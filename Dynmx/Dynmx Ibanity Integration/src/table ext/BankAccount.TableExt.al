tableextension 50141 "Bank Account" extends "Bank Account"
{
    fields
    {
        field(50140; "Isabel Account"; Boolean)
        {
            Caption = 'Isabel Account';
            ToolTip = 'Specifies wether the following bank account is a Isabel bank account.';
            DataClassification = CustomerContent;
        }
    }
}