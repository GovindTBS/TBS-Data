namespace Isabel6;

page 50140 "Isabel6 Setup"
{
    PageType = Card;
    Caption = 'Isabel6 Setup';
    SourceTable = "Isabel6 Setup";
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Isabel6';
                field("Client ID"; Rec."Isabel6 Client ID")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Client Secret"; Rec."Isabel6 Client Secret")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Auth Token Endpoint"; Rec."Isabel6 Auth Token Endpoint")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Payment Initiation Endpoint"; Rec."Payment Initiation Endpoint")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Integration Enabled"; Rec."Integration Enabled")
                {
                    Editable = false;
                }
                field("Authorization Code"; Rec."Authorization Code")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("SSL Certificate File"; Rec."SSL Certificate File")
                {
                    Editable = false;
                }
                field("SSL Certificate Password"; Rec."SSL Certificate Password")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Payment Status Endpoint"; Rec."Payment Status Endpoint")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("SSL Certificate Uploaded"; Rec."SSL Certificate Uploaded")
                {
                    Editable = false;
                }
            }

            group(Codabox)
            {
                field("Codabox Client ID"; Rec."Codabox Client ID")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field(" Codabox Client Secret"; Rec."Codabox Client Secret")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Codabox Auth Token Endpoint"; Rec."Codabox Auth Token Endpoint")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Accounting Office Company No."; Rec."Accounting Office Company No.")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Account Statement Endpoint"; Rec."Account Statement Endpoint")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Accounting Office Endpoint"; Rec."Accounting Office Endpoint")
                {
                    Editable = Isabel6IntegrationEnabled;
                }
                field("Document Search Endpoint"; Rec."Document Search Endpoint")
                {
                    Editable = Isabel6IntegrationEnabled;
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
        }

        area(Processing)
        {
            action("Enable/Disable Integration")
            {
                ApplicationArea = all;
                ToolTip = 'Allows you to enable Citi bank payments api itegration.';
                Caption = 'Enable/Disable Integration';
                Image = Bank;
                trigger OnAction()
                begin
                    if Rec."Integration Enabled" = true then begin
                        Rec."Integration Enabled" := false;
                        Isabel6IntegrationEnabled := true;
                    end else begin
                        ValidateCitiSetup();
                        Rec."Integration Enabled" := true;
                        Isabel6IntegrationEnabled := false;
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
                    if Rec."SSL Certificate Uploaded" = false and Isabel6IntegrationEnabled then begin
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
                    if Rec."SSL Certificate Uploaded" = true and Isabel6IntegrationEnabled then begin
                        Clear(Rec."SSL Certificate Uploaded");
                        Clear(Rec."SSL Certificate File");
                        Clear(Rec."SSL Certificate Value");
                        Clear(Rec."SSL Certificate Password");
                        Rec.Modify(false);
                    end else
                        Message('SSL certificate is not uploaded.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(false);
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Integration Enabled" then
            Isabel6IntegrationEnabled := false
        else
            Isabel6IntegrationEnabled := true;
        CurrPage.Update();
    end;

    procedure ValidateCitiSetup()
    begin
        Rec.TestField("Isabel6 Client ID");
        Rec.TestField("Isabel6 Client Secret");
        Rec.TestField("SSL Certificate Uploaded", true);
    end;

    var
        Isabel6IntegrationEnabled: Boolean;
}