using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

class Program
{
    static void Main(string[] args)
    {
        string xmlString = "<RSAKeyValue><Modulus>m2CF5y1bUCi1YTDYWNx10MN2bkfDMjHh3TzEZ+oDfL/bJ9qb4DFLfTRP74ZZO78ZxXh9zXLTWbGBoKZdiz+60NK3c5uDTHEIBf/rz0BW4+3YFWfRRBl+VUi/5gbwaT49S0lGxtK/xBV/vQPts87kZsEzHLjK+x0jrkItrAKZNKv/UE1Nt5ZCF2OEm95uyCPdXJNCCCZ5P7arfORYDY7ek2/OxXsBWHtYpQOm/IbxR6vX/+7ilXifwD7zUrER2MHXbSqK6aepBvIZTjibJ6PC1mK7zEFtKd85fnXCO/6P1xjHXqYBluIa8uTkLQFuVHtU/qaBj/ivKq5HuPfZBeQw+Q==</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
        string plainText = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><Document xmlns=\"urn:iso:std:iso:20022:tech:xsd:pain.002.001.03\"><CstmrPmtStsRpt><GrpHdr><MsgId>CITIBANK/20210311-PSR/981382059</MsgId><CreDtTm>09/03/24</CreDtTm><InitgPty><Id><OrgId><BICOrBEI>CITIUS33</BICOrBEI></OrgId></Id></InitgPty></GrpHdr><OrgnlGrpInfAndSts><OrgnlMsgId>GBP161114694869</OrgnlMsgId><OrgnlMsgNmId>pain.001.001.03</OrgnlMsgNmId></OrgnlGrpInfAndSts><OrgnlPmtInfAndSts><OrgnlPmtInfId>14017498 Fund Transfer Domestic</OrgnlPmtInfId><TxInfAndSts><OrgnlEndToEndId>CC21TPH3B8J8H2R</OrgnlEndToEndId><TxSts>ACSP</TxSts><StsRsnInf><AddtlInf>Processed Settled at clearing System. Payment settled at clearing system</AddtlInf></StsRsnInf><OrgnlTxRef><Amt><InstdAmt Ccy=\"USD\">0.00</InstdAmt></Amt><ReqdExctnDt>2021-02-03</ReqdExctnDt><PmtMtd>TRF</PmtMtd><RmtInf><Ustrd>TR002638</Ustrd></RmtInf><Dbtr><Nm>CITIBANK E-BUSINESS EUR DUM DEMO</Nm></Dbtr><DbtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId><PstlAdr><Ctry>GB</Ctry></PstlAdr></FinInstnId></DbtrAgt><CdtrAgt><FinInstnId><BIC>fakebic</BIC></FinInstnId></CdtrAgt><Cdtr><Nm>creditorname</Nm></Cdtr><CdtrAcct><Id><Othr><Id>12345678</Id></Othr></Id></CdtrAcct></OrgnlTxRef></TxInfAndSts></OrgnlPmtInfAndSts></CstmrPmtStsRpt><Signature xmlns=\"http://www.w3.org/2000/09/xmldsig#\"><SignedInfo><CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\" /><SignatureMethod Algorithm=\"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256\" /><Reference URI=\"\"><Transforms><Transform Algorithm=\"http://www.w3.org/2000/09/xmldsig#enveloped-signature\" /></Transforms><DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\" /><DigestValue>R/Xbtei/RPyAfpOjxmUO0mnFwc2J6HcHrZEgVGuJokM=</DigestValue></Reference></SignedInfo><SignatureValue>GS6vN/ugaFu8oya/MhSIexZcFhuNOBcgWMqShfBJKihokYSivpjms3jUKwd45IGEqNK1ruhWqh8nnXDnERzKJGDvjninSQEiO82To2hnyKRw9l5y4ROMjbg/Bx5TSyHmFKdxen/Gcdm5s9Uf1srJqC3HwnrJuvVyneb0JGr24q38R1/WDyHKJ7BpYiGqNsew04y4NNkaCNn6veo81s+WtpKXksuwF9TKfGbNzlz3/W0PF+AKPkZx3eDYfdoo4KHf63XWaoSyNBO1qCanzvSWiZoqtzR2FYGhiR24tVrLw0vXgAP0FpkLgqZpyZTy2RN0ePj1T9q2EMKKh1e2qlt38w==</SignatureValue></Signature></Document>";

        MemoryStream plainTextStream = new MemoryStream(Encoding.UTF8.GetBytes(plainText));
        MemoryStream encryptedTextStream = new MemoryStream();

        Encrypt(xmlString, plainTextStream, true, encryptedTextStream);

        string encryptedBase64 = Convert.ToBase64String(encryptedTextStream.ToArray());
        Console.WriteLine("Encrypted Text (Base64): " + encryptedBase64);
    }

    public static void Encrypt(string xmlString, Stream plainTextInStream, bool oaepPadding, Stream encryptedTextOutStream)
    {
        RSACryptoServiceProvider rsa = new RSACryptoServiceProvider();
        rsa.FromXmlString(xmlString);

        byte[] plainTextBytes;
        using (MemoryStream ms = new MemoryStream())
        {
            plainTextInStream.CopyTo(ms);
            plainTextBytes = ms.ToArray();
        }

        byte[] encryptedTextBytes = rsa.Encrypt(plainTextBytes, oaepPadding);

        encryptedTextOutStream.Write(encryptedTextBytes, 0, encryptedTextBytes.Length);
    }
}



// using System;
// using System.Security.Cryptography;
// using System.Text;

// class Program
// {
//     static void Main()
//     {
//         try
//         {
//             string pemFilePath = "Test.pem";
//             string privateKeyPem = System.IO.File.ReadAllText(pemFilePath);
//             string requestData = "data-to-sign";
// String privateKey;


//             using (var rsa = RSA.Create())
//             {
//                 rsa.ImportFromPem(privateKeyPem); // Import PEM-encoded private key
//                 RSAParameters rsaParameters = rsa.ExportParameters(true);
//                 Console.WriteLine("Private Key Parameters:");
//                 privateKey = BitConverter.ToString(rsaParameters.Modulus).Replace("-", "");
//                 Console.WriteLine($"Modulus: {BitConverter.ToString(rsaParameters.Modulus).Replace("-", "")}");
//                 Console.WriteLine($"Exponent: {BitConverter.ToString(rsaParameters.Exponent).Replace("-", "")}");
//                 Console.WriteLine($"D: {BitConverter.ToString(rsaParameters.D).Replace("-", "")}");
//                 Console.WriteLine($"P: {BitConverter.ToString(rsaParameters.P).Replace("-", "")}");
//                 Console.WriteLine($"Q: {BitConverter.ToString(rsaParameters.Q).Replace("-", "")}");
//                 Console.WriteLine($"DP: {BitConverter.ToString(rsaParameters.DP).Replace("-", "")}");
//                 Console.WriteLine($"DQ: {BitConverter.ToString(rsaParameters.DQ).Replace("-", "")}");
//                 Console.WriteLine($"InverseQ: {BitConverter.ToString(rsaParameters.InverseQ).Replace("-", "")}");
//                 var data = Encoding.UTF8.GetBytes(requestData);

//                 var signedData = rsa.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

//                 var base64SignedData = Convert.ToBase64String(signedData);
//                 Console.WriteLine($"Signed Data (Base64): {base64SignedData}");
//             }



//         }
//         catch (Exception ex)
//         {
//             Console.WriteLine($"An error occurred: {ex.Message}");
//         }
//     }
// }



// using System;
// using System.Security.Cryptography;
// using System.Text;

// class Program
// {
//     static void Main()
//     {
//         try
//         {
//             // string base64PrivateKey = "BwIAAACkAABSU0EyAAQAAAEAAQD99dvdVctFcYP6fGCvz/8QcoJqjpfKMPxCIsVRAZSCaKTB6Dl0DbEQBcaLNe8Cm31lzMYyf/2vh6gM+GUHmKcBYo2Z7JvauTGXFXEyv02ai8RINlvAGAicZwWoyGJb5h4sM881Q5+BuDTcoyefk+b7x7KBQjMD/wNuPCWijZ0lsP+Gt1tPryE757QDDl95jQk04ZS+70vGOAO836f+RCyeA6c0ZEA1eYzsM/PVsv+nLwh7pTj7KLFSha5CM304SdcDnyOnt1ARyv1BQsRhyN3IAOH/Se00OfWhcc0sZCjg+xvDebKuoODHDhUfHJPchOmyvhSxjyNACJuxg1uGh3XRmaPoceXXFCuNhFGheK5cQrfUGHpWeJKrpWM/+f3XcrYob0jQCloBIicXfvhhPnkPojiOquxmjy0rA8/JRjHov3+znJY+pQgFC5cUmvGWxhWygm+qDwYco6yCSRkkaIp/K39uJXQ2pQf9XapqjtAJipRo5xX0o/itiDyF1qPT7TumZROMUhU3znXGnxPelZ2bA7SgPiu6BBKADfqG1XJE1K50ydaEfyXYceYHIs7UAMLw9aTptqHbPPGp1hDL2xpWBR6hvqkPqouiVJ7VgPHkjxwT/hgXBvJbHOm/ghq/xA/1oTtXLJHXCASVdylt+nwauOp5qR0Dfdbz7IQGjChYzBHuqDuKorpmfHhZl+bDTHpJ1PjWrojoBfAt2v5zlBnw/ipjkD9MXKrNlPqbgeYXUAeAzfFKQhF2kr3zlmExIS8=";

//             string base64PrivateKey = "BwIAAACkAABSU0EyAAgAAAEAAQD5MOQF2fe4R64qr/iPgab+VHtUbgEt5OTyGuKWAaZexxjXj/47wnV+Od8pbUHMu2LWwqMnmzhOGfIGqafpiipt18HYEbFS8z7An3iV4u7/16tH8Yb8pgOlWHtYAXvFzm+T3o4NWOR8q7Y/eSYIQpNc3SPIbt6bhGMXQpa3TU1Q/6s0mQKsLUKuIx37yrgcM8Fm5M6z7QO9fxXEv9LGRklLPT5p8Abmv0hVfhlE0WcV2O3jVkDP6/8FCHFMg5tzt9LQuj+LXaaggbFZ03LNfXjFGb87WYbvTzR9SzHgm9on2798A+pnxDzd4TEyw0dudsPQddxY2DBhtShQWy3nhWCbhxMwWSiqhhcbusUA34jkquxLPp6kwLT5wUrY8UIkPEq+cKTy8SZb124/sT0y3UY+MUGuy1/2/+cRITzJKnMpIVgDhpqIVSnUBctPgJAtH5cWi5Ue7bR6qwiva9oLyLMMTVU3Zzj7qrY0JBOHLo995X5KVX2X+SpLGFgkQA14t9x/t4P9q1zEqL8vkcenEXtCsWHMko6p7qA4erq+h700rH6IlmlHjfcTN1Ln6nsBZp8u0P3PD+zcyY0IpBoq5LKm0ic+4iTGW4ShD3+MmYHlXpTNFf4InJyDXWzYKeBWE7F0Z76NTA8NSSPbh/MlvTO8YSRtUWsi3Z7/WochPh43tFu6xG0iz1w7wV8SCdZVui5V+8kmjpbMplImL9TQNP6/bVeHzpGQH5NR/c/R61PeMaCxyZSkrDfqfmPvwdnLb0ulEBpTKRSePAsZX9lBJbQk+mx4iUkVyDb90MA0gOprEthHOg5GFO5TvgVo58e7vsxOD76csSnREX32DBeOgiEaydO2xywusSXmMrOBta9NQcE12rA3w85nG/qkFfsEH2OjjHrcgxf99HF5XQ9cFlkz594cEc2e9nB0HKms1Odntn7QFP/oXKgrIHqSClwd1m6bHBHFNKLT4D2tpDZnefMRhoyxnEd4010ksglbfGpdXirhRYeuD0dgom/wdUzn80JlbdRpeoGHcsB3remXV3bcs7NHSn1ID6MRQ5nTSe3z0YnSN5ydEktz13QLlytGqey/zcAlZx6FaCWxn3F96+YjofYGdSlpPT7+XQ/3Nec8ZO69qn1q2l0r64WHO6RTFfvrb7465ttr+JiCtWtUMzjHwt3oLqbkxmvOIgzS7BODOZFEQ10ZC+QBnhZlUq4+A+lxp8RVGeqrv+ubheWHmeh9DDyY5Sz99eXOL+AjAMGA3Nc7pIvE3xjyljnoN1aDbUjxXQ+dR8JB3ODgJjO4zeU5rU4HRMfg+bJbuk5cF9scaN2ppFhq4P20NnbQd7/zLDzSWknuIIXbAdGUNrDVlclVqLsC+yE1D4zG6xktsSfcgwBGxmVdTBa6t3QzkOKTorZ454kvO5Vg6hFFGpDU274Lmn4YZPeuGbKqpA9GaVOBs8YgE2hE5L/KORpTTSrJLYehjxSrtRs8Hw2e98ndAqHhyNf1dsE/VIpSup7GL8FafWI8TnGcc7ZuHgtNFXcAUAw=";
//             byte[] privateKeyBlob = Convert.FromBase64String(base64PrivateKey);

//             using (var rsa = new RSACryptoServiceProvider())
//             {
//                 rsa.ImportCspBlob(privateKeyBlob);

//                 RSAParameters rsaParameters = rsa.ExportParameters(true);
//                 Console.WriteLine("Private Key Parameters:");
//                 Console.WriteLine($"Modulus: {BitConverter.ToString(rsaParameters.Modulus).Replace("-", "")}");
//                 Console.WriteLine($"Exponent: {BitConverter.ToString(rsaParameters.Exponent).Replace("-", "")}");
//                 Console.WriteLine($"D: {BitConverter.ToString(rsaParameters.D).Replace("-", "")}");
//                 Console.WriteLine($"P: {BitConverter.ToString(rsaParameters.P).Replace("-", "")}");
//                 Console.WriteLine($"Q: {BitConverter.ToString(rsaParameters.Q).Replace("-", "")}");
//                 Console.WriteLine($"DP: {BitConverter.ToString(rsaParameters.DP).Replace("-", "")}");
//                 Console.WriteLine($"DQ: {BitConverter.ToString(rsaParameters.DQ).Replace("-", "")}");
//                 Console.WriteLine($"InverseQ: {BitConverter.ToString(rsaParameters.InverseQ).Replace("-", "")}");

//                 string requestData = "data-to-sign";
//                 var data = Encoding.UTF8.GetBytes(requestData);

//                 var signedData = rsa.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

//                 var base64SignedData = Convert.ToBase64String(signedData);
//                 Console.WriteLine($"Signed Data (Base64): {base64SignedData}");
//             }
//         }
//         catch (Exception ex)
//         {
//             Console.WriteLine($"An error occurred: {ex.Message}");
//         }
//     }
// }
