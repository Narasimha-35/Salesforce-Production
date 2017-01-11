@isTest(SeeAllData=true)
private class DNCRuleSetUpControllerTest {

    static testMethod void DNCRuleSetUpControllerMethodTest() {
        List<DNC_Wash_Rule__c> oldRules = [Select Id From DNC_Wash_Rule__c];
        if (oldRules.size() > 0) {
        	delete oldRules;
        }
        DNCRuleSetUpController dncRuleSetupController = new DNCRuleSetUpController();
        DNC_Wash_Rule__c rule1 = new DNC_Wash_Rule__c();
        rule1.Api_Field_Name__c = 'lead.LastName#PICKLIST';
        rule1.Operator__c = 'contains with';
        rule1.Field_Value__c = 'YoYoImpossibleNameChen';
        insert rule1;
        List<DNC_Wash_Rule__c> ruleDNCSets = new List<DNC_Wash_Rule__c>();
        ruleDNCSets.add(rule1);
        dncRuleSetupController.ruleDNCSets = ruleDNCSets;
        DNC_Call_File_Setup__c setup = new DNC_Call_File_Setup__c();
        setup.Update_Call_File_With_Lead__c = true;
        List<vhc__Campaign__c> callFiles = [Select Id From vhc__Campaign__c limit 10];
        if (callFiles.size() > 0) {
        	setup.Call_File__c = callFiles.get(0).Id;
        }
        dncRuleSetupController.save();
        Integer sizeBefore = dncRuleSetupController.ruleDNCSets.size();
        dncRuleSetupController.moreRule();
        Integer sizeAfter = dncRuleSetupController.ruleDNCSets.size();
        System.assertEquals(sizeBefore + 1, sizeAfter);
        for (DNC_Wash_Rule__c rule : dncRuleSetupController.ruleDNCSets) {
        	if (rule.Api_Field_Name__c == null) {
        		dncRuleSetupController.selectedRuleSetId = rule.Id;
        	}
        }
        dncRuleSetupController.deleteRule();
        Integer sizeAfter2 = dncRuleSetupController.ruleDNCSets.size();
        System.assertEquals(sizeAfter - 1, sizeAfter2);
        
        Lead lead = new Lead();
    	lead.LastName = 'YoYoImpossibleNameChen1';
    	Lead.Phone = '0415530313';
    	upsert lead;
    	
    	Lead lead2 = new Lead();
    	lead2.LastName = 'YoYoImpossibleNameChen2';
    	Lead2.MobilePhone = '0415530313';
    	upsert lead2;
    	
    	Lead lead3 = new Lead();
    	lead3.LastName = 'YoYoImpossibleNameChen3';
    	Lead3.Phone = '0415530313';
    	Lead3.MobilePhone = '0415530313';
    	upsert lead3;
    	
    	Lead lead4 = new Lead();
    	lead4.LastName = 'YoYoImpossibleNameChen3';
    	upsert lead4;
    	
    	Test.startTest();
    	dncRuleSetupController.triggerWashFunction();
    	Test.stopTest();
    	Lead leadNew1 = LeadDAO.getLeadById(lead.id);
    	System.assert(leadNew1.DNCR_Outcome__c != null);
    	System.assertEquals(leadNew1.DNCR_Outcome__c, 'N');
    	
    	Lead leadNew2 = LeadDAO.getLeadById(lead2.id);
    	System.assert(leadNew2.DNCR_Outcome__c != null);
    	System.assertEquals(leadNew2.DNCR_Outcome__c, 'N');
    	
    	Lead leadNew3 = LeadDAO.getLeadById(lead3.id);
    	System.assert(leadNew3.DNCR_Outcome__c != null);
    	System.assertEquals(leadNew3.DNCR_Outcome__c, 'N');
    }
}