trigger acfTriggerOnOpportunity on Opportunity (after insert , after update)
{
    acfTriggerOnOpportunityHandler objTrgOppHandler = new acfTriggerOnOpportunityHandler();
    if(trigger.isAfter && trigger.isInsert) {
        OpportunityStaticValue.increaseAfterInsertCount();
        if(OpportunityStaticValue.acfTriggerOnOpportunityAfterInsert > 1) return;
        objTrgOppHandler.OnAfterInsert(Trigger.new);
        objTrgOppHandler.createFundingPosition(Trigger.new);
    }

    if(trigger.isAfter && trigger.isUpdate) {
        OpportunityStaticValue.increaseAfterUpdateCount();
        if(OpportunityStaticValue.acfTriggerOnOpportunityAfterUpdate > 1) return;
        objTrgOppHandler.onAfterUpdate(trigger.new,trigger.oldMap);
        objTrgOppHandler.createFundingPosition(Trigger.new);
    }
}
