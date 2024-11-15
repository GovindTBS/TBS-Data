codeunit 50141 "Citi Azure Triggers Mgt."
{
    Access = Internal;
    procedure DecryptAndVerify(EncryptedPayload: Text; Format: Text): Text
    var
        CitiBankAPISetup: Record "Citi Bank API Setup";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        Error: ErrorInfo;
        JsonRequest: Text;
        JsonResponse: Text;
    begin
        CitiBankAPISetup.Get();
        EncryptedPayload := EncryptedPayload.Replace('"', '\"');
        EncryptedPayload := EncryptedPayload.Remove(1, EncryptedPayload.IndexOfAny('>'));
        EncryptedPayload := EncryptedPayload.TrimStart();
        JsonRequest := '{"encryptedPayload": "' + EncryptedPayload + '", "mode": "' + Format + '" }';

        RequestContent.WriteFrom(JsonRequest);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/json');

        RequestMessage.Method('GET');
        RequestMessage.Content(RequestContent);
        RequestMessage.SetRequestUri(CitiBankAPISetup."Decrypt And Verify URL");
        Client.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then begin
            Error := ErrorInfo.Create(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
            Error(Error);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);
        exit(JsonResponse);
    end;

    procedure EncryptAndSign(Payload: Text; Format: Code[4]): Text
    var
        CitiBankAPISetup: Record "Citi Bank API Setup";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        Error: ErrorInfo;
        JsonRequest: Text;
        JsonResponse: Text;
    begin
        CitiBankAPISetup.Get();
        Payload := Payload.Replace('"', '\"');
        JsonRequest := '{"payload": "' + Payload + '", "mode": "' + Format + '"}';

        RequestContent.WriteFrom(JsonRequest);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/json');

        RequestMessage.Method('GET');
        RequestMessage.Content(RequestContent);
        RequestMessage.SetRequestUri(CitiBankAPISetup."Sign And Encrypt URL");
        Client.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then begin
            Error := ErrorInfo.Create(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
            Error(Error);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);
        exit(JsonResponse);
    end;

    var
        RequestErrLbl: Label 'The azure requested responded with %1 status code and the reason is %2', Comment = '%1= Status code , %2= reason ';
}