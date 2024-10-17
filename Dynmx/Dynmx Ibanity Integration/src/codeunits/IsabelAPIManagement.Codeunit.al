codeunit 50140 "Isabel API Management"
{
    Permissions = tabledata "Isabel API Setup" = RIMD;


    procedure PaymentsInitiation(PaymentJournalLine: Record "Payment Journal Line")
    var
        Isabel6APISetup: Record "Isabel API Setup";
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
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6APISetup."Auth Token");
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
        Isabel6APISetup: Record "Isabel API Setup";
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
        RequestHeader.Add('Authorization', 'Bearer ' + Isabel6APISetup."Auth Token");
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
        JsonPayload: JsonObject;
        PayloadData: JsonToken;
        PayloadAttributes: JsonToken;
        Status: JsonToken;
        RequestID: JsonToken;
    begin
        JsonPayload.ReadFrom(ResponseBody);
        JsonPayload.Get('data', PayloadData);

        if PayloadData.AsObject().Get('id', RequestID) and PayloadData.AsObject().Get('attributes', PayloadAttributes) then begin
            PaymentRequestID := RequestID.AsValue().AsText();
            if PayloadAttributes.AsObject().Get('status', Status) then
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
        IsabelAPISetup: Record "Isabel API Setup";
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

        URI := IsabelAPISetup."Auth Token Endpoint";
        URI := StrSubstNo(EncodedUriLbl, IsabelAPISetup."Auth Token Endpoint", 'authorization_code', IsabelAPISetup."Authorization Code", '');

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
            IsabelAPISetup."Auth Token" := '';
            IsabelAPISetup."Auth Token" := Format(AccessToken.AsValue().AsText());
            IsabelAPISetup.Modify();
            exit(true);
        end;
    end;

    local procedure GetEncodedClientSecret(): Text
    var
        IsabelAPISetup: Record "Isabel API Setup";
        Base64Convert: Codeunit "Base64 Convert";
        Base64Value: Text;
    begin
        IsabelAPISetup.Get();
        Base64Value := Base64Convert.ToBase64(StrSubstNo('%1:%2', IsabelAPISetup."Client ID", IsabelAPISetup."Client Secret"), TextEncoding::UTF8);
        exit(Base64Value);
    end;

    local procedure GetPaymentsInitiationRequestPayload(PaymentJournalLine: Record "Payment Journal Line"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        OutputSTream: OutStream;
        InputStream: InStream;
        XMLPayload: Text;
    begin
        TempBlob.CreateOutStream(OutputStream);
        Xmlport.Export(Xmlport::"SEPA CT pain.001.001.02", OutputStream, PaymentJournalLine);
        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XMLPayload);
        exit(XMLPayload);
    end;

    procedure CertificateAndHash()
    var
        X509Certificate2: Codeunit X509Certificate2;
        CertBase64: Text;
        CertificateProperties: Text;
    begin
        CertBase64 := 'MIIFNTCCAx2gAwIBAgIUDBYgNcUFIk/o7590NovlOY6o0xEwDQYJKoZIhvcNAQELBQAwgYkxCzAJBgNVBAYTAkJFMTYwNAYDVQQDDC1JYmFuaXR5IFByb2R1Y3Rpb24gVGhpcmQgUGFydHkgQXBwbGljYXRpb24gQ0ExFTATBgNVBAoMDElzYWJlbCBHcm91cDErMCkGA1UECwwiSXNhYmVsIEdyb3VwIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw0yNDEwMDEwODUwMTJaFw0yNTExMDEwODUwNDJaMIHKMQswCQYDVQQGEwJCRTEVMBMGA1UEChMMSXNhYmVsIEdyb3VwMSswKQYDVQQLEyJJc2FiZWwgR3JvdXAgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MUgwRgYDVQQDEz9EeSBhcHBsaWNhdGlvbiBzaWduYXR1cmUgKDU5MGZlNjY2LThlMmEtNDc1Ny04Y2E0LWE5NDU0YmJkNTgxMSkxLTArBgNVBAUTJDEwZGVhNDQ3LWFlYmMtNGI5My1iZjdhLWJiZGJmNGEzNmRiZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOqXBMd1n2EamYEvl1vJueHepJjD9TmX32elt/7n4KeDIge4N+LZ4JJUjcH0Os5QLU+wIwh7B/3jbOzOFkbvCnJT4GhmN4mmG5XQ5Zi2ZiLSMC7Ryibpc4vzTMfLG8hXqqakW8jgtVbuM2D7b4yjE4bf7i20XWKLXls53RA4r1TqzXxtvoxcnjT1DtzqbkFLsLKXbQpdMxMMv8T4rg3X6vbcyCjrDeZrucafz1hmbDwKuq4LNogWU4YAHebKbTyxayN9ctj/1o4/IkfxtJY1/JE5B1KkhzUMKK1X4S/mfTe18HrW5VTvMIisNMgPt8NsWk46McTyPubPVBSr/j6ntUUCAwEAAaNSMFAwDgYDVR0PAQH/BAQDAgOoMB0GA1UdDgQWBBQjUNVAXfIHj0SoQtKQBX+QdoCJOzAfBgNVHSMEGDAWgBRbTWya9sGCdDRZ7249f8EreUv4nTANBgkqhkiG9w0BAQsFAAOCAgEAh9Ex1udCq0Lop4ZuLXmAlbGF6Ln9W4SY2EhmDVd4c2jkZ5etGdMQ+HLEJYtM84rQlnY/Ah5eHjWOCRmTJMrdWgj/n6Nqv9eMA8DRky1KU0trdYbGco3Yk0486OpPkD3CaExp07ONK9KmSM72UxwBUW6SZa3tfqHIlwbR24abxoMhTT3PxfZVr5KGhRqlEB6NUcWLUAerx04UCIHFuYRkv0A+6T+bQzZg8GqCEOjqBOvApleyKByL/s/FmguQjxJb5bO7QsMN5AupWGx2xufwUx1Dkgv4Hy889JVLgqNhF3n479q+MqHXv/65mNhOBBMn2EfO3hqI1qV670RxtDP/zn8VTGk83bw4STvlsB0KgfYqJLQI/pO8hvuB9G9m+xwalxJwVos3nHyvaRiow1s58JHwOesvyrKD0zbZE6VdkUjR9pqEi+aKryNfXVMae0YDLL8n/mZwCTa5kSFPOHrUyKX3eCkxHj0sLdql5uDTBVDsuZsciSLo6+BIruAKMujQB4lJA7FhWFJ84GzO7CwA09t6L3RrMDniuh0sR4T07y//B7lKFEBL3B42BMr3QdoMArCTJ1Cl/6OkgFJYYIEGEOcU1GVf77zJjgCsdjDpiiRiKl5Pwdr6fV44WjbDgzS1EjpyMa+J8LNrveWL/T68uZ9dNQLZ2gsvRxIEm1Uf984=';
        X509Certificate2.GetCertificatePropertiesAsJson(CertBase64, 'mIqn8t8As-skB5d', CertificateProperties);
        Message(CertificateProperties);
    end;

    var
        RequestErrLbl: Label 'The requested responded with %1 status code and the reason is %2', Comment = '%1= , %2= ';
        EncodedUriLbl: Label '%1?grant_type=%2&code=%3&redirect_uri=%4', Comment = '%1 = URL, %2 = client ID,%3= ,%4 =';
}