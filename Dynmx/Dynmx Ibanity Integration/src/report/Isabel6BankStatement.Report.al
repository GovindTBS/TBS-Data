report 50100 "Isabel6 Bank Statement"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

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


        actions
        {
            area(processing)
            {
                action("Generate Statement")
                {
                    ApplicationArea = All;
                    Caption = 'Generate Statement';
                    InFooterBar = true;

                    trigger OnAction()
                    var
                        Isabel6StatementAPIMgt: Codeunit "Isabel Bank Statement API Mgt.";
                    begin
                        if (ToDate <> 0DT) and (FromDate <> 0DT) then
                            Isabel6StatementAPIMgt.GetAccountInformationAndStatement(FromDate, ToDate)
                        else
                            Error('Select proper dates');
                    end;
                }
            }
        }
    }

    var
        FromDate: DateTime;
        ToDate: DateTime;
}