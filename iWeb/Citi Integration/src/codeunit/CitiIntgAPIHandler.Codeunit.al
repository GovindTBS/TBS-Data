codeunit 50142 "Citi Intg API Handler"
{
    Permissions = tabledata "Citi Bank Intg. Keys" = R,
                    tabledata "Citi Bank Intg. Setup" = RIMD;


    procedure GetAuthToken(): Text
    var
        CitiIntgKey: Record "Citi Bank Intg. Keys";
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        CitiEncrytionHandler: Codeunit "Citi Intg Encryption Handler";
        Base64: Codeunit "Base64 Convert";
        Client: HttpClient;
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        AcsToken: JsonToken;
        JsonPayload: JsonObject;
        ExpiryDuration: JsonToken;
        AcsTokenString: JsonToken;
        OAuthTokenObject: JsonObject;
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

        CitiIntgSetup.Get();
        URI := CitiIntgSetup."Auth Token Endpoint";

        OAuthTokenObject.Add('grantType', 'client_credentials');
        OAuthTokenObject.Add('scope', '/authenticationservices/v1');

        JsonPayload.Add('oAuthToken', OAuthTokenObject);
        JsonPayload.WriteTo(JsonPayloadText);
        JsonPayloadText := JsonPayloadText.Replace('"', '\"');
        EncryptPayloadString := CitiEncrytionHandler.EncryptAndSign(JsonPayloadText, 'json');

        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', SecretStrSubstNo('Basic %1', GetEncodedClientSecret()));
        RequestContent.WriteFrom(EncryptPayloadString);
        RequestContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(PemCert, CitiIntgKey.Password);
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            HandleAuthError(ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        ResponseBody := CitiEncrytionHandler.DecryptAndVerify(ResponseBody, 'json');
        JsonPayload.ReadFrom(ResponseBody);
        JsonPayload.Get('token', AcsTokenString);


        if AcsTokenString.AsObject().Get('access_token', AcsToken) and AcsTokenString.AsObject().Get('expires_in', ExpiryDuration) then begin
            CitiIntgSetup."Auth Token" := Format(AcsToken);
            CitiIntgSetup."Token Expires At" := GetExpiryTime(ExpiryDuration.AsValue().AsInteger());
            CitiIntgSetup.Modify(true);
            Message('API token refreshed. Expires at %1', CitiIntgSetup."Token Expires At");
        end;
    end;


    procedure InitiatePayment(var GenJnlLine: Record "Gen. Journal Line"): Text
    var
        CitiIntgKey: Record "Citi Bank Intg. Keys";
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        Base64: Codeunit "Base64 Convert";
        CitiIntgEncryptionHandler: Codeunit "Citi Intg Encryption Handler";
        HttpRequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        ContentHeader: HttpHeaders;
        Content: HttpContent;
        Client: HttpClient;
        XmlPayload: Text;
        URI: Text;
        ResponseText: Text;
        XMLDoc: XmlDocument;
        OrgnlMsgIdNode: XmlNode;
        PaymentRequestID: Text;
        InputStream: InStream;
        PemCert: Text;
        AccessToken: Text;
        EncodedURILbl: Label '%1?client_id=%2', Comment = '%1 = URL , %2 = clientid';
    begin
        CitiIntgKey.Get(CitiIntgKey."Certificate Name"::"Client TLS Certificate (PFX)");
        CitiIntgKey.CalcFields(Value);
        CitiIntgKey.Value.CreateInStream(InputStream);
        PemCert := Base64.ToBase64(InputStream);

        CitiIntgSetup.Get();
        Message('%1', CitiIntgSetup."Token Expires At");
        if CitiIntgSetup."Token Expires At" < DT2Time(CurrentDateTime) then
            GetAuthToken();
        AccessToken := CitiIntgSetup."Auth Token";

        URI := StrSubstNo(EncodedURILbl, CitiIntgSetup."Payment Initiation Endpoint", CitiIntgSetup."Client ID");

        // XmlPayload := GetPaymentInitXMLPayload(GenJnlLine);
        XmlPayload := XmlPayload.Replace('"', '\"');
        XmlPayload := '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><Document xmlns=\"urn:iso:std:iso:20022:tech:xsd:pain.001.001.03\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><CstmrCdtTrfInitn><GrpHdr><MsgId>A1234567</MsgId><CreDtTm>2017-07-17T04:59:18</CreDtTm><NbOfTxs>1</NbOfTxs><InitgPty><Nm>ABC COMPANY NAME</Nm></InitgPty></GrpHdr><PmtInf><PmtInfId>A1234567</PmtInfId><PmtMtd>CHK</PmtMtd><PmtTpInf><SvcLvl><Cd>NURG</Cd></SvcLvl><LclInstrm><Prtry>CITI19</Prtry></LclInstrm></PmtTpInf><ReqdExctnDt>2017-07-17</ReqdExctnDt><Dbtr><Nm>ABC COMPANY NAME</Nm><PstlAdr><Ctry>US</Ctry></PstlAdr><Id><OrgId><Othr><Id>1123456789</Id></Othr></OrgId></Id></Dbtr><DbtrAcct><Id><Othr><Id>93000001</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId><BIC>CITIUS33XXX</BIC><ClrSysMmbId><MmbId>021000089</MmbId></ClrSysMmbId></FinInstnId></DbtrAgt><CdtTrfTxInf><PmtId><EndToEndId>123456</EndToEndId></PmtId><Amt><InstdAmt Ccy=\"USD\">1000.00</InstdAmt></Amt><ChqInstr><ChqNb>98765421</ChqNb><DlvrTo><Nm>Receiver Name</Nm><Adr><PstCd>22222</PstCd><TwnNm>Receiver City</TwnNm><CtrySubDvsn>NY</CtrySubDvsn><Ctry>US</Ctry><AdrLine>123,STREET NAME</AdrLine></Adr></DlvrTo></ChqInstr><Cdtr><Nm>BENEFICIARY NAME</Nm><PstlAdr><PstCd>11111</PstCd><TwnNm>CITY NAME</TwnNm><CtrySubDvsn>IL</CtrySubDvsn><Ctry>US</Ctry><AdrLine>123, STREET NAME</AdrLine></PstlAdr></Cdtr><RltdRmtInf><RmtLctnPstlAdr><Nm/><Adr><PstCd>22222</PstCd><TwnNm>Receiver City</TwnNm><CtrySubDvsn>NY</CtrySubDvsn></Adr></RmtLctnPstlAdr></RltdRmtInf><RmtInf><Strd><RfrdDocInf><Tp><CdOrPrtry><Cd>CINV</Cd></CdOrPrtry></Tp><Nb>INV#123</Nb><RltdDt>2017-07-17</RltdDt></RfrdDocInf><RfrdDocAmt><DuePyblAmt Ccy=\"USD\">1000.00</DuePyblAmt><DscntApldAmt Ccy=\"USD\">0.00</DscntApldAmt><RmtdAmt Ccy=\"USD\">1000.00</RmtdAmt></RfrdDocAmt><AddtlRmtInf>payment for invoice 123</AddtlRmtInf></Strd></RmtInf></CdtTrfTxInf></PmtInf></CstmrCdtTrfInitn></Document>';
        XmlPayload := CitiIntgEncryptionHandler.EncryptAndSign(XmlPayload, 'xml');

        Content.WriteFrom(XmlPayload);
        Content.GetHeaders(ContentHeader);

        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/xml');
        ContentHeader.Add('payloadType', 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03');

        HttpRequestMessage.SetRequestUri(URI);
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

        //!Request
        Client.AddCertificate(PemCert, CitiIntgKey.Password);
        Client.Send(HttpRequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Payment initiation failed with status code %1: %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseText);
        Message(ResponseText);

        //CitiIntgEncryptionHandler.DecryptPayload(responseBody);
        //CitiIntgEncryptionHandler.VerifyXmlSignature(responseBody);

        ResponseText := '<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.002.001.03"><CstmrPmtStsRpt><GrpHdr><MsgId>CITIBANK/20210311-PSR/2015295291</MsgId><CreDtTm>2021-03-11T17:23:37</CreDtTm><InitgPty><Id><OrgId><BICOrBEI>CITIUS33</BICOrBEI></OrgId></Id></InitgPty></GrpHdr><OrgnlGrpInfAndSts><OrgnlMsgId>GBP161114694869</OrgnlMsgId><OrgnlMsgNmId>pain.001.001.03</OrgnlMsgNmId><OrgnlCreDtTm>2020-04-14T10:17:55</OrgnlCreDtTm><OrgnlNbOfTxs>1</OrgnlNbOfTxs><NbOfTxsPerSts><DtldNbOfTxs>1</DtldNbOfTxs><DtldSts>PDNG</DtldSts></NbOfTxsPerSts></OrgnlGrpInfAndSts><OrgnlPmtInfAndSts><OrgnlPmtInfId>14017498 Fund Transfer Domestic</OrgnlPmtInfId><TxInfAndSts><OrgnlEndToEndId>85HO54TIEH545BB</OrgnlEndToEndId><TxSts>PDNG</TxSts><StsRsnInf><AddtlInf>Payment validation is in-progress</AddtlInf></StsRsnInf><OrgnlTxRef><Amt><InstdAmt Ccy="USD">1.00</InstdAmt></Amt><ReqdExctnDt>2020-04-14</ReqdExctnDt><PmtTpInf><SvcLvl><Cd>URGP</Cd></SvcLvl></PmtTpInf><PmtMtd>TRF</PmtMtd><RmtInf><Strd><AddtlRmtInf>UETR/185fa5eb-86dd-4471-b238-7bba906bfa2c/SvcTpIdr/003</AddtlRmtInf></Strd></RmtInf><Dbtr><Nm>CITIBANK E-BUSINESS EUR DUM DEMO</Nm></Dbtr><DbtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId><BIC>fakebic</BIC><PstlAdr><Ctry>GB</Ctry></PstlAdr></FinInstnId></DbtrAgt><CdtrAgt><FinInstnId><BIC>fakebic</BIC></FinInstnId></CdtrAgt><Cdtr><Nm>8010643122X XXXXXXXXXXXXX XXX</Nm><CtctDtls><Nm>creditordetails</Nm></CtctDtls></Cdtr><CdtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></CdtrAcct></OrgnlTxRef></TxInfAndSts></OrgnlPmtInfAndSts></CstmrPmtStsRpt></Document>';

        XmlDocument.ReadFrom(ResponseText, XMLDoc);
        XMLDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="OrgnlEndToEndId"]', OrgnlMsgIdNode);
        if not OrgnlMsgIdNode.AsXmlElement().IsEmpty then
            PaymentRequestID := OrgnlMsgIdNode.AsXmlElement().InnerText;

        exit(PaymentRequestID);
    end;

    //!Demo
    //Payment Status enquiry
    procedure SendEnhancedPaymentStatusInquiry(var GenJnlLine: Record "Gen. Journal Line"): Text
    var
        CitiIntgKey: Record "Citi Bank Intg. Keys";
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        HttpRequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        ContentHeader: HttpHeaders;
        Content: HttpContent;
        ResponseText: Text;
        URI: Text;
        XmlPayload: Text;
        XMLDoc: XmlDocument;
        OrgnlMsgIdNode: XmlNode;
        PaymentTxtStatus: Text;
        AccessToken: Text;
    begin
        CitiIntgSetup.Get();

        if CitiIntgSetup."Token Expires At" < DT2Time(CurrentDateTime) then
            GetAuthToken();
        AccessToken := CitiIntgSetup."Auth Token";

        URI := 'https://tts.apib2b.citi.com/citiconnect/prod/paymentservices/v3/payment/enhancedinquiry';


        XmlPayload := GetPaymentStatusPayload(GenJnlLine);

        // CitiIntgEncryptionHandler.SignXmlPayload(XmlPayload);
        // CitiIntgEncryptionHandler.EncryptXmlElement(XmlPayload);

        Content.WriteFrom(XmlPayload);
        Content.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/xml');

        HttpRequestMessage.SetRequestUri(URI);
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content(Content);

        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

        //!Request
        // Client.Send(HttpRequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Failed to inquire payment status. Status code: %1 - %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseText);

        ResponseText := '<?xml version="1.0" encoding="UTF-8"?><Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.002.001.03"><CstmrPmtStsRpt><GrpHdr><MsgId>CITIBANK/20210311-PSR/981382059</MsgId><CreDtTm>2021-03-11T19:31:39</CreDtTm><InitgPty><Id><OrgId><BICOrBEI>CITIUS33</BICOrBEI></OrgId></Id></InitgPty></GrpHdr><OrgnlGrpInfAndSts><OrgnlMsgId>GBP161114694869</OrgnlMsgId><OrgnlMsgNmId>pain.001.001.03</OrgnlMsgNmId></OrgnlGrpInfAndSts><OrgnlPmtInfAndSts><OrgnlPmtInfId>14017498 Fund Transfer Domestic</OrgnlPmtInfId><TxInfAndSts><OrgnlEndToEndId>CC21TPH3B8J8H2R</OrgnlEndToEndId><TxSts>ACSP</TxSts><StsRsnInf><AddtlInf>Processed Settled at clearing System. Payment settled at clearing system</AddtlInf></StsRsnInf><OrgnlTxRef><Amt><InstdAmt Ccy="USD">1.00</InstdAmt></Amt><ReqdExctnDt>2021-02-03</ReqdExctnDt><PmtMtd>TRF</PmtMtd><RmtInf><Ustrd>TR002638</Ustrd></RmtInf><Dbtr><Nm>CITIBANK E-BUSINESS EUR DUM DEMO</Nm></Dbtr><DbtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId><PstlAdr><Ctry>GB</Ctry></PstlAdr></FinInstnId></DbtrAgt><CdtrAgt><FinInstnId><BIC>fakebic</BIC></FinInstnId></CdtrAgt><Cdtr><Nm>8010643122X XXXXXXXXXXXXX XXX</Nm></Cdtr><CdtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></CdtrAcct></OrgnlTxRef></TxInfAndSts></OrgnlPmtInfAndSts></CstmrPmtStsRpt></Document>';
        XmlDocument.ReadFrom(ResponseText, XMLDoc);
        XMLDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="TxSts"]', OrgnlMsgIdNode);
        if not OrgnlMsgIdNode.AsXmlElement().IsEmpty then
            PaymentTxtStatus := OrgnlMsgIdNode.AsXmlElement().InnerText;

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

    local procedure GetExpiryTime(ExpiryDuration: Integer): Time
    var
        ExpiryTime: Time;
        MinutesToAdd: Decimal;
        DurationToAdd: Duration;
    begin
        MinutesToAdd := ExpiryDuration / 60;
        DurationToAdd := MinutesToAdd * 60000;
        ExpiryTime := DT2Time(CurrentDateTime) + DurationToAdd;
        exit(ExpiryTime);
    end;

    local procedure HandleAuthError(httpStatusCode: Integer; reasonPhrase: Text)
    begin
        Error('Authentication failed with status code %1: %2', httpStatusCode, reasonPhrase);
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
        XmlDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'UTF-8', 'yes');

        XmlDoc.SetDeclaration(Declaration);

        RootElement := XmlElement.Create('paymentInquiryRequest');
        // RootElement.SetAttribute('xmlns', 'http://com.citi.citiconnect/services/types/inquiries/payment/v1');

        EndToEndIdElement := XmlElement.Create('EndToEndId');
        EndToEndIdText := XmlText.Create(GenJnlLine."Payment Request ID");
        EndToEndIdElement.Add(EndToEndIdText);

        RootElement.Add(EndToEndIdElement);
        XmlDoc.Add(RootElement);

        XmlWriteOptions.PreserveWhitespace(true);
        XmlDoc.WriteTo(XmlWriteOptions, XmlData);

        exit(XmlData);
    end;
}

