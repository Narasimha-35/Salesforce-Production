//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#      Date                    Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0         25-03-2016              Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
// This Batch Class is used to create Income and Expense for Existing Record
// --------------------------------------------------------------------------------------------
global class createIncomeandExpenseForExistingRecord implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select id,acfAnnual_profit_income__c,acf_applicant_Monthlly_Salary__c,';
               query +='clickApp_1_Monthly_Expenses__c from click_Applicant__c ';
               query +='where (acf_applicant_Monthlly_Salary__c != null OR acfAnnual_profit_income__c != null ';
               query +='OR clickApp_1_Monthly_Expenses__c != null)';
        return Database.getQueryLocator(query);
       }   
   
   global void execute(Database.BatchableContext BC, List<click_Applicant__c> lstApp) {
        list<Income_And_Expense__c> lstIncomeandExp = new list<Income_And_Expense__c>();
        Id ExpenseRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Expense').getRecordTypeId();
        Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Income').getRecordTypeId();
                
        if(lstApp != null && lstApp.size() > 0)
        {
            for(click_Applicant__c objapp : lstApp)
            {
               if(objapp.acfAnnual_profit_income__c != null && objapp.acfAnnual_profit_income__c != '')
                {
                    string stramount = objapp.acfAnnual_profit_income__c.replaceAll('[a-zA-Z]','');
                    Income_And_Expense__c objIncome = new Income_And_Expense__c();
                    objIncome.Amount__c = integer.valueof(stramount.replaceAll(',',''));
                    objIncome.acfDetails__c='Business Income';
                    objIncome.Applicant__c = objapp.id;
                    objIncome.RecordtypeId = IncomeRecordTypeId;
                    objIncome.Category__c = 'Self Employed';
                    lstIncomeandExp.add(objIncome);
                }
                if(objapp.acf_applicant_Monthlly_Salary__c != null)
                {
                    Income_And_Expense__c objIncome = new Income_And_Expense__c();
                    objIncome.Amount__c = objapp.acf_applicant_Monthlly_Salary__c;
                    objIncome.acfDetails__c='Base Salary';
                    objIncome.Applicant__c = objapp.id;
                    objIncome.RecordtypeId = IncomeRecordTypeId;
                    objIncome.Category__c = 'Full Time - PAYG';
                    lstIncomeandExp.add(objIncome);
                }
                if(objapp.clickApp_1_Monthly_Expenses__c != null)
                {
                    Income_And_Expense__c objIncome = new Income_And_Expense__c();
                    objIncome.Amount__c = objapp.clickApp_1_Monthly_Expenses__c;
                    objIncome.acfDetails__c='Living Expenses';
                    objIncome.Applicant__c = objapp.id;
                    objIncome.RecordtypeId = ExpenseRecordTypeId;
                    objIncome.Category__c = 'Basic Living Expense';
                    lstIncomeandExp.add(objIncome);
                }
            }  
        }
        if(lstIncomeandExp != null && lstIncomeandExp.size() > 0)
        {
           insert lstIncomeandExp; 
        }     
    }

    global void finish(Database.BatchableContext BC) {

    }
}