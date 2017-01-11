global without sharing class CustomButtonUtilities {
	webservice static Boolean changeBroker(String appointmentId) {
		if (appointmentId != null && appointmentId != '') {
			List<Appointment__c> appointments = [select Id, Broker__c From Appointment__c where Id = :appointmentId];
			System.debug(appointments.size());
			if (appointments.size() == 1) {
				String userName = UserInfo.getUserName();
				User activeUser = [Select Email From User where Username = : userName limit 1];
				String userEmail = activeUser.Email;
				System.debug(userEmail);
				List<Broker__c> brokers = [select Id From Broker__c where email__c = :userEmail and Active_Broker__c = true];
				System.debug(brokers.size());
				if (brokers.size() == 1) {
					appointments.get(0).Broker__c = brokers.get(0).Id;
					update appointments;
					return true;
				}
			}
		}
		return false;
	}
}