codeunit 50142 "Citi Intg API Handler"
{
    Permissions = tabledata "Citi Bank Intg. Keys" = RIMD,
    tabledata "Citi Bank Intg. Setup" = RIMD;


    procedure GetAuthToken(var CitiIntgSetup: Record "Citi Bank Intg. Setup"): Text
    var
        CitiIntgKey: Record "Citi Bank Intg. Keys";
        CitiEncrytionHandler: Codeunit "Citi Intg Encryption Handler";
        Base64: Codeunit "Base64 Convert";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        RequestHeader: HttpHeaders;
        AcsToken: JsonToken;
        JsonPayload: JsonObject;
        ExpiryDuration: JsonToken;
        AcsTokenString: JsonToken;
        URI: Text;
        PemCert: Text;
        ResponseBody: Text;
        JsonPayloadText: Text;
        EncryptPayloadString: Text;
        Inputstream: InStream;
    begin
        CitiIntgKey.Get(CitiIntgKey."Certificate Name"::"Client TLS Certificate (PFX)");
        CitiIntgKey.CalcFields(Value);
        CitiIntgKey.Value.CreateInStream(Inputstream);
        PemCert := Base64.ToBase64(Inputstream);

        URI := CitiIntgSetup."Auth Token Endpoint";

        JsonPayloadText := GetAuthTokenJsonPayload();
        EncryptPayloadString := CitiEncrytionHandler.EncryptAndSign(JsonPayloadText, 'json');

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', SecretStrSubstNo('Basic %1', GetEncodedClientSecret()));
        RequestContent.WriteFrom(EncryptPayloadString);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(PemCert, CitiIntgKey.Password);
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then begin
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
            exit;
        end;

        ResponseBody := CitiEncrytionHandler.DecryptAndVerify(ResponseBody, 'json');
        JsonPayload.ReadFrom(ResponseBody);
        JsonPayload.Get('token', AcsTokenString);


        if AcsTokenString.AsObject().Get('access_token', AcsToken) and AcsTokenString.AsObject().Get('expires_in', ExpiryDuration) then begin
            CitiIntgSetup."Auth Token" := '';
            CitiIntgSetup."Auth Token" := Format(AcsToken.AsValue().AsText());
            CitiIntgSetup."Token Expires At" := GetExpiryDateTime(ExpiryDuration.AsValue().AsInteger());
            CitiIntgSetup.Modify(false);
            Message('API token refreshed. Expires at %1', CitiIntgSetup."Token Expires At");
        end;
    end;

    procedure InitiatePayment(var GenJnlLine: Record "Gen. Journal Line"): Text
    var
        CitiIntegrationKey: Record "Citi Bank Intg. Keys";
        CitiIntegrationSetup: Record "Citi Bank Intg. Setup";
        Base64Converter: Codeunit "Base64 Convert";
        TypeHelper: Codeunit "Type Helper";
        EncryptionHandler: Codeunit "Citi Intg Encryption Handler";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        RequestHeader: HttpHeaders;
        XmlPayload: Text;
        RequestUri: Text;
        ResponseContent: Text;
        PaymentRequestId: Text;
        InputStream: InStream;
        PemCertificate: Text;
        AuthToken: Text;
    begin
        CitiIntegrationKey.Get(CitiIntegrationKey."Certificate Name"::"Client TLS Certificate (PFX)");
        CitiIntegrationKey.CalcFields(Value);
        CitiIntegrationKey.Value.CreateInStream(InputStream);
        PemCertificate := Base64Converter.ToBase64(InputStream);

        CitiIntegrationSetup.Get();
        if TypeHelper.CompareDateTime(CitiIntegrationSetup."Token Expires At", CurrentDateTime) <> 1 then
            GetAuthToken(CitiIntegrationSetup);
        AuthToken := CitiIntegrationSetup."Auth Token";

        RequestUri := StrSubstNo(EncodedUriLbl, CitiIntegrationSetup."Payment Initiation Endpoint", CitiIntegrationSetup."Client ID");

        // XmlPayload := GetPaymentInitXMLPayload(GenJnlLine); //?
        XmlPayload := '<?xml version="1.0" encoding="UTF-8" standalone="no"?><Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CstmrCdtTrfInitn><GrpHdr><MsgId>A1234567</MsgId><CreDtTm>2017-07-17T04:59:18</CreDtTm><NbOfTxs>1</NbOfTxs><InitgPty><Nm>ABC COMPANY NAME</Nm></InitgPty></GrpHdr><PmtInf><PmtInfId>A1234567</PmtInfId><PmtMtd>CHK</PmtMtd><PmtTpInf><SvcLvl><Cd>NURG</Cd></SvcLvl><LclInstrm><Prtry>CITI19</Prtry></LclInstrm></PmtTpInf><ReqdExctnDt>2017-07-17</ReqdExctnDt><Dbtr><Nm>ABC COMPANY NAME</Nm><PstlAdr><Ctry>US</Ctry></PstlAdr><Id><OrgId><Othr><Id>1123456789</Id></Othr></OrgId></Id></Dbtr><DbtrAcct><Id><Othr><Id>93000001</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId><BIC>CITIUS33XXX</BIC><ClrSysMmbId><MmbId>021000089</MmbId></ClrSysMmbId></FinInstnId></DbtrAgt><CdtTrfTxInf><PmtId><EndToEndId>123456</EndToEndId></PmtId><Amt><InstdAmt Ccy="USD">1000.00</InstdAmt></Amt><ChqInstr><ChqNb>98765421</ChqNb><DlvrTo><Nm>Receiver Name</Nm><Adr><PstCd>22222</PstCd><TwnNm>Receiver City</TwnNm><CtrySubDvsn>NY</CtrySubDvsn><Ctry>US</Ctry><AdrLine>123,STREET NAME</AdrLine></Adr></DlvrTo></ChqInstr><Cdtr><Nm>BENEFICIARY NAME</Nm><PstlAdr><PstCd>11111</PstCd><TwnNm>CITY NAME</TwnNm><CtrySubDvsn>IL</CtrySubDvsn><Ctry>US</Ctry><AdrLine>123, STREET NAME</AdrLine></PstlAdr></Cdtr><RltdRmtInf><RmtLctnPstlAdr><Nm/><Adr><PstCd>22222</PstCd><TwnNm>Receiver City</TwnNm><CtrySubDvsn>NY</CtrySubDvsn></Adr></RmtLctnPstlAdr></RltdRmtInf><RmtInf><Strd><RfrdDocInf><Tp><CdOrPrtry><Cd>CINV</Cd></CdOrPrtry></Tp><Nb>INV#123</Nb><RltdDt>2017-07-17</RltdDt></RfrdDocInf><RfrdDocAmt><DuePyblAmt Ccy="USD">1000.00</DuePyblAmt><DscntApldAmt Ccy="USD">0.00</DscntApldAmt><RmtdAmt Ccy="USD">1000.00</RmtdAmt></RfrdDocAmt><AddtlRmtInf>payment for invoice 123</AddtlRmtInf></Strd></RmtInf></CdtTrfTxInf></PmtInf></CstmrCdtTrfInitn></Document>';
        XmlPayload := EncryptionHandler.EncryptAndSign(XmlPayload, 'xml');

        RequestContent.WriteFrom(XmlPayload);
        RequestMessage.SetRequestUri(RequestUri);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + AuthToken);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/xml');
        ContentHeader.Add('payloadType', 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03');

        RequestMessage.Content(RequestContent);
        Client.AddCertificate(PemCertificate, CitiIntegrationKey.Password);
        Client.Send(RequestMessage, ResponseMessage);

        // if not HttpResponse.IsSuccessStatusCode() then begin
        //     Message(StrSubstNo(RequestErrLbl, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase()));
        //     exit;
        // end;

        ResponseMessage.Content().ReadAs(ResponseContent);
        ResponseContent := EncryptionHandler.DecryptAndVerify(ResponseContent, 'xml');

        PaymentRequestId := ParsePaymentInitiationResponse(ResponseContent);
        exit(PaymentRequestId);
    end;

    local procedure ParsePaymentInitiationResponse(ResponseContent: Text): Text
    var
        Base64Converter: Codeunit "Base64 Convert";
        XmlDoc: XmlDocument;
        Base64Node: XmlNode;
        OriginalMessageIdNode: XmlNode;
        Base64Text: Text;
        Base64Xml: Text;
    begin
        XmlDocument.ReadFrom(ResponseContent, XmlDoc);
        if XmlDoc.SelectSingleNode('/*[local-name()="paymentInitiationResponse"]/*[local-name()="psrDocument"]', Base64Node) then
            Base64Text := Base64Node.AsXmlElement().InnerText()
        else
            exit('Error: psrDocument not found');

        Base64Xml := Base64Converter.FromBase64(Base64Text);
        XmlDocument.ReadFrom(Base64Xml, XmlDoc);
        if XmlDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="OrgnlEndToEndId"]', OriginalMessageIdNode) then
            exit(OriginalMessageIdNode.AsXmlElement().InnerText())
        else
            exit('Error: Original Payment Request ID not found');
    end;

    procedure SendEnhancedPaymentStatusInquiry(var GenJnlLine: Record "Gen. Journal Line"): Text
    var
        CitiIntegrationSetup: Record "Citi Bank Intg. Setup";
        CitiIntegrationKey: Record "Citi Bank Intg. Keys";
        TypeHelper: Codeunit "Type Helper";
        Base64Converter: Codeunit "Base64 Convert";
        EncryptionHandler: Codeunit "Citi Intg Encryption Handler";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        RequestHeader: HttpHeaders;
        ResponseText: Text;
        PemCertificate: Text;
        RequestUri: Text;
        XmlPayload: Text;
        XMLDoc: XmlDocument;
        OrgnlMsgIdNode: XmlNode;
        PaymentTxtStatus: Text;
        AuthToken: Text;
        InputStream: InStream;
    begin
        CitiIntegrationKey.Get(CitiIntegrationKey."Certificate Name"::"Client TLS Certificate (PFX)");
        CitiIntegrationKey.CalcFields(Value);
        CitiIntegrationKey.Value.CreateInStream(InputStream);
        PemCertificate := Base64Converter.ToBase64(InputStream);

        CitiIntegrationSetup.Get();
        if TypeHelper.CompareDateTime(CitiIntegrationSetup."Token Expires At", CurrentDateTime) = -1 then
            GetAuthToken(CitiIntegrationSetup);
        AuthToken := CitiIntegrationSetup."Auth Token";

        RequestUri := StrSubstNo(EncodedUriLbl, CitiIntegrationSetup."Payment Status Endpoint", CitiIntegrationSetup."Client ID");

        XmlPayload := GetPaymentStatusPayload(GenJnlLine); //?
        XmlPayload := '<?xml version="1.0" encoding="UTF-8" standalone="no"?><Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CstmrCdtTrfInitn><GrpHdr><MsgId>A1234567</MsgId><CreDtTm>2017-07-17T04:59:18</CreDtTm><NbOfTxs>1</NbOfTxs><InitgPty><Nm>ABC COMPANY NAME</Nm></InitgPty></GrpHdr><PmtInf><PmtInfId>A1234567</PmtInfId><PmtMtd>CHK</PmtMtd><PmtTpInf><SvcLvl><Cd>NURG</Cd></SvcLvl><LclInstrm><Prtry>CITI19</Prtry></LclInstrm></PmtTpInf><ReqdExctnDt>2017-07-17</ReqdExctnDt><Dbtr><Nm>ABC COMPANY NAME</Nm><PstlAdr><Ctry>US</Ctry></PstlAdr><Id><OrgId><Othr><Id>1123456789</Id></Othr></OrgId></Id></Dbtr><DbtrAcct><Id><Othr><Id>93000001</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId><BIC>CITIUS33XXX</BIC><ClrSysMmbId><MmbId>021000089</MmbId></ClrSysMmbId></FinInstnId></DbtrAgt><CdtTrfTxInf><PmtId><EndToEndId>123456</EndToEndId></PmtId><Amt><InstdAmt Ccy="USD">1000.00</InstdAmt></Amt><ChqInstr><ChqNb>98765421</ChqNb><DlvrTo><Nm>Receiver Name</Nm><Adr><PstCd>22222</PstCd><TwnNm>Receiver City</TwnNm><CtrySubDvsn>NY</CtrySubDvsn><Ctry>US</Ctry><AdrLine>123,STREET NAME</AdrLine></Adr></DlvrTo></ChqInstr><Cdtr><Nm>BENEFICIARY NAME</Nm><PstlAdr><PstCd>11111</PstCd><TwnNm>CITY NAME</TwnNm><CtrySubDvsn>IL</CtrySubDvsn><Ctry>US</Ctry><AdrLine>123, STREET NAME</AdrLine></PstlAdr></Cdtr><RltdRmtInf><RmtLctnPstlAdr><Nm/><Adr><PstCd>22222</PstCd><TwnNm>Receiver City</TwnNm><CtrySubDvsn>NY</CtrySubDvsn></Adr></RmtLctnPstlAdr></RltdRmtInf><RmtInf><Strd><RfrdDocInf><Tp><CdOrPrtry><Cd>CINV</Cd></CdOrPrtry></Tp><Nb>INV#123</Nb><RltdDt>2017-07-17</RltdDt></RfrdDocInf><RfrdDocAmt><DuePyblAmt Ccy="USD">1000.00</DuePyblAmt><DscntApldAmt Ccy="USD">0.00</DscntApldAmt><RmtdAmt Ccy="USD">1000.00</RmtdAmt></RfrdDocAmt><AddtlRmtInf>payment for invoice 123</AddtlRmtInf></Strd></RmtInf></CdtTrfTxInf></PmtInf></CstmrCdtTrfInitn></Document>';
        XmlPayload := EncryptionHandler.EncryptAndSign(XmlPayload, 'xml');

        RequestContent.WriteFrom(XmlPayload);
        RequestMessage.SetRequestUri(RequestUri);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + AuthToken);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/xml');

        RequestMessage.Content(RequestContent);
        Client.AddCertificate(PemCertificate, CitiIntegrationKey.Password);
        Client.Send(RequestMessage, ResponseMessage);

        // if not HttpResponse.IsSuccessStatusCode() then begin
        //     Message(StrSubstNo(RequestErrLbl, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase()));
        //     exit;
        // end;

        ResponseMessage.Content().ReadAs(ResponseText);
        ResponseText := EncryptionHandler.DecryptAndVerify(ResponseText, 'xml');

        ResponseText := '<?xml version="1.0" encoding="UTF-8"?><Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.002.001.03"><CstmrPmtStsRpt><GrpHdr><MsgId>CITIBANK/20210311-PSR/981382059</MsgId><CreDtTm>2021-03-11T19:31:39</CreDtTm><InitgPty><Id><OrgId><BICOrBEI>CITIUS33</BICOrBEI></OrgId></Id></InitgPty></GrpHdr><OrgnlGrpInfAndSts><OrgnlMsgId>GBP161114694869</OrgnlMsgId><OrgnlMsgNmId>pain.001.001.03</OrgnlMsgNmId></OrgnlGrpInfAndSts><OrgnlPmtInfAndSts><OrgnlPmtInfId>14017498 Fund Transfer Domestic</OrgnlPmtInfId><TxInfAndSts><OrgnlEndToEndId>CC21TPH3B8J8H2R</OrgnlEndToEndId><TxSts>ACSP</TxSts><StsRsnInf><AddtlInf>Processed Settled at clearing System. Payment settled at clearing system</AddtlInf></StsRsnInf><OrgnlTxRef><Amt><InstdAmt Ccy="USD">1.00</InstdAmt></Amt><ReqdExctnDt>2021-02-03</ReqdExctnDt><PmtMtd>TRF</PmtMtd><RmtInf><Ustrd>TR002638</Ustrd></RmtInf><Dbtr><Nm>CITIBANK E-BUSINESS EUR DUM DEMO</Nm></Dbtr><DbtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId><PstlAdr><Ctry>GB</Ctry></PstlAdr></FinInstnId></DbtrAgt><CdtrAgt><FinInstnId><BIC>fakebic</BIC></FinInstnId></CdtrAgt><Cdtr><Nm>8010643122X XXXXXXXXXXXXX XXX</Nm></Cdtr><CdtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></CdtrAcct></OrgnlTxRef></TxInfAndSts></OrgnlPmtInfAndSts></CstmrPmtStsRpt></Document>';
        XmlDocument.ReadFrom(ResponseText, XMLDoc);
        if XMLDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="TxSts"]', OrgnlMsgIdNode) then
            PaymentTxtStatus := OrgnlMsgIdNode.AsXmlElement().InnerText
        else
            exit('Error: Status not found');

        exit(PaymentTxtStatus);
    end;

    local procedure GetEncodedClientSecret(): Text
    var
        CitiIntSetup: Record "Citi Bank Intg. Setup";
        Base64: Codeunit "Base64 Convert";
        Base64Value: Text;
    begin
        CitiIntSetup.Get();
        Base64Value := Base64.ToBase64(StrSubstNo('%1:%2', CitiIntSetup."Client ID", CitiIntSetup."Client Secret"), TextEncoding::UTF8);
        exit(Base64Value);
    end;

    local procedure GetExpiryDateTime(ExpiryDuration: Integer): DateTime
    var
        DurationToAdd: Duration;
        ExpiryDateTime: DateTime;
    begin
        DurationToAdd := ExpiryDuration * 1000;
        ExpiryDateTime := CreateDateTime(Today, DT2Time(CurrentDateTime()) + DurationToAdd);
        exit(ExpiryDateTime);
    end;

    local procedure GetAuthTokenJsonPayload(): Text
    var
        OAuthTokenObject: JsonObject;
        JsonPayload: JsonObject;
        PayloadString: Text;
    begin
        OAuthTokenObject.Add('grantType', 'client_credentials');
        OAuthTokenObject.Add('scope', '/authenticationservices/v1');
        JsonPayload.Add('oAuthToken', OAuthTokenObject);
        JsonPayload.WriteTo(PayloadString);
        exit(PayloadString);
    end;


    local procedure GetPaymentInitXMLPayload(GenJnlLine: Record "Gen. Journal Line"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        PaymentInitRequestPort: XmlPort "SEPA CT pain.001.001.03";
        OutputStream: OutStream;
        InputStream: InStream;
        XmlPayload: Text;
    begin
        TempBlob.CreateOutStream(OutputStream);
        PaymentInitRequestPort.SetDestination(OutputStream);
        PaymentInitRequestPort.SetTableView(GenJnlLine);
        PaymentInitRequestPort.Export();
        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XmlPayload);
        exit(XmlPayload);
    end;

    local procedure GetPaymentStatusPayload(GenJnlLine: Record "Gen. Journal Line"): Text
    var
        Declaration: XmlDeclaration;
        XmlDoc: XmlDocument;
        RootElement: XmlElement;
        EndToEndIdElement: XmlElement;
        EndToEndIdText: XmlText;
        XmlData: Text;
        XmlWriteOptions: XmlWriteOptions;
    begin
        // <?xml version="1.0" encoding="UTF-8"?>
        // <paymentInquiryRequest xmlns="http://com.citi.citiconnect/services/types/inquiries/payment/v1">
        //   <EndToEndId>CC21TPH3B8J8H2R</EndToEndId>
        // </paymentInquiryRequest>

        XmlDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'UTF-8', 'yes');

        XmlDoc.SetDeclaration(Declaration);

        RootElement := XmlElement.Create('paymentInquiryRequest');

        EndToEndIdElement := XmlElement.Create('EndToEndId');
        EndToEndIdText := XmlText.Create(GenJnlLine."Payment Request ID");
        EndToEndIdElement.Add(EndToEndIdText);

        RootElement.Add(EndToEndIdElement);
        XmlDoc.Add(RootElement);

        XmlWriteOptions.PreserveWhitespace(false);
        XmlDoc.WriteTo(XmlWriteOptions, XmlData);

        exit(XmlData);
    end;


    var
        RequestErrLbl: Label 'The requested responded with %1 status code and the reason is %2', Comment = '%1= , %2= ';
        EncodedUriLbl: Label '%1?client_id=%2', Comment = '%1 = URL, %2 = client ID';

}

