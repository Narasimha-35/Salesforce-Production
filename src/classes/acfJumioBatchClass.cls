global class acfJumioBatchClass implements Database.Batchable<sobject>, Database.AllowsCallouts{

    global string id;
    
    global acfJumioBatchClass(){    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string objRequiredDocument = 'select id,Lead__c,Lead__r.isConverted,acfOpportunity__c,acfStatus__c,acf_Reference_No__c,Click_Date_of_Birth__c,click_Expiry_Date__c,Click_First_Name__c,Click_ID_Number__c,click_ID_Type__c,Click_Is_Identity_Document_Rejected__c,Click_Issuing_Country__c,Click_Jumio_Response__c,Click_Last_Name__c,Click_Reason_for_Rejection__c from Required_Document__c where acfStatus__c = \''+ 'Awaited'+'\' and acf_Reference_No__c <> null and acfDocument_Master__r.acf_Source__c = \''+ 'Jumio'+'\'';
        system.debug('start method ------------- '+objRequiredDocument);
        return Database.getQueryLocator(objRequiredDocument);
    }

    global void execute(Database.BatchableContext BC, List<Required_Document__c> scope){
        system.debug('execute method ------------- '+scope);
        //system.debug('@@KC::scope'+scope.size());
        //lead leadObj;     // = new lead();
        list<lead> lst_lead = new list<lead>();
        List<opportunity>lstOppToUpdate = new List<Opportunity>();
        list<Attachment> lst_attach = new list<Attachment>();
        List<Required_Document__c>lstRequiredDoc = new List<Required_Document__c>();
        for(Required_Document__c objRequiredDocument : scope)
        {
             system.debug('@@#$%^'+objRequiredDocument.Lead__r.isConverted);
            
            Jumio_Credentials__c objJumioCredential = Jumio_Credentials__c.getValues('Credential');       

            String strUserName = objJumioCredential.Merchant_API_token__c;
            String strPassword = objJumioCredential.Active_API_secret__c;    
            String strEndPoint = objJumioCredential.EndPoint__c;
            
            strEndPoint = strEndPoint.removeEnd('initiateNetverify');
            
            String strAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(strUserName + ':' + strPassword));
            
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(strEndPoint + 'scans/' + objRequiredDocument.acf_Reference_No__c);
            req.setHeader('Authorization', strAuthorizationHeader);
            req.setHeader('Accept', 'application/json');             
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
            
            Http http = new Http();
            String jsonResponseBody; 
            if(!test.isRunningTest())
            {
              HTTPResponse jsonResponse = http.send(req);
              jsonResponseBody = jsonResponse.getBody();
            }
            else
            {
              jsonResponseBody = '{"timestamp":"2015-05-27T10:58:28.245Z","scanReference":"0e9b9f48-5dbc-4cf1-a05a-8c8358c170ee","status":"Pending"}';
            }  
             
            system.debug('jsonResponseBody-------------------'+jsonResponseBody);
            acf_netverifyResponse_StatusCheck status_check = new acf_netverifyResponse_StatusCheck(); 
            status_check = acf_netverifyResponse_StatusCheck.parse(jsonResponseBody);
            system.debug('status_check---------------- '+status_check);
            
            if(status_check.status == 'DONE'){
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                request.setEndpoint(strEndPoint + 'scans/' + objRequiredDocument.acf_Reference_No__c + '/data');
                
                request.setHeader('Authorization', strAuthorizationHeader);
                request.setHeader('Accept', 'application/json');             
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
                
                Http http_obj = new Http();
                String jsonResponse_Body;
              HTTPResponse json_Response = http_obj.send(request);
              jsonResponse_Body = json_Response.getBody();
                system.debug('jsonResponseBody1-------------------'+jsonResponseBody);
                jsonResponse_Body = jsonResponse_Body.replace('"type":','"type_response":');
                jsonResponse_Body = jsonResponse_Body.replace('"number":','"number_response":');
                jsonResponse_Body = jsonResponse_Body.replace('"date":','"date_response":');
                jsonResponse_Body = jsonResponse_Body.replace('"transaction":','"transaction_response":');
                
                if(jsonResponse_Body.contains('"expiry":'))
                {
                    system.debug('expiry-----------');
                    acf_netverifyResponse_passport passport_verify = new acf_netverifyResponse_passport();
                    passport_verify = acf_netverifyResponse_passport.parse(jsonResponse_Body);
                    
                    //Added changes on 25-01-2016 to move jumio response to required documents
                    objRequiredDocument.Click_First_Name__c = passport_verify.document.firstname;
                    objRequiredDocument.Click_Last_Name__c = passport_verify.document.lastName;
                    objRequiredDocument.Click_ID_Number__c = passport_verify.document.number_response;
                    objRequiredDocument.click_ID_Type__c = passport_verify.document.type_response;
                    objRequiredDocument.Click_Date_of_Birth__c = passport_verify.document.dob;
                    objRequiredDocument.Click_Issuing_Country__c = passport_verify.document.issuingCountry;
                    objRequiredDocument.Click_Jumio_Response__c = passport_verify.document.status;
                    objRequiredDocument.click_Expiry_Date__c = passport_verify.document.expiry;
                    
                    /*
                    if(objRequiredDocument.Lead__r.isConverted == false)
                    {
                        
                        lead leadObj = new lead();
                        leadObj.acfJumioFirstName__c = passport_verify.document.firstname;
                        leadObj.acfJumioLastName__c = passport_verify.document.lastName;
                        leadObj.acfJumioIDNumber__c = passport_verify.document.number_response;
                        leadObj.acfJumioIDType__c = passport_verify.document.type_response;
                        leadObj.acfJumioDateOfBirth__c = passport_verify.document.dob;
                        leadObj.acfJumioIssuingCountry__c = passport_verify.document.issuingCountry;
                        leadObj.acfJumioStatus__c = passport_verify.document.status;
                        leadObj.acfJumioExpiryDate__c = passport_verify.document.expiry;
                        leadObj.id = objRequiredDocument.Lead__c;
                       
                        lst_lead.add(leadObj);
                    }
                    else if(objRequiredDocument.acfOpportunity__c <> null)
                    {
                        opportunity objOpportunity          = new Opportunity(id = objRequiredDocument.acfOpportunity__c);
                        objOpportunity.clickJumioLast_Name__c = passport_verify.document.lastName;
                        objOpportunity.clickJumioFirstName__c = passport_verify.document.firstname;
                        objOpportunity.acfID_Type__c        = passport_verify.document.type_response;
                        objOpportunity.acfID_Number__c      = passport_verify.document.number_response;
                        objOpportunity.acfExpiry_Date__c    = passport_verify.document.expiry;
                        objOpportunity.acfDate_of_Birth__c  = passport_verify.document.dob;
                        objOpportunity.acfIssuing_Country__c= passport_verify.document.issuingCountry;
                        objOpportunity.acfStatus__c         = passport_verify.document.status;
                        
                        lstOppToUpdate.add(objOpportunity);
                    }   
                    */
                    
                    // ================ image ========================
                    HttpRequest req_img_front = new HttpRequest();
                    req_img_front.setMethod('GET');
                    req_img_front.setEndpoint(strEndPoint + 'scans/' + objRequiredDocument.acf_Reference_No__c + '/images/front');
                    
                    req_img_front.setHeader('Authorization', strAuthorizationHeader);
                    req_img_front.setHeader('Accept', 'image/jpeg');             
                    req_img_front.setHeader('Content-Type', 'application/json');
                    req_img_front.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
                    
                  
                      Http http_img_front = new Http();
                      HTTPResponse img_front_Response = http_img_front.send(req_img_front);
                      blob imgFrontResponse = img_front_Response.getBodyAsBlob(); 
                      system.debug('imgFrontResponse-----------------'+imgFrontResponse);
                      
                      if(img_front_Response.getStatus() == 'OK')
                      {
                          system.debug('expiry front image ok ----');
                          Attachment attach_front_img = new Attachment();
                          attach_front_img.body = imgFrontResponse;
                          attach_front_img.name = 'front.jpeg';
                          attach_front_img.ParentId = objRequiredDocument.id;
                          lst_attach.add(attach_front_img);                           
                      }
                    HttpRequest req_img_back = new HttpRequest();
                    req_img_back.setMethod('GET');
                    req_img_back.setEndpoint(strEndPoint + 'scans/' + objRequiredDocument.acf_Reference_No__c + '/images/back');
                    
                    req_img_back.setHeader('Authorization', strAuthorizationHeader);
                    req_img_back.setHeader('Accept', 'image/jpeg');             
                    req_img_back.setHeader('Content-Type', 'application/json');
                    req_img_back.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
                    
                      Http http_img_back = new Http();
                      HTTPResponse img_back_Response = http_img_back.send(req_img_back);
                      blob imgBackResponse = img_back_Response.getBodyAsBlob(); 
                      system.debug('imgBackResponse-----------------'+imgBackResponse);
                      
                      if(img_back_Response.getStatus() == 'OK')
                      {
                          system.debug('expiry back image ok-----------');
                          Attachment attach_back_img = new Attachment();
                          attach_back_img.body = imgBackResponse;
                          attach_back_img.name = 'back.jpeg';
                          attach_back_img.ParentId = objRequiredDocument.id;
                          lst_attach.add(attach_back_img);
                      }
                      if(passport_verify.document.status == 'APPROVED_VERIFIED')
                      {
                        objRequiredDocument.acfStatus__c = 'Verified';
                      }else{
                        objRequiredDocument.acfStatus__c = 'Not Verified';
                      }
                    
                }else
                {                    
                    system.debug('expiry not-----------');
                    acf_netverifyResponse_verificationData verification_data = new acf_netverifyResponse_verificationData();
                    verification_data = acf_netverifyResponse_verificationData.parse(jsonResponse_Body);
                    //Added changes on 25-01-2016
                    objRequiredDocument.Click_First_Name__c = verification_data.document.firstname;
                    objRequiredDocument.Click_Last_Name__c = verification_data.document.lastName;
                    objRequiredDocument.Click_ID_Number__c = verification_data.document.number_response;
                    objRequiredDocument.click_ID_Type__c = verification_data.document.type_response;
                    objRequiredDocument.Click_Date_of_Birth__c = verification_data.document.dob;
                    objRequiredDocument.Click_Issuing_Country__c = verification_data.document.issuingCountry;
                    objRequiredDocument.Click_Jumio_Response__c = verification_data.document.status;
                    if(verification_data.document.address != null)
                    {
                        objRequiredDocument.Click_Jumio_Address__c = verification_data.document.address.streetNumber+' '
                                                                    +verification_data.document.address.streetSuffix+' '
                                                                    +verification_data.document.address.streetName+' '
                                                                    +verification_data.document.address.city+' '
                                                                    +verification_data.document.address.stateCode+' '
                                                                    +verification_data.document.address.country+' '
                                                                    +verification_data.document.address.zip;
                    }
                    
                    if(verification_data.document.status != 'APPROVED_VERIFIED')
                    {
                        objRequiredDocument.Click_Is_Identity_Document_Rejected__c = true;
                        objRequiredDocument.Click_Reason_for_Rejection__c= verification_data.document.status;
                    }
                    /*
                    if(objRequiredDocument.Lead__r.isConverted == false)
                    {
                        lead leadObj = new lead();
                        leadObj.acfJumioFirstName__c = verification_data.document.firstname;
                        leadObj.acfJumioLastName__c = verification_data.document.lastName;
                        leadObj.acfJumioIDNumber__c = verification_data.document.number_response;
                        leadObj.acfJumioIDType__c = verification_data.document.type_response;
                        leadObj.acfJumioDateOfBirth__c = verification_data.document.dob;
                        leadObj.acfJumioIssuingCountry__c = verification_data.document.issuingCountry;
                        leadObj.acfJumioStatus__c = verification_data.document.status;
                        if(verification_data.document.status != 'APPROVED_VERIFIED')
                        {
                       // leadObj.acfIs_Identity_Document_Submitted__c = false;
                        leadObj.acfIs_Identity_Document_Rejected__c = true;
                        leadObj.acfReason_for_Rejection__c = verification_data.document.status;
                        }else{
                          //leadObj.acfIs_Identity_Document_Submitted__c = true;
                        }
                        leadObj.id = objRequiredDocument.Lead__c;
                        lst_lead.add(leadObj);
                    }
                    else if(objRequiredDocument.acfOpportunity__c <> null)
                    {
                        opportunity objOpportunity          = new Opportunity(id = objRequiredDocument.acfOpportunity__c);
                        objOpportunity.acfID_Type__c        = verification_data.document.type_response;
                        objOpportunity.acfID_Number__c      = verification_data.document.number_response;
                        //objOpportunity.acfExpiry_Date__c  = verification_data.document.expiry;
                        objOpportunity.acfDate_of_Birth__c  = verification_data.document.dob;
                        objOpportunity.acfIssuing_Country__c= verification_data.document.issuingCountry;
                        objOpportunity.acfStatus__c         = verification_data.document.status;
                        objOpportunity.clickJumioLast_Name__c = verification_data.document.lastName;
                        objOpportunity.clickJumioFirstName__c = verification_data.document.firstname;
                        if(verification_data.document.status != 'APPROVED_VERIFIED')
                        {                        
                        //  objOpportunity.acfIs_Identity_Document_Submitted__c = false;
                          objOpportunity.acfIs_Identity_Document_Rejected__c = true;
                          objOpportunity.acfReason_for_Rejection__c = verification_data.document.status;
                        }else{
                          //objOpportunity.acfIs_Identity_Document_Submitted__c = true;
                        }
                        lstOppToUpdate.add(objOpportunity);                       
                    } 
                */
                    // ============= Images =========================
                    HttpRequest req_img_front = new HttpRequest();
                    req_img_front.setMethod('GET');
                    req_img_front.setEndpoint(strEndPoint + 'scans/' + objRequiredDocument.acf_Reference_No__c + '/images/front');
                    
                    req_img_front.setHeader('Authorization', strAuthorizationHeader);
                    req_img_front.setHeader('Accept', 'image/jpeg');             
                    req_img_front.setHeader('Content-Type', 'application/json');
                    req_img_front.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
                    
                    Http http_img_front = new Http();
                    HTTPResponse img_front_Response = http_img_front.send(req_img_front);
                    blob imgFrontResponse = img_front_Response.getBodyAsBlob(); 
                    
                    if(img_front_Response.getStatus() == 'OK'){
                        system.debug('expiry not front img ok--------------');
                        Attachment attach_front_img = new Attachment();
                        attach_front_img.body = imgFrontResponse;
                        attach_front_img.name = 'front.jpeg';
                        attach_front_img.ParentId = objRequiredDocument.id;
                        lst_attach.add(attach_front_img);
                    }
                    
                    HttpRequest req_img_back = new HttpRequest();
                    req_img_back.setMethod('GET');
                    req_img_back.setEndpoint(strEndPoint + 'scans/' + objRequiredDocument.acf_Reference_No__c + '/images/back');
                    
                    req_img_back.setHeader('Authorization', strAuthorizationHeader);
                    req_img_back.setHeader('Accept', 'image/jpeg');             
                    req_img_back.setHeader('Content-Type', 'application/json');
                    req_img_back.setHeader('User-Agent', 'SaasFocus Saas/1.9.0');
                    
                    Http http_img_back = new Http();
                    HTTPResponse img_back_Response = http_img_back.send(req_img_back);
                    blob imgBackResponse_Body = img_back_Response.getBodyAsBlob(); 
                    
                    if(img_back_Response.getStatus() == 'OK'){
                        system.debug('expiry not back image ok-------------------------');
                        Attachment attach_back_img = new Attachment();
                        attach_back_img.body = imgBackResponse_Body;
                        attach_back_img.name = 'back.jpeg';
                        attach_back_img.ParentId = objRequiredDocument.id;
                        lst_attach.add(attach_back_img);
                    }
                    if(verification_data.document.status == 'APPROVED_VERIFIED')
                  {
                    objRequiredDocument.acfStatus__c = 'Verified';
                  }else{
                    objRequiredDocument.acfStatus__c = 'Not Verified';
                  } 
                }
            }else {                                // Added by karthik
                  
                 objRequiredDocument.Click_Jumio_Response__c = status_check.status;
                 objRequiredDocument.Click_Is_Identity_Document_Rejected__c = true;
                 objRequiredDocument.Click_Reason_for_Rejection__c = 'Not verified by Jumio';
                 /* if(objRequiredDocument.Lead__r.isConverted == false)
                  {                               
                    lead leadObj = new lead();
                    leadObj.id = objRequiredDocument.Lead__c;
                   // leadObj.acfIs_Identity_Document_Submitted__c = false;
                    leadObj.acfIs_Identity_Document_Rejected__c = true;
                    leadObj.acfReason_for_Rejection__c = 'Not verified by Jumio';
                    leadObj.acfJumioStatus__c = status_check.status;
                    lst_lead.add(leadObj);   
                  }
                  else if(objRequiredDocument.acfOpportunity__c <> null)
                    {
                        opportunity objOpportunity = new Opportunity(id = objRequiredDocument.acfOpportunity__c);
                       // objOpportunity.acfIs_Identity_Document_Submitted__c = false;
                        objOpportunity.acfIs_Identity_Document_Rejected__c = true;
                        objOpportunity.acfReason_for_Rejection__c = 'Not verified by Jumio';
                        objOpportunity.acfStatus__c = status_check.status;
                        lstOppToUpdate.add(objOpportunity);
                    }*/
                    if(status_check.status == 'PENDING'){
                      objRequiredDocument.acfStatus__c = 'Pending';
                    }else{
                      objRequiredDocument.acfStatus__c = 'Not Verified';
                    }
                }
           lstRequiredDoc.add(objRequiredDocument);     
        }
        insert lst_attach;
        system.debug('@@Karthik::'+lst_attach.size());
        update lstRequiredDoc;
       // update lst_lead;
        /*if(lstOppToUpdate != null && lstOppToUpdate.size()>0)
          update lstOppToUpdate;
        */
    }
    
    global void finish(Database.BatchableContext BC){
   
    }

}