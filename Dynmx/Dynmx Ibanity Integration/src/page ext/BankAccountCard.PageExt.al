pageextension 50141 "Bank Account Card" extends "Bank Account Card"
{
    actions
    {
        addafter("CODA Statements")
        {
            action("Import Isabel CODA")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to import CODA bank statement from Isabel API.';
                Caption = 'Import Isabel CODA';
                Promoted = true;
                Image = Import;
                trigger OnAction()
                begin
                    Report.Run(Report::"Isabel6 Bank Statement");
                end;
            }
        }
    }
}