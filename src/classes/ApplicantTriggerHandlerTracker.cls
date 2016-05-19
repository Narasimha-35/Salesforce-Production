@isTest
private class ApplicantTriggerHandlerTracker{

private static Income_And_Expense__c objIncomeExpense;
private static Account objAccount;
private static Financials_Source__c objFinancialSource;
private static click_Applicant__c objApplicant;
private static Asset_And_Liability__c objAssetLiab;
private static Id recordtypeID;
 static testMethod void createApplicant(){
 
 string strExpenseAPI = system.label.acfExpense_API;
 
      ACFSwitch__c acfswitch = new ACFSwitch__c();
       acfswitch.Applicant_Trigger_Switch__c = true;
       insert acfswitch;
 
 /* Set<String> StrIncomeCategories = new set<string>();
     StrIncomeCategories.add('Full Time - PAYG');
     StrIncomeCategories.add('Basic Living Expense');
     StrIncomeCategories.add('Self Employed');
     */
 objAccount = new Account();
 objAccount = WLCommonTrackerClass.createAccount(objAccount);
 
 objApplicant = new click_Applicant__c();
 objApplicant = WLCommonTrackerClass.createApplicant(objApplicant,objAccount);
 
 objApplicant.click_Applicant_Number__c = 'APP5'; 
 objApplicant.acf_applicant_Annual_profit_income__c = '20000';
 objApplicant.acf_applicant_App_1_Monthly_Expenses__c = '3000';
 objApplicant.clickApp_1_Monthly_Expenses__c = 2400;
 objApplicant.acfEmployment_Type__c = 'Self Employed';
 // objApplicant.createdById = 'Customer Input';
 //objApplicant.lastmodifiedById = 'Customer Input';
 
 update objApplicant;
 
 objApplicant.acfEmployment_Type__c = 'Full Time - PAYG';
 update objApplicant;
 
 objApplicant.acf_applicant_App_1_Monthly_Expenses__c= '4003';
 update objApplicant;
 
 objApplicant.acfEmployment_Type__c = 'Full Time';
 update objApplicant;
 
 objIncomeExpense = new Income_And_Expense__c();
 objIncomeExpense = WLCommonTrackerClass.createIncomeExpense(objIncomeExpense,objApplicant);
 objIncomeExpense.Category__c = 'Full Time - PAYG';
 update objIncomeExpense;
 objIncomeExpense.Category__c = 'Self Employed';
 update objIncomeExpense;
 objIncomeExpense.Category__c = 'Basic Living Expense';
 update objIncomeExpense;
 
  ApplicantTriggerHandler objAppTrigHandler = new ApplicantTriggerHandler();
 // objAppTrigHandler.insertIncomeExpenses();
  
 update objIncomeExpense; 
 objAssetLiab = new Asset_And_Liability__c();
 objAssetLiab = WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
 
     
 
    List<Financials_Source__c> lstfinancialsource = new List<Financials_Source__c>();
    objFinancialSource = new Financials_Source__c();
    objFinancialSource.Amount__c = 10000;
    objFinancialSource.Income_And_Expense__c = objIncomeExpense.Id;
    objFinancialSource.Source__c = 'Customer Input';
    objFinancialSource.Asset_And_Liability__c = objAssetLiab.Id;
    lstfinancialsource.add(objFinancialSource);
    
    insert lstfinancialsource;
    system.debug(objFinancialSource.id != null);
  
    update objFinancialSource;
    
   // objAppTrigHandler.insertIncomeExpenses();
  //  objAppTrigHandler.updateFinancialSources();
 
 }


}