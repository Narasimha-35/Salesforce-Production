trigger acfTriggerOnOpportunity on Opportunity (after insert , after update) 
{
    acfTriggerOnOpportunityHandler objTrgOppHandler = new acfTriggerOnOpportunityHandler();
    if(trigger.isAfter && trigger.isInsert)
      objTrgOppHandler.OnAfterInsert(Trigger.new);
    if(trigger.isAfter && trigger.isUpdate)
    {
        objTrgOppHandler.onAfterUpdate(trigger.new,trigger.oldMap);
    }      
}