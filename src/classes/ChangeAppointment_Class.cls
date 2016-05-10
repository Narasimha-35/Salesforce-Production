public class ChangeAppointment_Class {
   public String brokername{get;set;}
   public Boolean save1completed {get;set;}
   public Boolean save2completed {get;set;}

   public Id currentAppointmentId;
   public Appointment__c currentAppointment;
   public Appointment__c newAppointment;
   public Id newEventId;

   public ChangeAppointment_Class() {
      init(null);
   }

   public ChangeAppointment_Class(Id appId) {
      init(appId);
   }

   private void init(Id appId) {
      currentAppointmentId = appId != null ? appId : ApexPages.currentPage().getParameters().get('id');
      currentAppointment = [Select id, Name,Account_Name__c,Street_Address__c,City__c,Postal_Code__c,State__c,Broker__c,Appointment_Date_and_Time__c,Broker__r.name,Broker_Email__c,Broker_Mobile__c, Appointment_Type__c from Appointment__c where id=:currentAppointmentId ];

      save1completed = false;
      save2completed = false;
   }

   public void save() {
      newAppointment = new Appointment__c();

      // Step 1
      BrokerUtilities.updateBroker(currentAppointmentId, brokername);

      // Step 2
      AppointmentUtilities.sendEmailToNewBroker(currentAppointment);
      AppointmentUtilities.sendEmailToOldBroker(currentAppointment);

      // Step 3
      newEventId =  EventUtilities.insertEvent(currentAppointmentId, brokername, newAppointment);

      save1completed = true;
      system.debug('save1completed called save 2');
   }


   Public pagereference save2() {
      // Step 4
      system.debug('Debug called save 2');
      Saasfocus_GoogleCalenderHelper.processEvent(new list<ID>{newEventId});
      save2completed = true;
      return null;
   }

   public pagereference save3() {
      // Step 5 - Send SMS to new broker.
      Appointment__c newAppointment = [Select Name, Street_Address__c,City__c,Broker__c,Postal_Code__c,State__c,Broker__r.name ,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c from Appointment__c where id=:currentAppointmentId ];
      // Define SMS template++
      String newSMSTemplate = 'The appointment ' + newAppointment.name + ' with ' + newAppointment.street_Address__c + ' ' + newAppointment.city__c + ' ' + newAppointment.postal_Code__c+' '+newAppointment.State__c+' on '+newAppointment.Appointment_Date_and_Time__c+' is allocated to you.';

      acfCommon.sendSMS(newAppointment.broker__r.name, newAppointment.broker_Mobile__c, newSMSTemplate, true);
      System.debug('MobileNew'+newAppointment.broker_Mobile__c);

      // Step 6 - Delete old Event from salesforce and google calendar
      List<Event> lstevobj = [Select id,Google_Event_ID__c from Event where whatid =: currentAppointment.Broker__c AND Subject like :currentAppointment.Name+'%'  LIMIT 1];

      if(lstevobj.size()>0) {
         if(lstevobj[0].google_Event_ID__c != null) {
            System.debug('Amit'+lstevobj[0].Google_Event_ID__c);
            String st= Saasfocus_Global.getGoogleId(lstevobj[0].Google_Event_ID__c);
            System.debug('Bingo'+st);
            Chen_GoogleCalenderHelper.deleteEventOnGoogleCalendar(currentAppointment.Broker_Email__c,st,true);
         } else {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+'No Google Event Id Found!'));
         }
      }
      // Step 7 - Email to old broker
      // Step 8 - SMS to Old broker
      String oldSMSTemplate = 'The appointment '+currentAppointment.Name+' with '+currentAppointment.Street_Address__c+' '+currentAppointment.City__c+' '+currentAppointment.Postal_Code__c+' '+currentAppointment.State__c+' on '+currentAppointment.Appointment_Date_and_Time__c+'  is cancelled.';

      acfCommon.sendSMS(currentAppointment.Broker__r.name,currentAppointment.Broker_Mobile__c,OldSMSTemplate ,true);
      System.debug('MobileOld' + currentAppointment.broker_Mobile__c);
      return new pagereference('/' + currentAppointmentId);
   }
}
