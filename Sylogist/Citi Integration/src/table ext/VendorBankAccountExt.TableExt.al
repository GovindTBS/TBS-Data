tableextension 50141 "Vendor Bank Account Ext" extends "Vendor Bank Account"
{
    fields
    {
        field(50141; "Purpose Code"; Code[150])
        {
            Caption = 'Purpose Code';
            Tooltip = 'Specifies the purpose code for the vendor bank account.';
            DataClassification = CustomerContent;
        }

        field(50142; "Intermediary Bank Name"; Code[200])
        {
            Caption = 'Intermediary Bank Name';
            Tooltip = 'Specifies the Intermediary Bank Name for the vendor bank account.';
            DataClassification = CustomerContent;
        }

        field(50143; "Interemdiary SWIFT"; Code[50])
        {
            Caption = 'Interemdiary SWIFT';
            Tooltip = 'Specifies the Interemdiary SWIFT for the vendor bank account.';
            DataClassification = CustomerContent;
        }

        field(50144; "Intermediary Country"; Code[50])
        {
            Caption = 'Intermediary Country';
            Tooltip = 'Specifies the Interemdiary Country for the vendor bank account.';
            DataClassification = CustomerContent;
        }
    }
}