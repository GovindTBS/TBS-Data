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
                ToolTip = 'Specifies the Payment request ID';
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
                actionref(InitiatePayment; "Initiate Payment") { }

                actionref("Check/Post Status"; "Check / Post Status") { }

                actionref("PrivateKey"; "Private Key") { }
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

                    PaymentJournalLine.Reset();
                    CurrPage.SetSelectionFilter(PaymentJournalLine);
                    if PaymentJournalLine.FindFirst() then
                        repeat

                            PaymentJournalLine."Payment Request ID" := Format(CitiAPIHandler.InitiatePayment(PaymentJournalLine));
                            PaymentJournalLine.Modify();
                        until PaymentJournalLine.Next() = 0;

                    Message('Payment Initiation finished');
                end;
            }


            action("Private Key")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to initiate the payment.';
                Caption = 'Initiate Payment';
                Image = VendorPayment;
                Visible = IntegrationEnabled;

                trigger OnAction()
                var
                    CitiEncHandler: Codeunit "Citi Intg Encryption Handler";
                    xmloptions: XmlWriteOptions;
                    key1: Boolean;
                begin
                    CitiEncHandler.SignXmlPayload();
                    CitiEncHandler.EncryptXmlPayload();
                    Message('%1', key1);
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
                    GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                begin
                    PaymentJournalLine.Reset();
                    CurrPage.SetSelectionFilter(PaymentJournalLine);
                    if PaymentJournalLine.FindFirst() then
                        repeat
                            if CitiAPIHandler.SendEnhancedPaymentStatusInquiry(Rec) = 'ACSP' then
                                GenJnlPostLine.Run(PaymentJournalLine);
                        until PaymentJournalLine.Next() = 0;

                    Message('Processed Payment Posted Successfully');
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