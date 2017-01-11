@isTest 
private class BankTemplateTriggerTracker {
    static testMethod void validate () {
       acfBank_Detail__c b = new acfBank_Detail__c(acfBank_Name__c ='Behind the Clou');
       insert b;
       acf_Bank_Template__c  bt = new acf_Bank_Template__c();
       
      // bt.Name = '';
       bt.Click_Loans_Bank_Detail__c  =  b.id;
       insert bt;
update bt;
      
      
    }
}