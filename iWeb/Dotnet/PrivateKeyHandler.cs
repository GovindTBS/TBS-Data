// using Org.BouncyCastle.Crypto;
// using Org.BouncyCastle.Crypto.Operators;
// using Org.BouncyCastle.OpenSsl;
// using Org.BouncyCastle.Security;
// using System;
// using System.IO;
// using System.Text;

// public class KeyLoader
// {
//     public static AsymmetricCipherKeyPair DecryptPrivateKey(string encryptedKeyPath, string password)
//     {
//         using (var reader = new StreamReader(encryptedKeyPath))
//         {
//             var pemReader = new PemReader(reader, new PasswordFinder(password));
//             return (AsymmetricCipherKeyPair)pemReader.ReadObject();
//         }
//     }
    
//     public class PasswordFinder : IPasswordFinder
//     {
//         private readonly string _password;

//         public PasswordFinder(string password)
//         {
//             _password = password;
//         }

//         public char[] GetPassword()
//         {
//             return _password.ToCharArray();
//         }
//     }
// }
