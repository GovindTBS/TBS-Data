pageextension 50143 "Bank Account" extends "Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Citi Bank Account"; Rec."Citi Bank Account")
            {
                ApplicationArea = All;
                Caption = 'Citi Bank Account';
            }
            field("ACH Intake Name"; Rec."ACH Intake Name")
            {
                ApplicationArea = All;
                Caption = 'ACH Intake Name';
            }
        }
    }
}