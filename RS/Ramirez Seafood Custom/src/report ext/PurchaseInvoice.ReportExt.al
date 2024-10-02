reportextension 50101 "Purchase Invoice Ext" extends "Purchase Invoice NA"
{
    dataset
    {
        add("Purch. Inv. Line")
        {
            column(Lot_No_; LotNos)
            { }
        }

        modify("Purch. Inv. Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                ValueEntryRelation: Record "Value Entry Relation";
                ValueEntry: Record "Value Entry";
                ItemTrackingMgt: Codeunit "Item Tracking Management";
                RowID: Text[250];
                Position: Integer;
            begin

                RowID := ItemTrackingMgt.ComposeRowID(Database::"Purch. Inv. Line", 0, "Purch. Inv. Line"."Document No.", '', 0, "Purch. Inv. Line"."Line No.");
                ValueEntryRelation.SetCurrentKey("Source RowId");
                ValueEntryRelation.SetRange("Source RowId", RowID);

                if ValueEntryRelation.FindSet() then
                    repeat
                        ValueEntry.Get(ValueEntryRelation."Value Entry No.");
                        if ValueEntry."Item Ledger Entry Type" in
                           [ValueEntry."Item Ledger Entry Type"::Purchase,
                            ValueEntry."Item Ledger Entry Type"::Sale,
                            ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
                            ValueEntry."Item Ledger Entry Type"::"Negative Adjmt."]
                        then begin
                            ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                            if ItemLedgerEntry.Quantity <> 0 then
                                Position := StrPos(LotNos, ItemLedgerEntry."Lot No.");
                            if Position = 0 then
                                LotNos := Format(LotNos + ItemLedgerEntry."Lot No." + '  ');
                        end;
                    until ValueEntryRelation.Next() = 0;
            end;
        }
    }


    rendering
    {
        layout(PurchaseInvoiceCust)
        {
            Type = RDLC;
            LayoutFile = 'src\report ext\report layout\CustomPurchaseInvoiceNA.rdl';
        }
    }


    var
        LotNos: Text[50];

}


