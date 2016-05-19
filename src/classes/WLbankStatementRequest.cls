/*====================================================
                WHITE LABEL
========================================================*/
public class WLbankStatementRequest 
{
    Public string strEndpoint;
    Public string strApiKey;
    //Constructor
    public WLbankStatementRequest(){
    
        //Get Bankstmt Api from Custom setting
        acfBank_Statement_Credential__c objBankstmtCredential = acfBank_Statement_Credential__c.getValues('Credential');   
        strEndpoint = objBankstmtCredential.acfEndPoint_Url__c;
        strApiKey = objBankstmtCredential.acfX_API_KEY__c;
    }
    
    //Method to initiate the statement process
    public pagereference initiate(string bankname, list<String> lstUserCredentials, list<string> lstUserQuearyType, boolean isTest, string parentid, string selectedAccounts)
    {
       return statementRequest(loginRequest(bankname, lstUserCredentials,lstUserQuearyType, isTest), parentid, isTest, selectedAccounts,bankname);
    
    }
    
    //Method is used to login and fetch user token from bank statement
    public acResponse.bankSatementResponseSuccessorFailure loginRequest(String bank_Slug_Nmme, list<String> lstUserCredentials, list<string> lstUserQuearyType,Boolean istest)
    {
        acResponse.bankSatementResponseSuccessorFailure return_Ref = new acResponse.bankSatementResponseSuccessorFailure(Null,false,Null);
        
        String response;
        String strBody = '{"credentials": {"institution": "'+bank_Slug_Nmme+'"';
        for(integer i=0;i<lstUserQuearyType.size();i++){
            strBody = strBody+',"'+lstUserQuearyType[i]+'": "'+lstUserCredentials[i]+'"';
        }
        strBody = strBody+'}}';
        System.debug('@@@@ body -'+strBody);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/login');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept-Language', 'en-US,en;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip,deflate,sdch');
        req.setHeader('Accept', '*/*');
        req.setHeader('X-API-KEY',strApiKey);
        req.setbody(strBody);
        Http http = new Http();
        String Statuscode;
        String responseFromHttp;
        
        if(isTest == false)
        {
            try
            {
                HTTPResponse res = http.send(req);
                Statuscode = String.valueOf(res.getStatusCode());
                responseFromHttp = res.getBody();
                
                if(Statuscode == '200')
                {
                    
                    return new acResponse.bankSatementResponseSuccessorFailure(bankStatementResponse.parse(responseFromHttp),true,'Successful Hit.');
                }else
                {
                    return new acResponse.bankSatementResponseSuccessorFailure(Null,false,'Unsuccessful Hit. Response from server is :'+responseFromHttp + 'Request is -:'+req);
                }                    
            }
            catch(Exception e)
            {
                response = e.getMessage();
                system.debug('!@#$%error'+e.getMessage());
                return new acResponse.bankSatementResponseSuccessorFailure(Null,false,response);
            }
        }
        else
        {
            Statuscode = '200';
            response = 'Test Mode';
            return new acResponse.bankSatementResponseSuccessorFailure(Null,true,response);
        }                                
        
        return return_Ref;                
    }
    
    //Method to initiate statemnt and Fetch file methods to set account number to fetch statement from
    public pagereference statementRequest(acResponse.bankSatementResponseSuccessorFailure objtoProcess, Id parentId, boolean isTest, string selectedAccounts ,string bankname)
    {
        String user_Token ;
        String AccountId = '';
        
        if(objtoProcess.success == true)
        {
            user_Token = objtoProcess.response.user_token;
         
            System.debug('$$$$$#### - ' + user_Token);
            string ReqDocId = '';
            if(parentId <> null)
            {
                system.debug('parentId**************'+parentId);
                //if lead not converted
                list<Lead> lstLead = [select id, IsConverted, ConvertedOpportunityId from Lead where id =:parentId];
                if(lstLead != null && lstLead.size() > 0)
                {
                        list<Lead> lstLeadTemp = [select id, 
                                                    (select id, acfStatus__c from Required_Documents__r where acf_Bank_Statement_Doc__c = true)
                                                    from Lead where id =:parentId];
                        system.debug('lstLeadTemp **************'+lstLeadTemp);
                        if(lstLeadTemp != null && lstLeadTemp.size() > 0)
                        {
                            if(lstLeadTemp[0].Required_Documents__r != null && lstLeadTemp[0].Required_Documents__r.size() > 0)
                            {
                                ReqDocId = string.valueOf(lstLeadTemp[0].Required_Documents__r[0].id);
                              
                            }
                        }
                }
                else
                {
                     //for multiple applicants
                    String ReqDocids = apexpages.currentpage().getparameters().get('Docid');
                    if(ReqDocids != null && ReqDocids <> '')
                    {
                        ReqDocId = ReqDocids;
                    }
                    else
                    {
                        list<Opportunity> lstOpportunity = [select Id , 
                                                                (select id from Required_Documents__r where acf_Bank_Statement_Doc__c = true)
                                                                from Opportunity where Id =: parentId];
                            system.debug('lstOpportunity**************'+lstOpportunity);
                            if(lstOpportunity != null && lstOpportunity.size() > 0)
                            {
                               if(lstOpportunity[0].Required_Documents__r != null && lstOpportunity[0].Required_Documents__r.size() > 0)
                               {
                                    ReqDocId = string.valueOf(lstOpportunity[0].Required_Documents__r[0].id);
                                    
                               }
                            }
                     }
                }
                
            }
            populate(user_Token, selectedAccounts,bankname,ReqDocId);
        }       
        return null;   
    }
    //Method to call statemnt method to set account number to fetch statement from
    public void populate(string user_Token, string selectedAccounts, string bankname,string ReqDocId)
    {
         acfFetchBankStatementFile.BankStatementFetchFile(user_Token,selectedAccounts,bankname,strEndpoint,strApiKey,ReqDocId);   
    }
    //To get bank credentials
    public Institution FetchInstitutionDetails(String strBankName,String PagePrefixOfCommunitySetUp)
    {
        //fetch the login details from custom settings
        acfBank_Statement_Credential__c objBankStatement = acfBank_Statement_Credential__c.getValues(PagePrefixOfCommunitySetUp+'Credential');
        
        //create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/institutions');
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('X-API-KEY', strApiKey);
        
        //getting Response     
        Http http = new Http();
        HTTPResponse objresponse = http.send(req); 
        system.debug('objresponse?????' + objresponse.getBody()); 
               
        //Parse entire JSON response.
        String strJsonResponse = objresponse.getBody().replace('"values":""','"values":{"one":1,"two":2,"three":3,"four":4}');  
        strJsonResponse = strJsonResponse.replace('"values":{"1":1,"2":2,"3":3,"4":4}','"values":{"one":1,"two":2,"three":3,"four":4}');    
            
        system.debug('objresponse2222' + strJsonResponse); 
        JSONParser parser = JSON.createParser(strJsonResponse);
        
        List<Institution> lstInstitutions = new List<Institution>();
        
        while (parser.nextToken() != null) 
        {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) 
            {
                while (parser.nextToken() != null) 
                {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
                    {
                        Institution inv = (Institution)parser.readValueAs(Institution.class);
                        system.debug('NRAC::::INV:::'+inv);
                        lstInstitutions.add(inv);
                        
                        if(inv.slug == strBankName)
                            return inv;
                    }
                }
            }
        }
        
        system.debug('NRAC::::::'+lstInstitutions.size()+':::'+lstInstitutions);
        
        return null;
    }
    //for captcha type questions
    public String PreloadFetchCaptcha(String strBankName)
    {     
        //create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/preload?institution='+strBankName);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/xml');
        req.setHeader('X-API-KEY', strApiKey);
        
        //getting Response     
        Http http = new Http();
        HTTPResponse objresponse = http.send(req); 
        system.debug('objresponse?????' + objresponse.getBody()); 
        
        Dom.Document doc = objresponse.getBodyDocument();
        
        //Retrieve the root element for this document.
        Dom.XMLNode objParent = doc.getRootElement();
        
        System.debug('NRAC:::objParent::'+objParent);
        
        // Alternatively, loop through the child elements.
        // This prints out all the elements of the address
        for(Dom.XMLNode objInstitute : objParent.getChildElements()) 
        {
            System.debug('objInstitute:::::'+objInstitute);
            for(Dom.XMLNode objInstituteProp : objInstitute.getChildElements())
            {
                System.debug('objInstituteProp:::::'+objInstituteProp);             
            }
            
            Dom.XMLNode objCredentials = objInstitute.getChildElement('credentials', null);
            
            if(objCredentials != null)
            {
            
                system.debug('NRAC:::CRED::'+objCredentials.getName());
                
                for(Dom.XMLNode objCredential : objCredentials.getChildElements())
                {
                    system.debug('objCredential:::'+objCredential.getname());
                     for(Dom.XMLNode objCaptcha : objCredential.getChildElements())
                     {
                          system.debug('objCaptcha :::'+objCaptcha.getName());
                          If(objCaptcha.getName() == 'src'){
                            system.debug('objCaptchaImg :::'+objCaptcha.getText());
                            String strCaptchaUrl = objCaptcha.getText();
                            return strCaptchaUrl;
                          }
                     }
                }
            }
        }
        
        return null;
    }
}