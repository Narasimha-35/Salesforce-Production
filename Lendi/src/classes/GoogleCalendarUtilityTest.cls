@isTest
public class GoogleCalendarUtilityTest {

	private static testMethod void testisBusy() {
		Datetime now = Datetime.now();

		Saasfocus_EventClass e = new Saasfocus_EventClass();
		e.StartDateTime = String.valueOf(now);
		e.EndDateTime = String.valueOf(now.addDays(1));

		Datetime st = now.addMinutes(1);
		Datetime ed = st.addDays(1);
		System.assertEquals(true, GoogleCalendarUtility.isBusy(st, ed, e));

		st = now.addMinutes(-2);
		System.assertEquals(true, GoogleCalendarUtility.isBusy(st, ed, e));

		ed = ed.addMinutes(-2);
		System.assertEquals(true, GoogleCalendarUtility.isBusy(st, ed, e));

		st = now.addMinutes(-10);
		ed = now.addMinutes(-9);
		System.debug(String.valueofGmt(st));
		System.debug(String.valueofGmt(ed));
		System.debug(e.startdatetime);
		System.debug(e.enddatetime);
		System.assertEquals(false, GoogleCalendarUtility.isBusy(st, ed, e));

		st = now.addDays(1).addMinutes(8);
		ed = now.addDays(1).addMinutes(10);
		System.assertEquals(false, GoogleCalendarUtility.isBusy(st, ed, e));
	}

}