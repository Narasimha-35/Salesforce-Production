@isTest
public with sharing class TestGoogleCalendarModel {

	private static testMethod void testRequestBody() {
		Datetime startDT = Datetime.now();
		Datetime endDT = Datetime.now();
		String timeZone = 'Australia/Sydney';

		String description = 'test descrption';
		String subject = 'test subject';
		String location = 'test location';

		Event e = new Event(startDateTime = startDT, endDateTime = endDT, timeZone__c = timeZone, description = description, subject = subject, location = location);
		GoogleCalendarModel.RequestBody reqBody = new GoogleCalendarModel.RequestBody(e);

		System.assertEquals(description, reqBody.description);
		System.assertEquals(subject, reqBody.summary);
		System.assertEquals(location, reqBody.location);

		System.assertNotEquals(null, reqBody.getJSON());
	}

	private static testMethod void testConstructRecur() {
		String recurString = 'RRULE:FREQ=WEEKLY;UNTIL=20151020T025959Z;BYDAY=TU';
		GoogleCalendarModel.Recur recur = new GoogleCalendarModel.Recur(recurString);

		System.assertEquals('WEEKLY', recur.FREQ);
		System.assertEquals(DateTime.valueOfGmt('2015-10-20 02:59:59').getTime(), recur.UNTIL.getTime());
	}

}
