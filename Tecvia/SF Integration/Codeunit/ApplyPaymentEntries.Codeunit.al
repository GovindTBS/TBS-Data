codeunit 50146 "Apply Payment Entries"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin

    end;

    var
        TempApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        AppliestoID: Code[50];

    procedure ApplyDocuments(var GenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJnlLine."Applies-to ID" = '' then
            GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
        AppliestoID := GenJnlLine."Applies-to ID";
        SetApplyingCustLedgEntryGenJnlLine(GenJnlLine);

        //auto apply
        if (GenJnlLine."Applied Doc Numbers" = '') and (GenJnlLine."Applies-to Doc. No." = '') then
            ApplyAutomatically(GenJnlLine);

        //multiple docs
        if GenJnlLine."Applied Doc Numbers" <> '' then
            ApplyByDocumentNumbers(GenJnlLine."Applied Doc Numbers");

        //single doc apply
        if GenJnlLine."Applies-to Doc. No." <> '' then
            ApplyByDocumentNumbers(GenJnlLine."Applies-to Doc. No.")
    end;

    local procedure ApplyByDocumentNumbers(ApplDocNumbers: Text)
    var
        CustLedgEntries: Record "Cust. Ledger Entry";
        FilterDoc: Text;
    begin
        FilterDoc := Format(ApplDocNumbers.Replace(',', '|'));
        CustLedgEntries.SetFilter("Document No.", FilterDoc);
        if CustLedgEntries.FindFirst() then
            CustEntrySetApplID.SetApplId(CustLedgEntries, TempApplyingCustLedgEntry, AppliestoID);
    end;

    local procedure ApplyAutomatically(var GenJnlLine: Record "Gen. Journal Line")
    var
        CustLedgEntries: Record "Cust. Ledger Entry";
        ApplyToDocNumbers: Text[260];
        AmountLeft: Decimal;
    begin
        CustLedgEntries.Reset();
        CustLedgEntries.SetCurrentKey("Posting Date");
        CustLedgEntries.Ascending(true);
        CustLedgEntries.SetRange("Customer No.", GenJnlLine."Bal. Account No.");
        CustLedgEntries.SetRange("Document Type", CustLedgEntries."Document Type"::Invoice);
        CustLedgEntries.SetRange(Open, true);
        AmountLeft := GenJnlLine.Amount;
        ApplyToDocNumbers := '';

        if not CustLedgEntries.FindFirst() then
            exit;

        if ApplyMatchedInvoiceAmount(CustLedgEntries, AmountLeft) then
            exit;

        repeat
            CustLedgEntries.CalcFields("Remaining Amount");
            if CustLedgEntries."Remaining Amount" < AmountLeft then begin
                ApplyToDocNumbers := Format(ApplyToDocNumbers + CustLedgEntries."Document No." + ',');
                AmountLeft := AmountLeft - CustLedgEntries."Remaining Amount";
            end;
        until CustLedgEntries.Next() = 0;

        if ApplyToDocNumbers <> '' then
            ApplyByDocumentNumbers(ApplyToDocNumbers.Substring(1, StrLen(ApplyToDocNumbers) - 1));
    end;

    local procedure ApplyMatchedInvoiceAmount(CustLedgEntries: Record "Cust. Ledger Entry"; AmountLeft: Decimal): Boolean
    begin
        CustLedgEntries.SetRange("Remaining Amount", AmountLeft);
        if CustLedgEntries.FindFirst() then begin
            ApplyByDocumentNumbers(CustLedgEntries."Document No.");
            exit(true);
        end;
    end;

    local procedure SetApplyingCustLedgEntryGenJnlLine(var GenJnlLine: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
    begin
        TempApplyingCustLedgEntry."Entry No." := 1;
        TempApplyingCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
        TempApplyingCustLedgEntry."Document Type" := GenJnlLine."Document Type";
        TempApplyingCustLedgEntry."Document No." := GenJnlLine."Document No.";

        if GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Customer then begin
            TempApplyingCustLedgEntry."Customer No." := GenJnlLine."Bal. Account No.";
            Customer.Get(TempApplyingCustLedgEntry."Customer No.");
            TempApplyingCustLedgEntry.Description := Customer.Name;
        end else begin
            TempApplyingCustLedgEntry."Customer No." := GenJnlLine."Account No.";
            TempApplyingCustLedgEntry.Description := GenJnlLine.Description;
        end;

        TempApplyingCustLedgEntry."Currency Code" := GenJnlLine."Currency Code";
        TempApplyingCustLedgEntry.Amount := GenJnlLine.Amount; // FlowFields
        TempApplyingCustLedgEntry."Remaining Amount" := GenJnlLine.Amount; // FlowFields
    end;
}
