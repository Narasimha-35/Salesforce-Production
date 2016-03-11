public without sharing class acf_PreLoginQuestionController{

    public String IsError { get; set; }
    public boolean InputHidden { get; set; }
    public boolean IsFirstTime =false;
    public Id IsInsertedId;
    public string pageId;
    public string AccountId;
    public Id ScriptId;
    public string strmsg {get;set;}
    public boolean PreviousVal;
    public boolean IsNewpurchase;
    public Lead objLead{get;set;}
    public List<Account> lstAcc;
    public map<id,Question__c>mapQuestionIdToQuestion;
    public integer indexNo{get;set;}
    public integer QuesNo{get;set;}
    public List<WrapperQuestions>lstMasterWrapperQuestion;
    public List<WrapperQuestions>lstWrapperQuestion{get;set;}
    public List<Question__c>lstScriptQuestion{get;set;}
    public List<string>lstSelectedAnswers{get;set;}
    public List<Click_Community_Setup__c> lstcommu;
    public Id communityid;
    // Public Integer intTotalQuestions {get;set;}
    public map<id,string> mapIdToAnswer;
    public List<Opportunity> opplatlist;
      public string MyAccountId{get; set;}
      public list<string> BankNamesAutosugest{set;}
      public string bankLists{get;set;}
      
      //setting Account Id
      public string setMyAccountId(String AccId)
      {
         MyAccountId=AccId;
         return null;
      }
        //Get AccountId Assign to variable in page
      public string getMyAccountId()
      {
       return  MyAccountId;
      }
      //Get List Of Account
      public list<Account> getMyAccount()
      {
      
       
        //PreLoginQuestion();
        return lstAcc ;
      }
     
      public string LoanType;
      
      public void setLoanType(String s) {
   
        LoanType= s;
      }
        
      public String getLoanType() {
        return LoanType;
      } 
      
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

    public acf_PreLoginQuestionController() 
    {
      communityid=null;
      system.debug('MyaccountID==>'+MyAccountId);
      system.debug('opp==>'+opplatlist); 
      lstcommu=new List<Click_Community_Setup__c>();
      lstcommu=[select id from Click_Community_Setup__c where name = 'ClickLoans' limit 1];
      if(lstcommu.size()>0)
          communityid=lstcommu[0].id ;
        bankLists='';
        
        integer temp=0;
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c from acfBank_Detail__c where click_Show_on_Current_Lender_question__c = true];
        List<string> banksname= new List<string>();
        
        for(acfBank_Detail__c ob: lstBank ){
             ob.acfBank_Name__c=ob.acfBank_Name__c.replace('\'','&#39;') ;

             if(temp==0)
             bankLists='\''+ob.acfBank_Name__c+'\'';
             else
             bankLists+=',\''+ob.acfBank_Name__c+'\'';
             
             temp++;
        }
        
        
        
        
     InputHidden =false;
     system.Debug('LOanTYpe Construct------------'+LoanType);
     mapIdToAnswer = new map<id,string>();
     lstAcc = new List<Account>();
     objLead = new Lead();
     indexNo = 0;
     strmsg = '';
     lstMasterWrapperQuestion = new List<WrapperQuestions>();
     lstWrapperQuestion       = new List<WrapperQuestions>();
     mapQuestionIdToQuestion  = new map<id,Question__c>();
    /* if(IsFirstTime== false)
     {
      objLead.Click_Loan_Type__c='Refinance';
      IsFirstTime=true;
     }*/
        lstScriptQuestion = new List<Question__c>();
        //Changed in Query by Dependra as told by himanshu , Ww will revert the changes while deployment, Old Query commented
        //List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login' order by acf_Sequence_no__c limit 1];
        //List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login' AND Click_Community_Setup__c = 'a2SO0000001PtV9' order by acf_Sequence_no__c limit 1];
        List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login'  order by acf_Sequence_no__c limit 1];
        system.debug('!#$%'+lstScript);
        if(lstScript <> null && lstScript.size()>0)
        {
            ScriptId = lstScript[0].id;
        }
     
     PreLoginQuestion();
         
    }
 
  public void PreLoginQuestion()
    {
      strmsg = '';
      if(MyAccountId<> null && MyAccountId<> '')
        {
            lstAcc = [select id,LastName,RecordTypeId,FirstName,PersonEmail,Is_Partner_Broker_Customer__c,PersonMobilePhone from Account where id=:MyAccountId];
            system.Debug('lstAccount-------------'+lstAcc);
           
        }
     lstWrapperQuestion.clear();
     lstMasterWrapperQuestion.clear();
     if(String.IsNotEmpty(LoanType))
     {
         objLead.Click_Loan_Type__c = LoanType;
     }
     system.Debug('LOanTYpe-------------'+LoanType);
     system.Debug('ScriptId-------------'+ScriptId);
     system.Debug('objLead.Click_Loan_Type__c-------------'+objLead.Click_Loan_Type__c);
     if(ScriptId <> null)
      {
     //   Cookie IsNewHomeLoan = ApexPages.currentPage().getCookies().get('IsNewHomeLoan');
     //     System.debug('****IsNewHomeLoan' +IsNewHomeLoan);
        lstScriptQuestion = [select id,acf_Stage_Name__c,acf_Sequence_No__c,acfBubble_Text__c,acfWatermark_Text__c from Question__c where acf_Script__c =:ScriptId and acf_Active__c = true order by acf_Sequence_No__c desc];
        
        if(objLead.Click_Loan_Type__c== 'New Purchase')
        { 
       /*      List<Question__c> lstNewHomeLoan =[select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                   acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                            
                                                       (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                       where (acf_Master_Question__c =null and acf_Script__c =:ScriptId and acf_Active__c = true and acfIs_New_Loan__c = true) order by acfNew_Loan_Sequence_No__c];
        //        intTotalQuestions = lstNewHomeLoan.size(); */   
                for(Question__c objQuestion:[select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                   acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                            
                                                       (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                       //where ((acf_Master_Question__r.acf_Script__c =: ScriptId or acf_Script__c =:ScriptId) and acf_Active__c = true and acfIs_New_Loan__c = true AND Click_Is_Broker_Question__c = true) order by acfNew_Loan_Sequence_No__c])
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
         else if(objLead.Click_Loan_Type__c== 'Refinance')
           {
           /*      List<Question__c> lstRefinance =[select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                   acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                            
                                                       (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                       where (acf_Master_Question__c =null and acf_Script__c =:ScriptId and acf_Active__c = true and acfIs_refinance__c = true) order by acfNew_Loan_Sequence_No__c];
        //          intTotalQuestions = lstRefinance.size(); */ 
                        for(Question__c objQuestion:[select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                                                                   acfBubble_Text__c,acfWatermark_Text__c,acfIs_refinance__c,acfRefinance_Sequence_No__c,                                                          
                                                       (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                       //where ((acf_Master_Question__r.acf_Script__c =: ScriptId or acf_Script__c =:ScriptId) and acf_Active__c = true and acfIs_refinance__c = true AND Click_Is_Broker_Question__c = true) order by acfRefinance_Sequence_No__c])
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
            system.Debug('lstMasterWrapperQuestion-------------'+lstMasterWrapperQuestion.size());
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
                    opplatlist = new List<Opportunity>();
                    opplatlist=[select Transaction_Type__c,Current_Lender__c,Current_Loan_Type__c,Current_Loan_Value__c from Opportunity where accountid =:MyAccountId limit 1];  
                    
                    system.debug('oppolist==>'+opplatlist);
                    system.debug('Myaccountid==>'+MyaccountId);

                    
                    if(objMasterQuestion.objWrapQuestion.acf_ApiName__c == 'Current_Lender__c')
                        objMasterQuestion.strWrapAnswer = opplatlist[0].Current_Lender__c;
                    
                    if(objMasterQuestion.objWrapQuestion.acf_ApiName__c == 'Current_Loan_Type__c')
                        objMasterQuestion.strWrapAnswer = opplatlist[0].Current_Loan_Type__c;
                    
                    if(objMasterQuestion.objWrapQuestion.acf_ApiName__c == 'acfLoan_Amount__c')
                        objMasterQuestion.strWrapAnswer = String.valueOf(opplatlist[0].Current_Loan_Value__c);
                    
                    if(objMasterQuestion.objWrapQuestion.acf_ApiName__c == 'Click_Loan_Type__c')
                        objMasterQuestion.strWrapAnswer = opplatlist[0].Transaction_Type__c;
                    
           
                    lstWrapperQuestion.add(objMasterQuestion); 
                    
                    
                 }
                  system.Debug('lstWrapperQuestion-------------'+lstWrapperQuestion);
                  system.Debug('Answer map1==>'+mapIdToAnswer);
           }
      }
  }  
     
    
    public PageReference saveLead()
    {
        
       //try
      // {

          InputHidden =true;
        system.Debug('lstWrapperQuestion================='+ lstWrapperQuestion+'===='+lstAcc);
        
        map<string,string> mapApiName = new map<string,string>();
        Id RecordTypeId;
        if(objLead.Click_Loan_Type__c == 'Refinance')
        {
            RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId(); 
        }else if(objLead.Click_Loan_Type__c == 'New Purchase')
        {
            IsNewpurchase=true;
            RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Click New Loans').getRecordTypeId(); 
        }
        
        Lead objInsertLead = new Lead();
        objInsertLead.acf_partner_account__c = lstAcc[0].id;
        objInsertLead.FirstName = lstAcc[0].FirstName;
        objInsertLead.LastName = lstAcc[0].LastName;
        objInsertLead.Email = lstAcc[0].PersonEmail;
        objInsertLead.Is_Partner_Broker_Customer__c = true;
        objInsertLead.Community__c=communityid;
        if(RecordTypeId  != null)
            objInsertLead.RecordTypeId  = RecordTypeId ;
        system.Debug('objInsertLead================='+ objInsertLead);
        objInsertLead.Click_Loan_Type__c = objLead.Click_Loan_Type__c;
        objInsertLead.MobilePhone = lstAcc[0].PersonMobilePhone;
        objInsertLead.Status = 'Open';
            
        system.Debug('lstWrapperQuestion================='+ lstWrapperQuestion);
        for(WrapperQuestions objWrappQuestion : lstWrapperQuestion)
        {
        
        
           if((objWrappQuestion.strWrapAnswer == null || objWrappQuestion.strWrapAnswer == '' || objWrappQuestion.strWrapAnswer == 'NONE') && objWrappQuestion.lstCheckBoxAnswer.size()==0) 
            {
                strmsg = 'Please fill answer for '+objWrappQuestion.objWrapQuestion.acf_Question__c;
                InputHidden = false;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,strmsg));
                return null;
            }
           if(objWrappQuestion.objWrapQuestion.acf_Type__c == 'Picklist' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'Button' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'RadioButton' )
            {       
               if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '' && objWrappQuestion.strWrapAnswer <> 'None')
               {
                 if(mapIdToAnswer.containsKey(objWrappQuestion.strWrapAnswer))
                 {
                       objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,mapIdToAnswer.get(objWrappQuestion.strWrapAnswer));
                 }
               }
            }
            else if(objWrappQuestion.objWrapQuestion.acf_Type__c == 'Number' || objWrappQuestion.objWrapQuestion.acf_Type__c == 'Percent')
            {
                if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '')
                {
                      objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,Decimal.valueOf(objWrappQuestion.strWrapAnswer));
                }
            }
            else if( objWrappQuestion.objWrapQuestion.acf_Type__c == 'Currency')
            {
                if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '')
                {
                     objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,Double.valueOf(objWrappQuestion.strWrapAnswer));
                }
            }
            else
            {
                if(objWrappQuestion.strWrapAnswer <> null && objWrappQuestion.strWrapAnswer <> '')
                {
                      objInsertLead.put(objWrappQuestion.objWrapQuestion.acf_ApiName__c,string.valueof(objWrappQuestion.strWrapAnswer));
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
        if(String.IsNotEmpty(objInsertLead.Id))
         {
          IsInsertedId= objInsertLead.Id;
 
         }
         system.Debug('objInsertLead================='+ objInsertLead);
        
        string Feedback = ClickEnablePortalUserFromCRM.createPortalUserFromCRMWithAccounts(MyAccountId,objInsertLead.FirstName,objInsertLead.LastName,objInsertLead.Email,objInsertLead.MobilePhone,objInsertLead.id,communityid);
        //string feedback='';
        
        if(Feedback.contains('Portal user created.') || Feedback == '')
        {
           
              updateAccount();
              system.Debug('objInsertLead================='+ objInsertLead);
              PageReference pg = new PageReference('/apex/BrokerClickPostloginQuestionnaires?cid='+ MyAccountId);
              pg.setRedirect(true);
              return pg;
        }
        else
        {
             strmsg = 'Email already Exist, Please use different one.';
             InputHidden = false;
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Email already Exist, Please use different one.'));
             delete objInsertLead;
             return null;
        }
    // }
    /* catch(Exception e ) 
      {
           
            if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
               if(objLead.Click_Loan_Type__c== 'New Purchase')
               {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter "Principal and Interest" or "Interest Only" in "What is your preferred repayment method?"'));
                    return null;
                }
               
               else if (objLead.Click_Loan_Type__c== 'Refinance')
               {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter "Principal and Interest" or "Interest Only" in "What is your current payment type?"'));
                    return null;
               }
             }
            else
            {
                   e.getMessage();
                   system.debug('Ankit*******'+e.getMessage());
                   return null;
            }
            return null;
        }    */       
    }
    
    public void updateAccount()
    {
         List<Account> lstAccount = new List<Account>();
         //Id LeadOwnerId = userInfo.getuserId();
         Id RecordTypeId=null;
         if(IsNewpurchase==true)
          RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Click New Loans').getRecordTypeId();
         else
          RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId();    
         if(lstAcc[0].RecordTypeId <> null && lstAcc[0].RecordTypeId <> RecordTypeId ) 
         {   
             Account objAcc = new Account(id = lstAcc[0].id);
             objAcc.RecordTypeId = RecordTypeId;
             objAcc.Is_Partner_Broker_Customer__c = true;
             objAcc.acf_Lead__pc=IsInsertedId;
             objAcc.Partner_User__c = userInfo.getuserId();
             objAcc.Click_Community_Setup__c=communityid;
             //if(LeadOwnerId != null)
               //  objAcc.OwnerId = LeadOwnerId;
             lstAccount.add(objAcc);
         }
         
         if(lstAccount <> null && lstAccount.size() > 0 )
         {
             update lstAccount;
         }
      system.Debug('lstAccount================='+ lstAccount);
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
    
    public List<SelectOption> getBankNames()
    {  
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c from acfBank_Detail__c where click_Show_on_Current_Lender_question__c = true];
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
    
    public List<string> getBankNamesAutosugest()
    {  
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c from acfBank_Detail__c where click_Show_on_Current_Lender_question__c = true];
        List<string> banksname= new List<string>();
        
        for(acfBank_Detail__c ob: lstBank ){
         banksname.add(ob.acfBank_Name__c);
        }
        
        return banksname;
    }
  
 }