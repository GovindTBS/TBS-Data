namespace Isabel6;

using Microsoft.Bank.Payment;
using Microsoft.Finance.Currency;
using Microsoft.Bank.BankAccount;

table 50141 "Payment Journal Buffer"
{
    Caption = 'Payment Journal Buffer';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Payment Journal Template";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(14; Amount; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(19; "Beneficiary Bank Account"; Code[20])
        {
            Caption = 'Beneficiary Bank Account';
        }
        field(22; "Bank Account"; Code[20])
        {
            Caption = 'Bank Account';
            TableRelation = "Bank Account";
        }
        field(51; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Paym. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure GetFromPaymentJnlLine(PaymentJournalLine: Record "Payment Journal Line")
    begin
        TransferFields(PaymentJournalLine);
        Insert();
    end;
}
