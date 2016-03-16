public with sharing class EventService {

	public static Map<Id, Broker__c> getRelatedBrokerMap(List<Event> el) {
      List<Id> brokerIds = new List<Id>();
      for(Event e : el) brokerIds.add(e.Whatid);
      BrokerSelector bs = new BrokerSelector(new Set<String>{'Email__c', 'Name'}, null);
      return new Map<Id, Broker__c>(bs.getById(brokerIds));
   }

}
