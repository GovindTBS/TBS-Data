package com.example;

import org.apache.xml.security.Init;
import org.apache.xml.security.signature.XMLSignature;
import org.apache.xml.security.transforms.Transforms;
import org.apache.xml.security.utils.ElementProxy;
import org.apache.xml.security.utils.Constants;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.w3c.dom.Node;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.security.Key;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import javax.crypto.KeyGenerator;

import org.apache.xml.security.encryption.XMLCipher;
import org.apache.xml.security.encryption.EncryptedData;
import org.apache.xml.security.encryption.EncryptedKey;
import org.apache.xml.security.keys.KeyInfo;
import org.apache.xml.security.keys.content.X509Data;
import org.apache.xml.security.keys.content.x509.XMLX509Certificate;
import org.apache.xml.security.keys.content.x509.XMLX509IssuerSerial;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

public class XmlCrypto {  
    private static final String PRIVATE_KEY_PATH = "sylogist2.key";
    private static final String PUBLIC_SIGN_CERT_PATH = "sylogist2_ned_org.pem";
    private static final String PUBLIC_ENCRYPT_KEY_PATH = "citigroupsoauat.xenc.citigroup.com-pub.pem";

    public static void main(String[] args) {
        try {
            String xmlString = createXmlPayload();
            Document xmlDoc = buildXmlDocument(xmlString);

            Init.init();
            ElementProxy.setDefaultPrefix(Constants.SignatureSpecNS, "ds");

            PrivateKey privateSignKey = loadPrivateKey(PRIVATE_KEY_PATH);
            X509Certificate signCert = loadCertificate(PUBLIC_SIGN_CERT_PATH);
            PublicKey publicEncryptKey = loadCertificate(PUBLIC_ENCRYPT_KEY_PATH).getPublicKey();

            String signedEncryptedRequest = signAndEncryptXml(xmlDoc, privateSignKey, signCert, publicEncryptKey);
            System.out.println(signedEncryptedRequest);

            String responseXMLPayload = ""; // Simulate the response XML payload
            Document decryptedDoc = decryptAndVerify(responseXMLPayload, privateSignKey, signCert);
            System.out.println(decryptedDoc);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String createXmlPayload() {
        String xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Document xmlns=\"urn:iso:std:iso:20022:tech:xsd:pain.001.001.03\"><CstmrCdtTrfInitn>...</CstmrCdtTrfInitn></Document>";
        String paymentBase64 = Base64.getEncoder().encodeToString(xmlString.getBytes());
        return "<Request><paymentBase64>" + paymentBase64 + "</paymentBase64></Request>";
    }

    private static Document buildXmlDocument(String xmlString) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(new InputSource(new StringReader(xmlString)));
    }

    private static PrivateKey loadPrivateKey(String path) throws Exception {
        byte[] keyBytes = java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(path));
        String privateKeyPEM = new String(keyBytes)
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replaceAll("\\s+", "");
        byte[] decodedPrivateKey = Base64.getDecoder().decode(privateKeyPEM);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(decodedPrivateKey);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return keyFactory.generatePrivate(keySpec);
    }

    private static X509Certificate loadCertificate(String path) throws Exception {
        InputStream certInputStream = new FileInputStream(path);
        return (X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(certInputStream);
    }

    private static String signAndEncryptXml(Document xmlDoc, PrivateKey privateSignKey, X509Certificate signCert, PublicKey publicEncryptKey) throws Exception {
        Element root = xmlDoc.getDocumentElement();
        XMLSignature sig = new XMLSignature(xmlDoc, "file:", XMLSignature.ALGO_ID_SIGNATURE_RSA);
        root.appendChild(sig.getElement());
        
        Transforms transforms = new Transforms(xmlDoc);
        transforms.addTransform(Transforms.TRANSFORM_ENVELOPED_SIGNATURE);
        transforms.addTransform(Transforms.TRANSFORM_C14N_OMIT_COMMENTS);
        sig.addDocument("", transforms, Constants.ALGO_ID_DIGEST_SHA1);

        KeyInfo info = sig.getKeyInfo();
        X509Data x509data = new X509Data(xmlDoc);
        x509data.add(new XMLX509IssuerSerial(xmlDoc, signCert));
        x509data.add(new XMLX509Certificate(xmlDoc, signCert));
        info.add(x509data);
        sig.sign(privateSignKey);

        // Encrypt the signed XML Payload Document
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

        // Convert the Document back to a string, omitting the XML declaration
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        StringWriter writer = new StringWriter();
        transformer.transform(new DOMSource(xmlDoc), new StreamResult(writer));
        return writer.getBuffer().toString();
    }

    private static Document decryptAndVerify(String responseXMLPayload, PrivateKey privateDecryptKey, X509Certificate signCert) throws Exception {
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
            Document decryptedDoc = cipher.doFinal(xmlDoc, (Element) dataEL);

            // Verify signature
            return verifySignature(decryptedDoc, signCert);
        } else {
            throw new Exception("Encryption data or key is null");
        }
    }

    private static Document verifySignature(Document decryptedDoc, X509Certificate signCert) throws Exception {
        NodeList sigElement = decryptedDoc.getElementsByTagNameNS("http://www.w3.org/2000/09/xmldsig#", "Signature");
        if (sigElement == null || sigElement.getLength() == 0) {
            throw new Exception("No XML Digital Signature Found - unable to check the signature");
        }

        String BaseURI = "file:";
        XMLSignature signature = new XMLSignature((Element) sigElement.item(0), BaseURI);
        if (signature.checkSignatureValue(signCert)) {
            return decryptedDoc;
        } else {
            throw new Exception("Signature verification failed");
        }
    }
}
