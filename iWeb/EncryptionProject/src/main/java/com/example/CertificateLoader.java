package com.example;

import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import org.w3c.dom.Document;

import java.security.PrivateKey;
import java.security.Security;

import java.io.FileReader;
import java.io.FileInputStream;
import java.io.InputStream;
import org.jose4j.jws.JsonWebSignature;
import org.jose4j.jwe.JsonWebEncryption;
import org.jose4j.jws.AlgorithmIdentifiers;
import org.jose4j.jwe.KeyManagementAlgorithmIdentifiers;
import org.jose4j.jwe.ContentEncryptionAlgorithmIdentifiers;
import org.bouncycastle.jce.provider.BouncyCastleProvider;


public class CertificateLoader {
    
    public static PrivateKey loadPrivateKey(String privateKeyPath) throws Exception {
        PEMParser pemParser = new PEMParser(new FileReader(privateKeyPath));
        JcaPEMKeyConverter converter = new JcaPEMKeyConverter().setProvider("BC");
        Object object = pemParser.readObject();
        pemParser.close();
        
        return converter.getPrivateKey((org.bouncycastle.asn1.pkcs.PrivateKeyInfo) object);
    }
    
    public static X509Certificate loadCertificate(String certificatePath) throws Exception {
        InputStream inputStream = new FileInputStream(certificatePath);
        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
        return (X509Certificate) certFactory.generateCertificate(inputStream);
    }
    
    public static void main(String[] args) throws Exception {
        
        Security.addProvider(new BouncyCastleProvider());
        
        PrivateKey signPrivateKey = loadPrivateKey("sylogist2.key");
        
        X509Certificate encryptPublicCert = loadCertificate("citigroupsoauat.xenc.citigroup.com-pub.pem");
        
        String painText = "{ \"oAuthToken\": { \"grantType\": \"client_credentials\", \"scope\": \"/authenticationservices/v1\", \"sourceApplication\": \"CCF\" } }";
        // String painText = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><oAuthToken xmlns=\"http://com.citi.citiconnect/services/types/oauthtoken/v2\"><grantType>client_credentials</grantType><scope>/authenticationservices/v1</scope><sourceApplication>CCF</sourceApplication></oAuthToken>";
        JsonWebSignature jwsignature = new JsonWebSignature();
        jwsignature.setPayload(painText);
        jwsignature.setAlgorithmHeaderValue(AlgorithmIdentifiers.RSA_USING_SHA256);
        jwsignature.setKey(signPrivateKey);
        String signed = jwsignature.getCompactSerialization();
        
        JsonWebEncryption jwe = new JsonWebEncryption();
        jwe.setPlaintext(signed);
        jwe.setAlgorithmHeaderValue(KeyManagementAlgorithmIdentifiers.RSA_OAEP_256);
        jwe.setEncryptionMethodHeaderParameter(ContentEncryptionAlgorithmIdentifiers.AES_256_GCM);
        jwe.setKey(encryptPublicCert.getPublicKey());
        String encryptedPayload = jwe.getCompactSerialization();
        
        System.out.println("\n\nEncrypted Payload: " + encryptedPayload);
        
        //decrypt
            PrivateKey signPrivateKey1 = loadPrivateKey("sylogist2.key");
            
            X509Certificate encryptPublicCert1 = loadCertificate("citigroupsoauat.dsig.citigroup.com-pub.pem");
            
            String encryptedPayload1 = "eyJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAtMjU2In0.Kwv6wUh1H28I4DQ4nLzU1nzDsQzZBXLEt7bZR5n3GbDMmgrYj_fGpMBuYGogQWlokYeQ8M0WsjRUxPr46lRaTJ4pQeugVxb-NLthOV4ubZUs5t3Px2bpo6OpI0xNWNahvtL0ZBwq7uBJD8w2T8dUgxDLogsqIB2wzBB1Qs9ClNgv9TosDEXJ40wqbYI3MM-uINE9JhYb1GOpSadyVIQi2ByGcbqstlSlp9DX4y0Op8e_IBqmyaGkQkye9JWTc75Htu7WTumshXuETMnIzxNpz7zBEsWbra43yE1IOCV25YzKcb1jU3ghFzFgToBXwPKLl9BZC4bZcEKc1r7O_QqThQ.-V4cFbFQthEecRbd.Kl0TLDKYYib-J0aQzyA7blQO7ADxUKWuHdn4dPD2YCNjft9jqzYtf5HhQ38lx_RH0fAjQrUEfjMMWjIN0qbJ-XsD5dei3bQN5PGcOLYwymU4cM79QzDatVZ1XSQ4ZzIMKCaBslG0o5IBrABUqyuwakeFCTzvcpYHMvS8USov8Rx-n1Ih82FHkEibQ5eUOcQMLMvhwD43uJT0VjCjhNoNRh4XrnNvEXTiRK0j0u_uXBPUTFRyfXrRrvMQUlxvYk0FyKwOej85wM15JqN6U-FbknAveCeUAtYNKwA6ibotrG16eMK_SI_JIVS_mYoXfR1YdIlsC6Ka0YyXE-PDVKJ4zuV3IwwqDFrAiE_52s5F_rb226Z6koCXmIm6lUqfVgj8JtcgUZUOmLzyRqxDFOHdgGAMx2vQlMj3CmENBRleNsnjBx3Y2dQ4rDLVnUkRpX1mfNWZHvKusFRWO1KDP7ws07jBdXjXAkewmC2FUVbQoRIyuwtxQmLvnq9G27v0IWh4PAAniuaXHPP0QknKPwHyj8Nez_hc36bKse9CMYt8yCnzEj82NZPOUdYkzJo1Mo49eizcw08tOjunhuf40RE9pOJQBanzqv9sgVjfqfwv4w4_j7RnSObmI68NFpKQdB0XqNASqaSE0Z6l9WwD72WdW5lHNUncxMisKE9yW2BNYboFSTU2IDI72KouusOJKDfcJMFcsk_f_o0pxiuA9lNMZML6PjNClMc2PusURbE1pT1LbHXCMS5cfzN1uLQHdc36KavZquoAsnsodrwKP1Sh5RtMtFN1UewzPakNeUtDWKpfuFJqXsFGpbQJjcM-W04u9MUd8s427F0XKF9xraQ6MOPnLVVwF-86JBfkFZuISUa25ErZrGb7hurBKmAPS35gK1kyakmo03WSptada9z4MR9e-wLGcAAlvZFqVUcdr27YhdlGklDx339gVOPZ2BDsuwsvJnQkAg7FnRVEtehWyEzYL-fsbUDUCV7ECmquwlyku26Y4pmK_IQt4qEK4WnLmmKuOSL794AH45xqPExGqFsSnn4qxKNELBIpycCTppkdU2rXuWRRt7Fsz6VKLEkvCnUa4wBmgWS27Ni7mifZvD7IbTF-Jmk0jrVO8HWHWyuf-8R505EY75gHJ4FaAgBbLbqDlzctZ0-isc9KhsF1rego_IXAIzrqTIwFWx_a8FQSF-MQpstqCJ0UY6thRqpZ3U7PSmaMwSTnW1OlGKwC4zRfVQ7lS2Bg-nwALgvG3f_DTNFtPo5nLBuSJqIBQJMsNtlAY-8ioZEeOUED7erDe8ZWBmoTVDHbnth5pZ6AW2CkAY6tMXAJJDBdZlvfyCq898ZYPDwxvBJwmnqeDa_h9dqWGt_q8jnptJLYroCa5HOp5KIacAkyTIdQ2GlNPR4dAGT8fkWrvhLT19TJCi12x6dZbc1VwfieMe4m508trOE-x4AzwbOgImW9jjDrTcH6JiAJk598qwkTjKA9GE_YyGWyoUhrevQYz81pJpuqEL3uXAmMnXG9e5Z4uNLuzfqIYWlNg44Shi81WGkxbkO-1Fiabp20xhHaUObS6i5ZAE0dFU0MBtQOmF-5yQDgw3U9DsOmVsBmkQu-pvRkvX5DZ2lwa5HGbUTfhWFhwpxwvNL09jrmgWAKJgywSA_Y0PTwpjsu4fDCfwqdMh6Ckh386RNuA5dmB1loqpvFGrfhw91D4YRXLgR1xWWKkT7hZCLlB7MMtsBJgcMkrBS9qtVlC8Huc-4L8aPiwhoHDjkW_6bnmZVL3oTU6gA5gjwZnWTMsVw2TTo1ZRDYPDKFaiBa5PEGmjKSq4f-v70EPnepJQ4RsOCPEkoXgNb6iEphbncaJ6WZxu-LH6UxXWJaQrM2h-msjOPtbB5rm5w2pq6GqxT1_MCd4JVNx3U6zVT3Q0IYotuwebr_kJJ0Mm56aKgYk-NHiKsckqR7hAANcRO30QGnfc6ZqIq--57Ad-Fm_ShtClpPg3TvZJ0mMqO0VK8HYlqZXjzUI2oXUcMSjxOQ9meH4KdWbprY4hKUk-Ks9oFTqQ.-ruWOezbt3fowUecphQuwA"; 
            
            JsonWebEncryption jwe1 = new JsonWebEncryption();
            jwe1.setCompactSerialization(encryptedPayload1);
            jwe1.setKey(signPrivateKey1); 
            String signed1 = jwe1.getPlaintextString();
            
            JsonWebSignature jws = new JsonWebSignature();
            jws.setCompactSerialization(signed1);
            jws.setKey(encryptPublicCert1.getPublicKey()); 
                
            if (jws.verifySignature()) {
                String payload = jws.getPayload();
                System.out.println("\n\nDecrypted Payload: " + payload + "\n");
            } else {
                System.out.println("\n\nSignature verification failed.");
            }   
    }
}
