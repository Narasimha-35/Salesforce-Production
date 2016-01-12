global class ClickEnablePortalUserFromCRM 
{ 
   webservice static string createPortalUserFromCRM(string strLeadFName,string strLeadLName,string strLeadEmail,string strPhone,string strLeadId)
   {
      if(IsValidUserName(strLeadEmail))
      {
       //Creating Person Account
        Id currentAccountRecordTypeId = acfcommon.GetRecordTypeId('Account','Click Refi');
        Account objPersonAccount      = new Account();
        objPersonAccount.FirstName    = strLeadFName; 
        objPersonAccount.LastName     = strLeadLName;
        objPersonAccount.PersonMobilePhone        = strPhone;
        objPersonAccount.PersonEmail  = strLeadEmail;
        objPersonAccount.acf_Lead__pc = strLeadId;
        objPersonAccount.RecordTypeId = currentAccountRecordTypeId;  
        objPersonAccount.Lead_Type__pc = 'Click Refi';  
        insert objPersonAccount;
        //List To get Person Account Contact.
        List<Account>lstPersonContact = [select id,PersonContactId from Account where id=:objPersonAccount.Id];
        if(lstPersonContact <> null && lstPersonContact.size()>0)
        {
            List<Profile> lstCommUserProfile = [select id,name from profile where name='Community User' limit 1];
            User objUser = new User();
            objUser.FirstName = strLeadFName;
            objUser.LastName = strLeadLName;
            objUser.Alias  = (strLeadLName+String.valueof(Math.random())).substring(0,5);
            objUser.LocaleSidKey = 'en_AU';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.MobilePhone = strPhone;
            objUser.Username = strLeadEmail;
            objUser.Email = strLeadEmail;
            objUser.ProfileId = lstCommUserProfile[0].id;
            objUser.ContactId = lstPersonContact[0].PersonContactId;
            objuser.EmailEncodingKey = 'UTF-8';
            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
            objUser.TimeZoneSidKey = 'Australia/Brisbane';
            objUser.acfIs_Password_Reset__c = true;
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            objUser.setOptions(dlo);
            insert(objUser);
            //system.setPassword(objUser.id, 'testpassword1');
            //Updating Account and Contact in Lead.
            Lead objLead = new Lead(id=strLeadId);
            objLead.acf_Contact__c = lstPersonContact[0].PersonContactId;
            objLead.acf_partner_account__c = objPersonAccount.id;
            update objLead;
            acfCustomerRegisterController.generateReqDocs(strLeadId);
            return 'Portal user created.';
        }
      }
      else
      {
         return 'Email already Exist, Please use different one.';   
      }  
      return '';   
   }
   public static boolean IsValidUserName(string struseEmail)
   {
        List<User>lstUser = [select id,Name from user where UserName=:struseEmail];
        if(lstUser <> null && lstUser.size()>0)
        {
            return false;
        }
        return true;
   }
   
   webservice static string createPortalUserFromCRMWithAccount(id AccId,string strLeadFName,string strLeadLName,string strLeadEmail,string strPhone,string strLeadId)
    {
        if(IsValidUserName(strLeadEmail))
        {
           
            //List To get Person Account Contact.
            List<Account>lstPersonContact = [select id,PersonContactId from Account where id=:AccId];
            if(lstPersonContact <> null && lstPersonContact.size()>0)
            {
                List<Profile> lstCommUserProfile = [select id,name from profile where name='Community User' limit 1];
                User objUser = new User();
                objUser.FirstName = strLeadFName;
                objUser.LastName = strLeadLName;
                //objuser.username='testuser';
                //objuser.email='testmail@gmail.com';
                objUser.Alias  = (strLeadLName+String.valueof(Math.random())).substring(0,5);
                objUser.LocaleSidKey = 'en_AU';
                objUser.LanguageLocaleKey = 'en_US';
                objUser.MobilePhone = strPhone;
                objUser.Username = strLeadEmail;
                objUser.Email = strLeadEmail;
                objUser.ProfileId = lstCommUserProfile[0].id;
                objUser.ContactId = lstPersonContact[0].PersonContactId;
                objuser.EmailEncodingKey = 'UTF-8';
                objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
                objUser.TimeZoneSidKey = 'Australia/Brisbane';
                objUser.acfIs_Password_Reset__c = true;
                Database.DMLOptions dlo = new Database.DMLOptions();
                dlo.EmailHeader.triggerUserEmail = false;
                objUser.setOptions(dlo);
                insert(objUser);
                //system.setPassword(objUser.id, 'testpassword1');
                //Updating Account and Contact in Lead.
                Lead objLead = new Lead(id=strLeadId);
                objLead.acf_Contact__c = lstPersonContact[0].PersonContactId;
                objLead.acf_partner_account__c = AccId;
                update objLead;
                acfCustomerRegisterController.generateReqDocs(strLeadId);
                
                //Code to display suggested products.
                List<Question__c> lstQuestions = [select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                acfBubble_Text__c,(select id,acf_Answer__c from Answer__r),acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c                                                            
                                                from Question__c where (acf_Script__r.acf_Type__c='Pre-Login' and acf_Active__c = true AND (acf_Type__c ='picklist' or acf_Type__c ='Checkbox' or acf_Type__c ='button' or acf_Type__c ='Radiobutton'))];

                Set<String> setOfQuesApiNames = new Set<String>();
                List<Answer__c> lstAnswer = new List<Answer__c>();
                if(lstQuestions != null && lstQuestions.size()>0)
                {
                    for(Question__c objQues :lstQuestions)
                    {
                        setOfQuesApiNames.add(objQues.acf_ApiName__c);
                        
                        for(Answer__c objAns:objQues.Answer__r)
                        {
                            lstAnswer.add(objAns);
                        }
                    }
                }
                String strleadQues='';
                if(setOfQuesApiNames != null && setOfQuesApiNames.size()>0)
                {
                    for(String strApiname : setOfQuesApiNames)
                    {
                        strleadQues = strleadQues+strApiname+',';
                    }
                }
                if(strleadQues != null && strleadQues <> '')
                {
                    String strQueryOnObj = 'select '+strleadQues+'id from Lead where id = \'' + strLeadId + '\'';
                    SObject[] lstDependentObj = Database.query(strQueryOnObj);
                    Set<String> setOfAnswers = new Set<String>(); 
                    if(lstDependentObj != null && lstDependentObj.size()>0)
                    {
                        for(SObject objDependentObj : lstDependentObj)
                        {
                            for(String strApiName : setOfQuesApiNames)
                            {
                                If(strApiName <> '' && objDependentObj.get(strApiName) <> null)
                                {  
                                    setOfAnswers.add(string.valueof(objDependentObj.get(strApiName))); 
                                }
                            }   
                        }
                    }
                    Set<String> setSelectedAnsIds = new Set<String>();
                    if(lstAnswer != null && lstAnswer.size()>0)
                    {
                        for(Answer__c objAns : lstAnswer)
                        {
                            if(setOfAnswers.contains(objAns.acf_Answer__c))
                            {
                                setSelectedAnsIds.add(objAns.id);
                            }
                        }
                    }
                    system.debug('@@karthik'+setSelectedAnsIds);                   
                    acfCommon.getSuggestedProductsFromAnswers(strLeadId,setSelectedAnsIds);
                    
                    acfCommon.getRequiredDocumentsFromAnswers(strLeadId,setSelectedAnsIds);  
                 }                                                            
                    return 'Portal user created.';
               }
            }
            else
            {
                return 'Email already Exist, Please use different one.';   
            }  
            return '';   
        }
}