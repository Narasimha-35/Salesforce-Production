global class AppointmentService {
	public static final Map<String, String> CHANNEL_TO_CONFIG_NAME = new Map<String, String>{
		'Phone Broker' => 'Phone_Broker',
		'Partner' => 'Face_To_face',
		'Employee' => 'Face_To_face',
		'Click' => 'Face_To_face'
	};
	public static final Allocate_Appointment__c FACE_TO_FACE_SETTING = Allocate_Appointment__c.getValues('Face_To_face');
	public static final Allocate_Appointment__c PHONE_BROKER_SETTING = Allocate_Appointment__c.getValues('Phone_Broker');
	public Appointment__c appt;
	public List<Broker__c> orderedBrokers;
	public Map<Id, Broker__c> brokerMap;
	public Integer workStartTime;
	public Integer workEndTime;
	public Integer displayMargin;
	public Integer eventDuration;
	public Integer eventCoolDown;
	public Datetime displayStartTime;
	public Datetime displayEndTime;
	public BrokerService brokerServ;

	public AppointmentService(Id apptId) {
		this.appt = [SELECT id, name, googleEventId__c, broker_Email__c, mobile__c, street_Address__c, city__c, postal_Code__c, state__c, employment_Status__c, industry__c, credit_Card_Balance__c, personal_Loan_Balance__c, current_Loan_Value__c, current_Interest_Rate__c, annual_Income__c, partner_Income__c, transaction_Type__c, fixed_Rate_Expiry__c, age_of_Current_Loan__c, phone__c, current_Loan_Type__c, current_Interest_Rate_Type__c, current_Financials_Up_to_Date__c, last_Refinance__c, current_Lender__c, account_Email__c, account_Name_Text__c, pre_Sales_Notes__c, appointment_Type__c, market__c, market__r.name, appointment_Date_and_Time__c, region__r.name, region__r.timeZone__c, brokerChannel__c, speciality_Skills__c FROM Appointment__c WHERE id =: apptId];
		brokerServ = new BrokerService(appt);
		orderedBrokers = brokerServ.getBrokers();
		brokerMap = brokerServ.getBrokerMap();

		workStartTime = Integer.valueOf(appt.appointment_Type__c == 'Phone Appointment' ? PHONE_BROKER_SETTING.dayStartTime__c : FACE_TO_FACE_SETTING.dayStartTime__c);
		workEndTime = Integer.valueOf(appt.appointment_Type__c == 'Phone Appointment' ? PHONE_BROKER_SETTING.dayEndTime__c : FACE_TO_FACE_SETTING.dayEndTime__c);
		displayMargin = Integer.valueOf(appt.appointment_Type__c == 'Phone Appointment' ? PHONE_BROKER_SETTING.intervalOfMeeting__c : FACE_TO_FACE_SETTING.intervalOfMeeting__c);
		eventDuration = Integer.valueOf(appt.appointment_Type__c == 'Phone Appointment' ? PHONE_BROKER_SETTING.durationOfMeeting__c : FACE_TO_FACE_SETTING.durationOfMeeting__c);
		eventCoolDown = Integer.valueOf(appt.appointment_Type__c == 'Phone Appointment' ? PHONE_BROKER_SETTING.buffer__c : FACE_TO_FACE_SETTING.buffer__c);

		setDisplayStartTime(getDisplayStartTime());
	}

	public Datetime getDisplayStartTime() {
		Date apptDate = appt.appointment_Date_and_Time__c.date();
		Datetime ret;

		if(apptDate > Date.today()) {
			ret = AppointmentUtil.convertToLocalDatetime(apptDate.addDays(-1), appt.region__r.timeZone__c);
		} else if(apptDate == Date.today()) {
			ret = AppointmentUtil.convertToLocalDatetime(apptDate, appt.region__r.timeZone__c);
		} else {
			// error?
			ret = AppointmentUtil.convertToLocalDatetime(Date.today(), appt.region__r.timeZone__c);
		}
		return ret.addHours(workStartTime);
	}

	public AppointmentService(Appointment__c appt) {
		this.appt = appt;
	}

	public Appointment__c getAppointment() {
		return this.appt;
	}

	public void setDisplayStartTime(Datetime displayStartTime) {
		this.displayStartTime = displayStartTime;
		this.displayEndTime = displayStartTime.addHours(workEndTime - workStartTime);
	}

	public List<List<Datetime>> generateAvaliableDatetime(Integer numOfDay) {
		List<List<Datetime>> ret = new List<List<Datetime>>();
		for(Integer i = 0; i < numOfDay; i++) {
			Datetime startTime = displayStartTime.addDays(i);
			Datetime endTime = startTime.addHours(workEndTime - workStartTime);
			ret.add(AppointmentUtil.getAvailabileDatetime(startTime, endTime, displayMargin));
		}
		return ret;
	}

	public List<List<SelectOption>> generateSelectOption(List<List<Datetime>> avaliableTime) {
		List<Datetime> firstDayAvaliableDatetimes = avaliableTime[0];
		Datetime queryStartTime = firstDayAvaliableDatetimes[0].addMinutes(-eventCoolDown);
		List<Datetime> lastDayAvaliableDatetimes = avaliableTime[avaliableTime.size() - 1];
		Datetime queryEndTime = lastDayAvaliableDatetimes[lastDayAvaliableDatetimes.size() - 1].addMinutes(eventCoolDown);
		List<String> brokerIds = brokerServ.getGoogleCalendarIds();
		GoogleCalendarModel.FreeBusyResponse apiResponse = GoogleCalendarUtility.getFreeBusy(queryStartTime, queryEndTime, brokerIds);

		List<List<SelectOption>> ret = new List<List<SelectOption>>();
		for(Integer i = 0; i < avaliableTime.size(); i++) {
			ret.add(AppointmentUtil.getAvailabileOptions(avaliableTime[i], orderedBrokers, apiResponse.calendars, appt.region__r.timeZone__c, eventCoolDown, eventDuration));
		}
		return ret;
	}

	public void updateAppointment() {

	}

	Webservice static void cancelAppointment(Id apptId) {
		AppointmentService apptServ = new AppointmentService(apptId);
		apptServ.cancelAppointment();
	}

	public void cancelAppointment() {
		HttpRequestResponse apiRes = GoogleCalendarUtility.deleteCalendarEvent(appt.broker_Email__c, appt.googleEventId__c);
		if(apiRes.res.getBody() != '') {
			//Error
			return;
		}
		appt.is_Rescheduled_Appointment__c = true;
		// record type to new
		appt.recordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('New').getRecordTypeId();
		//save the phone number
		appt.previous_Broker_Mobile__c = appt.broker_Mobile__c;
		// status to new
		appt.appointment_Status__c = 'New';
		// broker to ? workflow
		Broker__c broker = [SELECT id FROM Broker__c WHERE email__c = 'who@creditandfinance.com.au'];
		appt.broker__c = broker.id;
		update appt;
	}

	public void bookAppointment(Datetime apptStartTime) {
		appt.recordTypeId = [SELECT id FROM RecordType WHERE name = 'Confirmed Appointment' LIMIT 1].id;
		appt.appointment_Date_and_Time__c = Datetime.valueOf(apptStartTime.format('yyyy-MM-dd HH:mm:ss', appt.region__r.timeZone__c));
		appt.appointmentDateTime__c = apptStartTime;

		//check free busy again
		Datetime queryStartTime = apptStartTime.addMinutes(eventCoolDown);
		Datetime queryEndTime = apptStartTime.addMinutes(eventCoolDown + eventDuration);
		GoogleCalendarModel.FreeBusyResponse apiResponse = GoogleCalendarUtility.getFreeBusy(queryStartTime, queryEndTime, brokerServ.getGoogleCalendarIds());
		Broker__c broker = AppointmentUtil.selectBroker(BrokerServ.getBrokers(), apiResponse.calendars, apptStartTime.addMinutes(-eventCoolDown), apptStartTime.addMinutes(eventDuration + eventCoolDown));

		List<User> ul = [SELECT id FROM User WHERE email = :broker.email__c AND isActive = true LIMIT 1];
		User defaultUser = [SELECT id FROM User WHERE isActive = true LIMIT 1];
		Id userId = ul.size() > 0 ? ul[0].id : defaultUser.id;
		Event e = AppointmentUtil.constructEvent(appt, apptStartTime, userId, broker, 'appointmentConfirmationDescriptionTemplate');
		HttpRequestResponse apiRes = GoogleCalendarUtility.insertCalenderEvent(e, broker);
		GoogleCalendarModel.ResponseBody body = (GoogleCalendarModel.ResponseBody) JSON.deserialize(apiRes.res.getBody(), GoogleCalendarModel.ResponseBody.class);
        appt.googleEventId__c = body.id;
		appt.eventCalendar__c = broker.email__c;
		appt.broker__c = broker.id;

		AppointmentUtil.adjustCounts(broker);
		update appt;
		insert e;

		Utilities.sendAppointmentConfirmEmail(appt.id);
	}

	public void print() {
		System.debug('Appointment: ' + appt);
		System.debug('Avaliable Brokers: ' + orderedBrokers);
		System.debug('Appointment time zone: ' + appt.region__r.timeZone__c);

		System.debug('workStartTime: ' + workStartTime);
		System.debug('workEndTime: ' + workEndTime);
		System.debug('displayMargin: ' + displayMargin);
		System.debug('eventDuration: ' + eventDuration);
		System.debug('eventCoolDown: ' + eventCoolDown);

		System.debug('displayStartTime: ' + displayStartTime.format('yyyy-MM-dd\'T\'HH:mm:ssXXX', appt.region__r.timeZone__c));
		System.debug('displayEndTime: ' + displayEndTime.format('yyyy-MM-dd\'T\'HH:mm:ssXXX', appt.region__r.timeZone__c));
	}

}
