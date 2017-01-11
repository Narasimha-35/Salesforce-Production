@isTest
public with sharing class TestMercuryOpportunityCleanUpBatch {

	private static testMethod void dummyTest() {
		insert TestMercuryUtility.testMercOppo;

		MercuryOpportunityCleanUpBatch b = new MercuryOpportunityCleanUpBatch();
		Database.executeBatch(b, 5);
	}

}