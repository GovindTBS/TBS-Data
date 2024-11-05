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
                var
                    Isabel6StatementAPIMgt: Codeunit "Codabox Bank Stmt API Mgt.";
                    StatementDate: Text;
                    XmlDoc: XmlDocument;
                    FromDateNode: XmlNode;
                    ToDateNode: XmlNode;
                    FromDateText: Text;
                    ToDateText: Text;
                    FromDate: DateTime;
                    ToDate: DateTime;
                begin
                    StatementDate := Report.RunRequestPage(Report::"Isabel6 Bank Statement");
                    XmlDocument.ReadFrom(StatementDate, XmlDoc);
                    XmlDoc.SelectSingleNode('/ReportParameters/Options/Field[@name="FromDate"]', FromDateNode);
                    XmlDoc.SelectSingleNode('/ReportParameters/Options/Field[@name="ToDate"]', ToDateNode);
                    FromDateText := FromDateNode.AsXmlElement().InnerText;
                    ToDateText := ToDateNode.AsXmlElement().InnerText;
                    Evaluate(FromDate, FromDateText);
                    Evaluate(ToDate, ToDateText);

                    if (ToDate <> 0DT) and (FromDate <> 0DT) then
                        Isabel6StatementAPIMgt.GetAccountInformationAndStatement(FromDate, ToDate, Rec."No.")
                    else
                        Error('Select proper dates');
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