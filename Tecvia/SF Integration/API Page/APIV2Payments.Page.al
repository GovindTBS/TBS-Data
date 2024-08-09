page 50146 "APIV2 - Payments"
{
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'tecvia';
    APIGroup = 'firstMile';
    EntitySetCaption = 'Payment';
    EntityCaption = 'Payments';
    EntityName = 'payments';
    EntitySetName = 'payment';
    ODataKeyFields = SystemId;
    SourceTable = "Gen. Journal Line";
    DelayedInsert = true;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(journalId; Rec."Journal Batch Id")
                {
                    Caption = 'Journal Id';
                }
                field(journalDisplayName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Display Name';
                }
                field(lineNumber; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNumber; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(accountType; Rec."Account Type")
                {
                    Caption = 'Account Type';
                }
                field(accountNo; Rec."Account No.")
                {
                    Caption = 'Account No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(amountLCY; Rec."Amount (LCY)")
                {
                    Caption = 'Amount';
                }
                field(balAccountType; Rec."Bal. Account Type")
                {
                    Caption = 'Balance Account Type';
                }
                field(balAccountNumber; Rec."Bal. Account No.")
                {
                    Caption = 'Bal. Account No.';
                }
                field(appliesToDocType; Rec."Applies-to Doc. Type")
                {
                    Caption = 'Applies to Document No.';
                }
                field(appliesToDocNumber; Rec."Applies-to Doc. No.")
                {
                    Caption = 'Applies to Document No.';
                }
                field(appliedDocNumbers; Rec."Applied Doc Numbers")
                {
                    Caption = 'Applies to Document Numbers';
                }
                field(orderNumbers; OrderNumber)
                {
                    Caption = 'Order Number';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }
                part(dimensionSetLines; "APIV2 - Dimension Set Lines")
                {
                    Caption = 'Dimension Set Lines';
                    EntityName = 'dimensionSetLine';
                    EntitySetName = 'dimensionSetLines';
                    SubPageLink = "Parent Id" = field(SystemId), "Parent Type" = const("Journal Line");
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Journal Template Name" := 'CASHRCPT';
        Rec.Validate("Journal Batch Name", 'GENERAL');
        Rec."Line No." := Rec.GetNewLineNo(Rec."Journal Template Name", Rec."Journal Batch Name");
        Rec.Validate("Document Type", Rec."Document Type"::Payment);
        Rec.Validate("Account Type", Rec."Account Type"::"Bank Account");
        Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::Customer);
        Rec."Keep Description" := true;
        Rec."Applies-to Doc. Type" := Rec."Applies-to Doc. Type"::Invoice;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ApplypaymentEntries: Codeunit "Apply Payment Entries";
    begin
        ValidateValues();
        Rec."Applies-to ID" := Rec."Document No.";

        if OrderNumber <> '' then
            Rec.validate("Applies-to Doc. No.", GetInvoiceNumberByOrderNumber(OrderNumber));

        ApplypaymentEntries.ApplyDocuments(Rec);

        exit(true);
    end;

    local procedure GetInvoiceNumberByOrderNumber(OrderNo: Code[20]): Code[20]
    var
        PostedSalesInvoices: Record "Sales Invoice Header";
    begin
        PostedSalesInvoices.SetRange("Order No.", OrderNo);
        if PostedSalesInvoices.FindFirst() then
            exit(PostedSalesInvoices."No.")
        else
            exit('');
    end;

    local procedure ValidateValues()
    var
        CashRcptJnl: Record "Gen. Journal Line";
        PostingDateBlankErr: Label 'Posting Date is required.';
        DocumentNoBlankErr: Label 'Document No is required.';
        AmountEmptyErr: Label 'Amount is required.';
        BalAccNoErr: Label 'Bal Account No is required.';
    begin
        CashRcptJnl.SetRange("Journal Template Name", 'CASHRCPT');
        CashRcptJnl.SetRange("Journal Batch Name", 'GENERAL');
        CashRcptJnl.SetRange("Document No.", rec."Document No.");
        if CashRcptJnl.Count <> 0 then
            Error('An entry with the same Document No. already exist.');
        if Rec."Posting Date" = 0D then Error(PostingDateBlankErr);
        if Rec.Amount = 0 then Error(AmountEmptyErr);
        if Rec."Document No." = '' then Error(DocumentNoBlankErr);
        if Rec."Bal. Account No." = '' then Error(BalAccNoErr);
        Rec.Validate(Amount);
        Rec.Validate("Posting Date");
        Rec.Validate("Account No.", '1302')
    end;

    var
        OrderNumber: Text[20];
}
