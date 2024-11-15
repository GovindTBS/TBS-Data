namespace Microsoft.Warehouse.Activity;

using Microsoft.Inventory.Tracking;
using Microsoft.Warehouse.Structure;

query 7323 CalcOutstandQtyOnWhseActLine
{
    QueryType = Normal;
    Access = Internal;
    DataAccessIntent = ReadOnly;
    Caption = 'Calculate outstanding pick quantity on active warehouse pick documents', Locked = true;

    elements
    {
        dataitem(Bin_Content; "Bin Content")
        {
            DataItemTableFilter = Dedicated = const(false),
                                  "Block Movement" = filter(" " | Inbound);
            SqlJoinType = InnerJoin;

            filter(Bin_Type_Code; "Bin Type Code") { }

            column(Location_Code; "Location Code") { }
            column(Item_No_; "Item No.") { }
            column(Variant_Code; "Variant Code") { }

            dataitem(Warehouse_Activity_Line; "Warehouse Activity Line")
            {
                DataItemLink = "Location Code" = Bin_Content."Location Code",
                                "Bin Code" = Bin_Content."Bin Code",
                                "Item No." = Bin_Content."Item No.",
                                "Variant Code" = Bin_Content."Variant Code",
                                "Unit of Measure Code" = Bin_Content."Unit of Measure Code";
                DataItemTableFilter = "Breakbulk No." = const(0);
                SqlJoinType = InnerJoin;

                filter(Activity_Type; "Activity Type") { }
                filter(Action_Type; "Action Type") { }
                filter(Serial_No_; "Serial No.") { }
                filter(Lot_No_; "Lot No.") { }
                filter(Package_No_; "Package No.") { }

                column(TotalWhseActLineQtyOutstandingBase; "Qty. Outstanding (Base)")
                {
                    Method = Sum;
                }
            }
        }
    }

    internal procedure SetTrackingFilterFromItemTrackingSetupIfNotBlankIfRequired(WhseItemTrackingSetup: Record "Item Tracking Setup")
    begin
        if WhseItemTrackingSetup."Serial No." <> '' then
            if WhseItemTrackingSetup."Serial No. Required" then
                CurrQuery.SetRange(Serial_No_, WhseItemTrackingSetup."Serial No.")
            else
                CurrQuery.SetFilter(Serial_No_, '%1|%2', WhseItemTrackingSetup."Serial No.", '');

        if WhseItemTrackingSetup."Lot No." <> '' then
            if WhseItemTrackingSetup."Lot No. Required" then
                CurrQuery.SetRange(Lot_No_, WhseItemTrackingSetup."Lot No.")
            else
                CurrQuery.SetFilter(Lot_No_, '%1|%2', WhseItemTrackingSetup."Lot No.", '');

        if WhseItemTrackingSetup."Package No." <> '' then
            if WhseItemTrackingSetup."Package No. Required" then
                CurrQuery.SetRange(Package_No_, WhseItemTrackingSetup."Package No.")
            else
                CurrQuery.SetFilter(Package_No_, '%1|%2', WhseItemTrackingSetup."Package No.", '');
    end;
}