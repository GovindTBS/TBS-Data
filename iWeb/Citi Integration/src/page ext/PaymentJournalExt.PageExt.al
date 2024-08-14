pageextension 50140 "Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addlast(Promoted)
        {
            group("Citi")
            {
                actionref(InitiatePayment; "Initiate Payment") { }
            }
        }

        addlast(processing)
        {
            action("Initiate Payment")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to initiate the payment.';
                Caption = 'Initiate Payment';
                Image = VendorPayment;
                Visible = IntegrationEnabled;

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
        IntegrationEnabled: Boolean;

    trigger OnOpenPage()
    begin
        CitiIntgSetup.Get();
        IntegrationEnabled := CitiIntgSetup."Integration Enabled";
    end;
}