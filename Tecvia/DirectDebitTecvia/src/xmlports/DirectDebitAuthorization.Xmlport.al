xmlport 50141 "Direct Debit Authorization"
{
    Caption = 'Direct Debit Authorization';
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
            tableelement(Customer; Customer)
            {
                XmlName = 'Customer';
                SourceTableView = where("Payment Method Code" = filter('DD'), "Balance Due" = filter('> 0'));
                fieldelement(CustomerName; Customer.Name) { }

                textelement(CompanyName)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyName := 'FirstMile';
                    end;
                }

                tableelement(CustomerBankAccount; "Customer Bank Account")
                {
                    LinkTable = Customer;
                    LinkFields = Code = field("Preferred Bank Account Code");
                    fieldelement(BankAccountSortCode; CustomerBankAccount."Bank Branch No.") { }
                    fieldelement(BankAccountNo; CustomerBankAccount."Bank Account No.") { }
                }

                textelement(HardcodedValue0)
                {
                    trigger OnBeforePassVariable()
                    begin
                        HardcodedValue0 := '0';
                    end;
                }

                textelement(HardcodedValue0N)
                {
                    trigger OnBeforePassVariable()
                    begin
                        HardcodedValue0N := '0N';
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
                begin
                    SEPADirectDebitMandate.SetRange("Customer Bank Account Code", Customer."Preferred Bank Account Code");
                    if SEPADirectDebitMandate.FindSet() and SEPADirectDebitMandate.IsMandateActive(WorkDate()) then
                        currXMLport.Skip();
                end;


            }
        }
    }

    trigger OnInitXmlPort()
    var
    begin
        Filename('DirectDebitAuth_' + Format(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>-<Hours24,2><Minute,2><Seconds,2>') + '.csv');
    end;
}


