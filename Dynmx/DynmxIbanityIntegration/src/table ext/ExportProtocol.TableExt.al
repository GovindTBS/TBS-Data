namespace Isabel6;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.Payment;
using System.Text;
using System.Utilities;

tableextension 50104 "Export Protocol" extends "Export Protocol"
{
    procedure ExportPaymentLine(var PaymentJnlLine: Record "Payment Journal Line"): Text
    var
        PmtJnlLineToExport: Record "Payment Journal Line";
        GenJnlLine: Record "Gen. Journal Line";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InputStream: InStream;
        Payments: Text;
    begin
        if CheckPaymentLines(PaymentJnlLine) then begin
            TestField("Export Object ID");
            PmtJnlLineToExport.Copy(PaymentJnlLine);
            PmtJnlLineToExport.SetRange(Status, PmtJnlLineToExport.Status::Created);
            PmtJnlLineToExport.SetRange("Export Protocol Code", Code);
            PmtJnlLineToExport.SetRange("Journal Batch Name", PaymentJnlLine."Journal Batch Name");
            PmtJnlLineToExport.SetRange("Journal Template Name", PaymentJnlLine."Journal Template Name");

            if "Export Object Type" = "Export Object Type"::Report then
                REPORT.RunModal("Export Object ID", false, false, PmtJnlLineToExport)
            else begin
                if PaymentJnlLine."Exported To File" then
                    if not Confirm(ReExportQst) then
                        exit;

                GenJnlLine.Reset();
                GenJnlLine.SetRange("Journal Batch Name", PaymentJnlLine."Journal Batch Name");
                GenJnlLine.SetRange("Journal Template Name", PaymentJnlLine."Journal Template Name");
                GenJnlLine.SetFilter("Line No.", SelectionFilterManagement.GetSelectionFilterForEBPaymentJournal(PmtJnlLineToExport));
                TempBlob.CreateOutStream(OutStr);
                XMLPORT.Export("Export Object ID", OutStr, GenJnlLine);
                CopyStream(OutStr, InputStream);
                Message('%1', InputStream.Length);
                InputStream.Read(Payments);
                exit(Payments);
            end;
        end;
    end;

    var
        ReExportQst: Label 'The selected items have already been exported. Do you want to export again?';
}