using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

public class ApiRequestExample
{
    private static readonly string apiEndpoint = "https://tts.sandbox.apib2b.citi.com/citiconnect/sb/authenticationservices/v3/oauth/token";
    private static readonly string clientId = "18c09f8e-5b20-4d41-9b62-1dc059362b75";
    private static readonly string clientSecret = "jN5yJ1jV3rF4aQ4kS1dL4wM3aI6rJ1dU7iW2hJ0nV7cR1qR0pL";
    private static readonly string privateKeyPath = "MyKeys/decrypted_private_key.pem";

    public static async Task Main()
    {
        try
        {
            string privateKeyPem = File.ReadAllText(privateKeyPath);
            byte[] dataToSign = Encoding.UTF8.GetBytes("This is my data.");

            string signatureBase64 = SignData(privateKeyPem, dataToSign);
            Console.WriteLine($"Signature: {signatureBase64} \n");

            byte[] encryptedData = EncryptData(privateKeyPem, dataToSign);
            string encryptedDataBase64 = Convert.ToBase64String(encryptedData);
            Console.WriteLine($"Encrypted Data: {encryptedDataBase64} \n");

            byte[] decryptedData = DecryptData(privateKeyPem, encryptedData);
            string decryptedString = Encoding.UTF8.GetString(decryptedData);
            Console.WriteLine($"Decrypted Data: {decryptedString} \n");

            bool isSignatureValid = VerifySignature(privateKeyPem, dataToSign, Convert.FromBase64String(signatureBase64));
            Console.WriteLine(isSignatureValid ? "Signature is valid." : "Signature is invalid.  \n");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }

    // sign data
    private static string SignData(string privateKeyPem, byte[] dataToSign)
    {
        using (RSA rsa = RSA.Create())
        {
            rsa.ImportFromPem(privateKeyPem.ToCharArray());
            byte[] signature = rsa.SignData(dataToSign, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            return Convert.ToBase64String(signature);
        }
    }

    // encrypt data
    private static byte[] EncryptData(string publicKeyPem, byte[] dataToEncrypt)
    {
        using (RSA rsa = RSA.Create())
        {
            rsa.ImportFromPem(publicKeyPem.ToCharArray());

            using (AesGcm aesGcm = new AesGcm(new byte[32])) 
            {
                byte[] nonce = new byte[12]; 
                byte[] encryptedData = new byte[dataToEncrypt.Length];
                byte[] tag = new byte[16]; 

                aesGcm.Encrypt(nonce, dataToEncrypt, encryptedData, tag);

                return Combine(nonce, encryptedData, tag);
            }
        }
    }

    // decrypt data
    private static byte[] DecryptData(string privateKeyPem, byte[] encryptedData)
    {
        using (RSA rsa = RSA.Create())
        {
            rsa.ImportFromPem(privateKeyPem.ToCharArray());

            byte[] nonce = new byte[12];
            byte[] tag = new byte[16];
            byte[] ciphertext = new byte[encryptedData.Length - nonce.Length - tag.Length];

            Buffer.BlockCopy(encryptedData, 0, nonce, 0, nonce.Length);
            Buffer.BlockCopy(encryptedData, nonce.Length, ciphertext, 0, ciphertext.Length);
            Buffer.BlockCopy(encryptedData, nonce.Length + ciphertext.Length, tag, 0, tag.Length);

            using (AesGcm aesGcm = new AesGcm(new byte[32]))
            {
                byte[] decryptedData = new byte[ciphertext.Length];
                aesGcm.Decrypt(nonce, ciphertext, tag, decryptedData);
                return decryptedData;
            }
        }
    }

    // verify signature
    private static bool VerifySignature(string privateKeyPem, byte[] dataToVerify, byte[] signature)
    {
        using (RSA rsa = RSA.Create())
        {
            rsa.ImportFromPem(privateKeyPem.ToCharArray());
            return rsa.VerifyData(dataToVerify, signature, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
        }
    }

     private static byte[] Combine(byte[] nonce, byte[] ciphertext, byte[] tag)
    {
        byte[] result = new byte[nonce.Length + ciphertext.Length + tag.Length];
        Buffer.BlockCopy(nonce, 0, result, 0, nonce.Length);
        Buffer.BlockCopy(ciphertext, 0, result, nonce.Length, ciphertext.Length);
        Buffer.BlockCopy(tag, 0, result, nonce.Length + ciphertext.Length, tag.Length);
        return result;
    }
}


// //! API CALL
// using (HttpClient client = new HttpClient())
// {
//     client.DefaultRequestHeaders.Add("Authorization", $"Basic {Convert.ToBase64String(Encoding.UTF8.GetBytes($"{clientId}:{clientSecret}"))}");
//     client.DefaultRequestHeaders.Add("X-Signature", signatureBase64); // Custom header for signature

//     HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, apiEndpoint)
//     {
//         Content = new StringContent("{\"data\":\"Sample Data\"}", Encoding.UTF8, "application/json")
//     };

//     HttpResponseMessage response = await client.SendAsync(request);
//     string responseContent = await response.Content.ReadAsStringAsync();
//     Console.WriteLine($"Response: {responseContent}");
//     Console.WriteLine("Done");
// }


// //! RSA KEYS
// using (RSA rsa = RSA.Create(2048)) 
// {
//     byte[] privateKey = rsa.ExportRSAPrivateKey();
//     byte[] publicKey = rsa.ExportRSAPublicKey();

//     string privateKeyPem = Convert.ToBase64String(privateKey);
//     string publicKeyPem = Convert.ToBase64String(publicKey);

//     Console.WriteLine("Private Key (PEM Format):");
//     Console.WriteLine(privateKeyPem);
//     Console.WriteLine();
//     Console.WriteLine("Public Key (PEM Format):");
//     Console.WriteLine(publicKeyPem);
//     Console.WriteLine();

//     byte[] dataToSign = Encoding.UTF8.GetBytes("Sample Data");

//     byte[] signature = rsa.SignData(dataToSign, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

//     string signatureBase64 = Convert.ToBase64String(signature);

//     Console.WriteLine("Signature (Base64 Format):");
//     Console.WriteLine(signatureBase64);
//     Console.WriteLine();

//     using (RSA rsaPublic = RSA.Create())
//     {
//         rsaPublic.ImportRSAPublicKey(publicKey, out _);

//         bool isSignatureValid = rsaPublic.VerifyData(dataToSign, signature, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

//         Console.WriteLine("Signature Verification Result:");
//         Console.WriteLine(isSignatureValid ? "Signature is valid." : "Signature is invalid.");
//     }
// }


//! PRIVATE KEY FROM PFX
// using System.Security.Cryptography.X509Certificates;
// using System.Security.Cryptography;

// X509Certificate2 certificate = new X509Certificate2("path_to_cert.pfx", "password");

// using (RSA rsa = certificate.GetRSAPrivateKey())
// {
//     byte[] signature = rsa.SignData(dataToSign, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
//     string signatureBase64 = Convert.ToBase64String(signature);
//     Console.WriteLine("Signature: " + signatureBase64);
// }


//! SSL TLS Handshake

// var handler = new HttpClientHandler();

// var certificate = new X509Certificate2("path_to_your_certificate.pfx", "certificate_password");
// handler.ClientCertificates.Add(certificate);

// handler.SslProtocols = SslProtocols.Tls12; // Adjust as needed

// var client = new HttpClient(handler);
// var response = await client.GetAsync("https://yourapiendpoint.com");
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;

var host = new HostBuilder()
    .ConfigureFunctionsWebApplication()
    .ConfigureServices(services => {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();
    })
    .Build();

host.Run();