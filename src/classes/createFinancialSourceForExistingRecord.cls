//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#      Date                    Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0         25-03-2016              Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
// This Batch Class is used to create Financial Source for Existing Record
// --------------------------------------------------------------------------------------------
global class createFinancialSourceForExistingRecord implements Database.Batchable<sObject>{

 global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select id,Amount__c from Income_And_Expense__c';
        return Database.getQueryLocator(query);
       }  
       
 global void execute(Database.BatchableContext BC, List<Income_And_Expense__c> lstIncome) {
        List<Financials_Source__c> lstFinancial = new List<Financials_Source__c>();
        if(lstIncome != null && lstIncome.size() > 0)
        {
            for(Income_And_Expense__c objIncome : lstIncome)
            {
                Financials_Source__c obj = new Financials_Source__c();
                obj.Amount__c = objIncome.Amount__c;
                obj.Source__c = 'Customer Input';
                obj.Income_And_Expense__c = objIncome.id;
                lstFinancial.add(obj);
            }
        }
        if(lstFinancial != null && lstFinancial.size() > 0)
        {
           insert lstFinancial;   
        }
 
     }     
     
      global void finish(Database.BatchableContext BC) {
    }
 }