codeunit 50142 "Citi Bank API Management"
{
    Permissions = tabledata "Citi Bank API Setup" = RIMD;
    Access = Internal;

    local procedure GetAuthToken(var CitiBankAPISetup: Record "Citi Bank API Setup"): Text
    var
        CitiAzureTriggersMgt: Codeunit "Citi Azure Triggers Mgt.";
        Base64Convert: Codeunit "Base64 Convert";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        RequestHeader: HttpHeaders;
        JsonPayload: JsonObject;
        ExpiryDuration: JsonToken;
        AccessToken: JsonToken;
        AccessTokenString: JsonToken;
        URI: Text;
        Certificate: Text;
        ResponseBody: Text;
        JsonPayloadText: Text;
        EncryptPayloadString: Text;
        Inputstream: InStream;
    begin
        CitiBankAPISetup.Get();
        CitiBankAPISetup.CalcFields("SSL Certificate Value");
        CitiBankAPISetup."SSL Certificate Value".CreateInStream(Inputstream);
        Certificate := Base64Convert.ToBase64(Inputstream);

        URI := CitiBankAPISetup."Auth Token Endpoint";

        JsonPayloadText := GetAuthTokenJsonPayload();
        EncryptPayloadString := CitiAzureTriggersMgt.EncryptAndSign(JsonPayloadText, 'json');

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', SecretStrSubstNo('Basic %1', GetEncodedClientSecret()));
        RequestContent.WriteFrom(EncryptPayloadString);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/json');

        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        Client.AddCertificate(Certificate, CitiBankAPISetup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then begin
            Message(StrSubstNo(RequestErrLbl, ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase()));
            exit;
        end;

        ResponseBody := CitiAzureTriggersMgt.DecryptAndVerify(ResponseBody, 'json');
        JsonPayload.ReadFrom(ResponseBody);
        JsonPayload.Get('token', AccessTokenString);

        if AccessTokenString.AsObject().Get('access_token', AccessToken) and AccessTokenString.AsObject().Get('expires_in', ExpiryDuration) then begin
            CitiBankAPISetup."Auth Token" := '';
            CitiBankAPISetup."Auth Token" := Format(AccessToken.AsValue().AsText());
            CitiBankAPISetup."Token Expires At" := GetExpiryDateTime(ExpiryDuration.AsValue().AsInteger());
            CitiBankAPISetup.Modify(false);
        end;
    end;

    procedure InitiatePayment(var GenJournalLine: Record "Gen. Journal Line"): Text
    var
        GenJournalLine1: Record "Gen. Journal Line";
        CitiBankAPISetup: Record "Citi Bank API Setup";
        Base64Convert: Codeunit "Base64 Convert";
        TypeHelper: Codeunit "Type Helper";
        CitiAzureTriggersMgt: Codeunit "Citi Azure Triggers Mgt.";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        RequestHeader: HttpHeaders;
        XMLDoc: XmlDocument;
        XMLPayload: Text;
        URI: Text;
        ResponseContent: Text;
        PaymentRequestId: Text;
        OrgnlMsgIdNode: XmlNode;
        InputStream: InStream;
        Certificate: Text;
        AccessToken: Text;
        Status: text;
        StatusInfo: Text;
    begin
        CitiBankAPISetup.Get();
        CitiBankAPISetup.CalcFields("SSL Certificate Value");
        CitiBankAPISetup."SSL Certificate Value".CreateInStream(Inputstream);
        Certificate := Base64Convert.ToBase64(Inputstream);

        if TypeHelper.CompareDateTime(CitiBankAPISetup."Token Expires At", CurrentDateTime) <> 1 then
            GetAuthToken(CitiBankAPISetup);
        AccessToken := CitiBankAPISetup."Auth Token";
        URI := StrSubstNo(EncodedUriLbl, CitiBankAPISetup."Payment Initiation Endpoint", CitiBankAPISetup."Client ID");

        XMLPayload := GetPaymentInitXMLPayload(GenJournalLine); //?
        XMLPayload := CitiAzureTriggersMgt.EncryptAndSign(XMLPayload, 'xml');
        RequestContent.WriteFrom(XMLPayload);
        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method('POST');
        RequestMessage.Content(RequestContent);

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + AccessToken);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/xml');
        ContentHeader.Add('payloadType', 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03');

        RequestMessage.Content(RequestContent);
        Client.AddCertificate(Certificate, CitiBankAPISetup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseContent);
        ResponseContent := CitiAzureTriggersMgt.DecryptAndVerify(ResponseContent, 'xml');

        if not ResponseMessage.IsSuccessStatusCode() then begin
            if XMLDoc.SelectSingleNode('/*[local-name()="errormessage"]/*[local-name()="moreInformation"]', OrgnlMsgIdNode) then
                Error(OrgnlMsgIdNode.AsXmlElement().InnerText);
            exit;
        end else begin
            PaymentRequestId := ParsePaymentInitiationResponse(ResponseContent, Status, StatusInfo);
            GenJournalLine."Payment Status Code" := Status;
            GenJournalLine."Payment Status Information" := StatusInfo;
            GenJournalLine.Modify();
        end;
        exit(PaymentRequestId);
    end;

    local procedure ParsePaymentInitiationResponse(ResponseContent: Text; var Status: Text; Var StatusInfo: Text): Text
    var
        CitiBankAPISetup: Record "Citi Bank API Setup";
        Base64Convert: Codeunit "Base64 Convert";
        OutputSTream: OutStream;
        XmlDoc: XmlDocument;
        Base64Node: XmlNode;
        StatusNode: XmlNode;
        OriginalMessageIdNode: XmlNode;
        StatusInfoNode: XmlNode;
        Base64Text: Text;
        Base64Xml: Text;
    begin
        CitiBankAPISetup.Get();
        XmlDocument.ReadFrom(ResponseContent, XmlDoc);
        if XmlDoc.SelectSingleNode('/*[local-name()="paymentInitiationResponse"]/*[local-name()="psrDocument"]', Base64Node) then
            Base64Text := Base64Node.AsXmlElement().InnerText()
        else
            exit('Error: psrDocument not found');

        Base64Xml := Base64Convert.FromBase64(Base64Text);
        XmlDocument.ReadFrom(Base64Xml, XmlDoc);

        if XmlDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="TxSts"]', StatusNode) then begin
            Status := StatusNode.AsXmlElement().InnerText();
            if XmlDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="StsRsnInf"]/*[local-name()="AddtlInf"]', StatusInfoNode) then
                StatusInfo := StatusInfoNode.AsXmlElement().InnerText();
        end;
        if XmlDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="OrgnlEndToEndId"]', OriginalMessageIdNode) then
            exit(OriginalMessageIdNode.AsXmlElement().InnerText())
        else
            exit('Error: Original Payment Request ID not found');
    end;

    procedure SendEnhancedPaymentStatusInquiry(var GenJournalLine: Record "Gen. Journal Line"): Text
    var
        CitiBankAPISetup: Record "Citi Bank API Setup";
        TempBlob: Codeunit "Temp Blob";
        TypeHelper: Codeunit "Type Helper";
        Base64Convert: Codeunit "Base64 Convert";
        CitiAzureTriggersMgt: Codeunit "Citi Azure Triggers Mgt.";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentHeader: HttpHeaders;
        ResponseHeader: HttpHeaders;
        RequestHeader: HttpHeaders;
        ResponseText: Text;
        Certificate: Text;
        RequestURI: Text;
        XMLPayload: Text;
        PaymentTxtStatus: Text;
        XMLDoc: XmlDocument;
        OrgnlMsgIdNode: XmlNode;
        TxtStatus: XmlNode;
        StatusInfo: XmlNode;
        AccessToken: Text;
        FileName: Text;
        ResponseXMLDoc: XmlDocument;
        InputStream: InStream;
        Outputstream: OutStream;
    begin
        CitiBankAPISetup.Get();
        CitiBankAPISetup.CalcFields("SSL Certificate Value");
        CitiBankAPISetup."SSL Certificate Value".CreateInStream(Inputstream);
        Certificate := Base64Convert.ToBase64(Inputstream);

        CitiBankAPISetup.Get();
        if TypeHelper.CompareDateTime(CitiBankAPISetup."Token Expires At", CurrentDateTime) = -1 then
            GetAuthToken(CitiBankAPISetup);
        AccessToken := CitiBankAPISetup."Auth Token";

        RequestURI := StrSubstNo('%1?client_id=%2&&endToEndId=%3', CitiBankAPISetup."Payment Status Endpoint", CitiBankAPISetup."Client ID", GenJournalLine."Payment Request ID");

        RequestContent.WriteFrom(XMLPayload);
        RequestMessage.SetRequestUri(RequestURI);
        RequestMessage.Method('GET');
        RequestMessage.Content(RequestContent);

        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Accept', 'application/xml');
        RequestHeader.Add('Authorization', 'Bearer ' + AccessToken);
        RequestContent.GetHeaders(ContentHeader);
        if ContentHeader.Contains('Content-Type') then
            ContentHeader.Remove('Content-Type');
        ContentHeader.Add('Content-Type', 'application/xml');
        RequestMessage.Content(RequestContent);
        Client.AddCertificate(Certificate, CitiBankAPISetup."SSL Certificate Password");
        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseText);
        ResponseText := CitiAzureTriggersMgt.DecryptAndVerify(ResponseText, 'xml');

        XmlDocument.ReadFrom(ResponseText, XMLDoc);
        if not ResponseMessage.IsSuccessStatusCode() then begin
            if XMLDoc.SelectSingleNode('/*[local-name()="errormessage"]/*[local-name()="moreInformation"]', OrgnlMsgIdNode) then
                Error(OrgnlMsgIdNode.AsXmlElement().InnerText);
            exit;
        end else
            if XMLDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="TxSts"]', TxtStatus) then begin
                PaymentTxtStatus := TxtStatus.AsXmlElement().InnerText;
                if XMLDoc.SelectSingleNode('/*[local-name()="Document"]/*[local-name()="CstmrPmtStsRpt"]/*[local-name()="OrgnlPmtInfAndSts"]/*[local-name()="TxInfAndSts"]/*[local-name()="StsRsnInf"]/*[local-name()="AddtlInf"]', StatusInfo) then begin
                    GenJournalLine."Payment Status Information" := StatusInfo.AsXmlElement().InnerText;
                    GenJournalLine.Modify();
                end;
            end;

        if CitiBankAPISetup."Debug Mode" then begin
            XmlDocument.ReadFrom(ResponseText, ResponseXMLDoc);
            ResponseXMLDoc.WriteTo(ResponseText);
            TempBlob.CreateOutStream(Outputstream);
            Outputstream.Write(ResponseText);
            TempBlob.CreateInStream(InputStream);
            FileName := StrSubstNo('Payment_Init_Response_%1.txt', CurrentDateTime);
            DownloadFromStream(InputStream, '', '', '', FileName);
        end;

        exit(PaymentTxtStatus);
    end;

    local procedure GetEncodedClientSecret(): Text
    var
        GenJournalLine: Record "Gen. Journal Line" temporary;
        CitiBankAPISetup: Record "Citi Bank API Setup";
        Base64Convert: Codeunit "Base64 Convert";
        Base64Value: Text;
    begin
        CitiBankAPISetup.Get();
        Base64Value := Base64Convert.ToBase64(StrSubstNo('%1:%2', CitiBankAPISetup."Client ID", CitiBankAPISetup."Client Secret"), TextEncoding::UTF8);
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

    local procedure GetAuthTokenJsonPayload(): Text
    var
        OAuthTokenObject: JsonObject;
        JSONPayload: JsonObject;
        PayloadString: Text;
    begin
        OAuthTokenObject.Add('grantType', 'client_credentials');
        OAuthTokenObject.Add('scope', '/authenticationservices/v1');
        JSONPayload.Add('oAuthToken', OAuthTokenObject);
        JSONPayload.WriteTo(PayloadString);
        exit(PayloadString);
    end;

    local procedure GetPaymentInitXMLPayload(var GenJournalLine: Record "Gen. Journal Line"): Text
    var
        GeneralJournalBuffer: Record "General Journal Buffer";
        CitiBankAPISetup: Record "Citi Bank API Setup";
        TempBlob: Codeunit "Temp Blob";
        OutputStream: OutStream;
        InputStream: InStream;
        XMLPayload: Text;
        FileName: Text;
        CRLF_lTxt: array[3] of Char;
    begin
        clear(XMLPayload);
        Clear(DebugOutput);
        CitiBankAPISetup.Get();
        GeneralJournalBuffer.GetFromGenJnlLine(GenJournalLine);
        TempBlob.CreateOutStream(OutputStream);
        if GenJournalLine."Payment Transfer Method" = GenJournalLine."Payment Transfer Method"::WIRE then
            Xmlport.Export(Xmlport::"SEPA WIRE pain.001.001.03", OutputStream, GeneralJournalBuffer)
        else
            Xmlport.Export(Xmlport::"SEPA ACH pain.001.001.03", OutputStream, GeneralJournalBuffer);

        GeneralJournalBuffer.DeleteAll();
        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XMLPayload);

        XMLPayload := XMLPayload.Replace('<Document>', '<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">');
        CRLF_lTxt[1] := 10;
        CRLF_lTxt[2] := 13;
        CRLF_lTxt[3] := 9;
        XMLPayload := DELCHR(XMLPayload, '=', CRLF_lTxt[1]);
        XMLPayload := DELCHR(XMLPayload, '=', CRLF_lTxt[2]);
        XMLPayload := DELCHR(XMLPayload, '=', CRLF_lTxt[3]);

        if CitiBankAPISetup."Debug Mode" then begin
            FileName := StrSubstNo('Payment_Init_Request_%1.xml', CurrentDateTime);
            DownloadFromStream(InputStream, '', '', '', FileName);
        end;
        exit(XMLPayload);
    end;

    local procedure GetPaymentStatusPayload(GenJournalLine: Record "Gen. Journal Line"): Text
    var
        Declaration: XmlDeclaration;
        XMLDoc: XmlDocument;
        RootElement: XmlElement;
        EndToEndIdElement: XmlElement;
        EndToEndIdText: XmlText;
        XmlData: Text;
        XmlWriteOptions: XmlWriteOptions;
    begin
        XMLDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'UTF-8', 'yes');
        XMLDoc.SetDeclaration(Declaration);
        RootElement := XmlElement.Create('paymentInquiryRequest');
        EndToEndIdElement := XmlElement.Create('EndToEndId');
        EndToEndIdText := XmlText.Create(GenJournalLine."Payment Request ID");
        EndToEndIdElement.Add(EndToEndIdText);
        RootElement.Add(EndToEndIdElement);
        XMLDoc.Add(RootElement);
        XmlWriteOptions.PreserveWhitespace(false);
        XMLDoc.WriteTo(XmlWriteOptions, XmlData);
        exit(XmlData);
    end;

    var
        RequestErrLbl: Label 'The requested responded with %1 status code and the reason is %2', Comment = '%1= , %2= ';
        EncodedUriLbl: Label '%1?client_id=%2', Comment = '%1 = URL, %2 = client ID';
        PaymentJnlLine: Record "Gen. Journal Line";
        DebugOutput: Text;
}