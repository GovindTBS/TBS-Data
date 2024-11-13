namespace Isabel6;

table 50101 "Isabel Trasaction Logs"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Request ID"; Text[200])
        {
            ToolTip = 'Specifies the payment request ID.';
        }
        field(2; "Initiation Date & Time"; DateTime)
        {
            ToolTip = 'Specifies the Payment Initiation Date & Time';
        }
        field(3; "Amount"; Decimal)
        {
            ToolTip = 'Specifies the Payment Amount.';
        }
        field(4; "Status"; Text[100])
        {
            ToolTip = 'Specifies the last fetched payment status';
        }
        field(5; "Status Checked Last At"; DateTime)
        {
            ToolTip = 'Specifies the date and time when the status was last checked for the payment.';
        }
    }

    keys
    {
        key(PK; "Request ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Initiation Date & Time" := CurrentDateTime;
    end;
}