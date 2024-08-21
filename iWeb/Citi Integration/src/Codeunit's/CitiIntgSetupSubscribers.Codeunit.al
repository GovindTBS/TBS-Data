codeunit 50100 "Citi Intg. Setup Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddCitiIntgSetupWizard()
    var
        AssistedSetup: Codeunit "Guided Experience";
    begin
        AssistedSetup.InsertAssistedSetup(SetupTxt, SetupTxt, SetupTxt, 1000, ObjectType::Page, Page::"Citi Intg. Setup Wizard",
                        "Assisted Setup Group"::Connect,
                        '',
                        "Video Category"::Uncategorized,
                        '');
    end;

    var
        SetupTxt: Label 'Set up Citi Bank Integration';
}