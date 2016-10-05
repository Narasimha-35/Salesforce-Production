//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Ankit Singh          Initial Version
// -------------------------------------------------------------------------------------------
trigger PepperLoanProductFeeTrigger on Pepper_Loan_Product_Fee__c(after insert, after update, before delete, after delete,before insert,before update,after Undelete){
    PepperLoanProductFeeTriggerHandler triggerHandler= new PepperLoanProductFeeTriggerHandler();
    
   if(Trigger.isAfter && Trigger.isInsert){
        triggerHandler.OnAfterInsert(trigger.new, null);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        triggerHandler.OnAfterUpdate(trigger.new, Trigger.oldMap,trigger.old);
    }
    
    if(trigger.isBefore && trigger.isDelete){
        triggerHandler.OnBeforeDelete(trigger.old, trigger.oldMap);
    }
    
    if(trigger.isAfter && trigger.isDelete){
        triggerHandler.OnAfterDelete(trigger.old, trigger.oldMap);
    }
    
    if(trigger.isBefore && trigger.isinsert){
        triggerHandler.OnBeforeInsert(trigger.new);
        
    }
    if(trigger.isBefore && trigger.isupdate){
        triggerHandler.OnBeforeUpdate(trigger.new,trigger.oldmap);
    }
}