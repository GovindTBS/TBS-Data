tableextension 50102 "Item Tracing Buffer" extends "Item Tracing Buffer"
{
    fields
    {
        field(50100; "Harvest Location"; Text[50])
        {
            Caption = 'Harvest Location';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Harvest Location for the given item.';
        }

        field(50101; "Harvest Date"; Date)
        {
            Caption = 'Harvest Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Harvest Date for the given item.';
        }

        field(50200; "Certificate No."; Code[20])
        {
            Caption = 'Certificate No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Certificate No. for the given item.';
        }
    }

}