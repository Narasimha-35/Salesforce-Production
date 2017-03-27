//-------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------
// Version#    Date              Author                Description
// ------------------------------------- ------------------------------------------------------
// 1.0                       Dependra  Singh          Initial Version
// -------------------------------------------------------------------------------------------
trigger TriggerOnTransactionHandler on click_Bank_Statements_Transactions__c(after insert, after update, before delete, after delete,before insert,before update,after Undelete){
    TransactionHandler triggerHandler = new TransactionHandler();
    
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