pageextension 50145 "Cash Rcpt Jnl" extends "Cash Receipt Journal"
{
    actions
    {
        addafter("Apply Entries")
        {
            action("Apply Automaticaly")
            {
                ApplicationArea = All;
                ToolTip = 'Allow to apply the entries automatically.';
                Caption = 'Apply Automatically';
                Image = ApplyEntries;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    ApplyPaymentEntries: Codeunit "Apply Payment Entries";
                begin
                    CurrPage.SetSelectionFilter(GenJnlLine);
                    if GenJnlLine.FindFirst() then
                        repeat
                            ApplyPaymentEntries.ApplyDocuments(GenJnlLine);
                            GenJnlLine.Modify();
                        until GenJnlLine.Next() = 0;
                end;
            }
        }
    }
}