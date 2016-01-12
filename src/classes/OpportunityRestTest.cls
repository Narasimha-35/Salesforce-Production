@isTest(SeeAllData=true)
private class OpportunityRestTest {
	public static Account acc {get; set;}
	public static Opportunity opp {get; set;}
	
	
    static testMethod void doPostTest() {
        acc = new Account();
		//acc.Name = 'Test Account';
		acc.FirstName = 'Test';
		acc.LastName = 'Account';
		acc.PersonEmail = 'test@mailinator.com';
		acc.Phone = '+61423292909';
		acc.Employment_Status__pc = 'Full Time';
		acc.Marital_Status__pc = 'Single';
		acc.Housing_Status__pc = 'Renting';
		acc.Annual_Income__pc = 100000;
		acc.Super_Balance__pc = 100000;
		acc.Number_of_Children__pc = '2';
		acc.Partner_Annual_Income__pc = 100000;
		acc.Partner_Super_Balance__pc = 10000;
		insert acc;
		
		opp = new Opportunity();
		opp.Name = 'TEST';
		opp.AccountId = acc.Id;
		opp.CloseDate = Date.today();
		opp.StageName = 'Appointed';
		opp.Transaction_Type__c = 'Refinance';
		opp.Current_Lender__c = 'ANZ';
		opp.Current_Loan_Value__c = 45666;
		opp.Current_Loan_Type__c = 'Commercial';
		opp.Personal_Loan_Balance__c = 100;
		opp.Credit_Card_Balance__c = 120;
		opp.Car_Loan_Balance__c = 2000;
		insert opp;
		
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
    	req.params.put('oppoId', String.valueOf(opp.Id));
    	req.params.put('status', 'test chen');
    	req.requestURI = 'https://cs5.salesforce.com/services/apexrest/v1/Opportunity/';
    	req.httpMethod = 'POST';
    	RestContext.request = req;
    	RestContext.response = res;
    	ResponseHandler results = OpportunityRest.doPost();
    	System.assertEquals('Failed', results.status);
    }
}