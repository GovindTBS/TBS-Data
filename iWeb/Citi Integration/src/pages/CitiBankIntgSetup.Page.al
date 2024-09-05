page 50140 "Citi Bank Intg. Setup"
{
    Caption = 'Citi Bank Integration Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Citi Bank Intg. Setup";
    Editable = false;
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

            part("Citi Bank Keys"; "Citi Bank Intg. Keys") { }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(EnableIntegration; "Enable/Disable Integration") { }
            actionref(DeleteSetup; "Delete Setup") { }
        }

        area(Processing)
        {
            action("Enable/Disable Integration")
            {
                ToolTip = 'Allows you to enable citi bank itegration.';
                Image = Bank;
                trigger OnAction()
                begin
                    if Rec."Integration Enabled" = true then
                        Rec."Integration Enabled" := false
                    else begin
                        ValidateCitiSetup();
                        Rec."Integration Enabled" := true;
                    end;
                    Rec.Modify();
                end;
            }
            action("Delete Setup")
            {
                ToolTip = 'Allows you to enable citi bank itegration.';
                Image = Bank;
                trigger OnAction()
                begin
                    if Confirm(Label2Msg) then begin
                        Rec.Delete();
                        CitiIntgKeys.DeleteAll();
                        GuidedExperience.ResetAssistedSetup(ObjectType::Page, Page::"Citi Intg. Setup Wizard");
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        if not GuidedExperience.IsAssistedSetupComplete(ObjectType::Page, Page::"Citi Intg. Setup Wizard") then
            Page.RunModal(Page::"Citi Intg. Setup Wizard");

        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

    end;

    procedure ValidateCitiSetup()
    begin
        Rec.TestField("Client ID");
        Rec.TestField("Client Secret");

        CitiIntgKeys.Reset();
        CitiIntgKeys.SetRange(Uploaded, false);
        if CitiIntgKeys.Count() > 0 then
            Error(Label1Msg);
    end;

    var
        CitiIntgKeys: Record "Citi Bank Intg. Keys";
        GuidedExperience: Codeunit "Guided Experience";
        Label1Msg: Label 'Upload all the necessary certificates';
        Label2Msg: Label 'Are you sure you want to delete the setup ?';
}
