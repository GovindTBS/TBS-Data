codeunit 50100 "Event Handler"
{

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAssignLotNoOnAfterInsert', '', false, false)]
    local procedure OnAssignLotNoOnAfterInsert(var TrackingSpecification: Record "Tracking Specification"; QtyToCreate: Decimal)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        LotNoInformation.Init();
        LotNoInformation."Lot No." := TrackingSpecification."Lot No.";
        LotNoInformation."Item No." := TrackingSpecification."Item No.";
        LotNoInformation."Variant Code" := TrackingSpecification."Variant Code";
        LotNoInformation.Location := TrackingSpecification."Location Code";
        LotNoInformation.Date := Today;
        LotNoInformation.Insert(false);
    end;
}