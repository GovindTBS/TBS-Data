namespace Isabel6;

using Microsoft.Bank.Payment;
using System.Text;
using System.Utilities;

codeunit 50140 "Isabel6 Payment API Mgt."
{
    Permissions = tabledata "Isabel6 Setup" = RIMD;
    procedure PaymentsInitiation(PaymentJournalLine: Record "Payment Journal Line"; Payments: Text)
    var
        Isabel6APISetup: Record "Isabel6 Setup";
        Base64Convert: Codeunit "Base64 Convert";
        InputStream: InStream;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        RequestHeader: HttpHeaders;
        ContentHeader: HttpHeaders;
        URI: Text;
        XMLPayload: Text;
        Certificate: Text;
        ResponseBody: Text;
        PaymentRequestID: Text;
        PaymentRequestStatus: Text;
    begin
        GetAuthToken();
        Isabel6APISetup.Get();
        Isabel6APISetup.CalcFields("SSL Certificate Value");
        Isabel6APISetup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);
        // XMLPayload := '<?xml version="1.0" encoding="UTF-8"?>< Document xmlns = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.02" xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.02 D:\SEPA\pain.001.001.02.xsd" ><pain.001.001.02></pain.001.001.02></Document>';
        XMLPayload := GetPaymentsInitiationRequestPayload(PaymentJournalLine);
        URI := Isabel6APISetup."Payment Initiation Endpoint";

        RequestContent.WriteFrom(XMLPayload);
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6APISetup."Isabel6 Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.api+json');
        RequestHeader.Add('Is-Shared', 'True');
        RequestHeader.Add('Hide-Details', 'False');

        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Disposition', 'inline; filename=''payments.xml''');
        ContentHeader.Add('Content-Type', 'application/xml');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, Isabel6APISetup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()))
        else
            ParsePaymentInitiationResponse(ResponseBody, PaymentRequestID, PaymentRequestStatus);

        PaymentJournalLine."Payment Request ID" := Format(PaymentRequestID);
        PaymentJournalLine."Payment Status" := Format(PaymentRequestStatus);
        PaymentJournalLine.Modify();
    end;

    procedure GetPaymentsStatus(PaymentJournalLine: Record "Payment Journal Line")
    var
        Isabel6APISetup: Record "Isabel6 Setup";
        Base64Convert: Codeunit "Base64 Convert";
        InputStream: InStream;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        URI: Text;
        Certificate: Text;
        ResponseBody: Text;
        PaymentRequestStatus: Text;
    begin
        GetAuthToken();
        Isabel6APISetup.Get();
        Isabel6APISetup.CalcFields("SSL Certificate Value");
        Isabel6APISetup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);

        URI := Isabel6APISetup."Payment Initiation Endpoint";
        URI := StrSubstNo('%1/%2', URI, PaymentJournalLine."Payment Request ID");

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6APISetup."Isabel6 Auth Token");
        if RequestHeader.Contains('Accept') then
            RequestHeader.Remove('Accept');
        RequestHeader.Add('Accept', 'application/vnd.api+json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('GET');

        Client.AddCertificate(Certificate, Isabel6APISetup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()))
        else
            ParsePaymentStatusResponse(ResponseBody, PaymentRequestStatus);

        PaymentJournalLine."Payment Status" := Format(PaymentRequestStatus);
        PaymentJournalLine.Modify();
    end;

    local procedure ParsePaymentInitiationResponse(ResponseBody: Text; var PaymentRequestID: Text; var PaymentRequestStatus: Text)
    var
        JsonResponse: JsonObject;
        ResponseData: JsonToken;
        ResponseAttributes: JsonToken;
        Status: JsonToken;
        RequestID: JsonToken;
    begin
        JsonResponse.ReadFrom(ResponseBody);
        JsonResponse.Get('data', ResponseData);

        if ResponseData.AsObject().Get('id', RequestID) and ResponseData.AsObject().Get('attributes', ResponseAttributes) then begin
            PaymentRequestID := RequestID.AsValue().AsText();
            if ResponseAttributes.AsObject().Get('status', Status) then
                PaymentRequestStatus := Status.AsValue().AsText();
        end;
    end;

    local procedure ParsePaymentStatusResponse(ResponseBody: Text; var PaymentRequestStatus: Text)
    var
        JsonPayload: JsonObject;
        PayloadData: JsonToken;
        PayloadAttributes: JsonToken;
        Status: JsonToken;
    begin
        JsonPayload.ReadFrom(ResponseBody);
        JsonPayload.Get('data', PayloadData);

        if PayloadData.AsObject().Get('attributes', PayloadAttributes) and PayloadAttributes.AsObject().Get('status', Status) then
            PaymentRequestStatus := Status.AsValue().AsText();
    end;

    local procedure GetAuthToken(): Boolean
    var
        IsabelAPISetup: Record "Isabel6 Setup";
        Base64Convert: Codeunit "Base64 Convert";
        JsonPayload: JsonObject;
        AccessToken: JsonToken;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        RequestHeader: HttpHeaders;
        ContentHeader: HttpHeaders;
        InputStream: InStream;
        Certificate: Text;
        URI: Text;
        ResponseBody: Text;
    begin
        IsabelAPISetup.Get();
        IsabelAPISetup.CalcFields("SSL Certificate Value");
        IsabelAPISetup."SSL Certificate Value".CreateInStream(InputStream);
        Certificate := Base64Convert.ToBase64(InputStream);

        URI := IsabelAPISetup."Isabel6 Auth Token Endpoint";
        URI := StrSubstNo(EncodedUriLbl, IsabelAPISetup."Isabel6 Auth Token Endpoint", 'authorization_code', IsabelAPISetup."Authorization Code", '');

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
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));

        JsonPayload.ReadFrom(ResponseBody);
        if JsonPayload.Get('access_token', AccessToken) then begin
            IsabelAPISetup."Isabel6 Auth Token" := '';
            IsabelAPISetup."Isabel6 Auth Token" := Format(AccessToken.AsValue().AsText());
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
        Base64Value := Base64Convert.ToBase64(StrSubstNo('%1:%2', IsabelAPISetup."Isabel6 Client ID", IsabelAPISetup."Isabel6 Client Secret"), TextEncoding::UTF8);
        exit(Base64Value);
    end;

    procedure GetPaymentsInitiationRequestPayload(PaymentJournalLine: Record "Payment Journal Line"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        OutputSTream: OutStream;
        InputStream: InStream;
        XMLPayload: Text;
    begin
        TempBlob.CreateOutStream(OutputStream);
        // Xmlport.Export(Xmlport::"SEPA CT pain.001.001.02", OutputStream, PaymentJournalLine);
        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XMLPayload);
        exit(XMLPayload);
    end;

    var
        RequestErrLbl: Label 'The requested responded with %1 status code and the reason is %2', Comment = '%1= , %2= ';
        EncodedUriLbl: Label '%1?grant_type=%2&code=%3&redirect_uri=%4', Comment = '%1 = URL, %2 = client ID,%3= ,%4 =';
}