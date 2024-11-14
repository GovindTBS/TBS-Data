pageextension 50144 "Sales Order" extends "Sales Order"
{
    actions
    {
        addlast(Category_Report)
        {
            actionref("Print Labels"; PrintLabel) { }
        }

        addlast(reporting)
        {
            action(PrintLabel)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Label';
                Image = PrintCheck;
                ToolTip = 'Prepare to print the Label.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesHeader);
                    Report.Run(Report::"Sales Order Labels", true, false, SalesHeader);
                end;
            }
        }
    }
}