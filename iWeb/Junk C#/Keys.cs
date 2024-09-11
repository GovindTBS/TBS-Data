// using System;
// using System.IO;
// using System.Security.Cryptography;
// using System.Text;
// using Org.BouncyCastle.Crypto;
// using Org.BouncyCastle.Crypto.Parameters;
// using Org.BouncyCastle.OpenSsl;
// using Org.BouncyCastle.X509;

// class Program
// {
//     public static void Main(string[] args)
//     {
//         // Paths to PEM files and message
//         string privateKeyPemPath = "Key.pem";  // Update with your actual path
//         string publicKeyPemPath = "Test.pem";  // Update with your actual path
//         string message = "This is a message to be signed and encrypted";

//         try
//         {
//             // Load and convert private key from PEM file
//             AsymmetricKeyParameter privateKey;
//             using (var reader = File.OpenText(privateKeyPemPath))
//             {
//                 PemReader pemReader = new PemReader(reader);
//                 privateKey = pemReader.ReadObject() as AsymmetricKeyParameter;
//             }

//             var rsaPrivateParams = new RSAParameters
//             {
//                 Modulus = ((RsaPrivateCrtKeyParameters)privateKey).Modulus.ToByteArrayUnsigned(),
//                 Exponent = ((RsaPrivateCrtKeyParameters)privateKey).PublicExponent.ToByteArrayUnsigned(),
//                 D = ((RsaPrivateCrtKeyParameters)privateKey).Exponent.ToByteArrayUnsigned(),
//                 P = ((RsaPrivateCrtKeyParameters)privateKey).P.ToByteArrayUnsigned(),
//                 Q = ((RsaPrivateCrtKeyParameters)privateKey).Q.ToByteArrayUnsigned(),
//                 DP = ((RsaPrivateCrtKeyParameters)privateKey).DP.ToByteArrayUnsigned(),
//                 DQ = ((RsaPrivateCrtKeyParameters)privateKey).DQ.ToByteArrayUnsigned(),
//                 InverseQ = ((RsaPrivateCrtKeyParameters)privateKey).QInv.ToByteArrayUnsigned()
//             };

//             using (RSA rsa = RSA.Create())
//             {
//                 rsa.ImportParameters(rsaPrivateParams);

//                 // Sign the message
//                 byte[] messageBytes = Encoding.UTF8.GetBytes(message);
//                 byte[] signature = rsa.SignData(messageBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
//                 string base64Signature = Convert.ToBase64String(signature);

//                 // Concatenate the plaintext and the signature
//                 string signedMessage = $"{message}\nSignature:{base64Signature}";
//                 Console.WriteLine("Signed Message:\n" + signedMessage);

//                 // Load and convert public key from PEM file
//                 AsymmetricKeyParameter publicKey;
//                 using (var reader = File.OpenText(publicKeyPemPath))
//                 {
//                     PemReader pemReader = new PemReader(reader);
//                     var pemObject = pemReader.ReadObject();
//                     if (pemObject is RsaKeyParameters rsaKey)
//                     {
//                         publicKey = rsaKey;
//                     }
//                     else if (pemObject is X509Certificate cert)
//                     {
//                         publicKey = cert.GetPublicKey();
//                     }
//                     else
//                     {
//                         throw new InvalidOperationException("Unsupported PEM format.");
//                     }
//                 }

//                 var rsaPublicParams = new RSAParameters
//                 {
//                     Modulus = ((RsaKeyParameters)publicKey).Modulus.ToByteArrayUnsigned(),
//                     Exponent = ((RsaKeyParameters)publicKey).Exponent.ToByteArrayUnsigned()
//                 };

//                 using (RSA rsaPublic = RSA.Create())
//                 {
//                     rsaPublic.ImportParameters(rsaPublicParams);

//                     // Encrypt the signed message with the public key
//                     byte[] signedMessageBytes = Encoding.UTF8.GetBytes(signedMessage);
//                     byte[] encryptedMessageBytes = rsaPublic.Encrypt(signedMessageBytes, RSAEncryptionPadding.OaepSHA256);
//                     string base64EncryptedMessage = Convert.ToBase64String(encryptedMessageBytes);
//                     Console.WriteLine("Encrypted Message (Base64): " + base64EncryptedMessage);
//                 }
//             }
//         }
//         catch (Exception ex)
//         {
//             Console.WriteLine($"An error occurred: {ex.Message}");
//         }
//     }
// }
