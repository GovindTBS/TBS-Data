// package com.example;

// import java.io.FileInputStream;
// import java.security.KeyStore;
// import java.security.MessageDigest;
// import java.security.PrivateKey;
// import java.security.Security;
// import java.security.Signature;
// import java.util.Base64;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;

// public class Main {
//     static {
//         Security.addProvider(new BouncyCastleProvider());
//     }

//     public static void main(String[] args) {
//         try {
//             String pfxFilePath = "resources/Sign/signature_certificate.pfx"; 
//             String pfxPassword = "mIqn8t8As-skB5d"; 
//             String payload = ""; 
//             String host = "api.ibanity.com";
//             String keyId = "75b5d796-de5c-400a-81ce-e72371b01cbc";
//             long createdTimestamp = System.currentTimeMillis() / 1000;

//             PrivateKey privateKey = extractPrivateKey(pfxFilePath, pfxPassword);

//             String digestHeader = calculateDigest(payload);

//             String requestTarget = "get /isabel-connect/accounts"; 
//             String signingString = String.format(
//                 "(request-target): %s%n" +
//                 "digest: %s%n" +
//                 "created: %d%n" +
//                 "host: %s",
//                 requestTarget, digestHeader, createdTimestamp, host
//             );

//             String signature = signData(signingString, privateKey);

//             String signatureHeader = String.format(
//                 "Signature: keyId=\"%s\", created=%d, algorithm=\"hs2019\", " +
//                 "headers=\"(request-target) digest (created) host\", signature=\"%s\"",
//                 keyId, createdTimestamp, signature
//             );

//             String digest = String.format("Digest: %s", digestHeader);

//             System.out.println(signatureHeader);
//             System.out.println(digest);
//         } catch (Exception e) {
//             e.printStackTrace();
//         }
//     }

//     public static PrivateKey extractPrivateKey(String pfxFilePath, String password) throws Exception {
//         try (FileInputStream fis = new FileInputStream(pfxFilePath)) {
//             KeyStore keyStore = KeyStore.getInstance("PKCS12");
//             keyStore.load(fis, password.toCharArray());
//             String alias = keyStore.aliases().nextElement();
//             return (PrivateKey) keyStore.getKey(alias, password.toCharArray());
//         }
//     }

//     public static String signData(String data, PrivateKey privateKey) throws Exception {
//         Signature signature = Signature.getInstance("SHA256withRSA");
//         signature.initSign(privateKey);
//         signature.update(data.getBytes("UTF-8"));
//         byte[] signedBytes = signature.sign();
//         return Base64.getEncoder().encodeToString(signedBytes);
//     }

//     public static String calculateDigest(String payload) throws Exception {
//         MessageDigest digest = MessageDigest.getInstance("SHA-512");
//         byte[] hash = digest.digest(payload.getBytes("UTF-8"));
//         return "SHA-512=" + Base64.getEncoder().encodeToString(hash);
//     }
// }
