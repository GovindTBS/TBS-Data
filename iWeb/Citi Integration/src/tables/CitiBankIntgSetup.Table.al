table 50140 "Citi Bank Intg. Setup"
{
    Caption = 'Citi Integration Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        field(2; "Client ID"; Code[35])
        {
            Caption = 'Client ID';
        }

        field(3; "Client Secret"; Code[50])
        {
            Caption = 'Client Secret';
        }

        field(4; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
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