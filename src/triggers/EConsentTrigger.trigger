trigger EConsentTrigger on E_Consent__c (before insert, before update, before delete, 
    after insert, after update, after delete, after undelete) 
{
    // add switch in
    ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('E_Consent_Switch__c') != null && (Boolean) acfSwitch.get('E_Consent_Switch__c')) 
    {
      new EConsentTriggerHandler().run();
    }
}