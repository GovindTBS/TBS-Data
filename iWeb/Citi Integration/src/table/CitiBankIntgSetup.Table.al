table 50140 "Citi Bank Intg. Setup"
{
    Caption = 'Citi Integration Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            NotBlank = false;
            AllowInCustomizations = Never;
            DataClassification = CustomerContent;
        }

        field(2; "Client ID"; Text[40])
        {
            Caption = 'Client ID';
            ToolTip = 'Specifies the client id for the Citi bank API authorization.';
            DataClassification = CustomerContent;
        }

        field(3; "Client Secret"; Text[50])
        {
            Caption = 'Client Secret';
            ToolTip = 'Specifies the client secret for the Citi bank API authorization.';
            DataClassification = CustomerContent;
        }

        field(4; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
            ToolTip = 'Specifies wether the integration is enabled or not.';
            DataClassification = CustomerContent;
        }

        field(5; "Token Expires At"; Time)
        {
            Caption = 'Token Expires At';
            DataClassification = CustomerContent;
        }

        field(6; "Auth Token"; Text[1000])
        {
            Caption = 'Auth Token';
            DataClassification = CustomerContent;
        }

        field(7; "Sign And Encrypt Function"; Text[200])
        {
            ToolTip = 'Specifies the url for Sign And Encrypt Function.';
            Caption = 'Sign and Encrypt function';
            DataClassification = CustomerContent;
        }

        field(8; "Decrypt And Verify Function"; Text[200])
        {
            ToolTip = 'Specifies the url for Decrypt And Verify Function';
            Caption = 'Decrypt And Verify function';
            DataClassification = CustomerContent;
        }

        field(9; "Auth Token Endpoint"; Text[1000])
        {
            ToolTip = 'The Auth Token Endpoint for the Citi bank API authorization.';
            Caption = 'Auth Token Endpoint';
            DataClassification = CustomerContent;
        }

        field(10; "Payment Initiation Endpoint"; Text[1000])
        {
            ToolTip = 'The Payment Initiation Endpoint for the Citi bank API authorization.';
            Caption = 'Auth Token Endpoint';
            DataClassification = CustomerContent;
        }

        field(11; "Payment Status Endpoint"; Text[1000])
        {
            ToolTip = 'The Payment Status Endpoint for the Citi bank API authorization.';
            Caption = 'Auth Token Endpoint';
            DataClassification = CustomerContent;
        }
    }
}
