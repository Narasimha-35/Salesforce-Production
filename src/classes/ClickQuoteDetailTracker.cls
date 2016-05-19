@isTest(SeeAllData = false)
private class ClickQuoteDetailTracker 
{   
    private static Lead objLead ;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;

    
    static testMethod void validate() 
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
       objScript.acf_Type__c = 'Pre-Login';
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
        
      System.runAs(objuser) 
        {
            
      PageReference pageRef = new PageReference('http://www.google.com');
      Test.setCurrentPage(pageRef);
      ClickQuoteDetail.intWidth = 10;
      ClickQuoteDetail.setProgressBarWidth(10,10,'ClickPostloginQuestionnaires');
      ClickQuoteDetail objclick = new ClickQuoteDetail ();
      objclick.strLoanPurpose = 'test';
      objclick.decCurrLoanAmt = 10.01;
      objclick.decEstPropVal = 10.01;
      objclick.decBestRate = 10.01;
      objclick.decComparison = 10.01;
      objclick.decMonthlyPayment = 10;
      objclick.pge_name = 'test';
     }
    }
    
        
    static testMethod void validate1() 
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
       objScript.acf_Type__c = 'Pre-Login';
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
        
      System.runAs(objuser) 
        {
            
      PageReference pageRef = new PageReference('http://www.google.com');
      Test.setCurrentPage(pageRef);
      ClickQuoteDetail.intWidth = 10;
      ClickQuoteDetail.setProgressBarWidth(10,10,'ClickBankInfoDetails');
      ClickQuoteDetail objclick = new ClickQuoteDetail ();
      objclick.strLoanPurpose = 'test';
      objclick.decCurrLoanAmt = 10.01;
      objclick.decEstPropVal = 10.01;
      objclick.decBestRate = 10.01;
      objclick.decComparison = 10.01;
      objclick.decMonthlyPayment = 10;
      objclick.pge_name = 'test';
     }
    }
    
    
      static testMethod void validate2() 
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
      
      
       Script__c objScript = new Script__c();
       objScript.acf_Type__c = 'Pre-Login';
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
        
      System.runAs(objuser) 
        {
            
      PageReference pageRef = new PageReference('http://www.google.com');
      Test.setCurrentPage(pageRef);
      ClickQuoteDetail.intWidth = 10;
     // ClickQuoteDetail.setProgressBarWidth(10,10,'Clickid_verification');
      ClickQuoteDetail objclick = new ClickQuoteDetail ();
      objclick.strLoanPurpose = 'test';
      objclick.decCurrLoanAmt = 10.01;
      objclick.decEstPropVal = 10.01;
      objclick.decBestRate = 10.01;
      objclick.decComparison = 10.01;
      objclick.decMonthlyPayment = 10;
      objclick.pge_name = 'test';
     }
    }
    
    private static void LoadData()
    {
        createLead();
        createAccount();
 //     createContact();
        createUser();
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
        //objLead.acfIs_Identity_Document_Submitted__c = true;
        //objLead.acfIs_Post_Login_Ques_Attempted__c =true;
        //objLead.acfIs_Identity_Document_Submitted__c =true;
        insert objLead;
 //   objLead = acfCommonTrackerClass.createLeadForPortal();
    }
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
    }
    
    static void createContact()
    {

      
        objContact = new Contact();
        objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser = acfCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    
}