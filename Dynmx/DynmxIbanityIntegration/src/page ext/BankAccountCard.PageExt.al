namespace Isabel6;

using Microsoft.Bank.BankAccount;
using System.Security.User;

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
                Visible = IntegrationEnabled;
                Image = Import;
                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                begin
                    BankAccount.Reset();
                    BankAccount.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Isabel6 Bank Statement", true, false, BankAccount);
                end;
            }
        }
        addafter("CODA Statements_Promoted")
        {
            actionref("Import Isabel &CODA"; "Import Isabel CODA")
            { }
        }
    }

    trigger OnOpenPage()
    var
        IsabelAPISetup: Record "Isabel6 Setup";
        UserSetup: Record "User Setup";
    begin
        IsabelAPISetup.Get();
        if UserSetup.Get(UserId) then
            if IsabelAPISetup."Integration Enabled" and UserSetup."Allow Isabel Payments" then
                IntegrationEnabled := true;
    end;

    var
        IntegrationEnabled: Boolean;
}