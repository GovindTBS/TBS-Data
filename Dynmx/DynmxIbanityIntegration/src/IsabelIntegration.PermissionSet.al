namespace Isabel6;

permissionset 50100 "Isabel Integration"
{
    Assignable = true;
    Permissions = tabledata "Isabel6 Setup" = RIMD,
        table "Isabel6 Setup" = X,
        table "Payment Journal Buffer" = x,
        table "Isabel Trasaction Logs" = X,
        page "Isabel6 Setup" = X,
        codeunit "Isabel6 Payment API Mgt." = X,
        report "Isabel6 Bank Statement" = X,
        codeunit "Codabox Bank Stmt API Mgt." = X,
        tabledata "Isabel Trasaction Logs" = RIMD,
        tabledata "Payment Journal Buffer" = RMID;
}