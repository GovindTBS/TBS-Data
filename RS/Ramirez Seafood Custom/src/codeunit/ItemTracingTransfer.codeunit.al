codeunit 50100 "Item Tracing_Transfer"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracing Mgt.", 'OnAfterTransferData', '', true, true)]
    local procedure OnAfterTransferData(ValueEntry: Record "Value Entry"; var ItemLedgerEntry: Record "Item Ledger Entry"; var TempItemTracingBuffer: Record "Item Tracing Buffer" temporary);
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        LotNoInformation.SetRange("Item No.", TempItemTracingBuffer."Item No.");
        LotNoInformation.SetRange("Lot No.", TempItemTracingBuffer."Lot No.");
        if LotNoInformation.FindFirst() then begin
            TempItemTracingBuffer."Harvest Location" := LotNoInformation."Harvest Location";
            TempItemTracingBuffer."Harvest Date" := LotNoInformation.Date;
            TempItemTracingBuffer."Certificate No." := LotNoInformation."Certificate Number";
        end;
    end;
}