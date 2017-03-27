/*
                        WHITE LABEL
    This class is used to integrate user data with jumio for identity verfication
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Himansu kesari                09/30/2015                                1.0
    =============================================================================
*/
public class WLJumioIntegration 
{
    //variables declarations
    public string strIframeURL {get; set;}
    public string strLeadId {get; set;}
    public ID LoggedInLeadId;
    Public Boolean isOppExist {get;set;}
    Public Click_Community_Setup__c objCommunity = new Click_Community_Setup__c();
    Public string strNetworkId;
    Public string strURLPrifix {get{return ClickCommon.URLPRefix;}set;}
    Public string loggedInOppId;
    public string OppIds;
    
    //Constructor
    public  WLJumioIntegration()
    {
        strNetworkId =  Network.getNetworkId();
        if(strNetworkId != null) objCommunity = ClickCommon.getCommunitySetup(strNetworkId);
         
        LoggedInLeadId  = ClickCommon.getCurrentLoggedInLeadId(UserInfo.getUserId()); 
        OppIds = Apexpages.currentpage().getparameters().get('id');
        system.debug('OppIds**************'+OppIds);
        if(OppIds != null && OppIds != '')
        {
            loggedInOppId = OppIds;
        }
        else
        {
            loggedInOppId = ClickCommon.getCurrentLoggedInOpportunityId(UserInfo.getuserId(),(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c);
        }
        isOppExist = false;
        If(loggedInOppId != null)
        {
           isOppExist = true;
        }
         WLQuoteDetail.setProgressBarWidth(0,0,(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c+'jumiointegration',strNetworkId);
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
        OppIds = Apexpages.currentpage().getparameters().get('id');
        String ReqDocid = apexpages.currentpage().getparameters().get('Docid');
        system.debug('ReqDocid !@#$%'+ReqDocid +'!@#$%^'+OppIds);
        JSONGenerator objJsonGen = JSON.createGenerator(true);
        objJsonGen.writeStartObject();
        
        if(LoggedInLeadId != null)
        {
            objJsonGen.writeStringField('merchantIdScanReference', LoggedInLeadId);
        }
        else
            objJsonGen.writeStringField('merchantIdScanReference', 'TestScanReference');
            
        String strRetUrl ='/Exception';
        if(objCommunity != null)
        {
            if(ReqDocid <> null && ReqDocid <> '')
            {
                if(OppIds <> null && OppIds <> '')
                {
                    system.debug('OppIds1**************'+OppIds);
                    strRetUrl =  objCommunity.Click_URL__c+ClickCommon.URLPrefix+'AcfJumioSuccess?Docid='+ReqDocid+'&id='+OppIds;  
                    system.debug('strRetUrl 2345**************'+strRetUrl );
                }
                else
                {
                    strRetUrl =  objCommunity.Click_URL__c+ClickCommon.URLPrefix+'AcfJumioSuccess';
                }
                system.debug('Hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii:'+objCommunity.Click_URL__c+ClickCommon.URLPrefix+'AcfJumioSuccess');
            }
            else
            {
                strRetUrl =  objCommunity.Click_URL__c+ClickCommon.URLPrefix+'AcfJumioSuccess';  
                system.debug('Hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii:'+objCommunity.Click_URL__c+ClickCommon.URLPrefix+'AcfJumioSuccess');
            }
        }
    //    strRetUrl = System.label.acfSite_Url+'/AcfJumioSuccess';  
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
        strIframeURL = objRootObject.authorizationToken;
        //Update Document Object and Lead.
        List<lead> lstLead = [select id,IsConverted,convertedOpportunityId from Lead where id =: LoggedInLeadId];
        if(lstLead != null && lstLead.size() > 0)
        {
            if(objRootObject.jumioIdScanReference <> null)
            {
                   List<Required_Document__c> lstRequiredDoc = new List<Required_Document__c>();
                   if(ReqDocid <> null && ReqDocid <> '' && OppIds != null && OppIds != '')
                   {
                       lstRequiredDoc = [select id,acfStatus__c,acfOpportunity__c,acf_Reference_No__c,acfDocument_Master__c from Required_Document__c Where id=:ReqDocid and acfOpportunity__c =:OppIds];
                   }else{
                           if(OppIds <> null && OppIds <> '')
                           {
                               lstRequiredDoc = [select id,acfStatus__c,acf_Reference_No__c,acfDocument_Master__c from Required_Document__c 
                                                                           Where acfDocument_Master__c <> null AND ((Lead__c <> null AND Lead__c=:LoggedInLeadId) OR (acfOpportunity__c <> null AND acfOpportunity__c=:OppIds)) 
                                                                           AND acfDocument_Master__r.acf_Source__c =: 'Jumio' limit 1];
                               system.debug('@@karthik'+lstRequiredDoc+'!@#'+objRootObject.jumioIdScanReference+'@@@'+LoggedInLeadId +'@@'+ OppIds );
                           }
                           else
                           {
                               lstRequiredDoc = [select id,acfStatus__c,acf_Reference_No__c,acfDocument_Master__c from Required_Document__c 
                                                                       Where acfDocument_Master__c <> null AND ((Lead__c <> null AND Lead__c=:LoggedInLeadId) OR (acfOpportunity__c <> null AND acfOpportunity__c=:lstLead[0].convertedOpportunityId)) 
                                                                       AND acfDocument_Master__r.acf_Source__c =: 'Jumio' limit 1];
                               system.debug('@@karthik'+lstRequiredDoc+'!@#'+objRootObject.jumioIdScanReference+'@@@'+LoggedInLeadId +'@@'+ lstLead[0].convertedOpportunityId);
                           }
                   }
                   if(lstRequiredDoc <> null && lstRequiredDoc.size()>0)
                   {
                      // lstRequiredDoc[0].acfStatus__c = 'Awaited';
                       lstRequiredDoc[0].acf_Reference_No__c = objRootObject.jumioIdScanReference;
                       update lstRequiredDoc;
                   }
            }
        }
        /*List<lead> lstLead = [select id, IsConverted from Lead where id =: strLeadId];
        if(lstLead != null && lstLead.size() > 0)
        {
            if(!lstLead[0].IsConverted)
            {
                lead lead_obj = new lead(id = strLeadId, acfScanReference__c = objRootObject.jumioIdScanReference);
                update lead_obj;
            }
            else
            {
                //TODO: Update contact code here                
            }
        }*/
        
       /* if(loggedInOppId != null && objRootObject.jumioIdScanReference <> null)
        {
            list<Opportunity> lstOpportnity = [select id from opportunity where id=: loggedInOppId];
            if(lstOpportnity != null && lstOpportnity.size()>0)
            {
                   List<Required_Document__c>lstRequiredDoc = [select id,acfStatus__c,acf_Reference_No__c,acfDocument_Master__c from Required_Document__c where acfDocument_Master__c <> null and Lead__c=:LoggedInLeadId and acfDocument_Master__r.acf_Source__c = 'Jumio' limit 1];
                   if(lstRequiredDoc <> null && lstRequiredDoc.size()>0)
                   {
                       lstRequiredDoc[0].acfStatus__c = 'Awaited';
                       lstRequiredDoc[0].acf_Reference_No__c = objRootObject.jumioIdScanReference;
                       update lstRequiredDoc;
                   }
            }
        }*/
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
       
        if(loggedInOppId == null)
        {
                string strLoggedInleadid = ClickCommon.getCurrentLoggedInLeadId(userInfo.getuserId());
                if(strLoggedInleadid != null)
                {
                    lead leadObj = new lead(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Skipped', id= strLoggedInleadid);
                    update leadObj;
                }
        }else if(loggedInOppId != null){
                opportunity objOpp = new opportunity(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Skipped',id= loggedInOppId);
                update objOpp;
        }
        String retPgname = ClickCommon.sendReturnUrl(userInfo.getUserId(),false,(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c+'id_verification',strNetworkId);
        Pagereference pageref = new Pagereference(retPgname);
        
        
       /* String retPgname = ClickCommon.sendReturnUrl(userInfo.getUserId(),true,'clickid_verification');
        Pagereference pageref = new Pagereference('/partners/'+retPgname);
        Pagereference pageref = page.acfBankDetails;
        pageref.setredirect(true);*/
        return pageref;
    }
       
}