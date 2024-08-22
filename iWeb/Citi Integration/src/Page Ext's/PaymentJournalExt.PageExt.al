pageextension 50140 "Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addlast(Promoted)
        {
            group("Citi Bank")
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
                    CitiAPIHandler: Codeunit "Citi Intg API Handler";
                begin
                    CitiAPIHandler.InitiatePayment(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CitiIntgSetup.Get();
        IntegrationEnabled := CitiIntgSetup."Integration Enabled";
    end;

    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        IntegrationEnabled: Boolean;
}