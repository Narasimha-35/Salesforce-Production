global without sharing class BatchAddCallFileToLead implements Database.Batchable<sObject> {

	global BatchAddCallFileToLead() {
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		LeadSelector selector = new LeadSelector();
		String query = selector.getQueryPartOne() + 'WHERE Is_Updated__c = false AND AddToCallFileDate__c = today LIMIT 10000';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Lead> scope) {
		List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();

		List<Lead> updateList = new List<Lead>();
		for(Lead l : scope) {
			if(l.LeadToCallFileRule__c != null) {
				LeadToCallFileRule__c rule = LeadToCallFileDAO.getLeadToCallFileRuleById(l.LeadToCallFileRule__c);
				boolean isFittedRule = LeadToCallFileUtilities.checkIfLeadFitTheRule(l, rule);
				System.debug('isFittedRule ' + isFittedRule);
				if (isFittedRule) {
					l.vhc__CallFile__c = rule.Call_File__c;
					l.Is_Updated__c = true;
					l.AddToCallFileDateCheck__c = true;
					updateList.add(l);
				}
			}
		}

		update updateList;
	}

	global void finish(Database.BatchableContext BC) {

	}

}
