public with sharing class BrokerUtilities {
	public static void updateBroker(Id currentAppointmentId, String brokername) {
      Appointment__c newapp = new Appointment__c(id = currentAppointmentId);
      newapp.Broker__c = brokername;
      update newapp;
   }
}
