codeunit 50100 "Citi Integration"
{

    trigger OnRun()
    var
        CertificateRequest: Codeunit CertificateRequest;
    begin
    end;

    procedure CreateOAuthTokenJson(): Text
    var
        JsonObject: JsonObject;
        JsonSubObject: JsonObject;
        JsonText: Text;
    begin
        JsonSubObject.Add('grantType', 'client_credentials');
        JsonSubObject.Add('scope', '/authenticationservices/v1');
        JsonSubObject.Add('sourceApplication', 'CCF');
        JsonObject.Add('oAuthToken', JsonSubObject);
        JsonObject.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure CreatePaymentInquiryRequestXML(): Text
    var
        XmlDoc: XmlDocument;
        Declaration: XmlDeclaration;
        RootElement: XmlElement;
        XmlData: Text;
    begin
        XmlDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'UTF-8', '');
        XmlDoc.SetDeclaration(Declaration);
        RootElement := XmlElement.Create('paymentInquiryRequest');
        RootElement.SetAttribute('xmlns', 'http://com.citi.citiconnect/services/types/inquiries/payment/v1');
        RootElement.Add(XmlElement.Create('EndToEndId').Add(XmlText.Create('CC21TPH3B8J8H2R')));
        XmlDoc.Add(RootElement);
        XmlDoc.WriteTo(XmlData);
        exit(XmlData);
    end;


    procedure CreateStatementInitiationRequestXML(): Text
    var
        XmlDoc: XmlDocument;
        Declaration: XmlDeclaration;
        RootElement: XmlElement;
        AccountNumberElement: XmlElement;
        FormatNameElement: XmlElement;
        FromDateElement: XmlElement;
        ToDateElement: XmlElement;
        XmlData: Text;
    begin
        XmlDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'UTF-8', '');
        XmlDoc.SetDeclaration(Declaration);
        RootElement := XmlElement.Create('statementInitiationRequest');
        RootElement.SetAttribute('xmlns', 'http://com.citi.citiconnect/services/types/inquiries/statement/v1');
        AccountNumberElement := XmlElement.Create('accountNumber');
        AccountNumberElement.Add(XmlText.Create('12345678'));
        RootElement.Add(AccountNumberElement);
        FormatNameElement := XmlElement.Create('formatName');
        FormatNameElement.Add(XmlText.Create('SWIFT_MT940'));
        RootElement.Add(FormatNameElement);
        FromDateElement := XmlElement.Create('fromDate');
        FromDateElement.Add(XmlText.Create('2018-05-01'));
        RootElement.Add(FromDateElement);
        ToDateElement := XmlElement.Create('toDate');
        ToDateElement.Add(XmlText.Create('2018-05-28'));
        RootElement.Add(ToDateElement);
        XmlDoc.Add(RootElement);
        XmlDoc.WriteTo(XmlData);
        exit(XmlData);
    end;

    procedure CreateStatementRetrievalRequestXML(): Text
    var
        XmlDoc: XmlDocument;
        Declaration: XmlDeclaration;
        RootElement: XmlElement;
        StatementIdElement: XmlElement;
        XmlData: Text;
    begin
        XmlDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'UTF-8', '');
        XmlDoc.SetDeclaration(Declaration);
        RootElement := XmlElement.Create('statementRetrievalRequest');
        RootElement.SetAttribute('xmlns', 'http://com.citi.citiconnect/services/types/attachments/v1');
        StatementIdElement := XmlElement.Create('statementId');
        StatementIdElement.Add(XmlText.Create('111111111'));
        RootElement.Add(StatementIdElement);
        XmlDoc.Add(RootElement);
        XmlDoc.WriteTo(XmlData);
        exit(XmlData);
    end;


}