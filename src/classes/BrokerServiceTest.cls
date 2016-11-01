@isTest
public class BrokerServiceTest {
	public static Broker__c broker1;
	public static Broker__c broker2;
	public static Broker__c broker3;

	private static List<Appointment__c> initAppointment() {
		Opportunity oppo = TestUtilities.createOpportunity();
		broker1 = TestUtilities.createBroker();
		broker1.channel__c = 'Phone broker';
		broker2 = TestUtilities.createBroker();
		broker2.channel__c = 'Partner';
		broker3 = TestUtilities.createBroker();
		broker3.channel__c = 'Partner';
		Market__c market1 = TestUtilities.createMarket();
		Market__c market2 = TestUtilities.createMarket();

		insert oppo;
		insert broker1;
		insert broker2;
		insert broker3;
		insert market1;
		insert market2;

		Counter__c c = [SELECT id, count__c FROM Counter__c WHERE broker__c = :broker2.id LIMIT 1];
		c.count__c += 1;
		update c;

		insert TestUtilities.createMarketAssociation(broker1, market1);
		insert TestUtilities.createMarketAssociation(broker1, market2);
		insert TestUtilities.createMarketAssociation(broker2, market2);
		insert TestUtilities.createMarketAssociation(broker2, market1);
		insert TestUtilities.createMarketAssociation(broker3, market2);

		Appointment__c appt1 = TestUtilities.createAppointment(oppo, broker1, market1);
		appt1.appointment_Type__c = 'Phone Appointment';
		Appointment__c appt2 = TestUtilities.createAppointment(oppo, broker2, market2);
		appt2.appointment_Type__c = 'First Appointment';
		return new List<Appointment__c>{appt1, appt2};
	}

	private static testMethod void testGetMarketAssociation() {
		List<Appointment__c> appts = initAppointment();
		insert appts;
		Appointment__c appt = appts[0];

		BrokerService brokerServ = new BrokerService(appt);
		List<Market_Broker_Association__c> res = brokerServ.getMarketAssociation(appt);
		System.assertEquals(1, res.size());
	}

	private static testMethod void testGetBrokers() {
		List<Appointment__c> appts = initAppointment();
		insert appts;
		Appointment__c appt1 = appts[0];

		BrokerService brokerServ1 = new BrokerService(appt1);
		System.assertEquals(1, brokerServ1.getBrokers(appt1).size());

		appt1.appointment_Type__c = 'First Appointment';
		update appt1;
		BrokerService brokerServ2 = new BrokerService(appt1);
		System.assertEquals(1, brokerServ2.getBrokers(appt1).size());

		Appointment__c appt2 = appts[1];
		BrokerService brokerServ3 = new BrokerService(appt2);
		List<broker__c> brokers = brokerServ3.getBrokers(appt2);
		System.assertEquals(2, brokers.size());
		System.assertEquals(broker3.id, brokers[0].id);
	}

}
