@isTest(SeeAllData = false)
private class acfLoginTracker {
private static Question__c objQuestion;
private static Script__c objScript;
static private User objUser;
private static acfBank_Detail__c objBankDetail;
private static Answer__c objAnswer;
private static list<Answer__c> lstAnswer;
private static Contact objContact;
private static Account objAccount;
private static acfContentManagementSystem__c objContentManagementSystem;
private static acfContentManagementSystem__c objContentManagementSystem1;
private static acfContentManagementSystem__c objContentManagementSystem2;
private static acfContentManagementSystem__c objContentManagementSystem3;
private static acfContentManagementSystem__c objContentManagementSystem4;
private static acfContentManagementSystem__c objContentManagementSystem5;
private static RecordType objRT;

    static testMethod void validateacfLogin() 
    {
       LoadData();
       
        ClickHomeController.WrapperQuestions wrap = new ClickHomeController.WrapperQuestions();
        wrap.IsContinueDisplay = true;
      
        ClickHomeController objacfLogin = new ClickHomeController(); 
        list<acfContentManagementSystem__c> cms = new list<acfContentManagementSystem__c>();
        cms.add(objContentManagementSystem);
        cms.add(objContentManagementSystem1);
        cms.add(objContentManagementSystem2);
        objacfLogin.Refinance_loan_lst = cms;
     /* objacfLogin.strusername = 'swati.sharma@saasfocus.com';
        objacfLogin.strPassword = 'swatisharma10';
        objacfLogin.strforgotUsername = 'swati.sharma@saasfocus.com';*/
        objacfLogin.getStarted();
        objacfLogin.getStartedLast();
        objacfLogin.newHomeLoan();
     // objacfLogin.UserLogin();
        ClickHomeController.AutoCompleteBanklList('Bank of Statements');
        objacfLogin.LandingQuestion();        
     // objacfLogin.ResetPassword();
       
    }
    
    private static void LoadData()
    {
        createAccount();
        createContact();
        createuser();
        createBankDetail();        
        createContent(); 
        createScript();      
        createQuestion();                
   //     createAnswer();
            
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = acfCommontrackerClass.createAccount(objAccount);
    }
    
    static void createContact()
    {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = acfCommontrackerClass.createuser(objUser);
    }
    
    static void createBankDetail()
    {
        objBankDetail = new acfBank_Detail__c();
        objBankDetail = acfCommonTrackerClass.createBankDetail(objBankDetail);
    }
    
    static void createScript()
    {
  //      objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'Script__c' AND name= 'Pre-Login'];
        objScript = new Script__c();
  //      objScript.RecordTypeId = objRT.id;
        objScript = acfCommonTrackerClass.createScript('Post-Login');
        system.debug('swati' +objScript);
    }
    
    static void createQuestion()
    {
        objQuestion = new Question__c();
        objQuestion= acfCommonTrackerClass.createQuestion(objQuestion);
        
    }
    
    static void createContent()
    { 
       acfCMS_Page__c objcms = new acfCMS_Page__c();
       objcms.name = 'ClickHome BetterRates';
       objcms.acfDescription__c = 'test';
       objcms.acfHeading__c = 'ClickHome BetterRates';
       insert objcms;
         
    
        objContentManagementSystem = new acfContentManagementSystem__c();
        //objContentManagementSystem.Name='Test';
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'ClickHome';
        objContentManagementSystem.acfSectionName__c = 'how it works';
        objContentManagementSystem.acfSequence__c = 1;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 1;
        objContentManagementSystem.acfCMS_Page__c =objcms.id;

        insert objContentManagementSystem;
        
        acfCMS_Page__c objcms1 = new acfCMS_Page__c();
        objcms1.name = 'ClickHome Features';
        objcms1.acfDescription__c = 'test';
        objcms1.acfHeading__c = 'ClickHome Features';
        insert objcms1;
        
        objContentManagementSystem1 = new acfContentManagementSystem__c();
        //objContentManagementSystem.Name='Test';
        objContentManagementSystem1.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem1.acfPageName__c = 'ClickHome';
        objContentManagementSystem1.acfSectionName__c = 'features';
        objContentManagementSystem1.acfSequence__c = 2;
        objContentManagementSystem1.acfDescription__c = 'Online loans';
        objContentManagementSystem1.acfIs_Checked__c = true;
        objContentManagementSystem1.acfHeader_Sequance__c = 2;
        objContentManagementSystem1.acfCMS_Page__c =objcms1.id;

        insert objContentManagementSystem1;
        
        acfCMS_Page__c objcms2 = new acfCMS_Page__c();
        objcms2.name = 'ClickHome Refinance';
        objcms2.acfDescription__c = 'test';
        objcms2.acfHeading__c = 'ClickHome Refinance';
        insert objcms2;
        
        objContentManagementSystem2 = new acfContentManagementSystem__c();
        //objContentManagementSystem.Name='Test';
        objContentManagementSystem2.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem2.acfPageName__c = 'common';
        objContentManagementSystem2.acfSectionName__c = 'Footer';
        objContentManagementSystem2.acfSequence__c = 3;
        objContentManagementSystem2.acfDescription__c = 'Online loans';
        objContentManagementSystem2.acfIs_Checked__c = true;
        objContentManagementSystem2.acfHeader_Sequance__c = 3;
        objContentManagementSystem2.acfCMS_Page__c =objcms2.id;

        insert objContentManagementSystem2;
        
        acfCMS_Page__c objcms3 = new acfCMS_Page__c();
        objcms3.name = 'ClickHome LoanSteps';
        objcms3.acfDescription__c = 'test';
        objcms3.acfHeading__c = 'ClickHome LoanSteps';
        insert objcms3;
        
        objContentManagementSystem3 = new acfContentManagementSystem__c();
        //objContentManagementSystem.Name='Test';
        objContentManagementSystem3.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem3.acfPageName__c = 'common';
        objContentManagementSystem3.acfSectionName__c = 'Refinance Loan';
        objContentManagementSystem3.acfSequence__c = 4;
        objContentManagementSystem3.acfDescription__c = 'Online loans';
        objContentManagementSystem3.acfIs_Checked__c = true;
        objContentManagementSystem3.acfHeader_Sequance__c = 4;
        objContentManagementSystem3.acfCMS_Page__c =objcms3.id;

        insert objContentManagementSystem3;
        
                
        acfCMS_Page__c objcms4 = new acfCMS_Page__c();
        objcms4.name = 'ClickHome Team';
        objcms4.acfDescription__c = 'test';
        objcms4.acfHeading__c = 'ClickHome Team';
        insert objcms4;
        
        objContentManagementSystem4 = new acfContentManagementSystem__c();
        //objContentManagementSystem.Name='Test';
        objContentManagementSystem4.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem4.acfPageName__c = 'common';
        objContentManagementSystem4.acfSectionName__c = 'Refinance Loan';
        objContentManagementSystem4.acfSequence__c = 4;
        objContentManagementSystem4.acfDescription__c = 'Online loans';
        objContentManagementSystem4.acfIs_Checked__c = true;
        objContentManagementSystem4.acfHeader_Sequance__c = 4;
        objContentManagementSystem4.acfCMS_Page__c =objcms4.id;

        insert objContentManagementSystem4;
        
                
        acfCMS_Page__c objcms5 = new acfCMS_Page__c();
        objcms5.name = 'ClickHomeRateInSeconds';
        objcms5.acfDescription__c = 'test';
        objcms5.acfHeading__c = 'ClickHomeRateInSeconds';
        insert objcms5;
        
        objContentManagementSystem5 = new acfContentManagementSystem__c();
        //objContentManagementSystem.Name='Test';
        objContentManagementSystem5.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem5.acfPageName__c = 'common';
        objContentManagementSystem5.acfSectionName__c = 'Refinance Loan';
        objContentManagementSystem5.acfSequence__c = 4;
        objContentManagementSystem5.acfDescription__c = 'Online loans';
        objContentManagementSystem5.acfIs_Checked__c = true;
        objContentManagementSystem5.acfHeader_Sequance__c = 4;
        objContentManagementSystem5.acfCMS_Page__c =objcms5.id;

        insert objContentManagementSystem5;
        
        
        document objdoc = new document();
        objdoc.name = 'Refinance BG Image';
        objdoc.FolderId = UserInfo.getUserId();
        insert objdoc;
        
        document objdoc1 = new document();
        objdoc1.name = 'Better Rates BG Image';
        objdoc1.FolderId = UserInfo.getUserId();
        insert objdoc1;
        
        document objdoc2 = new document();
        objdoc2.name = 'Team BG Image';
        objdoc2.FolderId = UserInfo.getUserId();
        insert objdoc2;
        
        Script__c objscr = new Script__c();
        objscr.acf_Sequence_no__c = 1;
        objscr.acf_Type__c= 'Pre-Login'; 
        insert objscr ;
        
        Question__c objQues = new Question__c ();
        objQues.acf_Question__c = 'Who is your current lender?';
        objQues.acf_Active__c = true;
        objQues.acf_Sequence_No__c = 2.0;
        objQues.acf_Type__c = 'Button';
        objQues.acfRefinance_Sequence_No__c = 1;
        objQues.acfIs_refinance__c = true;
        objQues.acf_Script__c = objscr.id;
        insert objQues;
    }
    
    
    
    static void createAnswer()
    {
        objAnswer = new Answer__c();
        lstAnswer = new list<Answer__c>();
        objAnswer.acf_Question__c = objQuestion.id;
        objAnswer.acf_Related_Question__c = objQuestion.id;
        objAnswer.acf_Answer__c = 'test';
        objAnswer.acfSequence_No__c = 1;
        //objAnswer = acfCommonTrackerClass.createAnswer(objAnswer);
        lstAnswer.add(objAnswer);
        insert lstAnswer;
    }
}