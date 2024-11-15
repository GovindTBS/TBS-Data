page 50140 "Citi Bank API Setup"
{
    Caption = 'Citi Bank API Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Citi Bank API Setup";
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group("General")
            {
                Caption = 'General';
                field("Client ID"; Rec."Client ID")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ExtendedDatatype = Masked;
                    Editable = CitiIntegrationDisabled;
                }
                field("SSL Certificate File"; Rec."SSL Certificate File")
                {
                    Editable = false;
                }
                field("Payment Request ID No's"; Rec."Payment Request ID No's")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("Message ID No's"; Rec."Message ID No's")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("Integration Enabled"; Rec."Integration Enabled")
                {
                    Editable = false;
                }
                field("Auth Token Endpoint"; Rec."Auth Token Endpoint")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("Payment Initiation Endpoint"; Rec."Payment Initiation Endpoint")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("Payment Status Endpoint"; Rec."Payment Status Endpoint")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("SSL Certificate Password"; Rec."SSL Certificate Password")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("Payment Instruction ID No's"; Rec."Payment Instruction ID No's")
                {
                    Editable = CitiIntegrationDisabled;
                }
                field("SSL Certificate Uploaded"; Rec."SSL Certificate Uploaded")
                {
                    Editable = false;
                }
                field("Debug Mode"; Rec."Debug Mode")
                {
                    Editable = false;
                }

            }

            group("Azure Triggers")
            {
                Caption = 'Azure Triggers';
                field("Sign And Encrypt URL"; Rec."Sign And Encrypt URL")
                {
                    ApplicationArea = all;
                    Editable = CitiIntegrationDisabled;
                }

                field("Decrypt And Verify URL"; Rec."Decrypt And Verify URL")
                {
                    ApplicationArea = all;
                    Editable = CitiIntegrationDisabled;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(EnableIntegration; "Enable/Disable Integration") { }
            actionref(UploadSSLCertificate; "Upload SSL Certificate") { }
            actionref(DeleteSSLCertificate; "Delete SSL Certificate") { }
            actionref(EnableDebugMode; "Enable/Disable Debug Mode") { }
        }

        area(Processing)
        {
            action("Enable/Disable Integration")
            {
                ToolTip = 'Allows you to enable Citi bank payments api itegration.';
                Caption = 'Enable/Disable Integration';
                Image = Bank;
                trigger OnAction()
                begin
                    if Rec."Integration Enabled" = true then begin
                        Rec."Integration Enabled" := false;
                        CitiIntegrationDisabled := true;
                    end else begin
                        ValidateCitiSetup();
                        Rec."Integration Enabled" := true;
                        CitiIntegrationDisabled := false;
                    end;
                    Rec.Modify(false);
                    CurrPage.Update();
                end;
            }

            action("Upload SSL Certificate")
            {
                ToolTip = 'Allows to Upload the certificate file.';
                ApplicationArea = All;
                Caption = 'Upload Certificate';
                Image = Import;
                trigger OnAction()
                var
                    InputStream: InStream;
                    OutputStream: OutStream;
                begin
                    if Rec."SSL Certificate Uploaded" = false and CitiIntegrationDisabled then begin
                        if File.UploadIntoStream('Upload the certificate file', '', '', Rec."SSL Certificate File", InputStream) then begin
                            Rec."SSL Certificate Value".CreateOutStream(OutputStream);
                            CopyStream(OutputStream, InputStream);
                            Rec."SSL Certificate Uploaded" := true;
                            Rec.Modify();
                        end else
                            exit;
                    end else
                        Message('%1 certificate is already uploaded', Rec."SSL Certificate File");
                end;
            }

            action("Delete SSL Certificate")
            {
                ToolTip = 'Allows to Delete the certificate file.';
                ApplicationArea = All;
                Caption = 'Delete Certificate';
                Image = Import;
                trigger OnAction()
                begin
                    if Rec."SSL Certificate Uploaded" = true and CitiIntegrationDisabled then begin
                        Clear(Rec."SSL Certificate Uploaded");
                        Clear(Rec."SSL Certificate File");
                        Clear(Rec."SSL Certificate Value");
                        Clear(Rec."SSL Certificate Password");
                        Rec.Modify(false);
                    end else
                        Message('SSL certificate is not uploaded.');
                end;
            }

            action("Enable/Disable Debug Mode")
            {
                ToolTip = 'Allows to Enable/Disable Debug Mode.';
                ApplicationArea = All;
                Caption = 'Enable Debug Mode';
                Image = Debug;
                trigger OnAction()
                begin
                    if CitiIntegrationDisabled then begin
                        if rec."Debug Mode" = true then begin
                            Rec."Debug Mode" := false;
                        end else
                            Rec."Debug Mode" := true;
                        Rec.Modify();
                        CurrPage.Update();
                    end else
                        Message('Disable Citi Integration.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not rec.Get() then begin
            rec.Init();
            rec.Insert();
        end;

        if not GuidedExperience.IsAssistedSetupComplete(ObjectType::Page, Page::"Citi Intg. Setup Wizard") then
            GuidedExperience.Run(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"Citi Intg. Setup Wizard");

        if not Rec.Get() then begin
            GuidedExperience.Run(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"Citi Intg. Setup Wizard");
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Integration Enabled" then
            CitiIntegrationDisabled := false
        else
            CitiIntegrationDisabled := true;
        CurrPage.Update();
    end;

    procedure ValidateCitiSetup()
    begin
        Rec.TestField("Client ID");
        Rec.TestField("Client Secret");
        Rec.TestField("SSL Certificate Uploaded", true);
    end;

    var
        GuidedExperience: Codeunit "Guided Experience";
        CitiIntegrationDisabled: Boolean;
}
