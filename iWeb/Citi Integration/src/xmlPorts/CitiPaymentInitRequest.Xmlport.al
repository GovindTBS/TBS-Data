xmlport 50140 "Citi Payment Init Request"
{
    Caption = 'CITI Payment Initiation XML pain.002.001.03';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.002.001.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;
    XmlVersionNo = V10;

    schema
    {
        tableelement(GenJnlLine; "Gen. Journal Line")
        {
            XmlName = 'Document';
            UseTemporary = true;
            textelement(CstmrPmtStsRpt)
            {
                textelement(GrpHdr)
                {
                    textelement(MsgIdValue)
                    {
                        XmlName = 'MsgId';
                    }
                    textelement(CreDtTmValue)
                    {
                        XmlName = 'CreDtTm';
                    }
                    textelement(InitgPty)
                    {
                        textelement(InitgPtyId)
                        {
                            XmlName = 'Id';
                            textelement(OrgId)
                            {
                                textelement(BICOrBEIValue)
                                {
                                    XmlName = 'BICOrBEI';
                                }
                            }
                        }
                    }
                }

                textelement(OrgnlGrpInfAndSts)
                {
                    textelement(OrgnlMsgIdValue)
                    {
                        XmlName = 'OrgnlMsgId';
                    }

                    textelement(OrgnlMsgNmIdValue)
                    {
                        XmlName = 'OrgnlMsgNmId';
                    }
                }

                textelement(OrgnlPmtInfAndSts)
                {
                    textelement(OrgnlPmtInfIdValue)
                    {
                        XmlName = 'OrgnlPmtInfId';
                    }
                    textelement(TxInfAndSts)
                    {
                        textelement(OrgnlEndToEndIdValue)  //CC21TPH3B8J8H2R
                        {
                            XmlName = 'OrgnlEndToEndId';
                        }
                        textelement(TxStsValue)   //ACSP
                        {
                            XmlName = 'TxSts';
                        }
                        textelement(StsRsnInf)
                        {
                            textelement(AddtlInfValue)   //Processed Settled at clearing System. Payment settled at clearing system
                            {
                                XmlName = 'AddtlInf';
                            }
                        }

                        textelement(OrgnlTxRef)
                        {
                            textelement(Amt)
                            {
                                fieldelement(InstdAmt; GenJnlLine.Amount)   //1.00
                                {
                                    XmlName = 'InstdAmt';
                                    textattribute(CcyValue)
                                    {
                                        XmlName = 'Ccy';
                                    }
                                }
                            }
                            textelement(ReqdExctnDtValue)//2021-02-03
                            {
                                XmlName = 'ReqdExctnDt';
                            }
                            textelement(PmtMtdValue) //TRF
                            {
                                XmlName = 'PmtMtd';
                            }

                            textelement(RmtInf)
                            {
                                textelement(UstrdValue)   //TR002638
                                {
                                    XmlName = 'Ustrd';
                                }
                            }

                            textelement(Dbtr)
                            {
                                textelement(NmValue)   //CITIBANK E-BUSINESS EUR DUM DEMO
                                {
                                    XmlName = 'Nm';
                                }
                            }
                            textelement(DbtrAcct)
                            {
                                textelement(DbtrAcctId)
                                {
                                    XmlName = 'Id';

                                    textelement(DbtrAcctOthr)
                                    {
                                        XmlName = 'Othr';
                                        textelement(IdValue)   //12345678
                                        {
                                            XmlName = 'Id';
                                        }
                                    }

                                }
                            }

                            textelement(DbtrAgt)
                            {
                                textelement(DbtrAgtFinInstnId)
                                {
                                    XmlName = 'FinInstnId';
                                    textelement(PstlAdr)
                                    {
                                        textelement(CtryValue)   //12345678
                                        {
                                            XmlName = 'Ctry';
                                        }
                                    }
                                }
                            }

                            textelement(CdtrAgt)
                            {
                                textelement(CdtrAgtFinInstnId)
                                {
                                    XmlName = 'FinInstnId';
                                    textelement(BICValue)   //fakebic
                                    {
                                        XmlName = 'BIC';
                                    }
                                }
                            }

                            textelement(Cdtr)
                            {
                                textelement(CdtrNmValue)   //fakebic
                                {
                                    XmlName = 'Nm';
                                }
                            }

                            textelement(CdtrAcct)
                            {
                                textelement(Id)
                                {
                                    textelement(Othr)
                                    {
                                        textelement(CdtrAcctIdValue)   //12345678
                                        {
                                            XmlName = 'Id';
                                        }
                                    }

                                }
                            }
                        }

                    }
                }
            }
        }
    }

    trigger OnInitXmlPort()
    begin
        //GrpHdr
        MsgIdValue := 'CITIBANK/20210311-PSR/981382059';
        CreDtTmValue := Format(Today);
        BICOrBEIValue := 'CITIUS33';

        //OrgnlGrpInfAndSts
        OrgnlMsgIdValue := 'GBP161114694869';
        OrgnlMsgNmIdValue := 'pain.001.001.03';

        //OrgnlPmtInfAndSts
        OrgnlPmtInfIdValue := '14017498 Fund Transfer Domestic';
        OrgnlEndToEndIdValue := 'CC21TPH3B8J8H2R';
        TxStsValue := 'ACSP';
        AddtlInfValue := 'Processed Settled at clearing System. Payment settled at clearing system';
        ReqdExctnDtValue := '2021-02-03';
        PmtMtdValue := 'TRF';
        UstrdValue := 'TR002638';
        NmValue := 'CITIBANK E-BUSINESS EUR DUM DEMO';
        IdValue := '12345678';
        CcyValue := 'USD';
        CtryValue := 'GB';
        BICValue := 'fakebic';
        CdtrNmValue := 'creditorname';
        CdtrAcctIdValue := '12345678';
    end;
}
