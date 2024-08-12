codeunit 50147 "Export Bank Statement"
{
    SingleInstance = true;
    TableNo = "Cust. Ledger Entry";

    trigger OnRun()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Payment);
        CustLedgEntry.SetRange("Customer No.", '001w000001QGn5AAAT');
        if CustLedgEntry.FindLast() then
            repeat
                SynceBankStatement(CustLedgEntry);
            until CustLedgEntry.Next() = 0;

        // UpdateOutStanding(CustLedgEntry);

        // UpdateUnallocated(CustLedgEntry);
    end;

    local procedure SynceBankStatement(var CustLedgEntryRec: Record "Cust. Ledger Entry")
    var
        Client: HttpClient;
        Content: HttpContent;
        Header: HttpHeaders;
        ContHeader: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        JResponse: JsonObject;
        Response: Text;
        BankStatementID: JsonToken;
        Url: Text;
    begin
        // 
        if AccessToken.IsEmpty() then GenerateAuthAccessTokenJSON();
        Url := 'https://thefirstmile--full.sandbox.my.salesforce.com/services/data/v60.0/sobjects/Bank_Statement__c';
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(Url);
        RequestMessage.GetHeaders(Header);
        Header.Add('Authorization', SecretStrSubstNo('Bearer %1', AccessToken));
        //
        Content.WriteFrom(CreateJsonFromCustLedgEntryRec(CustLedgEntryRec));
        // Content.WriteFrom(CreateDemoPayload());
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
                JResponse.Get('id', BankStatementID);
                CustLedgEntryRec."SF Bank Statement ID" := DelChr(Format(BankStatementID), '=', '"');
                CustLedgEntryRec.Modify();
                Message('%1', JResponse);
            end
            else
                Error(NotSuccessStatusErr, ResponseMessage.HttpStatusCode);
        end
        else
            Error(HttpRequestFailedErr);
    end;

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
        Content.WriteFrom(UpdateUnallocJsonFromCustLedgEntryRec(CustLedgEntryRec));
        //
        Message(UpdateUnallocJsonFromCustLedgEntryRec(CustLedgEntryRec));

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


    procedure UpdateOutStanding(CustLedgEntryRec: Record "Cust. Ledger Entry")
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
        if AccessToken.IsEmpty() then GenerateAuthAccessTokenJSON();
        Url := 'https://thefirstmile--full.sandbox.my.salesforce.com/services/data/v60.0/composite/sobjects/';
        RequestMessage.Method := 'PATCH';
        RequestMessage.SetRequestUri(Url);
        RequestMessage.GetHeaders(Header);
        Header.Add('Authorization', SecretStrSubstNo('Bearer %1', AccessToken));
        //
        Content.WriteFrom(UpdateOutStdJsonFromCustLedgEntryRec(CustLedgEntryRec));
        //
        Message(UpdateOutStdJsonFromCustLedgEntryRec(CustLedgEntryRec));

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

    local procedure CreateJsonFromCustLedgEntryRec(CustLedgEntryRec: Record "Cust. Ledger Entry"): Text
    var
        JRecord: JsonObject;
        Body: Text;
    begin
        CustLedgEntryRec.CalcFields(Amount);
        JRecord.Add('Entry_Date__c', Format(CustLedgEntryRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        JRecord.Add('Transaction_Type__c', CustLedgEntryRec."Payment Method Code");
        JRecord.Add('Receipt_Amount__c', CustLedgEntryRec."Amount");
        JRecord.Add('Account__c', '001w000001QGn5AAAT');
        JRecord.Add('Transaction_Details__c', CustLedgEntryRec."Description");
        JRecord.Add('Unallocated_Amount__c', CustLedgEntryRec."Remaining Amount");
        JRecord.Add('Document_name__c', GetAppliesDocNumber(CustLedgEntryRec));
        JRecord.WriteTo(Body);
        exit(Body);
    end;

    local procedure UpdateOutStdJsonFromCustLedgEntryRec(var CustLedgEntryRec: Record "Cust. Ledger Entry"): Text
    var
        JsonArray: JsonArray;
        JsonAttributeObj: JsonObject;
        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if CustLedgEntryRec.FindSet() then
            repeat
                Clear(JsonObject);
                Clear(JsonAttributeObj);
                JsonAttributeObj.Add('type', 'Invoice_Header__c');
                JsonObject.Add('attributes', JsonAttributeObj);
                JsonObject.Add('id', CustLedgEntryRec."SF Bank Statement ID");
                JsonObject.Add('AmountOutstanding__c', CustLedgEntryRec."Remaining Amount");
                JsonArray.Add(JsonObject);
            until CustLedgEntryRec.Next() = 0;

        JsonObject.Add('allOrNone', false);
        JsonObject.Add('records', JsonArray);
        JsonObject.WriteTo(JsonText);

        exit(JsonText);
    end;

    local procedure UpdateUnallocJsonFromCustLedgEntryRec(CustLedgEntryRec: Record "Cust. Ledger Entry"): Text
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

    local procedure GetAppliesDocNumber(CustLedgEntryRec: Record "Cust. Ledger Entry"): Text
    var
        CustLedgerEntries: Record "Cust. Ledger Entry";
        AppliedDocNumbers: Text;
    begin
        CustLedgerEntries.Reset();
        CustLedgerEntries.SetRange("Closed by Entry No.", CustLedgEntryRec."Entry No.");
        if CustLedgerEntries.FindSet() then
            repeat
                AppliedDocNumbers += CustLedgerEntries."Document No." + ',';
            until CustLedgerEntries.Next() = 0;
        exit(AppliedDocNumbers);
    end;

    var
        NotSuccessStatusErr: Label 'Request returned with status code %1', Comment = '%1= Returning status code';
        HttpRequestFailedErr: Label 'Http request failed';
        AccessToken: SecretText;


}
