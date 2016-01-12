@isTest(SeeAllData=true)
private class LeadWithCustomBControllerExtensionTest {
	public static Lead testLead1;
	static {
		testLead1 = new Lead();
    	testLead1.Source__c = 'test 1';
    	testLead1.LastName = 'lI';
    	testLead1.Total_Calls__c = 3;
    	testLead1.Status = 'New';
    	testLead1.Last_Refinance__c = Date.today();
    	testLead1.Fixed_Rate_Expiry__c = Date.today();
    	insert testLead1;
	}
    static testMethod void customButtonControllerTest() {
        Test.startTest();
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(testLead1);
        LeadWithCustomButtonControllerExtension stdController = new LeadWithCustomButtonControllerExtension(controller);
        System.assert(stdController != null);
        stdController.currectCreditHistory = 'Excellent - No Issues';
        stdController.currentLender = 'BankWest';
        stdController.employmentStatus = 'Full Time';
        stdController.fixedExpiry = '2015-05-06';
        stdController.housingStatus = 'Boarding/Family';
        stdController.interestRate = 4.29;
        stdController.interestType = 'Variable';
        stdController.lastRefinance = '2015-03-08';
        stdController.loadAmount = 440000;
        stdController.lookingToBuy = 'More than 2 years';
        stdController.mortgageStatus = 'Owner Occupied';
        stdController.saveCreditHistory();
        stdController.saveCurrentLender();
        stdController.saveEmploymentStatus();
        stdController.saveFixedExpiryDate();
        stdController.saveHousingStatus();
        stdController.saveInterestRate();
        stdController.saveInterestType();
        stdController.saveLastRefinanceDate();
        stdController.saveLoadAmount();
        stdController.saveLookingToBuy();
        stdController.saveMortgageStatus();
        Test.stopTest();
        Lead newLead = [Select Id, Name, Current_Loan_Value__c, Current_Lender__c, Credit_History__c, Employment_Status__c, Fixed_Rate_Expiry__c, Housing_Status__c, Current_Interest_Rate__c, Current_Interest_Rate_Type__c, Last_Refinance__c, Loan_Value__c, Looking_To_Buy__c, Current_Loan_Type__c From Lead where Id = : testLead1.Id];
    	System.assertEquals(newLead.Current_Lender__c, 'BankWest');
    	System.assertEquals(newLead.Credit_History__c, 'Excellent - No Issues');
    	System.assertEquals(newLead.Employment_Status__c, 'Full Time');
    	System.assertEquals(newLead.Housing_Status__c, 'Boarding/Family');
    	System.assertEquals(newLead.Current_Interest_Rate__c, 4.29);
    	System.assertEquals(newLead.Current_Interest_Rate_Type__c, 'Variable');
    	System.assertEquals(newLead.Current_Loan_Value__c, 440000);
    	System.assertEquals(newLead.Looking_To_Buy__c, 'More than 2 years');
    	System.assertEquals(newLead.Current_Loan_Type__c, 'Owner Occupied');
    	stdController.currectCreditHistory = null;
        stdController.currentLender = null;
        stdController.employmentStatus = null;
        stdController.fixedExpiry = null;
        stdController.housingStatus = null;
        stdController.interestRate = null;
        stdController.interestType = null;
        stdController.lastRefinance = null;
        stdController.loadAmount = null;
        stdController.lookingToBuy = null;
        stdController.mortgageStatus = null;
        stdController.saveCreditHistory();
        stdController.saveCurrentLender();
        stdController.saveEmploymentStatus();
        stdController.saveFixedExpiryDate();
        stdController.saveHousingStatus();
        stdController.saveInterestRate();
        stdController.saveInterestType();
        stdController.saveLastRefinanceDate();
        stdController.saveLoadAmount();
        stdController.saveLookingToBuy();
        stdController.saveMortgageStatus();
    }
}