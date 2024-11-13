xmlport 50140 "SEPA pain.001.001.03"
{
    Caption = 'SEPA pain.001.001.03';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    PreserveWhiteSpace = false;

    schema
    {
        tableelement("Payment Journal Buffer"; "Payment Journal Buffer")
        {
            XmlName = 'Document';

            tableelement(companyinformation; "Company Information")
            {
                XmlName = 'CstmrCdtTrfInitn';
                textelement(GrpHdr)
                {
                    textelement(messageid)
                    {
                        XmlName = 'MsgId';
                        trigger OnBeforePassVariable()
                        begin
                            messageid := '';
                        end;
                    }
                    textelement(createddatetime)
                    {
                        XmlName = 'CreDtTm';
                    }
                    textelement(nooftransfers)
                    {
                        XmlName = 'NbOfTxs';
                    }
                    textelement(controlsum)
                    {
                        XmlName = 'CtrlSum';
                    }
                    textelement(InitgPty)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(initgptypstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(StrtNm; CompanyInformation.Address)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.Address = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(PstCd; CompanyInformation."Post Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Post Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(TwnNm; CompanyInformation.City)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.City = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(Ctry; CompanyInformation."Country/Region Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Country/Region Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                    }
                }

                tableelement(paymentexportdatagroup; "Payment Export Data")
                {
                    XmlName = 'PmtInf';
                    UseTemporary = true;

                    textelement(PmtInfId)
                    {
                        XmlName = 'PmtInfId';

                        trigger OnBeforePassVariable()
                        begin
                            PmtInfId := '';
                        end;
                    }
                    fieldelement(PmtMtd; PaymentExportDataGroup."SEPA Payment Method Text")
                    {
                    }
                    fieldelement(BtchBookg; PaymentExportDataGroup."SEPA Batch Booking")
                    {
                    }
                    textelement(PmtTpInf)
                    {
                        textelement(SvcLvl)
                        {
                            textelement(Cd)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    Cd := 'NURG';
                                end;
                            }
                        }
                        textelement(LclInstrm)
                        {
                            textelement(Cd1)
                            {
                                XmlName = 'Cd';
                                trigger OnBeforePassVariable()
                                begin
                                    Cd1 := 'CCP';
                                end;
                            }
                        }
                    }
                    fieldelement(ReqdExctnDt; PaymentExportDataGroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        textelement(DebtorName)
                        {
                            XmlName = 'Nm';
                        }
                        textelement(dbtrpstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(StrtNm; CompanyInformation.Address)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.Address = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(PstCd; CompanyInformation."Post Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Post Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(TwnNm; CompanyInformation.City)
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation.City = '' then
                                        currXMLport.Skip();
                                end;
                            }
                            fieldelement(Ctry; CompanyInformation."Country/Region Code")
                            {

                                trigger OnBeforePassField()
                                begin
                                    if CompanyInformation."Country/Region Code" = '' then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                    }
                    textelement(DbtrAcct)
                    {
                        textelement(dbtracctid)
                        {
                            XmlName = 'Id';
                            textelement(otherdbtraccid)
                            {
                                XmlName = 'Othr';
                                fieldelement(IBAN; PaymentExportDataGroup."Sender Bank Account No.")
                                {
                                    XmlName = 'Id';
                                }
                            }
                        }
                    }
                    textelement(DbtrAgt)
                    {
                        textelement(dbtragtfininstnid)
                        {
                            XmlName = 'FinInstnId';
                            fieldelement(BIC; PaymentExportDataGroup."Sender Bank BIC")
                            {
                            }
                        }
                    }

                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = field("Sender Bank BIC"), "SEPA Instruction Priority Text" = field("SEPA Instruction Priority Text"), "Transfer Date" = field("Transfer Date"), "SEPA Batch Booking" = field("SEPA Batch Booking"), "SEPA Charge Bearer Text" = field("SEPA Charge Bearer Text");
                        LinkTable = PaymentExportDataGroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            textelement(InstrId)
                            {
                                XmlName = 'InstrId';
                                trigger OnBeforePassVariable()
                                begin
                                    InstrId := '';
                                end;
                            }
                            textelement(EndToEndID)
                            {
                                XmlName = 'EndToEndId';
                                trigger OnBeforePassVariable()
                                begin
                                    EndToEndID := '';
                                end;
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt; PaymentExportData.Amount)
                            {
                                fieldattribute(Ccy; PaymentExportData."Currency Code")
                                {
                                }
                            }
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                textelement(ClrSysMmbId)
                                {
                                    XmlName = 'ClrSysMmbId';
                                    fieldelement(MmbId; PaymentExportData."Transit No.")
                                    {
                                    }
                                }
                            }
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm; PaymentExportData."Recipient Name")
                            {
                            }
                            textelement(cdtrpstladr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(StrtNm; PaymentExportData."Recipient Address")
                                {
                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Address" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(PstCd; PaymentExportData."Recipient Post Code")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Post Code" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(TwnNm; PaymentExportData."Recipient City")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient City" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                                fieldelement(Ctry; PaymentExportData."Recipient Country/Region Code")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Country/Region Code" = '' then
                                            currXMLport.Skip();
                                    end;
                                }
                            }
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                textelement(cdtracctOtherid)
                                {
                                    XmlName = 'Othr';
                                    fieldelement(IBAN; PaymentExportData."Recipient Bank Acc. No.")
                                    {
                                        XmlName = 'Id';
                                        FieldValidate = yes;
                                        MaxOccurs = Once;
                                        MinOccurs = Once;
                                    }
                                }
                            }
                        }
                        textelement(Purp)
                        {
                            textelement(PurposeCode)
                            {
                                XmlName = 'Cd';
                            }
                            trigger OnBeforePassVariable()
                            begin
                                if PurposeCode = '' then
                                    currXMLport.Skip();
                            end;
                        }
                        textelement(RmtInf)
                        {
                            MinOccurs = Zero;
                            textelement(remittancetext)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';
                            }

                            trigger OnBeforePassVariable()
                            begin
                                remittancetext := 'Integration Test Transaction';
                            end;
                        }
                    }
                }
            }
            trigger OnAfterGetRecord()
            begin
                InitData("Payment Journal Buffer");
            end;
        }
    }

    local procedure InitData(PaymentJournalBuffer: Record "Payment Journal Buffer")
    var
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        Clear(paymentexportdata);
        Clear(paymentexportdatagroup);

        NoOfTransfers := Format(PaymentJournalBuffer.Count);
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := Format(CurrentDateTime, 19, 9);
        ControlSum := Format(PaymentJournalBuffer.Amount, 0, '<Standard Format,9>');

        PaymentExportData.Init();
        PaymentExportData.Amount := PaymentJournalBuffer.Amount;
        if PaymentJournalBuffer."Currency Code" = '' then
            PaymentExportData."Currency Code" := GeneralLedgerSetup."LCY Code"
        else
            PaymentExportData."Currency Code" := PaymentJournalBuffer."Currency Code";
        PaymentExportData.Insert();
        Vendor.Get(PaymentJournalBuffer."Account No.");
        VendorBankAccount.Get(Vendor."No.", PaymentJournalBuffer."Beneficiary Bank Account");
        SetVendorAsRecipient(Vendor, VendorBankAccount, PaymentExportData);
        PaymentExportDataGroup."SEPA Payment Method Text" := 'TRF';
        PaymentExportDataGroup."SEPA Batch Booking" := PaymentExportData."SEPA Batch Booking";
        PaymentExportDataGroup."Transfer Date" := Today;
        BankAccount.Get(PaymentJournalBuffer."Bank Account");
        PaymentExportDataGroup."Sender Bank BIC" := BankAccount."SWIFT Code";
        paymentexportdatagroup."Sender Bank Account No." := BankAccount.IBAN;
        PaymentExportDataGroup.Insert();
    end;

    procedure SetVendorAsRecipient(var Vendor: Record Vendor; var VendorBankAccount: Record "Vendor Bank Account"; var PaymentExportData: Record "Payment Export Data")
    begin
        PaymentExportData."Recipient Name" := CopyStr(Vendor.Name, 1, 22);
        PaymentExportData."Recipient Address" := CopyStr(Vendor.Address, 1, 70);
        PaymentExportData."Recipient Post Code" := Vendor."Post Code";
        PaymentExportData."Recipient City" := Vendor.City;
        PaymentExportData."Recipient Country/Region Code" := Vendor."Country/Region Code";
        PaymentExportData."Transit No." := VendorBankAccount."Transit No.";
        PaymentExportData."Recipient Bank Acc. No." := VendorBankAccount."Bank Account No.";
    end;
}

