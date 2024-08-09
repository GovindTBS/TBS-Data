pageextension 50146 "Cust Ledg Entries Ext" extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("SF Bank Statement ID"; Rec."SF Bank Statement ID")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Apply Entries")
        {
            action("Bank Statement")
            {
                ToolTip = 'Sync payment entries with Salesforce.';
                Caption = 'Send to SF';
                ApplicationArea = All;
                Image = SendAsPDF;
                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Export Bank Statement")
                end;
            }
            action("Update Outstanding on SF Invoices")
            {
                ToolTip = 'Update Outstanding on SF Invoices.';
                Caption = 'Update Outstanding on SF Invoices';
                ApplicationArea = All;
                Image = SendAsPDF;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Apply Payment Entries")
                end;
            }
            action("Update Unallocated on SF Payments")
            {
                ToolTip = 'Update Unallocated on SF Payments.';
                Caption = 'Update Unallocated on SF Payments';
                ApplicationArea = All;
                Image = SendAsPDF;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Apply Payment Entries")
                end;
            }
        }
    }
}
