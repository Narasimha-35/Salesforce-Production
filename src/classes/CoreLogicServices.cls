/*
   This class is used for calling Rest Api of CoreLogic. This class is Have Three main
   method 1 for genratinting access token.
          2. for genrating propertyIF respose.
          3. Avm details
    Note-- all End Point  comming from custome setting.      
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Prateek Gupta               21/04/2016                               1.0
    =============================================================================
*/ 

Public class CoreLogicServices{

    public String inputAddress { get; set; }
    private String ClientId ;
    private String  ClientSecret;
    private String  UserName ;
    private String  password;
    private String endPoint;
    private String TokenEndPoint;
    private String SearchApiEndPoint;
    private String AvmEndpoint;
    public String res {get ;set;}
    public CoreLogicServices(){
    
    
    Map<string,CoreLogic__c> mapCodes = CoreLogic__c.getAll();  
        if(mapCodes.get('CoreLogic').Username__C != null){
            UserName = mapCodes.get('CoreLogic').Username__C;
        }if(mapCodes.get('CoreLogic').password__C != null){
            password = mapCodes.get('CoreLogic').password__C;
        }
        if(mapCodes.get('CoreLogic').ClientId__C != null){
            ClientId = mapCodes.get('CoreLogic').ClientId__C;
        }
        
        if(mapCodes.get('CoreLogic').ClientSecret__C != null){
            ClientSecret = mapCodes.get('CoreLogic').ClientSecret__C;
        }
        
        if(mapCodes.get('CoreLogic').EndPoint__C != null){
        endPoint = mapCodes.get('CoreLogic').EndPoint__C;
        }
         if(mapCodes.get('CoreLogic').TokenEndPoint__c != null){
        TokenEndPoint = mapCodes.get('CoreLogic').TokenEndPoint__C;
        }
        
         if(mapCodes.get('CoreLogic').SearchApiEndPoint__C != null){
        SearchApiEndPoint = mapCodes.get('CoreLogic').SearchApiEndPoint__C;
        }
        
        if(mapCodes.get('CoreLogic').AvmEndpoint__C != null){
        AvmEndpoint = mapCodes.get('CoreLogic').AvmEndpoint__C;
        }
        
       
    }
    // This is use for getting token.
    public String getToken(){
        
        HttpRequest req = new HttpRequest();
        String URL =TokenEndPoint+'/access/oauth/token?client_id='+ClientId+'&client_secret='+ ClientSecret +'&grant_type=client_credentials';
        req.setEndpoint(URL);
        req.setMethod('GET');
        req.setHeader('accept','application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
       
        JSONParser parser = JSON.createParser(res.getBody());
        wrpToken tempToken = (wrpToken)parser.readValueAs(wrpToken.class);

        
        return tempToken.access_token;
        
    }

    // This is use for getting propertyId.
     public HttpResponse SearchProperty(String address){
        
            Http h1 = new Http();
            address =  EncodingUtil.urlEncode( address, 'UTF-8');
            String accessToken = getToken();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
         
            req1.setMethod('GET');
            req1.setEndpoint(SearchApiEndPoint +'/search/au/matcher/address?q='+ address);
            HttpResponse res1 = h1.send(req1);
            
            /* System.debug(res1.getBody());
            JSONParser parser = JSON.createParser(res1.getBody());
            
               while (parser.nextToken() != null) {

            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'propertyId')) {

                // Get the value.

                parser.nextToken();
                // Compute the grand total price for all invoices.
               return  parser.gettext();

            }
        }*/
             
           return res1;  
           
        
    }
    
    // This is use for Avm Details.
      public HttpResponse getPropertyAVM(String postBody){
        
            Http h1 = new Http();
            
            String accessToken = getToken();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setBody(postbody);
            req1.setMethod('POST');
            req1.setEndpoint(AvmEndpoint);
            HttpResponse res1 = h1.send(req1);
             
            return  res1;
        
    }
    // This method is use for genrating Json request.
    public String avmJson( String pid , String bathrooms ,  String bedrooms , String carSpaces , String craftsmanshipQuality, String floorAreaM2 , String landAreaM2 ,   String propertyType , String saleDate, String salePrice, String valuationDate , String yearBuilt  ){
        
        String  propertyJson = ' {"propertyId": '+pId +' ,"targetPropertyAvmInput": { "bathrooms": '+bathrooms+', "bedrooms": '+bedrooms+',"carSpaces": '+carSpaces+', "craftsmanshipQuality": "'+craftsmanshipQuality+'","floorAreaM2": '+floorAreaM2+',"landAreaM2": '+landAreaM2+','+
            +' "propertyType": "'+propertyType+'",'+
            + '"saleDate": "'+saleDate +'",'+
            + '"salePrice": '+ salePrice+','+
            +'  "valuationDate": "'+valuationDate +'",'+
            + ' "yearBuilt": '+ yearBuilt
            +'}'+
            +'}';
            
            return propertyJson;
    }
    
    public class wrpToken 
    {
    public String access_token {get ;set ;}
    }
     
    
}