pageextension 50101 ItemCard extends "Item Card"
{
    layout
    {
        addafter("No.")
        {
            field(MyField; Rec."Catch Method")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}