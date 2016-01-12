@isTest(SeeAllData=true)
private class ListAllRuleSetTest {

    static testMethod void myUnitTest() {
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
    	
    	// Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Id', rule1.Id);
        
    	ListAllRuleSet ruleSetController = new ListAllRuleSet();
    	System.assertEquals(ruleSetController.rule.Is_Active_Rule__c, rule1.Is_Active_Rule__c);
    	ruleSetController.rule.Is_Active_Rule__c = false;
    	ruleSetController.save();
    	rule1 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule1.Id);
    	System.assertEquals(rule1.Is_Active_Rule__c, false);
    	
    	LeadToCallFileRuleSet__c ruleSet1 = new LeadToCallFileRuleSet__c();
    	ruleSet1.Operator__c = LeadToCallFileUtilities.CONTAINS_WITH;
    	ruleSet1.Field_Value__c = 'test';
    	ruleSet1.Field_Name_Dyna__c = 'lead.Source__c#DATE';
    	ruleSet1.LeadToCallFileRule__c = rule1.Id;
    	ruleSetController.ruleSets.add(ruleSet1);
    	ruleSetController.save();
    	rule1 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule1.Id);
    	System.assertEquals(rule1.LeadToCallFileRuleSets__r.size(), 0);
    	
    	Integer size1 = ruleSetController.ruleSets.size();
    	ruleSetController.moreRule();
    	Integer size2 = ruleSetController.ruleSets.size();
    	System.assertEquals(size1 + 1, size2);
    	
    	if (size2 > 0) {
    		rule1 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule1.Id);
    		List<LeadToCallFileRuleSet__c> ruleSets = rule1.LeadToCallFileRuleSets__r;
    		ruleSetController.selectedRuleSetId = String.valueOf(ruleSets.get(0).Id);
    		ruleSetController.deleteRule();
    		Integer size3 = ruleSetController.ruleSets.size();
    		System.assertEquals(size2 - 1, size3);
    	}
    	Integer size5 = ruleSetController.ruleSets.size();
    	//test selectedRuleSetId is null
    	ruleSetController.selectedRuleSetId = null;
    	ruleSetController.deleteRule();
    	Integer size4 = ruleSetController.ruleSets.size();
    	System.assertEquals(size5, size4);
    }
}