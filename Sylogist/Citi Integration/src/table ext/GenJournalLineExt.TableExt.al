tableextension 50140 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50140; "Payment Request ID"; Text[150])
        {
            Caption = 'Payment Request ID';
            Tooltip = 'Specifies the Payment request ID for the initaited Citi bank payment to vendor.';
            DataClassification = CustomerContent;
        }

        field(50141; "Payment Status Code"; Code[5])
        {
            Caption = 'Payment Status Code';
            Tooltip = 'Specifies the Payment Status Code for Citi bank payment to vendor.';
            DataClassification = CustomerContent;
        }

        field(50142; "Payment Status Information"; Code[150])
        {
            Caption = 'Payment Status Information';
            Tooltip = 'Specifies the Payment Status Information.';
            DataClassification = CustomerContent;
        }

        field(50143; "Payment Transfer Method"; Enum "Payment Method Transfer")
        {
            Caption = 'Payment Transfer Method';
            Tooltip = 'Specifies the Payment Transfer Method.';
            DataClassification = CustomerContent;
        }
        field(50144; "Beneficiary Currency Code"; Code[10])
        {
            Caption = 'Beneficiary Currency Code';
            Tooltip = 'Specifies the Beneficiary Currency Code.';
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
    }

    trigger OnDelete()
    begin
        if ("Payment Request ID" <> '') and ("Payment Status Code" <> 'RJCT') then
            Error('Cannot delete an initiated payment');
    end;
}