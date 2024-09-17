pageextension 50102 "Company Information Ext" extends "Company Information"
{
    layout
    {
        addlast(General)
        {
            field("Shellfish Permit"; Rec."Shellfish Permit")
            {
                ApplicationArea = All;
            }
        }
    }
}