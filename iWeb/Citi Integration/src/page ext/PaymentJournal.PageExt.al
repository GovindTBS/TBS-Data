pageextension 50140 "Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addlast(processing)
        {
            action("Initiate Payment")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to initiate the payment.';
                Caption = 'Initiate Payment';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = VendorPayment;
                Visible = CitiIntgSetup."Integration Enabled";

                trigger OnAction()
                var
                    CitiIntegration: Codeunit "Citi Integration";
                begin
                    CitiIntegration.InitiatePayment(Rec);
                end;
            }
        }
    }
    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";

    trigger OnOpenPage()
    begin
        CitiIntgSetup.Get();
    end;
}