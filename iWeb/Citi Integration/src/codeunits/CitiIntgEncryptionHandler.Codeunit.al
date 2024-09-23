//! Test (Static)
codeunit 50141 "Citi Intg Encryption Handler"
{
    procedure SignXmlPayload()
    var
        SignXmlMgt: Codeunit "Signed XML Mgt.";
        PrivateKey1: Text;
        XmlPayload: Text;
    begin
        XmlPayload := GetPaymentInitXMLPayload();
        PrivateKey1 := GetPrivateKey();
        XmlPayload := SignXmlMgt.SignXmlText(XmlPayload, PrivateKey1);
        Message(XmlPayload);
    end;


    procedure EncryptXmlPayload()
    var
        EncryptXml: Codeunit EncryptedXml;
        XmlDoc: XmlDocument;
        PublicKey: Text;
        XmlPayload: Text;
        Password: Text;
    begin
        PublicKey := 'MIID5zCCAs+gAwIBAgIUSDLdBczbUqZh+eNjrnYqErP1lzkwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJOWTERMA8GA1UEBwwITmV3IFlvcmsxDDAKBgNVBAoMA0RFUzEMMAoGA1UECwwDRVJQMRMwEQYDVQQDDApkZXMub3JnLmluMSIwIAYJKoZIhvcNAQkBFhNkZXMuY29tcGFueUBkZXMuY29tMB4XDTI0MDkwNjA3NTkyMFoXDTI1MDkwNjA3NTkyMFowgYIxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJOWTERMA8GA1UEBwwITmV3IFlvcmsxDDAKBgNVBAoMA0RFUzEMMAoGA1UECwwDRVJQMRMwEQYDVQQDDApkZXMub3JnLmluMSIwIAYJKoZIhvcNAQkBFhNkZXMuY29tcGFueUBkZXMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoTBLZf9i0Nh+lFrz+dlzBJsGswPZ7BDrNGiTTRaVNGjTW1M/27wR3l3m3j1uakrPxYTRwGot2Fdt1wAdeJpy027SWj6k2741+1c6sXBR9gOSJKr8cU2D65d+n9X2I7Ru0S04kFjTXqy76DzkJnkb9R874wwqNIkcOS1S1MQESgnnNUHzEZ5Rdgv+16Ub+p1Zj9LxOQFS//XqXOw7pQoAxSx+WEg0OGRpMn0LBDfH+68Sh/gsGQKe6pKtX2xdDum5apne/RYZsPos3os1l1MvU8nnD7k0xjZPa9PWetQ/PspB6/hxN9W4CpYrJSjYyO38tQp2awVFoP2y2Gm0ib7QgQIDAQABo1MwUTAdBgNVHQ4EFgQUobjZW8si/WTuC2bLDPtJxVHtZx0wHwYDVR0jBBgwFoAUobjZW8si/WTuC2bLDPtJxVHtZx0wDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAYO1N4erli/FUW6dmxso69TJ525zJ3QnhjeEOaVbap1qNZPwywkNZ3eaVngM9AcYWifNJ4e2ArzGPqTk52K2tOlZ7wDo9rO628tDpdo+Kx/YamcUcoTY7FC25DEoQo+rHyLC//sj8eLwL1Mtfs+xrEVxH4wjhTMyzpu4LjGYSowNn14kuoAc6LFkEVBhSqF3Ms0/LtfhVOvmWcMsaqmP00yA1Sj/GSAJKu1sRcwTtx1hdRqAKCgWH+fStyNVhCRepdIqHJf1vR2K0Fj2mWLQGILHzPuFMV+W8H8MYnwfbPLKQayOhFV8Gr+PzDxDQPcjAbSCxhrFK/SVaaZMRrfSLbQ==';
        Password := 'IAh4TauObFZwyDgZbHhwBl3WGiaA/smS8eQZjpo6pe8';
        XmlPayload := GetPaymentInitXMLPayload();
        EncryptXml.Encrypt(XmlDoc, 'Document', PublicKey, Password);
        XmlDoc.WriteTo(XmlPayload);
        Message(XmlPayload);
    end;


    procedure SignPayload(var Payload: Text)
    var
        SignXmlMgt: Codeunit "Signed XML Mgt.";
        TempBlob: Codeunit "Temp Blob";
        CryptMgt: Codeunit "Cryptography Management";
        PrivateKey1: Text;
        OutputStream: OutStream;
    begin
        // CitiIntgKeys.Get();
        // PrivateKey1 := GetPrivateKey();
        TempBlob.CreateOutStream(OutputStream);
        CryptMgt.SignData(Payload, PrivateKey1, Enum::"Hash Algorithm"::SHA256, OutputStream);
    end;

    procedure VerifyXmlSignature(XmlPayload: Text): Boolean
    var
        SignXmlMgt: Codeunit "Signed XML Mgt.";
        IsValidSignature: Boolean;
        PublicKey1: Text;
    begin
        PublicKey1 := GetPublicKey();
        IsValidSignature := SignXmlMgt.CheckXmlTextSignature(XmlPayload, PublicKey1);

        if IsValidSignature then
            Message('Signature verification succeeded.')
        else
            Message('Signature verification failed.');

        exit(IsValidSignature);
    end;

    procedure EncryptXmlElement(XmlPayload: Text)
    var
        RSACrypto: Codeunit RSACryptoServiceProvider;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        TempBlob1: Codeunit "Temp Blob";
        InputStream: InStream;
        OutputStream: OutStream;
        PublicKey: Text;
        Encrypted: Text;
    begin
        // Get the RSA public key
        PublicKey := GetPublicKey();

        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XmlPayload, InputStream.Length);

        TempBlob1.CreateOutStream(OutputStream);
        RSACrypto.Encrypt(PublicKey, InputStream, false, OutputStream);
        TempBlob1.CreateInStream(InputStream);
        InputStream.Read(Encrypted);

        Encrypted := Base64Convert.ToBase64(Encrypted);
        Message(Encrypted);

        // DecryptPayload(Encrypted);
    end;

    // procedure AESEncryptionExample(XmlPayload: Text)
    // var
    //     RijndaelCryptography: Codeunit "Rijndael Cryptography";
    //     Base64Convert: Codeunit "Base64 Convert";
    //     EncryptedText: Text;
    //     DecryptedText: Text;
    // begin
    //     RijndaelCryptography.SetEncryptionData(Base64Convert.ToBase64('m2CF5y1bUCi1YTDYWNx10MN2bkfDMjHh3TzEZ+oDfL/bJ9qb4DFLfTRP74ZZO78ZxXh9zXLTWbGBoKZdiz+60NK3c5uDTHEIBf/rz0BW4+3YFWfRRBl+VUi/5gbwaT49S0lGxtK/xBV/vQPts87kZsEzHLjK+x0jrkItrAKZNKv/UE1Nt5ZCF2OEm95uyCPdXJNCCCZ5P7arfORYDY7ek2/OxXsBWHtYpQOm/IbxR6vX/+7ilXifwD7zUrER2MHXbSqK6aepBvIZTjibJ6PC1mK7zEFtKd85fnXCO/6P1xjHXqYBluIa8uTkLQFuVHtU/qaBj/ivKq5HuPfZBeQw+Q=='), Base64Convert.ToBase64(XmlPayload));
    //     RijndaelCryptography.SetBlockSize(256);
    //     RijndaelCryptography.SetCipherMode('CBC');
    //     EncryptedText := RijndaelCryptography.Encrypt('Hello world');
    //     DecryptedText := RijndaelCryptography.Decrypt(EncryptedText);

    //     Message('EncryptedText: %1, DecryptedText: %2', EncryptedText, DecryptedText);
    // end;

    procedure DecryptPayload(XmlPayload: Text)
    var
        RSACrypto: Codeunit RSACryptoServiceProvider;
        TempBlob: Codeunit "Temp Blob";
        TempBlob1: Codeunit "Temp Blob";
        OutputStream: OutStream;
        InputStream: InStream;
        PublicKey: Text;
    begin
        PublicKey := GetPublicKey();

        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XmlPayload);
        TempBlob1.CreateOutStream(OutputStream);
        RSACrypto.Decrypt(PublicKey, InputStream, false, OutputStream);
    end;

    procedure GetPrivateKey(): text
    var
        x509Certificate: Codeunit X509Certificate2;
        Base64: Codeunit "Base64 Convert";
        KeyValue: Text;
        Password: Text;

    begin
        Password := Format('IAh4TauObFZwyDgZbHhwBl3WGiaA/smS8eQZjpo6pe8');
        KeyValue := 'BwIAAACkAABSU0EyAAgAAAEAAQD5MOQF2fe4R64qr/iPgab+VHtUbgEt5OTyGuKWAaZexxjXj/47wnV+Od8pbUHMu2LWwqMnmzhOGfIGqafpiipt18HYEbFS8z7An3iV4u7/16tH8Yb8pgOlWHtYAXvFzm+T3o4NWOR8q7Y/eSYIQpNc3SPIbt6bhGMXQpa3TU1Q/6s0mQKsLUKuIx37yrgcM8Fm5M6z7QO9fxXEv9LGRklLPT5p8Abmv0hVfhlE0WcV2O3jVkDP6/8FCHFMg5tzt9LQuj+LXaaggbFZ03LNfXjFGb87WYbvTzR9SzHgm9on2798A+pnxDzd4TEyw0dudsPQddxY2DBhtShQWy3nhWCbhxMwWSiqhhcbusUA34jkquxLPp6kwLT5wUrY8UIkPEq+cKTy8SZb124/sT0y3UY+MUGuy1/2/+cRITzJKnMpIVgDhpqIVSnUBctPgJAtH5cWi5Ue7bR6qwiva9oLyLMMTVU3Zzj7qrY0JBOHLo995X5KVX2X+SpLGFgkQA14t9x/t4P9q1zEqL8vkcenEXtCsWHMko6p7qA4erq+h700rH6IlmlHjfcTN1Ln6nsBZp8u0P3PD+zcyY0IpBoq5LKm0ic+4iTGW4ShD3+MmYHlXpTNFf4InJyDXWzYKeBWE7F0Z76NTA8NSSPbh/MlvTO8YSRtUWsi3Z7/WochPh43tFu6xG0iz1w7wV8SCdZVui5V+8kmjpbMplImL9TQNP6/bVeHzpGQH5NR/c/R61PeMaCxyZSkrDfqfmPvwdnLb0ulEBpTKRSePAsZX9lBJbQk+mx4iUkVyDb90MA0gOprEthHOg5GFO5TvgVo58e7vsxOD76csSnREX32DBeOgiEaydO2xywusSXmMrOBta9NQcE12rA3w85nG/qkFfsEH2OjjHrcgxf99HF5XQ9cFlkz594cEc2e9nB0HKms1Odntn7QFP/oXKgrIHqSClwd1m6bHBHFNKLT4D2tpDZnefMRhoyxnEd4010ksglbfGpdXirhRYeuD0dgom/wdUzn80JlbdRpeoGHcsB3remXV3bcs7NHSn1ID6MRQ5nTSe3z0YnSN5ydEktz13QLlytGqey/zcAlZx6FaCWxn3F96+YjofYGdSlpPT7+XQ/3Nec8ZO69qn1q2l0r64WHO6RTFfvrb7465ttr+JiCtWtUMzjHwt3oLqbkxmvOIgzS7BODOZFEQ10ZC+QBnhZlUq4+A+lxp8RVGeqrv+ubheWHmeh9DDyY5Sz99eXOL+AjAMGA3Nc7pIvE3xjyljnoN1aDbUjxXQ+dR8JB3ODgJjO4zeU5rU4HRMfg+bJbuk5cF9scaN2ppFhq4P20NnbQd7/zLDzSWknuIIXbAdGUNrDVlclVqLsC+yE1D4zG6xktsSfcgwBGxmVdTBa6t3QzkOKTorZ454kvO5Vg6hFFGpDU274Lmn4YZPeuGbKqpA9GaVOBs8YgE2hE5L/KORpTTSrJLYehjxSrtRs8Hw2e98ndAqHhyNf1dsE/VIpSup7GL8FafWI8TnGcc7ZuHgtNFXcAUAw=';
        //add code to get value from setup 
        exit(KeyValue);
    end;

    local procedure GetPublicKey(): Text
    var
        X509Certificate2: Codeunit X509Certificate2;
        KeyValue: Text;
        Password: SecretText;
    begin
        KeyValue := 'MIIELDCCAxSgAwIBAgIRALu3uIBrZf4QvyGedSVezS0wDQYJKoZIhvcNAQELBQAwNTEVMBMGA1UEAwwMRXhhbXBsZSBDb3JwMRwwGgYDVQQKDBNFeGFtcGxlIENvcnBvcmF0aW9uMB4XDTI0MDkwMjEwMjcyNVoXDTI0MTAwMjEwMjcyNVowgdAxCzAJBgNVBAYTAlVTMSAwHgYJKoZIhvcNAQkBFhFhZG1pbkBleGFtcGxlLmNvbTEiMCAGA1UEDAwZQ2hpZWYgSW5mb3JtYXRpb24gT2ZmaWNlcjEWMBQGA1UECwwNSVQgRGVwYXJ0bWVudDEcMBoGA1UECgwTRXhhbXBsZSBDb3Jwb3JhdGlvbjERMA8GA1UEBwwITmV3IFlvcmsxETAPBgNVBAgMCE5ldyBZb3JrMR8wHQYDVQQDDBZbVEVTVF0gd3d3LmV4YW1wbGUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm2CF5y1bUCi1YTDYWNx10MN2bkfDMjHh3TzEZ+oDfL/bJ9qb4DFLfTRP74ZZO78ZxXh9zXLTWbGBoKZdiz+60NK3c5uDTHEIBf/rz0BW4+3YFWfRRBl+VUi/5gbwaT49S0lGxtK/xBV/vQPts87kZsEzHLjK+x0jrkItrAKZNKv/UE1Nt5ZCF2OEm95uyCPdXJNCCCZ5P7arfORYDY7ek2/OxXsBWHtYpQOm/IbxR6vX/+7ilXifwD7zUrER2MHXbSqK6aepBvIZTjibJ6PC1mK7zEFtKd85fnXCO/6P1xjHXqYBluIa8uTkLQFuVHtU/qaBj/ivKq5HuPfZBeQw+QIDAQABo4GaMIGXMAsGA1UdDwQEAwIE8DAsBgNVHSUBAf8EIjAgBggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwwwGgYDVR0RBBMwEYIPd3d3LmV4YW1wbGUuY29tMB0GA1UdDgQWBBSZnZDWxiaQzt5BZFWsZN9FhWlkIzAfBgNVHSMEGDAWgBS4OCFFGKFQfr4OrAMHydszaMVvzTANBgkqhkiG9w0BAQsFAAOCAQEAcffll/g59nIDQq6vnyqXfZgjWS1DvRCKsxRfE88XZHa3/5vYaTuKMsoNjwIRoj/RGI+z2VvYt5J/s3BZ4CzaT+vc+9x1Whlm/6OzT/JK1kfrKHDmMo167/YBXtnLz/fdIr3Dq9S09qIf+O0Puzmw1OjEIAj1Ffs56Aw51Z4k3UGxSqfkgs5jSegql/pOd8ou+4N2uZ+AewnMxcQLc9jxkFnFDcYGG4RwQbtcn1eKx+7ydP5ZpDZlBAoCuehJuqA+z2FnVA5NtEQrEhXAu9SNfTXM6lPxhjeDaB2cWkjY8Ua5Xg6PfI423ZtSiZUgKZbaRWUXebTQH8+a770eTUiCYg==';
        Password := Format('IAh4TauObFZwyDgZbHhwBl3WGiaA/smS8eQZjpo6pe8');
        KeyValue := X509Certificate2.GetCertificatePublicKey(KeyValue, Password);
        Message(KeyValue);
        exit(KeyValue);
    end;

    local procedure GetPaymentInitXMLPayload(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        PaymentInitRequestPort: XmlPort "Citi Payment Init Request";
        OutputStream: OutStream;
        InputStream: InStream;
        XmlPayload: Text;
    begin
        TempBlob.CreateOutStream(OutputStream);
        PaymentInitRequestPort.SetDestination(OutputStream);
        PaymentInitRequestPort.Export();
        TempBlob.CreateInStream(InputStream);
        InputStream.Read(XmlPayload);
        exit(XmlPayload);
    end;

}

