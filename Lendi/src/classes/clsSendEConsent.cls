global class clsSendEConsent
 {
 
   webservice static void SendEonsent(String EconsentID)
   {

            if(EconsentID != null && EconsentID != '')
            {
                List<Required_Document__c> lstReqDoc = [Select EconsentID__C , Type__c ,Bankid__c ,Id,Click_Applicant__c,
                Click_Applicant__r.clickOpportunity__r.Community_Setup__c,
                acfStatus__c From Required_Document__c where EconsentID__C =:EconsentID];
                
                if(!lstReqDoc.isEmpty() && lstReqDoc[0].Click_Applicant__r.clickOpportunity__r.Community_Setup__c  != null)
                {

                    if(lstReqDoc[0].Bankid__C != null   &&   lstReqDoc[0].Type__c != 'General'   ){

                        List<acf_Bank_Template__c>  lstBank = [Select Id ,Body__c ,Click_Loans_Bank_Detail__c from acf_Bank_Template__c

                        where Click_Loans_Bank_Detail__c = :   lstReqDoc[0].Bankid__C  ] ;

                        if(  lstReqDoc != null  && lstBank.size() > 0  && lstReqDoc[0].EconsentID__C != null  )
                        SendEmail(lstBank[0].ID ,lstReqDoc[0].Click_Applicant__c  , lstReqDoc[0].Id  ,lstReqDoc[0].EconsentID__C   , lstReqDoc[0].Click_Applicant__r.clickOpportunity__r.Community_Setup__c  ); 

                    }
                    else{
                        If(lstReqDoc[0].Type__c == 'General'   && lstReqDoc[0].Click_Applicant__c  != null  
                        && lstReqDoc[0].Click_Applicant__r.clickOpportunity__r.Community_Setup__c != null ){
                        sendEconsentEmailSMS(lstReqDoc[0].Click_Applicant__c  ,  lstReqDoc[0].Click_Applicant__r.clickOpportunity__r.Community_Setup__c);
                        }
                    }
                }
            } 
     }   
        
   
   
    global static  void SendEmail(ID BankId  , Id applicantId   , ID reqDocID , ID econID  ,ID  objCommunityID)
   {
    
                List<Click_Community_Setup__c> objCommunity = [Select  Name ,Click_URL__c , Click_Page_Prefix__c  from   Click_Community_Setup__c where id = : objCommunityID ];
                list<click_Applicant__c> lstApplicants = [select id,acf_Applicant_Name__c,click_Account__c,
                click_Applicant_Number__c,Applicant_Phone__c,Applicant_Email__c from click_Applicant__c where id=:applicantId];
                try
                {
                    if(lstApplicants != null && !lstApplicants.isEmpty()  && objCommunity.size() > 0 )
                    {
                        List<EmailTemplate> templateId =new List<EmailTemplate>();  
                        templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'ProductEConsent' AND isActive=true];
                        for(click_Applicant__c app:lstApplicants ){
                             system.debug('### Entered Mail Method1');
                              system.debug('### Entered Mail Method1'+app.Applicant_Email__c);
                            string econsentId='';
                            string encodedDate=string.valueOf(System.currentTimeMillis());
                            econsentId=encodedDate+'-'+applicantId+'-'+BankId+'-'+reqDocID+'-'+econID;
                                         
                            
                            Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');                    
                            Blob data1 = Blob.valueOf(econsentId);
                            Blob encryptedValue  =Crypto.encryptWithManagedIV('AES128', cryptoKey, data1);
                            string Encryptdata=EncodingUtil.base64encode(encryptedValue);
                            string finalData= EncodingUtil.urlEncode(Encryptdata, 'UTF-8');
                            string body='';                            
                            body=templateId[0].HtmlValue;
                            body=body.replace('{!econsentid}',finalData);  
                            body = body.replace('{!Site.Label}',objCommunity[0].Name); 
                            body = body.replace('baseurl',objCommunity[0].Click_URL__c);
                            body=body.replace('{!Account.Name}',app.acf_Applicant_Name__c);
                            system.debug('###body'+body);
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            String[] toaddress=new List<String>();
                            toaddress.add(app.Applicant_Email__c); 
                            system.debug('###'+toaddress);                   
                            mail.setToAddresses(toaddress);
                            mail.setSubject(templateId[0].Subject);
                            mail.setHtmlBody(body);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                            string mobileMessage = '';
                           if(objCommunity[0].Click_Page_Prefix__c == 'ACF'){
                             mobileMessage=Label.Applicant_Econsent_Message_Acf_for_product; 
                            }
                            else 
                            {
                                mobileMessage=Label.Applicant_E_consent_message_for_product;
                            } 
                            mobileMessage=mobileMessage.replace('{!econsentid}',finalData);             
                            mobileMessage=mobileMessage.replace('{!Account.Name}',app.acf_Applicant_Name__c);  
                           
                            System.debug('___________mobileMessage_____________'+mobileMessage);                            
                          acfCommon.SendSMSUsingFutureEconsent(app.acf_Applicant_Name__c,app.Applicant_Phone__c,mobileMessage ,true,objCommunity[0].Click_Page_Prefix__c);
                        }
                       
                    }
                   
                }
                catch(Exception Ex)
                      {
                          
                      } 
                
              
                     
       
   }
   
    global   Static  void sendEconsentEmailSMS(Id applicantId , ID  objCommunityID)
   {
    
            List<Click_Community_Setup__c> objCommunity = [Select  Name ,Click_URL__c , Click_Page_Prefix__c  from   
            Click_Community_Setup__c where id = : objCommunityID ];
            
               
           list<click_Applicant__c> lstApplicants = [select id,acf_Applicant_Name__c,click_Account__c,click_Applicant_Number__c,Applicant_Phone__c,Applicant_Email__c from 
            click_Applicant__c where id=:applicantId];
                try
                {
                    if(lstApplicants != null && !lstApplicants.isEmpty() &&  objCommunity != null  && objCommunity.size() > 0 )
                    {
                        List<EmailTemplate> templateId =new List<EmailTemplate>();  
                        templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'GenericEConsent' AND isActive=true];
                        for(click_Applicant__c app:lstApplicants ){
                             system.debug('### Entered Mail Method1');
                              system.debug('### Entered Mail Method1'+app.Applicant_Email__c);
                            string econsentId='';
                            string encodedDate=string.valueOf(System.currentTimeMillis());
                            econsentId=encodedDate+'-'+app.click_Account__c+'-'+app.click_Applicant_Number__c;
                                         
                            
                            Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');                    
                            Blob data1 = Blob.valueOf(econsentId);
                            Blob encryptedValue  =Crypto.encryptWithManagedIV('AES128', cryptoKey, data1);
                            string Encryptdata=EncodingUtil.base64encode(encryptedValue);
                            string finalData= EncodingUtil.urlEncode(Encryptdata, 'UTF-8');
                            string body='';                            
                            body=templateId[0].HtmlValue;
                            body=body.replace('{!econsentid}',finalData);  
                            body = body.replace('{!Site.Label}',objCommunity[0].Name); 
                            body = body.replace('baseurl',objCommunity[0].Click_URL__c);
                            body=body.replace('{!Account.Name}',app.acf_Applicant_Name__c);
                            system.debug('###body'+body);
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            String[] toaddress=new List<String>();
                            toaddress.add(app.Applicant_Email__c); 
                            system.debug('###'+toaddress);                   
                            mail.setToAddresses(toaddress);
                            mail.setSubject(templateId[0].Subject);
                            mail.setHtmlBody(body);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                            string mobileMessage = '';
                           if(objCommunity[0].Click_Page_Prefix__c == 'ACF'){
                             mobileMessage=Label.Applicant_Econsent_Message_ACF; 
                            }
                            else 
                            {
                                mobileMessage=Label.Applicant_E_consent_message;
                            } 
                            mobileMessage=mobileMessage.replace('{!econsentid}',finalData);             
                            mobileMessage=mobileMessage.replace('{!Account.Name}',app.acf_Applicant_Name__c);              
                            acfCommon.SendSMSUsingFutureEconsent(app.acf_Applicant_Name__c,app.Applicant_Phone__c,mobileMessage,true,objCommunity[0].Click_Page_Prefix__c);
                        }
                       
                    }
                    
                }catch(Exception Ex)
                      {
                          
                      }       
            }  
   }