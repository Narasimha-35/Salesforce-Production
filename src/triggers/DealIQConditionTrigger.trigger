trigger DealIQConditionTrigger on acfDealIQ_Condition__c ( 
    before insert, before update, before delete, 
    after insert, after update, after delete, after undelete) {
    // add switch in
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    system.debug(acfSwitch.get('Trigger_Switch_DealIQCondition__c'));
    if (acfSwitch != null && acfSwitch.get('Trigger_Switch_DealIQCondition__c') != null && (Boolean) acfSwitch.get('Trigger_Switch_DealIQCondition__c')) {
      new DealIQConditionTriggerHandler().run();
    }
}