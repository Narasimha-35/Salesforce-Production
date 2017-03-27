@isTest
private class ApplicantTriggerHandlerTracker
    {
        private static Income_And_Expense__c objIncomeExpense;
        private static Account objAccount;
        private static Financials_Source__c objFinancialSource;
        private static click_Applicant__c objApplicant;
        private static Asset_And_Liability__c objAssetLiab;
        private static E_Consent__c objEconsent;
        private static Required_Document__c objrequiredDoc;
        private static Document_Master__c objDocumentMaster;
        private static Id recordtypeID;
        private static task objTask;
        private static user objUser;
        private static Lead objLead;
        private static Contact objContact;
        private static opportunity objOpportunity ;
        private static Document_Master__c docobj;
        private static Required_Document__c reqobj;
       // private static acfTask_Master__c objTask;
    
    static testMethod void validate()
    {
       
        ACFSwitch__c acfswitch = new ACFSwitch__c();
        acfswitch.Applicant_Trigger_Switch__c = true;    
        insert acfswitch;
        
        loadData();
        objTask=new Task();
        //objTask.Description = objTaskMaster.acfDescription__c;
        objTask.WhatId = reqobj.id;
        objTask.Status = 'Open';
        objTask.Priority = 'Normal';
        objTask.ActivityDate = system.today();
        objTask.IsVisibleInSelfService = true;
        //insert objTask;
        
        Financials_Source__c financeobj=new Financials_Source__c();
        financeobj.Income_And_Expense__c=objIncomeExpense.id;
        financeobj.Amount__c=888;
        insert financeobj;
        financeobj.Amount__c=880;
        update financeobj;
        
        objApplicant.acf_create_from_custom_clone_button__C=false;
        objApplicant.clickApp_1_Monthly_Expenses__c =56;
        objApplicant.acfEconsent__c='I Consent';
        update objApplicant; 
      }
      
      static testMethod void validate1()
    {
       
        ACFSwitch__c acfswitch = new ACFSwitch__c();
        acfswitch.Applicant_Trigger_Switch__c = true;    
        insert acfswitch;
        
        loadDataNew();
        //objTask=new Task();
        //objTask.WhatId = reqobj.id;
        //objTask.Status = 'Open';
        //objTask.Priority = 'Normal';
        //objTask.ActivityDate = system.today();
        //objTask.IsVisibleInSelfService = true;
        //insert objTask;
        
        Financials_Source__c financeobj=new Financials_Source__c();
        financeobj.Income_And_Expense__c=objIncomeExpense.id;
        financeobj.Amount__c=888;
        insert financeobj;
        financeobj.Amount__c=880;
        update financeobj;
        
        objApplicant.acf_create_from_custom_clone_button__C=false;
        objApplicant.clickApp_1_Monthly_Expenses__c =56;
        objApplicant.acfEconsent__c='I Consent';
        update objApplicant; 
      }
       
    static void loadData()
    {
        createLead();
        createAccount();
        createContact();
        createuser();
        createOpportunity();
        createApplicant();
        createEconsent();
        createIncomeAndExpenses(); 
    }
    
    static void loadDataNew()
    {
        createLead();
        createAccount();
        createContact();
        createuser();
        createOpportunity();
        createApplicantNew();
        createEconsent();
        createIncomeAndExpenses(); 
    }
    
    static void createLead()
    {
        objLead=new Lead();
        objLead=WLCommonTrackerClass.createLead(objLead);
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','88','test@gmail.com',objLead.id);
        objAccount.acfAsset_House_Worth__c=55;
        update objAccount; 
    }
    
      static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
      static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }

    static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);      
    }
    static void createApplicant()
    {
        objApplicant=new click_Applicant__c ();
        objApplicant.clickOpportunity__c = objOpportunity.id;
        //objApplicant.acfAnnual_profit_income__c = 3250;
        objApplicant.acf_applicant_Monthlly_Salary__c = 45;
        objApplicant.clickApp_1_Monthly_Expenses__c  = 654;
        objApplicant.click_Applicant_Number__c = '1';
        objApplicant.acf_applicant_DOB__c='10/06/2016';
        objApplicant.acfEconsent__c='test';
        objApplicant.acfRelationship_code__c='1';
        objApplicant.click_Account__c = objAccount.id;
        objApplicant.acf_Applicant_Name__c='Neha Gupta';
        objApplicant.acf_applicant_Employer_Name__c='test';
        insert objApplicant;
        
        docobj=new Document_Master__c ();
        docobj=WLCommonTrackerClass.createDocumentMaster(docobj);   
        reqobj=new Required_Document__c ();
        reqobj=WLCommonTrackerClass.createRequiredDocument(reqobj,docobj,objOpportunity);
        reqobj.Click_Applicant__c=objApplicant.id;
        reqobj.acfStatus__c='Verified';
        update reqobj;
    } 
    
    static void createApplicantNew()
    {
        objApplicant=new click_Applicant__c ();
        objApplicant.clickOpportunity__c = objOpportunity.id;
        objApplicant.acf_applicant_Monthlly_Salary__c = 45;
        objApplicant.acfAnnual_profit_income__c = '3250';
        objApplicant.clickApp_1_Monthly_Expenses__c  = 654;
        objApplicant.click_Applicant_Number__c = '1';
        objApplicant.acf_applicant_DOB__c='10/06/2016';
        objApplicant.acfEconsent__c='test';
        objApplicant.acfRelationship_code__c='1';
        objApplicant.click_Account__c = objAccount.id;
        objApplicant.acf_Applicant_Name__c='Neha Gupta';
        objApplicant.acf_applicant_Employer_Name__c='test';
        insert objApplicant;
    } 
    
    static void createEconsent()
    {
        objEconsent=new E_Consent__c();
        objEconsent=WLCommonTrackerClass.createEconsent(objApplicant);
    }
    
    static void createIncomeAndExpenses()
    {
        objIncomeExpense=new Income_And_Expense__c();
        objIncomeExpense=WLCommonTrackerClass.createIncomeExpense(objIncomeExpense,objApplicant);
    }
      
}