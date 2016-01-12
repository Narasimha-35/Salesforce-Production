@isTest(SeeAllData=true)
private class WLpreloginQuestionControllerTracker {
private static Question__c objQuestion;
private static Question__c objRelatedQuestion;
private static Question__c objRelatedQuestion1;
private static Script__c objScript;
static private User objUser;
private static ACFBank_Detail__c objBankDetail;
private static Answer__c objAnswer;
private static Answer__c objRelatedQuestionAnswer;
private static Answer__c objRelatedQuestionAnswer1;
private static list<Answer__c> lstAnswer;

private static testMethod void ValidateNewLoan()
{
  objScript     = WLCommonTrackerClass.createScript('Pre-Login');
  system.debug('!@#$%'+objScript.id);
  objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'Current_Lender__c');
  objBankDetail = WLCommonTrackerClass.createBankDetail();
  Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','true','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
    Cookie Bname = new Cookie('Bname','Westpac Bank',null,72000,true); 
    WLpreloginQuestionController objacfpreloginQuestionController = new WLpreloginQuestionController();
    objacfpreloginQuestionController.RelatedQuestions();
}
private static testMethod void ValidateBankName()
{
  objScript     = WLCommonTrackerClass.createScript('Pre-Login');
  system.debug('!@#$%'+objScript.id);
  objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
    objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
    objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,'Current_Lender__c');
    objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
  objBankDetail = WLCommonTrackerClass.createBankDetail();
  //Setting Cookie for New Loan.
  Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','false','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
    //Setting Cookie For bank Name.
    Cookie Bname = new Cookie('Bname','Westpac Bank',null,72000,true); 
    ApexPages.currentPage().setCookies( new Cookie[]{Bname});
    WLpreloginQuestionController objacfpreloginQuestionController = new WLpreloginQuestionController();
}


private static testMethod void ValidateReFinance()
{
  objScript     = WLCommonTrackerClass.createScript('Pre-Login');
  system.debug('!@#$%'+objScript.id);
  objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
    objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
    objRelatedQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,'Current_Lender__c');
    
    objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, objRelatedQuestion.id,'Westpac Bank');
    objRelatedQuestionAnswer = WLCommonTrackerClass.createAnswer(objRelatedQuestion.id, null ,'Westpac Bank');
         
  objBankDetail = WLCommonTrackerClass.createBankDetail();
  //Setting Cookie for New Loan.
  Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','false','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
    //Setting Cookie For bank Name.
    Cookie Bname = new Cookie('Bname','Westpac Bank',null,72000,true); 
    ApexPages.currentPage().setCookies( new Cookie[]{Bname});
    //Setting Cookie For Questions
    Cookie ACFQues = new Cookie('ACFQues',objQuestion.id + '-:-' +objAnswer.id+'-,-',null,72000, false); 
    ApexPages.currentPage().setCookies( new Cookie[]{ACFQues});
    WLpreloginQuestionController objacfpreloginQuestionController = new WLpreloginQuestionController();
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    if(objacfpreloginQuestionController.lstWrapperQuestion <> null && objacfpreloginQuestionController.lstWrapperQuestion.size()>0)
        objacfpreloginQuestionController.lstWrapperQuestion[0].strWrapAnswer = objAnswer.id;
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    objacfpreloginQuestionController.RelatedQuestions();
    //objacfpreloginQuestionController.lstWrapperQuestion[0].lstRelatedQuestion[0].strWrapAnswer = objRelatedQuestionAnswer.id;
    
    objacfpreloginQuestionController.AddingRelatedQuestion();
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    if(objacfpreloginQuestionController.lstWrapperQuestion != null && objacfpreloginQuestionController.lstWrapperQuestion.size()>0)
        objacfpreloginQuestionController.lstWrapperQuestion[0].lstCheckBoxAnswer = new List<string>();
    //objacfpreloginQuestionController.lstWrapperQuestion[0].lstRelatedQuestion[0].lstCheckBoxAnswer = new List<string>();
    objacfpreloginQuestionController.NextQuestion();
    
     objacfpreloginQuestionController.indexNo = 1;
    objacfpreloginQuestionController.NextQuestion();
    objacfpreloginQuestionController.previousQuestion();
    acfpreloginQuestionController.AutoCompleteBanklList('Bank of Statements');
    objacfpreloginQuestionController.resumePreviousSession();
    objacfpreloginQuestionController.clearCookies(); 
}

private static testMethod void ValidateReFinance1()
{
  objScript     = WLCommonTrackerClass.createScript('Pre-Login');
  system.debug('!@#$%'+objScript.id);
  objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
   
    objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
  objBankDetail = WLCommonTrackerClass.createBankDetail();
  //Setting Cookie for New Loan.
  Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','false','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
    //Setting Cookie For bank Name.
    Cookie Bname = new Cookie('Bname','Westpac Bank',null,72000,true); 
    ApexPages.currentPage().setCookies( new Cookie[]{Bname});
    //Setting Cookie For Questions
    Cookie ACFQues = new Cookie('ACFQues',objQuestion.id + '-:-' +objAnswer.id+'-,-',null,72000, false); 
    ApexPages.currentPage().setCookies( new Cookie[]{ACFQues});
    WLpreloginQuestionController objacfpreloginQuestionController = new WLpreloginQuestionController();
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    if(objacfpreloginQuestionController.lstWrapperQuestion!= null && objacfpreloginQuestionController.lstWrapperQuestion.size()>0)
        objacfpreloginQuestionController.lstWrapperQuestion[0].strWrapAnswer = objAnswer.id;
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    objacfpreloginQuestionController.RelatedQuestions();
    //objacfpreloginQuestionController.lstWrapperQuestion[0].lstRelatedQuestion[0].strWrapAnswer = objRelatedQuestionAnswer.id;
    
    objacfpreloginQuestionController.AddingRelatedQuestion();
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    if(objacfpreloginQuestionController.lstWrapperQuestion!= null && objacfpreloginQuestionController.lstWrapperQuestion.size()>0)
    objacfpreloginQuestionController.lstWrapperQuestion[0].lstCheckBoxAnswer = new List<string>();
    //objacfpreloginQuestionController.lstWrapperQuestion[0].lstRelatedQuestion[0].lstCheckBoxAnswer = new List<string>();
    objacfpreloginQuestionController.NextQuestion();
    objacfpreloginQuestionController.previousQuestion();
    acfpreloginQuestionController.AutoCompleteBanklList('Bank of Statements');
    objacfpreloginQuestionController.resumePreviousSession();
    objacfpreloginQuestionController.clearCookies(); 
}

private static testMethod void ValidateReFinanceForCheckBoxValidate()
{
  objScript     = WLCommonTrackerClass.createScript('Pre-Login');
  system.debug('!@#$%'+objScript.id);
  objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Checkbox',true,false,objScript.id,'Current_Lender__c');
  objRelatedQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,'Current_Lender__c');
    objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
  objRelatedQuestionAnswer = WLCommonTrackerClass.createAnswer(objRelatedQuestion.id, null ,'Westpac Bank');
  objBankDetail = WLCommonTrackerClass.createBankDetail();
  //Setting Cookie for New Loan.
  Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','false','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
    //Setting Cookie For bank Name.
    Cookie Bname = new Cookie('Bname','Westpac Bank',null,72000,true); 
    ApexPages.currentPage().setCookies( new Cookie[]{Bname});
    //Setting Cookie For Questions
    Cookie ACFQues = new Cookie('ACFQues',objQuestion.id + '-:-' +objAnswer.id+'-,-',null,72000, false); 
    ApexPages.currentPage().setCookies( new Cookie[]{ACFQues});
    WLpreloginQuestionController objacfpreloginQuestionController = new WLpreloginQuestionController();
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    if(objacfpreloginQuestionController.lstWrapperQuestion != null && objacfpreloginQuestionController.lstWrapperQuestion.size()>0)
        objacfpreloginQuestionController.lstWrapperQuestion[0].lstCheckBoxAnswer.add(objAnswer.id);
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    objacfpreloginQuestionController.RelatedQuestions();
    //objacfpreloginQuestionController.lstWrapperQuestion[0].lstRelatedQuestion[0].strWrapAnswer = objRelatedQuestionAnswer.id;
    
    objacfpreloginQuestionController.AddingRelatedQuestion();
    objacfpreloginQuestionController.indexNo = 0;
    objacfpreloginQuestionController.QuesNo = 0;
    if(objacfpreloginQuestionController.lstWrapperQuestion != null && objacfpreloginQuestionController.lstWrapperQuestion.size()>0)
        objacfpreloginQuestionController.lstWrapperQuestion[0].lstCheckBoxAnswer = new List<string>();
    //objacfpreloginQuestionController.lstWrapperQuestion[0].lstRelatedQuestion[0].lstCheckBoxAnswer = new List<string>();
    objacfpreloginQuestionController.NextQuestion();
    objacfpreloginQuestionController.previousQuestion();
    acfpreloginQuestionController.AutoCompleteBanklList('Bank of Statements');
    objacfpreloginQuestionController.resumePreviousSession();
    objacfpreloginQuestionController.clearCookies(); 
}
}