pageextension 50143 "Lot No Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addlast(General)
        {
            field("Harvest Location"; Rec."Harvest Location")
            {
                Caption = 'Harvest Location';
                ApplicationArea = All;
            }

            field(Date; Rec.Date)
            {
                Caption = 'Harvest Date';
                ApplicationArea = All;
            }
        }
    }
}