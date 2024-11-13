namespace Isabel6;

using System.Text;
using Microsoft.Bank.CODA;

codeunit 50141 "Codabox Bank Stmt API Mgt."
{
    procedure GetAccountInformationAndStatement(FromDate: DateTime; ToDate: DateTime; BankAccountNo: Code[20])
    var
        AccountStatementID: Text;
        ClientID: Text;
        Statement: Text;
    begin
        GetAuthToken();
        PostAccountingOfficeConsent();
        DocumentSearch(FromDate, ToDate, ClientID, AccountStatementID);
        Statement := GetAccountStatement(AccountStatementID, ClientID);
        ImportCodaStatementFromText(Statement, BankAccountNo);
    end;

    local procedure GetAccountStatement(AccountStatementID: Text; ClientID: Text): Text
    var
        Isabel6Setup: Record "Isabel6 Setup";
        Base64Convert: Codeunit "Base64 Convert";
        InputStream: InStream;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        URI: Text;
        Certificate: Text;
        ResponseBody: Text;
    begin
        Isabel6Setup.Get();
        Isabel6Setup.CalcFields("SSL Certificate Value");
        Isabel6Setup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        URI := StrSubstNo(Isabel6Setup."Account Statement Endpoint", Isabel6Setup."Accounting Office ID", ClientID, AccountStatementID);

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6Setup."Codabox Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.coda.v1+cod');
        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('GET');

        Client.AddCertificate(Certificate, Isabel6Setup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseBody);

        exit(ResponseBody);
    end;

    local procedure DocumentSearch(FromDate: DateTime; ToDate: DateTime; var DocClientID: Text; var StmtID: Text)
    var
        Isabel6Setup: Record "Isabel6 Setup";
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
        IncludedNode: JsonToken;
        DocumentsNode: JsonToken;
        DocumentNode: JsonToken;
        JsonResponse: JsonObject;
        DocumentId: JsonToken;
        ClientId: JsonToken;
        ClientNode: JsonToken;
        ClientData: JsonToken;
        RelationshipsNode: JsonToken;
    begin
        Isabel6Setup.Get();
        Isabel6Setup.CalcFields("SSL Certificate Value");
        Isabel6Setup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        JsonPayload := GetDocumentSearchPayload(FromDate, ToDate);
        URI := StrSubstNo(Isabel6Setup."Document Search Endpoint", Isabel6Setup."Accounting Office ID");

        RequestContent.WriteFrom(JsonPayload);
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6Setup."Codabox Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.api+json');
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/vnd.api+json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, Isabel6Setup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        JsonResponse.ReadFrom(ResponseBody);
        if JsonResponse.Get('included', IncludedNode) then
            if IncludedNode.AsObject().Get('documents', DocumentsNode) then
                if DocumentsNode.AsArray().Count > 0 then begin
                    DocumentsNode.AsArray().Get(0, DocumentNode);
                    DocumentNode.AsObject().Get('id', DocumentId);
                    if DocumentNode.AsObject().Get('relationships', RelationshipsNode) and
                       RelationshipsNode.AsObject().Get('client', ClientNode) and ClientNode.AsObject().Get('data', ClientData) then
                        ClientData.AsObject().Get('id', ClientId);
                end;

        DocClientID := ClientId.AsValue().AsText();
        StmtID := DocumentId.AsValue().AsText();
    end;

    local procedure PostAccountingOfficeConsent()
    var
        Isabel6Setup: Record "Isabel6 Setup";
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
        ConsentID: JsonToken;
        OfficeID: JsonToken;
        ConsentStatus: JsonToken;
    begin
        Isabel6Setup.Get();
        Isabel6Setup.CalcFields("SSL Certificate Value");
        Isabel6Setup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        JsonPayload := GetAccountingOfficeConsentPayload();
        URI := Isabel6Setup."Accounting Office Endpoint";

        RequestContent.WriteFrom(JsonPayload);
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6Setup."Codabox Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.api+json');

        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/vnd.api+json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, Isabel6Setup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        JsonResponse.ReadFrom(ResponseBody);
        JsonResponse.Get('data', ResponseData);
        ResponseData.AsObject().Get('attributes', ResponseAttributes);
        if ResponseData.AsObject().Get('id', ConsentID) and ResponseAttributes.AsObject().Get('status', ConsentStatus) then
            case ConsentStatus.AsValue().AsText() of
                'unconfirmed':
                    repeat
                        GetAccountingOfficeConsentStatus(ConsentID.AsValue().AsText());
                    until GetAccountingOfficeConsentStatus(ConsentID.AsValue().AsText());
                'denied':
                    PostAccountingOfficeConsent();
            end;
        Isabel6Setup."Accounting Office Consent ID" := Format(ConsentID.AsValue().AsText());
        ResponseAttributes.AsObject().Get('accountingOfficeId', OfficeID);
        Isabel6Setup."Accounting Office ID" := Format(OfficeID.AsValue().AsText());
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
        Isabel6Setup.Get();
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
        AttributesObject.Add('from', Format(FromDate, 24, 9));
        AttributesObject.Add('to', Format(ToDate, 24, 9));
        ClientDataObject.Add('type', 'client');
        ClientDataObject.Add('id', Isabel6Setup."Isabel6 Client ID");
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


    local procedure GetAccountingOfficeConsentStatus(AccountingOfficeID: Text): Boolean
    var
        Isabel6Setup: Record "Isabel6 Setup";
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
        Isabel6Setup.Get();
        Isabel6Setup.CalcFields("SSL Certificate Value");
        Isabel6Setup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        JsonPayload := GetAccountingOfficeConsentPayload();
        URI := StrSubstNo('%1/%2', Isabel6Setup."Accounting Office Endpoint", AccountingOfficeID);

        RequestContent.WriteFrom(JsonPayload);
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6Setup."Codabox Auth Token");
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
            Error(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

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

    local procedure GetAuthToken(): Boolean
    var
        IsabelAPISetup: Record "Isabel6 Setup";
        Base64Convert: Codeunit "Base64 Convert";
        JsonPayload: JsonObject;
        AccessToken: JsonToken;
        ExpiresIn: JsonToken;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        RequestHeader: HttpHeaders;
        ContentHeader: HttpHeaders;
        InputStream: InStream;
        Certificate: Text;
        EncodedUriLbl: Text;
        URI: Text;
        ResponseBody: Text;
    begin
        IsabelAPISetup.Get();
        IsabelAPISetup.CalcFields("SSL Certificate Value");
        IsabelAPISetup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);

        EncodedUriLbl := '%1?grant_type=client_credentials';
        URI := StrSubstNo(EncodedUriLbl, IsabelAPISetup."Codabox Auth Token Endpoint");

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', SecretStrSubstNo('Basic %1', GetEncodedClientSecret()));
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, IsabelAPISetup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());

        JsonPayload.ReadFrom(ResponseBody);
        if JsonPayload.Get('access_token', AccessToken) and JsonPayload.Get('expires_in', ExpiresIn) then begin
            IsabelAPISetup."Codabox Auth Token" := '';
            IsabelAPISetup."Codabox Auth Token" := Format(AccessToken.AsValue().AsText());
            IsabelAPISetup."Codabox Auth Token Expires" := GetExpiryDateTime(ExpiresIn.AsValue().AsInteger());
            IsabelAPISetup.Modify();
            exit(true);
        end;
    end;

    local procedure GetEncodedClientSecret(): Text
    var
        IsabelAPISetup: Record "Isabel6 Setup";
        Base64Convert: Codeunit "Base64 Convert";
        Base64Value: Text;
    begin
        IsabelAPISetup.Get();
        Base64Value := Base64Convert.ToBase64(StrSubstNo('%1:%2', IsabelAPISetup."Codabox Client ID", IsabelAPISetup."Codabox Client Secret"), TextEncoding::UTF8);
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

    procedure ImportCodaStatementFromText(TextData: Text; BankAccountNo: Code[20])
    begin
        BankAccNo := BankAccountNo;
        CodaMgmt.InitCodaImport(BankAccNo);
        FirstTime := true;
        InLines := false;
        Pos := 1;
        LineLength := StrLen(TextData);
        LineNo := 0;

        if CodBankStmtSrcLine.FindLast() then
            TempStatementNo := IncStr(CodBankStmtSrcLine."Statement No.");
        if TempStatementNo = '' then
            TempStatementNo := CopyStr(BankAccNo, 1, 18) + '/1';
        CodBankStmtSrcLine.Reset();

        while Pos <= LineLength do begin
            LineNo := LineNo + 1;

            LineText := CopyStr(TextData, Pos, 136);
            LineText := LineText.Trim();
            Pos := Pos + 136;

            CodBankStmtSrcLine.Init();
            CodBankStmtSrcLine."Bank Account No." := BankAccNo;
            CodBankStmtSrcLine."Statement No." := TempStatementNo;
            CodBankStmtSrcLine."Line No." := LineNo;
            CodBankStmtSrcLine.Data := LineText;

            if PutRecordInDatabase() then
                break;
        end;
        Message('Statement Imported Successfully');
    end;

    procedure PutRecordInDatabase(): Boolean
    var
        i: Integer;
    begin
        if not Evaluate(i, CopyStr(CodBankStmtSrcLine.Data, 1, 1)) then begin
            if InLines then
                Error(Text000Lbl, CodBankStmtSrcLine.Data);

            CodaMgmt.SkipLine();
            exit;
        end;
        CodBankStmtSrcLine.ID := i;

        if not ((VersionCode = '2') and (CodBankStmtSrcLine.ID = CodBankStmtSrcLine.ID::"Free Message")) then
            CodaMgmt.UpdateLineCounter(CodBankStmtSrcLine);

        case CodBankStmtSrcLine.ID of
            CodBankStmtSrcLine.ID::Header:
                CodBankStmtSrcLine.Insert();
            // begin
            // CodaMgmt.CheckCodaHeader(CodBankStmtSrcLine);
            // end;
            CodBankStmtSrcLine.ID::"Old Balance":
                begin
                    CodaMgmt.CheckOldBalance(CodBankStmtSrcLine);
                    if FirstTime then begin
                        TempStatementNo :=
                          CodaMgmt.UpdateStatementNo(CodBankStmtSrcLine, TempStatementNo, CodBankStmtSrcLine."Statement No.");
                        AccountType := CopyStr(CodBankStmtSrcLine.Data, 2, 1);
                        FirstTime := false
                    end else
                        TempStatementNo := CodBankStmtSrcLine."Statement No.";
                    CodBankStmtSrcLine.Insert();
                    exit(false);
                end;
            CodBankStmtSrcLine.ID::Movement, CodBankStmtSrcLine.ID::Information, CodBankStmtSrcLine.ID::"Free Message":
                begin
                    CodaMgmt.CheckCodaRecord(CodBankStmtSrcLine);
                    CodBankStmtSrcLine.Insert();
                    exit(false);
                end;
            CodBankStmtSrcLine.ID::"New Balance":
                begin
                    CodaMgmt.CheckNewBalance(CodBankStmtSrcLine, AccountType);
                    CodBankStmtSrcLine.Insert();
                    exit(false);
                end;
            CodBankStmtSrcLine.ID::Trailer:
                begin
                    CodaMgmt.CheckCodaTrailer(CodBankStmtSrcLine);
                    CodaMgmt.Success();

                    CodBankStmtSrcLine2.SetRange("Bank Account No.", BankAccNo);
                    CodBankStmtSrcLine2.SetRange("Statement No.", TempStatementNo);
                    REPORT.RunModal(REPORT::"Initialise CODA Stmt. Lines", false, false, CodBankStmtSrcLine2);
                    CodBankStmtSrcLine2.DeleteAll();
                    TempStatementNo := IncStr(TempStatementNo);
                    exit(true);
                end;
        end;
    end;

    var
        CodBankStmtSrcLine2: Record "CODA Statement Source Line";
        CodBankStmtSrcLine: Record "CODA Statement Source Line";
        CodaMgmt: Codeunit "Coda Import Management";
        BankAccNo: Code[20];
        TempStatementNo: Code[20];
        LineNo: Integer;
        FirstTime: Boolean;
        InLines: Boolean;
        VersionCode: Text[1];
        AccountType: Text[1];
        Pos: Integer;
        LineLength: Integer;
        LineText: Text[136];
        Text000Lbl: Label 'Line is not valid\%1.', Comment = '%1 = ';
        RequestErrLbl: Label 'The requested responded with %1 status code and the reason is %2', Comment = '%1= , %2= ';
}