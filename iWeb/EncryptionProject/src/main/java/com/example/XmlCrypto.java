package com.example;

import org.apache.xml.security.Init;
import org.apache.xml.security.signature.XMLSignature;
import org.apache.xml.security.transforms.Transforms;
import org.apache.xml.security.utils.ElementProxy;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
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
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.security.Key;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;

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
        
        Init.init();
        ElementProxy.setDefaultPrefix(Constants.SignatureSpecNS, "ds");
        
        String privateKeyPath = "sylogist2.key";
        byte[] keyBytes = java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(privateKeyPath));
        String privateKeyPEM = new String(keyBytes)
        .replace("-----BEGIN PRIVATE KEY-----", "")
        .replace("-----END PRIVATE KEY-----", "")
        .replaceAll("\\s+", "");
        byte[] decodedPrivateKey = Base64.getDecoder().decode(privateKeyPEM);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(decodedPrivateKey);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateSignKey = keyFactory.generatePrivate(keySpec);
        
        // Load the public certificate from a .pem file
        String publicKeyPath = "citigroupsoauat.xenc.citigroup.com-pub.pem"; // Update with your public key path
        InputStream inputStream = new FileInputStream(publicKeyPath);
        X509Certificate cert = (X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(inputStream);
        PublicKey publicEncryptKey = cert.getPublicKey();
        
        
        String xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Document xmlns=\"urn:iso:std:iso:20022:tech:xsd:pain.001.001.03\"><CstmrCdtTrfInitn><GrpHdr><MsgId>MSG123456789</MsgId><CreDtTm>2024-09-27T10:30:00</CreDtTm><NbOfTxs>3</NbOfTxs><CtrlSum>1500.00</CtrlSum><InitgPty><Nm>Example Company Name</Nm><PstlAdr><StrtNm>Main Street 123</StrtNm><PstCd>12345</PstCd><TwnNm>Example City</TwnNm><Ctry>US</Ctry></PstlAdr><Id><OrgId><Othr><Id>VAT123456789</Id></Othr></OrgId></Id></InitgPty></GrpHdr><PmtInf><PmtInfId>Batch123456</PmtInfId><PmtMtd>TRF</PmtMtd><BtchBookg>true</BtchBookg><NbOfTxs>1</NbOfTxs><CtrlSum>500.00</CtrlSum><PmtTpInf><InstrPrty>NORM</InstrPrty></PmtTpInf><ReqdExctnDt>2024-09-30</ReqdExctnDt><Dbtr><Nm>Example Debtor Name</Nm><PstlAdr><StrtNm>Main Street 123</StrtNm><PstCd>12345</PstCd><TwnNm>Example City</TwnNm><Ctry>US</Ctry></PstlAdr><Id><OrgId><Othr><Id>BEI123456789</Id></Othr></OrgId></Id></Dbtr><DbtrAcct><Id><IBAN>US12345678901234567890</IBAN></Id></DbtrAcct><DbtrAgt><FinInstnId><BIC>BANKUS33</BIC></FinInstnId></DbtrAgt><ChrgBr>SLEV</ChrgBr><CdtTrfTxInf><PmtId><EndToEndId>E2E1234567890</EndToEndId></PmtId><Amt><InstdAmt Ccy=\"USD\">500.00</InstdAmt></Amt><CdtrAgt><FinInstnId><BIC>RECIPIENTBIC</BIC></FinInstnId></CdtrAgt><Cdtr><Nm>Recipient Name</Nm><PstlAdr><StrtNm>Recipient Street 456</StrtNm><PstCd>67890</PstCd><TwnNm>Recipient City</TwnNm><Ctry>GB</Ctry></PstlAdr></Cdtr><CdtrAcct><Id><IBAN>GB12345678901234567890</IBAN></Id></CdtrAcct><RmtInf><Ustrd>Invoice 12345</Ustrd></RmtInf></CdtTrfTxInf></PmtInf></CstmrCdtTrfInitn></Document>";
        
        // Parse the XML string into a Document
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document xmlDoc = db.parse(new ByteArrayInputStream(xmlString.getBytes()));
        
        
        // Signing the XML Payload Document
        Element root = xmlDoc.getDocumentElement();
        XMLSignature sig = new XMLSignature(xmlDoc, "file:", XMLSignature.ALGO_ID_SIGNATURE_RSA);
        root.appendChild(sig.getElement());
        
        Transforms transforms = new Transforms(xmlDoc);
        transforms.addTransform(Transforms.TRANSFORM_ENVELOPED_SIGNATURE);
        transforms.addTransform(Transforms.TRANSFORM_C14N_OMIT_COMMENTS);
        sig.addDocument("", transforms, Constants.ALGO_ID_DIGEST_SHA1);
        
        KeyInfo info = sig.getKeyInfo();
        X509Data x509Data = new X509Data(xmlDoc);
        x509Data.add(new XMLX509IssuerSerial(xmlDoc, cert));
        x509Data.add(new XMLX509Certificate(xmlDoc, cert));
        info.add(x509Data);
        
        sig.sign(privateSignKey);
        
        
        // Encrypt the signed XML Payload Document
        String jceAlgorithmName = "DESede";
        KeyGenerator keyGenerator = KeyGenerator.getInstance(jceAlgorithmName);
        SecretKey symmetricKey = keyGenerator.generateKey();
        String algorithmURI = XMLCipher.RSA_v1dot5;
        XMLCipher keyCipher = XMLCipher.getInstance(algorithmURI);
        keyCipher.init(XMLCipher.WRAP_MODE, publicEncryptKey);
        EncryptedKey encryptedKey = keyCipher.encryptKey(xmlDoc, symmetricKey);
        
        Element rootElement = xmlDoc.getDocumentElement();
        algorithmURI = XMLCipher.TRIPLEDES;
        XMLCipher xmlCipher = XMLCipher.getInstance(algorithmURI);
        xmlCipher.init(XMLCipher.ENCRYPT_MODE, symmetricKey);
        EncryptedData encryptedData = xmlCipher.getEncryptedData();
        KeyInfo keyInfo = new KeyInfo(xmlDoc);
        keyInfo.add(encryptedKey);
        encryptedData.setKeyInfo(keyInfo);
        xmlCipher.doFinal(xmlDoc, rootElement, false);
        
        // Convert the Document back to a string
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        DOMSource source = new DOMSource(xmlDoc);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        StreamResult result = new StreamResult(outputStream);
        transformer.transform(source, result);
        
        // Print the signed and encrypted XML
        String signedEncryptedXml = outputStream.toString("UTF-8");       
        
        String cleanedXml = cleanXml(signedEncryptedXml);
        System.out.println(cleanedXml);
    }
    
    
    private static String cleanXml(String xml) throws Exception {
        // Parse XML string into a Document
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document document = builder.parse(new java.io.ByteArrayInputStream(xml.getBytes()));
        
        // Transform XML Document to string without indentation or spaces
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
        transformer.setOutputProperty(OutputKeys.INDENT, "no");
        
        // Write the XML content as string
        StringWriter writer = new StringWriter();
        transformer.transform(new DOMSource(document), new StreamResult(writer));
        
        // Remove occurrences of `&#13;` and trim whitespace
        return writer.toString().replaceAll("&#13;", "").replaceAll("\\s+", "");
    }
}
