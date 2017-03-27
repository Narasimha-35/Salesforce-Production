public class BrokerService {
	List<Broker__c> brokers;
	Map<Id, Broker__c> brokerMap;

	public BrokerService(Appointment__c appt) {
		brokers = getBrokers(appt);
		brokerMap = new Map<Id, Broker__c>(brokers);
	}

	public List<String> getGoogleCalendarIds() {
		List<String> calendarIds = new List<String>();
		for(Broker__c b : brokers) {
			calendarIds.add(b.email__c);
		}
		return calendarIds;
	}

	public List<Broker__c> getBrokers() {
		return this.brokers;
	}

	public Map<Id, Broker__c> getBrokerMap() {
		return this.brokerMap;
	}

	public Map<Id, Broker__c> getBrokers(List<Market_Broker_Association__c> associations, String speciality) {
		Set<Id> brokerIds = new Set<Id>();
		for(Market_Broker_Association__c association : associations) {
			brokerIds.add(association.broker__c);
		}
		List<Broker__c> brokersWithCompensation;
		List<Broker__c> brokersWithoutCompensation;
		if(speciality == null) {
			brokersWithCompensation = [SELECT id, compensatory_Appointment__c, email__c FROM Broker__c WHERE id IN :brokerIds AND active_Broker__c = true AND compensatory_Appointment__c > 0];
		} else {
			brokersWithCompensation = [SELECT id, compensatory_Appointment__c, email__c FROM Broker__c WHERE id IN :brokerIds AND active_Broker__c = true AND compensatory_Appointment__c > 0 AND speciality_Skills__c INCLUDES (:speciality)];
		}
		Set<Id> brokerIdsWithoutCompensation = new Set<Id>(brokerIds);
		brokerIdsWithoutCompensation.removeAll((new Map<Id, Broker__c>(brokersWithCompensation)).keySet());

		if(speciality == null) {
			brokersWithoutCompensation = [SELECT id, compensatory_Appointment__c, email__c FROM Broker__c WHERE id IN :brokerIdsWithoutCompensation AND active_Broker__c = true];
		} else {
			brokersWithoutCompensation = [SELECT id, compensatory_Appointment__c, email__c FROM Broker__c WHERE id IN :brokerIdsWithoutCompensation AND active_Broker__c = true AND speciality_Skills__c INCLUDES (:speciality)];
		}
		brokersWithCompensation.addAll(brokersWithoutCompensation);
		return new Map<Id, Broker__c>(brokersWithCompensation);
	}

	// get all brokers for this appointment
	public List<Broker__c> getBrokers(Appointment__c appt) {
		//check self appointment
		User curUser = [SELECT email FROM User WHERE id = :UserInfo.getUserId()];
		List<Broker__c> ret = [SELECT id, compensatory_Appointment__c, email__c FROM broker__c WHERE email__c = :curUser.email];
		if(ret.size() > 0) return ret;

		List<Market_Broker_Association__c> marketAssociations = getMarketAssociation(appt);
		Map<Id, Broker__c> marketBrokers = getBrokers(marketAssociations, appt.speciality_Skills__c);
		List<Counter__c> counter = [SELECT id, count__c, broker__c FROM Counter__c where broker__c IN :marketBrokers.keySet() ORDER BY count__c ASC];
		for(Counter__c c : counter) {
			ret.add(marketBrokers.get(c.broker__c));
		}
		return ret;
	}

	public List<Market_Broker_Association__c> getMarketAssociation(Appointment__c appt) {
		String apptType = appt.appointment_Type__c == 'Phone Appointment' ? 'Phone Broker' : 'Face to Face';
		return [SELECT id, broker__c, broker__r.type__c FROM Market_Broker_Association__c WHERE market__c = :appt.market__c AND broker__r.type__c = :apptType];
	}

}