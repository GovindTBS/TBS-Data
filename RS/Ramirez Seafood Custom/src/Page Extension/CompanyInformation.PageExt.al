pageextension 50141 "Company Information" extends "Company Information"
{
    layout
    {
        addlast(General)
        {
            field("Shellfish Permit"; Rec."Shellfish Permit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Shellfish Permit no.';
            }
        }
    }

    actions
    {
    }
}