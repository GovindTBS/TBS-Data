page 50140 "Citi Bank Intg. Setup"
{
    Caption = 'Citi Bank Integration Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Citi Bank Intg. Setup";
    Permissions = tabledata "Citi Bank Intg. Keys" = RMID;
    layout
    {
        area(Content)
        {
            group("General")
            {
                Caption = 'General';
                field("Client ID"; Rec."Client ID")
                {
                    Editable = CitiIntegrationEnabled;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ExtendedDatatype = Masked;
                    Editable = CitiIntegrationEnabled;
                }

                field("Integration Enabled"; Rec."Integration Enabled")
                {

                    ApplicationArea = all;
                    Editable = false;
                }

                field("Auth Token Endpoint"; Rec."Auth Token Endpoint")
                {
                    Editable = CitiIntegrationEnabled;
                    RowSpan = 2;
                }

                field("Payment Initiation Endpoint"; Rec."Payment Initiation Endpoint")
                {
                    Editable = CitiIntegrationEnabled;
                    RowSpan = 2;
                }

                field("Payment Status Endpoint"; Rec."Payment Status Endpoint")
                {
                    Editable = CitiIntegrationEnabled;
                    RowSpan = 2;
                }



            }

            group("Azure Functions")
            {
                Caption = 'Azure Functions';
                field("Sign And Encrypt Function"; Rec."Sign And Encrypt Function")
                {
                    ApplicationArea = all;
                    Editable = CitiIntegrationEnabled;
                }

                field("Decrypt And Verify Function"; Rec."Decrypt And Verify Function")
                {
                    ApplicationArea = all;
                    Editable = CitiIntegrationEnabled;
                }
            }

            part("Citi Bank Keys"; "Citi Bank Intg. Keys")
            {
                Caption = 'Citi Bank Keys';
                Editable = CitiIntegrationEnabled;
            }

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
                Caption = 'Enable/Disable Integration';
                Image = Bank;
                trigger OnAction()
                begin
                    if Rec."Integration Enabled" = true then begin
                        Rec."Integration Enabled" := false;
                        CitiIntegrationEnabled := true;
                    end else begin
                        ValidateCitiSetup();
                        Rec."Integration Enabled" := true;
                        CitiIntegrationEnabled := false;
                    end;
                    Rec.Modify(false);
                    CurrPage.Update();
                end;
            }
            action("Delete Setup")
            {
                Caption = 'Delete Setup';
                ToolTip = 'Allows you to enable citi bank itegration.';
                Image = Bank;
                trigger OnAction()
                begin
                    if Confirm(Label2Msg) then begin
                        Rec.Delete(true);
                        CitiIntgKeys.DeleteAll(true);
                        GuidedExperience.ResetAssistedSetup(ObjectType::Page, Page::"Citi Intg. Setup Wizard");
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Integration Enabled" then
            CitiIntegrationEnabled := false
        else
            CitiIntegrationEnabled := true;

        if not GuidedExperience.IsAssistedSetupComplete(ObjectType::Page, Page::"Citi Intg. Setup Wizard") then
            Page.RunModal(Page::"Citi Intg. Setup Wizard");

        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(false);
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
        CitiIntegrationEnabled: Boolean;
}
