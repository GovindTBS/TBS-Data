using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Azure.Identity;
using Azure.Security.KeyVault.Certificates;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Company.Function
{
    public class test
    {
        private readonly ILogger<test> _logger;

        public test(ILogger<test> logger)
        {
            _logger = logger;
        }

        private static readonly string keyVaultUrl = "https://your-keyvault-name.vault.azure.net/"; // Key Vault URL
        private static readonly string certificateName = "your-certificate-name"; // Certificate name in Key Vault

        public Cryptographer(ILogger<Cryptographer> logger)
        {
            _logger = logger;
        }

        [Function("test")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("Processing cryptographic operations request...");

            try
            {
                // Step 1: Retrieve certificate from Azure Key Vault
                X509Certificate2 certificate = await GetCertificateFromKeyVault();
                if (certificate == null)
                {
                    _logger.LogError("Certificate not found in Key Vault.");
                    return new BadRequestObjectResult("Failed to retrieve certificate.");
                }

                // Sample data to be encrypted, signed, etc.
                byte[] dataToSign = Encoding.UTF8.GetBytes("Sample data for signing");
                byte[] dataToEncrypt = Encoding.UTF8.GetBytes("Sample data for encryption");

                // Step 2: Perform cryptographic operations using the certificate
                // 1. Signing Data
                byte[] signature = SignData(certificate, dataToSign);
                string signatureBase64 = Convert.ToBase64String(signature);
                _logger.LogInformation($"Signature: {signatureBase64}");

                // 2. Encrypting Data
                byte[] encryptedData = EncryptData(certificate, dataToEncrypt);
                string encryptedDataBase64 = Convert.ToBase64String(encryptedData);
                _logger.LogInformation($"Encrypted Data: {encryptedDataBase64}");

                // 3. Decrypting Data
                byte[] decryptedData = DecryptData(certificate, encryptedData);
                string decryptedString = Encoding.UTF8.GetString(decryptedData);
                _logger.LogInformation($"Decrypted Data: {decryptedString}");

                // 4. Verifying Signature
                bool isSignatureValid = VerifySignature(certificate, dataToSign, signature);
                _logger.LogInformation(isSignatureValid ? "Signature is valid." : "Signature is invalid.");

                return new OkObjectResult(new
                {
                    Signature = signatureBase64,
                    EncryptedData = encryptedDataBase64,
                    DecryptedData = decryptedString,
                    IsSignatureValid = isSignatureValid
                });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error: {ex.Message}");
                return new StatusCodeResult(500);
            }
        }

        // Step 3: Method to retrieve the certificate from Key Vault
        private static async Task<X509Certificate2> GetCertificateFromKeyVault()
        {
            var client = new CertificateClient(new Uri(keyVaultUrl), new DefaultAzureCredential());
            var certificateResponse = await client.GetCertificateAsync(certificateName);

            return new X509Certificate2(certificateResponse.Value.Cer);
        }

        // Step 4: Method to sign data using the private key
        private static byte[] SignData(X509Certificate2 certificate, byte[] dataToSign)
        {
            using (RSA rsa = certificate.GetRSAPrivateKey())
            {
                return rsa.SignData(dataToSign, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            }
        }

        // Step 5: Method to verify signature using the public key
        private static bool VerifySignature(X509Certificate2 certificate, byte[] dataToVerify, byte[] signature)
        {
            using (RSA rsa = certificate.GetRSAPublicKey())
            {
                return rsa.VerifyData(dataToVerify, signature, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            }
        }

        // Step 6: Method to encrypt data using the public key
        private static byte[] EncryptData(X509Certificate2 certificate, byte[] dataToEncrypt)
        {
            using (RSA rsa = certificate.GetRSAPublicKey())
            {
                return rsa.Encrypt(dataToEncrypt, RSAEncryptionPadding.OaepSHA256);
            }
        }

        // Step 7: Method to decrypt data using the private key
        private static byte[] DecryptData(X509Certificate2 certificate, byte[] encryptedData)
        {
            using (RSA rsa = certificate.GetRSAPrivateKey())
            {
                return rsa.Decrypt(encryptedData, RSAEncryptionPadding.OaepSHA256);
            }
        }
    }
}
