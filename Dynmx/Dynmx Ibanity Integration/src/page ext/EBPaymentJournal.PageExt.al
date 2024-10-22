pageextension 50140 "EB Payment Journal" extends "EB Payment Journal"
{
    layout
    {
        addafter("Payment Message")
        {
            field("Payment Request ID"; Rec."Payment Request ID")
            {
                ApplicationArea = all;
            }
            field("Payment Status"; Rec."Payment Status")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(CheckPaymentLines_Promoted)
        {
            actionref(Send_ToIsabel; SendToIsabel)
            {
            }
        }

        addafter(CheckPaymentLines)
        {
            action(SendToIsabel)
            {
                ApplicationArea = All;
                Caption = 'Send to Isabel';
                Image = SettleOpenTransactions;
                ToolTip = 'Allows you to send to payment request to Isabel.';
                Visible = IntegrationEnabled;
                trigger OnAction()
                var
                    IsabelAPIMgt: Codeunit "Isabel Payment API Mgt.";
                begin
                    // IsabelAPIMgt.CertificateAndHash();
                    IsabelAPIMgt.PaymentsInitiation(Rec);
                end;
            }
            action(CheckStatus)
            {
                ApplicationArea = All;
                Caption = 'Check Payment Status';
                Image = SettleOpenTransactions;
                ToolTip = 'Allows you to Check Payment Status for payment request to Isabel.';
                Visible = IntegrationEnabled;
                trigger OnAction()
                var
                    IsabelAPIMgt: Codeunit "Isabel Payment API Mgt.";
                begin
                    IsabelAPIMgt.GetPaymentsStatus(Rec);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        IsabelAPiSetup: Record "Isabel6 Setup";
    begin
        IsabelAPiSetup.Get();
        IntegrationEnabled := IsabelAPiSetup."Integration Enabled";
    end;

    var
        IntegrationEnabled: Boolean;
}
