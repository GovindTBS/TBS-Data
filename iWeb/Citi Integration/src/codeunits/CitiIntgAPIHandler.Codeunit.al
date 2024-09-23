codeunit 50142 "Citi Intg API Handler"
{
    //!Demo
    // Procedure to obtain OAuth token
    procedure GetAuthToken(): Text
    var
        requestMessage: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        requestHeaders: HttpHeaders;
        contentHeaders: HttpHeaders;
        requestContent: HttpContent;
        jsonPayload: JsonObject;
        AcsToken: JsonToken;
        expiryDuration: JsonToken;
        requestBody: Text;
        responseBody: Text;
        URI: Text;
    begin

        URI := 'https://tts.sandbox.apib2b.citi.com/citiconnect/sb/authenticationservices/v3/oauth/token'; //? Dynam

        jsonPayload.Add('grantType', 'client_credentials');
        jsonPayload.Add('scope', '/authenticationservices/v1');
        jsonPayload.WriteTo(requestBody);

        //CitiIntgEncryptionHandler.SignPayload(requestBody);
        //CitiIntgEncryptionHandler.EncryptXmlElement(requestBody);

        requestMessage.GetHeaders(requestHeaders);
        requestHeaders.Add('Authorization', SecretStrSubstNo('Basic %1', GetEncodedClientSecret()));

        requestContent.WriteFrom(requestBody);
        requestContent.GetHeaders(contentHeaders);
        if contentHeaders.Contains('Content-Type') then
            contentHeaders.Remove('Content-Type');
        contentHeaders.Add('Content-Type', 'application/json');

        requestMessage.SetRequestUri(URI);
        requestMessage.Method('POST');
        requestMessage.Content(requestContent);

        //!Request
        //httpClient.Send(requestMessage, responseMessage);

        if not responseMessage.IsSuccessStatusCode() then
            HandleAuthError(responseMessage.HttpStatusCode(), responseMessage.ReasonPhrase());

        responseMessage.Content().ReadAs(responseBody);

        //CitiIntgEncryptionHandler.DecryptPayload(responseBody);
        //CitiIntgEncryptionHandler.VerifyXmlSignature(responseBody);
        responseBody := '{"token_type": "Bearer","access_token": "O0n8J+fXQr32nrmBI5let6iDqg5F1iMlocBhqwokdtU3d0C/gNKVPYnmxJYheps4YdnuIijt9E3LKYMEab+lP5M34yGNumBLQUUE8myVo40y3Tyo4d2j1cYYF9RGfpOVzAtb9VrhoMdJORJaIcIvTlRpcqCI/c0kV5t5mk0wmL7blWiTF0NW+w6Y57p4iikn0H+zMQ4zMmZiYI06t0VIH4yQrFw6N4tsoN1GD2A3/XKVVi5CO+I71aq0CaDlR/qEUfyZ6psyqqg94W54Eaq5m5Wp1uq5aQXK+A1II8zHNcARV/Iot3ZUGVYcPfvNEYZaANRbJcXhGepOwkDrRu/jYBguWm+/Vmvr3cIFaQ1bvhpCHxTAW7uJerWJzBE11RE0wv8HGsznQRUsbSq0woOa69Pe0Oym5qzeo9Ar139DIpp0hmeU5Ee8qWZBTalW5QdDIEhWdizlxK/1gvrOU8TK+AR/fI/2h3ApPUf+pT67gqh+EhWlEr0U2jM3EcJmL7aMVjZu9dswX79aGK7ss+JB3iEoC9tD/2cBRbHuitrqiRqp1Bd2L6w9bKx6tUQk+l9/KOX6h/5kOxlFc2z6CXpc1MVXlBQOSdJdj/2ILJ7UPCdmlzBG3q9WtJi1MaeNefUaQlNQUGpP017zLKxNIW5OtSJCneGeOjAxsdtZunO0LUS+2Z6OiiRxsYIZJMzmQ5dh4vGLzMFTH9bG74se1EuPHw==","expires_in": 1800,"scope": "/authenticationservices/v3"}';
        jsonPayload.ReadFrom(responseBody);

        if jsonPayload.Get('access_token', AcsToken) and jsonPayload.Get('expires_in', expiryDuration) then begin
            CitiIntgSetup.Get();
            CitiIntgSetup."Auth Token" := Format(AcsToken);
            CitiIntgSetup."Token Expires At" := GetExpiryTime(expiryDuration);
            CitiIntgSetup.Modify();
            Message('API token refreshed. Expires at %1', CitiIntgSetup."Token Expires At");
        end else
            Error('Invalid response: %1', responseBody);
    end;

    //!Demo
    //Procedure to initiate payment
    procedure InitiatePayment(var GenJnlLine: Record "Gen. Journal Line"): Text
    var
        Base64: Codeunit "Base64 Convert";
        HttpRequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        ContentHeader: HttpHeaders;
        Content: HttpContent;
        XmlPayload: Text;
        EncodedPayload: Text;
        URI: Text;
        ResponseText: Text;
        XMLDoc: XmlDocument;
        OrgnlMsgIdNode: XmlNode;
        PaymentRequestID: Text;
    begin
        CitiIntgSetup.Get();

        if CitiIntgSetup."Token Expires At" < DT2Time(CurrentDateTime) then
            GetAuthToken();
        AccessToken := CitiIntgSetup."Auth Token";

        URI := 'https://tts.sandbox.apib2b.citi.com/citiconnect/sb/paymentservices/v3/payment/initiation';

        XmlPayload := GetPaymentInitXMLPayload(GenJnlLine);

        // CitiIntgEncryptionHandler.SignXmlPayload(XmlPayload);
        // CitiIntgEncryptionHandler.EncryptXmlElement(XmlPayload);

        EncodedPayload := Base64.ToBase64(XmlPayload);

        XmlPayload := '<?xml version="1.0" encoding="UTF-8"?>' +
                      '<Request>' +
                      '<paymentBase64>' + EncodedPayload + '</paymentBase64>' +
                      '</Request>';

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
        // Client.Send(HttpRequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Payment initiation failed with status code %1: %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseText);

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


    local procedure GetEncodedClientSecret(): SecretText
    var
        CitiIntgSteup: Record "Citi Bank Intg. Setup";
        Base64: Codeunit "Base64 Convert";
        Base64Value: SecretText;
    begin
        CitiIntgSteup.Get();
        Base64Value := Base64.ToBase64(StrSubstNo('%1 : %2', CitiIntgSteup."Client ID", CitiIntgSteup."Client Secret"));
        exit(Base64Value);
    end;

    local procedure GetExpiryTime(ExpiryDuration: JsonToken): Time
    var
        Duration: Integer;
        ExpiryTime: Time;
        MinutesToAdd: Decimal;
        DurationToAdd: Duration;
    begin
        Evaluate(Duration, Format(ExpiryDuration));
        MinutesToAdd := Duration / 60;
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
        PaymentInitRequestPort: XmlPort "Citi Payment Init Request";
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

    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        AccessToken: Text;
}

