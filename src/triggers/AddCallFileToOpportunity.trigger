trigger AddCallFileToOpportunity on Opportunity (before insert, before update) {
	
	List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveOpportunityToCallFileRules();
	 for (Opportunity oppo : trigger.new ) {
	 	OpportunityToCallFileUtilities.selectRightCallFileForOpportunity(oppo, rules);
	 }
}