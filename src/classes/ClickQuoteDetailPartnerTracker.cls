@isTest(SeeAllData = false)
private class ClickQuoteDetailPartnerTracker 
{   
    private static Lead objLead ;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    
    
    
    
    static testMethod void validate() 
    {
        LoadData();
        Click_Community_Setup__c objccs=new Click_Community_Setup__c();
        objccs.Name='ClickLoans';
        objccs.Click_Page_Prefix__c = 'Click';
        objccs.Click_Network_ID__c='0DB900000008Ptg';
        insert objccs;
        
        //    RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Variable'];
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Variable';
        //     objPro.Recordtype.Name = 'Variable';
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
        //objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
        //   objPro.acfRating__c = '1';
        insert objPro;
        
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 120000.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objPro.id;
        objLVR.acfLoan_Size__c = 10000.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 50.50;
        objLVR.clickLVR_From__c = 1.2;
        objLVR.acfApplication_Fee__c = 5000; 
        insert objLVR; 
        
        
        Script__c objScript = new Script__c();
        objScript.acf_Type__c = 'Post-Login';
        objScript.acf_Sequence_no__c = 1;
        insert objScript; 
        
        Question__c objQuestion = new Question__c ();
        objQuestion.acf_Question__c = 'Who is your current lender?';
        objQuestion.acf_Active__c = true;
        objQuestion.acf_Sequence_No__c = 2.0;
        objQuestion.acf_Type__c = 'Button';
        objQuestion.acfRefinance_Sequence_No__c = 1;
        objQuestion.acfIs_refinance__c = true;
        objQuestion.acf_Script__c = objScript.id;
        insert objQuestion;
        
            
            PageReference pageRef = new PageReference('http://www.google.com');
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('cid',objAccount.id);
            ClickQuoteDetail_partner.intWidth = 10;
            ClickQuoteDetail_partner.setProgressBarWidth(10,10,'BrokerClickPostloginQuestionnaires');
            ClickQuoteDetail_partner objclick = new ClickQuoteDetail_partner ();
            
            objclick.strLoanPurpose = 'test';
            objclick.decCurrLoanAmt = 10.01;
            objclick.decEstPropVal = 10.01;
            objclick.decBestRate = 10.01;
            objclick.decComparison = 10.01;
            objclick.decMonthlyPayment = 10;
            objclick.pge_name = 'test';
        
    }
    
    
    static testMethod void validate1() 
    {
        LoadData();
         Click_Community_Setup__c objccs=new Click_Community_Setup__c();
        objccs.Name='ClickLoans';
        objccs.Click_Page_Prefix__c = 'Click';
        objccs.Click_Network_ID__c='0DB900000008Ptg';
        insert objccs;
        //      RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Variable'];
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Variable';
        //       objPro.Recordtype.Name = 'Variable';
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
        //  objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
        //    objPro.acfRating__c = '1';
        insert objPro;
        
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 120000.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objPro.id;
        objLVR.acfLoan_Size__c = 10000.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 50.50;
        objLVR.clickLVR_From__c = 1.2;
        objLVR.acfApplication_Fee__c = 5000; 
        insert objLVR; 
        
        
        Script__c objScript = new Script__c();
        objScript.acf_Type__c = 'Post-Login';
        objScript.acf_Sequence_no__c = 1;
        insert objScript; 
        
        Question__c objQuestion = new Question__c ();
        objQuestion.acf_Question__c = 'Who is your current lender?';
        objQuestion.acf_Active__c = true;
        objQuestion.acf_Sequence_No__c = 2.0;
        objQuestion.acf_Type__c = 'Button';
        objQuestion.acfRefinance_Sequence_No__c = 1;
        objQuestion.acfIs_refinance__c = true;
        objQuestion.acf_Script__c = objScript.id;
        insert objQuestion;
        
            Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click New Loans');
            objLead.RecordTypeId = recorsTypeId;
            update objLead;
            
            PageReference pageRef = new PageReference('http://www.google.com');
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('cid',objAccount.id);
            ClickQuoteDetail_partner.intWidth = 10;
            ClickQuoteDetail_partner.setProgressBarWidth(10,10,'BrokerClickBankInfoDetails');
            ClickQuoteDetail_partner objclick = new ClickQuoteDetail_partner ();
            
            objclick.strLoanPurpose = 'test';
            objclick.decCurrLoanAmt = 10.01;
            objclick.decEstPropVal = 10.01;
            objclick.decBestRate = 10.01;
            objclick.decComparison = 10.01;
            objclick.decMonthlyPayment = 10;
            objclick.pge_name = 'test';
        
    }
    
    
    /*static testMethod void validate2() 
    {
        LoadData();
        
        //      RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Variable'];
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Variable';
        //       objPro.Recordtype.Name = 'Variable';
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
        //   objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
        //    objPro.acfRating__c = '1';
        insert objPro;
        
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 120000.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objPro.id;
        objLVR.acfLoan_Size__c = 10000.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 50.50;
        objLVR.clickLVR_From__c = 1.2;
        objLVR.acfApplication_Fee__c = 5000; 
        insert objLVR; 
        
        Script__c objScript= acfCommonTrackerClass.createScriptnew('Post-Login');        
        objScript.acf_Sequence_no__c = 1;
        
        Question__c objQuestion = new Question__c ();
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Button',true,false,objScript.id,'Current_Lender__c');
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestionsnew('Who is your current lender?',1,'Text',true,false,objScript.id,'Current_Lender__c');
        
        answer__c objAnswer=new answer__c();
        objAnswer     = acfCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
        
        
        
       
        
        
        
            PageReference pageRef = new PageReference('http://www.google.com');
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('cid',objAccount.id);
            ClickQuoteDetail_partner.intWidth = 10;
            ClickQuoteDetail_partner.currentLeadId=objLead.id;
        
        
        
        
            ClickQuoteDetail_partner.setProgressBarWidth(10,10,'BrokerClickid_verification');
            ClickQuoteDetail_partner.setProgressBarWidth(10,10,'BrokerClickBankInfoDetails');
        
        
            ClickQuoteDetail_partner objclick = new ClickQuoteDetail_partner ();
            objclick.strLoanPurpose = 'test';
            objclick.decCurrLoanAmt = 10.01;
            objclick.decEstPropVal = 10.01;
            objclick.decBestRate = 10.01;
            objclick.decComparison = 10.01;
            objclick.decMonthlyPayment = 10;
            objclick.pge_name = 'test';
        
    }*/
    static testMethod void validatefinal() {
        LoadData();
        PageReference pageRef = new PageReference('http://www.BrokerClickPostloginQuestionnaires.com');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid',objAccount.id);        
        ClickQuoteDetail_partner.setProgressBarWidth(10,12, 'BrokerClickPostloginQuestionnaires');
        
    }
    private static void LoadData()
    {
        createLead();
        createAccount();
        //createContact();
        //createUser();
        createOpportunity();
        
    }
    
    static void createLead()
    {
        objLead = new Lead();
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = recorsTypeId;
        objLead.acfOneTimePassword__c = '724715';
        objLead.acfApproximately_how_much_is_your_house__c = 100.01;
        objLead.acfLoan_Amount__c = 100.20;
        objLead.acfIs_Bank_Statement_Submitted__c = true;
        objLead.acfIs_Identity_Document_Submitted__c = true;
        objLead.acfIs_Post_Login_Ques_Attempted__c =true;
        objLead.acfIs_Identity_Document_Submitted__c =true;
        
        insert objLead;
        //   objLead = acfCommonTrackerClass.createLeadForPortal();
    }
    static void createAccount()
    { 
        objAccount = new Account();
        recordType   recType = [select id,name,sobjectType,ispersontype from recordType where ispersontype=true and sobjectType='account' limit 1];
        objAccount.recordtypeId=recType.id;
        objAccount.firstname='testname';
        objAccount.lastname='testname';
        objAccount.acf_Lead__pc=objLead.Id;
        
        insert objAccount;
    }
    static void createContact()
    {
        objContact = new Contact();
        objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createPartnerContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser.MobilePhone='+611234567890';
        
        objUser.contactId=objContact.Id;
        List<Profile> lstCommUserProfile = [select id,name from profile where name='Customize Partner User' limit 1];
        //List<Account>lstPersonContact = [select id,PersonContactId from Account where id=:ContactId];
        //User objUser = new User();
        objUser.FirstName = 'test';
        objUser.LastName = 'test';
        objUser.Alias  = ('test'+String.valueof(Math.random())).substring(0,5);
        objUser.LocaleSidKey = 'en_AU';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.MobilePhone = '+6145678904';
        objUser.Username = 'test@fakeEmail.com';
        objUser.Email = 'test@fakeEmail.com';
        objUser.ProfileId = lstCommUserProfile[0].id;
        //objUser.ContactId = lstPersonContact[0].PersonContactId;
        objuser.EmailEncodingKey = 'UTF-8';
        objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
        objUser.TimeZoneSidKey = 'Australia/Brisbane';
        objUser.acfIs_Password_Reset__c = true;
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
        objUser.setOptions(dlo);
        insert(objUser);
        objLead = new Lead();
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = recorsTypeId;
        objLead.acfOneTimePassword__c = '724715';
        objLead.acfIs_Post_Login_Ques_Attempted__c=false;
        objLead.acfIs_Bank_Statement_Submitted__c=false;
        objLead.acfIs_Identity_Document_Submitted__c=false;
        
        insert objLead;
    }
    
    static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        objOpportunity.acfBankdetailStatus__c = 'Skipped';        
        objOpportunity.AccountId = objAccount.id;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity;
    }
    
    
    
}