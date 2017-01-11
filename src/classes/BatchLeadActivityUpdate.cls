global without sharing class BatchLeadActivityUpdate implements Database.Batchable<sObject>, Database.AllowsCallouts {
	global BatchLeadActivityUpdate() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		//Get all tagged as update activity lead
		String query = 'Select Id, Name, Email From Lead where Is_Update_Activity__c = true and ConvertedDate = null';
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Lead> leads) { 
		if (leads != null && leads.size() > 0) {
			for (Lead lead : leads) {
				if (lead.Email != null) {
					PardotActivitiesUtilities.getPardoctVisitorActivities(lead.Email, lead);
				}
			}
		}
	}
	
	global void finish(Database.BatchableContext BC) { 
		
	}
}