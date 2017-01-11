public class AppointmentAllocationModel {

	public class MarketBrokerQueue {
		public Map<Id, Broker__c> brokers;
		public List<Counter__c> counters;

		public MarketBrokerQueue(Market__c market) {
			List<Market_Broker_Association__c> association = [SELECT id FROM Market_Broker_Association__c WHERE market__c = :market.id];
		}
	}

}