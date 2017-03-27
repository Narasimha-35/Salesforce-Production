@isTest(SeeAllData=true)
private class LeadToCallFileUtilitiesTest {
	public static LeadToCallFileRule__c rule1 {get; set;}
	public static LeadToCallFileRule__c rule2 {get; set;}
	public static LeadToCallFileRule__c rule3 {get; set;}
	public static LeadToCallFileRule__C rule4 {get; set;}
	public static LeadToCallFileRule__C rule5 {get; set;}
	public static LeadToCallFileRule__C rule6 {get; set;}
	static {
		rule1 = new LeadToCallFileRule__c();
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
    	
    	LeadToCallFileRuleSet__c ruleSet1Rule1 = new LeadToCallFileRuleSet__c();
    	ruleSet1Rule1.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
    	ruleSet1Rule1.Field_Value__c = 'test 1';
    	ruleSet1Rule1.Field_Name_Dyna__c = 'lead.Source__c#STRING';
    	ruleSet1Rule1.LeadToCallFileRule__c = rule1.Id;
    	insert ruleSet1Rule1;
    	LeadToCallFileRuleSet__c ruleSet2Rule1 = new LeadToCallFileRuleSet__c();
    	ruleSet2Rule1.Operator__c = LeadToCallFileUtilities.IS_GREATER_THAN;
    	ruleSet2Rule1.Field_Value__c = '2015-02-15';
    	ruleSet2Rule1.Field_Name_Dyna__c = 'lead.CreatedDate#DATETIME';
    	ruleSet2Rule1.LeadToCallFileRule__c = rule1.Id;
    	insert ruleSet2Rule1;
    	LeadToCallFileRuleSet__c ruleSet3Rule1 = new LeadToCallFileRuleSet__c();
    	ruleSet3Rule1.Operator__c = LeadToCallFileUtilities.IS_LESS_THAN;
    	ruleSet3Rule1.Field_Value__c = '4';
    	ruleSet3Rule1.Field_Name_Dyna__c = 'lead.Total_Calls__c#DOUBLE';
    	ruleSet3Rule1.LeadToCallFileRule__c = rule1.Id;
    	insert ruleSet3Rule1;
    	rule1 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule1.Id);
    	
    	rule2 = new LeadToCallFileRule__c();
    	rule2.Rule_Name__c = 'test rule type 1';
    	rule2.Is_Active_Rule__c = false;
    	rule2.Exclude_Do_Not_Call__c = true;
    	rule2.Exclude_Do_Not_Email__c = true;
    	rule2.Exclude_Closed_And_Lost__c = true;
    	rule2.Exclude_Converted_Lead__c = true;
    	rule2.Rule_Description__c = 'test description 2';
    	//rule2.Call_File__c = 'bbb';
    	rule2.Priority__c = 1;
    	insert rule2;
    	
    	LeadToCallFileRuleSet__c ruleSet1Rule2 = new LeadToCallFileRuleSet__c();
    	ruleSet1Rule2.Operator__c = LeadToCallFileUtilities.IS_NOT_EQUAL_TO;
    	ruleSet1Rule2.Field_Value__c = 'test 1';
    	ruleSet1Rule2.Field_Name_Dyna__c = 'lead.Source__c#STRING';
    	ruleSet1Rule2.LeadToCallFileRule__c = rule2.Id;
    	insert ruleSet1Rule2;
    	LeadToCallFileRuleSet__c ruleSet2Rule2 = new LeadToCallFileRuleSet__c();
    	ruleSet2Rule2.Operator__c = LeadToCallFileUtilities.IS_GREATER_THAN;
    	ruleSet2Rule2.Field_Value__c = '2015-02-15';
    	ruleSet2Rule2.Field_Name_Dyna__c = 'lead.CreatedDate#DATETIME';
    	ruleSet2Rule2.LeadToCallFileRule__c = rule2.Id;
    	insert ruleSet2Rule2;
    	LeadToCallFileRuleSet__c ruleSet3Rule2 = new LeadToCallFileRuleSet__c();
    	ruleSet3Rule2.Operator__c = LeadToCallFileUtilities.IS_GREATER_THAN;
    	ruleSet3Rule2.Field_Value__c = '4';
    	ruleSet3Rule2.Field_Name_Dyna__c = 'lead.Total_Calls__c#DOUBLE';
    	ruleSet3Rule2.LeadToCallFileRule__c = rule2.Id;
    	insert ruleSet3Rule2;
    	rule2 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule2.Id);
    	
    	rule3 = new LeadToCallFileRule__c();
    	rule3.Rule_Name__c = 'test rule 3';
    	rule3.Is_Active_Rule__c = true;
    	rule3.Exclude_Do_Not_Call__c = false;
    	rule3.Exclude_Do_Not_Email__c = false;
    	rule3.Exclude_Closed_And_Lost__c = false;
    	rule3.Exclude_Converted_Lead__c = false;
    	rule3.Rule_Description__c = 'test description 3';
    	//rule3.Call_File__c = 'ccc';
    	rule3.Priority__c = 1;
    	insert rule3;
    	
    	LeadToCallFileRuleSet__c ruleSet1Rule3 = new LeadToCallFileRuleSet__c();
    	ruleSet1Rule3.Operator__c = LeadToCallFileUtilities.CONTAINS_WITH;
    	ruleSet1Rule3.Field_Value__c = 'test';
    	ruleSet1Rule3.Field_Name_Dyna__c = 'lead.Source__c#STRING';
    	ruleSet1Rule3.LeadToCallFileRule__c = rule3.Id;
    	insert ruleSet1Rule3;
    	
    	rule3 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule3.Id);
    	
    	//Test Case for exclude the lead status
    	rule4 = new LeadToCallFileRule__c();
    	rule4.Rule_Name__c = 'test rule 4';
    	rule4.Is_Active_Rule__c = true;
    	rule4.Exclude_Do_Not_Call__c = false;
    	rule4.Exclude_Do_Not_Email__c = false;
    	rule4.Exclude_Closed_And_Lost__c = true;
    	rule4.Exclude_Converted_Lead__c = false;
    	rule4.Rule_Description__c = 'test description 4';
    	rule4.Priority__c = 1;
    	insert rule4;
    	
    	LeadToCallFileRuleSet__c ruleSet1Rule4 = new LeadToCallFileRuleSet__c();
    	ruleSet1Rule4.Operator__c = LeadToCallFileUtilities.CONTAINS_WITH;
    	ruleSet1Rule4.Field_Value__c = 'test';
    	ruleSet1Rule4.Field_Name_Dyna__c = 'lead.Source__c#STRING';
    	ruleSet1Rule4.LeadToCallFileRule__c = rule4.Id;
    	insert ruleSet1Rule4;
    	
    	LeadToCallFileRuleSet__c ruleSet2Rule4 = new LeadToCallFileRuleSet__c();
    	ruleSet2Rule4.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
    	ruleSet2Rule4.Field_Value__c = '3';
    	ruleSet2Rule4.Field_Name_Dyna__c = 'lead.Total_Calls__c#DOUBLE';
    	ruleSet2Rule4.LeadToCallFileRule__c = rule4.Id;
    	insert ruleSet2Rule4;
    	
    	rule4 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule4.Id);
    	
    	rule5 = new LeadToCallFileRule__c();
    	rule5.Rule_Name__c = 'test rule 5';
    	rule5.Is_Active_Rule__c = true;
    	rule5.Exclude_Closed_And_Lost__c = false;
    	rule5.Exclude_Do_Not_Call__c = false;
    	rule5.Exclude_Do_Not_Email__c = false;
    	rule5.Exclude_Converted_Lead__c = false;
    	rule5.Rule_Description__c = 'test description 5';
    	rule5.Priority__c = 1;
    	insert rule5;
    	
    	LeadToCallFileRuleSet__c ruleSet1Rule5 = new LeadToCallFileRuleSet__c();
    	ruleSet1Rule5.Field_Name_Dyna__c = 'lead.Birthday__c#DATE';
    	ruleSet1Rule5.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
    	ruleSet1Rule5.Field_Value__c = '2014-02-09';
    	ruleSet1Rule5.LeadToCallFileRule__c = rule5.Id;
    	insert ruleSet1Rule5;
    	
    	LeadToCallFileRuleSet__c ruleSet3Rule5 = new LeadToCallFileRuleSet__c();
    	ruleSet3Rule5.Field_Name_Dyna__c = 'lead.Birthday__c#DATE';
    	ruleSet3Rule5.Operator__c = LeadToCallFileUtilities.IS_GREATER_THAN;
    	ruleSet3Rule5.Field_Value__c = '2014-02-09';
    	ruleSet3Rule5.LeadToCallFileRule__c = rule5.Id;
    	insert ruleSet3Rule5;
    	
    	rule5 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule5.Id);
    	
    	rule6 = new LeadToCallFileRule__c();
    	rule6.Rule_Name__c = 'test rule 6';
    	rule6.Is_Active_Rule__c = true;
    	rule6.Exclude_Closed_And_Lost__c = false;
    	rule6.Exclude_Do_Not_Call__c = false;
    	rule6.Exclude_Do_Not_Email__c = false;
    	rule6.Exclude_Converted_Lead__c = false;
    	rule6.Rule_Description__c = 'test description 6';
    	rule6.Priority__c = 1;
    	insert rule6;
    	
    	LeadToCallFileRuleSet__c ruleSet1Rule6 = new LeadToCallFileRuleSet__c();
    	ruleSet1Rule6.Field_Name_Dyna__c = 'lead.Birthday__c#DATE';
    	ruleSet1Rule6.Operator__c = LeadToCallFileUtilities.IS_LESS_THAN;
    	ruleSet1Rule6.Field_Value__c = '2014-02-09';
    	ruleSet1Rule6.LeadToCallFileRule__c = rule6.Id;
    	insert ruleSet1Rule6;
    	
    	LeadToCallFileRuleSet__c ruleSet2Rule6 = new LeadToCallFileRuleSet__c();
    	ruleSet2Rule6.Field_Name_Dyna__c = 'lead.Birthday__c#DATE';
    	ruleSet2Rule6.Operator__c = LeadToCallFileUtilities.IS_NOT_EQUAL_TO;
    	ruleSet2Rule6.Field_Value__c = '2014-02-09';
    	ruleSet2Rule6.LeadToCallFileRule__c = rule6.Id;
    	insert ruleSet2Rule6;
    	
    	rule6 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule6.Id);
	}
	
	static testMethod void checkDateFormatTest() {
		String wrongFormat1 = 'xxx';
		String wrongFormat2 = '2014-134-23';
		String wrongFormat3 = '2019-11-129';
		String correctFormat = '2018-09-09';
		
		Boolean result1 = LeadToCallFileUtilities.checkDateFormat(wrongFormat1);
		Boolean result2 = LeadToCallFileUtilities.checkDateFormat(wrongFormat2);
		Boolean result3 = LeadToCallFileUtilities.checkDateFormat(wrongFormat3);
		Boolean result4 = LeadToCallFileUtilities.checkDateFormat(correctFormat);
		System.assert(!result1);
		System.assert(!result2);
		System.assert(!result3);
		System.assert(result4);
	}
	
	static testMethod void convertStringToDateTest() {
		String date1 = '2014-02-02';
		Date myDate = LeadToCallFileUtilities.convertStringToDate(date1);
		System.assert(myDate!=null);
	}
	
	static testMethod void convertStringToDateTimeTest() {
		String date1 = '2014-02-02';
		Datetime myDatetime = LeadToCallFileUtilities.convertStringToDateTime(date1);
		System.assert(myDatetime!=null);
	}
	
	static testMethod void ruleSetErrorCheckTest() {
		LeadToCallFileRuleSet__c ruleSet1 = new LeadToCallFileRuleSet__c();
		ruleSet1 = null;
		//Date with wrong format
		LeadToCallFileRuleSet__c ruleSet2 = new LeadToCallFileRuleSet__c();
		ruleSet2.Field_Name_Dyna__c = 'lead.test1#DATE';
		ruleSet2.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
		ruleSet2.Field_Value__c = 'wrong format';
		//Date with correct format
		LeadToCallFileRuleSet__c ruleSet3 = new LeadToCallFileRuleSet__c();
		ruleSet3.Field_Name_Dyna__c = 'lead.test2#DATE';
		ruleSet3.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
		ruleSet3.Field_Value__c = '2014-02-09';
		//Number with wrong format
		LeadToCallFileRuleSet__c ruleSet4 = new LeadToCallFileRuleSet__c();
		ruleSet4.Field_Name_Dyna__c = 'lead.test3#INTEGER';
		ruleSet4.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
		ruleSet4.Field_Value__c = 'XUY';
		//Number with correct format
		LeadToCallFileRuleSet__c ruleSet5 = new LeadToCallFileRuleSet__c();
		ruleSet5.Field_Name_Dyna__c = 'lead.test4#INTEGER';
		ruleSet5.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
		ruleSet5.Field_Value__c = '3';
		
		Boolean result1 = LeadToCallFileUtilities.ruleSetErrorCheck(ruleSet1);
		Boolean result2 = LeadToCallFileUtilities.ruleSetErrorCheck(ruleSet2);
		Boolean result3 = LeadToCallFileUtilities.ruleSetErrorCheck(ruleSet3);
		Boolean result4 = LeadToCallFileUtilities.ruleSetErrorCheck(ruleSet4);
		Boolean result5 = LeadToCallFileUtilities.ruleSetErrorCheck(ruleSet5);
		
		System.assert(!result1);
		System.assert(!result2);
		System.assert(result3);
		System.assert(!result4);
		System.assert(result5);
	}
	
    static testMethod void checkIfLeadFitTheRuleTest() {
    	Lead testLead1 = new Lead();
    	testLead1.Source__c = 'test 1';
    	testLead1.LastName = 'lI';
    	testLead1.Total_Calls__c = 3;
    	testLead1.Status = 'New';
    	insert testLead1;
    	testLead1 = [Select Id, Source__c, DoNotCall, vhc__CallFile__c, HasOptedOutOfEmail, ConvertedDate, LastName, Total_Calls__c, Status, CreatedDate From lead where Id =: testLead1.Id ];

    	Lead testLead2 = new Lead();
    	testLead2.Source__c = 'test 2';
    	testLead2.LastName = 'Ren';
    	testLead2.Total_Calls__c = 8;
    	testLead2.Status = 'New';
    	insert testLead2;
    	testLead2 = [Select Id, Source__c, DoNotCall, vhc__CallFile__c, HasOptedOutOfEmail, ConvertedDate, LastName, Total_Calls__c, Status, CreatedDate From lead where Id =: testLead2.Id ];
		
		Lead testLead3 = new Lead();
		testLead3.Source__c = 'test 1';
		testLead3.LastName = 'xxx';
		testLead3.Total_Calls__c = 3;
		testLead3.Status = 'New';
		testLead3.DoNotCall = true;
		
		Lead testLead4 = new Lead();
		testLead4.Source__c = 'test 1';
		testLead4.LastName = 'sksk';
		testLead4.Status = 'Closed Lost';
		insert testLead4;
		
    	Boolean result1 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead1, rule1);
    	Boolean result2 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead2, rule1);
    	Boolean result3 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead3, rule1);
    	System.assert(result1);
    	System.assert(!result2);
    	System.assert(!result3);
    	
    	Boolean result4 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead1, rule2);
    	Boolean result5 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead2, rule2);
    	Boolean result6 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead3, rule2);
    	System.assert(!result4);
    	System.assert(result5);
    	System.assert(!result6);
    	
    	Boolean result7 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead1, rule3);
    	Boolean result8 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead2, rule3);
    	Boolean result9 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead3, rule3);
    	System.assert(result7);
    	System.assert(result8);
    	System.assert(result9);
    	
    	Boolean result10 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead3, rule4);
    	Boolean result11 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead4, rule4);
    	System.assert(result10);
    	System.assert(!result11);
    	
    	Lead testLead5 = new Lead();
    	Date myDate5 = Date.newInstance(2014, 2, 9);
		testLead5.Source__c = 'test 1';
		testLead5.LastName = 'sksk';
		testLead5.Status = 'Closed Lost';
		testLead5.Birthday__c = myDate5;
		insert testLead5;
		
		Lead testLead6 = new Lead();
		Date myDate6 = Date.newInstance(2014, 2, 8);
		testLead6.Source__c = 'test 1';
		testLead6.LastName = 'sksk';
		testLead6.Status = 'Closed Lost';
		testLead6.Birthday__c = myDate6;
		insert testLead6;
		
		Lead testLead7 = new Lead();
		Date myDate7 = Date.newInstance(2014, 2, 19);
		testLead7.Source__c = 'test 1';
		testLead7.LastName = 'sksk';
		testLead7.Status = 'Closed Lost';
		testLead7.Birthday__c = myDate7;
		insert testLead7;
		
		Lead testLead8 = new Lead();
		Date myDate8 = Date.newInstance(2014, 2, 11);
		testLead8.Source__c = 'test 1';
		testLead8.LastName = 'sksk';
		testLead8.Status = 'Closed Lost';
		testLead8.Birthday__c = myDate8;
		insert testLead8;
		
		Boolean result12 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead5, rule5);
		Boolean result13 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead6, rule5);
		Boolean result14 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead7, rule5);
		Boolean result15 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead8, rule5);
		System.assert(!result12);
		System.assert(!result13);
		System.assert(!result14);
		System.assert(!result15);
		
		Boolean result16 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead5, rule6);
		Boolean result17 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead6, rule6);
		Boolean result18 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead7, rule6);
		Boolean result19 = LeadToCallFileUtilities.checkIfLeadFitTheRule(testLead8, rule6);
		System.assert(!result16);
		System.assert(result17);
		System.assert(!result18);
		System.assert(!result19);
    }
}