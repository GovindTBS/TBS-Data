table 50141 "Citi Bank Intg. Keys"
{
    Caption = 'Citi Bank Integration Keys';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Certificate Name"; Enum "Citi Bank Intg. Certificate")
        {
            Caption = 'Certificate Name';
            ToolTip = 'Specifies the name of the certificate uploaded.';
            Editable = false;
        }

        field(2; "Value"; Blob)
        {
            Caption = 'Value';
            ToolTip = 'Specifies the name of the certificate file.';
        }

        field(3; "Uploaded"; Boolean)
        {
            Caption = 'Uploaded';
            ToolTip = 'Specifies if the certificate is uploaded.';
        }

        field(4; "File Name"; Text[50])
        {
            Caption = 'File Name';
            ToolTip = 'Specifies the name of the certificate file.';
        }

        field(5; "Password"; Text[100])
        {
            Caption = 'Password';
            ToolTip = 'Specifies the password of the certificate file.';
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; "Certificate Name")
        {
            Clustered = true;
        }
    }

    procedure ReturnKeyText(var IStream: InStream): Text
    var
        FileContent: Text;
        TempText: Text;
    begin
        while not IStream.EOS do begin
            IStream.ReadText(TempText);
            FileContent := FileContent + TempText;
        end;
        exit(FileContent);
    end;
}
