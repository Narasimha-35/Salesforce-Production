public class AppointmentAllocationController {
	public static final Integer NUM_OF_DAY_SHOW = 3;
	public static final Allocate_Appointment__c FACE_TO_FACE_SETTING = Allocate_Appointment__c.getValues('Face_To_face');
	public static final Allocate_Appointment__c PHONE_BROKER_SETTING = Allocate_Appointment__c.getValues('Phone_Broker');
	public Appointment__c appt {get; set;}
	public List<String> displayDates {get; set;}
	public List<String> displayToday {get; set;}
	public List<List<SelectOption>> options {get; set;}
	public List<String> selections {get; set;}
	public AppointmentService apptServ;
	public String errorMessage {get; set;}

	public void init(String apptId) {
		apptServ = new AppointmentService(apptId);
		appt = apptServ.appt;
		List<List<Datetime>> avaliableTimes = apptServ.generateAvaliableDatetime(NUM_OF_DAY_SHOW);
		options = apptServ.generateSelectOption(avaliableTimes);
		displayDates = new List<String>();
		displayToday = new List<String>();
		selections = new List<String>();
		for(List<Datetime> dayAvaliableTimes : avaliableTimes) {
			displayDates.add(dayAvaliableTimes[0].format('EEE, d MMM yyyy'));
			if(dayAvaliableTimes[0].date() == Date.today()) displayToday.add('today');
			else displayToday.add('not-today');
			selections.add('');
		}
	}

	public Pagereference confirm() {
		String selectionResult = '';
		for(String s : selections) {
			selectionResult += s == null ? '' : s;
		}
		if(selectionResult == '') {
			//send Email to admin
			return new pagereference('/' + appt.id);
		}
		Datetime bookingDateTime = Datetime.valueOf(selectionResult);
		apptServ.bookAppointment(bookingDateTime);
		return new pagereference('/' + appt.id);
	}

	Public Pagereference cancel() {
		return new pagereference('/' + appt.id);
	}

	public AppointmentAllocationController() {
		Id apptId = ApexPages.currentPage().getParameters().get('id');
		init(apptId);
	}

	public AppointmentAllocationController(String apptId) {
		init(apptId);
	}

}