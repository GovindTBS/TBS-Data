/// <summary>
/// Codeunit Direct Debits Handler (ID 50100).
/// </summary>
codeunit 50144 "Direct Debits Handler"
{
    /// <summary>
    /// MailDirectDebitAuth.
    /// </summary>
    /// <param name="RecipientEmail">Text.</param>
    procedure MailDirectDebitAuth()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        EmailMessage: Codeunit "Email Message";
        DirectDebitAuthPort: XmlPort "Direct Debit Authorization";
        Inputstream: InStream;
        OutputStream: OutStream;
        SubjectLbl: Label 'Direct Debit Authorization';
        BodyLbl: Label 'You will find attached to this email a CSV file containing the results of the Direct Debit Authorization.';
        RecipientEmail: List of [Text];
    begin
        SalesReceivablesSetup.Get();

        TempBlob.CreateOutStream(OutputStream);
        DirectDebitAuthPort.SetDestination(OutputStream);
        DirectDebitAuthPort.Export();
        TempBlob.CreateInStream(Inputstream);

        //mail receipients
        if SalesReceivablesSetup."Accounts Email ID" <> '' then
            RecipientEmail.Add(SalesReceivablesSetup."Accounts Email ID")
        else
            Error('Accounts Email ID must have a value on Sales & Receivables Setup.');

        //Export csv
        ExportDirectDebitAuth();

        if Inputstream.Length() > 0 then begin
            EmailMessage.Create(RecipientEmail, SubjectLbl, BodyLbl, true);
            EmailMessage.AddAttachment(Format(DirectDebitAuthPort.Filename), 'csv', Inputstream);
            if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
                Message('Authorization Mail sent successfully.')
            else
                Message('Failed to send Authorization mail.');
        end
        else
            Message('Not found customers to send Direct Debit Authorization.');
    end;

    /// <summary>
    /// MailDirectDebitCollectionEntries.
    /// </summary>
    /// <param name="RecipientEmail">Text.</param>
    procedure MailDirectDebitCollectionEntries()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        DirectDebitCollectPort: XmlPort "Direct Debit Collection Entry";
        Inputstream: InStream;
        OutputStream: OutStream;
        SubjectLbl: Label 'Direct Debit';
        BodyLbl: Label 'You will find attached to this email a CSV file containing the results';
        RecipientEmail: List of [Text];
    begin
        SalesReceivablesSetup.Get();

        TempBlob.CreateOutStream(OutputStream);
        DirectDebitCollectPort.SetDestination(OutputStream);
        DirectDebitCollectPort.Export();
        TempBlob.CreateInStream(Inputstream);

        //mail receipients
        if SalesReceivablesSetup."Accounts Email ID" <> '' then
            RecipientEmail.Add(SalesReceivablesSetup."Accounts Email ID")
        else
            Error('Accounts Email ID must have a value on Sales & Receivables Setup.');

        if Inputstream.Length() > 0 then begin
            //Export csv
            Xmlport.Run(Xmlport::"Direct Debit Authorization");
            EmailMessage.Create(RecipientEmail, SubjectLbl, BodyLbl, true);
            EmailMessage.AddAttachment(Format(DirectDebitCollectPort.Filename), 'csv', Inputstream);
            if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
                Message('Direct Debit Collection Mail sent successfully.')
            else
                Message('Failed to send Direct Debit Collection mail.');
        end else
            Message('Valid Direct debit collection entries do not exist.');
    end;

    procedure ExportDirectDebitAuth()
    var
        TempBlob: Codeunit "Temp Blob";
        DirectDebitCollectPort: XmlPort "Direct Debit Collection Entry";
        Inputstream: InStream;
        OutputStream: OutStream;
    begin
        TempBlob.CreateOutStream(OutputStream);
        DirectDebitCollectPort.SetDestination(OutputStream);
        DirectDebitCollectPort.Export();
        TempBlob.CreateInStream(Inputstream);
        if Inputstream.Length() > 0 then
            Xmlport.Run(Xmlport::"Direct Debit Authorization");
    end;

    


    var
        GLSetup: Record "General Ledger Setup";
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";


    /// <summary>
    /// PostDirectDebitCollection.
    ///   Method
    ///      Applies customer ledger entries for customers with valid SEPA Direct Debit Mandate and due invoices. 
    ///      Sends remittance mail to finance contact for each such customer 
    ///  Variables
    ///      InvoiceList - HTML parsing text with list of invoice and its respective amount
    ///      TotalAmount - Total amount on all the invoices 
    ///      ValidCustomer - Boolean true for customer with active SEPA DD Mandate 
    ///      PostedCount - Total postd  Gen Journal Lines count
    ///     ProgressDialog - TotalEntries(Total filtered Cust Ledger entries), ProcessedEntries(Entries Posted)
    /// </summary>
    procedure PostDirectDebitCollection()
    var
        Customer: Record Customer;
        CustomerLedgEntry: Record "Cust. Ledger Entry";
        // GenJournalLine: Record "Gen. Journal Line";
        // GenJournalPostLine: Codeunit "Gen. Jnl.-Post Line";
        CustomerNo: Code[20];
        ProgressDialog: Dialog;
        InvoiceList: Text;
        TotalAmount: Decimal;
        ValidCustomer: Boolean;
        TotalEntries: Integer;
        ProcessedEntries: Integer;
    begin
        CustomerLedgEntry.SetRange("Document Type", CustomerLedgEntry."Document Type"::Invoice);
        CustomerLedgEntry.SetRange("Open", true);
        CustomerLedgEntry.SetRange("Payment Method Code", 'DD');
        CustomerLedgEntry.SetFilter("Direct Debit Mandate ID", '<> %1', '');
        CustomerLedgEntry.SetCurrentKey("Customer No.");
        CustomerLedgEntry.Ascending(true);

        GLSetup.Get();

        TotalAmount := 0;
        CustomerNo := '';
        ValidCustomer := false;
        TotalEntries := CustomerLedgEntry.Count;
        ProcessedEntries := 0;

        ProgressDialog.Open('Processing Direct Debit Collections: #1 out of #2', ProcessedEntries, TotalEntries);

        repeat
            ProgressDialog.Update(1, ProcessedEntries);
            //check for a different customer no than previous( grouping ) 
            if CustomerLedgEntry."Customer No." <> CustomerNo then begin
                //remittance mail sent
                if TotalAmount > 0 then
                    SendRemittanceEmail(Customer, TotalAmount, InvoiceList);
                //Get new customer and validate
                Customer.Get(CustomerLedgEntry."Customer No.");
                ValidCustomer := ValidateDirectDebitMandate(Customer);
                CustomerNo := CustomerLedgEntry."Customer No.";
                InvoiceList := '';
                TotalAmount := 0;
            end;
            if ValidCustomer and (CustomerLedgEntry."Due Date" < WorkDate()) then begin
                CustomerLedgEntry.CalcFields("Remaining Amount");
                // InitializeGenJournalLine(GenJournalLine, CustomerLedgEntry);
                // GenJournalLine.Insert();
                // GenJournalPostLine.Run(GenJournalLine);
                InvoiceList += Format(CustomerLedgEntry."Document No.") + ' - ' + Format(GLSetup."Local Currency Symbol") + Format(CustomerLedgEntry."Remaining Amount") + '<br>';
                TotalAmount += CustomerLedgEntry."Remaining Amount";
            end;
            ProcessedEntries += 1;
        until CustomerLedgEntry.Next() = 0;

        if TotalAmount > 0 then
            SendRemittanceEmail(Customer, TotalAmount, InvoiceList);

        ProgressDialog.Close();
    end;

    procedure CreateDirectDebitCollectionAndSendRemittanceMail(DirectDebitCollection: Record "Direct Debit Collection")
    var
        DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";
        CreateDebitCollectionReport: Report "Create Direct Debit Collection";
        PostDirectDebitCollectionReport: Report "Post Direct Debit Collection";
        ReportParameters: Text;
    begin
        MailDirectDebitCollectionEntries();
        PostDirectDebitCollection();

        // create collection
        ReportParameters := CreateCollectionParam('2022-01-01', '2025-01-01', '1', 'true', 'true', '1301', 'Barclays current account');
        CreateDebitCollectionReport.Execute(ReportParameters);

        //reset transfer date
        DirectDebitCollection.FindLast();
        DirectDebitCollectionEntry.SetRange("Direct Debit Collection No.", DirectDebitCollection."No.");
        DirectDebitCollectionEntry.SetRange(Status, DirectDebitCollectionEntry.Status::New);

        DirectDebitCollectionEntry.SetFilter("Transfer Date", '<%1', Today());
        if DirectDebitCollectionEntry.FindSet() then
            repeat
                DirectDebitCollectionEntry.Validate("Transfer Date", Today());
                DirectDebitCollectionEntry.Status := DirectDebitCollectionEntry.Status::"File Created";
                DirectDebitCollectionEntry.Modify();
            until DirectDebitCollectionEntry.Next() = 0;
        DirectDebitCollection.Status := DirectDebitCollection.Status::"File Created";
        DirectDebitCollection.Modify();

        //post
        Clear(ReportParameters);
        ReportParameters := CreatePostDirectDebitCollectionParameters(Format(DirectDebitCollection."No."), Format(DirectDebitCollection.Identifier), '2', '1301', 'CASHRCPT', 'DDEBIT', 'false');
        PostDirectDebitCollectionReport.Execute(ReportParameters);

    end;


    local procedure SendRemittanceEmail(Customer: Record Customer; TotalAmount: Decimal; InvoiceList: Text)
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        SubjectLbl: Label 'Sandbox: Direct Debit Remittance for your account %1', Comment = '%1 = Customer Account No.';
        BodyLbl: Label ' <p>Remittance Date: <strong>%1</strong> </p><p> Account Name:  <strong>%2</strong></p> <p> First Mile Account Code:   <strong>%3</strong></p> <p> Total of invoices due for payment:   <strong>%4</strong></p><p>This amount will be debited from your account in the next 3 working days.</p> <p>For a full list of invoices on your account, including payment due dates, please visit <a href="portal.thefirstmile.co.uk">portal.thefirstmile.co.uk</a>.</p><p>Your total debited is the total of all unpaid invoices which were due for payment up to and including today.</p>List of Invoices being paid:<br>%5', Comment = '%1 = Workdate, %2 = Customer Name, %3 = Customer No., %4 = Total amount, %5 = List of invoives with invoice no and amount';
    begin
        if GetFinanceContactEmail(Customer) <> '' then begin
            EmailMessage.Create(GetFinanceContactEmail(Customer), StrSubstNo(SubjectLbl, Customer."Preferred Bank Account Code"), StrSubstNo(BodyLbl, WorkDate(), Customer.Name, Customer."No.", Format(GLSetup."Local Currency Symbol") + Format(TotalAmount), InvoiceList), true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end else
            Message('Email not found for customer %1', Customer.Name);
    end;

    local procedure ValidateDirectDebitMandate(Customer: Record Customer): Boolean
    begin
        SEPADirectDebitMandate.SetRange("Customer Bank Account Code", Customer."Preferred Bank Account Code");
        exit(SEPADirectDebitMandate.FindSet() and SEPADirectDebitMandate.IsMandateActive(WorkDate()));
    end;

    local procedure GetFinanceContactEmail(Customer: Record Customer): Text
    var
    // Contact: Record Contact;
    begin
        // Contact.SetFilter("Company Name", Customer.Name);
        // Contact.SetRange("Organizational Level Code", 'CFO');
        // if Contact.FindFirst() then
        // exit(Contact."E-Mail")
        // else
        exit(Customer."E-Mail");
    end;

    local procedure CreateCollectionParam(FromDate: Text; ToDate: Text; PartnerType: Text; OnlyCustomersWithMandate: Text; OnlyInvoicesWithMandate: Text; BankAccountNo: Text; BankAccountName: Text): Text
    var
        ReportParametersTemplate: Text;
    begin
        ReportParametersTemplate :=
            ' <?xml version="1.0" standalone="yes"?>' +
            '<ReportParameters name="Create Direct Debit Collection" id="1200">' +
            '<Options>' +
            '<Field name="FromDate">%1</Field>' +
            '<Field name="ToDate">%2</Field>' +
            '<Field name="PartnerType">%3</Field>' +
            '<Field name="OnlyCustomersWithMandate">%4</Field>' +
            '<Field name="OnlyInvoicesWithMandate">%5</Field>' +
            '<Field name="BankAccount.quot;No.quot;">%6</Field>' +
            '<Field name="BankAccount.Name">%7</Field>' +
            '</Options>' +
            '<DataItems>' +
            '<DataItem name="Customer">VERSION(1) SORTING(Field1)</DataItem>' +
            '<DataItem name="Cust. Ledger Entry">VERSION(1) SORTING(Field36,Field37)</DataItem>' +
            '</DataItems>' +
            '</ReportParameters>';

        exit(STRSUBSTNO(ReportParametersTemplate, FromDate, ToDate, PartnerType, OnlyCustomersWithMandate, OnlyInvoicesWithMandate, BankAccountNo, BankAccountName));
    end;

    procedure CreatePostDirectDebitCollectionParameters(DirectDebitCollectionNo: Text; DirectDebitCollectionIdentifier: Text; DirectDebitCollectionStatus: Text; ToBankAccountNo: Text; GeneralJournalTemplateName: Text; GeneralJournalBatchName: Text; CreateJnlOnly: Text): Text
    var
        ReportParametersTemplate: Text;
    begin
        ReportParametersTemplate :=
            '<?xml version="1.0" standalone="yes"?>' +
            '<ReportParameters name="Post Direct Debit Collection" id="1201">' +
            '<Options>' +
            '<Field name="DirectDebitCollectionNo">%1</Field>' +
            '<Field name="DirectDebitCollection.Identifier">%2</Field>' +
            '<Field name="DirectDebitCollection.Status">%3</Field>' +
            '<Field name="DirectDebitCollection.quot;To Bank Account No.quot;">%4</Field>' +
            '<Field name="GeneralJournalTemplateName">%5</Field>' +
            '<Field name="GeneralJournalBatchName">%6</Field>' +
            '<Field name="CreateJnlOnly">%7</Field>' +
            '</Options>' +
            '<DataItems>' +
            '<DataItem name="Direct Debit Collection Entry">VERSION(1) SORTING(Field1,Field2)</DataItem>' +
            '</DataItems>' +
            '</ReportParameters>';

        exit(STRSUBSTNO(ReportParametersTemplate, DirectDebitCollectionNo, DirectDebitCollectionIdentifier, DirectDebitCollectionStatus, ToBankAccountNo, GeneralJournalTemplateName, GeneralJournalBatchName, CreateJnlOnly));
    end;

    // local procedure InitializeGenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; CustomerLedgEntry: Record "Cust. Ledger Entry")
    // var
    //     GenJournalBatches: Record "Gen. Journal Batch";
    // begin
    //     GenJournalLine.Init();
    //     GenJournalLine."Journal Template Name" := 'CASHRCPT';
    //     GenJournalLine."Journal Batch Name" := 'DDEBIT';
    //     GenJournalBatches.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
    //     GenJournalLine.Validate("Bal. Account Type", GenJournalBatches."Bal. Account Type");
    //     GenJournalLine.Validate("Bal. Account No.", GenJournalBatches."Bal. Account No.");
    //     GenJournalLine."Line No." := GenJournalLine.GetNewLineNo(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
    //     GenJournalLine.Validate("Posting Date", CustomerLedgEntry."Posting Date");
    //     GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
    //     GenJournalLine.Description := 'Direct Debit Payment for ' + CustomerLedgEntry."Customer No." + ' Invoice ' + CustomerLedgEntry."Document No.";
    //     GenJournalLine.CopyFromPaymentCustLedgEntry(CustomerLedgEntry); // Copies Dimension values
    //     GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
    //     GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
    //     GenJournalLine.Validate("Applies-to Doc. No.", CustomerLedgEntry."Document No.");
    //     GenJournalLine.Validate(Amount, -CustomerLedgEntry."Remaining Amount");
    //     GenJournalLine.Validate("Account No.", CustomerLedgEntry."Customer No.");
    // end;

}
