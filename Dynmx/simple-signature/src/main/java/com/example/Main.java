package com.example;

import com.google.cloud.translate.Translate;
import com.google.cloud.translate.TranslateOptions;
import com.google.cloud.translate.Translation;
import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Main {

    public static void translateXlfFile(String inputFilePath, String outputFilePath, String targetLanguage) {
        try {
            // Initialize the document builder
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            DocumentBuilder builder = factory.newDocumentBuilder();

            // Parse the input XLF file
            Document document = builder.parse(new File(inputFilePath));
            document.getDocumentElement().normalize();

            // Get all <trans-unit> elements
            NodeList transUnits = document.getElementsByTagName("trans-unit");

            // Iterate over <trans-unit> elements
            for (int i = 0; i < transUnits.getLength(); i++) {
                Element transUnit = (Element) transUnits.item(i);

                // Get the <source> and <target> elements within the <trans-unit>
                Node sourceNode = transUnit.getElementsByTagName("source").item(0);
                Node targetNode = transUnit.getElementsByTagName("target").item(0);

                if (sourceNode != null && targetNode != null) {
                    String sourceText = sourceNode.getTextContent();
                    String targetText = targetNode.getTextContent();

                    // If the target is marked as [NAB: NOT TRANSLATED], translate it dynamically
                    if ("[NAB: NOT TRANSLATED]".equals(targetText)) {
                        String translatedText = translateText(sourceText, targetLanguage);
                        targetNode.setTextContent(translatedText);
                    }
                }
            }

            // Write the updated document to the output file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            DOMSource source = new DOMSource(document);
            StreamResult result = new StreamResult(new File(outputFilePath));
            transformer.transform(source, result);

            System.out.println("Translation complete. Saved as " + outputFilePath);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Method to translate text using Google Cloud Translation API
    public static String translateText(String text, String targetLanguage) {
        // Initialize Google Cloud Translation client
        Translate translate = TranslateOptions.getDefaultInstance().getService();
        
        // Translate the text
        Translation translation = translate.translate(
            text,
            Translate.TranslateOption.targetLanguage(targetLanguage)
        );
        
        return translation.getTranslatedText();
    }

    public static void main(String[] args) {
        // Input and output file paths
        String inputFilePath = "Dynmx Ibanity Integration.de-DE.xlf";
        String outputFilePath = "output_translated.xlf";
        String targetLanguage = "nl";  // Dutch language code

        // Perform translation
        translateXlfFile(inputFilePath, outputFilePath, targetLanguage);
    }
}
