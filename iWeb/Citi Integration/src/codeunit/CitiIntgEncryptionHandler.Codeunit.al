codeunit 50141 "Citi Intg Encryption Handler"
{
    procedure DecryptAndVerify(encryptedPayload: Text; Mode: Text): Text
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        ErrorInf: ErrorInfo;
        JsonRequest: Text;
        JsonResponse: Text;
    begin
        encryptedPayload := encryptedPayload.Replace('"', '\"');
        encryptedPayload := encryptedPayload.Remove(1, encryptedPayload.IndexOfAny('>'));
        encryptedPayload := encryptedPayload.TrimStart();
        JsonRequest := '{"encryptedPayload": "' + encryptedPayload + '", "mode": "' + Mode + '" }';

        RequestContent.WriteFrom(JsonRequest);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/json');

        RequestMessage.Method('GET');
        RequestMessage.Content(RequestContent);
        RequestMessage.SetRequestUri('https://cryptfunctions.azurewebsites.net/api/DecryptAndVerify');
        Client.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then begin
            ErrorInf := ErrorInfo.Create(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
            Error(ErrorInf);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);
        exit(JsonResponse);
    end;

    procedure EncryptAndSign(payload: Text; mode: Code[4]): Text
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        ErrorInf: ErrorInfo;
        JsonRequest: Text;
        JsonResponse: Text;
    begin
        payload := payload.Replace('"', '\"');
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

        if not ResponseMessage.IsSuccessStatusCode() then begin
            ErrorInf := ErrorInfo.Create(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
            Error(ErrorInf);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);
        exit(JsonResponse);
    end;

    var
        RequestErrLbl: Label 'The azure requested responded with %1 status code and the reason is %2', Comment = '%1= Status code , %2= reason ';

}


