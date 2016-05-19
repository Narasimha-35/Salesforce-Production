trigger AssetAndLiabilityTrigger on Asset_And_Liability__c ( 
    before insert, before update, before delete, 
    after insert, after update, after delete, after undelete) {
    //  add switch in
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('Asset_And_Liability_Switch__C') != null && (Boolean) acfSwitch.get('Asset_And_Liability_Switch__C')) {
      new AssetAndLiabilityTriggerHandler().run();
    }
    }