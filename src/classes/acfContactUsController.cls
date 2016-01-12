public class acfContactUsController
{
    public MortgageExpert__c objMortgageExpert {get;set;}   
    public string strUsrName {get;set;}
    public string strUsrEmail {get;set;}
    public string strUsrPhone {get;set;}
    public string strQues {get;set;}
    public string strErrMsg {get;set;}
    public boolean isCaseGenerated {get;set;} 
    public boolean isFAQpage {get;set;}
    public acfContactUsController()
    {
        strUsrName = '';
        strUsrEmail = '';
        strUsrPhone = '';
        strQues = '';
        strErrMsg = '';
        isCaseGenerated = false;
        isFAQpage = false;
        list<MortgageExpert__c> lstMortExpert = MortgageExpert__c.getall().values();
        if(lstMortExpert != null && lstMortExpert.size()>0)
        {
            objMortgageExpert = lstMortExpert[0]; 
        }
        string pge = Apexpages.currentPage().getUrl();
        List<String> parts = pge.split('/'); 
        List<String> parts1 = parts[2].split('\\?');
        string pge_name = parts1[0].toLowerCase(); 
        system.debug('cons pge_name --------'+pge_name);  
        if(pge_name == 'clickfaq')
        {
          isFAQpage = true;
        }
    }
    public pagereference CreateCaseMethod()
    {
       if(strUsrName != null && strUsrName <> '')
       {
        if(strUsrEmail != null && strUsrEmail <> '')
        {
         if(strUsrPhone != null && strUsrPhone <>'')
         {
           if(strQues != null && strQues <> '')
           {
             list<lead> lstlead = [select id,name,Email from lead where Email =: strUsrEmail.trim()];
             list<user> lstUser = [select id,name,email,accountId,contactId from user where username=:strUsrEmail.trim()];
             system.debug('@@@@test'+lstlead+'======='+lstUser.size());
             case objCase = new case();
             objCase.Description = strQues;
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
                        objLead.LastName = strUsrName;
                        objLead.Email = strUsrEmail.trim();
                        if(strUsrPhone.substring(0,1) == '0')
                        {
                            objLead.MobilePhone = '+61'+strUsrPhone.substring(1,strUsrPhone.length());
                        }else{
                            objLead.MobilePhone = '+61'+strUsrPhone;
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
                isCaseGenerated = true;
                strErrMsg = 'Your request submitted successfully';
             }else{
                    strErrMsg = 'your request failed,please try again!';
                 }

           }else{
                   strErrMsg = 'Please enter Query';
               }
         }else{
                strErrMsg = 'Please enter phone number';
               }
        }else{
               strErrMsg = 'Please enter email id';
            }
       }else{
                strErrMsg = 'Please enter name';
            }
       return null;
    }
}