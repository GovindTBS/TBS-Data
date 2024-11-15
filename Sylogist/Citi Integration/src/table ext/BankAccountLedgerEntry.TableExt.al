tableextension 50146 "Bank Account Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50140; "Beneficiary Currency Code"; Code[10])
        {
            Caption = 'Beneficiary Currency Code';
            Tooltip = 'Specifies the Beneficiary Currency Code.';
            DataClassification = CustomerContent;
            TableRelation = Currency.Code;
        }
    }
}