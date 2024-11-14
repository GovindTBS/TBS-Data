reportextension 50100 "Sales - Invoice" extends "Standard Sales - Invoice"
{
    dataset
    {
        add(header)
        {
            column(CompanyInfo_Address; CompanyInfo.Address) { }
            column(CompanyInfo_Address2; CompanyInfo."Address 2") { }
            column(CompanyInfo_City; CompanyInfo.City) { }
            column(CompanyInfo_County; CompanyInfo.County) { }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code") { }
            column(CompanyInfo_CountryRegionCode; CompanyInfo."Country/Region Code") { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Bill_to_County; "Bill-to County") { }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(Bill_to_Contact_No_; "Bill-to Contact No.") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_County; "Ship-to County") { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(ShellfishPermit; CompanyInfo."Shellfish Permit") { }
            column(TERMS_Lbl; TERMS_Lbl) { }
            column(REP_Lbl; REP_Lbl) { }
            column(UM_Lbl; UM_Lbl) { }
            column(PRODUCTDESCRIPTION_Lbl; PRODUCTDESCRIPTION_Lbl) { }
            column(AMOUNT_Lbl; AMOUNT_Lbl) { }
            column(RECEIVEDBY_Lbl; RECEIVEDBY_Lbl) { }
            column(TIMEOFSHIPMENT_Lbl; TIMEOFSHIPMENT_Lbl) { }
            column(TOTAL__Lbl; TOTAL__Lbl) { }
            column(PRICE__Lbl; PRICE__Lbl) { }
            column(DocumentNo_Barcode; DocNoBarcode) { }
            column(Sell_to_Contact_No_; "Sell-to Contact No.") { }
        }

        add(line)
        {
            column(Amount; Amount) { }
            column(CatchMethod; CatchMethod) { }
            column(CountryOfOrigin; CountryOfOrigin) { }
            column(CatchMethodLbl; CatchMethodLbl) { }
            column(CountryOfOriginLbl; CountryOfOriginLbl) { }
            column(ItemDescription; ItemDescription) { }
            column(Description2; Description2) { }
            column(Description_2; Description_2) { }
            column(Description2Lbl; Description2Lbl) { }
        }

        add(header)
        {
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(DocumentDate1; DocumentDate) { }
        }

        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                Item: Record Item;
                ItemLedgerEntry: Record "Item Ledger Entry";
                ValueEntryRelation: Record "Value Entry Relation";
                ValueEntry: Record "Value Entry";
                ItemTrackingMgt: Codeunit "Item Tracking Management";
                RowID: Text[250];
                Position: Integer;
            begin
                if Line.Type = Line.Type::Item then begin
                    Item.Get(Line."No.");
                    CatchMethod := Format(Item."Catch Method");
                    CatchMethodLbl := Item.FieldCaption("Catch Method");
                    CountryOfOrigin := Item."Country/Region of Origin Code";
                    Description_2 := Item."Description 2";
                    CountryOfOriginLbl := 'Country of Origin';
                    ItemDescription := Item.Description;
                    Description2Lbl := Item.FieldCaption("Description 2");
                    Clear(CommentLine);
                    SalesCommentLine.Reset();
                    SalesCommentLine.SetRange("Document Type", "Sales Comment Line"."Document Type"::"Posted Invoice");
                    SalesCommentLine.SetFilter("No.", Line."Document No.");
                    SalesCommentLine.SetRange("Document Line No.", Line."Line No.");
                    if SalesCommentLine.FindSet() then
                        repeat
                            CommentLine += SalesCommentLine.Comment + '<br>';
                        until SalesCommentLine.Next() = 0;

                    RowID := ItemTrackingMgt.ComposeRowID(Database::"Sales Invoice Line", 0, Line."Document No.", '', 0, Line."Line No.");
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
                                    LotNos := Format(LotNos + ItemLedgerEntry."Lot No." + '<br>');
                            end;
                        until ValueEntryRelation.Next() = 0;
                    Description2 := format(LotNos + CommentLine);
                end else
                    CurrReport.Skip();
            end;
        }

        addlast(line)
        {
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemTableView = where("Document Type" = const("Posted Invoice"));
                DataItemLink = "No." = field("Document No."), "Document Line No." = field("Line No.");

                column(No_; "No.") { }
            }
        }

        modify(header)
        {
            trigger OnAfterAfterGetRecord()
            begin
                GenerateDocNoBarCodeString();
                DocumentDate := Format("Document Date", 0, '<Month,2>/<Day,2>/<Year4>');
            end;
        }
    }

    rendering
    {
        layout("Sales Invoice Custom")
        {
            Type = RDLC;
            LayoutFile = 'src\report ext\report layout\SalesInvoiceCustom.rdl';
        }
    }

    local procedure GenerateDocNoBarCodeString()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeString := Header."No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        DocNoBarcode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    var
        SalesCommentLine: Record "Sales Comment Line";
        TERMS_Lbl: Label 'TERMS:';
        REP_Lbl: Label 'REP:';
        UM_Lbl: Label 'UM';
        PRODUCTDESCRIPTION_Lbl: Label 'PRODUCT DESCRIPTION';
        AMOUNT_Lbl: Label 'AMOUNT';
        RECEIVEDBY_Lbl: Label 'RECEIVED BY :';
        TIMEOFSHIPMENT_Lbl: Label 'TIME OF SHIPMENT :';
        TOTAL__Lbl: Label 'TOTAL';
        PRICE__Lbl: Label 'PRICE';
        DocNoBarcode: Text;
        CommentLine: Text[2034];
        DocumentDate: Text;
        CatchMethod: Text;
        CountryOfOrigin: Text;
        CatchMethodLbl: Text;
        CountryOfOriginLbl: Text;
        ItemDescription: Text;
        LotNos: Text[50];
        Description2: Text[500];
        Description_2: Text[200];
        Description2Lbl: Text[50];
}