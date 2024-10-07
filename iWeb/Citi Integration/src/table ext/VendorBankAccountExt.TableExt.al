tableextension 50141 "Vendor Bank Account Ext" extends "Vendor Bank Account"
{
    fields
    {
        field(50141; "Purpose Code"; Code[50])
        {
            Caption = 'Purpose Code';
            ToolTip = 'Specifies the purpose code';
            DataClassification = CustomerContent;
        }
    }
}