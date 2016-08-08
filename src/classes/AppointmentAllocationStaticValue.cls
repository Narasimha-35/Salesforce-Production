public with sharing class AppointmentAllocationStaticValue {
	public static UserSelector userSelector = new UserSelector(new Set<String>{'id', 'email'}, null);
	public static Map<Id, User> idUserMap = new Map<Id, User>(userSelector.getActiveUser());
	public static Map<String, User> emailUserMap = new Map<String, User>();
	static {
		for(User u : idUserMap.values()) {
			emailUserMap.put(u.email, u);
		}
	}

	public static BrokerSelector brokerSelector = new BrokerSelector();
	public static Map<Id, Broker__c> idBrokerMap = new Map<Id, Broker__c>(brokerSelector.getAllActiveBroker());
	public static Map<String, Broker__c> emailBrokerMap = new Map<String, Broker__c>();
	static {
		for(Broker__c b : idBrokerMap.values()) {
			emailBrokerMap.put(b.email__c, b);
		}
	}

	public static EventSelector eventSelector = new EventSelector();
}
