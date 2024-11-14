tableextension 50105 "User Setup" extends "User Setup"
{
    fields
    {
        field(50100; "Allow Isabel Payments"; Boolean)
        {
            Caption = 'Allow Isabel Payments';
            // CaptionML = ENU = 'Allow Isabel Payments';
            ToolTip = 'Allow the user to make Isabel Payments.';
            DataClassification = CustomerContent;
        }
    }
}