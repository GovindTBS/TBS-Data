report 50100 "Sales Order Labels"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = InvoiceLabels;

    dataset
    {
        dataitem(SalesOrder; "Sales Header")
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Sales Order';

            column(No_; "No.") { }

            column(HeaderDocument_Type; "Document Type") { }

            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }

            dataitem(SalesOrderLine; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Type" = filter(Type::Item));

                column(LineDocumentType; "Document Type") { }

                column(Document_No_; "Document No.") { }

                column(Line_No_; "Line No.") { }

                column(Description; Description) { }

                column(Quantity; Quantity) { }

                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            }
        }
    }

    rendering
    {
        layout(InvoiceLabels)
        {
            Type = RDLC;
            LayoutFile = 'src/report/report layout/InvoiceLabels.rdl';
        }
    }

    trigger OnPreReport()
    begin
        if SalesOrder.GetFilters = '' then
            Error(NoFilterSetErr);
    end;

    var
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidently printing all documents.';
}