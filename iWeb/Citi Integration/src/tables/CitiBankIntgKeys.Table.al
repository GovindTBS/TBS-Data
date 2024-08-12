table 50141 "Citi Bank Intg. Keys"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Certificate Name"; Enum "Citi Bank Intg. Certificate")
        { }

        field(2; "Value"; Blob)
        { }

        field(3; "Uploaded"; Boolean)
        { }

        field(4; "Password"; Code[50])
        { }

        field(5; "File Name"; Text[50])
        { }
    }

    keys
    {
        key(PK; "Certificate Name")
        {
            Clustered = true;
        }
    }
}