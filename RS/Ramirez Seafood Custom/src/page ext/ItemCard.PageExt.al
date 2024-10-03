pageextension 50101 "Item Card" extends "Item Card"
{
    layout
    {
        addafter("No.")
        {
            field("Catch Method"; Rec."Catch Method")
            {
                ApplicationArea = All;
            }
        }
    }
}