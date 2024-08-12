page 50140 "Citi Bank Intg. Setup"
{
    Caption = 'Citi Bank Interation Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Citi Bank Intg. Setup";

    layout
    {
        area(Content)
        {
            group("General")
            {
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'The client id for the Citi bank API authorization.';
                    ApplicationArea = All;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ToolTip = 'The client secret for the Citi bank API authorization.';
                    ApplicationArea = All;
                }
                field("Integration Enabled"; Rec."Integration Enabled")
                {
                    ToolTip = 'Specifies wether the integration is enabled or not.';
                    ApplicationArea = all;
                }
            }

            part("CitiBankKeys"; "Citi Bank Intg. Keys")
            {

            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    trigger OnOpenPage()
    var
        CitiKeys: Record "Citi Bank Intg. Keys";
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
            
        end;
    end;
}