/// <summary>
/// PageExtension Customer Card Ext (ID 50101) extends Record Customer Card.
/// </summary>
pageextension 50141 "Customer List Ext" extends "Customer List"
{
    actions
    {
        addafter("&Customer")
        {
            group("Direct Debit")
            {
                Image = PaymentPeriod;
                Caption = 'Direct Debit';

                action("Direct Debit Authorisation")
                {
                    Caption = 'Direct Debit Authorisation';
                    ApplicationArea = All;
                    Image = PaymentDays;
                    ToolTip = 'Generate and Mail the Direct Debit file.';
                    trigger OnAction()
                    var
                        DirectDebitMailHandler: Codeunit "Direct Debits Handler";
                    begin
                        DirectDebitMailHandler.ExportDirectDebitAuth();
                        DirectDebitMailHandler.MailDirectDebitAuth();
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            group(DIrectDebit)
            {
                Caption = 'Direct Debit';

                actionref("Generate and Mail Direct Debit_Promoted"; "Direct Debit Authorisation")
                {
                }
            }
        }
    }
}
