trigger AddCallFileToOpportunity on Opportunity (before insert, before update) {

	List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveOpportunityToCallFileRules();
	System.debug(LoggingLevel.DEBUG, '[AddCallFileToOpportunity] rules: ' + rules);
	if(rules == null || rules.size() == 0) {
		System.debug(LoggingLevel.INFO, '[AddCallFileToOpportunity] there is no rule applys exit...');
		return;
	}
	for (Opportunity oppo : trigger.new ) {
		OpportunityToCallFileUtilities.selectRightCallFileForOpportunity(oppo, rules);
	}
}
