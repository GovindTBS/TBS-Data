package com.example;
import java.io.ByteArrayInputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPrivateKeySpec;
import java.util.Base64;

import org.bouncycastle.asn1.ASN1InputStream;
import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.asn1.pkcs.RSAPrivateKey;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.security.Security;

public class HashAndSign {

    // Method to load private key from PEM file (handle both PKCS#1 and PKCS#8)
    public static PrivateKey loadPrivateKey(String privateKeyPath) throws Exception {
        String privateKeyPem = new String(Files.readAllBytes(Paths.get(privateKeyPath)));

        // Remove PEM headers, footers, and any newlines
        privateKeyPem = privateKeyPem
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replace("-----BEGIN RSA PRIVATE KEY-----", "")
                .replace("-----END RSA PRIVATE KEY-----", "")
                .replaceAll("\\s+", ""); // Remove all whitespaces including newlines

        byte[] privateKeyBytes = Base64.getDecoder().decode(privateKeyPem);

        if (privateKeyPem.contains("RSA PRIVATE KEY")) {
            // It's a PKCS#1 RSA private key (requires extra handling)
            return loadPKCS1PrivateKey(privateKeyBytes);
        } else {
            // It's a PKCS#8 private key (standard handling)
            PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(privateKeyBytes);
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            return keyFactory.generatePrivate(keySpec);
        }
    }

    // Method to load a PKCS#1 formatted RSA private key
    public static PrivateKey loadPKCS1PrivateKey(byte[] keyBytes) throws Exception {
        Security.addProvider(new BouncyCastleProvider());

        // Decode the PKCS#1 key into a PrivateKey object
        try (ASN1InputStream asn1InputStream = new ASN1InputStream(new ByteArrayInputStream(keyBytes))) {
            RSAPrivateKey rsa = RSAPrivateKey.getInstance(asn1InputStream.readObject());
            RSAPrivateKeySpec keySpec = new RSAPrivateKeySpec(rsa.getModulus(), rsa.getPrivateExponent());
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            return keyFactory.generatePrivate(keySpec);
        }
    }

    // Method to create a SHA-256 hash and sign it using the private key
    public static byte[] signData(String data, PrivateKey privateKey) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initSign(privateKey);
        signature.update(data.getBytes());
        return signature.sign();
    }

    public static void main(String[] args) {
        try {
            // Path to the private key PEM file
            String privateKeyPath = "IsabelKeys/Sign/signature_private_key.pem";

            // Load the private key (handles both PKCS#1 and PKCS#8)
            PrivateKey privateKey = loadPrivateKey(privateKeyPath);

            // Input string to hash and sign
            String inputData = "This is a sample string for hashing and signing.";

            // Sign the data
            byte[] signedData = signData(inputData, privateKey);

            // Print the signed hash (in Base64 for readability)
            System.out.println("Signed Hash: " + Base64.getEncoder().encodeToString(signedData));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
