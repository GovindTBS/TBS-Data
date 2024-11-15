pageextension 50141 "Vendor Bank Account Ext" extends "Vendor Bank Account Card"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Purpose Code"; Rec."Purpose Code")
            {
                ApplicationArea = All;
            }
        }
    }
}