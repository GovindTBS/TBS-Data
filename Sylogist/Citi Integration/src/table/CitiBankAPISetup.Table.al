table 50140 "Citi Bank API Setup"
{
    Caption = 'Citi Bank API Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }

        field(2; "Client ID"; Text[40])
        {
            Caption = 'Client ID';
            Tooltip = 'Specifies the client id for the Citi bank API authorization.';
        }

        field(3; "Client Secret"; Text[50])
        {
            Caption = 'Client Secret';
            Tooltip = 'Specifies the client secret for the Citi bank API authorization.';
        }

        field(4; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
            Tooltip = 'Specifies if the payments integration is enabled or not.';
        }

        field(5; "Token Expires At"; DateTime)
        {
            Caption = 'Token Expires At';
            Tooltip = 'Specifies the Token Expires at time.';
        }

        field(6; "Auth Token"; Text[1024])
        {
            Caption = 'Auth Token';
            Tooltip = 'Specifies the auth token.';
        }

        field(7; "Sign And Encrypt URL"; Text[200])
        {
            Caption = 'Sign and Encrypt URL';
            Tooltip = 'Specifies the url for Sign And Encrypt trigger url.';
        }

        field(8; "Decrypt And Verify URL"; Text[200])
        {
            Caption = 'Decrypt And Verify URL';
            Tooltip = 'Specifies the url for Decrypt And Verify trigger url.';
        }

        field(9; "Auth Token Endpoint"; Text[1000])
        {
            Caption = 'Auth Token Endpoint';
            Tooltip = 'The Auth Token Endpoint for the Citi bank API authorization.';
        }

        field(10; "Payment Initiation Endpoint"; Text[1000])
        {
            Tooltip = 'The Payment Initiation Endpoint for the Citi bank API authorization.';
            Caption = 'Payment Initiation Endpoint';
        }

        field(11; "Payment Status Endpoint"; Text[1000])
        {
            Tooltip = 'The Payment Status Endpoint for the Citi bank API authorization.';
            Caption = 'Payment Status Endpoint';
        }

        field(12; "SSL Certificate Value"; Blob)
        {
            Caption = 'Value';
            Tooltip = 'Specifies the SSL Certificate BLOB value.';
        }

        field(13; "SSL Certificate Uploaded"; Boolean)
        {
            Caption = 'SSL Certificate Uploaded';
            Tooltip = 'Specifies if the SSL certificate is uploaded.';
        }

        field(14; "SSL Certificate Password"; Text[100])
        {
            Caption = 'SSL Certificate Password';
            Tooltip = 'Specifies the password of the SSL Certificate.';
            ExtendedDatatype = Masked;
        }
        field(15; "SSL Certificate File"; Text[50])
        {
            Caption = 'SSL Certificate File';
            Tooltip = 'Specifies the name of the certificate file.';
        }
        field(17; "Payment Request ID No's"; Code[80])
        {
            Caption = 'Payment Request ID No''s';
            Tooltip = 'Specifies the No''s that is used to assign the payment request id from the sequence.';
            TableRelation = "No. Series".Code;
        }
        field(18; "Debug Mode"; Boolean)
        {
            Caption = 'Debug Mode';
            Tooltip = 'Specifies if the debug mode is enabled for citi integration this will allow to download the payment request and response files.';
        }
        field(19; "Message ID No's"; Code[80])
        {
            Caption = 'Message ID No''s';
            Tooltip = 'Specifies the No''s that is used to assign the payment request id from the sequence.';
            TableRelation = "No. Series".Code;
        }
        field(20; "Payment Instruction ID No's"; Code[80])
        {
            Caption = 'Payment Instruction ID No''s';
            Tooltip = 'Specifies the No''s that is used to assign the payment request id from the sequence.';
            TableRelation = "No. Series".Code;
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
