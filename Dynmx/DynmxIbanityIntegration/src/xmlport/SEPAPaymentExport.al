namespace Isabel6;

using Microsoft.Bank.Payment;
using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using System.Utilities;
using Microsoft.Bank.Setup;
using Microsoft.Bank.DirectDebit;

xmlport 50140 "SEPA Payment Export"
{
    Caption = 'SEPA CUST pain.001.001.09';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.09';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        tableelement("Payment Journal Line"; "Payment Journal Line")
        {
            XmlName = 'Document';
            UseTemporary = true;
            tableelement(companyinformation; "Company Information")
            {
                XmlName = 'CstmrCdtTrfInitn';
                textelement(GrpHdr)
                {
                    textelement(messageid)
                    {
                        XmlName = 'MsgId';
                    }
                    textelement(createddatetime)
                    {
                        XmlName = 'CreDtTm';
                    }
                    textelement(nooftransfers)
                    {
                        XmlName = 'NbOfTxs';
                    }
                    textelement(controlsum)
                    {
                        XmlName = 'CtrlSum';
                    }
                    textelement(InitgPty)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(initgptypstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(StrtNm; CompanyInformation.Address)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.Address = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(PstCd; CompanyInformation."Post Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Post Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(TwnNm; CompanyInformation.City)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.City = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(Ctry; CompanyInformation."Country/Region Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Country/Region Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                        textelement(initgptyid)
                        {
                            XmlName = 'Id';
                            textelement(initgptyorgid)
                            {
                                XmlName = 'OrgId';
                                textelement(initgptyothrinitgpty)
                                {
                                    XmlName = 'Othr';
                                    fieldelement(Id; CompanyInformation."Enterprise No.")
                                    {
                                    }
                                }
                            }
                        }
                    }
                }
                tableelement(paymentexportdatagroup; "Payment Export Data")
                {
                    XmlName = 'PmtInf';
                    UseTemporary = true;
                    fieldelement(PmtInfId; PaymentExportDataGroup."Payment Information ID")
                    {
                    }
                    fieldelement(PmtMtd; PaymentExportDataGroup."SEPA Payment Method Text")
                    {
                    }
                    fieldelement(BtchBookg; PaymentExportDataGroup."SEPA Batch Booking")
                    {
                    }
                    fieldelement(NbOfTxs; PaymentExportDataGroup."Line No.")
                    {
                    }
                    fieldelement(CtrlSum; PaymentExportDataGroup.Amount)
                    {
                    }
                    textelement(PmtTpInf)
                    {
                        fieldelement(InstrPrty; PaymentExportDataGroup."SEPA Instruction Priority Text")
                        {
                        }
                    }
                    textelement(ReqdExctnDt)
                    {
                        fieldelement(Dt; PaymentExportDataGroup."Transfer Date")
                        {
                        }
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(dbtrpstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(StrtNm; CompanyInformation.Address)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.Address = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(PstCd; CompanyInformation."Post Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Post Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(TwnNm; CompanyInformation.City)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.City = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(Ctry; CompanyInformation."Country/Region Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Country/Region Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                        textelement(dbtrid)
                        {
                            XmlName = 'Id';
                            textelement(dbtrorgid)
                            {
                                XmlName = 'OrgId';
                                fieldelement(AnyBIC; PaymentExportDataGroup."Sender Bank BIC")
                                {
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportDataGroup."Sender Bank BIC" = '' then
                                    currXMLport.Skip();
                            end;
                        }
                    }
                    textelement(DbtrAcct)
                    {
                        textelement(dbtracctid)
                        {
                            XmlName = 'Id';
                            fieldelement(IBAN; PaymentExportDataGroup."Sender Bank Account No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }
                    }
                    textelement(DbtrAgt)
                    {
                        textelement(dbtragtfininstnid)
                        {
                            XmlName = 'FinInstnId';
                            fieldelement(BICFI; PaymentExportDataGroup."Sender Bank BIC")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }

                        trigger OnBeforePassVariable()
                        begin
                            if PaymentExportDataGroup."Sender Bank BIC" = '' then
                                currXMLport.Skip();
                        end;
                    }
                    fieldelement(ChrgBr; PaymentExportDataGroup."SEPA Charge Bearer Text")
                    {
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = field("Sender Bank BIC"), "SEPA Instruction Priority Text" = field("SEPA Instruction Priority Text"), "Transfer Date" = field("Transfer Date"), "SEPA Batch Booking" = field("SEPA Batch Booking"), "SEPA Charge Bearer Text" = field("SEPA Charge Bearer Text");
                        LinkTable = PaymentExportDataGroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(EndToEndId; PaymentExportData."End-to-End ID")
                            {
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt; PaymentExportData.Amount)
                            {
                                fieldattribute(Ccy; PaymentExportData."Currency Code")
                                {
                                }
                            }
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                fieldelement(BICFI; PaymentExportData."Recipient Bank BIC")
                                {
                                    FieldValidate = yes;
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportData."Recipient Bank BIC" = '' then
                                    currXMLport.Skip();
                            end;
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm; PaymentExportData."Recipient Name")
                            {
                            }
                            textelement(cdtrpstladr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(StrtNm; PaymentExportData."Recipient Address")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Address" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(PstCd; PaymentExportData."Recipient Post Code")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Post Code" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(TwnNm; PaymentExportData."Recipient City")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient City" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(Ctry; PaymentExportData."Recipient Country/Region Code")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Country/Region Code" = '' then
                                            currXMLport.Skip();
                                    end;
                                }

                                trigger OnBeforePassVariable()
                                begin
                                    if (PaymentExportData."Recipient Address" = '') and
                                       (PaymentExportData."Recipient Post Code" = '') and
                                       (PaymentExportData."Recipient City" = '') and
                                       (PaymentExportData."Recipient Country/Region Code" = '')
                                    then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                fieldelement(IBAN; PaymentExportData."Recipient Bank Acc. No.")
                                {
                                    FieldValidate = yes;
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                }
                            }
                        }
                        textelement(RmtInf)
                        {
                            MinOccurs = Zero;
                            textelement(remittancetext)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';
                            }

                            trigger OnBeforePassVariable()
                            var
                                SeparatorText: Text;
                                IsHandled: Boolean;
                            begin
                                IsHandled := false;
                                if IsHandled then
                                    exit;

                                RemittanceText := '';

                                TempPaymentExportRemittanceText.SetRange("Pmt. Export Data Entry No.", PaymentExportData."Entry No.");
                                if not TempPaymentExportRemittanceText.FindSet() then
                                    currXMLport.Skip();
                                RemittanceText := TempPaymentExportRemittanceText.Text;
                                if TempPaymentExportRemittanceText.Next() = 0 then
                                    exit;

                                SeparatorText := '; ';

                                RemittanceText := CopyStr(
                                    StrSubstNo('%1%2%3', RemittanceText, SeparatorText, TempPaymentExportRemittanceText.Text), 1, 140);
                            end;
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if not PaymentExportData.GetPreserveNonLatinCharacters() then
                        PaymentExportData.CompanyInformationConvertToLatin(CompanyInformation);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        InitData();
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: Label 'There is no data to export.', Comment = '%1=Field;%2=Value;%3=Value';

    local procedure InitData()
    var
        PaymentGroupNo: Integer;
    begin
        FillExportBuffer("Payment Journal Line", PaymentExportData);
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        NoOfTransfers := Format(PaymentExportData.Count);
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := Format(CurrentDateTime, 19, 9);
        PaymentExportData.CalcSums(Amount);
        ControlSum := Format(PaymentExportData.Amount, 0, 9);

        PaymentExportData.SetCurrentKey(
          "Sender Bank BIC", "SEPA Instruction Priority Text", "Transfer Date",
          "SEPA Batch Booking", "SEPA Charge Bearer Text");

        if not PaymentExportData.FindSet() then
            Error(NoDataToExportErr);

        InitPmtGroup();
        repeat
            if IsNewGroup() then begin
                InsertPmtGroup(PaymentGroupNo);
                InitPmtGroup();
            end;
            PaymentExportDataGroup."Line No." += 1;
            PaymentExportDataGroup.Amount += PaymentExportData.Amount;
        until PaymentExportData.Next() = 0;
        InsertPmtGroup(PaymentGroupNo);
    end;

    local procedure IsNewGroup(): Boolean
    begin
        exit(
          (PaymentExportData."Sender Bank BIC" <> PaymentExportDataGroup."Sender Bank BIC") or
          (PaymentExportData."SEPA Instruction Priority Text" <> PaymentExportDataGroup."SEPA Instruction Priority Text") or
          (PaymentExportData."Transfer Date" <> PaymentExportDataGroup."Transfer Date") or
          (PaymentExportData."SEPA Batch Booking" <> PaymentExportDataGroup."SEPA Batch Booking") or
          (PaymentExportData."SEPA Charge Bearer Text" <> PaymentExportDataGroup."SEPA Charge Bearer Text"));
    end;

    local procedure InitPmtGroup()
    begin
        PaymentExportDataGroup := PaymentExportData;
        PaymentExportDataGroup."Line No." := 0; // used for counting transactions within group
        PaymentExportDataGroup.Amount := 0; // used for summarizing transactions within group
    end;

    local procedure InsertPmtGroup(var PaymentGroupNo: Integer)
    begin
        PaymentGroupNo += 1;
        PaymentExportDataGroup."Entry No." := PaymentGroupNo;
        PaymentExportDataGroup."Payment Information ID" :=
          CopyStr(
            StrSubstNo('%1/%2', PaymentExportData."Message ID", PaymentGroupNo),
            1, MaxStrLen(PaymentExportDataGroup."Payment Information ID"));
        PaymentExportDataGroup.Insert();
    end;

    procedure FillExportBuffer(var PaymentJournalLine: Record "Payment Journal Line"; var PaymentExportData: Record "Payment Export Data")
    var
        TempPaymentJournalLine: Record "Payment Journal Line" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        TempInteger: Record "Integer" temporary;
        VendorBankAccount: Record "Vendor Bank Account";
        CustomerBankAccount: Record "Customer Bank Account";
        CreditTransferRegister: Record "Credit Transfer Register";
        CreditTransferEntry: Record "Credit Transfer Entry";
        BankExportImportSetup: Record "Bank Export/Import Setup";
        MessageID: Code[20];
    begin
        TempPaymentJournalLine.CopyFilters(PaymentJournalLine);
        CODEUNIT.Run(CODEUNIT::"SEPA CT-Prepare Source", TempPaymentJournalLine);

        TempPaymentJournalLine.Reset();
        TempPaymentJournalLine.FindSet();
        BankAccount.Get(TempPaymentJournalLine."Account No.");
        BankAccount.TestField(IBAN);
        BankAccount.GetBankExportImportSetup(BankExportImportSetup);
        BankExportImportSetup.TestField("Check Export Codeunit");
        // repeat
        //     CODEUNIT.Run(BankExportImportSetup."Check Export Codeunit", TempPaymentJournalLine);
        //     if TempPaymentJournalLine."Account No." <> BankAccount."No." then
        //         TempPaymentJournalLine.InsertPaymentFileError(SameBankErr);
        // until TempPaymentJournalLine.Next() = 0;

        // if TempPaymentJournalLine.HasPaymentFileErrorsInBatch() then begin
        //     Commit();
        //     Error(HasErrorsErr);
        // end;

        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("LCY Code");

        MessageID := BankAccount.GetCreditTransferMessageNo();
        CreditTransferRegister.CreateNew(MessageID, BankAccount."No.");

        PaymentExportData.Reset();
        if PaymentExportData.FindLast() then;

        TempPaymentJournalLine.FindSet();
        repeat
            PaymentExportData.Init();
            PaymentExportData."Entry No." += 1;
            PaymentExportData.SetPreserveNonLatinCharacters(BankExportImportSetup."Preserve Non-Latin Characters");
            PaymentExportData.SetBankAsSenderBank(BankAccount);
            PaymentExportData."Transfer Date" := TempPaymentJournalLine."Posting Date";
            PaymentExportData.Amount := TempPaymentJournalLine.Amount;
            if TempPaymentJournalLine."Currency Code" = '' then
                PaymentExportData."Currency Code" := GeneralLedgerSetup."LCY Code"
            else
                PaymentExportData."Currency Code" := TempPaymentJournalLine."Currency Code";

            case TempPaymentJournalLine."Account Type" of
                TempPaymentJournalLine."Account Type"::Customer:
                    begin
                        Customer.Get(TempPaymentJournalLine."Account No.");
                        CustomerBankAccount.Get(Customer."No.", TempPaymentJournalLine."Beneficiary Bank Account");
                        PaymentExportData.SetCustomerAsRecipient(Customer, CustomerBankAccount);
                    end;
                TempPaymentJournalLine."Account Type"::Vendor:
                    begin
                        Vendor.Get(TempPaymentJournalLine."Account No.");
                        VendorBankAccount.Get(Vendor."No.", TempPaymentJournalLine."Beneficiary Bank Account");
                        PaymentExportData.SetVendorAsRecipient(Vendor, VendorBankAccount);
                    end;

            end;

            PaymentExportData.Validate(PaymentExportData."SEPA Instruction Priority", PaymentExportData."SEPA Instruction Priority"::NORMAL);
            PaymentExportData.Validate(PaymentExportData."SEPA Payment Method", PaymentExportData."SEPA Payment Method"::TRF);
            PaymentExportData.Validate(PaymentExportData."SEPA Charge Bearer", PaymentExportData."SEPA Charge Bearer"::SLEV);
            PaymentExportData."SEPA Batch Booking" := false;
            PaymentExportData.SetCreditTransferIDs(MessageID);

            if PaymentExportData."Applies-to Ext. Doc. No." <> '' then
                PaymentExportData.AddRemittanceText(StrSubstNo(RemitMsg, TempPaymentJournalLine."Applies-to Doc. Type", PaymentExportData."Applies-to Ext. Doc. No."))
            else
                PaymentExportData.AddRemittanceText(TempPaymentJournalLine.Description);
            if TempPaymentJournalLine.Description <> '' then
                PaymentExportData.AddRemittanceText(TempPaymentJournalLine.Description);

            // ValidatePaymentExportData(PaymentExportData, TempPaymentJournalLine);
            PaymentExportData.Insert(true);
            TempInteger.DeleteAll();
            // GetAppliesToDocEntryNumbers(TempPaymentJournalLine, TempInteger);
            if TempInteger.FindSet() then
                repeat
                    CreateNewCreditTransferEntry(
                        PaymentExportData, CreditTransferEntry, CreditTransferRegister, TempPaymentJournalLine, 0, TempInteger.Number);
                until TempInteger.Next() = 0
            else
                CreateNewCreditTransferEntry(
                    PaymentExportData, CreditTransferEntry, CreditTransferRegister, TempPaymentJournalLine,
                    CreditTransferEntry."Entry No." + 1, TempPaymentJournalLine."Ledger Entry No.");
        until TempPaymentJournalLine.Next() = 0;
    end;

    local procedure CreateNewCreditTransferEntry(var PaymentExportData: Record "Payment Export Data"; var CreditTransferEntry: Record "Credit Transfer Entry"; CreditTransferRegister: Record "Credit Transfer Register"; var TempPaymentJournalLine: Record "Payment Journal Line" temporary; EntryNo: Integer; LedgerEntryNo: Integer)
    var
        LedgEntryNo: Integer;
    begin
        CreditTransferEntry.CreateNew(
            CreditTransferRegister."No.", EntryNo,
            TempPaymentJournalLine."Account Type", TempPaymentJournalLine."Account No.", LedgEntryNo,
            PaymentExportData."Transfer Date", PaymentExportData."Currency Code", PaymentExportData.Amount,
            CopyStr(PaymentExportData."End-to-End ID", 1, MaxStrLen(PaymentExportData."End-to-End ID")),
            TempPaymentJournalLine."Beneficiary Bank Account", TempPaymentJournalLine.Description);
    end;

    var
RemitMsg: Label '%1 %2', Comment = '%1=Document type, %2=Document no., e.g. Invoice A123';
}

