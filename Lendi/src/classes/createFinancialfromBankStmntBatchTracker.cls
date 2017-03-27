@isTest
private class createFinancialfromBankStmntBatchTracker {
private static User objUser;
private static click_Applicant__c objApp;
private static Account objAccount;
private static Income_And_Expense__c objIncome;
private static Opportunity objOpportunity;
private static Required_Document__c objRequiredDocument;
private static Document_Master__c objDocumentMaster;
private static click_Bank_Statement_Data__c objBankStatCategory;
private static click_Bank_Statements_Sub_Category__c objBankStatSubCategory;
private static Lead objLead;
    static testmethod void test()
     {
         LoadData();
         Test.startTest();
         createFinancialSourcefromBankStmntBatch obj = new createFinancialSourcefromBankStmntBatch();
         Database.executeBatch(obj);
         Test.stopTest();
     }
     
    private static void LoadData()
    {
        createLead();
        createAccount();
        createApplicant();
        createIncomeandExpense();
        createUser();
        createOpportunity();
        createDocumentMaster();
        createRequiredDocument();
        createBankStatementCategory();
        createBankStatementSubCategory();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        list<lead> lstLead = [select id,isConverted from lead where id =: objLead.id];
        if(lstLead != null && lstLead.size()>0)
        {
            if(lstLead[0].isConverted == false)
                objAccount.acf_Lead__pc = lstLead[0].id;
        }
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createLead()
    {
        objLead = new Lead();
        objLead.isconverted = false;
        objLead = WLCommonTrackerClass.createLead(objLead);
    }

    static void createApplicant()
    {
         objApp = new click_Applicant__c();
         objApp.acfAnnual_profit_income__c = '3234';
         objApp.acf_applicant_Monthlly_Salary__c = 45;
         objApp.clickApp_1_Monthly_Expenses__c  = 654.54;
         objApp.click_Applicant_Number__c = '1';
         objApp.click_Account__c = objAccount.id;
         insert objApp;
    }
    
    static void createIncomeandExpense()
    {
         Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Income').getRecordTypeId();
         objIncome = new Income_And_Expense__c();
         objIncome.recordTypeId = IncomeRecordTypeId;
         objIncome.Amount__c = 45;
         objIncome.Category__c = 'Full Time - PAYG';
         objIncome.Applicant__c = objApp.Id;
         insert objIncome;
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
      list<Account> lstAccount = [select id from Account where personContactId =: objUser.ContactId limit 1];
      objOpportunity = new Opportunity();
      objOpportunity.AccountId =lstAccount[0].id;
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity =  WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
     static void createDocumentMaster()
    {
      objDocumentMaster = new Document_Master__c();
      objDocumentMaster =   WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
  
    }
    
    static void createRequiredDocument()
    {
        objRequiredDocument = new Required_Document__c ();  
        objRequiredDocument.Lead__c =  objLead.id;  
        objRequiredDocument = WLCommonTrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMaster,objOpportunity);
    }
    
     static void createBankStatementCategory()
    {
        objBankStatCategory = new click_Bank_Statement_Data__c();      
        objBankStatCategory.Name = 'Income';   
        insert objBankStatCategory;
    }
    
    static void createBankStatementSubCategory()
    {
        objBankStatSubCategory = new click_Bank_Statements_Sub_Category__c();      
        objBankStatSubCategory.Name = 'Wages'; 
        objBankStatSubCategory.Click_TransactionCount__c = '3';  
        objBankStatSubCategory.Click_Required_Document_Id__c = string.valueof(objRequiredDocument.Id);
        objBankStatSubCategory.click_monthAvg__c = '432';
        objBankStatSubCategory.Bank_Statement_Category__c = objBankStatCategory.id;
        insert objBankStatSubCategory;
    }
    
}