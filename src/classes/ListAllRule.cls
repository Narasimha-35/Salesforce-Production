public class ListAllRule {
        public List<LeadToCallFileRule__c> rulesList {get; set;}
        public Boolean isZero {get; set;}
        
    public PageReference addNewRule() {
        LeadToCallFileRule__c newRule = new LeadToCallFileRule__c();
        insert newRule;
        PageReference newRuleSetPage = new PageReference('/apex/RuleSetDisplay?Id=' + newRule.Id);
        return newRuleSetPage;
    }

    public ListAllRule(ApexPages.StandardController controller) {
        rulesList = new List<LeadToCallFileRule__c>();
        List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllLeadToCallFileRules();
        if (rules.size() > 0) {
            isZero = false;
            rulesList = rules;
        }
    }

}