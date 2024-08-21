//! Test 
codeunit 50141 "Citi Integration"
{
    procedure InitiatePayment(PaymentJnlRec: Record "Gen. Journal Line")
    var
        XmlPayload: Text;
    begin
        CitiIntgSetup.Get();

        XmlPayload := CreateXmlDemo();

        SignXmlPayload(XmlPayload);

        EncryptPayload(XmlPayload);
    end;

    local procedure CreateXmlDemo(): Text
    var
        RootElement: XmlElement;
        DataItemsElement: XmlElement;
        DataItemElement: XmlElement;
        XmlDoc: XmlDocument;
        XmlDecl: XmlDeclaration;
    begin
        XmlDoc := XmlDocument.Create();
        XmlDecl := XmlDeclaration.Create('1.0', 'utf-8', 'yes');
        XmlDoc.SetDeclaration(XmlDecl);

        RootElement := XmlElement.Create('DemoXMLFile');
        RootElement.SetAttribute('attribute1', 'value1');
        RootElement.SetAttribute('attribute2', 'value2');

        DataItemsElement := XmlElement.Create('DataItems');
        DataItemElement := XmlElement.Create('DataItem');
        DataItemElement.Add(XmlText.Create('textvalue'));
        DataItemsElement.Add(DataItemElement);

        RootElement.Add(DataItemsElement);
        XmlDoc.Add(RootElement);

        XmlDoc.WriteTo(payload);
        exit(payload);
    end;

    procedure SignXmlPayload(XmlPayload: Text)
    var
        RSACryptoProvider: Codeunit "RSACryptoServiceProvider";
        DataInStream: InStream;
        SignatureStream: OutStream;
        HashAlgorithm: Enum "Hash Algorithm";
        Signature: Text;
    begin
        RSACryptoProvider.InitializeRSA(2048);
        RSACryptoProvider.CreateRSAKeyPair(PublicKey, PrivateKey);
        Message(PublicKey);

        TempBlob.CreateOutStream(SignatureStream);
        SignatureStream.Write(XmlPayload);
        TempBlob.CreateInStream(DataInStream);

        Clear(SignatureStream);
        TempBlob1.CreateOutStream(SignatureStream);

        DataInStream.ResetPosition();
        HashAlgorithm := HashAlgorithm::SHA256;
        RSACryptoProvider.SignData(PrivateKey, DataInStream, HashAlgorithm, SignatureStream);

        Clear(DataInStream);
        TempBlob1.CreateInStream(DataInStream);
        Signature := '';
        DataInStream.ReadText(Signature);

        Message('Signed XML Payload: %1', Signature);

        VerifyXmlSignature(XmlPayload, Signature);
    end;

    procedure VerifyXmlSignature(XmlPayload: Text; Signature: Text): Boolean
    var
        RSACryptoProvider: Codeunit "RSACryptoServiceProvider";
        DataInStream: InStream;
        SignatureInStream: InStream;
        HashAlgorithm: Enum "Hash Algorithm";
        IsValidSignature: Boolean;
    begin
        RSACryptoProvider.InitializeRSA(2048);

        TempBlob.CreateOutStream(OutputStream);
        OutputStream.Write(XmlPayload);
        TempBlob.CreateInStream(DataInStream);

        TempBlob1.CreateOutStream(OutputStream);
        OutputStream.Write(Signature);
        TempBlob1.CreateInStream(SignatureInStream);

        HashAlgorithm := HashAlgorithm::SHA256;

        Message('Data for verification: %1', XmlPayload);
        Message('Signature for verification: %1', Signature);

        IsValidSignature := RSACryptoProvider.VerifyData(PublicKey, DataInStream, HashAlgorithm, SignatureInStream);

        if IsValidSignature then
            Message('Signature verification succeeded.')
        else
            Message('Signature verification failed.');

        exit(IsValidSignature);
    end;

    procedure EncryptPayload(var XmlPayload: Text)
    var
        RSACryptoProvider: Codeunit "RSACryptoServiceProvider";
        PlainTextInStream: InStream;
        EncryptedTextStream: OutStream;
    begin
        RSACryptoProvider.InitializeRSA(2048);
        TempBlob.CreateOutStream(EncryptedTextStream);
        EncryptedTextStream.Write(XmlPayload);
        TempBlob.CreateInStream(PlainTextInStream);

        TempBlob1.CreateOutStream(EncryptedTextStream);
        RSACryptoProvider.Encrypt(PublicKey, PlainTextInStream, false, EncryptedTextStream);

        TempBlob1.CreateInStream(PlainTextInStream);
        XmlPayload := '';
        PlainTextInStream.ReadText(XmlPayload);

        Message('Encrypted XML Payload: %1', XmlPayload);

        DecryptPayload(XmlPayload);
    end;

    procedure DecryptPayload(XmlPayload: Text)
    var
        RSACryptoProvider: Codeunit "RSACryptoServiceProvider";
        EncryptedTextInStream: InStream;
        EncryptedTextOutStream: OutStream;
        DecryptedTextStream: OutStream;
        DecryptedTextInStream: InStream;
        DecryptedPayload: Text;
    begin
        RSACryptoProvider.InitializeRSA(2048);
        TempBlob.CreateOutStream(EncryptedTextOutStream);
        EncryptedTextOutStream.Write(XmlPayload);
        TempBlob.CreateInStream(EncryptedTextInStream);

        TempBlob1.CreateOutStream(DecryptedTextStream);
        RSACryptoProvider.Decrypt(PrivateKey, EncryptedTextInStream, false, DecryptedTextStream);

        TempBlob1.CreateInStream(DecryptedTextInStream);
        DecryptedPayload := '';
        DecryptedTextInStream.Read(DecryptedPayload);

        Message('Decrypted XML Payload: %1', DecryptedPayload);
    end;

    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        TempBlob: Codeunit "Temp Blob";
        TempBlob1: Codeunit "Temp Blob";
        payload: Text;
        PublicKey: Text;
        PrivateKey: SecretText;
        OutputStream: OutStream;
}
