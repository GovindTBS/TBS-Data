pageextension 50103 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {

    }

    actions
    {
        addlast(Category_Category6)
        {
            actionref("Print Labels"; PrintLabel) { }
        }

        addafter(Print)
        {
            action(PrintLabel)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Label';
                Image = PrintCheck;
                ToolTip = 'Prepare to print the Label.';

                trigger OnAction()
                var
                begin
                    Report.Run(Report::"Standard Sales - Invoice");
                end;
            }
        }
    }

    var
        myInt: Integer;
}