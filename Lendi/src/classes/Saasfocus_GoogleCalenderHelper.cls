/* This class will called by the trigger TGRCreateAppointMentOnGoogle
* Created Date  08 -04 -2015
* Created By : Vidhi Srivastava
*Used for insert event on Gooogle */

/*
*  Last modified Anthony Xuan
*/

public with sharing class Saasfocus_GoogleCalenderHelper {
   private static List<Event> successSyncedEventList = new List<Event>();

   public static Map<Id, Broker__c> getRelatedBrokerMap(List<Event> el) {
      List<Id> brokerIds = new List<Id>();
      for(Event e : el) brokerIds.add(e.Whatid);
      BrokerSelector bs = new BrokerSelector(new Set<String>{'Email__c', 'Name'}, null);
      return new Map<Id, Broker__c>(bs.getById(brokerIds));
   }

   // This Method will make callOut Request and create Data On Google
   // This method will id of event as an argument which are related to the Broker.
   public static void processEvent(List<String> ids){
      EventSelector es = new EventSelector();
      List<Event> eventList = new List<Event>();

      // eventList = [SELECT StartDateTime,EndDateTime,Subject,Location,Description,Google_Event_ID__c,Whatid FROM Event WHERE Id IN :ids and Whatid != null LIMIT 100];
      eventList = es.getById(ids);
      Map<Id, Broker__c> bmap = getRelatedBrokerMap(eventList);

      for(Event event: eventList){
         if(event.Google_Event_ID__c != null) continue;
         Broker__c broker = bmap.get(event.whatId);
         GoogleCalendarModel.ResponseBody res;
         try {
            res = GoogleCalendarUtility.handleResponse(GoogleCalendarUtility.insertCalenderEvent(event, broker));
         } catch (HttpRequestResponse.HttpException e) {
            e.sendExceptionEmail('Google Calendar Sync', 'Saasfocus_GoogleCalenderHelper', 'processEvent');
            //handle
         }
         system.debug(LoggingLevel.INFO, '[Saasfocus_GoogleCalenderHelper] Google ResponseBody: ' + res);
         event.google_Event_ID__c = GoogleCalendarUtility.generateGoogleEventId(res.id, broker.email__c);
         event.googleId__c = res.id;
         successSyncedEventList.add(event);
      }

      system.debug(LoggingLevel.INFO, '[Saasfocus_GoogleCalenderHelper] success Synced Event List: ' + successSyncedEventList);
      update successSyncedEventList;
   }

}