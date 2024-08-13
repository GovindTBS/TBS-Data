page 50100 "Citi Intg. Setup Wizard"
{
    Caption = 'Citi Integration Setup Wizard';
    PageType = NavigatePage;
    SourceTable = "Citi Bank Intg. Setup";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(StandardBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(Step1)
            {
                Visible = Step1Visible;
                group("Welcome to General Ledger Setup Wizard")
                {
                    Caption = 'Welcome to Citi Bank Integration Setup Wizard';
                    Visible = Step1Visible;
                    group(Welcome)
                    {
                        ShowCaption = false;
                        InstructionalText = 'This wizard will guide you through the setup process for integrating Citi Bank with your Business Central environment. Please ensure you have all required credentials and certificates ready.';
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    group(Group10)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Click Next to begin configuring the basic settings needed for the integration.';
                    }
                }
            }

            group(Step2)
            {
                Caption = 'General';
                InstructionalText = 'Please enter your Citi Bank Client ID and Client Secret. These credentials are essential for secure communication between your Business Central environment and Citi Bank''s API services.';
                Visible = Step2Visible;

                group(Step21)
                {
                    ShowCaption = false;
                    InstructionalText = 'Enter the unique Client ID provided by Citi Bank for API authentication.';
                    field("Client ID"; Rec."Client ID")
                    {
                        ToolTip = 'Specifies the unique Client ID provided by Citi Bank for API authentication.';
                        ApplicationArea = All;
                    }
                }
                group(Step22)
                {
                    ShowCaption = false;
                    InstructionalText = 'Enter the Client Secret for secure communication with Citi Bank''s API.';
                    field("Client Secret"; Rec."Client Secret")
                    {
                        ToolTip = 'Specifies the Client Secret associated with your Client ID for secure API communication.';
                        ApplicationArea = All;
                    }
                }
            }
            group(Step3)
            {
                Caption = 'SSL/TLS Certificates';
                InstructionalText = 'In this step, you will upload the required SSL/TLS certificates to ensure secure and encrypted communication with Citi Bank.';
                Visible = Step3Visible;
                part("CitiBankKeys"; "Citi Bank Intg. Keys")
                {
                    ApplicationArea = all;
                }
            }


            group(Step4)
            {
                Visible = Step4Visible;
                group(Group23)
                {
                    Caption = 'Setup Complete';
                    InstructionalText = 'You have successfully completed the setup process. Your Citi Bank integration is now ready for use.';
                }
                group("Final Steps")
                {
                    Caption = 'Final Steps';
                    group(Group25)
                    {
                        ShowCaption = false;
                        InstructionalText = 'To finalize and save this setup, click Finish. If you need to review any of the steps, you can navigate back using the Previous button.';
                    }

                    group(Group26)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Enable the integration using the Enable/Disable Integration action available on the Citi Bank Integration setup page.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }

    trigger OnInit();
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage();
    begin
        Rec.Init();
        if CitiIntgSetup.Get() then
            Rec.TransferFields(CitiIntgSetup);
        Rec.Insert();

        InitCitiBankKeys();

        Step := Step::Start;
        EnableControls();
    end;

    var
        CitiIntgKeys: Record "Citi Bank Intg. Keys";
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";
        GuidedExperience: Codeunit "Guided Experience";
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        Step4Visible: Boolean;
        Step: Option Start,Step2,Step3,Finish;
        BackActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        TopBannerVisible: Boolean;

    local procedure EnableControls();
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStep1();
            Step::Step2:
                ShowStep2();
            Step::Step3:
                ShowStep3();
            Step::Finish:
                ShowStep4();
        end;
    end;

    local procedure StoreRecordVar();
    begin
        if not CitiIntgSetup.Get() then begin
            CitiIntgSetup.Init();
            CitiIntgSetup.Insert();
        end;

        CitiIntgSetup.TransferFields(Rec, false);
        CitiIntgSetup.Modify(true);
    end;


    local procedure FinishAction();
    begin
        StoreRecordVar();
        GuidedExperience.CompleteAssistedSetup(ObjectType::Page, PAGE::"Citi Intg. Setup Wizard");
        CurrPage.Close();
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            Step := Step - 1
        ELSE
            Step := Step + 1;

        EnableControls();
    end;

    local procedure ShowStep1();
    begin
        Step1Visible := true;
        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowStep2();
    begin
        Step2Visible := true;
    end;

    local procedure ShowStep3();
    begin
        Step3Visible := true;
    end;

    local procedure ShowStep4();
    begin
        Step4Visible := true;
        NextActionEnabled := false;
        FinishActionEnabled := true;
    end;

    local procedure ResetControls();
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
        Step4Visible := false;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) and
            MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType()))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and
                MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
        then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;

    local procedure InitCitiBankKeys()
    var
        Index: Integer;
    begin
        CitiIntgKeys.DeleteAll();
        Index := 1;
        repeat
            CitiIntgKeys.Init();
            CitiIntgKeys.Validate("Certificate Name", Index);
            CitiIntgKeys.Insert();
            Index += 1;
        until Index = Enum::"Citi Bank Intg. Certificate".Names().Count() + 1;
    end;

}
