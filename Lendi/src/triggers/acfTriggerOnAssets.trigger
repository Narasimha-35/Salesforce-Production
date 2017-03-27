trigger acfTriggerOnAssets on Asset_And_Liability__c (after insert,after update,after delete) 
{
    acfTriggerOnAssetsHandler objacfTriggerOnAssetsHandler = new acfTriggerOnAssetsHandler();
    if(trigger.isAfter&&trigger.isInsert)
    {
        objacfTriggerOnAssetsHandler.onAfterInsert(trigger.new);
    }
    if(trigger.isAfter&&trigger.isUpdate)
    {
        objacfTriggerOnAssetsHandler.onAfterUpdate(trigger.new,trigger.oldMap);
    }
    if(trigger.isAfter&&trigger.isDelete)
    {
        objacfTriggerOnAssetsHandler.onAfterDelete(trigger.old);
    }
}