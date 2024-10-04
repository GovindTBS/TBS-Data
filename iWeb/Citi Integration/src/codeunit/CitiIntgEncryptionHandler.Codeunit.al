//! Test (Static)
codeunit 50141 "Citi Intg Encryption Handler"
{
    procedure DecryptAndVerify(encryptedPayload: Text; Mode: Text): Text
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpRequestMessage: HttpRequestMessage;
        HttpContent: HttpContent;
        JsonRequest: Text;
        JsonResponse: Text;
    begin
        JsonRequest := '{"encryptedPayload": "' + encryptedPayload + '", "mode": "' + Mode + '" }';

        HttpContent.WriteFrom(JsonRequest);
        HttpRequestMessage.Content(HttpContent);
        HttpRequestMessage.SetRequestUri('https://cryptfunctions.azurewebsites.net/api/DecryptAndVerify');
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content.ReadAs(JsonResponse);
            exit(JsonResponse);
        end else
            Error('Error: %1', HttpResponseMessage.HttpStatusCode());
    end;

    procedure EncryptAndSign(payload: Text; Mode: Code[4]): Text;
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        JsonRequest: Text;
        JsonResponse: Text;
    begin
        JsonRequest := '{"payload": "' + payload + '", "mode": "' + mode + '"}';

        RequestContent.WriteFrom(JsonRequest);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/json');

        RequestMessage.Method('GET');
        RequestMessage.Content(RequestContent);
        RequestMessage.SetRequestUri('https://cryptfunctions.azurewebsites.net/api/SignAndEncrypt');
        Client.Send(RequestMessage, ResponseMessage);

        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(JsonResponse);
            exit(JsonResponse);
        end else
            Error('Error: %1', ResponseMessage.HttpStatusCode());
    end;
}


