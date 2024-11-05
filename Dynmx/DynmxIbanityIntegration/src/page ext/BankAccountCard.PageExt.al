namespace Isabel6;

using Microsoft.Bank.BankAccount;

pageextension 50141 "Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Isabel Account"; Rec."Isabel Account")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("CODA Statements")
        {
            action("Import Isabel CODA")
            {
                ApplicationArea = All;
                ToolTip = 'Allows to import CODA bank statement from Isabel API.';
                Caption = 'Import Isabel CODA';
                Image = Import;
                trigger OnAction()
                begin
                    Report.Run(Report::"Isabel6 Bank Statement", true, false);
                end;
            }
        }
        addafter("CODA Statements_Promoted")
        {
            actionref("Import Isabel &CODA"; "Import Isabel CODA")
            { }
        }
    }
}