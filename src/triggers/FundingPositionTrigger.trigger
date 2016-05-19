trigger FundingPositionTrigger on Funding_Position__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('Fund_Position_Trigger_Switch__c') != null && (Boolean) acfSwitch.get('Fund_Position_Trigger_Switch__c')) {
      new FundingPositionTriggerHandler().run(); 
    }
}