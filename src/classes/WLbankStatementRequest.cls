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
       /* if(String.isBlank(String.valueof(bank_Slug_Nmme)))
        {
            response = 'Bank Slug Name is Mandatory.';          
            return new acResponse.bankSatementResponseSuccessorFailure(Null,false,response);
        }
        
        if(String.isBlank(String.valueof(username)))
        {
            response = 'User Name is Mandatory.';
            return new acResponse.bankSatementResponseSuccessorFailure(Null,false,response);
        }
        
        if(String.isBlank(String.valueof(password)))
        {
            response = 'Password is Mandatory.';
            return new acResponse.bankSatementResponseSuccessorFailure(Null,false,response);
        }*/
        String strBody = '{"credentials": {"institution": "'+bank_Slug_Nmme+'"';
        for(integer i=0;i<lstUserQuearyType.size();i++){
            strBody = strBody+',"'+lstUserQuearyType[i]+'": "'+lstUserCredentials[i]+'"';
        }
        strBody = strBody+'}}';
        //String body = '{"credentials": {"institution": "'+bank_Slug_Nmme+'","username": "'+username+'","password": "'+password+'"}}';
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
         
            populate(user_Token, selectedAccounts,bankname);
            FetchFile(user_Token, parentId);
        }
        
        return null;   
    }
    
    //Method to call statemnt method to set account number to fetch statement from
    public void populate(string user_Token, string selectedAccounts, string bankname)
    {
        String body = '{"user_token":"'+user_Token+'","accounts":{"'+bankname+'":['+selectedAccounts+']}}';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/statements');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('X-API-KEY',strApiKey);
        req.setbody(body);
        req.setTimeout(100000);
        
        System.debug('!!!!Statement Body -'+body);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String Statuscode = String.valueOf(res.getStatusCode());
        String response = res.getBody();
        
        System.debug('!!!! XML Response - '+response);
    }
    
    //Method to fetch file from bank statement and save it in salesforce
    public void FetchFile(string user_Token, string strLeadId)
    {
        //fetch the login details from custom settings
       // acfBank_Statement_Credential__c objBankStatement = acfBank_Statement_Credential__c.getValues('Credential');
         
        //create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/files?X-API-KEY='+strApiKey+'&user_token='+ user_Token);
        req.setMethod('GET');
        
        //getting Response     
        Http http = new Http();
        HTTPResponse objresponse = http.send(req); 
        system.debug('objresponse?????' + objresponse.getBody()); 
        
        Blob objBlob = objresponse.getBodyAsBlob();
        
        system.debug('status???' + objresponse.getBodyAsBlob());
        try{
        if(strLeadId != null && strLeadId != '')
        {
            list<Lead> lstLead = [select id, IsConverted, ConvertedOpportunityId from Lead where id =:strLeadId];
            
            if(lstLead != null && lstLead.size() > 0)
            {
                if(lstLead[0].IsConverted == true)
                {
                    list<Opportunity> lstOpportunity = [select Id , 
                                                        (select id from Required_Documents__r where acf_Bank_Statement_Doc__c = true)
                                                        from Opportunity where Id =: lstLead[0].ConvertedOpportunityId];
                    
                    if(lstOpportunity != null && lstOpportunity.size() > 0)
                    {
                       if(lstOpportunity[0].Required_Documents__r != null && lstOpportunity[0].Required_Documents__r.size() > 0)
                       {
                            Attachment attach = new Attachment();
                            attach.Body = objBlob;
                            attach.Name = 'Bankstatement.zip';
                            attach.ContentType = 'application/zip';
                            attach.ParentID = lstOpportunity[0].Required_Documents__r[0].id;
                            insert attach;                                        
                       }     
                    }
                }
                else
                {
                    list<Lead> lstLeadTemp = [select id, 
                                                (select id, acfStatus__c from Required_Documents__r where acf_Bank_Statement_Doc__c = true)
                                                from Lead where id =:strLeadId];
                    
                    if(lstLeadTemp != null && lstLeadTemp.size() > 0)
                    {
                        if(lstLeadTemp[0].Required_Documents__r != null && lstLeadTemp[0].Required_Documents__r.size() > 0)
                        {
                            Attachment attach = new Attachment();
                            attach.Body = objBlob;
                            attach.Name = 'Bankstatement.zip';
                            attach.ContentType = 'application/zip';
                            attach.ParentID = lstLeadTemp[0].Required_Documents__r[0].id;
                            insert attach; 
                            system.debug('@@@@Att'+attach);   
                            lstLeadTemp[0].Required_Documents__r[0].acfStatus__c = 'Uploaded'; 
                            update lstLeadTemp[0].Required_Documents__r[0];                              
                        }
                         //For Updating Task
                         list<task> lstTask = [select id,subject,status,acf_Is_Upload_Bank_Stmt__c from task where acf_Is_Upload_Bank_Stmt__c= true limit 1];
                         if(lstTask != null && lstTask.size()>0)
                         {
                            lstTask[0].status = 'Completed';
                            update lstTask[0];
                         }   
                    }                        
                }
            }
        }
        }catch(Exception ex){
            system.debug('Exception@@'+ex);
        }
    }
    
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
        
        //institution institutions = (institution)JSON.deserialize(objresponse.getBody(), institution.class);
        //system.debug('NRAC::::'+institutions);
        
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

    public String PreloadFetchCaptcha(String strBankName)
    {
        //fetch the login details from custom settings
      //  acfBank_Statement_Credential__c objBankStatement = acfBank_Statement_Credential__c.getValues('Credential');
        
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
        
        //institution institutions = (institution)JSON.deserialize(objresponse.getBody(), institution.class);
        //system.debug('NRAC::::'+institutions);
                
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
               // Dom.XMLNode objCredentials = objCredentials.getChildElement('credentials', null);
            }
        }
        
        return null;
    }
}