table 50100 "General Journal Buffer"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(11; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(51; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(76; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(288; "Recipient Bank Account"; Code[20])
        {
            Caption = 'Recipient Bank Account';
        }
        field(50144; "Beneficiary Currency Code"; Code[10])
        {
            Caption = 'Beneficiary Currency Code';
            Tooltip = 'Specifies the Beneficiary Currency Code.';
            DataClassification = CustomerContent;
            TableRelation = Currency.Code;
        }
    }

    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure GetFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        TransferFields(GenJnlLine);
        Insert();
    end;
}