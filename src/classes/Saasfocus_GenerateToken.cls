// ----------------------------------------------------------------------------------
// This class Is used for Checking Access token is Expires or Not
// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       14-June-2012      Ashutosh Kumar         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------
//
public class Saasfocus_GenerateToken {


    Public String Header{get;set;}
    Public String encodedHeader{get;set;}
    Public Claimset cs{get;set;}
    public String jsonclaimset{get;set;}
    Public String encodedClaimset{get;set;}
    Public Blob Signature{get;set;}
    Public String encodedSignature{get;set;}
    Public String PrivateKey{get;set;}
    Public String signatureinput {get;set;}
    Public String request {get;set;}
    Public String resbody{get;set;}
    Public String responsewithsync{get;set;}
    public string urlencodedsignature {get;set;}

    public string Accesstoken{get;set;}
    public string Synctoken{get;set;}
    public TokenParse tp{get;set;}
    public  KeyGet gtkey{get;set;}

    public Saasfocus_GetNextSyncToken Stoken{get;set;}
    public boolean Istokenchanged = false;
     Google_API_Setting__c  obj = new Google_API_Setting__c();
    Public Saasfocus_GenerateToken()
    {


            onloading();
            Google_API_Setting__c  obj =  Google_API_Setting__c.getValues('Google_Setting');   // Call the custom setting for calender value



            Header = '{"alg":"RS256","typ":"JWT"}';
            encodedHeader = EncodingUtil.base64Encode(Blob.valueOf(Header));

            cs = new Claimset();
            cs.iss =  obj.Client_Email_ID__c;
            cs.scope ='https://www.googleapis.com/auth/calendar';
            cs.aud = 'https://www.googleapis.com/oauth2/v3/token';

            Long currentutctime  = system.now().gettime()/1000;

            cs.iat = String.valueof(currentutctime);
            cs.exp = String.valueof(currentutctime+300);
           // cs.sub = 'test.user@getmaxx.in';
            cs.sub =  obj.Google_Calender_ID__c;

            jsonclaimset = JSON.serialize(cs);

            encodedClaimset = EncodingUtil.base64Encode(Blob.valueOf(jsonclaimset ));
            signatureinput = encodedHeader+'.'+encodedClaimset;
            Blob privateKeyDecoded  = EncodingUtil.base64Decode(privateKey);
            Signature = Crypto.sign('RSA-SHA256',blob.valueof(signatureinput),privateKeyDecoded);
            encodedSignature = EncodingUtil.base64Encode(Signature);
            urlencodedsignature = EncodingUtil.urlEncode(encodedSignature,'UTF-8');

     }

    // This Method is used for create the private key in the specific format
     public void onloading()
       {
           List<Document> lisDocs =[SELECT AuthorId, Body, BodyLength FROM Document WHERE Name ='Private Key' LIMIT 1];
           Document objDoc = lisDocs[0];

           gtkey= (KeyGet)JSON.deserialize((objDoc.Body).toString(),KeyGet.Class);
           String p_key=gtkey.private_key;
           p_key=p_key.replace('-----BEGIN PRIVATE KEY-----\n','');
           p_key=p_key.replace('\n-----END PRIVATE KEY-----\n','');

           PrivateKey = p_key;
       }

  // This Method is used for Generate the AccessToken

    public Google_API_Setting__c  CheckAccessToken()
    {
             tp= new TokenParse();
             Stoken= new Saasfocus_GetNextSyncToken();

         // Logic for the get Custom setting Values

            obj= [Select Id, Access_Token__c,Access_Token_Time_Stamp__c,Sync_Token__c,Client_Email_ID__c,Google_Calender_ID__c,API_KEY__c From  Google_API_Setting__c  Where Name = 'Google_Setting' FOR UPDATE];


      // Logic for generate the New access token if previous token had expired or Null

         if(obj.Access_Token__c==null || obj.Access_Token_Time_Stamp__c <system.now())
         {
             String granttype = EncodingUtil.urlEncode('urn:ietf:params:oauth:grant-type:jwt-bearer','UTF-8');

             string assertion = encodedHeader+'.'+encodedClaimset+'.'+urlencodedsignature;

          //Logic for get the Access token

             HttpRequest req = new HttpRequest();
             req.setEndpoint('https://www.googleapis.com/oauth2/v3/token');
             req.setHeader('Content-Type','application/x-www-form-urlencoded');

            String body = 'grant_type='+granttype +
                          '&assertion='+ assertion;
            req.setBody(body);
            req.setMethod('POST');
            request = req.getBody();



            Http http = new Http();
            Httpresponse res = http.send(req);
            resbody = res.getBody();
            system.debug('******resbody'+resbody );
            tp= (TokenParse)JSON.deserialize( res.getBody(),TokenParse.Class);

     // Assign the new values in the custom setting(Google_Setting) field.

            obj= [Select Id, Access_Token__c,Access_Token_Time_Stamp__c,Sync_Token__c,API_KEY__c From  Google_API_Setting__c  Where Name = 'Google_Setting'];
            obj.Access_Token_Time_Stamp__c =system.now().addSeconds(Integer.ValueOf(tp.expires_in));
            obj.Access_Token__c= tp.access_token;
            obj.Access_Token_Time_Stamp__c = System.now().addSeconds(Integer.ValueOf(tp.expires_in)) ;

            Istokenchanged  =true;

         }

        return obj;
    }


  // This Method is used for update the Custom setting

   public void updategoogleSettings()
   {


            if(Istokenchanged)
            update obj;       // update Custom Setting

   }

  // Class for get the Claimset values

    Public Class Claimset
    {
     Public String iss;
     Public String scope;
     Public String aud;
     Public String exp;
     Public String iat;
     Public String sub;
     }


  // Class for parsing the access token response

    public class TokenParse
    {
     public String access_token;
     public String token_type;
     public Integer expires_in;
    }
   public class KeyGet
 {
    public String private_key_id;
    public String private_key;
    public String client_email;
    public String client_id;
    public String type;
 }

}