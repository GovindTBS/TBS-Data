codeunit 50143 "Citi Bank API Event Mgt."
{
    Access = Internal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Batch Processing Mgt.", 'OnBeforeBatchProcessGenJournalLine', '', false, false)]
    local procedure OnBeforeBatchProcessGenJournalLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."Payment Request ID" <> '' then
            GenJournalLine.TestField("Payment Status Code", 'ACSP');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddCitiIntgSetupWizard()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if GuidedExperience.Exists(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"Citi Intg. Setup Wizard") then
            GuidedExperience.Remove(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"Citi Intg. Setup Wizard");

        GuidedExperience.InsertAssistedSetup(SetupTxt, SetupTxt, SetupTxt, 1000, ObjectType::Page, Page::"Citi Intg. Setup Wizard",
                        "Assisted Setup Group"::Connect,
                        '',
                        "Video Category"::Uncategorized,
                        '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlEntry', '', false, false)]
    local procedure OnBeforeInsertGlEntry(var GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    begin
        GLEntry."Beneficiary Currency Code" := GenJnlLine."Beneficiary Currency Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    local procedure OnBeforeVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        VendorLedgerEntry."Beneficiary Currency Code" := GenJournalLine."Beneficiary Currency Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."Beneficiary Currency Code" := GenJournalLine."Beneficiary Currency Code";
    end;

    var
        SetupTxt: Label 'Set up Citi Bank API';
}