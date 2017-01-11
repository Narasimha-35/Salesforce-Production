@isTest(SeeAllData=true)
private class TestOpportunityToCallFile {
  public static LeadToCallFileRule__c rule1 {get; set;}
  public static LeadToCallFileRule__c rule2 {get; set;}
  public static LeadToCallFileRule__c rule3 {get; set;}
  public static LeadToCallFileRule__C rule4 {get; set;}
  public static LeadToCallFileRule__C rule5 {get; set;}
  public static LeadToCallFileRule__C rule6 {get; set;}
  
  static {
    List<vhc__Campaign__c> callFiles = [select Id From vhc__Campaign__c limit 1];
    rule1 = new LeadToCallFileRule__c ();
    rule1.Rule_Name__c = 'test rule 1';
    rule1.Is_Active_Rule__c = true;
    rule1.Exclude_Do_Not_Call__c = true;
      rule1.Exclude_Do_Not_Email__c = true;
      rule1.Exclude_Closed_And_Lost__c = true;
      rule1.Exclude_Converted_Lead__c = true;
      rule1.Rule_Description__c = 'test description 1';
      rule1.Priority__c = 1;
      rule1.Rule_Object__c = 'Opportunity';
      rule1.Call_File__c = callFiles.get(0).Id;
      insert rule1;
       
       LeadToCallFileRuleSet__c ruleSet1Rule1 = new LeadToCallFileRuleSet__c();
      ruleSet1Rule1.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
      ruleSet1Rule1.Field_Value__c = 'test 1';
      ruleSet1Rule1.Field_Name_Dyna__c = 'Opportunity.Name#STRING';
      ruleSet1Rule1.LeadToCallFileRule__c = rule1.Id;
      insert ruleSet1Rule1;
      
      LeadToCallFileRuleSet__c ruleSet2Rule1 = new LeadToCallFileRuleSet__c();
      ruleSet2Rule1.Operator__c = LeadToCallFileUtilities.IS_GREATER_THAN;
      ruleSet2Rule1.Field_Value__c = '2015-02-15';
      ruleSet2Rule1.Field_Name_Dyna__c = 'Opportunity.CreatedDate#DATETIME';
      ruleSet2Rule1.LeadToCallFileRule__c = rule1.Id;
      insert ruleSet2Rule1;
      
      LeadToCallFileRuleSet__c ruleSet3Rule1 = new LeadToCallFileRuleSet__c();
      ruleSet3Rule1.Operator__c = LeadToCallFileUtilities.IS_LESS_THAN;
      ruleSet3Rule1.Field_Value__c = '4';
      ruleSet3Rule1.Field_Name_Dyna__c = 'Opportunity.Credit_Card_Balance__c#CURRENCY';
      ruleSet3Rule1.LeadToCallFileRule__c = rule1.Id;
      insert ruleSet3Rule1;
      rule1 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule1.Id);
      
      rule2 = new LeadToCallFileRule__c();
      rule2.Rule_Name__c = 'test rule type 2';
      rule2.Is_Active_Rule__c = false;
      rule2.Exclude_Do_Not_Call__c = true;
      rule2.Exclude_Do_Not_Email__c = true;
      rule2.Exclude_Closed_And_Lost__c = true;
      rule2.Exclude_Converted_Lead__c = true;
      rule2.Rule_Description__c = 'test description 2';
      //rule2.Call_File__c = 'bbb';
      rule2.Priority__c = 1;
      rule2.Rule_Object__c = 'Opportunity';
      rule2.Call_File__c = callFiles.get(0).Id;
      insert rule2;
      
      LeadToCallFileRuleSet__c ruleSet1Rule2 = new LeadToCallFileRuleSet__c();
      ruleSet1Rule2.Operator__c = LeadToCallFileUtilities.IS_NOT_EQUAL_TO;
      ruleSet1Rule2.Field_Value__c = 'test 1';
      ruleSet1Rule2.Field_Name_Dyna__c = 'Opportunity.Name#STRING';
      ruleSet1Rule2.LeadToCallFileRule__c = rule2.Id;
      insert ruleSet1Rule2;
      LeadToCallFileRuleSet__c ruleSet2Rule2 = new LeadToCallFileRuleSet__c();
      ruleSet2Rule2.Operator__c = LeadToCallFileUtilities.IS_GREATER_THAN;
      ruleSet2Rule2.Field_Value__c = '2015-02-15';
      ruleSet2Rule2.Field_Name_Dyna__c = 'Opportunity.CreatedDate#DATETIME';
      ruleSet2Rule2.LeadToCallFileRule__c = rule2.Id;
      insert ruleSet2Rule2;
      LeadToCallFileRuleSet__c ruleSet3Rule2 = new LeadToCallFileRuleSet__c();
      ruleSet3Rule2.Operator__c = LeadToCallFileUtilities.IS_GREATER_THAN;
      ruleSet3Rule2.Field_Value__c = '4';
      ruleSet3Rule2.Field_Name_Dyna__c = 'Opportunity.Credit_Card_Balance__c#DOUBLE';
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
      rule3.Rule_Object__c = 'Opportunity';
      rule3.Call_File__c = callFiles.get(0).Id;
      insert rule3;
      
      LeadToCallFileRuleSet__c ruleSet1Rule3 = new LeadToCallFileRuleSet__c();
      ruleSet1Rule3.Operator__c = LeadToCallFileUtilities.CONTAINS_WITH;
      ruleSet1Rule3.Field_Value__c = 'test';
      ruleSet1Rule3.Field_Name_Dyna__c = 'Opportunity.Name#STRING';
      ruleSet1Rule3.LeadToCallFileRule__c = rule3.Id;
      insert ruleSet1Rule3;
      
      rule3 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule3.Id);
      
      //Test Case for exclude the lead status
      rule4 = new LeadToCallFileRule__c();
      rule4.Rule_Name__c = 'test rule 4';
      rule4.Is_Active_Rule__c = true;
      rule4.Exclude_Do_Not_Call__c = false;
      rule4.Exclude_Do_Not_Email__c = true;
      rule4.Exclude_Closed_And_Lost__c = false;
      rule4.Exclude_Converted_Lead__c = false;
      rule4.Rule_Description__c = 'test description 4';
      rule4.Priority__c = 1;
      rule4.Rule_Object__c = 'Opportunity';
      rule4.Call_File__c = callFiles.get(0).Id;
      insert rule4;
      
      LeadToCallFileRuleSet__c ruleSet1Rule4 = new LeadToCallFileRuleSet__c();
      ruleSet1Rule4.Operator__c = LeadToCallFileUtilities.CONTAINS_WITH;
      ruleSet1Rule4.Field_Value__c = 'test';
      ruleSet1Rule4.Field_Name_Dyna__c = 'Opportunity.Name#STRING';
      ruleSet1Rule4.LeadToCallFileRule__c = rule4.Id;
      insert ruleSet1Rule4;
      
      LeadToCallFileRuleSet__c ruleSet2Rule4 = new LeadToCallFileRuleSet__c();
      ruleSet2Rule4.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
      ruleSet2Rule4.Field_Value__c = '3';
      ruleSet2Rule4.Field_Name_Dyna__c = 'Opportunity.Credit_Card_Balance__c#DOUBLE';
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
      rule5.Rule_Object__c = 'Opportunity';
      rule5.Call_File__c = callFiles.get(0).Id;
      insert rule5;
      
      LeadToCallFileRuleSet__c ruleSet1Rule5 = new LeadToCallFileRuleSet__c();
      ruleSet1Rule5.Field_Name_Dyna__c = 'Opportunity.Future_Followed_Date__c#DATE';
      ruleSet1Rule5.Operator__c = LeadToCallFileUtilities.IS_EQUAL_TO;
      ruleSet1Rule5.Field_Value__c = '2014-02-09';
      ruleSet1Rule5.LeadToCallFileRule__c = rule5.Id;
      insert ruleSet1Rule5;
      
      LeadToCallFileRuleSet__c ruleSet3Rule5 = new LeadToCallFileRuleSet__c();
      ruleSet3Rule5.Field_Name_Dyna__c = 'Opportunity.Future_Followed_Date__c#DATE';
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
      rule6.Rule_Object__c = 'Opportunity';
      rule6.Call_File__c = callFiles.get(0).Id;
      insert rule6;
      
      LeadToCallFileRuleSet__c ruleSet1Rule6 = new LeadToCallFileRuleSet__c();
      ruleSet1Rule6.Field_Name_Dyna__c = 'Opportunity.Future_Followed_Date__c#DATE';
      ruleSet1Rule6.Operator__c = LeadToCallFileUtilities.IS_LESS_THAN;
      ruleSet1Rule6.Field_Value__c = '2014-02-09';
      ruleSet1Rule6.LeadToCallFileRule__c = rule6.Id;
      insert ruleSet1Rule6;
      
      LeadToCallFileRuleSet__c ruleSet2Rule6 = new LeadToCallFileRuleSet__c();
      ruleSet2Rule6.Field_Name_Dyna__c = 'Opportunity.Future_Followed_Date__c#DATE';
      ruleSet2Rule6.Operator__c = LeadToCallFileUtilities.IS_NOT_EQUAL_TO;
      ruleSet2Rule6.Field_Value__c = '2014-02-09';
      ruleSet2Rule6.LeadToCallFileRule__c = rule6.Id;
      insert ruleSet2Rule6;
      
      rule6 = LeadToCallFileDAO.getLeadToCallFileRuleById(rule6.Id);
  }
  
   static testMethod void checkIfLeadFitTheRuleTest() { 
     Account account = new account();
    account =  WLCommonTrackerClass.createAccount(account);
     Opportunity testOppo1 = new Opportunity();
     testOppo1.Name = 'test 1';
     testOppo1.AccountId = account.Id;
     testOppo1.CloseDate = Date.today().addDays(1);
     testOppo1.StageName = 'Appointed';
     testOppo1.Transaction_Type__c = 'Refinance';
     testOppo1.Current_Lender__c = 'AMP';
     testOppo1.Current_Loan_Value__c = 40000;
     testOppo1.Current_Loan_Type__c = 'Commercial';
     testOppo1.Personal_Loan_Balance__c = 300;
     testOppo1.Credit_Card_Balance__c = 3;
     testOppo1.Car_Loan_Balance__c = 400;
     RecordType recType = [Select Id, Name From RecordType  Where SobjectType = 'Opportunity' and Name = 'Home Opportunity'];
     testOppo1.RecordTypeId = recType.Id;
     insert testOppo1;
     testOppo1 = [select Id, Name, vhc__CallFile__c, Account_Do_Not_Call__c, Account_Do_Not_Email__c, Future_Followed_Date__c, Credit_Card_Balance__c, CreatedDate From Opportunity where Id = : testOppo1.id];
     
     Opportunity testOppo2 = new Opportunity();
     testOppo2.Name = 'test 2';
     testOppo2.AccountId = account.Id;
     testOppo2.CloseDate = Date.today().addDays(1);
     testOppo2.StageName = 'Appointed';
     testOppo2.Transaction_Type__c = 'Refinance';
     testOppo2.Current_Lender__c = 'AMP';
     testOppo2.Current_Loan_Value__c = 40000;
     testOppo2.Current_Loan_Type__c = 'Commercial';
     testOppo2.Personal_Loan_Balance__c = 300;
     testOppo2.Credit_Card_Balance__c = 8;
     testOppo2.Car_Loan_Balance__c = 400;
     testOppo2.RecordTypeId = recType.Id;
     insert testOppo2;
     testOppo2 = [select Id, Name, vhc__CallFile__c, Account_Do_Not_Call__c, Account_Do_Not_Email__c, Future_Followed_Date__c, Credit_Card_Balance__c, CreatedDate From Opportunity where Id = :testOppo2.Id];
    
    Opportunity testOppo3 = new Opportunity();
     testOppo3.Name = 'test 1';
     testOppo3.AccountId = account.Id;
     testOppo3.CloseDate = Date.today().addDays(1);
     testOppo3.StageName = 'Appointed';
     testOppo3.Transaction_Type__c = 'Refinance';
     testOppo3.Current_Lender__c = 'AMP';
     testOppo3.Current_Loan_Value__c = 40000;
     testOppo3.Current_Loan_Type__c = 'Commercial';
     testOppo3.Personal_Loan_Balance__c = 300;
     testOppo3.Credit_Card_Balance__c = 3;
     testOppo3.Car_Loan_Balance__c = 400;
     testOppo3.RecordTypeId = recType.Id;
     insert testOppo3;
     testOppo3 = [select Id, Name, vhc__CallFile__c, Account_Do_Not_Call__c, Account_Do_Not_Email__c, Future_Followed_Date__c, Credit_Card_Balance__c, CreatedDate From Opportunity where Id = :testOppo3.Id];
    
    Boolean result1 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo1, rule1);
      Boolean result2 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo2, rule1);
      Boolean result3 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo3, rule1);
    
      
      Boolean result4 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo1, rule2);
      Boolean result5 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo2, rule2);
      Boolean result6 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo3, rule2);
      
      
      Boolean result7 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo1, rule3);
      Boolean result8 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo2, rule3);
      Boolean result9 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo3, rule3);
      
      
      Opportunity testOppo4 = new Opportunity();
      Date myDate4 = Date.newInstance(2014, 2, 9);
     testOppo4.Name = 'test 1';
     testOppo4.AccountId = account.Id;
     testOppo4.CloseDate = Date.today().addDays(1);
     testOppo4.StageName = 'Appointed';
     testOppo4.Transaction_Type__c = 'Refinance';
     testOppo4.Current_Lender__c = 'AMP';
     testOppo4.Current_Loan_Value__c = 40000;
     testOppo4.Current_Loan_Type__c = 'Commercial';
     testOppo4.Personal_Loan_Balance__c = 300;
     testOppo4.Credit_Card_Balance__c = 3;
     testOppo4.Car_Loan_Balance__c = 400;
     testOppo4.RecordTypeId = recType.Id;
     testOppo4.Future_Followed_Date__c = myDate4;
     insert testOppo4;
     testOppo4 = [select Id, Name, vhc__CallFile__c, Account_Do_Not_Call__c, Account_Do_Not_Email__c, Future_Followed_Date__c, Credit_Card_Balance__c, CreatedDate From Opportunity where Id = :testOppo4.Id];
    
    
    Opportunity testOppo5 = new Opportunity();
    Date myDate5 = Date.newInstance(2014, 2, 8);
     testOppo5.Name = 'test 1';
     testOppo5.AccountId = account.Id;
     testOppo5.CloseDate = Date.today().addDays(1);
     testOppo5.StageName = 'Appointed';
     testOppo5.Transaction_Type__c = 'Refinance';
     testOppo5.Current_Lender__c = 'AMP';
     testOppo5.Current_Loan_Value__c = 40000;
     testOppo5.Current_Loan_Type__c = 'Commercial';
     testOppo5.Personal_Loan_Balance__c = 300;
     testOppo5.Credit_Card_Balance__c = 3;
     testOppo5.Car_Loan_Balance__c = 400;
     testOppo5.RecordTypeId = recType.Id;
     testOppo5.Future_Followed_Date__c = myDate5;
     insert testOppo5;
     testOppo5 = [select Id, Name, vhc__CallFile__c, Account_Do_Not_Call__c, Account_Do_Not_Email__c, Future_Followed_Date__c, Credit_Card_Balance__c, CreatedDate From Opportunity where Id = :testOppo5.Id];
    Boolean result12 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo4, rule5);
    Boolean result13 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo5, rule5);
    Boolean result14 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo4, rule6);
    Boolean result15 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo5, rule6);
    System.assert(!result12);
    System.debug(result13);
    System.debug(result14);
    System.debug(result15);
    
    Opportunity testOppo6 = new Opportunity();
      Date myDate6 = Date.newInstance(2014, 2, 19);
     testOppo6.Name = 'test 1';
     testOppo6.AccountId = account.Id;
     testOppo6.CloseDate = Date.today().addDays(1);
     testOppo6.StageName = 'Appointed';
     testOppo6.Transaction_Type__c = 'Refinance';
     testOppo6.Current_Lender__c = 'AMP';
     testOppo6.Current_Loan_Value__c = 40000;
     testOppo6.Current_Loan_Type__c = 'Commercial';
     testOppo6.Personal_Loan_Balance__c = 300;
     testOppo6.Credit_Card_Balance__c = 3;
     testOppo6.Car_Loan_Balance__c = 400;
     testOppo6.RecordTypeId = recType.Id;
     testOppo6.Future_Followed_Date__c = myDate6;
     insert testOppo6;
     testOppo6 = [select Id, Name, vhc__CallFile__c, Account_Do_Not_Call__c, Account_Do_Not_Email__c, Future_Followed_Date__c, Credit_Card_Balance__c, CreatedDate From Opportunity where Id = :testOppo6.Id];
    
    Opportunity testOppo7 = new Opportunity();
      Date myDate7 = Date.newInstance(2014, 2, 11);
     testOppo7.Name = 'test 1';
     testOppo7.AccountId = account.Id;
     testOppo7.CloseDate = Date.today().addDays(1);
     testOppo7.StageName = 'Appointed';
     testOppo7.Transaction_Type__c = 'Refinance';
     testOppo7.Current_Lender__c = 'AMP';
     testOppo7.Current_Loan_Value__c = 40000;
     testOppo7.Current_Loan_Type__c = 'Commercial';
     testOppo7.Personal_Loan_Balance__c = 300;
     testOppo7.Credit_Card_Balance__c = 3;
     testOppo7.Car_Loan_Balance__c = 400;
     testOppo7.RecordTypeId = recType.Id;
     testOppo7.Future_Followed_Date__c = myDate7;
     insert testOppo7;
     testOppo7 = [select Id, Name, vhc__CallFile__c, Account_Do_Not_Call__c, Account_Do_Not_Email__c, Future_Followed_Date__c, Credit_Card_Balance__c, CreatedDate From Opportunity where Id = :testOppo7.Id];
     
     Boolean result16 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo6, rule5);
    Boolean result17 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo7, rule5);
    Boolean result18 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo6, rule6);
    Boolean result19 = OpportunityToCallFileUtilities.checkIfOppoFitTheRule(testOppo7, rule6);
    System.debug(result16);
    System.debug(result17);
    System.debug(result18);
    System.debug(result19);
    
    //Test Opportunity
    List<LeadToCallFileRule__c> callFileRules = new List<LeadToCallFileRule__c>();
    callFileRules.add(rule2);
    OpportunityToCallFileUtilities.selectRightCallFileForOpportunity(testOppo2, callFileRules);
   }
}