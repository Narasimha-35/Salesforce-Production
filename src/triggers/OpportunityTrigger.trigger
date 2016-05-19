trigger OpportunityTrigger on Opportunity (before insert,before update,before delete,after insert,after update,after delete,after undelete) {
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('Mercury_AOL_Switch__c') != null && (Boolean) acfSwitch.get('Mercury_AOL_Switch__c')) {
        MercuryRecordUpdateHandler aolHandler = new MercuryRecordUpdateHandler();
        aolHandler.run();
    }
}