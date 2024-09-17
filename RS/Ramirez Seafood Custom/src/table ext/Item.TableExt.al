tableextension 50100 "Item Ext" extends Item
{
    fields
    {
        field(50100; "Catch Method"; Enum "Catch Method")
        {
            Caption = 'Catch Method';
            ToolTip = 'Specifies the Catch Method for the item.';
            DataClassification = CustomerContent;
        }
    }
}