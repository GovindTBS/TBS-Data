pageextension 50142 "Direct Debit Collections Ext" extends "Direct Debit Collections"
{
    actions
    {
        addafter(Entries)
        {
            group("Direct Debit")
            {
                Image = PaymentPeriod;
                Caption = 'Direct Debit';

                action("Process Direct Debits")
                {
                    Caption = 'Export Direct Debit File';
                    Image = PaymentDays;
                    ApplicationArea = All;
                    ToolTip = 'Generate and Mail the Direct Debit file.';
                    trigger OnAction()
                    var
                        DirectDebitHandler: Codeunit "Direct Debits Handler";
                    begin
                        DirectDebitHandler.CreateDirectDebitCollectionAndSendRemittanceMail(Rec);
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            group(DIrectDebit)
            {
                Caption = 'Direct Debit';

                actionref("Generate and Mail Direct Debit_Promoted"; "Process Direct Debits")
                {
                }
            }
        }

    }



}