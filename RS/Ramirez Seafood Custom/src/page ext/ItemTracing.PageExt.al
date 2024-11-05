pageextension 50100 "Item Tracing" extends "Item Tracing"
{
    layout
    {
        addafter("Already Traced")
        {
            field("Harvest Location"; Rec."Harvest Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the harvest location for the lot.';
            }

            field("Harvest Date"; Rec."Harvest Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date for the lot assigned.';
            }
        }
    }
    actions
    {
        modify(Print)
        {
            Visible = false; // Hides the "Print" action
        }

        addafter(TraceOppositeFromLine)
        {
            action(PrintTest)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Print';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    xItemTracingBuffer: Record "Item Tracing Buffer";
                    PrintTracking: Report "ItemTracingSpecification_Rami";
                begin
                    Clear(PrintTracking);
                    xItemTracingBuffer.Copy(Rec);
                    PrintTracking.TransferEntries(Rec);
                    Rec.Copy(xItemTracingBuffer);
                    PrintTracking.Run();
                end;
            }
        }
    }
}


