trigger TriggerOnOpportunitylineItem on OpportunityLineItem (before insert, before update, after delete, after insert, after update) {
	acfTriggerOnOpportunityLineItemHandler obj = new acfTriggerOnOpportunityLineItemHandler();
	OpportunityLineItemTriggerHandler handler = new OpportunityLineItemTriggerHandler();

	if(Trigger.isBefore) {
		if(Trigger.isInsert) obj.OnBeforeInsert(Trigger.new);
		else if(Trigger.isUpdate) obj.OnBeforeUpdate(Trigger.new);
	}

	if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			obj.OnAfterInsert(Trigger.new, Trigger.newMap);

			//Servicing Cal
			handler.afterInsert(Trigger.newMap);
		} else if(Trigger.isUpdate) {
			obj.OnAfterUpdate(Trigger.new);

			//Servicing Cal
			handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
		} else if(Trigger.isDelete) handler.afterDelete(Trigger.oldMap);
	}

}
