@isTest
private class createIncomeandExpForExistRecordTracker {
    static testmethod void test()
     {
         click_Applicant__c objApp = new click_Applicant__c();
         objApp.acfAnnual_profit_income__c = '3234';
         objApp.acf_applicant_Monthlly_Salary__c = 45;
         objApp.clickApp_1_Monthly_Expenses__c  = 654.54;
         insert objApp;

         Test.startTest();
         createIncomeandExpenseForExistingRecord obj = new createIncomeandExpenseForExistingRecord ();
         Database.executeBatch(obj);
         Test.stopTest();
     }
}