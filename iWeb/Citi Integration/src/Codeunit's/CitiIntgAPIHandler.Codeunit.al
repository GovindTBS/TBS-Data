codeunit 50142 "Citi Intg API Handler"
{
    procedure GetAuthToken()
    begin

    end;

    procedure InitiatePayment(var GenJnlLine: Record "Gen. Journal Line")
    var
        TempBlob: Codeunit "Temp Blob";
        CitiIntgEncyptionHandler: Codeunit "Citi Intg Encryption Handler";
        PaymentInitRequestPort: XmlPort "Citi Payment Init Request";
        XmlPayload: Text;
        OutputStream: OutStream;
        InputStream: InStream;
    begin
        //run port
        TempBlob.CreateOutStream(OutputStream);
        PaymentInitRequestPort.SetDestination(OutputStream);
        PaymentInitRequestPort.Export();
        TempBlob.CreateInStream(Inputstream);
        InputStream.Read(XmlPayload);

        //sign payload
        CitiIntgEncyptionHandler.SignXmlPayload(XmlPayload);

        //encrypt payload
        CitiIntgEncyptionHandler.EncryptPayload(XmlPayload);
    end;

    procedure PostPaymentStatus()
    begin

    end;

    procedure StatementInitiation()
    begin

    end;

    procedure StatementRetrival()
    begin

    end;
}