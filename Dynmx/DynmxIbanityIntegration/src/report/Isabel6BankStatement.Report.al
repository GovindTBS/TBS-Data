namespace Isabel6;

using Microsoft.Bank.BankAccount;

report 50100 "Isabel6 Bank Statement"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(BankAccount; "Bank Account")
        {
            RequestFilterFields = "No.";
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Date Selection")
                {
                    field("From Date"; FromDate)
                    {
                        ToolTip = 'Specifies the date to get the statement entries from.';
                        ApplicationArea = all;
                        Caption = 'From Date';
                    }
                    field("To Date"; ToDate)
                    {
                        ToolTip = 'Specifies the date to get the statement entries upto.';
                        ApplicationArea = all;
                        Caption = 'To Date';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        Isabel6StatementAPIMgt: Codeunit "Codabox Bank Stmt API Mgt.";
    begin
        if (ToDate <> 0DT) and (FromDate <> 0DT) then
            Isabel6StatementAPIMgt.GetAccountInformationAndStatement(FromDate, ToDate, BankAccount."No.")
        else
            Error('Select proper dates');
    end;

    var
        FromDate: DateTime;
        ToDate: DateTime;
}