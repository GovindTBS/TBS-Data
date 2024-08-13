codeunit 50141 "Citi Integration"
{
    procedure InitiatePayment(PaymentJnlRec: Record "Gen. Journal Line")
    var
        JsonObject: JsonObject;
        JsonSubObject: JsonObject;
        JsonText: Text;
    begin
        CitiIntgSetup.Get();

        JsonSubObject.Add('grantType', 'client_credentials');
        JsonSubObject.Add('scope', '/authenticationservices/v1');
        JsonSubObject.Add('sourceApplication', 'CCF');
        JsonObject.Add('oAuthToken', JsonSubObject);
        JsonObject.WriteTo(JsonText);

        SignedXml.SetSigningKey(GetSigningKey(CitiIntgKeys));
    end;

    var
        CitiIntgSetup: Record "Citi Bank Intg. Setup";
        CitiIntgKeys: Record "Citi Bank Intg. Keys";
        SignedXml: Codeunit SignedXml;

    procedure GetSigningKey(CitiIntgKey: Record "Citi Bank Intg. Keys"): Text
    var
        IStream: InStream;
    begin
        CitiIntgKey.Get(CitiIntgKey."Certificate Name"::"Citi sign-in certificate");
        if CitiIntgKey.Uploaded then
            CitiIntgKey.Value.CreateInStream(IStream);
        exit(CitiIntgKey.ReturnKeyText(IStream));
    end;
}