// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Service.History;

using Microsoft.Finance.Currency;
using Microsoft.Finance.SalesTax;
using Microsoft.Inventory.Costing;
using Microsoft.Sales.Customer;

page 10057 "Service Credit Memo Stats."
{
    Caption = 'Service Credit Memo Statistics';
    Editable = false;
    PageType = Document;
    SourceTable = "Service Cr.Memo Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("CustAmount + InvDiscAmount"; CustAmount + InvDiscAmount)
                {
                    ApplicationArea = Service;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount of the service credit.';
                }
                field(InvDiscAmount; InvDiscAmount)
                {
                    ApplicationArea = Service;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    ToolTip = 'Specifies the invoice discount amount for the service credit memo.';
                }
                field(CustAmount; CustAmount)
                {
                    ApplicationArea = Service;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total';
                    ToolTip = 'Specifies the total amount less any invoice discount amount (excluding tax) for the posted service credit memo.';
                }
                field(TaxAmount; TaxAmount)
                {
                    ApplicationArea = Service;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    ToolTip = 'Specifies the tax amount.';
                }
                field(AmountInclTax; AmountInclTax)
                {
                    ApplicationArea = Service;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total Incl. Tax';
                    ToolTip = 'Specifies the total amount, including taxes.';
                }
                field(AmountLCY; AmountLCY)
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    ToolTip = 'Specifies the sales amount, in dollars.';
                }
                field(ProfitLCY; ProfitLCY)
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Original Profit (LCY)';
                    ToolTip = 'Specifies the profit, expressed as an amount in local currency, which was associated with the service credit memo, when it was originally posted.';
                }
                field(AdjProfitLCY; AdjProfitLCY)
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit (LCY)';
                    ToolTip = 'Specifies the adjusted profit of the service credit, in local currency.';
                }
                field(ProfitPct; ProfitPct)
                {
                    ApplicationArea = Service;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1 : 1;
                    ToolTip = 'Specifies the profit, expressed as a percentage, which was associated with the service credit memo when it was originally posted.';
                }
                field(AdjProfitPct; AdjProfitPct)
                {
                    ApplicationArea = Service;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1 : 1;
                    ToolTip = 'Specifies the adjusted profit of the service credit expressed as a percentage.';
                }
                field(LineQty; LineQty)
                {
                    ApplicationArea = Service;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity of the item/resource on the service credit memo.';
                }
                field(TotalParcels; TotalParcels)
                {
                    ApplicationArea = Service;
                    Caption = 'Parcels';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the number of parcels on the document.';
                }
                field(TotalNetWeight; TotalNetWeight)
                {
                    ApplicationArea = Service;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the net weight of items on the document.';
                }
                field(TotalGrossWeight; TotalGrossWeight)
                {
                    ApplicationArea = Service;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the gross weight of items listed on the document.';
                }
                field(TotalVolume; TotalVolume)
                {
                    ApplicationArea = Service;
                    Caption = 'Volume';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the volume of the items in the posted service credit memo.';
                }
                field(CostLCY; CostLCY)
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Original Cost (LCY)';
                    ToolTip = 'Specifies the original cost of the items on the service credit memo.';
                }
                field(TotalAdjCostLCY; TotalAdjCostLCY)
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost (LCY)';
                    ToolTip = 'Specifies the adjusted profit of the service credit, expressed as a percentage.';
                }
                field("TotalAdjCostLCY - CostLCY"; TotalAdjCostLCY - CostLCY)
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount (LCY)';
                    ToolTip = 'Specifies the cost adjustment amount, in local currency.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupAdjmtValueEntries();
                    end;
                }
                label(BreakdownTitle)
                {
                    CaptionClass = Format(BreakdownTitle);
                    Editable = false;
                }
                field("BreakdownAmt[1]"; BreakdownAmt[1])
                {
                    ApplicationArea = Service;
                    BlankZero = true;
                    CaptionClass = Format(BreakdownLabel[1]);
                    Editable = false;
                    ShowCaption = false;
                }
                field("BreakdownAmt[2]"; BreakdownAmt[2])
                {
                    ApplicationArea = Service;
                    BlankZero = true;
                    CaptionClass = Format(BreakdownLabel[2]);
                    Editable = false;
                    ShowCaption = false;
                }
                field("BreakdownAmt[3]"; BreakdownAmt[3])
                {
                    ApplicationArea = Service;
                    BlankZero = true;
                    CaptionClass = Format(BreakdownLabel[3]);
                    Editable = false;
                    ShowCaption = false;
                }
                field("BreakdownAmt[4]"; BreakdownAmt[4])
                {
                    ApplicationArea = Service;
                    BlankZero = true;
                    CaptionClass = Format(BreakdownLabel[4]);
                    Editable = false;
                    ShowCaption = false;
                }
            }
            part(Subform; "Sales Tax Lines Serv. Subform")
            {
                Editable = false;
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Cust.""Balance (LCY)"""; Cust."Balance (LCY)")
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                    ToolTip = 'Specifies the customer''s balance. ';
                }
                field("Cust.""Credit Limit (LCY)"""; Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Service;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit ($)';
                    ToolTip = 'Specifies the customer''s credit limit, in dollars.';
                }
                field(CreditLimitLCYExpendedPct; CreditLimitLCYExpendedPct)
                {
                    ApplicationArea = Service;
                    Caption = 'Expended % of Credit Limit ($)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies the Expended Percentage of Credit Limit ($).';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        CostCalcMgt: Codeunit "Cost Calculation Management";
    begin
        ClearAll();
        TaxArea.Get(Rec."Tax Area Code");

        if Rec."Currency Code" = '' then
            Currency.InitRoundingPrecision()
        else
            Currency.Get(Rec."Currency Code");

        ServCrMemoLine.SetRange("Document No.", Rec."No.");

        if ServCrMemoLine.Find('-') then
            repeat
                CustAmount := CustAmount + ServCrMemoLine.Amount;
                AmountInclTax := AmountInclTax + ServCrMemoLine."Amount Including VAT";
                if Rec."Prices Including VAT" then
                    InvDiscAmount := InvDiscAmount + ServCrMemoLine."Inv. Discount Amount" / (1 + ServCrMemoLine."VAT %" / 100)
                else
                    InvDiscAmount := InvDiscAmount + ServCrMemoLine."Inv. Discount Amount";
                CostLCY := CostLCY + (ServCrMemoLine.Quantity * ServCrMemoLine."Unit Cost (LCY)");
                LineQty := LineQty + ServCrMemoLine.Quantity;
                TotalNetWeight := TotalNetWeight + (ServCrMemoLine.Quantity * ServCrMemoLine."Net Weight");
                TotalGrossWeight := TotalGrossWeight + (ServCrMemoLine.Quantity * ServCrMemoLine."Gross Weight");
                TotalVolume := TotalVolume + (ServCrMemoLine.Quantity * ServCrMemoLine."Unit Volume");
                if ServCrMemoLine."Units per Parcel" > 0 then
                    TotalParcels := TotalParcels + Round(ServCrMemoLine.Quantity / ServCrMemoLine."Units per Parcel", 1, '>');
                if ServCrMemoLine."VAT %" <> TaxPercentage then
                    if TaxPercentage = 0 then
                        TaxPercentage := ServCrMemoLine."VAT %"
                    else
                        TaxPercentage := -1;
                TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcServCrMemoLineCostLCY(ServCrMemoLine);
            until ServCrMemoLine.Next() = 0;
        TaxAmount := AmountInclTax - CustAmount;
        InvDiscAmount := Round(InvDiscAmount, Currency."Amount Rounding Precision");

        if Rec."Currency Code" = '' then
            AmountLCY := CustAmount
        else
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WorkDate(), Rec."Currency Code", CustAmount, Rec."Currency Factor");
        ProfitLCY := AmountLCY - CostLCY;
        if AmountLCY <> 0 then
            ProfitPct := Round(100 * ProfitLCY / AmountLCY, 0.1);

        AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
        if AmountLCY <> 0 then
            AdjProfitPct := Round(100 * AdjProfitLCY / AmountLCY, 0.1);

        if Cust.Get(Rec."Bill-to Customer No.") then
            Cust.CalcFields("Balance (LCY)")
        else
            Clear(Cust);
        if Cust."Credit Limit (LCY)" = 0 then
            CreditLimitLCYExpendedPct := 0
        else
            if Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0 then
                CreditLimitLCYExpendedPct := 0
            else
                if Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1 then
                    CreditLimitLCYExpendedPct := 10000
                else
                    CreditLimitLCYExpendedPct := Round(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000, 1);

        SalesTaxCalculate.StartSalesTaxCalculation();
        TempSalesTaxLine.DeleteAll();

        OnAfterCalculateSalesTax(ServCrMemoLine, TempSalesTaxLine, TempSalesTaxAmtLine, SalesTaxCalculationOverridden);
        if not SalesTaxCalculationOverridden then
            if TaxArea."Use External Tax Engine" then
                SalesTaxCalculate.CallExternalTaxEngineForDoc(DATABASE::"Service Cr.Memo Header", 0, Rec."No.")
            else begin
                SalesTaxCalculate.AddServCrMemoLines(Rec."No.");
                SalesTaxCalculate.EndSalesTaxCalculation(Rec."Posting Date");
            end;

        SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine);
        if not SalesTaxCalculationOverridden then
            SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);

        if TaxArea."Country/Region" = TaxArea."Country/Region"::CA then
            BreakdownTitle := Text006
        else
            BreakdownTitle := Text007;
        TempSalesTaxAmtLine.Reset();
        TempSalesTaxAmtLine.SetCurrentKey("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
        if TempSalesTaxAmtLine.Find('-') then
            repeat
                if (TempSalesTaxAmtLine."Print Order" = 0) or
                   (TempSalesTaxAmtLine."Print Order" <> PrevPrintOrder) or
                   (TempSalesTaxAmtLine."Tax %" <> PrevTaxPercent)
                then begin
                    BrkIdx := BrkIdx + 1;
                    if BrkIdx > ArrayLen(BreakdownAmt) then begin
                        BrkIdx := BrkIdx - 1;
                        BreakdownLabel[BrkIdx] := Text008;
                    end else
                        BreakdownLabel[BrkIdx] := CopyStr(StrSubstNo(TempSalesTaxAmtLine."Print Description", TempSalesTaxAmtLine."Tax %"), 1, MaxStrLen(BreakdownLabel[BrkIdx]));
                end;
                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + TempSalesTaxAmtLine."Tax Amount";
            until TempSalesTaxAmtLine.Next() = 0;
        CurrPage.Subform.PAGE.SetTempTaxAmountLine(TempSalesTaxLine);
        CurrPage.Subform.PAGE.InitGlobals(Rec."Currency Code", false, false, false, false, Rec."VAT Base Discount %");
    end;

    var
        CurrExchRate: Record "Currency Exchange Rate";
        ServCrMemoLine: Record "Service Cr.Memo Line";
        Cust: Record Customer;
        TempSalesTaxLine: Record "Sales Tax Amount Line" temporary;
        Currency: Record Currency;
        TaxArea: Record "Tax Area";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        CustAmount: Decimal;
        AmountInclTax: Decimal;
        InvDiscAmount: Decimal;
        TaxAmount: Decimal;
        CostLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        AmountLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        TaxPercentage: Decimal;
        BreakdownTitle: Text[35];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        BrkIdx: Integer;
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Sales Tax Breakdown:';
        Text008: Label 'Other Taxes';
        SalesTaxCalculationOverridden: Boolean;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateSalesTax(var ServiceCrMemoLine: Record "Service Cr.Memo Line"; var TempSalesTaxAmountLine: Record "Sales Tax Amount Line" temporary; var TempSalesTaxAmountLine2: Record "Sales Tax Amount Line" temporary; var SalesTaxCalculationOverridden: Boolean)
    begin
    end;
}

