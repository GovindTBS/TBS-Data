table 50140 "Citi Bank Intg. Setup"
{
    Caption = 'Citi Integration Setup';
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
            ToolTip = 'Specifies the client id for the Citi bank API authorization.';
        }

        field(3; "Client Secret"; Text[50])
        {
            Caption = 'Client Secret';
            ToolTip = 'Specifies the client secret for the Citi bank API authorization.';
        }

        field(4; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
            ToolTip = 'Specifies wether the integration is enabled or not.';
        }

        field(5; "Token Expires At"; DateTime)
        {
            Caption = 'Token Expires At';
            ToolTip = 'Specifies the Token Expires at time.';
        }

        field(6; "Auth Token"; Text[1024])
        {
            Caption = 'Auth Token';
            ToolTip = 'Specifies the auth token.';
        }

        field(7; "Sign And Encrypt Function"; Text[200])
        {
            ToolTip = 'Specifies the url for Sign And Encrypt Function.';
            Caption = 'Sign and Encrypt function';
        }

        field(8; "Decrypt And Verify Function"; Text[200])
        {
            ToolTip = 'Specifies the url for Decrypt And Verify Function';
            Caption = 'Decrypt And Verify function';
        }

        field(9; "Auth Token Endpoint"; Text[1000])
        {
            ToolTip = 'The Auth Token Endpoint for the Citi bank API authorization.';
            Caption = 'Auth Token Endpoint';
        }

        field(10; "Payment Initiation Endpoint"; Text[1000])
        {
            ToolTip = 'The Payment Initiation Endpoint for the Citi bank API authorization.';
            Caption = 'Payment Initiation Endpoint';
        }

        field(11; "Payment Status Endpoint"; Text[1000])
        {
            ToolTip = 'The Payment Status Endpoint for the Citi bank API authorization.';
            Caption = 'Payment Status Endpoint';
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
