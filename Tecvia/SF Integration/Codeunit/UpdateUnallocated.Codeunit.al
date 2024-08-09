codeunit 50103 "Update Unallocated"
{
    SingleInstance = true;
    TableNo = "Cust. Ledger Entry";

    trigger OnRun()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        // CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Payment);
        // CustLedgEntry.SetRange("Posting Date", Today);
        // if CustLedgEntry.FindSet() then
        //     repeat
        UpdateUnallocated(CustLedgEntry);
        // until CustLedgEntry.Next() = 0;
    end;
    //main
    procedure UpdateUnallocated(CustLedgEntryRec: Record "Cust. Ledger Entry")
    var
        Client: HttpClient;
        Content: HttpContent;
        Header: HttpHeaders;
        ContHeader: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        JResponse: JsonArray;
        Response: Text;
        Url: Text;
    begin
        // 
        if AccessToken.IsEmpty() then GenerateAuthAccessTokenJSON();
        Url := 'https://thefirstmile--full.sandbox.my.salesforce.com/services/data/v60.0/composite/sobjects/';
        RequestMessage.Method := 'PATCH';
        RequestMessage.SetRequestUri(Url);
        RequestMessage.GetHeaders(Header);
        Header.Add('Authorization', SecretStrSubstNo('Bearer %1', AccessToken));
        //
        // Content.WriteFrom(CreateJsonFromCustLedgEntryRec(CustLedgEntryRec));
        Content.WriteFrom(CreateDemoPayload());
        //
        Content.GetHeaders(ContHeader);
        if ContHeader.Contains('Content-Type') then ContHeader.Remove('Content-Type');
        ContHeader.Add('Content-Type', 'application/json');
        RequestMessage.Content(Content);
        //
        if Client.Send(RequestMessage, ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(Response);
            if ResponseMessage.IsSuccessStatusCode() then begin
                JResponse.ReadFrom(Response);

                Message(Response);
            end
            else
                Error(NotSuccessStatusErr, ResponseMessage.HttpStatusCode);
        end
        else
            Error(HttpRequestFailedErr);
    end;
    //returns a json object for request body 
    local procedure CreateJsonFromCustLedgEntryRec(CustLedgEntryRec: Record "Cust. Ledger Entry"): Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonAttributeObj: JsonObject;
        JsonText: Text;
    begin
        if CustLedgEntryRec.FindSet() then
            repeat
                Clear(JsonObject);
                Clear(JsonAttributeObj);
                JsonObject.Add('type', 'Invoice_Header__c');
                JsonObject.Add('attributes', JsonAttributeObj);
                JsonObject.Add('id', CustLedgEntryRec."SF Bank Statement ID");
                JsonObject.Add('Unallocated_Amount__c', CustLedgEntryRec."Remaining Amount");
                JsonArray.Add(JsonObject);
            until CustLedgEntryRec.Next() = 0;

        JsonObject.Add('allOrNone', false);
        JsonObject.Add('records', JsonArray);
        JsonObject.WriteTo(JsonText);

        exit(JsonText);
    end;

    // returns salesforce request auth token
    local procedure GenerateAuthAccessTokenJSON(): SecretText
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        JAccessToken: JsonToken;
        JsonResponse: JsonObject;
        TAccessToken: Text;
        ResponseText: Text;
        Url: Text;
    begin
        Url := 'https://thefirstmile--full.sandbox.my.salesforce.com/services/oauth2/token?' + 'grant_type=client_credentials&' + 'client_id=3MVG9xj60O9CjKHrE7FhA5I7_uwmC8ewInWCHIz7eUKBtncRqxnKlie_RZ8_ryG3IPjKkbrN6CdTZiFB3JzRD&' + 'client_secret=B5278AD55DEED19E86B1AFA053A3A262A252C6545F8449CEAAD110E29D908D4A';
        Content.WriteFrom('');
        if Client.Post(Url, Content, Response) then begin
            Response.Content().ReadAs(ResponseText);
            if Response.IsSuccessStatusCode() then begin
                JsonResponse.ReadFrom(ResponseText);
                JsonResponse.Get('access_token', JAccessToken);
            end
            else
                Error(NotSuccessStatusErr, Response.HttpStatusCode);
        end
        else
            Error(HttpRequestFailedErr);
        //secret text
        JAccessToken.WriteTo(TAccessToken);
        TAccessToken := TAccessToken.Replace('"', '');
        AccessToken := Format(TAccessToken);
        exit(AccessToken);
    end;


    //test 
    local procedure CreateDemoPayload(): Text
    var
        RecordsArray: JsonArray;
        JsonAttributeObj: JsonObject;
        JRecord: JsonObject;
        body: Text;
    begin
        JsonAttributeObj.Add('type', 'Bank_Statement__c');
        JRecord.Add('attributes', JsonAttributeObj);
        JRecord.Add('id', 'a4LPu000000Z6aPMAS');
        JRecord.Add('Unallocated_Amount__c', 0);
        RecordsArray.Add(JRecord);
        Clear(JRecord);
        Clear(JsonAttributeObj);

        JsonAttributeObj.Add('type', 'Bank_Statement__c');
        JRecord.Add('attributes', JsonAttributeObj);
        JRecord.Add('id', 'a4LPu000000Z6aQMAS');
        JRecord.Add('Unallocated_Amount__c', 100);
        RecordsArray.Add(JRecord);
        Clear(JRecord);
        Clear(JsonAttributeObj);

        JRecord.Add('allOrNone', false); // Static value
        JRecord.Add('records', RecordsArray);

        JRecord.WriteTo(body);
        exit(body);
    end;


    var
NotSuccessStatusErr: Label 'Request returned with status code %1', Comment = '%1= Returning status code';
        HttpRequestFailedErr: Label 'Http request failed';
        AccessToken: SecretText;
}
