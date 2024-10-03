tableextension 50142 "Lot No Information" extends "Lot No. Information"
{
    fields
    {
        field(50100; "Harvest Location"; Text[50])
        {
            Caption = 'Harvest Location';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the harvest location for the lot.';
        }

        field(50101; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the date for the lot assigned.';
        }
    }

}