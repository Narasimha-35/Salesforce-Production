@isTest
public with sharing class TestBatchAddCallFileToLead {

	private static testMethod void testBatch() {
		LeadToCallFileRule__c rule = createRule();
		insert rule;

		Lead testLead = TestUtilities.createLead();
		testLead.is_Updated__c = false;
		testLead.addToCallFileDate__c = Date.today();
		testLead.LeadToCallFileRule__c = rule.id;
		List<Lead> testLeadRecords = TestUtilities.createLeads(10, testLead);
		System.debug(testLeadRecords);
		ACFSwitch__c swh = ACFSwitch__c.getOrgDefaults();
		swh.LeadTriggerSwitch__c = false;
		upsert swh;
		System.debug(swh);
		insert testLeadRecords;

		Test.startTest();
		BatchAddCallFileToLead b = new BatchAddCallFileToLead();
		Database.executebatch(b, 10);
		Test.stopTest();

		System.debug(testLeadRecords);
	}

	private static LeadToCallFileRule__c createRule() {
		LeadToCallFileRule__c rule = new LeadToCallFileRule__c(name = 'test');
		rule.Delay_To_Call_File_Days__c = 1;
		rule.Exclude_Closed_And_Lost__c = true;
		rule.Exclude_Converted_Lead__c = true;
		rule.Exclude_Do_Not_Call__c = true;
		rule.Exclude_Do_Not_Email__c = true;
		rule.Is_Active_Rule__c = true;
		rule.Priority__c = 0;
		rule.Rule_Object__c = 'Rule_Object__c';
		return rule;
	}

}