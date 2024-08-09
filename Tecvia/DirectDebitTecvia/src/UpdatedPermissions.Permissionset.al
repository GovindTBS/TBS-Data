/// <summary>
/// Unknown Updated Permissions (ID 50100).
/// </summary>
permissionset 50141 "Updated Permissions"
{
    Assignable = true;
    Caption = 'Updated Permissions set', Locked = true;
    Permissions =
    codeunit "Direct Debits Handler" = X,
    xmlport "Direct Debit Collection Entry" = X,
        xmlport "Direct Debit Authorization" = X;
}