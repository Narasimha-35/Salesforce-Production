@isTest(SeeAllData=true)
private class LeadToCallFileDAOTest {

    static testMethod void leadToCallFileTest() {
        LeadToCallFileRule__c rule1 = new LeadToCallFileRule__c();
    	rule1.Rule_Name__c = 'test rule 1';
    	rule1.Is_Active_Rule__c = true;
    	rule1.Exclude_Do_Not_Call__c = true;
    	rule1.Exclude_Do_Not_Email__c = true;
    	rule1.Exclude_Closed_And_Lost__c = true;
    	rule1.Exclude_Converted_Lead__c = true;
    	rule1.Rule_Description__c = 'test description 1';
    	//rule1.Call_File__c = 'aaa';
    	rule1.Priority__c = 1;
    	insert rule1;
    	LeadToCallFileRule__c rule2 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule1.Id);
    	System.assertEquals(rule1.Priority__c, rule2.Priority__c);
    }
    
    static testMethod void getAllActiveLeadToCallFileRulesTest() {
    	List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();
    	LeadToCallFileRule__c rule1 = new LeadToCallFileRule__c();
    	rule1.Rule_Name__c = 'test rule 1';
    	rule1.Is_Active_Rule__c = true;
    	rule1.Exclude_Do_Not_Call__c = true;
    	rule1.Exclude_Do_Not_Email__c = true;
    	rule1.Exclude_Closed_And_Lost__c = true;
    	rule1.Exclude_Converted_Lead__c = true;
    	rule1.Rule_Description__c = 'test description 1';
    	//rule1.Call_File__c = 'aaa';
    	rule1.Priority__c = 1;
    	rule1.Rule_Object__c = 'Lead';
    	insert rule1;
    	List<LeadToCallFileRule__c> rules2 = LeadToCallFileDAO.getAllActiveLeadToCallFileRules();
    	System.assertEquals(rules.size() + 1, rules2.size());
    }
    
    static testMethod void getAllActiveOpportunityToCallFileRulesTest() {
    	List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllActiveOpportunityToCallFileRules();
    	LeadToCallFileRule__c rule1 = new LeadToCallFileRule__c();
    	rule1.Rule_Name__c = 'test rule 1';
    	rule1.Is_Active_Rule__c = true;
    	rule1.Exclude_Do_Not_Call__c = true;
    	rule1.Exclude_Do_Not_Email__c = true;
    	rule1.Exclude_Closed_And_Lost__c = true;
    	rule1.Exclude_Converted_Lead__c = true;
    	rule1.Rule_Description__c = 'test description 1';
    	//rule1.Call_File__c = 'aaa';
    	rule1.Priority__c = 1;
    	rule1.Rule_Object__c = 'Opportunity';
    	insert rule1;
    	List<LeadToCallFileRule__c> rules2 = LeadToCallFileDAO.getAllActiveOpportunityToCallFileRules();
    	System.assertEquals(rules.size() + 1, rules2.size());
    }
    
    static testMethod void getAllLeadToCallFileRules() {
    	List<LeadToCallFileRule__c> rules = LeadToCallFileDAO.getAllLeadToCallFileRules();
    	LeadToCallFileRule__c rule1 = new LeadToCallFileRule__c();
    	rule1.Rule_Name__c = 'test rule 1';
    	rule1.Is_Active_Rule__c = true;
    	rule1.Exclude_Do_Not_Call__c = true;
    	rule1.Exclude_Do_Not_Email__c = true;
    	rule1.Exclude_Closed_And_Lost__c = true;
    	rule1.Exclude_Converted_Lead__c = true;
    	rule1.Rule_Description__c = 'test description 1';
    	//rule1.Call_File__c = 'aaa';
    	rule1.Priority__c = 1;
    	insert rule1;
    	List<LeadToCallFileRule__c> rules2 = LeadToCallFileDAO.getAllLeadToCallFileRules();
    	System.assertEquals(rules.size() + 1, rules2.size());
    }
}