trigger TriggerOnOpportunitylineItem on OpportunityLineItem (before insert, before update,after insert,after update,after delete) 
{
    acfTriggerOnOpportunityLineItemHandler obj = new acfTriggerOnOpportunityLineItemHandler();
    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
            system.debug('Before@@#$%');
            obj.OnBeforeInsert(trigger.new);
        }
        else if(trigger.isUpdate)
        {
            system.debug('Before@@#$%');
            obj.OnBeforeUpdate(trigger.new);
        }
    }
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            system.debug('After@@#$%');
            obj.OnAfterInsert(trigger.new,trigger.newMap);
        }
        else if(trigger.isUpdate)
        {
            system.debug('After@@#$%');
            obj.OnAfterUpdate(trigger.new);
        }
        
        else if(trigger.isDelete){
            system.debug('###called');
            obj.onAfterDelete(trigger.old,trigger.oldMap);
        }
    }
}