// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Bank.ElectronicFundsTransfer;

using System.IO;

codeunit 10335 "Exp. Mapping Det EFT MX"
{
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        ACHCecobanDetail: Record "ACH Cecoban Detail";
        DataExch: Record "Data Exch.";
        EFTExportMgt: Codeunit "EFT Export Mgt";
        RecordRef: RecordRef;
        LineNo: Integer;
    begin
        if NoDataExchLineDef(Rec."Data Exch. Def Code") then
            exit;

        LineNo := 1;

        if ACHCecobanDetail.Find('-') then
            repeat
                DataExch.SetRange("Entry No.", Rec."Entry No.");
                if DataExch.FindFirst() then begin
                    RecordRef.GetTable(ACHCecobanDetail);
                    EFTExportMgt.InsertDataExchLineForFlatFile(
                      DataExch,
                      LineNo,
                      RecordRef);
                    LineNo := LineNo + 1;
                end;
            until ACHCecobanDetail.Next() = 0;
        ACHCecobanDetail.DeleteAll();
    end;

    local procedure NoDataExchLineDef(DataExchDefCode: Code[20]): Boolean
    var
        DataExchLineDef: Record "Data Exch. Line Def";
    begin
        DataExchLineDef.Init();
        DataExchLineDef.SetRange("Data Exch. Def Code", DataExchDefCode);
        DataExchLineDef.SetRange("Line Type", DataExchLineDef."Line Type"::Detail);
        exit(DataExchLineDef.IsEmpty);
    end;
}

