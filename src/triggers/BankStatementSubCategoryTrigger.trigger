//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0         04-05-2016              Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
trigger BankStatementSubCategoryTrigger on click_Bank_Statements_Sub_Category__c(after insert, after update, before delete, after delete,before insert,before update,after Undelete){
    //  add switch in
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('Bank_Statement_SubCategory_TriggerSwitch__c') != null && (Boolean) acfSwitch.get('Bank_Statement_SubCategory_TriggerSwitch__c')) 
    {
        new BankStatementSubCategoryTriggersHandler().run();
    }
}