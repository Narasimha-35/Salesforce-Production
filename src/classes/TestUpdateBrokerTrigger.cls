@isTest
private class TestUpdateBrokerTrigger {

	private static testMethod void testQueue() {
		MercuryTestUtilities.setCustomSettings(true);
		Appointment__c app = TestUtilities.createAppointment();
		insert app;
		app.RecordTypeId = [SELECT Name, id FROM RecordType WHERE sObjectType='Appointment__c' and isActive=true and Name='Confirmed Appointment'][0].id;
		Test.startTest();
		update app;
		Test.stopTest();
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
