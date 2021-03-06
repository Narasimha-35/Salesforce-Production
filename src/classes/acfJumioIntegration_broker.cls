/*
                        Click Loans
    This class is used to integrate user data with jumio for identity verfication
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Ashutosh Belwal              11/18/2014                                1.0
    =============================================================================
*/
public class acfJumioIntegration_broker 
{
    //variables declarations
    public string strIframeURL {get; set;}
    public string strLeadId {get; set;}
    public ID LoggedInLeadId;
    Public Boolean isSkipvisible {get;set;}
    public string logedinuserid{get;set;}
    public string AccountIdUser{get;set;}
    public string strBaseURL {get;set;}
    //Constructor
    public  acfJumioIntegration_broker()
    {
    
        AccountIdUser=ApexPages.currentPage().getParameters().get('cid');
        strBaseURL = system.label.acf_Broker_Url;
        list<user>  lstuser = [select Id, ContactId, Contact.acf_Lead__c from User where AccountId =: AccountIdUser AND IsActive = true limit 1];
        logedinuserid=lstuser[0].Id;         
        LoggedInLeadId  = acfCommon.getCurrentLoggedInLeadId(logedinuserid); 
        system.debug('Ashu!!!=>'+LoggedInLeadId);
        isSkipvisible = true;
        If(LoggedInLeadId != null)
        {
            System.debug('@@@leadid'+LoggedInLeadId);
            List<Lead> lstLead = [select id,acfIs_Bank_Statement_Submitted__c,acfIs_Post_Login_Ques_Attempted__c from lead where id=:LoggedInLeadId];
            If(lstLead != null && lstLead.size()>0){
                   System.debug('@@@leadid'+lstLead);
                   If(lstLead[0].acfIs_Bank_Statement_Submitted__c && lstLead[0].acfIs_Post_Login_Ques_Attempted__c){
                        isSkipvisible = false;
                   }
            }
         }
          ClickQuoteDetail_partner.setProgressBarWidth(0,0,'BrokerClickjumiointegration');
                    
    }
    
    /*
        This method is used to get the iframe url of jumio
        ===================================================
        Name                 Date                   version
        ===================================================
        Prashant Kumar      11/18/2014                1.0
        ===================================================   
    */
    public void CallToJumio() 
    {
        JSONGenerator objJsonGen = JSON.createGenerator(true);
        objJsonGen.writeStartObject();
        
        if(LoggedInLeadId != null)
        {
            objJsonGen.writeStringField('merchantIdScanReference', LoggedInLeadId);
        }
        else
            objJsonGen.writeStringField('merchantIdScanReference', 'TestScanReference');

            system.debug('cons pge_name --------'+System.URL.getSalesforceBaseURL().toExternalForm());  
 
            //strBaseURL = system.label.acf_Broker_Url;
            String strRetUrl = strBaseURL+'/apex/BrokerJumioSuccess?cid='+AccountIdUser;
            
           // String strRetUrl = System.label.acfSite_Url+'/acfJumioSuccess; 
            
            objJsonGen.writeStringField('successUrl',strRetUrl);
            objJsonGen.writeStringField('errorUrl',strRetUrl);
            objJsonGen.writeEndObject();
            String jsonRequest = objJsonGen.getAsString();                
        
        //Get Merchant Api and Secret from Custom setting
        Jumio_Credentials__c objJumioCredential = Jumio_Credentials__c.getValues('Credential');       
        
        String strUserName = objJumioCredential.Merchant_API_token__c;
        String strPassword = objJumioCredential.Active_API_secret__c;    
        String strEndPoint = objJumioCredential.EndPoint__c;
        
        String strAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(strUserName + ':' + strPassword));
        
        //Create Http request
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(strEndPoint);
        System.debug('!!!! strAuthorizationHeader -'+ strAuthorizationHeader);
        req.setHeader('Authorization', strAuthorizationHeader);
        req.setHeader('Accept', 'application/json');             
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
        req.setBody(jsonRequest);                
        //send request        
        Http http = new Http();
        HTTPResponse jsonResponse = http.send(req);
        String jsonResponseBody = jsonResponse.getBody(); 
        system.debug('@@@json'+jsonResponseBody);                      
        RootObject objRootObject = parse(jsonResponseBody);
        strIframeURL = objRootObject.clientRedirectUrl;        
     
        //Update Document Object and Lead.
        List<lead> lstLead = [select id, IsConverted from Lead where id =: LoggedInLeadId];
        if(lstLead != null && lstLead.size() > 0)
        {
            if(!lstLead[0].IsConverted && objRootObject.jumioIdScanReference <> null)
            {
                   List<Required_Document__c>lstRequiredDoc = [select id,acfStatus__c,acf_Reference_No__c,acfDocument_Master__c from Required_Document__c where acfDocument_Master__c <> null and Lead__c=:LoggedInLeadId and acfDocument_Master__r.acf_Source__c = 'Jumio' limit 1];
                   if(lstRequiredDoc <> null && lstRequiredDoc.size()>0)
                   {
                       lstRequiredDoc[0].acfStatus__c = 'Awaited';
                       lstRequiredDoc[0].acf_Reference_No__c = objRootObject.jumioIdScanReference;
                       update lstRequiredDoc;
                   }
            }
        }
    }
    
    public class RootObject
    {
        public string timestamp { get; set; }
        public string authorizationToken { get; set; }
        public string clientRedirectUrl { get; set; }
        public string jumioIdScanReference { get; set; }
    }
    
    public static RootObject parse(String json) 
    {
        return (RootObject) System.JSON.deserialize(json, RootObject.class);
    } 
    
    /***added by karthik 02-01-2015******/
    Public pagereference redirectToNextPage()
    {
        string loggedInOppId = acfCommon.getCurrentLoggedInOpportunityId(logedinuserid);
        if(loggedInOppId == null)
        {
                string strLoggedInleadid = acfcommon.getCurrentLoggedInLeadId(logedinuserid);
                    lead leadObj = new lead(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Skipped', id= strLoggedInleadid);
                    update leadObj;
        }else{
                opportunity objOpp = new opportunity(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Skipped',id= loggedInOppId);
                update objOpp;
        }
        String retPgname = acfCommon.sendReturnUrl(logedinuserid,false,'clickid_verification');
        Pagereference pageref = new Pagereference('/apex/Broker'+retPgname+'?cid='+AccountIdUser);
        return pageref;
    }
       
}