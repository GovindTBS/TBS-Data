page 50141 "Citi Bank Intg. Keys"
{
    Caption = 'Citi Bank Integration Keys';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Citi Bank Intg. Keys";
    Permissions = tabledata "Citi Bank Intg. Setup" = R;

    layout
    {
        area(Content)
        {
            repeater(Keys)
            {
                field("Certificate Name"; Rec."Certificate Name")
                {
                    Caption = 'Certificate Name';
                    Editable = false;
                }

                field("Uploaded"; Rec.Uploaded)
                {
                    Caption = 'Uploaded';
                    Editable = false;
                }

                field("File Name"; Rec."File Name")
                {
                    Caption = 'File Name';
                    Editable = false;
                }

                field(Password; Rec.Password)
                {
                    Caption = 'Password';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Upload Certificate")
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
                    if Rec.Uploaded = false and checkAllowKeysModification() then begin
                        if File.UploadIntoStream('Upload the certificate file', '', '', Rec."File Name", InputStream) then begin
                            Rec."Value".CreateOutStream(OutputStream);
                            CopyStream(OutputStream, InputStream);
                            Rec.Uploaded := true;
                            Rec.Modify();
                        end else
                            exit;
                    end else
                        Message('%1 certificate is already uploaded', Rec."Certificate Name");
                end;
            }

            action("Delete Certificate")
            {
                ToolTip = 'Allows to Delete the certificate file.';
                ApplicationArea = All;
                Caption = 'Delete Certificate';
                Image = Import;
                trigger OnAction()
                begin
                    if Rec.Uploaded = true and checkAllowKeysModification() then begin
                        Clear(Rec.Uploaded);
                        Clear(Rec."File Name");
                        Clear(Rec.Value);
                        Clear(Rec.Password);
                        Rec.Modify(false);
                    end else
                        Message('%1 certificate is not uploaded', Rec."Certificate Name");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        GetCitiIntgSetup();
    end;

    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";

    local procedure GetCitiIntgSetup()
    begin
        CitiIntgSetup.Get();
    end;

    local procedure checkAllowKeysModification(): Boolean
    begin
        GetCitiIntgSetup();
        if CitiIntgSetup."Integration Enabled" then
            Error('Disable Integration to modify key values.')
        else
            exit(true);
    end;
}



