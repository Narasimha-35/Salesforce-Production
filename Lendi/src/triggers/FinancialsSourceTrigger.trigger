trigger FinancialsSourceTrigger  on Financials_Source__c (before insert, before update, before delete, 
    after insert, after update, after delete, after undelete) {
     new FinancialSourcecTriggerHandler().run();
}