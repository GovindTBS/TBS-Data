codeunit 50143 "Isabel6 Event Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", 'OnAfterFinalizePost', '', false, false)]
    local procedure OnAfterOnAfterFinalizePost(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        Isabel6Setup: Record "Isabel6 Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        Isabel6Setup.Get();
        if Isabel6Setup."Allow Reconciliation Mail" then begin
            EmailMessage.SetSubject('Test mail');
            EmailMessage.SetBody('This mail is to give a confirmation of bank reconciliation');
            if Email.Send(EmailMessage, Enum::"Email Scenario"::"Finance Department") then
                Message('Reconciliation Mail Sent');
        end;
    end;
}