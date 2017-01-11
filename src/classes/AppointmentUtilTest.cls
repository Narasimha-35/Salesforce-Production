@isTest
public class AppointmentUtilTest {
	public static Broker__c broker1;
	public static Broker__c broker2;
	public static Broker__c broker3;

	private static List<Appointment__c> initAppointment() {
		Opportunity oppo = TestUtilities.createOpportunity();
		broker1 = TestUtilities.createBroker();
		broker1.channel__c = 'Phone broker';
		broker1.email__c = 'email1@test.com';
		broker2 = TestUtilities.createBroker();
		broker2.channel__c = 'Partner';
		broker2.email__c = 'email1@test.com';
		broker3 = TestUtilities.createBroker();
		broker3.channel__c = 'Partner';
		broker3.email__c = 'email2@test.com';
		Market__c market1 = TestUtilities.createMarket();
		Market__c market2 = TestUtilities.createMarket();

		insert oppo;
		insert broker1;
		insert broker2;
		insert broker3;
		insert market1;
		insert market2;

		Counter__c c = [SELECT id, count__c FROM Counter__c WHERE broker__c = :broker2.id LIMIT 1];
		c.count__c += 1;
		update c;

		insert TestUtilities.createMarketAssociation(broker1, market1);
		insert TestUtilities.createMarketAssociation(broker1, market2);
		insert TestUtilities.createMarketAssociation(broker2, market2);
		insert TestUtilities.createMarketAssociation(broker2, market1);
		insert TestUtilities.createMarketAssociation(broker3, market2);

		Appointment__c appt1 = TestUtilities.createAppointment(oppo, broker1, market1);
		appt1.appointment_Type__c = 'Phone Appointment';
		Appointment__c appt2 = TestUtilities.createAppointment(oppo, broker2, market2);
		appt2.appointment_Type__c = 'First Appointment';
		return new List<Appointment__c>{appt1, appt2};
	}

	private static testMethod void testSelectBroker() {

	}

	private static testMethod void testIsClash() {
		Datetime dt1 = Datetime.now().addMinutes(-5);
		Datetime dt2 = Datetime.now().addMinutes(5);
		Datetime dt3 = Datetime.now().addMinutes(10);
		Datetime dt4 = Datetime.now().addMinutes(15);
		System.assertEquals(false, AppointmentUtil.isClash(dt1, dt2, dt3, dt4));

		dt1 = Datetime.now().addMinutes(-5);
		dt2 = Datetime.now().addMinutes(5);
		dt3 = Datetime.now();
		dt4 = Datetime.now().addMinutes(15);
		System.assertEquals(true, AppointmentUtil.isClash(dt1, dt2, dt3, dt4));
	}

	private static testMethod void testConstructEmailBodyToOldBroker() {
		List<Appointment__c> appts = initAppointment();
		insert appts;
		EmailTemplate template = new EmailTemplate(name = 'test', developerName = 'test', htmlValue = 'test');
		System.assertNotEquals('', AppointmentUtil.constructEmailBodyToOldBroker(appts[0], template), '');
	}

	private static testMethod void testConstructEvent() {
		List<Appointment__c> appts = initAppointment();
		insert appts;
		Allocate_Appointment__c aa = new Allocate_Appointment__c(name = 'Phone_Broker', durationOfMeeting__c = '60', buffer__c = '10', dayEndTime__c = '8', dayStartTime__c = '8', intervalOfMeeting__c = '30');
		insert aa;
		Folder f = [SELECT id FROM Folder WHERE accessType = 'Public' and name = 'public' LIMIT 1];
		Document template = new Document(name = 'test', developerName = 'appointmentConfirmationDescriptionTemplate1', body = Blob.valueOf('test'), folderId = f.id);
		insert template;

		System.assertNotEquals(null, AppointmentUtil.constructEvent(appts[0], Datetime.now(), appts[0].createdBy.id, broker1, 'appointmentConfirmationDescriptionTemplate1'), '');
	}

	private static testMethod void testConstructAppointmentDescription() {
		List<Appointment__c> appts = initAppointment();
		insert appts;
		Folder f = [SELECT id FROM Folder WHERE accessType = 'Public' and name = 'public' LIMIT 1];
		Document template = new Document(name = 'test', developerName = 'appointmentConfirmationDescriptionTemplate1', body = Blob.valueOf('test'), folderId = f.id);
		insert template;
		System.assertNotEquals(null, AppointmentUtil.constructAppointmentDescription(appts[0], 'appointmentConfirmationDescriptionTemplate1'), '');
	}

	private static testMethod void testGetGoogleCalendarIds() {
		List<Appointment__c> appts = initAppointment();
		insert appts;

		List<String> calendarIds = AppointmentUtil.getGoogleCalendarIds(new List<Broker__c>{broker1, broker2, broker3});
		System.assert((new Set<String>(calendarIds)).contains('email1@test.com'));
		System.assert((new Set<String>(calendarIds)).contains('email2@test.com'));
		System.assertEquals(2, calendarIds.size());
	}

	private static testMethod void testAdjustCounts() {
		List<Appointment__c> appts = initAppointment();
		insert appts;

		AppointmentUtil.adjustCounts(broker2);
		Counter__c c = [SELECT id, count__c FROM Counter__c WHERE broker__c = :broker2.id LIMIT 1];
		System.assertEquals(2, c.count__c);
	}

}