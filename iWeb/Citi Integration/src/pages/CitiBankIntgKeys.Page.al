page 50141 "Citi Bank Intg. Keys"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Citi Bank Intg. Keys";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Keys)
            {
                field("Certificate Name"; Rec."Certificate Name")
                {
                    ToolTip = 'Specifies the name of the certificate uploaded.';
                    ApplicationArea = All;
                }

                field("Uploaded"; Rec.Uploaded)
                {
                    ToolTip = 'Specifies if the certificate is uploaded.';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the name of the certificate file.';
                    ApplicationArea = all;
                    Editable = false;
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
                    KeyValue: Text;
                begin
                    if Rec.Uploaded = false and checkAllowKeysModification() then begin
                        if File.UploadIntoStream('Upload the certificate file', '', 'PEM files (*.pem)|*.pem', Rec."File Name", InputStream) then begin
                            Rec."Value".CreateOutStream(OutputStream);
                            CopyStream(OutputStream, InputStream);
                            Rec.Uploaded := true;
                            Rec.Modify();
                        end else
                            exit;
                    end else
                        Message('%1 certificate is already uploaded', rec."Certificate Name");
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
                        Rec.Modify();
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

    procedure ValidatePemFileFormatFromStream(var InputStream: InStream): Boolean;
    var
        PemFileContent: Text;
        StartMarker: Text;
        EndMarker: Text;
        StartPos: Integer;
        EndPos: Integer;
    begin
        StartMarker := '-----BEGIN CERTIFICATE-----';
        EndMarker := '-----END CERTIFICATE-----';

        PemFileContent := Rec.ReturnKeyText(InputStream);

        StartPos := StrPos(PemFileContent, StartMarker);
        EndPos := StrPos(PemFileContent, EndMarker);

        if (StartPos = 0) or (EndPos = 0) or (EndPos < StartPos) then
            Error('Invalid PEM file format: Missing or incorrectly ordered certificate markers.');

        if (EndPos - (StartPos + StrLen(StartMarker))) <= 0 then
            Error('Invalid PEM file format: No content found between certificate markers.');

        exit(true);
    end;


}



