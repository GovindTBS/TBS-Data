#if not CLEAN25
// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Finance.VAT.Reporting;

using Microsoft.Foundation.Company;
using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Vendor;
using Microsoft.Utilities;
using System.Utilities;

report 10116 "Vendor 1099 Misc 2020"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Local/Finance/VAT/Reporting/Vendor1099Misc2020.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Vendor 1099 Misc 2020';
    UsageCategory = ReportsAndAnalysis;
    ObsoleteReason = 'Moved to IRS Forms App.';
    ObsoleteState = Pending;
    ObsoleteTag = '25.0';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Vendor Filter';
            column(VoidBox; VoidBox)
            {
            }
            column(CompanyAddress1; CompanyAddress[1])
            {
            }
            column(GetAmtMISC01; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-01', RunTestPrint))
            {
            }
            column(CompanyAddress2; CompanyAddress[2])
            {
            }
            column(CompanyAddress3; CompanyAddress[3])
            {
            }
            column(GetAmtMISC02; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-02', RunTestPrint))
            {
            }
            column(CompanyAddress4; CompanyAddress[4])
            {
            }
            column(CompanyAddress5; CompanyAddress[5])
            {
            }
            column(FATCA; FATCA)
            {
            }
            column(GetAmtMISC03; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-03', RunTestPrint))
            {
            }
            column(CompanyInfoFederalIDNo; CompanyInfo."Federal ID No.")
            {
            }
            column(FederalIDNo_Vendor; "Federal ID No.")
            {
            }
            column(GetAmtMISC04; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-04', RunTestPrint))
            {
            }
            column(GetAmtMISC05; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-05', RunTestPrint))
            {
            }
            column(Name_Vendor; Name)
            {
            }
            column(GetAmtMISC06; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-06', RunTestPrint))
            {
            }
            column(GetAmtMISC09; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-09', RunTestPrint))
            {
            }
            column(Name2_Vendor; "Name 2")
            {
            }
            column(Address_Vendor; Address)
            {
            }
            column(GetAmtMISC08; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-08', RunTestPrint))
            {
            }
            column(Box7; Box7)
            {
            }
            column(Address3_Vendor; VendorAddress)
            {
            }
            column(GetAmtMISC10; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-10', RunTestPrint))
            {
            }
            column(GetAmtMISC12; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-12', RunTestPrint))
            {
            }
            column(GetAmtMISC13; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-13', RunTestPrint))
            {
            }
            column(No_Vendor; "No.")
            {
            }
            column(GetAmtMISC14; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-14', RunTestPrint))
            {
            }
            column(GetAmtMISC15; IRS1099Management.GetAmtByCode(Codes, Amounts, LastLineNo, 'MISC-15', RunTestPrint))
            {
            }
            column(Address2_Vendor; "Address 2")
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number);
                MaxIteration = 1;
                column(FormCounter; FormCounter)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    FormCounter := FormCounter + 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                CodeIndex: Integer;
            begin
                Clear(Amounts);
                Clear(VoidBox);
                Clear(Box7);
                Clear(FATCA);

                if RunTestPrint then begin
                    if FirstVendor then begin
                        Name := PadStr('x', MaxStrLen(Name), 'X');
                        Address := PadStr('x', MaxStrLen(Address), 'X');
                        VendorAddress := PadStr('x', MaxStrLen(VendorAddress), 'X');
                        VoidBox := 'X';
                        Box7 := 'X';
                        FATCA := 'X';
                        "No." := PadStr('x', MaxStrLen("No."), 'X');
                        "Federal ID No." := PadStr('x', MaxStrLen("Federal ID No."), 'X');
                    end else
                        CurrReport.Break();
                end else begin
                    PrintThis := false;
                    IRS1099Management.ProcessVendorInvoices(Amounts, "No.", PeriodDate, Codes, LastLineNo, 'MISC*');

                    PrintThis := IRS1099Management.AnyCodeWithUpdatedAmountExceedMinimum(Codes, Amounts, LastLineNo);
                    if not PrintThis then
                        CurrReport.Skip();

                    VendorAddress := IRS1099Management.GetFormattedVendorAddress(Vendor);

                    Line9 := UpdateLines('MISC-07', 0.0);
                    if IRS1099FormBox.Get(Codes[Line9]) then
                        if Amounts[Line9] >= IRS1099FormBox."Minimum Reportable" then
                            Box7 := 'X';

                    if "FATCA filing requirement" then begin
                        FATCA := 'X';
                        CodeIndex := UpdateLines('MISC-03', 0.0);
                        Amounts[CodeIndex] := 0;
                    end;
                end;

                if VendorNo = 2 then begin
                    PageGroupNo += 1;
                    VendorNo := 0;
                end;
                VendorNo += 1;
            end;

            trigger OnPreDataItem()
            begin
                VendorNo := 0;
                PageGroupNo := 0;

                UpdatePeriodDateArray();

                Clear(Codes);
                Clear(LastLineNo);
                Codes[1] := 'MISC-01';
                Codes[2] := 'MISC-02';
                Codes[3] := 'MISC-03';
                Codes[4] := 'MISC-04';
                Codes[5] := 'MISC-05';
                Codes[6] := 'MISC-06';
                Codes[7] := 'MISC-07';
                Codes[8] := 'MISC-08';
                Codes[9] := 'MISC-09';
                Codes[10] := 'MISC-10';
                Codes[13] := 'MISC-12';
                Codes[14] := 'MISC-13';
                Codes[15] := 'MISC-14';
                Codes[16] := 'MISC-15';
                Codes[17] := 'MISC-15-A';
                Codes[18] := 'MISC-15-B';
                Codes[19] := 'MISC-16';
                LastLineNo := 19;

                IRS1099Management.FormatCompanyAddress(CompanyAddress, CompanyInfo, RunTestPrint);
                FirstVendor := true;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Year; CurrYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calendar Year';
                        ToolTip = 'Specifies the tax year for the 1099 forms that you want to print. The default is the work date year. The taxes may apply to the previous calendar year so you may want to change this date if nothing prints.';

                        trigger OnValidate()
                        begin
                            if (CurrYear < 1980) or (CurrYear > 2060) then
                                Error(ValidYearErr);
                            UpdatePeriodDateArray();
                        end;
                    }
                    field(TestPrint; RunTestPrint)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Test Print';
                        ToolTip = 'Specifies if you want to print the 1099 form on blank paper before you print them on dedicated forms.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            RunTestPrint := false;
            CurrYear := Date2DMY(WorkDate(), 3);
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        IRS1099Management.ThrowErrorfUpgrade2020Needed();
    end;

    var
        CompanyInfo: Record "Company Information";
        IRS1099FormBox: Record "IRS 1099 Form-Box";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        IRS1099Management: Codeunit "IRS 1099 Management";
        PeriodDate: array[2] of Date;
        CurrYear: Integer;
        RunTestPrint: Boolean;
        VoidBox: Code[1];
        FATCA: Code[1];
        Box7: Code[1];
        CompanyAddress: array[5] of Text[50];
        FirstVendor: Boolean;
        PrintThis: Boolean;
        VendorAddress: Text[30];
        Codes: array[20] of Code[10];
        Amounts: array[20] of Decimal;
        LastLineNo: Integer;
        Invoice1099Amount: Decimal;
        i: Integer;
        Line9: Integer;
        FormCounter: Integer;
        PageGroupNo: Integer;
        VendorNo: Integer;
        ValidYearErr: Label 'You must enter a valid year, eg 1998.';
UnknownMiscCodeErr: Label 'Invoice %1 on vendor %2 has unknown 1099 miscellaneous code  %3.', Comment = '%1 = invoice "Entry No.", %2 = "Vendor No.", %3 = misc Code';

    procedure ProcessVendorInvoices(VendorNo: Code[20]; PeriodDate: array[2] of Date)
    var
        EntryApplicationManagement: Codeunit "Entry Application Management";
    begin
        EntryApplicationManagement.GetAppliedVendorEntries(TempVendorLedgerEntry, VendorNo, PeriodDate, true);
        TempVendorLedgerEntry.SetFilter("Document Type", '%1|%2', TempVendorLedgerEntry."Document Type"::Invoice, TempVendorLedgerEntry."Document Type"::"Credit Memo");
        TempVendorLedgerEntry.SetFilter("IRS 1099 Amount", '<>0');
        TempVendorLedgerEntry.SetRange("IRS 1099 Code", 'MISC-', 'MISC-99');
        if TempVendorLedgerEntry.FindSet() then
            repeat
                IRS1099Management.Calculate1099Amount(
                  Invoice1099Amount, Amounts, Codes, LastLineNo, TempVendorLedgerEntry, TempVendorLedgerEntry."Amount to Apply");
            until TempVendorLedgerEntry.Next() = 0;
    end;

    procedure UpdateLines("Code": Code[10]; Amount: Decimal): Integer
    begin
        i := 1;
        while (Codes[i] <> Code) and (i <= LastLineNo) do
            i := i + 1;

        if (Codes[i] = Code) and (i <= LastLineNo) then
            Amounts[i] := Amounts[i] + Amount
        else
            Error(UnknownMiscCodeErr,
              TempVendorLedgerEntry."Entry No.", TempVendorLedgerEntry."Vendor No.", Code);
        exit(i);
    end;

    local procedure UpdatePeriodDateArray()
    begin
        PeriodDate[1] := DMY2Date(1, 1, CurrYear);
        PeriodDate[2] := DMY2Date(31, 12, CurrYear);
    end;
}

#endif
