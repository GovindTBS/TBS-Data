tableextension 50140 "Payment Journal" extends "Payment Journal Line"
{
    fields
    {
        field(50140; "Payment Request ID"; Text[250])
        {
            Caption = 'Payment Request ID';
            ToolTip = 'Specifies the Payment Request ID for the initiated payment.';
        }
        field(50141; "Payment Status"; Text[50])
        {
            Caption = 'Payment Status';
            ToolTip = 'Specifies the Payment Status for the initaited payment';
        }
    }
}