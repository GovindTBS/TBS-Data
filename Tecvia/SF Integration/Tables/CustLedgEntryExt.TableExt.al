tableextension 50141 "Cust Ledg Entry Ext" extends "Cust. Ledger Entry" //OriginalId
{
    fields
    {
        field(50140; "SF Bank Statement ID"; Text[20])
        {
            Caption = 'SF Bank Statement ID';
            ToolTip = 'Specifies the Bank Statement entry ID in Salesforce.';
        }
    }
}
