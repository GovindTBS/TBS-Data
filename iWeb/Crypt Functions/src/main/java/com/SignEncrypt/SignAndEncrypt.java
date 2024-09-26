package com.SignEncrypt;

import java.util.Map;
import java.util.Optional;

import com.microsoft.azure.functions.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.azure.functions.*;

import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.jose4j.jwe.JsonWebEncryption;
import org.jose4j.jws.JsonWebSignature;
import org.jose4j.jws.AlgorithmIdentifiers;
import org.jose4j.jwe.KeyManagementAlgorithmIdentifiers;
import org.jose4j.jwe.ContentEncryptionAlgorithmIdentifiers;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.logging.Level;
public class SignAndEncrypt {

    @FunctionName("SignAndEncrypt")
    
    public HttpResponseMessage run(
        @HttpTrigger(name = "req", methods = {HttpMethod.GET, HttpMethod.POST}, authLevel = AuthorizationLevel.ANONYMOUS)
        HttpRequestMessage<Optional<String>> request,
        final ExecutionContext context) {

        context.getLogger().info("Java HTTP trigger processed a request.");

        try {
            Security.addProvider(new BouncyCastleProvider());

            PrivateKey signPrivateKey = loadPrivateKey("sylogist2.key");
                                                                                                                                                
            X509Certificate encryptPublicCert = loadCertificate("citigroupsoauat.xenc.citigroup.com-pub.pem");

            String requestBody = request.getBody().orElse("");
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> bodyMap = objectMapper.readValue(requestBody, Map.class);
            String payload = bodyMap.get("payload");

            if (payload == null) {
                return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                        .body("Missing 'encryptedPayload' in the request body").build();
            }

            JsonWebSignature jwsignature = new JsonWebSignature();
            jwsignature.setPayload(payload);
            jwsignature.setAlgorithmHeaderValue(AlgorithmIdentifiers.RSA_USING_SHA256);
            jwsignature.setKey(signPrivateKey);
            String signedPayload = jwsignature.getCompactSerialization();

            JsonWebEncryption jwe = new JsonWebEncryption();
            jwe.setPlaintext(signedPayload);
            jwe.setAlgorithmHeaderValue(KeyManagementAlgorithmIdentifiers.RSA_OAEP_256);
            jwe.setEncryptionMethodHeaderParameter(ContentEncryptionAlgorithmIdentifiers.AES_256_GCM);
            jwe.setKey(encryptPublicCert.getPublicKey());
            String encryptedPayload = jwe.getCompactSerialization();

            return request.createResponseBuilder(HttpStatus.OK).body(encryptedPayload).build();

        } catch (Exception Err) {
            context.getLogger().log(Level.SEVERE, "Error processing request: {0}", Err.getMessage());
            return request.createResponseBuilder(HttpStatus.INTERNAL_SERVER_ERROR)
                          .body("Error during sign and encrypt process: " + Err.getMessage()).build();
        }
    }

     public static PrivateKey loadPrivateKey(String privateKeyPath) throws Exception {
        InputStream privateKeyStream = SignAndEncrypt.class.getClassLoader().getResourceAsStream(privateKeyPath);
        if (privateKeyStream == null) {
            throw new IllegalArgumentException("Private key resource not found: " + privateKeyPath);
        }

        PEMParser pemParser = new PEMParser(new InputStreamReader(privateKeyStream));
        JcaPEMKeyConverter converter = new JcaPEMKeyConverter().setProvider("BC");

        Object object = pemParser.readObject();
        pemParser.close();
        privateKeyStream.close();

        if (object instanceof org.bouncycastle.asn1.pkcs.PrivateKeyInfo) {
            return converter.getPrivateKey((org.bouncycastle.asn1.pkcs.PrivateKeyInfo) object);
        } else {
            throw new IllegalArgumentException("Invalid private key format");
        }
    }

    public static X509Certificate loadCertificate(String certificatePath) throws Exception {
        InputStream certStream = SignAndEncrypt.class.getClassLoader().getResourceAsStream(certificatePath);
        if (certStream == null) {
            throw new IllegalArgumentException("Certificate resource not found: " + certificatePath);
        }

        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");

        try {
            return (X509Certificate) certFactory.generateCertificate(certStream);
        } finally {
            certStream.close();
        }
    } 
}

