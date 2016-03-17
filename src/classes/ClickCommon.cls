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
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('senderId');
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
        
        String status;
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
    
    //user redirect method
     public static string redirect(string currentUserId,string pagename,string strNetworkId)
     {
       String oppId = getCurrentLoggedInOpportunityId(currentUserId,getCommunitySetup(strNetworkId).Click_Page_Prefix__c); 
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
 }