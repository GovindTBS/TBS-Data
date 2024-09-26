package com.SignEncrypt;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Map;
import java.util.Optional;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.jose4j.jwe.JsonWebEncryption;
import org.jose4j.jws.JsonWebSignature;

import com.microsoft.azure.functions.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.azure.functions.*;

public class DecryptAndVerify {
    
    @FunctionName("DecryptAndVerify")
    public HttpResponseMessage run(
    @HttpTrigger(name = "req", methods = {HttpMethod.GET, HttpMethod.POST}, authLevel = AuthorizationLevel.ANONYMOUS) 
    HttpRequestMessage<Optional<String>> request,
    final ExecutionContext context) {
        
        try {
            Security.addProvider(new BouncyCastleProvider());
            
            PrivateKey decryptPrivateKey = loadPrivateKey("sylogist2.key");
            
            X509Certificate verifyPublicCert = loadCertificate("citigroupsoauat.dsig.citigroup.com-pub.pem");
      
            String requestBody = request.getBody().orElse("");
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> bodyMap = objectMapper.readValue(requestBody, Map.class);
            String encryptedPayload = bodyMap.get("encryptedPayload");

            if (encryptedPayload == null) {
                return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                        .body("Missing 'encryptedPayload' in the request body").build();
            }
            
            JsonWebEncryption jwe = new JsonWebEncryption();
            jwe.setCompactSerialization(encryptedPayload);
            jwe.setKey(decryptPrivateKey); 
            String signedPayload = jwe.getPlaintextString();
            
            JsonWebSignature jws = new JsonWebSignature();
            jws.setCompactSerialization(signedPayload);
            jws.setCompactSerialization(signedPayload);
            jws.setKey(verifyPublicCert.getPublicKey()); 
            
            if (jws.verifySignature()) {
                String payload = jws.getPayload();
                return request.createResponseBuilder(HttpStatus.OK).body(payload).build();
            } else {
                return request.createResponseBuilder(HttpStatus.UNAUTHORIZED).body("Signature verification failed").build();
            }
        } catch (Exception e) {
            return request.createResponseBuilder(HttpStatus.INTERNAL_SERVER_ERROR)
            .body("Error during decryption and verification: " + e.getMessage()).build();
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
