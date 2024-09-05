pageextension 50143 "Bank Acc Rec Ext" extends "Bank Acc. Reconciliation List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Promoted)
        {
            group("Citi Bank")
            {
                actionref(InitiateStatement; "Initiate Statement") { }

            }
        }

        addlast(processing)
        {
            action("Initiate Statement")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to initiate the Statement.';
                Caption = 'Initiate Statement';
                Image = BankAccountLedger;
                Visible = IntegrationEnabled;

                trigger OnAction()
                begin
                    PaymentJournalLine.Reset();

                    Message('Payment Initiation finished');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if CitiIntgSetup.Get() then
            IntegrationEnabled := CitiIntgSetup."Integration Enabled";
    end;

    var
        PaymentJournalLine: Record "Gen. Journal Line";
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        IntegrationEnabled: Boolean;
}