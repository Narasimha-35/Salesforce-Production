public class ClickCommon
{
    /*
    //this method is created by deepak dhingra
    //this method is used to sendsms using smsApi
    // this method takes the 
        a)Recepients Name 
        b)Recepients Number 
        c)message as input parameters 
        d) a boolean parameter that specifies whether or not we are
    //running it in test mode
    // send istest true if you want to send sms else if pass false
    // returns the response from webservive
    */
    public static boolean IsStopRecursion = true;
    
    public static string URLPrefix 
    {
        get
        {
           string strRetURL = '/';
         /*  if(Network.getNetworkId() != null)
           {
               Click_Community_Setup__c objComm = ClickCommon.getCommunitySetup(Network.getNetworkId());
               if(objComm != null && objComm.Click_Site_Prefix__c <> null)
               {
                   strRetURL = strRetURL+objComm.Click_Site_Prefix__c+'/';
               }
           } */              
           return strRetURL;
        }
        set;
    }
    
    
    public static string sendSMS(String recepientName, String recepientNumber, String message, Boolean isTest)
    {
        String response;
        if(recepientName == Null || recepientName.trim() == '')
        {
            response = 'Recepient Name should not be null or blank';
            return response;
        }
        if(recepientNumber == Null || recepientNumber.trim() == '')
        {
            response = 'Recepient Number should not be null or blank';
            return response;
        }
        if(message == Null || message.trim() == '')
        {
            response = 'Message should not be null or blank';
            return response;
        }
        try
        {
            List<smagicinteract__smsmagic__c> smsObjectList;
            smsObjectList = new List <smagicinteract__smsmagic__c>();
            
         //  Click_Community_Setup__c objComm = ClickCommon.getCommunitySetup(Network.getNetworkId());   
        //    Sms_Magic__c objSetting = Sms_Magic__c.getValues('senderId');   
       Sms_Magic__c objSetting = Sms_Magic__c.getValues(getCommunitySetup(Network.getNetworkId()).Click_Page_Prefix__c+' senderId');
       system.debug('objSetting-------------' +objSetting);
            if(objSetting == Null)
            {
                response = 'Sender ID not found in custom settings.';
                return response;
            }
            String senderId = objSetting.senderId__c;
            String templateText = message;
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = senderId;
            smsObject.smagicinteract__PhoneNumber__c = recepientNumber;
            smsObject.smagicinteract__Name__c = recepientName; // records name
            smsObject.smagicinteract__ObjectType__c = 'Mobile'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 1; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            smsObject.smagicinteract__SMSText__c = templateText;
            smsObjectList.add(smsObject);
            if(isTest == true)
            {
               DescribeSObjectResult result = Schema.getGlobalDescribe().get('smagicinteract__smsMagic__c').getDescribe();
                System.debug('Object Accessible:'+result.isAccessible());
                System.debug('Object Createable:'+result.isCreateable());
                System.debug('Object Updateable:'+result.isUpdateable());
                System.debug('Object Deleteable:'+result.isDeletable());

                for (Schema.Sobjectfield obj : result.fields.getMap().values()) {
                Schema.DescribeFieldResult fldResult = obj.getDescribe();
                System.debug('Field Name:'+fldResult.getLabel()+';\tField Accessible:'+fldResult.isAccessible()+';\tField Createable:'+fldResult.isCreateable()+';\tField Updateable:'+fldResult.isUpdateable());
                }
               response = smagicinteract.ApexAPI.pushSMSCallout(smsObjectList);
            }else
            {
                response = 'Testing mode' ;
                // 'Testing mode.'
            }
            System.debug('@@@@response ->'+ response);
           // response = 'success';
            insert smsObjectList;
            System.debug('!!!! smsObjectList -'+smsObjectList);
            return response;
        }catch(Exception e)
        {
            response = 'Exception occurred :1.Message is -'+e.getMessage() +'2.Stack trace is -'+e.getStackTraceString();
            return response;
        }        
        return response;
    }
    
    @future (callout=true)
    public static void SendSMSUsingFuture(String recepientName, String recepientNumber, String message, Boolean isTest)
    {
        String response;
        
        if(recepientName == Null || recepientName.trim() == '')
        {
            return;
        }
        if(recepientNumber == Null || recepientNumber.trim() == '')
        {
            return;
        }
        if(message == Null || message.trim() == '')
        {
            return;
        }
        
        try
        {
            List<smagicinteract__smsmagic__c> smsObjectList;
            smsObjectList = new List <smagicinteract__smsmagic__c>();
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('senderId');
            
            if(objSetting == Null)
            {
                return ;
            }
            
            String senderId = objSetting.senderId__c;
            String templateText = message;
            
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = senderId;
            smsObject.smagicinteract__PhoneNumber__c = recepientNumber;
            smsObject.smagicinteract__Name__c = recepientName; // records name
            smsObject.smagicinteract__ObjectType__c = 'Mobile'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            smsObject.smagicinteract__SMSText__c = templateText;//+'*TestOTPIssue*';
            smsObjectList.add(smsObject);
            
            if(isTest == true)
            {
                system.debug('@@@@mobile'+recepientName);
                system.debug('@@@@mobile'+recepientNumber);
                response = smagicinteract.ApexAPI.pushSMSCallout(smsObjectList);
                System.debug('NRAC::response ->'+ response);
            }
        }
        catch(Exception e)
        {
            response = 'Exception occurred :1.Message is -'+e.getMessage() +'2.Stack trace is -'+e.getStackTraceString();
            system.debug('@@Exception'+e);
        }        
    }
    
    
    /*
    * 
    * This method is responsible for checking any string i.e empty or null 
    */
    public static boolean isNullOrEmpty(string str)
    {
        if(str != null && str.trim() != '')
            return false;
        else
            return true;        
    }
    
    /*
    ** This method is used to check the email with mail id as a parameters. 
    **
    */    
    public static boolean checkEmail(String strEmail)
    {
        return true;
        
       /* String status;
        try{   
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            String emailKey = System.Label.acfEmailVerifyKey;
            system.debug('@@@email testing'+emailKey);
            String str = 'http://emailverifyapi.com:80/api/a/v1?key='+emailKey+'&email='+strEmail;
            system.debug('@@Email Checker'+str);
            req.setEndpoint(str);
            req.setMethod('GET');
            req.setTimeOut(60000);
            res = http.send(req); 
            
            //filtering the status from res.getBody()
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'status') {
                        status = parser.getText();
                    } 
                }
            }
            
            if(status == 'Ok' || status == 'unknown')            
                return true;
            else
                return false; 
                   
        }catch(Exception e){
            return false;
        }
*/
    }
    
    // -------------------------------------------------------------------------------------------
    // This method used to Send Mail
    // -------------------------------------------------------------------------------------------
    // Input - list<SObject>
    // Output - void
    // Version#    Date            Author             Description
    // -------------------------------------------------------------------------------------------
    // 1.0         1/22/2014       Lokesh Pant            Initial Version
    // -------------------------------------------------------------------------------------------
    public static void sendTemplatedEmail(ID targetObjId , string strContent, string strSubject,List<string> lstToEmail,List<string> lstCcEmail)
    {
        //try 
        //{
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            if(targetObjId <> null)
                email.setTargetObjectId(targetObjId);
            if(lstToEmail <> null && lstToEmail.size()>0)
                email.setToAddresses(lstToEmail);
            if(lstCcEmail <> null && lstCcEmail.size()>0)   
                email.setCcAddresses(lstCcEmail);   
            email.setSubject(strSubject);
            email.setSenderDisplayName('ACF');
            email.setPlainTextBody(strContent);
            email.setHtmlBody(strContent);
            email.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        //}
        //catch (Exception e) 
        //{
       // }
    }
    
    
    public static boolean IsNullOrEmptyString(string strInput)
    {
        if(strInput == null || strInput.equals('')){
            return true;
        }
        return false;
    }
    
    public static map<string,string> getLeadApiNameToAnswerMap(string strAnswers)
    {
       map<string,string> mapLeadApiToAnswer = new map<string,string>();
       if(strAnswers <> null && strAnswers <> '')
       {
           for(string objLeadAnswers:strAnswers.split('-,-'))
           {
              List<string>lstLeadApiToAnswer = objLeadAnswers.split('-:-');
              if(lstLeadApiToAnswer.size()>=2) 
                mapLeadApiToAnswer.put(lstLeadApiToAnswer[0],lstLeadApiToAnswer[1]); 
           }
           return mapLeadApiToAnswer;
       }
       return null;    
    }
    public static map<string,string>getLeadApiNameToType(string strAnswers)
    {
       Click_Community_Setup__c objCommSetup = getCommunitySetup(Network.getNetworkId());
       if(objCommSetup != null)
       {
           List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c,Click_Community_Setup__c from Script__c where acf_Type__c=:'Pre-Login' AND Click_Community_Setup__c =: objCommSetup.Id order by acf_Sequence_no__c limit 1]; 
           if(lstScript != null && lstScript.size()>0)
           {
               map<string,string> mapLeadApiToType = new map<string,string>();
               set<string>setLeadApiNames = new set<string>();
               if(strAnswers <> null && strAnswers <> '')
               {
                   for(string objLeadApiName:strAnswers.split('-:-'))
                   {
                        setLeadApiNames.add(objLeadApiName);
                   }
                   if(setLeadApiNames <> null && setLeadApiNames.size()>0)
                   {
                        for(Question__c objQuestion : [select id,acf_ApiName__c,acf_Type__c,acf_Script__c from Question__c 
                                                        where acf_ApiName__c in:setLeadApiNames AND acf_Script__c =:lstScript[0].id])
                        {
                            mapLeadApiToType.put(objQuestion.acf_ApiName__c,objQuestion.acf_Type__c);
                        }
                   }
                   return mapLeadApiToType;
               }
           }
       }
       return null; 
    }
    
    /*
    //this method is created by pawan mudgal
    // this method takes the a)current logged in user id
    // returns the url to which user is to be redirected after resetting password
    */
    public static string sendReturnUrl(String userId,Boolean isSkip,String pgname,string strNetworkId)
    {   
        
        Map<string,acfStepsSequence__c> Map_postloginSequence  = acfStepsSequence__c.getall();
        Map<integer,string> map_pg = new Map<integer,string>();
        for(string strName:Map_postloginSequence.keyset())
        {
            acfStepsSequence__c pgInstance = acfStepsSequence__c.getvalues(strName);
            //if(pgInstance.Click_Community_Setup_Network_id__c == strNetworkId)
            map_pg.put(Integer.valueof(pgInstance.acfSequence_Number__c),pgInstance.Name);
            system.debug('map_pg*******************'+map_pg);
        }
        
        String strLeadId = '';
        String strOppId = '';
        String strReturnUrl = getCommunitySetup(strNetworkId).Click_Page_Prefix__c+'Dashboard';
        Boolean isError = true;
        
        if(userId != Null && userId != '')
        {
            system.debug('userId *******************'+userId );
            List<User> lstuser = [select Id, ContactId,acfIs_Password_Reset__c ,Contact.acf_Lead__c from User where Id =: userId limit 1];
            system.debug('@@@@user list'+lstuser);
            if(lstuser != Null && lstuser.size() > 0)
            {
                strLeadId = lstuser[0].Contact.acf_Lead__c;
                Opportunity objOpportunity = new Opportunity();               
                strOppId = getCurrentLoggedInOpportunityId(lstuser[0].id,getCommunitySetup(strNetworkId).Click_Page_Prefix__c);
                system.debug('@@@Karthik:::'+strLeadId);
                If(strOppId != null && strOppId != ''){
                    List<Opportunity> lstOpp = [select id,acfIs_Identity_Document_Rejected__c,acfIs_Identity_Document_Submitted__c from Opportunity where id =: strOppId];
                    If(lstOpp != null && lstOpp.size()>0){
                       objOpportunity =  lstOpp[0];
                    }
                }
                if(strLeadId != Null && strLeadId != '')
                {
                    List<Lead> lstLead = [select Id, acfIs_Bank_Statement_Submitted__c,RecordType.DeveloperName ,acfIs_Post_Login_Ques_Attempted__c, acfIs_Identity_Document_Submitted__c,isConverted from Lead where Id =: strLeadId limit 1];
                    
                    if(lstLead != Null && lstLead.size() > 0)
                    {
                       Lead objLead = lstLead[0];
                       system.debug('lead@@@'+lstLead[0]);
                       system.debug('map@@@'+map_pg);
                      If(!isSkip)
                      {
                          //integer index = 1;
                          //for(Integer sn:map_pg.keyset())
                          for(integer sn=1;sn<=map_pg.size();sn++)
                          {
                            system.debug('Seq##'+sn);
                            if(objLead.isConverted == false && !objLead.acfIs_Identity_Document_Submitted__c && map_pg.get(sn)== 'clickid_verification')
                            {   
                                isError = false; 
                                strReturnUrl = getCommunitySetup(strNetworkId).Click_Page_Prefix__c+'id_verification';
                                break;
                            }
                            else
                            {   
                                system.debug('bank'+objLead.acfIs_Bank_Statement_Submitted__c);
                                system.debug('pagevalidation@@@@@'+map_pg.get(sn));
                                system.debug('pagevalidation@@@@@'+map_pg.get(sn)== 'ClickBankInfoDetails');
                                if(objLead.isConverted == false && !objLead.acfIs_Bank_Statement_Submitted__c && map_pg.get(sn)== 'ClickBankInfoDetails')
                                {
                                     isError = false;
                                     system.debug('@@@@Karthik'+strReturnUrl);
                                     strReturnUrl = getCommunitySetup(strNetworkId).Click_Page_Prefix__c+'BankInfoDetails'; 
                                     break;

                                }
                                else
                                {
                                 system.debug('postlogin @@'+objLead.acfIs_Post_Login_Ques_Attempted__c);
                                 system.debug('pagevalidation@@@@@'+map_pg.get(sn));
                                    if(!objLead.acfIs_Post_Login_Ques_Attempted__c && map_pg.get(sn)== 'ClickPostloginQuestionnaires')
                                    {
                                        isError = false;
                                        strReturnUrl = getCommunitySetup(strNetworkId).Click_Page_Prefix__c+'PostloginQuestionnaires';  
                                        break;     
                                    }
                                    else
                                    { 
                                            isError = false;
                                            strReturnUrl = getCommunitySetup(strNetworkId).Click_Page_Prefix__c+'Dashboard';                                            
                                    }
                                }
                              }         
                          } 
                       }                 
                    }
                } 
            } 
        }
        if(isError)
        {
            return('error');
        }
        else
        {
          return(URLPrefix+strReturnUrl);
        }
    }
    //
    public static Id getCurrentLoggedInContactId(Id CurrentUserId)
    {
        List<User>lstUser = [select id , contactId from User where id=:CurrentUserId];
        system.debug('====lstUser===='+lstUser);
        if(lstUser.size()>0)
        {
            return lstUser[0].ContactId;
        }
        return null;
    }
    
    public static Id getCurrentLoggedInLeadId(Id CurrentUserId)
    {
        List<user>lstUser = [select id,username,Name,contactId,accountId,contact.acf_lead__c,Email,firstName,lastName,MobilePhone from user where id=:CurrentUserId];
        system.debug('====lstUser with Lead ID===='+lstUser);
        if(lstUser.size()>0)
        {
            return lstUser[0].contact.acf_lead__c;
        }
        return null;
    }
    //====================================================================
    //     Name             createdDate               Version
    //====================================================================
    //    Ankit Singh       23-05-2016                 1.0
    //====================================================================
    // This method is used to getConverted Opportunity Id for customerUser.
    //=====================================================================
    public static Id getConvertedOpportunityId(Id CurrentUserId)
    {
        List<user>lstUser = [select id,username,Name,contactId,accountId,contact.acf_lead__c,Email,firstName,lastName,MobilePhone from user where id=:CurrentUserId];
        system.debug('====lstUser with Lead ID===='+lstUser);
        if(lstUser.isEmpty() == false && lstUser[0].contact.acf_lead__c <> null)
        {
            List<Lead> lstLead = [select id,isconverted,convertedOpportunityid from Lead where id=:lstUser[0].contact.acf_lead__c];
            if(!lstLead.isEmpty() && lstLead[0].isConverted && lstLead[0].convertedOpportunityid != null)
                return lstLead[0].convertedOpportunityid;
        }
        return null;
    }
    
    public static Id getCurrentLoggedInOpportunityId(Id CurrentUserId,string PrefixVal)
    {
        List<Opportunity> List_opp = new List<Opportunity>();
        List<User>lstUser = [select id , ContactId, AccountId from User where id=:CurrentUserId];
     //   string strNetworkId = Network.getNetWorkId();
       // system.debug('strNetworkId%%%%%%%%'+strNetworkId);
        Click_Community_Setup__c objCommunity = getCommunitySetup(Network.getNetWorkId());
        system.debug('objCommunity%%%%%%%%'+objCommunity);
        string strNewLoanType = objCommunity.Click_Page_Prefix__c+' New Loans';
        string strRefiType = objCommunity.Click_Page_Prefix__c+' Refi';
        List_opp = [select id,Recordtype.Name from opportunity where accountId=:lstUser[0].AccountId AND (Recordtype.Name=:strNewLoanType OR Recordtype.Name=:strRefiType)];
        system.debug('List_opp%%%%%%%%'+List_opp);
        If(!List_opp.isEmpty())
        {
            system.debug('##########################');
            return List_opp[0].Id;
        }
        return null;
    }
    //Method to Find Required Documents Based on the Answer Selected.
    // for CRM User
    public static void getRequiredDocumentsFromAnswers(Id LeadId,set<string> setSelectedAnswer)
    {
        system.debug('@@#$$%');
       List<Required_Document__c>lstRequiredDocumentToInsert = new List<Required_Document__c>();  
       system.debug('@@@@@@@@@@@@@@@@@'+setSelectedAnswer);  
       if(setSelectedAnswer <> null && setSelectedAnswer.size()>0)
       {
            for(Dependent_Document__c objDependentDocument:[select id,acfAnswer__c,acfDocument_Master__c,acfActive__c ,name
                                                            from Dependent_Document__c where acfAnswer__c in:setSelectedAnswer and acfActive__c = true])
            {
                   Required_Document__c objRequiredDocument  =  new Required_Document__c();
                   objRequiredDocument.Name                  =  objDependentDocument.Name;
                   objRequiredDocument.acfDocument_Master__c =  objDependentDocument.acfDocument_Master__c;
                   objRequiredDocument.Lead__c               =  LeadId;
                   objRequiredDocument.acfStatus__c          =  'Pending';
                   lstRequiredDocumentToInsert.add(objRequiredDocument);       
            }
            system.debug(':::::'+lstRequiredDocumentToInsert);
            if(lstRequiredDocumentToInsert <> null && lstRequiredDocumentToInsert.size()>0)
            {
                insert lstRequiredDocumentToInsert;
            }                                           
       }     
    }
    
     //Method to Find Required Documents Based on the Answer Selected.
    public static void getRequiredDocumentsFromAnswersFromCRM(Id LeadId,set<string> setSelectedAnswer,Id CommunitySetupId)
    {
        system.debug('@@#$$%'+CommunitySetupId);
       List<Required_Document__c>lstRequiredDocumentToInsert = new List<Required_Document__c>();    
       if(setSelectedAnswer <> null && setSelectedAnswer.size()>0 && CommunitySetupId <> null)
       {
       
           Set<String> st = new Set<String>();
            for(Dependent_Document__c objDependentDocument:[select id,acfAnswer__c,acfDocument_Master__c,acfDocument_Master__r.Click_Community_Setup__c,
                                                            acfActive__c,name
                                                            from Dependent_Document__c where acfAnswer__c in:setSelectedAnswer and acfActive__c = true
                                                            and acfDocument_Master__r.Click_Community_Setup__c =:CommunitySetupId])
            {
                   if(!st.contains(objDependentDocument.Name)){
                       system.debug('@@#$$%Ankit'+objDependentDocument);
                       Required_Document__c objRequiredDocument  =  new Required_Document__c();
                       objRequiredDocument.Name                  =  objDependentDocument.Name;
                       objRequiredDocument.acfDocument_Master__c =  objDependentDocument.acfDocument_Master__c;
                       objRequiredDocument.Lead__c               =  LeadId;
                       objRequiredDocument.acfStatus__c          =  'Pending';
                       lstRequiredDocumentToInsert.add(objRequiredDocument);       
                       st.add(objDependentDocument.Name);
                   }
            }
            system.debug(':::::'+lstRequiredDocumentToInsert);
            if(lstRequiredDocumentToInsert <> null && lstRequiredDocumentToInsert.size()>0)
            {
                insert lstRequiredDocumentToInsert;
            }                                           
       }     
    }
    
    public static Click_Community_Setup__c getCommunitySetup(string NetworkId)
    {
       Click_Community_Setup__c CommSetup = new Click_Community_Setup__c();
       if(!test.isrunningTest())
       {
            if(NetworkId != null)
            {
                NetworkId = NetworkId.substring(0, 15);
                list<Click_Community_Setup__c> lstCommSetup = [select id,Click_Site_Prefix__c,Click_Network_ID__c,Click_URL__c,Community_User_Name_Prefix__c,Click_IsActive__c,Click_Page_Prefix__c,Click_Support_Team_Name__c,click_Home_Page_URL__c from Click_Community_Setup__c where Click_Network_ID__c = : NetworkId  AND Click_IsActive__c = true limit 1];
                if(lstCommSetup!=null && lstCommSetup.size()>0)
                {
                    CommSetup = lstCommSetup[0];
                }
            }
        }
        else
        {
            list<Click_Community_Setup__c> lstCommSetup = [select id,Click_Network_ID__c,Click_URL__c,Community_User_Name_Prefix__c,Click_IsActive__c,Click_Page_Prefix__c,Click_Support_Team_Name__c,click_Home_Page_URL__c from Click_Community_Setup__c where Click_IsActive__c = true limit 1];
            if(lstCommSetup!=null && lstCommSetup.size()>0){
            CommSetup = lstCommSetup[0];
            }
        }
        return CommSetup;
    }
    
    //Method to Find Suggested Products based on the Answer Selected.
    public static void getSuggestedProductsFromAnswers(Id LeadId,set<string> setSelectedAnswer,string strCommSetupId)
    {
        system.debug('Sumit LeadId :: '+LeadId);
        system.debug('Sumit setSelectedAnswer :: '+setSelectedAnswer);
        // changes done by Ankit for Adding bank functionality
        set<id> setOfBankDetailId = new set<id>();
        List<Click_Loans_Bank__c> lstbank = new List<Click_Loans_Bank__c>();
        if(strCommSetupId <> null)
        {
            lstbank = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:strCommSetupId];
        }
        if(lstbank.size() > 0 && lstbank != null)
        {
            for(Click_Loans_Bank__c objbank : lstbank)
            {
                    setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
            }
        }
        List<acfSuggested_Product__c>lstSuggestedDocumentToInsert = new List<acfSuggested_Product__c>();    
       if(setSelectedAnswer <> null && setSelectedAnswer.size()>0 && setOfBankDetailId <> null && setOfBankDetailId.size() > 0)
       {
            list<acfDependent_Product__c> lstDependentProducts = [select id,acfAnswer__c,acfFilter__c,acfProduct__c,acfProduct_Family__c 
                                                                    from acfDependent_Product__c 
                                                                    where acfAnswer__c in :setSelectedAnswer 
                                                                    and  acfProduct__r.Click_Loans_Bank_Detail__c IN : setOfBankDetailId];
            
            system.debug('Sumit lstDependentProducts :::: ' + lstDependentProducts );
            
            for(acfDependent_Product__c objDependentProd :lstDependentProducts)
            {
                acfSuggested_Product__c objSuggestedProd = new acfSuggested_Product__c();
                objSuggestedProd.acfFilter__c   =  objDependentProd.acfFilter__c;
                objSuggestedProd.acfLead__c     =  LeadId; 
                objSuggestedProd.acfProduct__c  =  objDependentProd.acfProduct__c;
                lstSuggestedDocumentToInsert.add(objSuggestedProd);
            }
            system.debug('Sumit lstSuggestedDocumentToInsert ::: '+lstSuggestedDocumentToInsert);
            if(lstSuggestedDocumentToInsert <> null && lstSuggestedDocumentToInsert.size()>0)
                insert lstSuggestedDocumentToInsert;
       }     
    }
    //For Record Type
    public static id GetRecordTypeId(string objectAPIName, string recordTypeName){
        system.debug('====Record Type Name====='+recordTypeName);
        Map<String, Schema.SObjectType> sobjectSchemaMap;
        if(IsNullOrEmptyString(objectAPIName) || IsNullOrEmptyString(recordTypeName)){
            return null;
        }
        if(sobjectSchemaMap == null)
        {
            sobjectSchemaMap = Schema.getGlobalDescribe();
        }
        Schema.SObjectType sObjType = sobjectSchemaMap.get(objectAPIName) ;
        
        Schema.DescribeSObjectResult cfrSchema = sObjType.getDescribe() ;
        
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id recordTypeId = RecordTypeInfo.get(recordTypeName).getRecordTypeId();
        return recordTypeId;
    }
    //For valid Decimal. 
    public static boolean IsValidDecimal(decimal decValue)
    {
        try
        {
            decimal decimalValue = decValue;
            return true;
        }
        catch(Exception Ex)
        {
            return false;
        }
    }
     //Calculating EMI
    public static double calculateMonthlyPayment(decimal loanAmount,double decRate,string strPaymentType,double decTenure)
    {
        try{
            if(decRate !=0){
                decRate   = decRate/1200;//here 1200 is 12*100.
                decTenure = decTenure*12;
                if(strPaymentType == 'Interest Only') 
                    return (Math.Round((loanAmount)*(decRate)));
                else if(strPaymentType == 'Principal and Interest')
                {    
                  return (Math.Round((loanAmount)*((decRate*(Math.pow((1+decRate),decTenure)))/((Math.pow((1+decRate),decTenure))-1))));
                }
                return null;
            }
        }

        catch(Exception ex){
            System.debug('ErrorMessage'+ex.getMessage());
        }
        return null; 
    }
    
    //user redirect method
     public static string redirect(string currentUserId,string pagename,string strNetworkId)
     {
       String oppId = getConvertedOpportunityId(currentUserId); 
       string loggedInLeadId = getCurrentLoggedInLeadId(currentUserId);
       system.debug('loggedInLeadId*******'+loggedInLeadId +oppId );
       string retURL = '';
       Click_Community_Setup__c objCommunity = getCommunitySetup(strNetworkId);
       
       pagename = pagename.tolowercase();
       list<opportunity> lstOpp = new list<opportunity>();

       if(oppId != null && oppId <> '')
       {
           string strNewLoanType = objCommunity.Click_Page_Prefix__c+' New Loans';
           string strRefiType = objCommunity.Click_Page_Prefix__c+' Refi';
           lstOpp = [select id,clickJumio_Status__c,acfBankdetailStatus__c,RecordType.Name from opportunity where id=:oppId AND (RecordType.Name =: strNewLoanType OR RecordType.Name =: strRefiType)]; 
       }
            
        if(lstOpp != null && lstOpp.size()>0)  
        {  
            If
            (
                pagename == objCommunity.Click_Page_Prefix__c+'dashboard' || pagename == objCommunity.Click_Page_Prefix__c+'editprofile' || (pagename == objCommunity.Click_Page_Prefix__c+'bankInfodetails' && 
                lstOpp[0].acfBankdetailStatus__c != 'Completed') || ((pagename == objCommunity.Click_Page_Prefix__c+'jumiointegration' || 
                pagename == objCommunity.Click_Page_Prefix__c+'id_verification') && lstOpp[0].clickJumio_Status__c != 'Attempted')
            )
            { 
               retURL = 'false';
            }
            else
            {
               retURL = objCommunity.Click_Page_Prefix__c+'dashboard';
               system.debug('retURL *******'+retURL );   
             }
        }
        else if(loggedInLeadId != null && loggedInLeadId <> '')
        {
            list<lead> lstLead = [select acfIs_Bank_Statement_Submitted__c,acfIs_Post_Login_Ques_Attempted__c,acfIs_Identity_Document_Submitted__c from lead where id=:loggedInLeadId];
            
            if
            (
                ((pagename == objCommunity.Click_Page_Prefix__c+'jumiointegration' ||  pagename == objCommunity.Click_Page_Prefix__c+'id_verification') && lstLead[0].acfIs_Identity_Document_Submitted__c == true) || (pagename == objCommunity.Click_Page_Prefix__c+'bankInfodetails' && lstLead[0].acfIs_Bank_Statement_Submitted__c == true) 
               || (pagename == objCommunity.Click_Page_Prefix__c+'postloginquestionnaires' && lstLead[0].acfIs_Post_Login_Ques_Attempted__c == true) || pagename == objCommunity.Click_Page_Prefix__c+'dashboard' || pagename == objCommunity.Click_Page_Prefix__c+'editprofile')
             {  
               retUrl  = sendReturnUrl(currentUserId,false,'',strNetworkId);
               system.debug('retURL111 *******'+retURL );  
             }
             else retURL = 'false';
        }
         
         return retUrl;
      }   
      
      //to return user input type      
      public static map<string,string> mapUserInputType()
      {
           map<id,user> mapUserIdToUser = new map<id,user>([select Alias,id,profileid,profile.name from user where isActive = true limit 200]);
           map<string,string> mapusrIdToUsrInputType = new map<string,string>();
           string strUsrInputType = '';
           if(mapUserIdToUser != null && mapUserIdToUser.size()>0)
           {
               for(string userId : mapUserIdToUser.keyset())
               {
            
                   if(mapUserIdToUser.get(userId).profile.name.contains('Community User')  || mapUserIdToUser.get(userId).Alias.contains('guest'))
                   {
                        
                        mapusrIdToUsrInputType.put(userId,'Customer Input');
                 
                   }else if(mapUserIdToUser.get(userId).profile.name == 'Customize Partner User')
                           {
                               mapusrIdToUsrInputType.put(userId,'Partner User Input');
                               
                           }else {
                               mapusrIdToUsrInputType.put(userId,'CRM User Input');
                           }
              }

           }
           return mapusrIdToUsrInputType;
      }  
      
      public static map<string,string> mapUserInputType(List<id> createdbyId )
      {
           map<id,user> mapUserIdToUser = new map<id,user>([select Alias,id,profileid,profile.name from user where isActive = true and ID in :createdbyId ]);
           map<string,string> mapusrIdToUsrInputType = new map<string,string>();
           string strUsrInputType = '';
           if(mapUserIdToUser != null && mapUserIdToUser.size()>0)
           {
               for(string userId : mapUserIdToUser.keyset())
               {
            
                   if(mapUserIdToUser.get(userId).profile.name.contains('Community User')  || mapUserIdToUser.get(userId).Alias.contains('guest'))
                   {
                        
                        mapusrIdToUsrInputType.put(userId,'Customer Input');
                 
                   }else if(mapUserIdToUser.get(userId).profile.name == 'Customize Partner User')
                           {
                               mapusrIdToUsrInputType.put(userId,'Partner User Input');
                               
                           }else {
                               mapusrIdToUsrInputType.put(userId,'CRM User Input');
                           }
              }

           }
           return mapusrIdToUsrInputType;
      }
            //to calculate transfer fee
      public static decimal calculateTransferFee(string strState,integer propertyValue)
      {
         list<State__c> lstStates = [select id,acfBase_Transfer_Fee__c,acfState_Short_Name__c,WA_Additional_Fee2__c,WA_Additional_Fee__c,acfEach_Amount__c,
                                     VIC_Max_Additional_Fee_Limit__c,acfQLD_From_value_for_Add_Fee__c,acfAdditional_Transfer_Fee__c from State__c where acfState_Short_Name__c =:strState limit 1];
          decimal decTransferFee = 0;
          decimal intAdditionalFee = 0;
          if(lstStates != null && lstStates.size()>0 && propertyValue <> null)
          {
              State__c objState = lstStates[0];
              decTransferFee = objState.acfBase_Transfer_Fee__c;  
              //QLD-$162.90 + additional fee for lodging a transfer if the consideration is more than $180,000 - $30.80 for each $10,000 or part of $10,000 more than $180,000
              if(strState == 'QLD' && propertyValue > objState.acfQLD_From_value_for_Add_Fee__c && objState.acfEach_Amount__c>0)
              {
                  intAdditionalFee = propertyValue - objState.acfQLD_From_value_for_Add_Fee__c;
                  decTransferFee = decTransferFee + ((math.ceil(intAdditionalFee/objState.acfEach_Amount__c))*(objState.acfAdditional_Transfer_Fee__c));//$30.80 for each $10,000                             
              }                     
              //VIC-$138.90 + $2.46 for every whole $1,000 of the monetary consideration. This fee does not exceed $1,369.
              if(strState == 'VIC' && objState.acfEach_Amount__c>0)
              {
                  intAdditionalFee = (propertyValue/objState.acfEach_Amount__c)*(objState.acfAdditional_Transfer_Fee__c);
                  decTransferFee = decTransferFee+intAdditionalFee;
                  if(decTransferFee > objState.VIC_Max_Additional_Fee_Limit__c)
                  {
                      decTransferFee = objState.VIC_Max_Additional_Fee_Limit__c;
                  }                 
              }
              //WA Transfer Fee $160 for land up to $85,000; $170 for land between $85,001 and $120,000; $190 for land between $120,001 and $200,000 and then $20 for every $100,000 or part thereof.
              if(strState == 'WA')
              {
                  if(propertyValue > 85000 && propertyValue <= 120000)
                  {
                      decTransferFee = objState.WA_Additional_Fee__c;
                  }else if(propertyValue > 120000 && propertyValue <= 200000)
                          {
                              decTransferFee = objState.WA_Additional_Fee2__c;
                          }else if(propertyValue > 200000 && objState.acfEach_Amount__c>0)
                                  {
                                      intAdditionalFee = propertyValue - 200000;
                                      decTransferFee = objState.WA_Additional_Fee2__c+((math.ceil(intAdditionalFee/objState.acfEach_Amount__c))*objState.acfAdditional_Transfer_Fee__c);
                                  }               
              }
              return decTransferFee; 
          } 
          return 0;
      } 
      //to calculate registration fee
      public static decimal getRegistrationFee(string strState)
      {
         if(strState != null && strState <> '')
         {
             list<State__c> lstStates = [select id,acfRegistration_Fee__c from State__c where acfState_Short_Name__c =:strState limit 1];
             if(lstStates != null && lstStates.size()>0)
             {
                 return lstStates[0].acfRegistration_Fee__c;
             }
         }
         return 0;
      }
      //to calculate stamp duty
      public static decimal getStampdutyRate(string strState,integer propertyValue,string strPurpose)
      {
          decimal stampDuty = 0;
          if(strState != null && strState != '' && propertyValue != null && strPurpose!= null && strPurpose != '')
          {
              list<State__c> lstStates = [select id,acfBase_Transfer_Fee__c,acfState_Short_Name__c,(select id,Acf_Purpose__c,Acf_Property_value_from__c,
                           Acf_Property_value_to__c,Acf_Base_Value__c,Acf_Variable_rate__c,acfDivide_Number__c
                           from Stamp_Duty_Table__r where Acf_Purpose__c=:strPurpose AND Acf_Property_value_from__c <=: propertyValue AND
                           Acf_Property_value_to__c >=: propertyValue) from State__c where acfState_Short_Name__c =:strState limit 1];
              if(lstStates != null && lstStates.size()>0 && lstStates[0].Stamp_Duty_Table__r != null && lstStates[0].Stamp_Duty_Table__r.size() > 0)
              {
                  acfStamp_Duty_Table__c objStampDutyTable = lstStates[0].Stamp_Duty_Table__r[0];
                  if(objStampDutyTable.Acf_Base_Value__c <> null && objStampDutyTable.Acf_Variable_rate__c <> null)
                  {
                      if(objStampDutyTable.Acf_Property_value_from__c == 0 && lstStates[0].acfState_Short_Name__c == 'NT') //for NT state
                      {
                          stampDuty = (0.06571441*propertyValue*propertyValue)/1000000 + (15*propertyValue/1000);
                      }else if(objStampDutyTable.acfDivide_Number__c <> null && objStampDutyTable.acfDivide_Number__c <> 0){
                              stampDuty = objStampDutyTable.Acf_Base_Value__c + (objStampDutyTable.Acf_Variable_rate__c * (math.ceil((propertyValue-objStampDutyTable.Acf_Property_value_from__c)/objStampDutyTable.acfDivide_Number__c)));
                           }else {
                                    stampDuty = objStampDutyTable.Acf_Base_Value__c + (objStampDutyTable.Acf_Variable_rate__c * (propertyValue-objStampDutyTable.Acf_Property_value_from__c)/100);
                                }  
                 }               
              }             
          }
          return stampDuty;
       }
       
       //This method is use to send emial notification.
       public static void sendEmailNotification(Set<Id> oppID){
        
            if(oppID != null){
            List<Opportunity> lstOpp = [SELECT  StageName ,CurrentAssignedBroker__r.Email__c ,  CurrentAssignedBroker__r.Channel__c , Account.Recordtypeid  ,(SELECT Applicant_Email__c FROM Applicants__r) FROM Opportunity where id in :oppID ];
            List<String> ccTo = new List<String>();
             List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
             if(lstOpp.size() > 0){
                
                     
                 for(Opportunity oopObj : lstOpp){
                     if(oopObj.StageName == 'Appliaction taken'){
                         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                     for( click_Applicant__c  applicant  : oopObj.Applicants__r){
                                         
                                            
                                            
                                            List<String> sendTo = new List<String>();
                                            if(applicant.Applicant_Email__c != null){
                                            sendTo.add(applicant.Applicant_Email__c);   
                                            }
                                            
                                            mail.setToAddresses(sendTo);
                                            mail.setSenderDisplayName(Userinfo.getusername());
        
                                            
                                           // mail.setCcAddresses(ccTo);
                                            mail.setSubject('Subject');
                                            String body = '';
                                            mail.setHtmlBody(body);
                                            List<Messaging.EmailFileAttachment> efa =  getEmailAttachment( oopObj);
                                            if(efa.size() >0)
                                            mail.setFileAttachments(efa);
                                            
                                        }
                                if(oopObj.CurrentAssignedBroker__r.Email__c != null){
                                      ccTo.add(oopObj.CurrentAssignedBroker__r.Email__c);
                                      mail.setCcAddresses(ccTo);
                                      
                                }   
                                    mails.add(mail);                        
                            }
                    }
                
             }
             
             if(mails.size() > 0){
                 Messaging.sendEmail(mails);
                 
             }
            
            
            }
        
        }    
        // This method is use for getting email's attachment 
       public static List<Messaging.EmailFileAttachment>  getEmailAttachment(Opportunity oopObj){
             List<Messaging.EmailFileAttachment>  mailsAttachments = new List<Messaging.EmailFileAttachment> ();
               /* String Channel =oopObj.CurrentAssignedBroker__r.Channel__c  == null ? '' : oopObj.CurrentAssignedBroker__r.Channel__c ;
                 String AccountRecordtypeid =oopObj.Account.Recordtypeid   == null ? '' : oopObj.Account.Recordtypeid  ;
                string ACFNewLoansId = ClickCommon.GetRecordTypeId('Account','ACF New Loans');
                string ACFRefiId = ClickCommon.GetRecordTypeId('Account','ACF Refi');
                string ClickNewLoansId = ClickCommon.GetRecordTypeId('Account','Click New Loans');
                string ClickRefiId = ClickCommon.GetRecordTypeId('Account','Click Refi');
                 if(Channel == 'Partner'){
                     
                     // 1 attachment
                        PageReference CreditGuidePartner = page.CreditGuidePartner;
                        CreditGuidePartner.getParameters().put('id',(String) oopObj.id);
                        CreditGuidePartner.setRedirect(true);
    
                        Blob CreditGuidePartneObj= CreditGuidePartner.getContent();
                        Messaging.EmailFileAttachment CreditGuidePartnerefa = new Messaging.EmailFileAttachment();
                        CreditGuidePartnerefa.setFileName('CreditGuidePartner.pdf');
                        CreditGuidePartnerefa.setBody(CreditGuidePartneObj);
                        mailsAttachments.add(CreditGuidePartnerefa);
                    // 2nd attachment       
                        PageReference PreliminaryAssesmentPartner = page.PreliminaryAssesmentPartner;
                        PreliminaryAssesmentPartner.getParameters().put('id',(String) oopObj.id);
                        PreliminaryAssesmentPartner.setRedirect(true);
    
                        Blob PreliminaryAssesmentPartnerObj= PreliminaryAssesmentPartner.getContent();
                        Messaging.EmailFileAttachment PreliminaryAssesmentPartnerefa = new Messaging.EmailFileAttachment();
                        PreliminaryAssesmentPartnerefa.setFileName('PreliminaryAssesmentPartner.pdf');
                        PreliminaryAssesmentPartnerefa.setBody(PreliminaryAssesmentPartnerObj);
                        mailsAttachments.add(PreliminaryAssesmentPartnerefa);
                    // 3rd attachment   
                        PageReference CreditProposalDisclosureDocPartner = page.CreditProposalDisclosureDocPartner;
                        CreditProposalDisclosureDocPartner.getParameters().put('id',(String) oopObj.id);
                        CreditProposalDisclosureDocPartner.setRedirect(true);
    
                        Blob CreditProposalDisclosureDocPartnerObj= CreditProposalDisclosureDocPartner.getContent();
                        Messaging.EmailFileAttachment CreditProposalDisclosureDocPartnerObjefa = new Messaging.EmailFileAttachment();
                        CreditProposalDisclosureDocPartnerObjefa.setFileName('CreditProposalDisclosureDocPartner.pdf');
                        CreditProposalDisclosureDocPartnerObjefa.setBody(CreditProposalDisclosureDocPartnerObj);
                        mailsAttachments.add(CreditProposalDisclosureDocPartnerObjefa);
                    
                  }
                  
    
                    if(  (AccountRecordtypeid == ACFNewLoansId  || AccountRecordtypeid == ACFRefiId ) &&  Channel == 'Employee'){
                      // 1 attachment
                        PageReference CreditProposalDisclosureACF = page.CreditProposalDisclosureACF;
                        CreditProposalDisclosureACF.getParameters().put('id',(String) oopObj.id);
                        CreditProposalDisclosureACF.setRedirect(true);
    
                        Blob CreditGuidePartneObj= CreditProposalDisclosureACF.getContent();
                        Messaging.EmailFileAttachment CreditProposalDisclosureACFefa = new Messaging.EmailFileAttachment();
                        CreditProposalDisclosureACFefa.setFileName('CreditProposalDisclosureACF.pdf');
                        CreditProposalDisclosureACFefa.setBody(CreditGuidePartneObj);
                        mailsAttachments.add(CreditProposalDisclosureACFefa);
                    // 2nd attachment       
                        PageReference PreliminaryAssesmentACF = page.PreliminaryAssesmentACF;
                        PreliminaryAssesmentACF.getParameters().put('id',(String) oopObj.id);
                        PreliminaryAssesmentACF.setRedirect(true);
    
                        Blob PreliminaryAssesmentACFObj= PreliminaryAssesmentACF.getContent();
                        Messaging.EmailFileAttachment PreliminaryAssesmentACFefa = new Messaging.EmailFileAttachment();
                        PreliminaryAssesmentACFefa.setFileName('PreliminaryAssesmentACF.pdf');
                        PreliminaryAssesmentACFefa.setBody(PreliminaryAssesmentACFObj);
                        mailsAttachments.add(PreliminaryAssesmentACFefa);
                    // 3rd attachment   
                        PageReference CreditGuideACF = page.CreditGuideACF;
                        CreditGuideACF.getParameters().put('id',(String) oopObj.id);
                        CreditGuideACF.setRedirect(true);
    
                        Blob CreditGuideACFObj= CreditGuideACF.getContent();
                        Messaging.EmailFileAttachment CreditGuideACFObjefa = new Messaging.EmailFileAttachment();
                        CreditGuideACFObjefa.setFileName('CreditGuideACF.pdf');
                        CreditGuideACFObjefa.setBody(CreditGuideACFObj);
                        mailsAttachments.add(CreditGuideACFObjefa);
                    }
                                 
    
                 if(  (AccountRecordtypeid == ClickNewLoansId  || AccountRecordtypeid == ClickRefiId ) &&  Channel == 'Employee'){
                      // 1 attachment
                        PageReference PreliminaryAssesmentClick = page.PreliminaryAssesmentClick;
                        PreliminaryAssesmentClick.getParameters().put('id',(String) oopObj.id);
                        PreliminaryAssesmentClick.setRedirect(true);
    
                        Blob PreliminaryAssesmentClickObj= PreliminaryAssesmentClick.getContent();
                        Messaging.EmailFileAttachment PreliminaryAssesmentClickefa = new Messaging.EmailFileAttachment();
                        PreliminaryAssesmentClickefa.setFileName('PreliminaryAssesmentClick.pdf');
                        PreliminaryAssesmentClickefa.setBody(PreliminaryAssesmentClickObj);
                        mailsAttachments.add(PreliminaryAssesmentClickefa);
                    // 2nd attachment       
                        PageReference CreditProposalDisclosureDocClick = page.CreditProposalDisclosureDocClick;
                        CreditProposalDisclosureDocClick.getParameters().put('id',(String) oopObj.id);
                        CreditProposalDisclosureDocClick.setRedirect(true);
    
                        Blob CreditProposalDisclosureDocClickObj= CreditProposalDisclosureDocClick.getContent();
                        Messaging.EmailFileAttachment CreditProposalDisclosureDocClickefa = new Messaging.EmailFileAttachment();
                        CreditProposalDisclosureDocClickefa.setFileName('CreditProposalDisclosureDocClick.pdf');
                        CreditProposalDisclosureDocClickefa.setBody(CreditProposalDisclosureDocClickObj);
                        mailsAttachments.add(CreditProposalDisclosureDocClickefa);
                    // 3rd attachment   
                        PageReference CreditGuideClick = page.CreditGuideClick;
                        CreditGuideClick.getParameters().put('id',(String) oopObj.id);
                        CreditGuideClick.setRedirect(true);
    
                        Blob CreditGuideClickObj= CreditGuideClick.getContent();
                        Messaging.EmailFileAttachment CreditGuideClickefa = new Messaging.EmailFileAttachment();
                        CreditGuideClickefa.setFileName('CreditGuideClick.pdf');
                        CreditGuideClickefa.setBody(CreditGuideClickObj);
                        mailsAttachments.add(CreditGuideClickefa);
                    }   */
                return mailsAttachments;
            }   
            //insert econsent required documents
         /*   Public void createEconsentRequiredDocument(List<Id> LstApplicantId)
            { 
                 list<Document_Master__c> lstDocumentmaster = new list<Document_Master__c>();
                    lstDocumentmaster = [select id,Name,acf_Source__c from Document_Master__c where acf_Source__c = 'E-consent'];
                    List<Required_Document__c> lstRequireddoc = new List<Required_Document__c>();
                 if(!lstDocumentmaster.isempty() && !LstApplicantId.IsEmpty())
                 {
                     integer Count = 1;
                      for(Id objApplicantID :LstApplicantId)
                      {
                       Required_Document__c objRequiredDocument  =  new Required_Document__c();
                       objRequiredDocument.Name                  =  lstDocumentmaster[0].Name + Count;
                       objRequiredDocument.acfDocument_Master__c =  lstDocumentmaster[0].Id;
                       objRequiredDocument.Click_Applicant__c    =  objApplicantID;
                       objRequiredDocument.acfStatus__c          =  'Pending';
                       objRequiredDocument.Click_Is_E_consent__c = true;
                       lstRequireddoc.add(objRequiredDocument); 
                       Count++;
                      }
                      Count = 1;
                     
                 }
                 system.debug('lstRequireddoc---' +lstRequireddoc.size());
               insert lstRequireddoc;   
            }     
            
            Public static List<Required_Document__c>  createEconsentRequiredDocument1(List<Id> LstApplicantId)
                { 
                 list<Document_Master__c> lstDocumentmaster = new list<Document_Master__c>();
                 List<Opportunity> lstOpportunity = new List<Opportunity>();
                 lstOpportunity =[select id,name from Opportunity];
                 List<Lead> lstLeadConverted = new List<Lead>();
                 List<Lead> lstLeadNotConverted = new List<Lead>();
                     lstLeadConverted = [select id,name,isconverted,Lead.ConvertedOpportunityId from Lead where isconverted=true];
                     lstLeadNotConverted =[select id,isconverted from Lead where isconverted=false];
                     
                     
                    lstDocumentmaster = [select id,Name,acf_Source__c from Document_Master__c where acf_Source__c = 'E-consent'];
                    List<Required_Document__c> lstRequireddoc = new List<Required_Document__c>();
                 if(!lstDocumentmaster.isempty() && !LstApplicantId.IsEmpty() && lstLeadNotConverted.size()>0 && lstOpportunity.size()==0)
                 {    
                     integer Count = 1;
                      for(Id objApplicantID :LstApplicantId)
                      {
                       Required_Document__c objRequiredDocument  =  new Required_Document__c();
                       objRequiredDocument.Name                  =  lstDocumentmaster[0].Name + Count;
                       objRequiredDocument.acfDocument_Master__c =  lstDocumentmaster[0].Id;
                       objRequiredDocument.Click_Applicant__c    =  objApplicantID;
                       objRequiredDocument.acfStatus__c          =  'Pending';
                       objRequiredDocument.Click_Is_E_consent__c = true;
                       objRequiredDocument.Lead__c               = lstLeadNotConverted[0].Id;
                       lstRequireddoc.add(objRequiredDocument); 
                       Count++;
                      }
                      Count = 1;
                     insert lstRequireddoc;
                     return lstRequireddoc;
                    system.debug('bhasin test on 30 may'+lstRequireddoc);
                 }
            
             else if (!lstDocumentmaster.isempty() && !LstApplicantId.IsEmpty() && lstLeadConverted.size()>0 && !lstOpportunity.IsEmpty())
                    { 
                   
                     integer Count = 1;
                      for(Id objApplicantID :LstApplicantId)
                      {
                       Required_Document__c objRequiredDocument  =  new Required_Document__c();
                       objRequiredDocument.Name                  =  lstDocumentmaster[0].Name + Count;
                       objRequiredDocument.acfDocument_Master__c =  lstDocumentmaster[0].Id;
                       objRequiredDocument.Click_Applicant__c    =  objApplicantID;
                       objRequiredDocument.acfStatus__c          =  'Pending';
                       objRequiredDocument.Click_Is_E_consent__c = true;
                       objRequiredDocument.acfOpportunity__c     = lstOpportunity[0].Id;
                       
                       lstRequireddoc.add(objRequiredDocument); 
                       Count++;
                      }
                      Count = 1;
                     insert lstRequireddoc;
                    } 
                    system.debug('lstRequireddoc-----'+ lstRequireddoc);
                return lstRequireddoc;
              }   
                
                
            //send E-Consent email & sms to applicants
            public static boolean sendEconsentEmailSMS(Id applicantId)
            {
                list<click_Applicant__c> lstApplicants = [select id,acf_Applicant_Name__c,Applicant_Phone__c,Applicant_Email__c from click_Applicant__c where id=:applicantId];
                try
                {
                    if(lstApplicants != null && !lstApplicants.isEmpty())
                    {
                        string econsentId='';
                        string encodedDate=string.valueOf(System.currentTimeMillis());
                        econsentId=encodedDate+'-'+lstApplicants[0].click_Account__c+'-'+lstApplicants[0].acf_Applicant_Name__c;
                        EmailTemplate templateId =new EmailTemplate();                
                        templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'EConsent' AND isActive=true];
                        Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');                    
                        Blob data1 = Blob.valueOf(econsentId);
                        Blob encryptedValue  =Crypto.encryptWithManagedIV('AES128', cryptoKey, data1);
                        string Encryptdata=EncodingUtil.base64encode(encryptedValue);
                        string finalData= EncodingUtil.urlEncode(Encryptdata, 'UTF-8');
                        string body='';                            
                        body=templateId.HtmlValue;
                        body=body.replace('{!econsentid}',finalData);                                        
                        body=body.replace('{!Account.Name}',lstApplicants[0].acf_Applicant_Name__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toaddress=new List<String>();
                        toaddress.add(lstApplicants[0].Applicant_Email__c); 
                        system.debug('###'+toaddress);                   
                        mail.setToAddresses(toaddress);
                        mail.setSubject(templateId.Subject);
                        mail.setHtmlBody(body);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                        string mobileMessage=Label.Applicant_E_consent_message;
                        mobileMessage=mobileMessage.replace('{!econsentid}',finalData);             
                        mobileMessage=mobileMessage.replace('{!Account.Name}',lstApplicants[0].acf_Applicant_Name__c);              
                        acfCommon.SendSMSUsingFuture(lstApplicants[0].acf_Applicant_Name__c,lstApplicants[0].Applicant_Phone__c,mobileMessage,true);
                    }
                    return true;  
                }catch(Exception Ex)
                      {
                          return false;
                      }       
            }  
            */ 
            public static string sendSMSTwillio(String recepientNumber, String message)
            {
                TwilioConfig__c tc = TwilioConfig__c.getOrgDefaults();
        
                String ACCOUNT_SID = '';
                String AUTH_TOKEN = '';
                if(tc.AccountSid__c !=null){
                    ACCOUNT_SID = tc.AccountSid__c;
                }
                if(tc.AccountSid__c !=null){
                    AUTH_TOKEN = tc.AuthToken__c;
                }
                
                TwilioRestClient client = new TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN);
        
                Map<String,String> properties = new Map<String,String>();
                properties.put('To',recepientNumber);
                properties.put('From','+61400738629');
                properties.put('Body',message);
                
                TwilioMessage response = client.getAccount().getMessages().create(properties);
                return string.valueOf(response);
           }    
 }