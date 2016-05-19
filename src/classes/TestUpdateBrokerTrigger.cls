@isTest
private class TestUpdateBrokerTrigger {

	private static testMethod void testQueue() {
		// MercuryTestUtilities.setCustomSettings(true);
		// Appointment__c app = TestUtilities.createAppointment();
		// Account a = TestUtilities.createAccount();
		// insert a;
		// Opportunity o = TestUtilities.createOpportunity();
		// o.AccountId = a.id;
		// insert o;
		// app.Opportunity__c = o.id;
		// insert app;
		// MercuryTestUtilities.setMock(app.Opportunity__c, app.Account_Id__c);
		// app.RecordTypeId = [SELECT Name, id FROM RecordType WHERE sObjectType='Appointment__c' and isActive=true and Name='Confirmed Appointment'][0].id;
		// System.debug(Limits.getDMLRows());
		// Test.startTest();
		// System.debug(Limits.getDMLRows());
		//
		// Test.stopTest();
		// update app;

		//can't test
	}

	private static testMethod void testNotQueue() {
		MercuryTestUtilities.setCustomSettings(false);
		Appointment__c app = TestUtilities.createAppointment();
		insert app;
		MercuryTestUtilities.setMock(app.Opportunity__c, app.Account_Id__c);
		app.RecordTypeId = [SELECT Name, id FROM RecordType WHERE sObjectType='Appointment__c' and isActive=true and Name='Confirmed Appointment'][0].id;
		Test.startTest();
		update app;
		Test.stopTest();
	}
}