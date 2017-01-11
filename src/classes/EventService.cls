/*
* EventService
*/
public class EventService {

    public static String constructAppointmentEventSubject(Appointment__c appt) {
        return constructAppointmentEventSubject(appt, '-', ' ');
    }

    public static String constructAppointmentEventSubject(Appointment__c appt, String subjectDelimiter,  String addressDelimiter) {
        String ret = '';
        ret += appt.name == null ? '' : appt.name;
        ret += subjectDelimiter;
        ret += constructAppointmentEventLocation(appt, addressDelimiter);
        ret += subjectDelimiter;
        ret += appt.phone__c == null ? '' : appt.phone__c;
        ret += subjectDelimiter;
        ret += appt.appointment_Type__c == null ? '' : appt.appointment_Type__c;
        return ret;
    }

    public static String constructAppointmentEventLocation(Appointment__c appt, String delimiter) {
        String ret = '';
        ret += appt.street_Address__c == null ? '' : appt.street_Address__c;
        ret += delimiter;
        ret += appt.city__c == null ? '' : appt.city__c;
        ret += delimiter;
        ret += appt.state__c == null ? '' : appt.state__c;
        ret += delimiter;
        ret += appt.postal_Code__c == null ? '' : appt.postal_Code__c;
        return ret;
    }

}