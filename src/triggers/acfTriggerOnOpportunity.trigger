trigger acfTriggerOnOpportunity on Opportunity (after insert , after update,before insert, before update)
{
    acfTriggerOnOpportunityHandler objTrgOppHandler = new acfTriggerOnOpportunityHandler();
    if((trigger.isBefore && trigger.isUpdate) || (trigger.isBefore && trigger.isInsert)) {
        //OpportunityStaticValue.increaseAfterUpdateCount();
       // if(OpportunityStaticValue.acfTriggerOnOpportunityAfterUpdate > 2) return;
        objTrgOppHandler.updateRequiredDocument(trigger.new,trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isInsert) {
        OpportunityStaticValue.increaseAfterInsertCount();
        if(OpportunityStaticValue.acfTriggerOnOpportunityAfterInsert > 2) return;
        objTrgOppHandler.OnAfterInsert(Trigger.new);
        objTrgOppHandler.createFundingPosition(Trigger.new);
    }

    if(trigger.isAfter && trigger.isUpdate) {
        OpportunityStaticValue.increaseAfterUpdateCount();
        if(OpportunityStaticValue.acfTriggerOnOpportunityAfterUpdate > 2) return;
        objTrgOppHandler.onAfterUpdate(trigger.new,trigger.oldMap);
        objTrgOppHandler.createFundingPosition(Trigger.new);
    }
    
}