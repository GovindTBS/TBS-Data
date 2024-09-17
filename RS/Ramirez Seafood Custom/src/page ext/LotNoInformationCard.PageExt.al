pageextension 50143 "Lot No Information Card Ext" extends "Lot No. Information Card"
{
    layout
    {
        addlast(General)
        {
            field(Location; Rec.Location)
            {
                ApplicationArea = All;
            }

            field(Date; Rec.Date)
            {
                ApplicationArea = All;
            }

        }
    }

}