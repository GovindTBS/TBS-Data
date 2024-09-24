tableextension 50142 "Lot No Information Ext" extends "Lot No. Information"
{
    fields
    {
        field(50100; "Location"; Code[50])
        {
            Caption = 'Location';
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the location for the lot.';
        }

        field(50101; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the date for the lot assigned.';
        }
    }

}