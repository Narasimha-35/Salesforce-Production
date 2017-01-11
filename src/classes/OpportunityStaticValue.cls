/*
* OpportunityStaticValue
*/

public with sharing class OpportunityStaticValue {
	public static Integer acfTriggerOnOpportunityAfterUpdate = 0;
	public static Integer acfTriggerOnOpportunityAfterInsert = 0;

	public static void increaseAfterUpdateCount() {
		acfTriggerOnOpportunityAfterUpdate++;
	}

	public static void increaseAfterInsertCount() {
		acfTriggerOnOpportunityAfterInsert++;
	}
}