permissionset 50140 "Citi Permission Set"
{
    Assignable = true;
    Caption = 'Citi Integration Permissions', Locked = true;
    Permissions = tabledata "Citi Bank API Setup" = RMID,
        table "Citi Bank API Setup" = X,
        page "Citi Bank API Setup" = X,
        xmlport "SEPA WIRE pain.001.001.03" = X,
        page "Citi Intg. Setup Wizard" = X,
        tabledata "General Journal Buffer" = RIMD,
        table "General Journal Buffer" = X,
        codeunit "Citi Azure Triggers Mgt." = X,
        codeunit "Citi Bank API Event Mgt." = X,
        codeunit "Citi Bank API Management" = X;
}