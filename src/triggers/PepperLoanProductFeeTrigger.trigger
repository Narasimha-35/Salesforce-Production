//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
trigger PepperLoanProductFeeTrigger on Pepper_Loan_Product_Fee__c(after insert, after update, before delete, after delete,before insert,before update,after Undelete){
    // add switch in
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('PepperLoanProductFeeTriggerSwitch__c') != null && (Boolean) acfSwitch.get('PepperLoanProductFeeTriggerSwitch__c')) {
      new PepperLoanProductFeeTriggerHandler().run();
    }
}