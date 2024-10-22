codeunit 50141 "Isabel Bank Statement API Mgt."
{
    procedure GetAccountInformationAndStatement(FromDate: DateTime; ToDate: DateTime)
    var
        AccountStatementID: Text;
    begin
        PostAccountingOfficeConsent();

        AccountStatementID := DocumentSearch(FromDate, ToDate);
    end;    


    local procedure DocumentSearch(FromDate: DateTime; ToDate: DateTime): Text
    var
        Isabel6Setup: Record "Isabel6 Setup";
        Isabel6PaymentAPIMgt: Codeunit "Isabel Payment API Mgt.";
        Base64Convert: Codeunit "Base64 Convert";
        InputStream: InStream;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        RequestHeader: HttpHeaders;
        ContentHeader: HttpHeaders;
        Certificate: Text;
        ResponseBody: Text;
        JsonPayload: Text;
        URI: Text;
        JsonResponse: JsonObject;
        ResponseData: JsonToken;
    begin
        Isabel6PaymentAPIMgt.GetAuthToken();
        Isabel6Setup.Get();
        Isabel6Setup.CalcFields("SSL Certificate Value");
        Isabel6Setup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        JsonPayload := GetDocumentSearchPayload(FromDate, ToDate);
        URI := Isabel6Setup."Document Search Endpoint";

        RequestContent.WriteFrom(JsonPayload);
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6Setup."Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.api+json');
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Accept', 'application/vnd.api+json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, Isabel6Setup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));

        JsonResponse.ReadFrom(ResponseBody);
        JsonResponse.Get('data', ResponseData);
    end;

    local procedure PostAccountingOfficeConsent()
    var
        Isabel6Setup: Record "Isabel6 Setup";
        Isabel6PaymentAPIMgt: Codeunit "Isabel Payment API Mgt.";
        Base64Convert: Codeunit "Base64 Convert";
        InputStream: InStream;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        RequestHeader: HttpHeaders;
        ContentHeader: HttpHeaders;
        Certificate: Text;
        ResponseBody: Text;
        JsonPayload: Text;
        URI: Text;
        JsonResponse: JsonObject;
        ResponseData: JsonToken;
        ResponseAttributes: JsonToken;
        AccountingOfficeID: JsonToken;
        ConsentStatus: JsonToken;
    begin
        Isabel6PaymentAPIMgt.GetAuthToken();
        Isabel6Setup.Get();
        Isabel6Setup.CalcFields("SSL Certificate Value");
        Isabel6Setup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        JsonPayload := GetAccountingOfficeConsentPayload();
        URI := Isabel6Setup."Accounting Office Endpoint";

        RequestContent.WriteFrom(JsonPayload);
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6Setup."Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.api+json');

        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Accept', 'application/vnd.api+json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, Isabel6Setup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));

        JsonResponse.ReadFrom(ResponseBody);
        JsonResponse.Get('data', ResponseData);
        ResponseData.AsObject().Get('attributes', ResponseAttributes);
        if ResponseAttributes.AsObject().Get('accountingOfficeId', AccountingOfficeID) and ResponseAttributes.AsObject().Get('status', ConsentStatus) then
            case ConsentStatus.AsValue().AsText() of
                'unconfirmed':
                    repeat
                        GetPostAccountingOfficeConsentStatus(AccountingOfficeID.AsValue().AsText());
                    until GetPostAccountingOfficeConsentStatus(AccountingOfficeID.AsValue().AsText());
                'denied':
                    PostAccountingOfficeConsent();
            end;
        Isabel6Setup."Accounting Office ID" := format(AccountingOfficeID.AsValue().AsText());
        Isabel6Setup.Modify();
    end;

    local procedure GetAccountingOfficeConsentPayload(): Text
    var
        Isabel6Setup: Record "Isabel6 Setup";
        JsonObject: JsonObject;
        DataObject: JsonObject;
        AttributesObject: JsonObject;
        JsonText: Text;
    begin
        AttributesObject.Add('accountingOfficeCompanyNumber', Isabel6Setup."Accounting Office Company No.");
        DataObject.Add('type', 'accountingOfficeConsent');
        DataObject.Add('attributes', AttributesObject);
        JsonObject.Add('data', DataObject);
        JsonObject.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure GetDocumentSearchPayload(FromDate: DateTime; ToDate: DateTime): Text
    var
        Isabel6Setup: Record "Isabel6 Setup";
        JsonObject: JsonObject;
        DataObject: JsonObject;
        AttributesObject: JsonObject;
        RelationshipsObject: JsonObject;
        ClientsObject: JsonObject;
        ClientsDataArray: JsonArray;
        ClientDataObject: JsonObject;
        JsonText: Text;
    begin
        Isabel6Setup.Get();
        AttributesObject.Add('documentType', 'bankAccountStatement');
        AttributesObject.Add('from', Format(FromDate, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>.<MilliSeconds,3>Z'));
        AttributesObject.Add('to', Format(ToDate, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>.<MilliSeconds,3>Z'));
        ClientDataObject.Add('type', 'client');
        ClientDataObject.Add('id', Isabel6Setup."Client ID");
        ClientsDataArray.Add(ClientDataObject);
        ClientsObject.Add('data', ClientsDataArray);
        RelationshipsObject.Add('clients', ClientsObject);
        DataObject.Add('type', 'documentSearch');
        DataObject.Add('attributes', AttributesObject);
        DataObject.Add('relationships', RelationshipsObject);
        JsonObject.Add('data', DataObject);
        JsonObject.WriteTo(JsonText);
        exit(JsonText);
    end;


    local procedure GetPostAccountingOfficeConsentStatus(AccountingOfficeID: Text): Boolean
    var
        Isabel6Setup: Record "Isabel6 Setup";
        Isabel6PaymentAPIMgt: Codeunit "Isabel Payment API Mgt.";
        Base64Convert: Codeunit "Base64 Convert";
        InputStream: InStream;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        RequestHeader: HttpHeaders;
        Certificate: Text;
        ResponseBody: Text;
        JsonPayload: Text;
        URI: Text;
        JsonResponse: JsonObject;
        ResponseData: JsonToken;
        ResponseAttributes: JsonToken;
        ConsentStatus: JsonToken;
    begin
        Isabel6PaymentAPIMgt.GetAuthToken();
        Isabel6Setup.Get();
        Isabel6Setup.CalcFields("SSL Certificate Value");
        Isabel6Setup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        JsonPayload := GetAccountingOfficeConsentPayload();
        URI := StrSubstNo('%1/%2', Isabel6Setup."Accounting Office Endpoint", AccountingOfficeID);

        RequestContent.WriteFrom(JsonPayload);
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6Setup."Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.api+json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('GET');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, Isabel6Setup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));

        JsonResponse.ReadFrom(ResponseBody);
        JsonResponse.Get('data', ResponseData);
        ResponseData.AsObject().Get('attributes', ResponseAttributes);
        if ResponseAttributes.AsObject().Get('status', ConsentStatus) then
            case ConsentStatus.AsValue().AsText() of
                'unconfirmed':
                    exit(false);
                'denied':
                    PostAccountingOfficeConsent();
                'confirmed':
                    exit(true);
            end;
    end;

    var
        RequestErrLbl: Label 'The requested responded with %1 status code and the reason is %2', Comment = '%1= , %2= ';

}