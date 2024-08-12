page 50141 "Citi Bank Intg. Keys"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Citi Bank Intg. Keys";

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
                }

                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the name of the certificate file.';
                    ApplicationArea = all;
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the password if the certificate is password protected.';
                    ApplicationArea = all;
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
                    InStream: InStream;
                    OStream: OutStream;
                begin
                    File.UploadIntoStream('Upload the certificate file', '', 'All files (*.*)|*.*', Rec."File Name", InStream);
                    Rec."Value".CreateOutStream(OStream);
                    CopyStream(OStream, InStream);
                    Rec.Uploaded := true;
                    Rec.Modify();
                end;
            }

            action("Download Certificate")
            {
                ToolTip = 'Allows to download the certificate file.';
                ApplicationArea = All;
                Caption = 'Download Certificate';
                Image = Import;
                trigger OnAction()
                var
                    InStream: InStream;
                begin
                    if Rec.Uploaded = false then
                        exit;
                    Rec.CalcFields(Value);
                    Rec."Value".CreateInStream(InStream);
                    DownloadFromStream(InStream, '', '', '', Rec."File Name");
                end;
            }

            action("Delete Certificate")
            {
                ToolTip = 'Allows to Delete the certificate file.';
                ApplicationArea = All;
                Caption = 'Delete Certificate';
                Image = Import;
                trigger OnAction()
                var
                    InStream: InStream;
                begin
                    if Rec.Uploaded = false then
                        exit;
                    Clear(Rec.Uploaded);
                    Clear(Rec.Password);
                    Clear(Rec."File Name");
                    Clear(Rec.Value);
                end;
            }
        }
    }
}



