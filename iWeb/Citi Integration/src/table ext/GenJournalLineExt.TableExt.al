tableextension 50140 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50140; "Payment Request ID"; Text[150])
        {
            Caption = 'Payment Request ID';
            ToolTip = 'Specifies the Payment request ID.';
            DataClassification = CustomerContent;
        }
    }
}