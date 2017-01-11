trigger TriggerOnOpportunitylineItem on OpportunityLineItem (before insert, before update, after delete, after insert, after update) {
  
  OpportunityLineItemTriggerHandler handler = new OpportunityLineItemTriggerHandler();

  if(Trigger.isBefore) {
    //if(Trigger.isInsert) obj.OnBeforeInsert(Trigger.new);
   // else if(Trigger.isUpdate) obj.OnBeforeUpdate(Trigger.new);
  }

  if(Trigger.isAfter) {
    if(Trigger.isInsert) {
     // obj.OnAfterInsert(Trigger.new, Trigger.newMap);

      //Servicing Cal
      handler.afterInsert(Trigger.newMap);
    } else if(Trigger.isUpdate) {
      //obj.OnAfterUpdate(Trigger.new);

      //Servicing Cal
      handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
    } else if(Trigger.isDelete) handler.afterDelete(Trigger.oldMap);
  }
  ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('Opportunity_Line_Item_Switch__c') != null && (Boolean) acfSwitch.get('Opportunity_Line_Item_Switch__c')) {
      new acfTriggerOnOpportunityLineItemHandler().run();
    }

}