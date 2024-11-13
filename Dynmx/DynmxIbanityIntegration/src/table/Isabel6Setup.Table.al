namespace Isabel6;

table 50100 "Isabel6 Setup"
{
    Caption = 'Isabel Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary key';
            NotBlank = false;
            DataClassification = CustomerContent;
        }
        field(2; "Isabel6 Auth Token Endpoint"; Text[200])
        {
            Caption = 'Auth Token Endpoint';
            ToolTip = 'Specifies Auth Token Endpoint URL for the Isabel6 API.';
        }
        field(3; "SSL Certificate Value"; Blob)
        {
            Caption = 'Value';
            ToolTip = 'Specifies the SSL Certificate BLOB value.';
        }
        field(4; "SSL Certificate Uploaded"; Boolean)
        {
            Caption = 'SSL Certificate Uploaded';
            ToolTip = 'Specifies if the SSL certificate is uploaded.';
        }
        field(5; "SSL Certificate Password"; Text[100])
        {
            Caption = 'SSL Certificate Password';
            ToolTip = 'Specifies the password of the SSL Certificate.';
            ExtendedDatatype = Masked;
        }
        field(6; "SSL Certificate File"; Text[50])
        {
            Caption = 'SSL Certificate File';
            ToolTip = 'Specifies the name of the certificate file.';
        }
        field(7; "Isabel6 Client ID"; Text[40])
        {
            Caption = 'Client ID';
            ToolTip = 'Specifies the client id for the Citi bank API authorization.';
        }
        field(8; "Isabel6 Client Secret"; Text[50])
        {
            Caption = 'Client Secret';
            ToolTip = 'Specifies the client secret for the Citi bank API authorization.';
            ExtendedDatatype = Masked;
        }
        field(9; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
            ToolTip = 'Specifies if the payments integration is enabled or not.';
        }
        field(10; "Authorization Code"; Text[100])
        {
            Caption = 'Authorization Code';
            ToolTip = 'Specifies the Authorization code provided during the user linking process.';
        }
        field(11; "Isabel6 Auth Token"; Text[100])
        {
            Caption = 'Auth Token';
            ToolTip = 'Specifies the Authorization Token for Isabel6 API access.';
        }
        field(12; "Payment Initiation Endpoint"; Text[100])
        {
            Caption = 'Payment Initiation Endpoint';
            ToolTip = 'Specifies Payment Initiation Endpoint URL for the Isabel6 API.';
        }
        field(13; "Payment Status Endpoint"; Text[100])
        {
            Caption = 'Payment Status Endpoint';
            ToolTip = 'Specifies Payment Status Endpoint URL for the Isabel6 API.';
        }
        field(14; "Accounting Office Endpoint"; Text[100])
        {
            Caption = 'Accounting Office Endpoint';
            ToolTip = 'Specifies Accounting Office Endpoint URL for the Codabox API.';
        }
        field(15; "Document Search Endpoint"; Text[100])
        {
            Caption = 'Document Search Endpoint';
            ToolTip = 'Specifies Document Search Endpoint URL for the Codabox API.';
        }
        field(16; "Account Statement Endpoint"; Text[100])
        {
            Caption = 'Account Statement Endpoint';
            ToolTip = 'Specifies Account Statement Endpoint URL for the Codabox API.';
        }
        field(17; "Accounting Office Company No."; Text[50])
        {
            Caption = 'Accounting Office Company Number';
            ToolTip = 'Specifies Accounting Office Company Number for the Codabox API.';
        }
        field(18; "Accounting Office Consent ID"; Text[50])
        {
            Caption = 'Accounting Office ID';
            ToolTip = 'Specifies Accounting Office ID for the Codabox API.';
        }
        field(19; "Codabox Client ID"; Text[40])
        {
            Caption = 'Client ID';
            ToolTip = 'Specifies the client id for the Codabox API authorization.';
        }
        field(20; "Codabox Client Secret"; Text[50])
        {
            Caption = 'Client Secret';
            ToolTip = 'Specifies the client secret for the Codabox API authorization.';
            ExtendedDatatype = Masked;
        }
        field(21; "Codabox Auth Token Endpoint"; Text[200])
        {
            Caption = 'Auth Token Endpoint';
            ToolTip = 'Specifies Auth Token Endpoint URL for the Codabox API.';
        }
        field(22; "Codabox Auth Token"; Text[100])
        {
            Caption = 'Auth Token';
            ToolTip = 'Specifies the Authorization Token for Codabox API access.';
        }
        field(23; "Accounting Office ID"; Text[50])
        {
            Caption = 'Accounting Office ID';
            ToolTip = 'Specifies Accounting Office ID for the Codabox API.';
        }
        field(24; "Codabox Auth Token Expires"; DateTime)
        {
            Caption = 'Accounting Office ID';
            ToolTip = 'Specifies Accounting Office ID for the Codabox API.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}