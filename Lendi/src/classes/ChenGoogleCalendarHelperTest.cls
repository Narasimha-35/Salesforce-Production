@isTest(SeeAllData=true)
private class ChenGoogleCalendarHelperTest {

    static testMethod void myUnitTest() {        
      /*  Id devRecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Confirmed Appointment').getRecordTypeId();
        Appointment__c appointment = [select id, Appointment_Date_and_Time__c, Name, Broker_Email__c, Broker__c, RecordTypeId from Appointment__c where RecordTypeId = :devRecordTypeId and Region__r.Sydney_Timezone_Offset__c != null limit 1];
        Event event = new Event();
        event.Subject = appointment.Name;
        event.Google_Event_ID__c = 'xxxx~' + appointment.Broker_Email__c;
        event.WhatId = appointment.Broker__c;
        event.StartDateTime = appointment.Appointment_Date_and_Time__c;
        event.EndDateTime = appointment.Appointment_Date_and_Time__c.addHours(1);
        insert event;
        Test.startTest();
        Chen_GoogleCalenderHelper.rescheduleAppointment(appointment.Id);
        Chen_GoogleCalenderHelper.deleteEventOnGoogleCalendar(appointment.Broker_Email__c, 'xxxx', false);
        Test.stopTest();
        
        */
    }
}