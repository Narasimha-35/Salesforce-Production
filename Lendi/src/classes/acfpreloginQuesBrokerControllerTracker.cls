@isTest(SeeAllData=true)
public class acfpreloginQuesBrokerControllerTracker {
    
    public static Question__c objQuestion;
    public static Question__c objRelatedQuestion;
    public static Question__c objRelatedQuestion1;
    public static Script__c objScript;
    public static User objUser;
    public static acfBank_Detail__c objBankDetail;
    public static Answer__c objAnswer;
    public static Answer__c objRelatedQuestionAnswer;
    public static Answer__c objRelatedQuestionAnswer1;
    public static list<Answer__c> lstAnswer;
    public static Account objaccount;
    //private static acfBank_Detail__c objBankDetail;
    public static Lead objlead;
    
    public static testMethod void ValidateNewLoan()
    {
        
        objAccount = new Account();
        objAccount.firstname='testuser12345';
        objAccount.LastName= 'test2312';
        objaccount.PersonEmail='test1234566@gmail.com';
        objAccount.acfApproximately_how_much_is_your_house__pc = 12.00;
        objAccount.acfCurrent_Rate__pc = 10.20;
        objAccount.acfCurrent_Loan_Amount__pc = 10.00;
        objAccount.acfWhat_is_your_current_payment_type__pc ='Cash'; 
        
        insert objAccount;
        
        objBankDetail = new acfBank_Detail__c();
        objBankDetail.acfBank_Name__c = 'Bank of Statements';
        objBankDetail.acfBankSlugName__c = 'bank_of_statements';
        objBankDetail.click_Show_on_Current_Lender_question__c = true;
        insert objBankDetail;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objAccount.id;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        objOpportunity.Current_Lender__c=objBankDetail.id;
        insert objOpportunity;
        
         
        
        
        
        objScript= acfCommonTrackerClass.createScriptnew('Pre-Login');
        system.debug('!@#$%'+objScript.id);
        objLead = new Lead();
        objLead = acfCommonTrackerClass.createLeadForPortal();
        
        Question__c objQuest                 = new Question__c ();
        objQuest.acf_Question__c             = 'Who is your current lender?';
        objQuest.acf_Active__c               = true;
        objQuest.acfRefinance_Sequence_No__c = 1;
        objQuest.acf_Type__c                 = 'Button';
        objQuest.acfNew_Loan_Sequence_No__c  = 1;
        objQuest.acfIs_refinance__c          = true;
        objQuest.acf_Script__c               = objScript.id;
        objQuest.acfIs_New_Loan__c           = false;
        objQuest.acf_ApiName__c              = 'Current_Lender__c';
        objQuest.Click_Is_Broker_Question__c = false;
        //objQuest.Click_Is_Broker_Question__c = true;
        insert objQuest;
        
        
        //objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
        //objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
        //objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Text',true,false,objScript.id,'Current_Lender__c');
        objAnswer     = acfCommonTrackerClass.createAnswer(objQuest.id, null,'Westpac Bank');
        objBankDetail = acfCommonTrackerClass.createBankDetail();
        acf_PreLoginQuestionController objacfpreloginQuestionController = new acf_PreLoginQuestionController();
        objacfpreloginQuestionController.IsInsertedId=null;
        objacfpreloginQuestionController.pageId='';
        
        objacfpreloginQuestionController.AccountId=objAccount.id;
        objacfpreloginQuestionController.ScriptId=objScript.id;
        objacfpreloginQuestionController.strmsg='hello';
        objacfpreloginQuestionController.PreviousVal=false;
        objacfpreloginQuestionController.IsNewpurchase=true;
        objacfpreloginQuestionController.lstAcc=null;
        //objacfpreloginQuestionController.mapQuestionIdToQuestion=null;
        objacfpreloginQuestionController.lstSelectedAnswers=null;
        objacfpreloginQuestionController.BankNamesAutosugest=null;
        objacfpreloginQuestionController.setMyAccountId(objAccount.id);
        objacfpreloginQuestionController.strBubbleText='text';
        //objacfpreloginQuestionController.lstMasterWrapperQuestion=null; 
        acf_PreLoginQuestionController.WrapperQuestions obnew= new acf_PreLoginQuestionController.WrapperQuestions();
        obnew.objWrapQuestion=objQuestion;
        obnew.strWrapAnswer='true';
        obnew.strWrapAnswer='true';
        obnew.lstSelectOpt=new List<SelectOption>();
        obnew.lstRelatedQuestion= new List<acf_PreLoginQuestionController.WrapperQuestions>();
        obnew.lstSelectOptions=null;
        obnew.lstCheckBoxAnswer=null;
        objacfpreloginQuestionController.QuesNo=1;
        objacfpreloginQuestionController.iserror='false';
        objacfpreloginQuestionController.indexNo=2;
        objacfpreloginQuestionController.ScriptId=objScript.id;
        objacfpreloginQuestionController.MyAccountId=objaccount.id;
        objacfpreloginQuestionController.LoanType='Refinance';
        objacfpreloginQuestionController.MyAccountId=objaccount.id;
        objacfpreloginQuestionController.getBankNames();
        objacfpreloginQuestionController.PreLoginQuestion();
        objacfpreloginQuestionController.getMyAccountId();
        objacfpreloginQuestionController.getMyAccount();
        objacfpreloginQuestionController.setLoanType('Refinance');
        objacfpreloginQuestionController.getLoanType();
        objacfpreloginQuestionController.updateAccount();
        objacfpreloginQuestionController.saveLead();
        objacfpreloginQuestionController.getBankNamesAutosugest();
    }
    
    private static testMethod void ValidateNewLoan2()
    {
        
        objAccount = new Account();
        objAccount.firstname='testuser23423423';
        objAccount.LastName= 'test234234';
        objaccount.PersonEmail='test234234@gmail.com';
        objAccount.acfApproximately_how_much_is_your_house__pc = 12.00;
        objAccount.acfCurrent_Rate__pc = 10.20;
        objAccount.acfCurrent_Loan_Amount__pc = 10.00;
        objAccount.acfWhat_is_your_current_payment_type__pc ='Cash';         
        insert objAccount;
        
        objScript= acfCommonTrackerClass.createScriptnew('Pre-Login');
        system.debug('!@#$%'+objScript.id);
        objLead = new Lead();
        
        objLead = acfCommonTrackerClass.createLeadForPortal();
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Text',true,false,objScript.id,'Current_Lender__c');
        objAnswer     = acfCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
        objBankDetail = acfCommonTrackerClass.createBankDetail();
        acf_PreLoginQuestionController objacfpreloginQuestionController = new acf_PreLoginQuestionController();
        objacfpreloginQuestionController.QuesNo=1;
        objacfpreloginQuestionController.iserror='false';
        objacfpreloginQuestionController.indexNo=2;
        objacfpreloginQuestionController.ScriptId=objScript.id;
        objacfpreloginQuestionController.MyAccountId=objaccount.id;
        objacfpreloginQuestionController.LoanType='New Purchase';
        objacfpreloginQuestionController.MyAccountId=objaccount.id;
        objacfpreloginQuestionController.getBankNames();
        objacfpreloginQuestionController.PreLoginQuestion();
        objacfpreloginQuestionController.getMyAccountId();
        objacfpreloginQuestionController.getMyAccount();
        objacfpreloginQuestionController.setLoanType('Refinance');
        objacfpreloginQuestionController.getLoanType();
        objacfpreloginQuestionController.updateAccount();
        objacfpreloginQuestionController.saveLead();
    }
    
    
    
}