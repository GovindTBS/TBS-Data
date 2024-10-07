pageextension 50140 "Payment Journal Ext" extends "Payment Journal"
{

    layout
    {
        addafter("Document No.")
        {
            field("Payment Request ID"; Rec."Payment Request ID")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Payment request ID';
            }
        }
    }
    actions
    {
        addlast(Promoted)
        {
            group("Citi Bank")
            {
                Caption = 'Citi Bank';
                actionref(InitiatePayment; "Initiate Payment") { }

                actionref("Check/Post Status"; "Check / Post Status") { }
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
                    PaymentRequestID: Text;
                begin
                    PaymentJournalLine.Reset();
                    CurrPage.SetSelectionFilter(PaymentJournalLine);

                    if PaymentJournalLine.FindFirst() then
                        repeat
                            Clear(PaymentRequestID);
                            PaymentRequestID := Format(CitiAPIHandler.InitiatePayment(PaymentJournalLine));
                            if PaymentRequestID.IndexOfAny('Error') = 0 then begin
                                PaymentJournalLine."Payment Request ID" := PaymentRequestID;
                                PaymentJournalLine.Modify(false);
                            end else
                                Message(PaymentRequestID);

                        until PaymentJournalLine.Next() = 0;

                    Message('%1 payments initiated successfully.', PaymentJournalLine.Count);
                end;
            }
        }

        addlast(processing)
        {
            action("Check / Post Status")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to Check / Post Status the payment.';
                Caption = 'Check / Post Status';
                Image = PostedPayment;
                Visible = IntegrationEnabled;

                trigger OnAction()
                var
                    CitiAPIHandler: Codeunit "Citi Intg API Handler";
                    PaymentStatus: Text;
                    PostedCount: Integer;
                begin
                    PaymentJournalLine.Reset();
                    PostedCount := 0;
                    CurrPage.SetSelectionFilter(PaymentJournalLine);
                    if PaymentJournalLine.FindFirst() then
                        repeat
                            Clear(PaymentStatus);
                            PaymentStatus := CitiAPIHandler.SendEnhancedPaymentStatusInquiry(Rec);
                            if PaymentStatus = 'ACSP' then begin
                                PaymentJournalLine.SendToPosting(Codeunit::"Gen. Jnl.-Post");
                                CurrentJnlBatchName := PaymentJournalLine.GetRangeMax("Journal Batch Name");
                                CurrPage.Update(false);
                                // GenJnlPostLine.RunWithCheck(PaymentJournalLine);
                                PostedCount := PostedCount + 1;
                            end;
                        until PaymentJournalLine.Next() = 0;

                    Message('%1 processed payment''s posted successfully', PostedCount);
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