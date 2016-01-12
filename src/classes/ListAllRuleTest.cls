@isTest(SeeAllData=true)
private class ListAllRuleTest {
	
    static testMethod void listAllRuleControllerTest() {
        Account account = new Account(Name='Account Name'); 
        List<LeadToCallFileRule__c> rulesBefore = LeadToCallFileDAO.getAllLeadToCallFileRules();
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
    	
    	ApexPages.StandardController controller = new ApexPages.StandardController(account);
    	ListAllRule stdController = new ListAllRule(controller);
    	system.assert(stdController != null);
    	system.assert(stdController.rulesList != null && stdController.rulesList.size() !=0);
    	stdController.addNewRule();
    	List<LeadToCallFileRule__c> rulesAfter = LeadToCallFileDAO.getAllLeadToCallFileRules();
    	System.assertEquals(rulesBefore.size() + 2, rulesAfter.size());
    }
}