tableextension 50143 "Bank Account" extends "Bank Account"
{
    fields
    {
        field(50140; "Citi Bank Account"; Boolean)
        {
            Caption = 'Citi Bank Account';
            ToolTip = 'Specifies wether the account is a Citi Bank Account.';
            DataClassification = CustomerContent;
        }
        field(50141; "ACH Intake Name"; Text[16])
        {
            Caption = 'Citi Bank Account';
            ToolTip = 'Specifies wether the account is a Citi Bank Account.';
            DataClassification = CustomerContent;
        }
    }
}