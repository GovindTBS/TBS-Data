tableextension 50101 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50101; "Shellfish Permit"; Code[20])
        {
            Caption = 'Shellfish Permit';
            ToolTip = 'Specifies the Shellfish Permit no.';
            DataClassification = CustomerContent;
        }
    }
}