table 50100 "Isabel API Setup"
{
    Caption = 'Isabel API Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary key';
            NotBlank = false;
            DataClassification = CustomerContent;
        }
        field(2; "Auth Token Endpoint"; Text[200])
        {
            Caption = 'Auth Token Endpoint';
            ToolTip = 'Specifies Auth Token Endpoint URL for the Isabel API.';
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
        field(7; "Client ID"; Text[40])
        {
            Caption = 'Client ID';
            ToolTip = 'Specifies the client id for the Citi bank API authorization.';
        }
        field(8; "Client Secret"; Text[50])
        {
            Caption = 'Client Secret';
            ToolTip = 'Specifies the client secret for the Citi bank API authorization.';
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
        field(11; "Auth Token"; Text[100])
        {
            Caption = 'Auth Token';
            ToolTip = 'Specifies the Authorization Token for Isabel API access.';
        }
        field(12; "Payment Initiation Endpoint"; Text[100])
        {
            Caption = 'Payment Initiation Endpoint';
            ToolTip = 'Specifies Payment Initiation Endpoint URL for the Isabel API.';
        }
        field(13; "Payment Status Endpoint"; Text[100])
        {
            Caption = 'Payment Status Endpoint';
            ToolTip = 'Specifies Payment Status Endpoint URL for the Isabel API.';
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