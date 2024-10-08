pageextension 50140 "EB Payment Journal Ext" extends "EB Payment Journal"
{
    actions
    {
        addafter(CheckPaymentLines)
        {
            action(SendToIsabel)
            {
                ApplicationArea = All;
                Caption = 'Send to Isabel';
                Image = SettleOpenTransactions;

                trigger OnAction()
                begin   

                end;
            }
        }
    }
}
