xmlport 50141 "SEPA CITI pain.001.001.03"
{
    Caption = 'SEPA CITI pain.001.001.03';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    PreserveWhiteSpace = false;

    schema
    {
        tableelement(GenJnlLine; "Gen. Journal Line")
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
                        textelement(initgptyid)
                        {
                            XmlName = 'Id';
                            textelement(initgptyorgid)
                            {
                                XmlName = 'OrgId';
                                textelement(initgptyothrinitgpty)
                                {
                                    XmlName = 'Othr';
                                    fieldelement(Id; CompanyInformation."Registration No.")
                                    {
                                    }
                                }
                            }
                        }
                    }
                }

                tableelement(paymentexportdatagroup; "Payment Export Data")
                {
                    XmlName = 'PmtInf';
                    UseTemporary = true;
                    fieldelement(PmtInfId; PaymentExportDataGroup."Payment Information ID")
                    {
                    }
                    fieldelement(PmtMtd; PaymentExportDataGroup."SEPA Payment Method Text")
                    {
                    }
                    fieldelement(BtchBookg; PaymentExportDataGroup."SEPA Batch Booking")
                    {
                    }
                    fieldelement(NbOfTxs; PaymentExportDataGroup."Line No.")
                    {
                    }
                    fieldelement(CtrlSum; PaymentExportDataGroup.Amount)
                    {
                    }
                    textelement(PmtTpInf)
                    {
                        fieldelement(InstrPrty; PaymentExportDataGroup."SEPA Instruction Priority Text")
                        {
                        }
                    }
                    fieldelement(ReqdExctnDt; PaymentExportDataGroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
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
                        textelement(dbtrid)
                        {
                            XmlName = 'Id';
                            textelement(dbtrorgid)
                            {
                                XmlName = 'OrgId';
                                fieldelement(BICOrBEI; PaymentExportDataGroup."Sender Bank BIC")
                                {
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportDataGroup."Sender Bank BIC" = '' then
                                    currXMLport.Skip();
                            end;
                        }
                    }
                    textelement(DbtrAcct)
                    {
                        textelement(dbtracctid)
                        {
                            XmlName = 'Id';
                            fieldelement(IBAN; PaymentExportDataGroup."Sender Bank Account No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
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
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }

                        trigger OnBeforePassVariable()
                        begin
                            if PaymentExportDataGroup."Sender Bank BIC" = '' then
                                currXMLport.Skip();
                        end;
                    }
                    fieldelement(ChrgBr; PaymentExportDataGroup."SEPA Charge Bearer Text")
                    {
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = field("Sender Bank BIC"), "SEPA Instruction Priority Text" = field("SEPA Instruction Priority Text"), "Transfer Date" = field("Transfer Date"), "SEPA Batch Booking" = field("SEPA Batch Booking"), "SEPA Charge Bearer Text" = field("SEPA Charge Bearer Text");
                        LinkTable = PaymentExportDataGroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(EndToEndId; PaymentExportData."End-to-End ID")
                            {
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
                                fieldelement(BIC; PaymentExportData."Recipient Bank BIC")
                                {
                                    FieldValidate = yes;
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportData."Recipient Bank BIC" = '' then
                                    currXMLport.Skip();
                            end;
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

                                trigger OnBeforePassVariable()
                                begin
                                    if (PaymentExportData."Recipient Address" = '') and
                                       (PaymentExportData."Recipient Post Code" = '') and
                                       (PaymentExportData."Recipient City" = '') and
                                       (PaymentExportData."Recipient Country/Region Code" = '')
                                    then
                                        currXMLport.Skip();
                                end;
                            }
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                fieldelement(IBAN; PaymentExportData."Recipient Bank Acc. No.")
                                {
                                    FieldValidate = yes;
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                }
                            }
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
                                remittancetext := 'Test transaction';
                            end;
                        }
                    }
                }
            }
            trigger OnAfterGetRecord()
            begin
                InitData(GenJnlLine);
            end;
        }
    }

    trigger OnPreXmlPort()
    var
        SEPACTExportFile: Codeunit "SEPA CT-Export File";
    begin
        // InitData();
    end;

    local procedure InitData(GenJnlLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        GeneralLedgerSetup: Record "General Ledger Setup";
        PaymentGroupNo: Integer;
    begin
        GeneralLedgerSetup.Get();
        PaymentExportDataGroup."Line No." := GenJnlLine."Line No.";
        PaymentExportDataGroup.Amount := GenJnlLine.Amount;

        NoOfTransfers := '1';
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := Format(CurrentDateTime, 19, 9);
        PaymentExportData.CalcSums(Amount);
        ControlSum := Format(GenJnlLine.Amount);

        PaymentExportData.Init();
        paymentexportdata."End-to-End ID" := '100000000000000';
        PaymentExportData."Entry No." += 1;
        PaymentExportData."Transfer Date" := GenJnlLine."Posting Date";
        PaymentExportData."Document No." := GenJnlLine."Document No.";
        PaymentExportData."Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
        PaymentExportData.Amount := GenJnlLine.Amount;
        if GenJnlLine."Currency Code" = '' then
            PaymentExportData."Currency Code" := GeneralLedgerSetup."LCY Code"
        else
            PaymentExportData."Currency Code" := GenJnlLine."Currency Code";
        Vendor.Get(GenJnlLine."Account No.");
        VendorBankAccount.Get(Vendor."No.", GenJnlLine."Recipient Bank Account");
        SetVendorAsRecipient(Vendor, VendorBankAccount, PaymentExportData);
        PaymentExportData.Validate(PaymentExportData."SEPA Instruction Priority", PaymentExportData."SEPA Instruction Priority"::NORMAL);
        PaymentExportData.Validate(PaymentExportData."SEPA Payment Method", PaymentExportData."SEPA Payment Method"::TRF);
        PaymentExportData.Validate(PaymentExportData."SEPA Charge Bearer", PaymentExportData."SEPA Charge Bearer"::SLEV);
        PaymentExportData.SetCreditTransferIDs(MessageID);
        PaymentExportData.AddRemittanceText(GenJnlLine.Description);
        PaymentExportData.Insert(true);

        PaymentExportDataGroup."Payment Information ID" := CopyStr(StrSubstNo('%1/%2', PaymentExportData."Message ID", PaymentGroupNo), 1, MaxStrLen(PaymentExportDataGroup."Payment Information ID"));
        PaymentExportDataGroup."SEPA Payment Method Text" := 'TRF';
        PaymentExportDataGroup."SEPA Batch Booking" := PaymentExportData."SEPA Batch Booking";
        PaymentExportDataGroup."SEPA Instruction Priority Text" := '';
        PaymentExportDataGroup."Transfer Date" := Today;
        BankAccount.Get('2943');
        PaymentExportDataGroup."Sender Bank BIC" := BankAccount."Bank Branch No.";
        paymentexportdatagroup."Sender Bank Account No." := BankAccount."Bank Account No.";
        PaymentExportDataGroup.Insert();
    end;

    procedure SetVendorAsRecipient(var Vendor: Record Vendor; var VendorBankAccount: Record "Vendor Bank Account"; var PaymentExportData: Record "Payment Export Data")
    begin
        PaymentExportData."Recipient Name" := Vendor.Name;
        PaymentExportData."Recipient Address" := CopyStr(Vendor.Address, 1, 70);
        PaymentExportData."Recipient City" := CopyStr(Vendor.City, 1, 35);
        PaymentExportData."Recipient County" := Vendor.County;
        PaymentExportData."Recipient Post Code" := Vendor."Post Code";
        PaymentExportData."Recipient Country/Region Code" := Vendor."Country/Region Code";
        PaymentExportData."Recipient Email Address" := Vendor."E-Mail";
        PaymentExportData."Recipient Bank Name" := VendorBankAccount.Name;
        PaymentExportData."Recipient Bank Address" := CopyStr(VendorBankAccount.Address, 1, 70);
        PaymentExportData."Recipient Bank City" := CopyStr(VendorBankAccount.City, 1, 35);
        PaymentExportData."Recipient Bank County" := VendorBankAccount.County;
        PaymentExportData."Recipient Bank Post Code" := VendorBankAccount."Post Code";
        PaymentExportData."Recipient Bank Country/Region" := VendorBankAccount."Country/Region Code";
        PaymentExportData."Recipient Bank BIC" := VendorBankAccount."SWIFT Code";
        PaymentExportData."Recipient Bank Acc. No." := CopyStr(VendorBankAccount.GetBankAccountNo(), 1, MaxStrLen(PaymentExportData."Recipient Bank Acc. No."));
        PaymentExportData."Recipient Bank Clearing Std." := VendorBankAccount."Bank Clearing Standard";
        PaymentExportData."Recipient Bank Clearing Code" := VendorBankAccount."Bank Clearing Code";
    end;
}

