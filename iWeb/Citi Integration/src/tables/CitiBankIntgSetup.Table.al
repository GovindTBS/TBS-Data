table 50140 "Citi Bank Intg. Setup"
{
    Caption = 'Citi Integration Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }

        field(2; "Client ID"; Code[35])
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
        }

        field(3; "Client Secret"; Code[50])
        {
            Caption = 'Client Secret';
            DataClassification = CustomerContent;
        }

        field(4; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
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
    }
}