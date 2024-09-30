package com.SignEncrypt;

import java.util.Base64;
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
import org.apache.xml.security.Init;
import org.apache.xml.security.signature.XMLSignature;
import org.apache.xml.security.transforms.Transforms;
import org.apache.xml.security.utils.ElementProxy;
import org.apache.xml.security.utils.Constants;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.crypto.KeyGenerator;

import org.apache.xml.security.encryption.XMLCipher;
import org.apache.xml.security.encryption.EncryptedData;
import org.apache.xml.security.encryption.EncryptedKey;
import org.apache.xml.security.keys.KeyInfo;
import org.apache.xml.security.keys.content.X509Data;
import org.apache.xml.security.keys.content.x509.XMLX509Certificate;
import org.apache.xml.security.keys.content.x509.XMLX509IssuerSerial;

import java.security.Key;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.X509Certificate;
import java.security.cert.CertificateFactory;
import java.security.Security;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
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
            Init.init();
            
            PrivateKey signPrivateKey = loadPrivateKey("sylogist2.key");
            X509Certificate encryptPublicCert = loadCertificate("citigroupsoauat.xenc.citigroup.com-pub.pem");
            
            
            String requestBody = request.getBody().orElse("");
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> bodyMap = objectMapper.readValue(requestBody, Map.class);
            String payload = bodyMap.get("payload");
            String mode = bodyMap.get("mode"); 
            
            if (payload == null) {
                return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                .body("Missing 'payload' in the request body").build();
            }
            
            String encryptedPayload = processPayload(mode, payload, signPrivateKey, encryptPublicCert);
            
            if (encryptedPayload == null) {
                return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                .body("Invalid 'mode' specified. Use 'json' or 'xml'.").build();
            }
            
            return request.createResponseBuilder(HttpStatus.OK).body(encryptedPayload).build();
            
        } catch (Exception err) {
            context.getLogger().log(Level.SEVERE, "Error processing request: {0}", err.getMessage());
            return request.createResponseBuilder(HttpStatus.INTERNAL_SERVER_ERROR).body("Error during sign and encrypt process: " + err.getMessage()).build();
        }
    }
    
    private String processPayload(String mode, String payload, PrivateKey signPrivateKey, X509Certificate encryptPublicCert) throws Exception {
        return switch (mode.toLowerCase()) {
            case "json" -> signAndEncryptJson(payload, signPrivateKey, encryptPublicCert);
            case "xml" -> signAndEncryptXml(payload, signPrivateKey, encryptPublicCert.getPublicKey());
            default -> null;
        };
    }
    
    private String signAndEncryptJson(String payload, PrivateKey signPrivateKey, X509Certificate encryptPublicCert) throws Exception {
        JsonWebSignature jws = new JsonWebSignature();
        jws.setPayload(payload);
        jws.setAlgorithmHeaderValue(AlgorithmIdentifiers.RSA_USING_SHA256);
        jws.setKey(signPrivateKey);
        String signedPayload = jws.getCompactSerialization();
        
        JsonWebEncryption jwe = new JsonWebEncryption();
        jwe.setPlaintext(signedPayload);
        jwe.setAlgorithmHeaderValue(KeyManagementAlgorithmIdentifiers.RSA_OAEP_256);
        jwe.setEncryptionMethodHeaderParameter(ContentEncryptionAlgorithmIdentifiers.AES_256_GCM);
        jwe.setKey(encryptPublicCert.getPublicKey());
        
        return jwe.getCompactSerialization();
    }
    
    private String signAndEncryptXml(String xmlString, PrivateKey privateSignKey, PublicKey publicEncryptKey) throws Exception {
        X509Certificate signCert = loadCertificate("sylogist2_ned_org.pem");
        Document xmlDoc = buildXmlDocument(xmlString);
        ElementProxy.setDefaultPrefix(Constants.SignatureSpecNS, "ds");
        
        // Sign the XML
        XMLSignature sig = new XMLSignature(xmlDoc, "file:", XMLSignature.ALGO_ID_SIGNATURE_RSA);
        Element root = xmlDoc.getDocumentElement();
        root.appendChild(sig.getElement());
        
        Transforms transforms = new Transforms(xmlDoc);
        transforms.addTransform(Transforms.TRANSFORM_ENVELOPED_SIGNATURE);
        transforms.addTransform(Transforms.TRANSFORM_C14N_OMIT_COMMENTS);
        sig.addDocument("", transforms, Constants.ALGO_ID_DIGEST_SHA1);
        
        KeyInfo Info = sig.getKeyInfo();
        X509Data x509Data = new X509Data(xmlDoc);
        x509Data.add(new XMLX509IssuerSerial(xmlDoc, signCert));
        x509Data.add(new XMLX509Certificate(xmlDoc, signCert));
        Info.add(x509Data);
        sig.sign(privateSignKey);
        
        // Encrypt the XML
        Key symmetricKey = KeyGenerator.getInstance("DESede").generateKey();
        XMLCipher keyCipher = XMLCipher.getInstance(XMLCipher.RSA_v1dot5);
        keyCipher.init(XMLCipher.WRAP_MODE, publicEncryptKey);
        EncryptedKey encryptedKey = keyCipher.encryptKey(xmlDoc, symmetricKey);
        
        XMLCipher xmlCipher = XMLCipher.getInstance(XMLCipher.TRIPLEDES);
        xmlCipher.init(XMLCipher.ENCRYPT_MODE, symmetricKey);
        EncryptedData encryptedData = xmlCipher.getEncryptedData();
        KeyInfo keyInfo = new KeyInfo(xmlDoc);
        keyInfo.add(encryptedKey);
        encryptedData.setKeyInfo(keyInfo);
        xmlCipher.doFinal(xmlDoc, root, false);
        
        return documentToString(xmlDoc);
    }
    
    private Document buildXmlDocument(String xmlString) throws Exception {
        String paymentBase64 = Base64.getEncoder().encodeToString(xmlString.getBytes());
        xmlString = "<Request><paymentBase64>" + paymentBase64 + "</paymentBase64></Request>";
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(new InputSource(new StringReader(xmlString)));
    }
    
    private String documentToString(Document xmlDoc) throws Exception {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        StringWriter writer = new StringWriter();
        transformer.transform(new DOMSource(xmlDoc), new StreamResult(writer));
        return writer.getBuffer().toString();
    }
    
    public static PrivateKey loadPrivateKey(String privateKeyPath) throws Exception {
        try (InputStream privateKeyStream = SignAndEncrypt.class.getClassLoader().getResourceAsStream(privateKeyPath);
        PEMParser pemParser = new PEMParser(new InputStreamReader(privateKeyStream))) {
            
            if (privateKeyStream == null) {
                throw new IllegalArgumentException("Private key resource not found: " + privateKeyPath);
            }
            
            JcaPEMKeyConverter converter = new JcaPEMKeyConverter().setProvider("BC");
            Object object = pemParser.readObject();
            
            if (object instanceof org.bouncycastle.asn1.pkcs.PrivateKeyInfo) {
                return converter.getPrivateKey((org.bouncycastle.asn1.pkcs.PrivateKeyInfo) object);
            } else {
                throw new IllegalArgumentException("Invalid private key format");
            }
        }
    }
    
    public static X509Certificate loadCertificate(String certificatePath) throws Exception {
        try (InputStream certStream = SignAndEncrypt.class.getClassLoader().getResourceAsStream(certificatePath)) {
            if (certStream == null) {
                throw new IllegalArgumentException("Certificate resource not found: " + certificatePath);
            }
            
            CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
            return (X509Certificate) certFactory.generateCertificate(certStream);
        }
    }
}
