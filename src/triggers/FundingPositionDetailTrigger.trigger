trigger FundingPositionDetailTrigger on Funding_Position_Detail__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	 ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
    if (acfSwitch != null && acfSwitch.get('Funding_Position_Detail_Switch_Trigger__c') != null && (Boolean) acfSwitch.get('Funding_Position_Detail_Switch_Trigger__c')) {
      new FundingPositionDeatilTriggerHandler().run(); 
    }
}