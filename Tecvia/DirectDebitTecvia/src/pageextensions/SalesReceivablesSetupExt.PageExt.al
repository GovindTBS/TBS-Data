pageextension 50143 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Accounts Email ID"; Rec."Accounts Email ID")
            {
                ApplicationArea = all;
            }
        }

    }
}