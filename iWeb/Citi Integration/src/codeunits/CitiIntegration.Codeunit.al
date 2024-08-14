// ! Test
codeunit 50141 "Citi Integration"
{
    procedure InitiatePayment(PaymentJnlRec: Record "Gen. Journal Line")
    begin
        CitiIntgSetup.Get();

        CreateXmlDemo();

        GetSigningKey(CitiIntgKeys);

        SignXml();

    end;


    local procedure CreateXmlDemo(): Text
    var
        xmlElem2: XmlElement;
        xmlElem3: XmlElement;
        xmlElem: XmlElement;
        XmlDoc: XmlDocument;
        XmlDec: XmlDeclaration;
    begin
        xmlDoc := xmlDocument.Create();
        xmlDec := xmlDeclaration.Create('1.0', 'utf-8', 'yes');
        xmlDoc.SetDeclaration(xmlDec);
        xmlElem := xmlElement.Create('DemoXMLFile');
        xmlElem.SetAttribute('attribute1', 'value1');
        xmlElem.SetAttribute('attribute2', 'value2');
        xmlElem2 := XmlElement.Create('DataItems');
        xmlElem3 := XmlElement.Create('DataItem');
        xmlElem3.Add(XmlText.Create('textvalue'));
        xmlElem2.Add(xmlElem3);
        xmlElem.Add(xmlElem2);
        XmlDoc.Add(xmlElem);
        XmlDoc.WriteTo(xmlTxt);
        exit(xmlTxt);
    end;

    procedure GetSigningKey(CitiIntgKey: Record "Citi Bank Intg. Keys"): Text
    var
        IStream: InStream;
    begin
        CitiIntgKey.Get(CitiIntgKey."Certificate Name"::"Citi sign-in certificate");
        CitiIntgKey.CalcFields(Value);
        if CitiIntgKey.Uploaded then
            CitiIntgKey.Value.CreateInStream(IStream);
        KeyText := CitiIntgKey.ReturnKeyText(IStream);
        Clear(KeyText);
        KeyText := 'BwIAAACkAABSU0EyAAQAAAEAAQD99dvdVctFcYP6fGCvz/8QcoJqjpfKMPxCIsVRAZSCaKTB6Dl0DbEQBcaLNe8Cm31lzMYyf/2vh6gM+GUHmKcBYo2Z7JvauTGXFXEyv02ai8RINlvAGAicZwWoyGJb5h4sM881Q5+BuDTcoyefk+b7x7KBQjMD/wNuPCWijZ0lsP+Gt1tPryE757QDDl95jQk04ZS+70vGOAO836f+RCyeA6c0ZEA1eYzsM/PVsv+nLwh7pTj7KLFSha5CM304SdcDnyOnt1ARyv1BQsRhyN3IAOH/Se00OfWhcc0sZCjg+xvDebKuoODHDhUfHJPchOmyvhSxjyNACJuxg1uGh3XRmaPoceXXFCuNhFGheK5cQrfUGHpWeJKrpWM/+f3XcrYob0jQCloBIicXfvhhPnkPojiOquxmjy0rA8/JRjHov3+znJY+pQgFC5cUmvGWxhWygm+qDwYco6yCSRkkaIp/K39uJXQ2pQf9XapqjtAJipRo5xX0o/itiDyF1qPT7TumZROMUhU3znXGnxPelZ2bA7SgPiu6BBKADfqG1XJE1K50ydaEfyXYceYHIs7UAMLw9aTptqHbPPGp1hDL2xpWBR6hvqkPqouiVJ7VgPHkjxwT/hgXBvJbHOm/ghq/xA/1oTtXLJHXCASVdylt+nwauOp5qR0Dfdbz7IQGjChYzBHuqDuKorpmfHhZl+bDTHpJ1PjWrojoBfAt2v5zlBnw/ipjkD9MXKrNlPqbgeYXUAeAzfFKQhF2kr3zlmExIS8=';
    end;

    procedure SignXml(): Text;
    var
        SignedXmlText: Text;
    begin
        Message(KeyText);
        SignedXmlText := SignXmlMgmt.SignXmlText(xmlTxt, KeyText);
        exit(SignedXmlText);
    end;


    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        CitiIntgKeys: Record "Citi Bank Intg. Keys";
        SignXmlMgmt: Codeunit "Signed XML Mgt.";
        xmlTxt: Text;
        KeyText: Text;

}



