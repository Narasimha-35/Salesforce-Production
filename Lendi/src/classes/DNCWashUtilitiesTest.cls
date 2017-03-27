@isTest(SeeAllData=true)
private class DNCWashUtilitiesTest {

    static testMethod void constructDynamicSoqlForDNCRTest() {
        DNC_Wash_Rule__c rule1 = new DNC_Wash_Rule__c();
        rule1.Api_Field_Name__c = 'lead.LeadSource#PICKLIST';
        rule1.Operator__c = 'contains with';
        rule1.Field_Value__c = 'Google';
        
        DNC_Wash_Rule__c rule2 = new DNC_Wash_Rule__c();
        rule2.Api_Field_Name__c = 'lead.Super_Balance__C#CURRENCY';
        rule2.Operator__c = 'is less than';
        rule2.Field_Value__c = '3000';
        
        DNC_Wash_Rule__c rule3 = new DNC_Wash_Rule__c();
        rule3.Api_Field_Name__c = 'lead.LastName#STRING';
        rule3.Operator__c = 'is equal to';
        rule3.Field_Value__c = 'chen';
        
        //Need a Date
        DNC_Wash_Rule__c rule4 = new DNC_Wash_Rule__c();
        rule4.Api_Field_Name__c = 'lead.CreatedDate#DATETIME';
        rule4.Operator__c= 'is greater than';
        rule4.Field_Value__c = '2014-03-30';
        
        //Need a Datetime
        DNC_Wash_Rule__c rule5 = new DNC_Wash_Rule__c();
        rule5.Api_Field_Name__c = 'lead.Birthday__c#DATE';
        rule5.Operator__c = 'is equal to';
        rule5.Field_Value__c = '1987-09-07';
        
        //Need a boolean
        DNC_Wash_Rule__c rule6 = new DNC_Wash_Rule__c();
        rule6.Api_Field_Name__c = 'lead.DoNotCall#BOOLEAN';
        rule6.Operator__c = 'is equal to';
        rule6.Field_Value__c = 'true';
        
        insert rule1;
        String query = DNCWashUtilities.constructDynamicSoqlForDNCR(DNCWashUtilities.QUERY_TYPE_FIELD);
        System.assert(query != null);
        
        insert rule2;
        String query2 = DNCWashUtilities.constructDynamicSoqlForDNCR(DNCWashUtilities.QUERY_TYPE_FIELD);
        System.assert(query2 != null);
        
        insert rule3;
        String query3 = DNCWashUtilities.constructDynamicSoqlForDNCR(DNCWashUtilities.QUERY_TYPE_FIELD);
        System.assert(query3 != null);
        
        insert rule4;
        String query4 = DNCWashUtilities.constructDynamicSoqlForDNCR(DNCWashUtilities.QUERY_TYPE_FIELD);
        System.assert(query4 != null);
        System.debug('4 ' + query3);
        
        insert rule5;
        insert rule6;
        String query5 = DNCWashUtilities.constructDynamicSoqlForDNCR(DNCWashUtilities.QUERY_TYPE_COUNT);
        System.assert(query5 != null);
        System.debug('5 ' + query5);
    }
    
    static testMethod void  processWashResultTest() {
    	DNCWashUtilities.DNCWashResultWrap result1Y = new DNCWashUtilities.DNCWashResultWrap();
    	result1Y.washResult = 'Y';
    	result1Y.washDate = Date.today();
    	result1Y.transactionId = '99837282';
    	DNCWashUtilities.DNCWashResultWrap result2N = new DNCWashUtilities.DNCWashResultWrap();
    	result2N.washResult = 'N';
    	result2N.washDate = Date.today();
    	result2N.transactionId = '99837282';
    	DNCWashUtilities.DNCWashResultWrap result3N = new DNCWashUtilities.DNCWashResultWrap();
    	result3N.washResult = 'N';
    	result3N.washDate = Date.today();
    	result3N.transactionId = '99837282';
    	DNCWashUtilities.DNCWashResultWrap result4I = new DNCWashUtilities.DNCWashResultWrap();
    	result4I.washResult = 'I';
    	result4I.washDate = Date.today();
    	result4I.transactionId = '99837282';
    	DNCWashUtilities.DNCWashResultWrap result5I = new DNCWashUtilities.DNCWashResultWrap();
    	result5I.washResult = 'I';
    	result5I.washDate = Date.today();
    	result5I.transactionId = '99837282';
    	
    	List<DNCWashUtilities.DNCWashResultWrap> testList1ContainY = new List<DNCWashUtilities.DNCWashResultWrap>();
    	testList1ContainY.add(result1Y);
    	testList1ContainY.add(result2N);
    	
    	List<DNCWashUtilities.DNCWashResultWrap> testList2ContainY = new List<DNCWashUtilities.DNCWashResultWrap>();
    	testList2ContainY.add(result4I);
    	testList2ContainY.add(result1Y);
    	
    	List<DNCWashUtilities.DNCWashResultWrap> testList1BothI = new List<DNCWashUtilities.DNCWashResultWrap>();
    	testList1BothI.add(result4I);
    	testList1BothI.add(result5I);
    	
    	List<DNCWashUtilities.DNCWashResultWrap> testList1BothN = new List<DNCWashUtilities.DNCWashResultWrap>();
    	testList1BothN.add(result2N);
    	testList1BothN.add(result3N);
    	
    	List<DNCWashUtilities.DNCWashResultWrap> testList1IAndN = new List<DNCWashUtilities.DNCWashResultWrap>();
    	testList1IAndN.add(result2N);
    	testList1IAndN.add(result4I);
    	
    	DNCWashUtilities.DNCWashResultWrap testResult1 = DNCWashUtilities.processWashResult(testList1ContainY);
    	System.assert(testResult1 != null);
    	System.assertEquals(testResult1.washResult, 'Y');
    	
    	DNCWashUtilities.DNCWashResultWrap testResult2 = DNCWashUtilities.processWashResult(testList2ContainY);
    	System.assert(testResult2 != null);
    	System.assertEquals(testResult2.washResult, 'Y');
    	
    	DNCWashUtilities.DNCWashResultWrap testResult3 = DNCWashUtilities.processWashResult(testList1BothI);
    	System.assert(testResult3 != null);
    	System.assertEquals(testResult3.washResult, 'I');
    	
    	DNCWashUtilities.DNCWashResultWrap testResult4 = DNCWashUtilities.processWashResult(testList1BothN);
    	System.assert(testResult4 != null);
    	System.assertEquals(testResult4.washResult, 'N');
    	
    	DNCWashUtilities.DNCWashResultWrap testResult5 = DNCWashUtilities.processWashResult(testList1IAndN);
    	System.assert(testResult5 != null);
    	System.assertEquals(testResult5.washResult, 'N');
    }
    
    static testMethod void getCurrentAccountBalanceDNCTest() {
    	String accountBalance = DNCWashUtilities.getCurrentAccountBalanceDNC();
    	System.assert(accountBalance != null);
    	System.assertEquals(accountBalance, '14950');
    }
    
    static testMethod void washPhoneNumbersTest() {
    	Lead lead = new Lead();
    	lead.LastName = 'Chen';
    	Lead.Phone = '0415530313';
    	upsert lead;
    	Lead newLead = LeadDAO.getLeadById(lead.id);
    	DNCWashUtilities.washPhoneNumbers('415530313', newLead);
    	System.assert(newLead.DNCR_Outcome__c != null);
    	System.assertEquals(newLead.DNCR_Outcome__c, 'N');
    }
    
    static testMethod void getWashResultTest() {
    	Lead lead = new Lead();
    	lead.LastName = 'Chen';
    	Lead.Phone = '0415530313';
    	upsert lead;
    	Lead newLead = LeadDAO.getLeadById(lead.id);
    	Test.startTest();
    	DNCWashUtilities.getWashResult('415530313', newLead.Id);
    	Test.stopTest();
    	Lead newLeadAfter = LeadDAO.getLeadById(newLead.id);
    	System.assert(newLeadAfter.DNCR_Outcome__c != null);
    	System.assertEquals(newLeadAfter.DNCR_Outcome__c, 'N');
    }
    
    static testMethod void countPhoneNumberFromAllLeadsFitRuleTest() {
    	DNC_Wash_Rule__c rule1 = new DNC_Wash_Rule__c();
        rule1.Api_Field_Name__c = 'lead.LeadSource#PICKLIST';
        rule1.Operator__c = 'contains with';
        rule1.Field_Value__c = 'Google';
        insert rule1;
        DNCWashUtilities.DNCRuleResult result = DNCWashUtilities.countPhoneNumberFromAllLeadsFitRule();
        System.assert(result.leadCount != null);
        System.assert(result.leadPhoneAndMobileCount != null);
    }
    
}