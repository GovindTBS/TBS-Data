//! Test (Static)
codeunit 50141 "Citi Intg Encryption Handler"
{
    procedure SignXmlPayload(var XmlPayload: Text)
    var
        RSACryptoProvider: Codeunit "RSACryptoServiceProvider";
        X509Certificates: Codeunit X509Certificate2;
        KeyStream: InStream;
        DataInStream: InStream;
        SignatureStream: OutStream;
        HashAlgorithm: Enum "Hash Algorithm";
        Signature: Text;
    begin
        CitiIntgKeys.Get(CitiIntgKeys."Certificate Name"::"Citi sign-in certificate");
        GetPrivateKey(CitiIntgKeys);

        RSACryptoProvider.InitializeRSA(2048);
        RSACryptoProvider.CreateRSAKeyPair(PublicKey, PrivateKey);

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

        AddPayloadSignature(XmlPayload, Signature);
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

    local procedure AddPayloadSignature(var XmlPayload: Text; Signature: Text)
    var
        XmlDoc: XmlDocument;
    begin
        XmlDocument.ReadFrom(XmlPayload, XmlDoc);
    end;

    local procedure GetPrivateKey(CitiIntgKey: Record "Citi Bank Intg. Keys")
    var
        InputStream: InStream;
        KeyValue: Text;
        StartPos: Integer;
        EndPos: Integer;
    begin
        CitiIntgKey.Value.CreateInStream(InputStream);
        InputStream.Read(KeyValue);

        StartPos := StrPos(KeyValue, '-----BEGIN PUBLIC KEY-----');
        EndPos := StrPos(KeyValue, '-----END PUBLIC KEY-----');

        if (StartPos > 0) and (EndPos > 0) then begin
            StartPos := StartPos + StrLen('-----BEGIN PUBLIC KEY-----');
            EndPos := EndPos - StartPos - 1;

            PublicKey := CopyStr(KeyValue, StartPos, EndPos);


        end else
            Error('Public key not found in the certificate.');

    end;

    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        CitiIntgKeys: Record "Citi Bank Intg. Keys";
        TempBlob: Codeunit "Temp Blob";
        TempBlob1: Codeunit "Temp Blob";
        PublicKey: Text;
        PrivateKey: SecretText;
        OutputStream: OutStream;
}

