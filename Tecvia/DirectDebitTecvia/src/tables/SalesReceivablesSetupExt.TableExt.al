tableextension 50146 "Sales Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50140; "Accounts Email ID"; Code[50])
        {
            Caption = 'Accounts Email ID';
            ToolTip = 'Specifies the accounts team email-id.';
            ExtendedDatatype = EMail;
        }
    }
}