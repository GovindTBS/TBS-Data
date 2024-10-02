package com.SignEncrypt;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.PrivateKey;
import java.security.Security;
import org.apache.xml.security.encryption.EncryptedData;
import org.apache.xml.security.encryption.EncryptedKey;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Map;
import java.util.Optional;
import org.w3c.dom.Node;


import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.jose4j.jwe.JsonWebEncryption;
import org.jose4j.jws.JsonWebSignature;

import com.microsoft.azure.functions.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.azure.functions.*;
import org.apache.xml.security.encryption.XMLCipher;
import org.apache.xml.security.signature.XMLSignature;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.StringReader;
import java.io.StringWriter;
import java.security.Key;
import java.util.logging.Level;
import org.xml.sax.InputSource;

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

            // Parse the request body
            String requestBody = request.getBody().orElse("");
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> bodyMap = objectMapper.readValue(requestBody, Map.class);
            String encryptedPayload = bodyMap.get("encryptedPayload");
            String mode = bodyMap.get("mode"); 

            if (encryptedPayload == null) {
                return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                        .body("Missing 'encryptedPayload' in the request body").build();
            }

            String decryptedPayload = processPayload(mode, encryptedPayload, decryptPrivateKey, verifyPublicCert);

            if (decryptedPayload == null) {
                return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                        .body("Invalid 'mode' specified. Use 'json' or 'xml'.").build();
            }

            return request.createResponseBuilder(HttpStatus.OK).body(decryptedPayload).build();

        } catch (Exception e) {
            context.getLogger().log(Level.SEVERE, "Error processing request: {0}", e.getMessage());
            return request.createResponseBuilder(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error during decryption and verification: " + e.getMessage()).build();
        }
    }

    private String processPayload(String mode, String encryptedPayload, PrivateKey decryptPrivateKey, X509Certificate verifyPublicCert) throws Exception {
        switch (mode.toLowerCase()) {
            case "json":
                return decryptAndVerifyJson(encryptedPayload, decryptPrivateKey, verifyPublicCert);
            case "xml":
                return decryptAndVerifyXml(encryptedPayload, decryptPrivateKey, verifyPublicCert);
            default:
                return null;
        }
    }

    private String decryptAndVerifyJson(String encryptedPayload, PrivateKey decryptPrivateKey, X509Certificate verifyPublicCert) throws Exception {
        JsonWebEncryption jwe = new JsonWebEncryption();
        jwe.setCompactSerialization(encryptedPayload);
        jwe.setKey(decryptPrivateKey); 
        String signedPayload = jwe.getPlaintextString();

        JsonWebSignature jws = new JsonWebSignature();
        jws.setCompactSerialization(signedPayload);
        jws.setKey(verifyPublicCert.getPublicKey()); 

        if (jws.verifySignature()) {
            return jws.getPayload();
        } else {
            throw new Exception("Signature verification failed for JSON payload");
        }
    }

    private String decryptAndVerifyXml(String encryptedXmlPayload, PrivateKey privateDecryptKey, X509Certificate signCert) throws Exception {
        Document decryptedDoc = decryptXml(encryptedXmlPayload, privateDecryptKey);
        return verifySignature(decryptedDoc, signCert) ? documentToString(decryptedDoc) : null;
    }

    private static Document decryptXml(String responseXMLPayload, PrivateKey privateDecryptKey) throws Exception {
        org.apache.xml.security.Init.init();
        Document decryptedDoc = null;
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document xmlDoc = builder.parse(new InputSource(new StringReader(responseXMLPayload)));

        Node dataEL;
        Node keyEL;

        Element docRoot = xmlDoc.getDocumentElement();
        if ("http://www.w3.org/2001/04/xmlenc#".equals(docRoot.getNamespaceURI()) && "EncryptedData".equals(docRoot.getLocalName())) {
            dataEL = docRoot;
        } else {
            NodeList childs = docRoot.getElementsByTagNameNS("http://www.w3.org/2001/04/xmlenc#", "EncryptedData");
            if (childs == null || childs.getLength() == 0) {
                throw new Exception("Encrypted Data not found on XML Document while parsing to decrypt");
            }
            dataEL = childs.item(0);
        }

        NodeList keyList = ((Element) dataEL).getElementsByTagNameNS("http://www.w3.org/2001/04/xmlenc#", "EncryptedKey");
        if (keyList == null || keyList.getLength() == 0) {
            throw new Exception("Encrypted Key not found on XML Document while parsing to decrypt");
        }
        keyEL = keyList.item(0);
        
        XMLCipher cipher = XMLCipher.getInstance();
        cipher.init(XMLCipher.DECRYPT_MODE, null);
        EncryptedData encryptedData = cipher.loadEncryptedData(xmlDoc, (Element) dataEL);
        EncryptedKey encryptedKey = cipher.loadEncryptedKey(xmlDoc, (Element) keyEL);

        if (encryptedData != null && encryptedKey != null) {
            String encAlgoURL = encryptedData.getEncryptionMethod().getAlgorithm();
            XMLCipher keyCipher = XMLCipher.getInstance();
            keyCipher.init(XMLCipher.UNWRAP_MODE, privateDecryptKey);
            Key encryptionKey = keyCipher.decryptKey(encryptedKey, encAlgoURL);
            cipher = XMLCipher.getInstance();
            cipher.init(XMLCipher.DECRYPT_MODE, encryptionKey);
            decryptedDoc = cipher.doFinal(xmlDoc, (Element) dataEL);
        }
        return decryptedDoc;
    }

    private boolean verifySignature(Document decryptedDoc, X509Certificate signCert) throws Exception {
        NodeList signatureNodes = decryptedDoc.getElementsByTagNameNS("http://www.w3.org/2000/09/xmldsig#", "Signature");

        if (signatureNodes.getLength() == 0) {
            throw new Exception("No XML Digital Signature Found");
        }

        Element signatureElement = (Element) signatureNodes.item(0);
        XMLSignature signature = new XMLSignature(signatureElement, "file:");

        return signature.checkSignatureValue(signCert);
    }

    private String documentToString(Document doc) throws Exception {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        StringWriter writer = new StringWriter();
        transformer.transform(new DOMSource(doc), new StreamResult(writer));
        return writer.getBuffer().toString();
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
