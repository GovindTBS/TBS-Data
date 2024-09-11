using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

public class RsaSign
{
    public static void Main()
    {
        // Path to your PEM file
        string pemFilePath = "Key.pem";

        // Read PEM file content
        string pemPrivateKey = File.ReadAllText(pemFilePath);

        // The plaintext payload
        string plaintextPayload = "Your plaintext payload";

        // Sign the payload
        byte[] signedPayload = SignPayload(plaintextPayload, pemPrivateKey);

        // Output results
        Console.WriteLine("Signed Payload (Base64): " + Convert.ToBase64String(signedPayload));
    }

    public static byte[] SignPayload(string payload, string pemPrivateKey)
    {
        // Convert PEM key to RSA private key
        RSA rsa = RSA.Create();
        rsa.ImportFromPem(pemPrivateKey.ToCharArray());

        // Sign the payload
        byte[] payloadBytes = Encoding.UTF8.GetBytes(payload);
        byte[] signedPayload = rsa.SignData(payloadBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

        return signedPayload;
    }
}
