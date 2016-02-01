/*     White label    */
public without sharing class WLContactus 
{
    public list<acfContentManagementSystem__c> lstAboutUs {get;set;}
    public string strPagetitle {get;set;}
    public string strDescription {get;set;}
    public string strUserName {get;set;}
    public string strUserEmail {get;set;}
    public string strUserPhone {get;set;}
    public string strQuestion {get;set;}
    public string strErrorMsg {get;set;}
    public boolean isCaseCreated {get;set;}
    private Click_Community_Setup__c CommSetup;
    public WLContactus()
    {     
        strPagetitle = '';
        strDescription = '';
        strUserName = '';
        strUserEmail = '';
        strUserPhone = '';
        strQuestion = '';
        strErrorMsg = '';
        isCaseCreated = false;
        
        try{
             id NetworkId =  Network.getNetworkId();
            CommSetup = new Click_Community_Setup__c();
            commSetup = ClickCommon.getCommunitySetup(NetworkId);
            
            lstAboutUs = [select acfDescription__c,acfShort_Description__c ,acfHeadingRemoveSpace__c, acfHeading__c, acfImageURL__c, acfMoreDetailURL__c, acfSectionName__c, acfSequence__c,acfDescriptionImageURL__c, Id, Name,acfHeading_Caption__c FROM acfContentManagementSystem__c WHERE acfSectionName__c = 'About Us' and Click_Community_Setup__c=:commSetup.id ORDER BY acfSequence__c ASC NULLS FIRST]; 
            list<acfCMS_Page__c> lstCSMPage = [select id,name,acfDescription__c,acfHeading__c from acfCMS_Page__c where name = 'clickcontactus' and Click_Community_Setup__c=:commSetup.id limit 1];
            if(lstCSMPage != null && lstCSMPage.size()>0)
            {
                strPagetitle = lstCSMPage[0].acfHeading__c;
                strDescription = lstCSMPage[0].acfDescription__c;
            }
        }catch(Exception Ex){
            system.debug('@@@@@@@@@'+ex);
        }
    }
    public pagereference submitCase()
    {
       if(strUserName != null && strUserName <> '')
       {
        if(strUserEmail != null && strUserEmail <> '')
        {
         if(strUserPhone != null && strUserPhone <>'')
         {
           if(strQuestion != null && strQuestion <> '')
           {
             string loginUserName = strUserEmail.trim();
             if(CommSetup.Community_User_Name_Prefix__c != null)
                 loginUserName = CommSetup.Community_User_Name_Prefix__c + loginUserName;
             
             list<lead> lstlead = [select id,name,Email from lead where Email =: strUserEmail.trim()];
             list<user> lstUser = [select id,name,email,AccountId,ContactId from user where username =: loginUserName];
             system.debug('@@@@test'+lstlead+'======='+lstUser.size());
             case objCase = new case();
             objCase.Description = strQuestion;
             if(lstlead != null && lstlead.size()>0 && lstUser.size() == 0)
             {
                system.debug('lstlead ******************'+lstlead );
                objCase.Lead__c = lstlead[0].id;
             }
             else if(lstUser!=null && lstUser.size()>0)
                {
                    system.debug('lstUser******************'+lstUser);
                    if(lstUser[0].AccountId != null)
                        objCase.AccountId = lstUser[0].AccountId;
                    if(lstUser[0].ContactId != null)
                         objCase.ContactId = lstUser[0].ContactId;
                }else{
                       
                        lead  objLead = new lead();
                        Schema.DescribeSObjectResult leadRT = Schema.SObjectType.Lead;
                        Map<String,Schema.RecordTypeInfo> rtCick_Refi = leadRT.getRecordTypeInfosByName();
                        Schema.RecordTypeInfo rt_Lead =  rtCick_Refi.get(commSetup.Click_Page_Prefix__c+ ' Refi');                  
                        objLead.LastName = strUserName;
                        objLead.Community__c = CommSetup.Id;
                        objLead.Email = strUserEmail.trim();
                        if(strUserPhone.substring(0,1) == '0')
                        {
                            objLead.MobilePhone = '+61'+strUserPhone.substring(1,strUserPhone.length());
                        }else{
                            objLead.MobilePhone = '+61'+strUserPhone;
                        }
                        
                        objLead.acfIsCreatedViaRequestCall__c = true;
                        objLead.RecordTypeId = rt_Lead.getRecordTypeId(); 
                        objLead.Status = 'Open';
                        AssignmentRule AR = new AssignmentRule();
                        insert objLead;
                        AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
                        if(AR <> null)
                        {
                            Database.DMLOptions dmlOpts = new Database.DMLOptions();
                            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
                            objLead.setOptions(dmlOpts);
                        }
                        update objLead;
                        system.debug('lstlead ******************'+objLead);
                        objCase.Lead__c = objLead.id;
                    }
             if(objCase != null)
             {
                Schema.DescribeSObjectResult caseRT = Schema.SObjectType.Case;
                Map<String,Schema.RecordTypeInfo> rtCick_Refi = caseRT.getRecordTypeInfosByName();
                Schema.RecordTypeInfo rt_Case =  rtCick_Refi.get('Click Refi');   
                if(rt_Case != null && rt_Case.getRecordTypeId() <> null)
                {
                    objCase.RecordTypeId = rt_Case.getRecordTypeId(); 
                }
                system.debug('@@@karthik'+objCase);
                AssignmentRule AR = new AssignmentRule();
                insert objCase;
                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                if(AR <> null)
                {
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
                    objCase.setOptions(dmlOpts);
                }
                update objCase;
                strUserName = '';
                strUserEmail = '';
                strUserPhone = '';
                strQuestion = '';
                isCaseCreated = true;
                strErrorMsg = 'Your request submitted successfully';
             }else{
                    strErrorMsg = 'your request failed,please try again!';
                 }

           }else{
                   strErrorMsg = 'Please mention your query';
               }
         }else{
                strErrorMsg = 'Please enter phone number';
               }
        }else{
               strErrorMsg = 'Please enter email id';
            }
       }else{
                strErrorMsg = 'Please enter name';
            }
       return null;
    }
}