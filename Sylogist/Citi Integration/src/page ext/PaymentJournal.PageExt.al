pageextension 50140 "Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field(PaymentTransferMethod; Rec."Payment Transfer Method")
            {
                ApplicationArea = all;
                Caption = 'Payment Transfer Method';
            }
            field(PaymentRequestID; Rec."Payment Request ID")
            {
                ApplicationArea = All;
                Caption = 'Payment request ID';
            }
            field(PaymentStatusCode; Rec."Payment Status Code")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Payment Status';
            }
            field("Payment Status Information"; Rec."Payment Status Information")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Payment Status Information';
            }
        }

        addafter(Amount)
        {
            field("Beneficiary Currency Code"; Rec."Beneficiary Currency Code")
            {
                ApplicationArea = All;
                AssistEdit = true;
                Caption = 'Beneficiary Currency Code';
            }
        }

        modify("Currency Code")
        {
            Visible = false;
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
                    BankAccount: Record "Bank Account";
                    VendorBankAccount: Record "Vendor Bank Account";
                    GenJournalLine: Record "Gen. Journal Line";
                    CheckLedgerEntry: Record "Check Ledger Entry";
                    CitiBankAPISetup: Record "Citi Bank API Setup";
                    CitiBankAPIManagement: Codeunit "Citi Bank API Management";
                    PaymentRequestID: Text;
                    InitiatedCount: Integer;
                begin
                    InitiatedCount := 0;
                    CitiBankAPISetup.Get();
                    GenJournalLine.Copy(Rec);
                    CurrPage.SetSelectionFilter(GenJournalLine);
                    if GenJournalLine.FindSet() then
                        repeat
                            Rec.TestField("Payment Transfer Method");
                            if (GenJournalLine."Payment Request ID" <> '') then
                                break;
                            BankAccount.Get(GenJournalLine."Bal. Account No.");
                            if not BankAccount."Citi Bank Account" then
                                Error('Bal. Account must be a Citi Bank Account. %1 is not a Citi Bank Account.', GenJournalLine."Bal. Account No.");
                            VendorBankAccount.Get(GenJournalLine."Account No.", GenJournalLine."Recipient Bank Account");
                            if (GenJournalLine."Payment Transfer Method" = GenJournalLine."Payment Transfer Method"::ACH) and (VendorBankAccount."Transit No." = '') then
                                Error('Value of Transit No. is not available for bank account %1', GenJournalLine."Recipient Bank Account");
                            if (GenJournalLine."Payment Transfer Method" = GenJournalLine."Payment Transfer Method"::WIRE) and (VendorBankAccount."SWIFT Code" = '') then
                                Error('Value of SWIFT code is not available for bank account %1', GenJournalLine."Recipient Bank Account");

                            PaymentRequestID := Format(CitiBankAPIManagement.InitiatePayment(GenJournalLine));
                            if (PaymentRequestID <> '') and (PaymentRequestID.IndexOfAny('Error') = 0) then begin
                                InsertCheckLedgerEntry(GenJournalLine);
                                GenJournalLine."Payment Request ID" := PaymentRequestID;
                                GenJournalLine.Modify(false);
                                InitiatedCount += 1;
                            end;
                        until GenJournalLine.Next() = 0;
                    Message('%1 payments initiated successfully.', InitiatedCount);
                end;
            }
        }

        addlast(processing)
        {
            action("Check / Post Status")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to Check and Post the payment transaction if the status is ACSP.';
                Caption = 'Check / Post Payments';
                Image = PostedPayment;
                Visible = IntegrationEnabled;

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    CitiBankAPISetup: Record "Citi Bank API Setup";
                    CitiBankAPIManagement: Codeunit "Citi Bank API Management";
                    PaymentStatus: Text;
                    PendingCount: Integer;
                    RejectCount: Integer;
                    SuccessCount: Integer;
                begin
                    GenJournalLine.Copy(Rec);
                    CurrPage.SetSelectionFilter(GenJournalLine);
                    if GenJournalLine.FindSet() then
                        repeat
                            if (GenJournalLine."Payment Request ID" = '') then
                                break;
                            PaymentStatus := CitiBankAPIManagement.SendEnhancedPaymentStatusInquiry(GenJournalLine);
                            GenJournalLine."Payment Status Code" := PaymentStatus;
                            GenJournalLine.Modify();
                            case PaymentStatus of
                                'ACSP':
                                    begin
                                        GenJournalLine.SendToPosting(Codeunit::"Gen. Jnl.-Post");
                                        CurrentJnlBatchName := GenJournalLine.GetRangeMax("Journal Batch Name");
                                        CurrPage.Update(false);
                                        SuccessCount += 1;
                                    end;
                                'RJCT':
                                    begin
                                        RejectCount += 1;
                                        DeleteRejectedCheckLedgerEntry(GenJournalLine."Document No.")
                                    end;
                                'PDNG':
                                    PendingCount += 1;
                            end;
                        until GenJournalLine.Next() = 0;
                    Message('Status of selected Payment transactions: \ Pending %1 \ Rejected %2 \ Posted %3.', PendingCount, RejectCount, SuccessCount);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CitiBankAPISetup: Record "Citi Bank API Setup";
    begin
        if CitiBankAPISetup.Get() then
            IntegrationEnabled := CitiBankAPISetup."Integration Enabled";
    end;

    local procedure InsertCheckLedgerEntry(GenJournalLine: Record "Gen. Journal Line")
    var
        CheckLedgerEntry: Record "Check Ledger Entry";
        LastNo: Integer;
    begin
        CheckLedgerEntry.FindLast();
        LastNo := CheckLedgerEntry."Entry No.";
        CheckLedgerEntry.Init();
        CheckLedgerEntry."Entry No." := LastNo + 1000;
        CheckLedgerEntry."Check No." := GenJournalLine."Document No.";
        CheckLedgerEntry."Bal. Account No." := GenJournalLine."Bal. Account No.";
        CheckLedgerEntry."Bal. Account Type" := GenJournalLine."Bal. Account Type";
        CheckLedgerEntry.Amount := GenJournalLine.Amount;
        CheckLedgerEntry.Description := GenJournalLine.Description;
        CheckLedgerEntry.Insert();
    end;

    local procedure DeleteRejectedCheckLedgerEntry(CheckNo: Code[20])
    var
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        CheckLedgerEntry.SetRange("Check No.", CheckNo);
        CheckLedgerEntry.FindFirst();
        CheckLedgerEntry."Entry Status" := CheckLedgerEntry."Entry Status"::Voided;
        CheckLedgerEntry.Modify();
    end;

    var
        IntegrationEnabled: Boolean;
}