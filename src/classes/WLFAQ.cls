/*===============================================================
                        Click Loans
=================================================================*/
public class WLFAQ 
{
  
    public string strUserName {get;set;}
    public string strUserEmail {get;set;}
    public string strUserPhone {get;set;}
    public string strQuestion {get;set;}
    public string strErrorMsg {get;set;}
    public boolean isCaseCreated {get;set;}
    public string acfHeading {get;set;}
    public string acfDEscription {get;set;}
    
    public list<acfFAQ__c> lstacfFAQ {get;set;}
    public acfCMS_Page__c objacfCMSPage {get;set;}
    public string CMSPageId {get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public List<String> lstString {get;set;}
    private string strNetworkId;
    private List<Click_Community_Setup__c> lstCommunity;
    
    public List<wrapperFAQType> lstWrapperFAQType {get;set;}
    
    public class WrapperFAQ
    {
        public string question {get;set;}
        public string answer {get;set;}
        public string id {get;set;}
        
        public WrapperFAQ()
        {
            question = '';
            answer = '';
        }
    }
    
    public class WrapperFAQType
    {
        public string faqType {get;set;}
        public List<wrapperFAQ> lstWrapperFAQs{get;set;}
        
        public wrapperFAQType()
        {
            faqType = '';
            lstWrapperFAQs = new List <wrapperFAQ>();
        }
    }
    
    // constructor
    public WLFAQ()
    {
        
        lstString = new List<String>();
        statusOptions  = new List<SelectOption>();
        lstacfFAQ  =  new list<acfFAQ__c>();
        objacfCMSPage  =  new acfCMS_Page__c();
        CMSPageId = ApexPages.currentPage().getParameters().get('id');
        
        isCaseCreated = false;
        strErrorMsg = '';
        strUserEmail = '';
        strUserPhone = '';
        strQuestion = '';
        strUserName = '';
        strNetworkId = Network.getNetworkId();
  //    strNetworkId = '0DBN0000000CamKOAS';
        lstCommunity = new List<Click_Community_Setup__c>();
        if(strNetworkId != null && strNetworkId != '')
        {
             lstCommunity = [select id,name,Click_Page_Prefix__c,Click_Network_ID__c,Click_URL__c,Community_User_Name_Prefix__c,Click_IsActive__c,Click_Support_Team_Name__c from Click_Community_Setup__c where Click_Network_ID__c = : strNetworkId AND Click_IsActive__c =: true limit 1];
        }
        
        if(lstCommunity != null && lstCommunity.size() > 0)
        {
             objacfCMSPage = [select id,acfDescription__c,acfHeading__c,Click_Community_Setup__c from acfCMS_Page__c where Name = 'clickFAQ' AND Click_Community_Setup__c =: lstCommunity[0].id limit 1];
        }
        acfHeading = objacfCMSPage.acfHeading__c;
        acfDescription = objacfCMSPage.acfDescription__c;
        
        lstacfFAQ = [select id,acfAnswer__c,acfCMSPage__c,acfFAQType__c,acfQuestion__c from acfFAQ__c where acfCMSPage__c =:objacfCMSPage.Id];
        
        
        
        statusOptions = new List<SelectOption>();

            // Use DescribeFieldResult object to retrieve status field.
            Schema.DescribeFieldResult statusFieldDescription =  acfFAQ__c.acfFAQType__c.getDescribe();
            
            // For each picklist value, create a new select option
            for (Schema.Picklistentry  picklistEntry: statusFieldDescription.getPicklistValues())
            {
                statusOptions.add(new SelectOption( pickListEntry.getValue(),pickListEntry.getLabel()));
            // obtain and assign default value
            }
         
         lstWrapperFAQType = new List<wrapperFAQType>();
         
         integer count = 0;
         for(SelectOption s:statusOptions)
         {
             wrapperFAQType objWrapperFAQType = new wrapperFAQType();
             objWrapperFAQType.faqType = s.getValue();
            
            //lstString.add(s.getValue());
            
            for(acfFAQ__c objFAQ : lstacfFAQ)
            {
                if(objFAQ.acfFAQType__c == s.getValue())
                {
                    
                    wrapperFAQ objwrapFAQ  = new wrapperFAQ();
                    objwrapFAQ.question = objFAQ.acfQuestion__c;
                    objwrapFAQ.answer = objFAQ.acfAnswer__c;
                    objwrapFAQ.id= string.valueof(count);
                    objWrapperFAQType.lstWrapperFAQs.add(objwrapFAQ);
                    count = count +1;
                }
            }
            
            lstWrapperFAQType.add(objWrapperFAQType);
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
             list<lead> lstlead = [select id,name,Email from lead where Email =: strUserEmail.trim()];
             list<user> lstUser = [select id,name,email,accountId,contactId from user where username=:strUserEmail.trim()];
             system.debug('@@@@test'+lstlead+'======='+lstUser.size());
             case objCase = new case();
             objCase.Description = strQuestion;
             if(lstlead != null && lstlead.size()>0 && lstUser.size() == 0)
             {
                objCase.Lead__c = lstlead[0].id;
             }else if(lstUser!=null && lstUser.size()>0)
                {
                    if(lstUser[0].accountId != null)
                        objCase.AccountId = lstUser[0].accountId;
                    if(lstUser[0].contactId != null)
                         objCase.ContactId = lstUser[0].contactId;
                }else{
                        lead  objLead = new lead();
                        Schema.DescribeSObjectResult leadRT = Schema.SObjectType.Lead;
                        Map<String,Schema.RecordTypeInfo> rtCick_Refi = leadRT.getRecordTypeInfosByName();
                        Schema.RecordTypeInfo rt_Lead =  rtCick_Refi.get('Click Refi');                  
                        objLead.LastName = strUserName;
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
                        if(lstCommunity != null && lstCommunity.size() > 0){
                        objLead.Community__c = lstCommunity[0].id;     
                        }                   
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
                strUserEmail = '';
                strUserPhone = '';
                strQuestion = '';
                strUserName = '';
                isCaseCreated = true;
                strErrorMsg = 'Your request submitted successfully';
             }else{
                    strErrorMsg = 'your request failed,please try again!';
                  }
           }else{
                   strErrorMsg = 'Please enter Query';
                }
         }else{
                strErrorMsg = 'Please enter phone number';
              }
        }else{
               strErrorMsg = 'Please enter email id';
            }
       }
       else{
                strErrorMsg = 'Please enter name';
            }
       return null;
    }
       
    }