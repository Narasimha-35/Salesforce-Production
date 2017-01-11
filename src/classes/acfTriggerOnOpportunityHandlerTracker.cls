@isTest
private class acfTriggerOnOpportunityHandlerTracker
{

    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static Market__c objMarket;
    private static Broker__c  objBroker;
    private static Opportunity objOpp1;
    private static acfTask_Master__c objTaskMaster;
    private static OpportunityLineItem objOLI;
    private static LVR_Rate__c objLVR;
    private static Lead objLead;
    private static Product2 objProduct2;
    private static PricebookEntry objPBE;
    private static  Account objPersonAccount;
    private static Pricebook2 objPricebook;
    private static Click_Community_Setup__c  cmmset;
    private static Question__c objques;
    private static Script__c objscript;
    private static Document_Master__c  objDocumentMaster;
    private static Document_Master__c  objDocumentMasters;
    private static Required_Document__c objRequiredDocument;
    private static acfBank_Detail__c acobj;
    private static Answer__c objAnswer;
    
    static testMethod void validate()
    {
        Test.startTest();
        LoadData();
        Test.stopTest();
        objRequiredDocument = new Required_Document__c();
        objOpp1.Stagename = 'Application Taken';
        objOpp1.acf_Status__c = 'Submitted' ;
        objOpp1.acfRequired_Document_Generation__c=true;
        objOpp1.acfBankdetailStatus__c='Skipped';
        update objOpp1; 
        objRequiredDocument = WLCommonTrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMasters,objOpp1);     
    }
    
    static testMethod void validate1()
    {
        LoadData();
        list<opportunity> lstopp = new list<opportunity>();
        lstopp.add(objOpp1);
        objRequiredDocument = new Required_Document__c();
        objRequiredDocument = WLCommonTrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMasters,objOpp1);
        acfTriggerOnOpportunityHandler objtriggerHandler = new acfTriggerOnOpportunityHandler();
        objtriggerHandler.updateExistingTaskStatus(lstopp);
    }
    
    private static void LoadData()
    {
        createLead();
        createTaskMaster();
        createContact();
        
        acobj=new acfBank_Detail__c();
        insert acobj;
        
        createProduct();
        createLVR();
        createMarket();
        createBroker();
        CreatePersonAccount();
        createUser();
        
        Funding_Position__c obj=new Funding_Position__c();
        obj.Account__c=objPersonAccount.id;
        insert obj;
        
        Asset_And_Liability__c objasset=new Asset_And_Liability__c();
        objasset.Account__c=objPersonAccount.id;
        insert objasset;
        
        click_Applicant__c clkobj=new click_Applicant__c();
        clkobj.click_Account__c=objPersonAccount.id;
        insert clkobj;
        
        createcommunitysetup();
        createDocumentMaster();
        objDocumentMasters = new Document_Master__c();       
        objDocumentMasters = WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
        objDocumentMasters.Click_Community_Setup__c = cmmset.id;
        update objDocumentMasters;
        
        createScript();
        createQuestion();
        createAnswer();
        createDependentDocument();
        createDependentProduct();
        
        Click_Loans_Bank__c objbank=new Click_Loans_Bank__c();
        objbank.name='test';
        objbank.Click_Loans_Bank_Detail__c=acobj.id;
        objbank.Community_Setup__c=cmmset.id;
        insert objbank;
        
        createPriceBook();
        createPricebookEntry();
        
        createOpportunity();
        
        createTask();
        createOLI();

    }  
     
        
    static void createAccount()
    {
        objAccount = new Account();
        objAccount.acfApproximately_how_much_is_your_house__pc = 10000000;
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
        objAccount.acfWhat_is_your_current_payment_type__pc='teee';
        update objAccount ;
    }
    
    static void CreatePersonAccount()
    {
        objPersonAccount =new Account();
        objPersonAccount = WLCommonTrackerClass.CreatePersonAccount('FName','LName','strPhone','strLeadEmail@gmail.com',objLead.Id);
        objPersonAccount.acfWhat_is_your_current_payment_type__pc='teee';
        objPersonAccount.acf_Applicant_Employment_Type__pc = 'Self Employed';
        objPersonAccount.acfAsset_House_Worth__c = 100000;
        update objPersonAccount ;
    }
    
     static void createLead()
    {
        objLead=new Lead();
        objLead=WLCommonTrackerClass.createLead(objLead);
    
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objPersonAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objPersonAccount.id);
    }
   
   static void createProduct()
   {
       objProduct2 = new Product2();
       objProduct2 = WLCommonTrackerClass.createProduct(objProduct2);  
       objProduct2.Click_Loans_Bank_Detail__c = acobj.id;
       update objProduct2;    
   }
  
    public static void createMarket()
    {
      objMarket = new  Market__c();
      objMarket.Market_Region__c = 'Adelaide';
      insert objMarket;
    }
    static void createBroker()
    {
      objBroker = new Broker__c();
      objBroker.Name = 'test';
      objBroker.Email__c = 'test@gmail.com';
      objBroker.Channel__c = 'Employee';
      objBroker.MobilePhone__c = '123456788';
      objBroker.Street_Address__c = 'test' ;
      objBroker.City__c = 'test';
      objBroker.Primary_Market__c = objMarket.id;
      objBroker.ACL_Licence__c = 'test';
      objBroker.Representative_Email__c = 'test@gmail.com';
      objBroker.ACL_EDR_Membership_No__c = 'test';
      objBroker.ACL_EDR_Scheme__c = 'test';
      objBroker.ACL_Email__c = 'test@gmail.com';
      objBroker.ACL_Holder__c =  'test';
      objBroker.Representative_Business_Address__c = 'testtexarea';
      objBroker.ACR__c = 'test';
      objBroker.ACL_Phone__c = '123456788';
      objBroker.ACR_EDR_Membership_No__c = 'test';
      objBroker.ACR_EDR_Expiry__c = System.Today();
      objBroker.ACR_EDR_Scheme_Name__c = 'test';
      insert objBroker;
    }
   
    static void createTaskMaster()
    {
        objTaskMaster = new acfTask_Master__c();
        objTaskMaster.acfIsActive__c = true;
        objTaskMaster.acfStage__c = 'Opportunity Creation';
        objTaskMaster.acfSubject__c = 'test';
        objTaskMaster.acfDescription__c = 'Testing task master description';
        insert objTaskMaster; 
        objTaskMaster.acfDescription__c='test';
        update objTaskMaster; 
    }
    
    static void createOpportunity()
    {
        objOpp1 = new Opportunity();
        objOpp1.acfProduct_LVR__c = objLVR.id;
        objOpp1.AccountID = objPersonAccount.id;
        objOpp1.name = 'test';
        objOpp1.Amount = 1235;
        objOpp1.acf_Status__c = 'Conditionally Approved' ;
        objOpp1.Stagename = 'Settlement';
        objOpp1.CloseDate = System.today();
        objOpp1.acfAsset_House_Worth__c = 200000;
        objOpp1.CurrentAssignedBroker__c = objBroker.id;
        objOpp1.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lendi').getRecordTypeId();
        objOpp1.acfRequired_Document_Generation__c=false;
        objOpp1.Community_Setup__c=cmmset.id;
        objOpp1.acfBankdetailStatus__c='Completed';
        objOpp1.acfEmployment_Type__c = 'Self Employed';
        insert objOpp1;
        
    }

  static void createTask()
  {        
        List<Task>lstTasktoInsert = new List<Task>();
        Task objTask = new Task();
        objTask.Description  = objTaskMaster.acfDescription__c;
        objTask.WhatId = objOpp1.id;    
        objTask.Status = 'open';
        objTask.Priority = 'Normal';
        objTask.ActivityDate = system.Today();
        objTask.IsVisibleInSelfService  = true;
        objTask.acf_Is_Upload_Bank_Stmt__c=true;
        objTask.subject = objTaskMaster.acfSubject__c;
        objTask.acf_Is_Upload_Identity_Verification__c=true;
        lstTasktoInsert.add(objTask);
        insert lstTasktoInsert;
        objTask.subject='test';
        update objTask; 
  }
  
  static void createLVR()
  {
      objLVR = new LVR_Rate__c();
      objLVR.acfProduct__c = objProduct2.id;
      objLVR.clickFixed_Interest_Rate__c = 0.7;
      objLVR.acfRate__c = 0.7;
      insert objLVR;
  }
         
  static void createPriceBook()
  {
      objPricebook = new PriceBook2();
      objPricebook.Name = 'Standard 1 yr price';
      objPricebook.Description = 'test';
      objPricebook.IsActive = true;
      //objPricebook.isstandard=true;
      insert objPricebook;
  }
  
  static void createPricebookEntry()
  {
     Id pricebookId = Test.getStandardPricebookId();
     objPBE = new PricebookEntry();
     objPBE.IsActive = true;
     objPBE.Pricebook2id = pricebookId;
     objPBE.Product2id = objProduct2.id;
     objPBE.UnitPrice = 200;
     insert objPBE;
  
  }
  
  static void createOLI()
  {
      objOLI = new OpportunityLineItem();
      List<OpportunityLineItem>lstOLI= new List<OpportunityLineItem>();
      objOLI.acfApplication_Fee__c = 100;
      objOLI.acfComparison_Rate__c = 5.1;
      objOLI.clickEstablishment_Fee__c  = 200;
      objOLI.acfLegal_Fees__c = 250;
      objOLI.acfLoan_Fees__c = 400;
      objOLI.acfOngoing_Fees__c = 450;
      objOLI.Click_Estimated_Monthly_Payment__c = 130;
      objOLI.click_Loan_Amount__c = 240;
      objOLI.Click_Loans_LVR_Rate__c = objLVR.id;
      objOLI.clickMonthly_Fees__c = 650;
      objOLI.clickMortgage_Risk_Fee__c = 240;
      objOLI.click_Purpose__c = 'Investment';
      objOLI.click_Type__c = 'Interest Only';
      objOLI.acfRate__c = 4.1;
      objOLI.Click_Tenure__c = '10 years';
      objOLI.clickTitle_Protection_Fee__c = 1000;
      objOLI.clickTotal_Upfront_Fee__c = 180;
      objOLI.acfValuation_Fee__c = 190;
      objOLI.Description = 'test';
      objOLI.OpportunityId = objOpp1.id;
      objOLI.lender__c = 'Bank of Melbourne';
      objOLI.TotalPrice = 190;
      objOLI.PriceBookEntryId = objPBE.id;
      objOLI.Quantity = 1;
      lstOLI.add(objOLI);
      insert lstOLI;
  }
  
    static void createcommunitysetup()
    {
        cmmset= new Click_Community_Setup__c ();
        cmmset=WLCommonTrackerClass.createcommunitysetup();
        cmmset.name='Lendi';
        update cmmset;
    }
    static void createScript()
    {
        objscript=new Script__c();
        objscript=WLCommonTrackerClass.createScript('test');
        objscript.Click_Community_Setup__c=cmmset.id;
        update objscript;
    }
    static void createQuestion()
    {
        objques=new Question__c ();
        objques.acf_Script__c=objscript.id;
        objques=WLCommonTrackerClass.createQuestion(objques);
        objques.acf_AccountApiName__c = 'acf_Applicant_Employment_Type__pc';
        objques.acfOpportunity_Api_Name__c = 'acfEmployment_Type__c';
        update objques;
    }
    static void createDocumentMaster()
    {
        objDocumentMaster = new Document_Master__c();       
        objDocumentMaster = WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
        objDocumentMaster.Click_Community_Setup__c = cmmset.id;
        update objDocumentMaster;
    }
    static void createAnswer()
    {
        objAnswer               = new Answer__c();
        objAnswer.acf_Question__c         = objques.id; 
        objAnswer.acf_Answer__c           = 'Self Employed';
        objAnswer.acfSequence_No__c = 1;
        insert objAnswer;
    }
    static void createDependentDocument()
    {
        Dependent_Document__c objDependentDoc  = new Dependent_Document__c();
        objDependentDoc.acfDocument_Master__c= objDocumentMaster.id; 
        objDependentDoc.name = 'test';
        objDependentDoc.acfAnswer__c = objAnswer.id;
        insert objDependentDoc;
    }
    
    static void createDependentProduct()
    {
        acfDependent_Product__c objDependentProduct  = new acfDependent_Product__c();
        objDependentProduct.acfProduct__c = objProduct2.id; 
        objDependentProduct.acfAnswer__c = objAnswer.id;
        objDependentProduct.acfFilter__c = 'Exclude';
        insert objDependentProduct;
    }
    
}