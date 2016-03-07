//To create community user from CRM
public class ClickPreLoginQuestionController 
{
    public string strCurrentAccId;
    public Id ScriptId;
    public Id selectedCommunity{get;set;}
    public String selectedLoanType{get;set;}
    public Lead objLead{get;set;}
    public List<Account> lstAcc;
    public map<id,Question__c>mapQuestionIdToQuestion;
    public integer indexNo{get;set;}
    public integer QuesNo{get;set;}
    public List<WrapperQuestions>lstMasterWrapperQuestion;
    public List<WrapperQuestions>lstWrapperQuestion{get;set;}
    public List<Question__c>lstScriptQuestion{get;set;}
    public List<string>lstSelectedAnswers{get;set;}
    public map<id,string> mapIdToAnswer;
    public set<id> setCommIds;
    public List<Click_Community_Setup__c> lstCommunity;
    Public String strBubbleText 
    {
        get
        {
            if(lstWrapperQuestion != null && indexNo != null && indexNo >= 0 && lstWrapperQuestion.size() > indexNo)
            {
                if(lstWrapperQuestion[indexNo] != null)
                {
                    if(lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c != null)
                        return lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c;
                }
            }
            return '';
        }
        set;
    }

    public ClickPreLoginQuestionController(ApexPages.StandardController controller)
    {
            mapIdToAnswer = new map<id,string>();
            if(strCurrentAccId == null && strCurrentAccId == '')
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Account Id is null'));                
            }
            else
            {
                strCurrentAccId = ApexPages.currentPage().getParameters().get('id');   
            }
            lstAcc = new List<Account>();
            objLead = new Lead();
     //     objLead.Click_Loan_Type__c = 'New Purchase';
            lstMasterWrapperQuestion = new List<WrapperQuestions>();
            lstWrapperQuestion       = new List<WrapperQuestions>();
            mapQuestionIdToQuestion  = new map<id,Question__c>();
            indexNo = 0;
            lstScriptQuestion = new List<Question__c>();
            if(strCurrentAccId <> null && strCurrentAccId <> '')
            {
                lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,PersonMobilePhone,Click_Community_Setup__c,IsMaster__c,SelfLookup__c,SelfLookup__r.Click_Community_Setup__c,(select id,Click_Community_Setup__c,SelfLookup__c from Accounts__r) from Account where id=:strCurrentAccId];
                setCommIds = new set<Id>();
                if(lstAcc != null && lstAcc.size()>0)
                {
                    Account ObjMasterAccount = lstAcc[0];
                    if(ObjMasterAccount.Click_Community_Setup__c != null)
                        setCommIds.add(ObjMasterAccount.Click_Community_Setup__c);
                    if(ObjMasterAccount.IsMaster__c == true && ObjMasterAccount.Accounts__r != null && ObjMasterAccount.Accounts__r.size()>0)
                    {
                        for(Account objchildAcc : ObjMasterAccount.Accounts__r)
                        {
                            if(objchildAcc.Click_Community_Setup__c != null)
                                setCommIds.add(objchildAcc.Click_Community_Setup__c);
                        }
                    }else if(ObjMasterAccount.IsMaster__c == false && ObjMasterAccount.SelfLookup__c != null && ObjMasterAccount.SelfLookup__r.Click_Community_Setup__c != null)
                        {
                            list<Account> lstSiblingAccnts = [select id,Click_Community_Setup__c,(select id,Click_Community_Setup__c,SelfLookup__c from Accounts__r) from Account where id=:ObjMasterAccount.SelfLookup__c];
                            if(lstSiblingAccnts != null && lstSiblingAccnts.size()>0)
                            {
                                for(Account objSiblingAcc : lstSiblingAccnts)
                                {
                                    if(objSiblingAcc.Click_Community_Setup__c != null)
                                        setCommIds.add(objSiblingAcc.Click_Community_Setup__c);
                                }
                            }                           
                        }
                      lstCommunity = [select id,Name from Click_Community_Setup__c where Click_IsActive__c = true AND id Not IN: setCommIds];  
                      if(lstCommunity != null && lstCommunity.size() == 0)
                      {
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'All Community users already exist!'));
                      }   
                }
            }    
            
        } 
      //To display prelogin questions
        public void PreLoginQuestion()
        {
         lstWrapperQuestion.clear();
         lstMasterWrapperQuestion.clear();
          List<Click_Community_Setup__c> lstComm = [select id,Click_Page_Prefix__c from Click_Community_Setup__c where id =:selectedCommunity];
          List<Lead> lstLeadObj = new  List<Lead>();
        /*  if(lstAcc != null && lstAcc.size() > 0 && lstComm <> null && lstComm.size() > 0)
          {
              system.debug('%%%%@@@@@@@@'+lstAcc +'Ankit@@@@'+lstComm );
              if(selectedLoanType == 'New Purchase')
              {
                  lstLeadObj = [select id,Email,RecordType.Name from Lead where Email=:lstAcc[0].PersonEmail AND RecordType.Name =: lstComm[0].Click_Page_Prefix__c+' New Loans' ];
                   system.debug('%%%%@@@@@@@@1'+lstLeadObj +'Ankit1@@@@'+selectedLoanType);
              }
              else if(selectedLoanType == 'Refinance')
              {
                  lstLeadObj = [select id,Email,RecordType.Name from Lead where Email=:lstAcc[0].PersonEmail AND RecordType.Name =: lstComm[0].Click_Page_Prefix__c+' Refi' ];
                  system.debug('%%%%@@@@@@@@1'+lstLeadObj +'Ankit1@@@@'+selectedLoanType);
              }
          }
          else*/
          if(selectedCommunity == null)
          {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select community'));
          }
          else
          {
              system.debug('%%%%@@@@@@@@Ankit1'+lstLeadObj);
              List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login'  AND Click_Community_Setup__c =: selectedCommunity order by acf_Sequence_no__c limit 1];
                // system.debug('!#$%'+lstScript);
                if(lstScript <> null && lstScript.size()>0)
                {
                    ScriptId = lstScript[0].id;
                }
             if(ScriptId <> null)
              {
                lstScriptQuestion = [select id,acf_Stage_Name__c,acf_Sequence_No__c,acfBubble_Text__c,acfWatermark_Text__c from Question__c where acf_Script__c =:ScriptId and acf_Active__c = true order by acf_Sequence_No__c desc];
                if(selectedLoanType == 'New Purchase')
                   { 
                            for(Question__c objQuestion:[select id,acf_ApiName__c,Click_Is_Broker_Question__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                           acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                            
                                                               (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                               where ((acf_Master_Question__r.acf_Script__c =: ScriptId or acf_Script__c =:ScriptId) and acf_Active__c = true and acfIs_New_Loan__c = true AND Click_Is_Broker_Question__c = false) order by acfNew_Loan_Sequence_No__c])
                                {                                      
                                     mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                                     WrapperQuestions objWarpperQues = new WrapperQuestions();
                                     objWarpperQues.objWrapQuestion = objQuestion;
                                     if(objQuestion.acf_Script__c <> null)
                                     {
                                          lstMasterWrapperQuestion.add(objWarpperQues);   
                                     }
                                 }    
                        
                    }
                 else if(selectedLoanType == 'Refinance')
                   {
                             for(Question__c objQuestion:[select id,acf_ApiName__c,Click_Is_Broker_Question__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                           acfBubble_Text__c,acfWatermark_Text__c,acfIs_refinance__c,acfRefinance_Sequence_No__c,                                                          
                                                               (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                               where ((acf_Master_Question__r.acf_Script__c =: ScriptId or acf_Script__c =:ScriptId) and acf_Active__c = true and acfIs_refinance__c = true AND Click_Is_Broker_Question__c = false) order by acfRefinance_Sequence_No__c])  
                                {                                      
                                     mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                                     WrapperQuestions objWarpperQues = new WrapperQuestions();
                                     objWarpperQues.objWrapQuestion = objQuestion;
                                     if(objQuestion.acf_Script__c <> null)
                                     {
                                          lstMasterWrapperQuestion.add(objWarpperQues);   
                                     }
                                 }  
                   }
                       //for adding wrapperlist in a page for all master questions.  
                 if(lstMasterWrapperQuestion != null && lstMasterWrapperQuestion.size()>0)
                   {
                         for(WrapperQuestions objMasterQuestion:lstMasterWrapperQuestion)
                         {
                             objMasterQuestion.lstSelectOpt = new List<SelectOption>();
                             objMasterQuestion.lstSelectOptions = new List<Answer__c>();
                             objMasterQuestion.lstCheckBoxAnswer = new List<string>();
                            for(Answer__c objAnswer:objMasterQuestion.objWrapQuestion.Answer__r)
                            {   
                                objMasterQuestion.lstSelectOptions.add(objAnswer);
                                objMasterQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                mapIdToAnswer.put(objAnswer.id,objAnswer.acf_Answer__c);
                            }
                   
                            lstWrapperQuestion.add(objMasterQuestion); 
                         }
                   }
              }
          }
      }  
         
     public PageReference saveLead()
     {  
        Id RecordTypeId;
        List<Click_Community_Setup__c> lstComm = [select id,Click_Page_Prefix__c from Click_Community_Setup__c where id =:selectedCommunity];
        map<string,string> mapApiName = new map<string,string>();
        string strRecTypeName = '';
        if(lstComm != null && lstComm.size() > 0)
        {
            if(selectedLoanType == 'New Purchase')
            {
                RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' New Loans').getRecordTypeId();
                strRecTypeName = lstComm[0].Click_Page_Prefix__c +' New Loans';
            } 
            else if(selectedLoanType == 'Refinance')
            {
                RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' Refi').getRecordTypeId();
                strRecTypeName = lstComm[0].Click_Page_Prefix__c +' Refi';
            }
        } 
        Account objChildAccount = new Account();
        Lead objInsertLead = new Lead();
        Id AccRecTypeId = clickcommon.GetRecordTypeId('Account',strRecTypeName);
        if(lstAcc != null && lstAcc.size()>0)
        {
            Account objAcc = lstAcc[0];
            if(lstAcc[0].Click_Community_Setup__c == null)
            {
                 if(AccRecTypeId <> null)
                 objAcc.RecordTypeId = AccRecTypeId;
                 objAcc.Click_Is_Phone_Broker_customer__c = true;
                 objAcc.Click_Community_Setup__c = selectedCommunity;
            }else{              
                
                objChildAccount.FirstName = lstAcc[0].FirstName;
                objChildAccount.LastName = lstAcc[0].LastName;
                objChildAccount.PersonEmail = lstAcc[0].PersonEmail;
                objChildAccount.Click_Community_Setup__c = selectedCommunity;
                objChildAccount.PersonMobilePhone = lstAcc[0].PersonMobilePhone;
       //       objChildAccount.Click_Is_community_user_created__c = true;
                if(AccRecTypeId <> null)
                objChildAccount.RecordTypeId = AccRecTypeId;
                insert objChildAccount;
                objInsertLead.acf_partner_account__c = objChildAccount.id;
            }      
        objInsertLead.FirstName = lstAcc[0].FirstName;
        objInsertLead.LastName = lstAcc[0].LastName;
        objInsertLead.Email = lstAcc[0].PersonEmail;
        objInsertLead.Click_Is_Phone_Broker_customer__c = true;
        if(RecordTypeId <> null)
        objInsertLead.RecordTypeId  = RecordTypeId;
        objInsertLead.Community__c = selectedCommunity;
        objInsertLead.Click_Loan_Type__c = selectedLoanType;
        objInsertLead.MobilePhone = lstAcc[0].PersonMobilePhone;
        objInsertLead.Status = 'Open';
        
        for(WrapperQuestions objWrappQuestion : lstWrapperQuestion)
        {
           if((objWrappQuestion.strWrapAnswer == null || objWrappQuestion.strWrapAnswer == '' || objWrappQuestion.strWrapAnswer == 'NONE') && objWrappQuestion.lstCheckBoxAnswer.size()==0) 
            {
                string strmsg = 'Please fill answer for '+objWrappQuestion.objWrapQuestion.acf_Question__c;
               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,strmsg));
                return null;
            }
           
           
           if(objWrappQuestion.objWrapQuestion.acf_Type__c == 'Picklist' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'Button' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'RadioButton' )
            {       
               if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '' && objWrappQuestion.strWrapAnswer <> 'None')
               {
                 if(mapIdToAnswer.containsKey(objWrappQuestion.strWrapAnswer))
                 {
                       objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,mapIdToAnswer.get(objWrappQuestion.strWrapAnswer));
                 //      system.debug('Ankit11*******'+objInsertLead);
                 }
               }
            }
            else if(objWrappQuestion.objWrapQuestion.acf_Type__c == 'Number' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'Percent')
            {
                if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '')
                {
                      objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,Decimal.valueOf(objWrappQuestion.strWrapAnswer));
                     // system.debug('Ankit112*******'+objInsertLead);
                }
            }
            else if( objWrappQuestion.objWrapQuestion.acf_Type__c == 'Currency')
            {
                if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '')
                {
                     objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,Decimal.valueOf(objWrappQuestion.strWrapAnswer));
                    // system.debug('Ankit113*******'+objInsertLead);
                }
            }
            else
            {
                if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '')
                {
                      objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,string.valueof(objWrappQuestion.strWrapAnswer));
                      //system.debug('Ankit114*******'+objInsertLead);
                }
            }

        }         
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
        if(AR <> null)
        {
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
            objLead.setOptions(dmlOpts);
        }           
        insert objInsertLead;  
        string strAccountId = '';
        if(objChildAccount != null && objChildAccount.id <> null)
        {
            objChildAccount.acf_Lead__pc = objInsertLead.id;
            update objChildAccount;
            strAccountId = objChildAccount.id;
        }else{
            objAcc.acf_Lead__pc = objInsertLead.id;
            update objAcc;
            strAccountId = objAcc.id;
        }
        
       // updateAccount(objInsertLead.id,lstComm);
        if(strAccountId <> null && strAccountId <> '')
        {
            string Feedback = ClickEnablePortalUserFromCRM.createPortalUserFromCRMWithAccounts(strAccountId ,objInsertLead.FirstName,objInsertLead.LastName,objInsertLead.Email,objInsertLead.MobilePhone,objInsertLead.id,selectedCommunity);
            system.debug('Feedback************'+Feedback);
            if(Feedback.contains('Portal user created.') || Feedback == '')
            {
            //    system.debug('Feedback*******************'+Feedback);
                  PageReference pg = new PageReference('/' + strCurrentAccId  + '');
                  pg.setRedirect(true);
                  return pg;
            }
            else
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Email already Exist, Please use different one.'));
            //   system.debug('Feedback*******************');
                 return null;
            }       
        }
        }
        return null;   
    }
    
    public void updateAccount(id leadId,List<Click_Community_Setup__c> lstComm)
    {
         if(leadId != null)
         {
             Id RecordTypeId;
             List<Account> lstAccount = new List<Account>();
             if(lstComm != null && lstComm.size() > 0)
             {
                if(selectedLoanType == 'New Purchase')
                {
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c+' New Loans').getRecordTypeId();
                } 
                else if(selectedLoanType == 'Refinance')
                {
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(lstComm[0].Click_Page_Prefix__c +' Refi').getRecordTypeId();
                }
             }       
             if(lstAcc[0].RecordTypeId <> null && lstAcc[0].RecordTypeId <> RecordTypeId ) 
             {   
                 Account objAcc = new Account(id = lstAcc[0].id);
                 if(RecordTypeId <> null)
                 objAcc.RecordTypeId = RecordTypeId;
                 objAcc.Click_Is_Phone_Broker_customer__c = true;
                 objAcc.Click_Is_community_user_created__c = true;
                 objAcc.acf_Lead__pc = leadId;
                 objAcc.Click_Community_Setup__c = selectedCommunity;
                 lstAccount.add(objAcc);
             }
             
             if(lstAccount <> null && lstAccount.size() > 0 )
             {
                 update lstAccount;
             }
         }
         
     
    }
    
    public List<SelectOption> getBankNames()
    {  
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c,clickShow_on_Bank_Statements_Integration__c from acfBank_Detail__c where click_Show_on_Current_Lender_question__c = true];
        List<SelectOption> options = new List<SelectOption>();
        if(lstBank != null && lstBank.size()>0)
        {
           options.add(new SelectOption('','--NONE--'));
           for(acfBank_Detail__c objBank : lstBank)
           { 
             options.add(new SelectOption(objBank.acfBank_Name__c,objBank.acfBank_Name__c));
           }
        }
        return options;
    }
    //To populate communities
    public List<SelectOption> getCommunity()
    {  
        if(lstAcc != null && lstAcc.size()>0)
        {
            
            List<SelectOption> options = new List<SelectOption>();
             options.add(new SelectOption('','--Select--'));
            if(lstCommunity != null && lstCommunity.size()>0)
            {
              
               for(Click_Community_Setup__c objCommunity: lstCommunity)
               { 
                 options.add(new SelectOption(objCommunity.Id,objCommunity.Name));
               }
            }else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'All Community users already exist!'));
            }
            return options;
        }
        return null;
    }
    
    public List<SelectOption> getLoanType()
    {  
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        options.add(new SelectOption('Refinance','Refinance'));
        options.add(new SelectOption('New Purchase','New Purchase')); 
        return options;
    }
    
    public class WrapperQuestions
    {
      public Question__c objWrapQuestion {get;set;}
      public string strWrapAnswer {get;set;}
      public List<SelectOption>lstSelectOpt {get;set;}
      public List<WrapperQuestions>lstRelatedQuestion {get;set;}
      public List<Answer__c>lstSelectOptions{get;set;}
      public List<string>lstCheckBoxAnswer{get;set;}
    }
  
 }