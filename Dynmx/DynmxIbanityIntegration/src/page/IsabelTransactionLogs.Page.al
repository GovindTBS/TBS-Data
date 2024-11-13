namespace Isabel6;

page 50141 "Isabel Transaction Logs"
{
    Caption = 'Isabel Transaction Logs';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Isabel Trasaction Logs";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Request ID"; Rec."Request ID")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Initiation Date & Time"; Rec."Initiation Date & Time")
                {
                    ApplicationArea = all;
                }
                field("Status Checked Last At"; Rec."Status Checked Last At")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}