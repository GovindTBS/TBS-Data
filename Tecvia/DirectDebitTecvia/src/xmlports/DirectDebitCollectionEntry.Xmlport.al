xmlport 50142 "Direct Debit Collection Entry"
{
    Caption = 'Direct Debit Collection Entries';
    Direction = Export;
    Format = VariableText;
    FieldSeparator = ',';
    TableSeparator = ',';
    FieldDelimiter = '"';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(CustLedgerEntry; "Cust. Ledger Entry")
            {
                XmlName = 'CustLedgerEntry';
                SourceTableView = where("Payment Method Code" = filter('DD'), "Remaining Amount" = filter('> 0'), "Document Type" = const(Invoice));

                fieldelement(CustomerName; CustLedgerEntry."Customer Name") { }

                textelement(CompanyName)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyName := 'FirstMile';
                    end;
                }

                tableelement(Customer; Customer)
                {
                    LinkTable = CustLedgerEntry;
                    LinkFields = "No." = field("Customer No.");

                    tableelement(CustomerBankAccount; "Customer Bank Account")
                    {
                        LinkTable = Customer;
                        LinkFields = Code = field("Preferred Bank Account Code");

                        fieldelement(BankAccountSortCode; CustomerBankAccount."Bank Branch No.") { }
                        fieldelement(BankAccountNo; CustomerBankAccount."Bank Account No.") { }
                    }
                }

                fieldelement(Amount; CustLedgerEntry."Remaining Amount") { }

                textelement(LogicalFlag)
                {
                    trigger OnBeforePassVariable()
                    var
                        Customer: Record Customer;
                    begin
                        Customer.Get(CustLedgerEntry."Customer No.");
                        LogicalFlag := GetLogicalFLag(Customer);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    Customer: Record Customer;
                begin
                    Customer.Get(CustLedgerEntry."Customer No.");
                    ValidateDirectDebitMandate(Customer);

                    if CustLedgerEntry."Due Date" > WorkDate() then
                        currXMLport.Skip();
                end;
            }
        }
    }

    trigger OnInitXmlPort()
    begin
        Filename('DirectDebit_' + Format(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>-<Hours24,2><Minute,2><Seconds,2>') + '.csv');
    end;

    local procedure ValidateDirectDebitMandate(Customer: Record Customer)
    var
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
    begin
        SEPADirectDebitMandate.SetRange("Customer Bank Account Code", Customer."Preferred Bank Account Code");
        if not SEPADirectDebitMandate.FindSet() or not SEPADirectDebitMandate.IsMandateActive(WorkDate()) then
            currXMLport.Skip();
    end;

    local procedure GetLogicalFLag(Customer: Record Customer) LogicalFlag: Code[2]
    var
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
    begin
        SEPADirectDebitMandate.SetRange("Customer No.", Customer."No.");
        SEPADirectDebitMandate.SetRange("Customer Bank Account Code", Customer."Preferred Bank Account Code");
        SEPADirectDebitMandate.FindFirst();
        if SEPADirectDebitMandate."Debit Counter" > 0 then
            LogicalFlag := '17'
        else
            LogicalFlag := '01';
        exit(LogicalFlag);
    end;

}