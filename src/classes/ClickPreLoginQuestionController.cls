public class ClickPreLoginQuestionController 
{
public string pageId;
public Id ScriptId;
public Lead objLead{get;set;}
public List<Account> lstAcc;
public map<id,Question__c>mapQuestionIdToQuestion;
public integer indexNo{get;set;}
public integer QuesNo{get;set;}
public List<WrapperQuestions>lstMasterWrapperQuestion;
public List<WrapperQuestions>lstWrapperQuestion{get;set;}
public List<Question__c>lstScriptQuestion{get;set;}
public List<string>lstSelectedAnswers{get;set;}
// Public Integer intTotalQuestions {get;set;}
public map<id,string> mapIdToAnswer;
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
        if(pageId == null && pageId == '')
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Account Id is null'));
            
        }
        else
        {
            pageId = ApexPages.currentPage().getParameters().get('id');   
        }
        lstAcc = new List<Account>();
        objLead = new Lead();
        objLead.Click_Loan_Type__c = 'New Purchase';
        lstMasterWrapperQuestion = new List<WrapperQuestions>();
        lstWrapperQuestion       = new List<WrapperQuestions>();
        mapQuestionIdToQuestion  = new map<id,Question__c>();
        indexNo = 0;
        lstScriptQuestion = new List<Question__c>();
        if(pageId <> null && pageId <> '')
        {
            lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Click_Is_Phone_Broker_customer__c,PersonMobilePhone from Account where id=:pageId ];
        }
        List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login' order by acf_Sequence_no__c limit 1];
       // system.debug('!#$%'+lstScript);
        if(lstScript <> null && lstScript.size()>0)
        {
            ScriptId = lstScript[0].id;
        }
        PreLoginQuestion();
         
     } 
 
    public void PreLoginQuestion()
    {
     lstWrapperQuestion.clear();
     lstMasterWrapperQuestion.clear();
     if(ScriptId <> null)
      {
     //   Cookie IsNewHomeLoan = ApexPages.currentPage().getCookies().get('IsNewHomeLoan');
   //     System.debug('****IsNewHomeLoan' +IsNewHomeLoan);
        lstScriptQuestion = [select id,acf_Stage_Name__c,acf_Sequence_No__c,acfBubble_Text__c,acfWatermark_Text__c from Question__c where acf_Script__c =:ScriptId and acf_Active__c = true order by acf_Sequence_No__c desc];
        if(objLead.Click_Loan_Type__c == 'New Purchase')
           { 
       /*      List<Question__c> lstNewHomeLoan =[select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                   acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                            
                                                       (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                       where (acf_Master_Question__c =null and acf_Script__c =:ScriptId and acf_Active__c = true and acfIs_New_Loan__c = true) order by acfNew_Loan_Sequence_No__c];
        //        intTotalQuestions = lstNewHomeLoan.size(); */   
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
         else if(objLead.Click_Loan_Type__c == 'Refinance')
           {
           /*      List<Question__c> lstRefinance =[select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                   acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                            
                                                       (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                       where (acf_Master_Question__c =null and acf_Script__c =:ScriptId and acf_Active__c = true and acfIs_refinance__c = true) order by acfNew_Loan_Sequence_No__c];
        //          intTotalQuestions = lstRefinance.size(); */ 
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
                         //System.debug('****Refinance*****' +mapQuestionIdToQuestion.size());
                         //intTotalQuestions = mapQuestionIdToQuestion.size();    
           }
               //for adding wrapperlist in a page for all master questions.  
         if(lstMasterWrapperQuestion != null && lstMasterWrapperQuestion.size()>0)
           {
                 for(WrapperQuestions objMasterQuestion:lstMasterWrapperQuestion)
                 {
                     objMasterQuestion.lstSelectOpt = new List<SelectOption>();
                     objMasterQuestion.lstSelectOptions = new List<Answer__c>();
                     objMasterQuestion.lstCheckBoxAnswer = new List<string>();
             /*       if(objMasterQuestion.objWrapQuestion.acf_Type__c == 'Text' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Checkbox'|| objMasterQuestion.objWrapQuestion.acf_Type__c == 'Number' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                    {
                      objMasterQuestion.IsContinueDisplay = true;
                    }  */
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
     
    
    public PageReference saveLead()
    {
        
       //try
      // {
        map<string,string> mapApiName = new map<string,string>();
        Id RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId();       
        Lead objInsertLead = new Lead();
        objInsertLead.acf_partner_account__c = lstAcc[0].id;
        objInsertLead.FirstName = lstAcc[0].FirstName;
        objInsertLead.LastName = lstAcc[0].LastName;
        objInsertLead.Email = lstAcc[0].PersonEmail;
        objInsertLead.Click_Is_Phone_Broker_customer__c = true;
        objInsertLead.RecordTypeId  = RecordTypeId ;
        objInsertLead.Click_Loan_Type__c = objLead.Click_Loan_Type__c;
        objInsertLead.MobilePhone = lstAcc[0].PersonMobilePhone;
        objInsertLead.Status = 'Open';
        
        for(WrapperQuestions objWrappQuestion : lstWrapperQuestion)
        {
           if((objWrappQuestion.strWrapAnswer == null || objWrappQuestion.strWrapAnswer == '' || objWrappQuestion.strWrapAnswer == 'NONE') && objWrappQuestion.lstCheckBoxAnswer.size()==0) 
            {
                string strmsg = 'Please fill answer for '+objWrappQuestion.objWrapQuestion.acf_Question__c;
                //InputHidden = false;
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
                 //    system.debug('Ankit11*******'+objInsertLead);
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
        
        updateAccount(objInsertLead.id); 
        string Feedback = ClickEnablePortalUserFromCRM.createPortalUserFromCRMWithAccount(pageId,objInsertLead.FirstName,objInsertLead.LastName,objInsertLead.Email,objInsertLead.MobilePhone,objInsertLead.id);
        if(Feedback.contains('Portal user created.') || Feedback == '')
        {
        //     system.debug('Feedback*******************'+Feedback);
              PageReference pg = new PageReference('/' + pageId  + '');
              pg.setRedirect(true);
              return pg;
        }
        else
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Email already Exist, Please use different one.'));
        //   system.debug('Feedback*******************');
             return null;
        }
     /*}
     catch(Exception e ) 
      {
           
            if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
               if(objLead.Click_Loan_Type__c == 'New Purchase')
               {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter "Principal and Interest" or "Interest Only" in "What is your preferred repayment method?"'));
                    return null;
                }
               
               else if (objLead.Click_Loan_Type__c == 'Refinance')
               {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter "Principal and Interest" or "Interest Only" in "What is your current payment type?"'));
                    return null;
               }
             }
             else{
                   e.getMessage();
                   system.debug('Ankit*******'+e.getMessage());
                   return null;
            }
            return null;
        }   */        
    }
    
    public void updateAccount(id leadId)
    {
         if(leadId != null)
         {
             List<Account> lstAccount = new List<Account>();
             Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId();
             if(lstAcc[0].RecordTypeId <> null && lstAcc[0].RecordTypeId <> RecordTypeId ) 
             {   
                 Account objAcc = new Account(id = lstAcc[0].id);
                 objAcc.RecordTypeId = RecordTypeId;
                 objAcc.Click_Is_Phone_Broker_customer__c = true;
                 objAcc.acf_Lead__pc = leadId;
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
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c,click_Show_on_Current_Lender_question__c from acfBank_Detail__c where click_Show_on_Current_Lender_question__c = true];
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