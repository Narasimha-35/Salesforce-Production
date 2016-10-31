trigger AccountTrigger on Account( 
    before insert, before update, before delete, 
    after insert, after update, after delete, after undelete) {
    // add switch in
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('Trigger_Switch_Account__c') != null && (Boolean) acfSwitch.get('Trigger_Switch_Account__c')) {
      new AccountTriggerHandler().run();
    }
    }