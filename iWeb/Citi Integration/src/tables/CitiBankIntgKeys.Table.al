table 50141 "Citi Bank Intg. Keys"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Certificate Name"; Enum "Citi Bank Intg. Certificate")
        {
            Caption = 'Certificate Name';
            DataClassification = CustomerContent;
        }

        field(2; "Value"; Blob)
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }

        field(3; "Uploaded"; Boolean)
        {
            Caption = 'Uploaded';
            DataClassification = CustomerContent;
        }

        field(4; "File Name"; Text[50])
        {
            Caption = 'File Name';
            DataClassification = CustomerContent;
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
