/*
* GoogleAuth
*/
public class GoogleAuth {
    private static final Integer MILLISECONDS_PER_SECOND = 1000;
    private static final Integer MAX_DURATION = 3600;
    private static final Map<String, String> GOOGLE_SERVICE_AUTH_ENDPOINT = new Map<String, String>{
        'token' => 'https://www.googleapis.com/oauth2/v3/token',
        'calendar' => 'https://www.googleapis.com/auth/calendar'
    };
    private static final String KEY_START_LABEL = '-----BEGIN PRIVATE KEY-----\n';
    private static final String KEY_END_LABEL = '\n-----END PRIVATE KEY-----\n';
    private static final String PRIVATE_KEY_DEVELOPER_NAME = 'Private_Key';

    private static GoogleAuth instance = null;
    private Google_API_Setting__c setting = [SELECT id, access_Token__c, access_Token_Time_Stamp__c, client_Email_ID__c, google_Calender_ID__c FROM google_API_Setting__c WHERE Name = 'Google_Setting' FOR UPDATE];
    private Boolean needUpdateSetting = false;

    public class ClaimSet {
        //The email address of the service account.
        public String iss;
        //A space-delimited list of the permissions that the application requests.
        public String scope;
        //A descriptor of the intended target of the assertion. When making an access token request this value is always https://www.googleapis.com/oauth2/v4/token.
        public String aud;
        //The expiration time of the assertion, specified as seconds since 00:00:00 UTC, January 1, 1970. This value has a maximum of 1 hour after the issued time.
        public Long exp;
        //The time the assertion was issued, specified as seconds since 00:00:00 UTC, January 1, 1970.
        public Long iat;
        //The email address of the user for which the application is requesting delegated access.
        public String sub;

        public ClaimSet() {
        }

        public ClaimSet(List<String> serviceNames, String serviceAccount, String calendarId) {
            this.iss = serviceAccount;
            this.scope = '';
            for(String sName : serviceNames) {
                this.scope += ' ' + GOOGLE_SERVICE_AUTH_ENDPOINT.get(sName);
            }
            this.scope = this.scope.substring(1);
            this.aud = GOOGLE_SERVICE_AUTH_ENDPOINT.get('token');
            this.iat = System.now().getTime() / MILLISECONDS_PER_SECOND - 1;
            this.exp = this.iat + MAX_DURATION;
            this.sub = calendarId;
        }
    }

    public class PrivateKey {
        public String private_key_id;
        public String private_key;
        public String client_email;
        public String client_id;
        public String type;

        public PrivateKey() {
        }

        public PrivateKey(Document keyDoc) {
            PrivateKey key      = (PrivateKey) JSON.deserialize((keyDoc.body).toString(), PrivateKey.class);
            this.private_key_id = key.private_key_id;
            this.private_key    = key.private_key;
            this.client_email   = key.client_email;
            this.client_id      = key.client_id;
            this.type           = key.type;
        }

        public Blob getBlobPrivateKey() {
            String pkValue = private_key.removeStart(KEY_START_LABEL).removeEnd(KEY_END_LABEL);
            return EncodingUtil.base64Decode(pkValue);
        }

        public Blob encrypt(String algorithmName, String input) {
            return Crypto.sign(algorithmName, Blob.valueOf(input), getBlobPrivateKey());
        }
    }

    public class AccessTokenResponse {
        public String access_token;
        public String token_type;
        public Integer expires_in;

        public AccessTokenResponse() {
        }
    }

    private static final String JWT_HEADER = '{"alg":"RS256","typ":"JWT"}';
    private static final String ENCODEING_SCHAME = 'UTF-8';
    private static final String ENCRYPTION_SCHAME = 'RSA-SHA256';
    private static final String GRANT_TYPE = 'urn:ietf:params:oauth:grant-type:jwt-bearer';
    public String encodedJWTHeader;
    public ClaimSet claims;
    public String encodedClaims;
    //JWS(JSON Web Signature) {Base64url encoded header}.{Base64url encoded claim set}
    public String encodedSignature;
    //JWT(JSON Web Token) {Base64url encoded header}.{Base64url encoded claim set}.{Base64url encoded signature}
    public String jwt;
    public Document privateKeyDocument;

    public GoogleAuth(String serviceName) {
        this.encodedJWTHeader = EncodingUtil.Base64Encode(Blob.valueOf(JWT_HEADER));
        this.claims = new ClaimSet(new List<String>{serviceName}, setting.client_Email_ID__c, setting.google_Calender_ID__c);
        this.encodedClaims = EncodingUtil.Base64Encode(Blob.valueOf(JSON.serialize(this.claims)));
        this.privateKeyDocument = [SELECT body FROM Document WHERE developerName = :PRIVATE_KEY_DEVELOPER_NAME];
        PrivateKey pk = new PrivateKey(this.privateKeyDocument);
        this.encodedSignature = EncodingUtil.Base64Encode(pk.encrypt(ENCRYPTION_SCHAME, this.encodedJWTHeader + '.' + this.encodedClaims));
        this.jwt = this.encodedJWTHeader + '.' + this.encodedClaims + '.' + this.encodedSignature;
    }

    public AccessTokenResponse requestAccessKey() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(GOOGLE_SERVICE_AUTH_ENDPOINT.get('token'));
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String grantType = EncodingUtil.urlEncode(GRANT_TYPE, ENCODEING_SCHAME);
        String assertion = EncodingUtil.urlEncode(jwt, ENCODEING_SCHAME);
        req.setBody('grant_type=' + grantType + '&assertion=' + assertion);

        HttpResponse res = http.send(req);
        return (AccessTokenResponse) JSON.deserialize(res.getBody(), AccessTokenResponse.class);
    }

    public String getAccessToken() {
        String accessToken = setting.access_Token__c;
        // to be safe give 1 sec buffer
        if(Datetime.now().getTime() - setting.access_Token_Time_Stamp__c.getTime() > 1000) {
            AccessTokenResponse accessTokenRes = requestAccessKey();
            setting.access_Token__c = accessTokenRes.access_token;
            setting.access_Token_Time_Stamp__c = Datetime.now().addSeconds(Integer.ValueOf(accessTokenRes.expires_in));
            accessToken = accessTokenRes.access_token;
        }
        return accessToken;
    }

    public static GoogleAuth getInstance(String serviceName) {
        if(instance == null) return new GoogleAuth(serviceName);
        return instance;
    }

    public void updateAccessToken() {
        update setting;
    }

}
