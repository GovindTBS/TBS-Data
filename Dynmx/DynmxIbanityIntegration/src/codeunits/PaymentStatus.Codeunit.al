
namespace Isabel6;

using Microsoft.Bank.Payment;

codeunit 50103 "Payment Status"
{
    trigger OnRun()
    var
        PaymentJournalLine: Record "Payment Journal Line";
        IsabelAPIMgt: Codeunit "Isabel6 Payment API Mgt.";
    begin
        PaymentJournalLine.Reset();
        PaymentJournalLine.SetRange("Journal Template Name", 'DEFAULT');
        PaymentJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if PaymentJournalLine.FindSet() then
            repeat
                if PaymentJournalLine."Payment Request ID" <> '' then
                    IsabelAPIMgt.GetPaymentsStatus(PaymentJournalLine);
            until PaymentJournalLine.Next() = 0;
    end;
}