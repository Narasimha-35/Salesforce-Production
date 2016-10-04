@isTest
public class EventServiceTest {

    private static testMethod void testConstructAppointmentEventSubject() {
        Appointment__c appt = new Appointment__c();
        appt.appointment_Type__c = 'First Appointment';

        appt.street_Address__c = 'a';
        appt.city__c = 'b';
        appt.state__c = 'New South Wales';
        appt.postal_Code__c = '2000';
        String res = EventService.constructAppointmentEventSubject(appt);
        System.assertEquals('-a b New South Wales 2000--First Appointment', res);
    }

}
