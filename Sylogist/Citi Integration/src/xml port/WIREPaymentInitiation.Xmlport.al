xmlport 50141 "SEPA WIRE pain.001.001.03"
{
    Caption = 'SEPA WIRE pain.001.001.03';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    PreserveWhiteSpace = false;

    schema
    {
        tableelement(GenJnlBuffer; "General Journal Buffer")
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
                        var
                            CitiBankAPISetup: Record "Citi Bank API Setup";
                            NoSeries: Codeunit "No. Series";
                            NoSeriesCode: Code[20];
                        begin
                            CitiBankAPISetup.Get();
                            NoSeriesCode := CitiBankAPISetup."Message ID No's";
                            messageid := NoSeries.GetNextNo(NoSeriesCode);
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
                        var
                            CitiBankAPISetup: Record "Citi Bank API Setup";
                            NoSeries: Codeunit "No. Series";
                            NoSeriesCode: Code[20];
                        begin
                            CitiBankAPISetup.Get();
                            NoSeriesCode := CitiBankAPISetup."Message ID No's";
                            PmtInfId := NoSeries.GetNextNo(NoSeriesCode);
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
                                    Cd := 'URGP';
                                end;
                            }
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
                                var
                                    CitiBankAPISetup: Record "Citi Bank API Setup";
                                    NoSeries: Codeunit "No. Series";
                                    NoSeriesCode: Code[20];
                                begin
                                    CitiBankAPISetup.Get();
                                    NoSeriesCode := CitiBankAPISetup."Payment Instruction ID No's";
                                    InstrId := NoSeries.GetNextNo(NoSeriesCode);
                                end;
                            }
                            textelement(EndToEndID)
                            {
                                XmlName = 'EndToEndId';
                                trigger OnBeforePassVariable()
                                var
                                    CitiBankAPISetup: Record "Citi Bank API Setup";
                                    NoSeries: Codeunit "No. Series";
                                    NoSeriesCode: Code[20];
                                begin
                                    CitiBankAPISetup.Get();
                                    NoSeriesCode := CitiBankAPISetup."Payment Request ID No's";
                                    EndToEndID := NoSeries.GetNextNo(NoSeriesCode);
                                end;
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt; PaymentExportData.Amount)
                            {
                                textattribute(Ccy)
                                {
                                    trigger OnBeforePassVariable()
                                    begin
                                        Ccy := 'USD';
                                    end;
                                }
                            }
                            // textelement(EqvtAmt)
                            // {
                            //     fieldelement(Amt; PaymentExportData.Amount)
                            //     {
                            //         textattribute(Ccy)
                            //         {
                            //             trigger OnBeforePassVariable()
                            //             begin
                            //                 Ccy := 'USD';
                            //             end;
                            //         }
                            //     }
                            //     fieldelement(CcyOfTrf; PaymentExportData."Currency Code")
                            //     {

                            //     }
                            // }
                        }
                        // fieldelement(ChrgBr; PaymentExportData."SEPA Charge Bearer")
                        // {
                        //     trigger OnBeforePassField()
                        //     begin
                        //         if (PaymentExportData."Currency Code" = 'USD') and (PaymentExportData."Currency Code" = '') then
                        //             currXMLport.Skip();
                        //     end;
                        // }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                fieldelement(BIC; PaymentExportData."Recipient Bank BIC")
                                {
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
                                fieldelement(AdrLine; PaymentExportData."Recipient Address")
                                {

                                    trigger OnBeforePassField()
                                    begin
                                        if PaymentExportData."Recipient Address" = '' then
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
                InitData(GenJnlBuffer);
            end;
        }
    }

    local procedure InitData(GenJnlBuffer: Record "General Journal Buffer")
    var
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        CitiBankAPISetup: Record "Citi Bank API Setup";
        VendorBankAccount: Record "Vendor Bank Account";
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        GeneralLedgerSetup: Record "General Ledger Setup";
        PaymentGroupNo: Integer;
    begin
        GeneralLedgerSetup.Get();
        CitiBankAPISetup.Get();
        Clear(paymentexportdata);
        Clear(paymentexportdatagroup);

        NoOfTransfers := Format(GenJnlBuffer.Count);
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := Format(CurrentDateTime, 19, 9);
        ControlSum := Format(GenJnlBuffer.Amount);

        PaymentExportData.Init();
        PaymentExportData.Amount := GenJnlBuffer.Amount;
        if GenJnlBuffer."Beneficiary Currency Code" = '' then
            PaymentExportData."Currency Code" := GeneralLedgerSetup."LCY Code"
        else
            PaymentExportData."Currency Code" := GenJnlBuffer."Beneficiary Currency Code";
        PaymentExportData.Insert();
        Vendor.Get(GenJnlBuffer."Account No.");
        VendorBankAccount.Get(Vendor."No.", GenJnlBuffer."Recipient Bank Account");
        PurposeCode := VendorBankAccount."Purpose Code";
        SetVendorAsRecipient(Vendor, VendorBankAccount, PaymentExportData);
        PaymentExportDataGroup."SEPA Payment Method Text" := 'TRF';
        PaymentExportDataGroup."SEPA Batch Booking" := PaymentExportData."SEPA Batch Booking";
        PaymentExportDataGroup."Transfer Date" := Today;
        BankAccount.Get(GenJnlBuffer."Bal. Account No.");
        PaymentExportDataGroup."Sender Bank BIC" := BankAccount."SWIFT Code";
        paymentexportdatagroup."Sender Bank Account No." := BankAccount."Bank Account No.";
        PaymentExportDataGroup.Insert();
    end;

    procedure SetVendorAsRecipient(var Vendor: Record Vendor; var VendorBankAccount: Record "Vendor Bank Account"; var PaymentExportData: Record "Payment Export Data")
    begin
        PaymentExportData."Recipient Name" := CopyStr(Vendor.Name, 1, 35);
        PaymentExportData."SEPA Charge Bearer" := PaymentExportData."SEPA Charge Bearer"::SHAR;
        PaymentExportData."Recipient Address" := Vendor.Address;
        PaymentExportData."Recipient Bank BIC" := VendorBankAccount."SWIFT Code";
        PaymentExportData."Recipient Bank Acc. No." := VendorBankAccount."Bank Account No.";
    end;
}

