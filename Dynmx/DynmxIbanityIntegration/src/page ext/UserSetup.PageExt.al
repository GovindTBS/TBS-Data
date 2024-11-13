namespace Isabel6;

using System.Security.User;

pageextension 50143 "User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Allow Isabel Payments"; Rec."Allow Isabel Payments")
            {
                ApplicationArea = all;
                ToolTip = 'Allow the user to process Isabel payments';
            }
        }
    }
}