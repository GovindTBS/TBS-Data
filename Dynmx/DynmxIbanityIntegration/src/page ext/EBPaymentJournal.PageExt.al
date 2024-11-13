namespace Isabel6;

using Microsoft.Bank.Payment;
using Microsoft.Bank.BankAccount;
using System.Security.User;
using System.Utilities;

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
                    PaymentJournalLine: Record "Payment Journal Line";
                    BankAccount: Record "Bank Account";
                    TempBlob: Codeunit "Temp Blob";
                    IsabelAPIMgt: Codeunit "Isabel6 Payment API Mgt.";
                    Payments: Text;
                    OutputStream: OutStream;
                begin
                    TempBlob.CreateOutStream(OutputStream);
                    PaymentJournalLine.Reset();
                    PaymentJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    PaymentJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    PaymentJournalLine.SetFilter("Payment Request ID", '=%1', '');
                    if PaymentJournalLine.FindSet() then
                        repeat
                            PaymentJournalLine.TestField("Bank Account");
                            PaymentJournalLine.TestField("Beneficiary Bank Account");
                            BankAccount.Get(PaymentJournalLine."Bank Account");
                            BankAccount.TestField("Isabel Account", true);
                            IsabelAPIMgt.PaymentsInitiation(PaymentJournalLine, Payments);
                        until PaymentJournalLine.Next() = 0;
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
                    PaymentJournalLine: Record "Payment Journal Line";
                    IsabelAPIMgt: Codeunit "Isabel6 Payment API Mgt.";
                begin
                    PaymentJournalLine.Reset();
                    PaymentJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    PaymentJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if PaymentJournalLine.FindSet() then
                        repeat
                            if PaymentJournalLine."Payment Request ID" <> '' then
                                IsabelAPIMgt.GetPaymentsStatus(PaymentJournalLine);
                        until PaymentJournalLine.Next() = 0;
                end;
            }

            action(ExportPayment)
            {
                ApplicationArea = All;
                Caption = 'Export Payment';
                Image = SettleOpenTransactions;
                ToolTip = 'Allows you to Export Payment for payment request to Isabel.';
                Visible = IntegrationEnabled;
                trigger OnAction()
                var
                    ExportProtocol: Record "Export Protocol";
                begin
                    if ExportProtocolCode = '' then
                        Error('Please set an Export Protocol filter on the payment journal.');
                    ExportProtocol.Get(ExportProtocolCode);
                    ExportProtocol.ExportPaymentLine(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        IsabelAPISetup: Record "Isabel6 Setup";
        UserSetup: Record "User Setup";
    begin
        IsabelAPISetup.Get();
        UserSetup.Get(UserId);
        if IsabelAPISetup."Integration Enabled" and UserSetup."Allow Isabel Payments" then
            IntegrationEnabled := true;
    end;

    var
        IntegrationEnabled: Boolean;
}
