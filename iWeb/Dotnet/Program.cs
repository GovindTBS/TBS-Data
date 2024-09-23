using System;
using System.IO;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Xml;

public class XmlSignerAndEncryptor
{
    private readonly string _privateKeyPath;
    private readonly string _publicCertPath;
    private readonly string _recipientId;

    public XmlSignerAndEncryptor(string privateKeyPath, string publicCertPath, string recipientId)
    {
        _privateKeyPath = privateKeyPath;
        _publicCertPath = publicCertPath;
        _recipientId = recipientId;
    }

    public string SignAndEncryptXml(string inputXml)
    {
        var privateKey = new X509Certificate2(_privateKeyPath);
        using var rsaPrivate = privateKey.GetRSAPrivateKey() ?? throw new InvalidOperationException("Private key cannot be null.");

        var signedXml = SignXml(inputXml, rsaPrivate);
        var encryptedXml = EncryptXml(signedXml);

        return encryptedXml;
    }

    private string SignXml(string xml, RSA privateKey)
    {
        var xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(xml);

        var signedXml = new System.Security.Cryptography.Xml.SignedXml(xmlDoc)
        {
            SigningKey = privateKey
        };

        var reference = new System.Security.Cryptography.Xml.Reference
        {
            Uri = ""
        };
        signedXml.AddReference(reference);

        var keyInfo = new System.Security.Cryptography.Xml.KeyInfo();
        keyInfo.AddClause(new System.Security.Cryptography.Xml.KeyInfoX509Data(privateKey));
        signedXml.KeyInfo = keyInfo;

        signedXml.ComputeSignature();

        var xmlSignature = signedXml.GetXml();
        xmlDoc.DocumentElement.AppendChild(xmlDoc.ImportNode(xmlSignature, true));

        return xmlDoc.OuterXml;
    }

    private string EncryptXml(string xml)
    {
        var publicCert = new X509Certificate2(_publicCertPath);
        using var rsaPublic = publicCert.GetRSAPublicKey() ?? throw new InvalidOperationException("Public key cannot be null.");

        var encryptedXmlDoc = new XmlDocument();
        var encryptedDataElement = new System.Security.Cryptography.Xml.EncryptedData();

        using (var aes = Aes.Create())
        {
            aes.KeySize = 256;
            aes.GenerateKey();
            aes.GenerateIV();

            var encryptedContent = EncryptWithAes(xml, aes);
            var encryptedKeyElement = CreateEncryptedKey(aes.Key, rsaPublic);

            encryptedDataElement.CipherData = new System.Security.Cryptography.Xml.CipherData
            {
                CipherValue = Convert.ToBase64String(encryptedContent)
            };

            encryptedDataElement.KeyInfo.AddClause(new System.Security.Cryptography.Xml.KeyInfoEncryptedKey(encryptedKeyElement));
            encryptedXmlDoc.AppendChild(encryptedXmlDoc.ImportNode(encryptedDataElement.GetXml(), true));
        }

        return encryptedXmlDoc.OuterXml;
    }

    private byte[] EncryptWithAes(string data, Aes aes)
    {
        using (var encryptor = aes.CreateEncryptor())
        using (var ms = new MemoryStream())
        using (var cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write))
        {
            var dataBytes = Encoding.UTF8.GetBytes(data);
            cs.Write(dataBytes, 0, dataBytes.Length);
            cs.FlushFinalBlock();
            return ms.ToArray();
        }
    }

    private System.Security.Cryptography.Xml.EncryptedKey CreateEncryptedKey(byte[] key, RSA rsaPublic)
    {
        var encryptedKey = new System.Security.Cryptography.Xml.EncryptedKey();
        var encryptedKeyBytes = rsaPublic.Encrypt(key, RSAEncryptionPadding.Pkcs1);
        
        encryptedKey.CipherData = new System.Security.Cryptography.Xml.CipherData
        {
            CipherValue = Convert.ToBase64String(encryptedKeyBytes)
        };

        return encryptedKey;
    }
}

public class Program
{
    public static void Main(string[] args)
    {
        var signerEncryptor = new XmlSignerAndEncryptor("sylogist2.key", "sylogist2_ned_org.pem", "02e9e8730fc4e71d74c62cab42202ed358aeb59c");
        var resultXml = signerEncryptor.SignAndEncryptXml(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?><oAuthToken xmlns=\"http://com.citi.citiconnect/services/types/oauthtoken/v2\"><grantType>client_credentials</grantType><scope>/authenticationservices/v1</scope><sourceApplication>CCF</sourceApplication></oAuthToken>"
        );

        Console.WriteLine(resultXml);
    }
}
