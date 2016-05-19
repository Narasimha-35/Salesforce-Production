@isTest
private class createFinSourceForExistingRecordTracker {
    static testmethod void test()
     {
         Income_And_Expense__c objIncome = new Income_And_Expense__c();
         objIncome.Amount__c = 45.54;
         insert objIncome;
         Test.startTest();
         createFinancialSourceForExistingRecord obj = new createFinancialSourceForExistingRecord();
         Database.executeBatch(obj);
         Test.stopTest();
     }
}