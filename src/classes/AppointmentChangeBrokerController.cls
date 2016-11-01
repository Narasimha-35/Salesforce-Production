public class AppointmentChangeBrokerController {
	public String selection {get; set;}
	public Appointment__c appt;
	public List<SelectOption> options {
		get {
			List<SelectOption> ret = new List<SelectOption>();
			List<Broker__c> brokers;
			if(appt.appointment_Type__c == 'Phone Appointment') brokers = [SELECT id, name FROM Broker__c WHERE active_Broker__c = true AND name != 'Unallocated Broker' AND channel__c = 'Phone Broker' AND id != :appt.broker__c];
			else brokers = [SELECT id, name FROM Broker__c WHERE active_Broker__c = true AND name != 'Unallocated Broker' AND (channel__c = 'Partner' OR channel__c = 'Employee') AND id != :appt.broker__c];
			for(Broker__c broker : brokers) {
				ret.add(new SelectOption(broker.id, broker.name));
			}
			return ret;
		}
		set;
	}

	public AppointmentChangeBrokerController() {
		String apptId = ApexPages.currentPage().getParameters().get('id');
		init(apptId);
	}

	public AppointmentChangeBrokerController(String apptId) {
		init(apptId);
	}

	public void init(String apptId) {
		appt = [SELECT id, appointment_Type__c, broker__c FROM Appointment__c WHERE id = :apptId];
	}

	public PageReference confirm() {
		return new pagereference('/' + appt.id);
	}

	public PageReference cancel() {
		return new pagereference('/' + appt.id);
	}
}