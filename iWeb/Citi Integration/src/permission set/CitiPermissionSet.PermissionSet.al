permissionset 50140 "Citi Permission Set"
{
    Assignable = true;
    Caption = 'Citi Integration Permissions', Locked = true;
    Permissions = tabledata "Citi Bank Intg. Keys" = RMID,
        tabledata "Citi Bank Intg. Setup" = RMID,
        codeunit "Citi Intg Encryption Handler" = X,
        codeunit "Citi Intg API Handler" = X,
        table "Citi Bank Intg. Setup" = X,
        page "Citi Bank Intg. Setup" = X,
        table "Citi Bank Intg. Keys" = X,
        codeunit "Citi Intg. Setup Subscribers" = X,
        xmlport "SEPA CITI pain.001.001.03" = X,
        page "Citi Bank Intg. Keys" = X,
        page "Citi Intg. Setup Wizard" = X;
}