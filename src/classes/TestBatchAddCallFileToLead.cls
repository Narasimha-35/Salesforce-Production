@isTest
public with sharing class TestBatchAddCallFileToLead {

	private static testMethod void testBatch() {
		List<Lead> testLeadRecords = TestUtilities.createLeads(10);
		insert testLeadRecords;

		Test.startTest();

		Test.stopTest();
	}

}
