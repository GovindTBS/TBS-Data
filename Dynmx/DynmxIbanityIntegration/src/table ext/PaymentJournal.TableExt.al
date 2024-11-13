namespace Isabel6;

using Microsoft.Bank.Payment;

tableextension 50140 "Payment Journal" extends "Payment Journal Line"
{
    fields
    {
        field(50140; "Payment Request ID"; Text[250])
        {
            Caption = 'Payment Request ID';
            ToolTip = 'Specifies the Payment Request ID for the initiated payment.';
            DataClassification = CustomerContent;
        }
        field(50141; "Payment Status"; Text[50])
        {
            Caption = 'Payment Status';
            ToolTip = 'Specifies the Payment Status for the initaited payment';
            DataClassification = CustomerContent;
        }
    }

    trigger OnDelete()
    begin
        if ("Payment Request ID" <> '') then
            case "Payment Status" of
                'not-processed':
                    Error('Cannot delete payments under processing');
                'processed-ok':
                    Error('Cannot delete processed payments');
            end;

    end;
}