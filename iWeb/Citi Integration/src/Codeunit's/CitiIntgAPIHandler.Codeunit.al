codeunit 50142 "Citi Intg API Handler"
{
    // Procedure to obtain OAuth token
    procedure GetAuthToken(): Text
    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        CitiIntgEncryptionHandler: Codeunit "Citi Intg Encryption Handler";
        Client: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        RequestText: Text;
        ResponseText: Text;
        AccessToken: JsonToken;
        ExpiryDuration: JsonToken;
        RequestURI: Text;
    begin
        RequestURI := 'https://tts.sandbox.apib2b.citi.com/citiconnect/sb/authenticationservices/v3/oauth/token'; //?Dynam 

        JsonObject.Add('grantType', 'client_credentials');
        JsonObject.Add('scope', '/authenticationservices/v1');
        CitiIntgEncryptionHandler.SignXmlPayload(RequestText);
        CitiIntgEncryptionHandler.EncryptXmlElement(RequestText);

        JsonObject.WriteTo(RequestText);

        HttpContent.WriteFrom(RequestText);

        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Content-Type', 'application/json');
        RequestHeaders.Add('Authorization', 'Basic ' + StrSubstNo('%1', GetEncodedClientSecret()));

        HttpRequestMessage.SetRequestUri(RequestURI);
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content(HttpContent);

        Client.Send(HttpRequestMessage, HttpResponseMessage);

        if not HttpResponseMessage.IsSuccessStatusCode() then
            Error('Authentication failed with status code %1: %2', HttpResponseMessage.HttpStatusCode(), HttpResponseMessage.ReasonPhrase());

        HttpResponseMessage.Content().ReadAs(ResponseText);
        JsonObject.ReadFrom(ResponseText);

        CitiIntgEncryptionHandler.DecryptPayload(ResponseText);
        CitiIntgEncryptionHandler.VerifyXmlSignature(ResponseText);

        if JsonObject.Get('access_token', AccessToken) and JsonObject.Get('access_token', ExpiryDuration) then begin
            CitiIntgSetup."Auth Token" := Format(AccessToken);
            CitiIntgSetup."Token Expires At" := GetExpiryTime(ExpiryDuration);
            CitiIntgSetup.Modify();
        end else
            error('Failed to retrieve access token from response: %1', ResponseText);
    end;

    //Procedure to initiate payment
    procedure InitiatePayment(var GenJnlLine: Record "Gen. Journal Line")
    var
        CitiIntgEncryptionHandler: Codeunit "Citi Intg Encryption Handler";
        Base64: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        PaymentInitRequestPort: XmlPort "Citi Payment Init Request";
        Client: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        Content: HttpContent;
        XmlPayload: Text;
        EncodedPayload: Text;
        RequestURI: Text;
        ResponseText: Text;
        AccessToken: Text;
        OutputStream: OutStream;
        InputStream: InStream;
    begin
        RequestURI := 'https://tts.sit.apib2b.citi.com/citiconnect/sb/paymentinitiation/v3/payment/initiation';

        TempBlob.CreateOutStream(OutputStream);
        PaymentInitRequestPort.SetDestination(OutputStream);
        PaymentInitRequestPort.Export();
        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XmlPayload);

        CitiIntgEncryptionHandler.SignXmlPayload(XmlPayload);
        CitiIntgEncryptionHandler.EncryptXmlElement(XmlPayload);

        EncodedPayload := Base64.ToBase64(XmlPayload);

        XmlPayload := '<?xml version="1.0" encoding="UTF-8"?>' +
                      '<Request>' +
                      '<paymentBase64>' + EncodedPayload + '</paymentBase64>' +
                      '</Request>';

        AccessToken := GetAuthToken();

        Content.WriteFrom(XmlPayload);
        Content.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Content-Type', 'application/xml');
        RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
        RequestHeaders.Add('payloadType', 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03');

        HttpRequestMessage.SetRequestUri(RequestURI);
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content(Content);

        Client.Send(HttpRequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Payment initiation failed with status code %1: %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseText);

    end;

    //Payment Status enquiry
    procedure SendEnhancedPaymentStatusInquiry(Token: Text; RequestBody: Text): Text
    var
        Client: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        Content: HttpContent;
        ResponseText: Text;
        Url: Text;
    begin
        Url := 'https://tts.apib2b.citi.com/citiconnect/prod/paymentservices/v3/payment/enhancedinquiry';

        Content.WriteFrom(RequestBody);
        Content.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Content-Type', 'application/xml; format=PACX10');
        RequestHeaders.Add('Accept', 'application/xml; format=PSRX03');

        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.Content(Content);

        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Bearer ' + Token);

        Client.Send(HttpRequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Failed to inquire payment status. Status code: %1 - %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    procedure InitiateStatement(AccountNumber: Text[20]; FromDate: Date; ToDate: Date; OAuthToken: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpRequestHeader: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        RequestContent: Text;
        ResponseContent: Text;
    begin
        RequestContent := '<?xml version="1.0" encoding="UTF-8"?>' +
                          '<statementInitiationRequest xmlns="http://com.citi.citiconnect/services/types/inquiries/statement/v1">' +
                          '<accountNumber>' + AccountNumber + '</accountNumber>' +
                          '<formatName>CAMT_053_001_02</formatName>' +
                          '<fromDate>' + Format(FromDate, 0, '<Year4>-<Month,2>-<Day,2>') + '</fromDate>' +
                          '<toDate>' + Format(ToDate, 0, '<Year4>-<Month,2>-<Day,2>') + '</toDate>' +
                          '</statementInitiationRequest>';

        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri('https://tts.sandbox.apib2b.citi.com/citiconnect/sb/accountstatementservices/v1/statement/initiation');
        HttpRequestMessage.Content().WriteFrom(RequestContent);
        HttpRequestMessage.GetHeaders(HttpRequestHeader);
        HttpRequestHeader.Add('Content-Type', 'application/xml');
        HttpRequestHeader.Add('Authorization', 'Bearer ' + OAuthToken);

        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(ResponseContent);

    end;

    local procedure GetEncodedClientSecret(): Text
    begin
        //! code
        exit('');
    end;

    local procedure GetExpiryTime(ExpiryDuration: JsonToken): Time
    var
        Duration: Integer;
        ExpiryTime: Time;
    begin
        Evaluate(Duration, Format(ExpiryDuration));
        ExpiryTime := DT2Time(CurrentDateTime) + Duration;
        exit(ExpiryTime);
    end;

}

