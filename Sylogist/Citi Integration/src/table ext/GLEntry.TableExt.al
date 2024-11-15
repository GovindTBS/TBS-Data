tableextension 50145 "G/L Entry" extends "G/L Entry"
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