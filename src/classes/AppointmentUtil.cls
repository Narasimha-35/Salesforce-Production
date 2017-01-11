public class AppointmentUtil {

	public static List<SelectOption> getAvailabileOptions(List<Datetime> availableTimes, List<Broker__c> orderedBrokers, Map<String, GoogleCalendarModel.CalendarsItem> busyMap, String timezone, Integer coolDown, Integer duration) {
		List<SelectOption> ret = new List<SelectOption>();
		for(Datetime dt : availableTimes) {
			Broker__c broker = selectBroker(orderedBrokers, busyMap, dt.addMinutes(-coolDown), dt.addMinutes(duration + coolDown));
			ret.add(generateSelectOption(broker, dt, timezone));
		}
		return ret;
	}

	public static SelectOption generateSelectOption(Broker__c broker, Datetime dt, String timezone) {
		if(broker == null) {
			return new SelectOption('', '' + 'Not Availiable', true);
		} else {
			return new SelectOption(dt.format('yyyy-MM-dd HH:mm:ss'), '' + dt.format('HH:mm:ss', timezone), false);
		}
	}

	public static Broker__c selectBroker(List<Broker__c> orderedBrokers, Map<String, GoogleCalendarModel.CalendarsItem> busyMap, Datetime startDatetime, Datetime endDatetime) {
		for(Broker__c broker : orderedBrokers) {
			if(!isBusy(broker, busyMap, startDatetime, endDatetime)) return broker;
		}
		return null;
	}

	public static Boolean isClash(Datetime st1, Datetime ed1, Datetime st2, Datetime ed2) {
		if(st1 < ed2 && ed1 > st2) return true;
		return false;
	}

	public static Boolean isBusy(Broker__c broker, Map<String, GoogleCalendarModel.CalendarsItem> busyMap, Datetime eventStartTime, Datetime eventEndTime) {
		GoogleCalendarModel.CalendarsItem ci = busyMap.get(broker.email__c);
		List<GoogleCalendarModel.BusyItem> busyItems = ci.busy;
		Boolean ret = false;
		for(GoogleCalendarModel.BusyItem b : busyItems) {
			if(isClash(eventStartTime, eventEndTime, b.start, b.param_rr_end)) {
				return true;
			}
		}
		return false;
	}

	public static void increaseCount(Broker__c broker) {
		Counter__c c = [SELECT id, count__c FROM Counter__c WHERE broker__c = :broker.id LIMIT 1];
		c.count__c++;
		update c;
	}

	public static void decreaseCompensation(Broker__c broker) {
		broker.compensatory_Appointment__c--;
		update broker;
	}

	public static void adjustCounts(Broker__c broker) {
		if(broker.compensatory_Appointment__c > 0) {
			decreaseCompensation(broker);
		} else {
			increaseCount(broker);
		}
	}

	public static Datetime convertToLocalDatetime(Date gmtDate, String timezone) {
		Integer offset = getTimeZoneDiff('GMT', timezone);
		return ((Datetime) gmtDate).addSeconds(offset/1000);
	}

	public static Integer getTimeZoneDiff(String timezone1, String timezone2) {
		Datetime dt = Datetime.now();
		Datetime ldt1 = Datetime.valueOf(dt.format('yyyy-MM-dd HH:mm:ss', timezone1));
		Datetime ldt2 = Datetime.valueOf(dt.format('yyyy-MM-dd HH:mm:ss', timezone2));
		return (Integer) ((ldt1.getTime() - ldt2.getTime()));
	}

	public static List<Datetime> getAvailabileDatetime(Datetime displayStartTime, Datetime displayEndTime, Integer breakInMin) {
		List<Datetime> ret = new List<Datetime>();
		for(Datetime temp = displayStartTime; temp < displayEndTime; temp = temp.addMinutes(breakInMin)) {
			ret.add(temp);
		}
		return ret;
	}

	public static List<String> getGoogleCalendarIds(List<Broker__c> brokers) {
		Set<String> calendarIds = new Set<String>();
		for(Broker__c b : brokers) {
			calendarIds.add(b.email__c);
		}
		return new List<String>(calendarIds);
	}

	public static String constructAppointmentDescription(Appointment__c appt, String tempDocumentName) {
		String ret = DocumentService.getTemplate(tempDocumentName);
		ret = ret.replace('{!appointmentName}', appt.name == null ? '' : appt.name);
		ret = ret.replace('{!appointmentDatetime}', appt.appointment_Date_and_Time__c == null ? '' : appt.appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a'));
		ret = ret.replace('{!contactMobile}', appt.mobile__c == null ? '' : appt.mobile__c);
		ret = ret.replace('{!contactPhone}', appt.phone__c == null ? '' : appt.phone__c);
		ret = ret.replace('{!contactAddress}', EventService.constructAppointmentEventLocation(appt, ','));
		ret = ret.replace('{!contactEmail}', appt.account_Email__c == null ? '' : appt.account_Email__c);
		ret = ret.replace('{!contactName}', appt.account_Name_Text__c == null ? '' : appt.account_Name_Text__c);
		ret = ret.replace('{!appointmentNotes}', appt.pre_Sales_Notes__c == null ? '' : appt.pre_Sales_Notes__c.stripHtmlTags());
		ret = ret.replace('{!transactionType}', appt.transaction_Type__c == null ? '' : appt.transaction_Type__c);
		ret = ret.replace('{!currentLender}', appt.current_Lender__c == null ? '' : appt.current_Lender__c);
		ret = ret.replace('{!currentLoanType}', appt.current_Loan_Type__c == null ? '' : appt.current_Loan_Type__c);
		ret = ret.replace('{!currentInterestRateType}', appt.current_Interest_Rate_Type__c == null ? '' : appt.current_Interest_Rate_Type__c);
		ret = ret.replace('{!currentFinancials}', appt.current_Financials_Up_to_Date__c == null ? '' : appt.current_Financials_Up_to_Date__c);
		ret = ret.replace('{!lastRefinance}', appt.last_Refinance__c == null ? '' : appt.last_Refinance__c.format());
		ret = ret.replace('{!fixedRateExpiry}', appt.fixed_Rate_Expiry__c == null ? '' : appt.fixed_Rate_Expiry__c.format());
		ret = ret.replace('{!currentLoanAge}', appt.age_of_Current_Loan__c == null ? '' : appt.age_of_Current_Loan__c);
		ret = ret.replace('{!incomeLiabilityDetails}', ' ');
		ret = ret.replace('{!employmentStatus}', appt.employment_Status__c == null ? '' : appt.employment_Status__c);
		ret = ret.replace('{!industry}', appt.industry__c == null ? '' : appt.industry__c);

		ret = ret.replace('{!currentLoanValue}', appt.current_Loan_Value__c == null ? '' : '' + appt.current_Loan_Value__c);
		ret = ret.replace('{!currentInterestRate}', '' + appt.current_Interest_Rate__c);
		ret = ret.replace('{!annualIncome}', appt.annual_Income__c == null ? '' : '' + appt.annual_Income__c);
		ret = ret.replace('{!partnerAnualIncome}', appt.partner_Income__c == null ? '' : '' + appt.partner_Income__c);
		ret = ret.replace('{!creditCardBalance}', appt.credit_Card_Balance__c == null ? '' : '' + appt.credit_Card_Balance__c);
		ret = ret.replace('{!personalLoanBalance}', appt.personal_Loan_Balance__c == null ? '' : '' + appt.personal_Loan_Balance__c);

		return ret;
	}

	public static Event constructEvent(Appointment__c appt, Datetime startTime, Id ownerId, Broker__c broker, String tempDocumentName) {
		Integer durationOfMeeting = Integer.valueOf(Allocate_Appointment__c.getValues(AppointmentService.CHANNEL_TO_CONFIG_NAME.get(appt.brokerChannel__c)).durationOfMeeting__c);

		Event e = new Event();
		e.ownerid = ownerId;
		e.startdatetime = startTime;
		e.enddatetime = startTime.addminutes(durationOfMeeting);
		e.whatid = broker.id;
		e.description = constructAppointmentDescription(appt, tempDocumentName);
		e.location = EventService.constructAppointmentEventLocation(appt, ',');
		e.subject = EventService.constructAppointmentEventSubject(appt);
		return e;
	}

	public static String constructEmailBodyToNewBroker(Appointment__c appt, EmailTemplate emailTemplate) {
		string ret = '';
		ret = emailTemplate.htmlValue;
		ret = ret.replace('{!Broker.Name}', appt.broker__r.name == null ? '' : appt.broker__r.name);
		ret = ret.replace('[[AppRef]]', appt.name == null ? '' : appt.name);
		ret = ret.replace('[[Presales]]', appt.pre_Sales_User__c == null ? '' : appt.pre_Sales_User__c);
		ret = ret.replace('[[CustName]]', appt.account_Name__c == null ? '' : appt.account_Name__c);
		ret = ret.replace('[[CustEmail]]', appt.account_Email__c == null ? '' : appt.account_Email__c);
		ret = ret.replace('[[Mobile]]', appt.mobile__c == null ? '' : appt.mobile__c);
		ret = ret.replace('[[Phone]]', appt.phone__c == null ? '' : appt.phone__c);
		ret = ret.replace('[[AlternatePhone]]', appt.alternate_Phone__c == null ? '' : appt.alternate_Phone__c);
		ret = ret.replace('[[AppDateTime]]', appt.appointment_Date_and_Time__c == null ? '' : String.valueOf(appt.appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
		ret = ret.replace('[[StreetAddress]]', appt.street_Address__c == null ? '' : appt.street_Address__c);
		ret = ret.replace('[[City]]', appt.city__c == null ? '' : appt.city__c);
		ret = ret.replace('[[PostalCode]]', appt.postal_Code__c == null ? '' : appt.postal_Code__c);
		ret = ret.replace('[[State]]', appt.state__c == null ? '' : appt.state__c);
		ret = ret.replace('[[AppType]]', appt.appointment_Type__c == null ? '' : appt.appointment_Type__c);
		ret = ret.replace('[[preNote]]', appt.pre_Sales_Notes__c == null ? '' : appt.pre_Sales_Notes__c);
		ret = ret.replace('[[TransactionType]]', appt.transaction_Type__c == null ? '' : appt.transaction_Type__c);
		ret = ret.replace('[[CurrentLender]]', appt.current_Lender__c == null ? '' : appt.current_Lender__c);
		ret = ret.replace('[[CurrentLoanValue]]', appt.current_Loan_Value__c == null ? '' : String.valueOf(appt.current_Loan_Value__c));
		ret = ret.replace('[[CurrentLoanType]]', appt.current_Loan_Type__c == null ? '' : appt.current_Loan_Type__c);
		ret = ret.replace('[[CurrentInterestRate]]', appt.current_Interest_Rate__c == null ? '' : String.valueOf(appt.current_Interest_Rate__c));
		ret = ret.replace('[[CurrentInterestRateType]]', appt.current_Interest_Rate_Type__c == null ? '' : appt.current_Interest_Rate_Type__c);
		ret = ret.replace('[[CurrentFinancials]]', appt.current_Financials_Up_to_Date__c == null ? '' : appt.current_Financials_Up_to_Date__c);
		ret = ret.replace('[[FixedRate]]', appt.fixed_Rate_Expiry__c == null ? '' : String.valueOf(appt.fixed_Rate_Expiry__c));
		ret = ret.replace('[[lastRefinance]]', appt.last_Refinance__c == null ? '' : String.valueOf(appt.last_Refinance__c));
		ret = ret.replace('[[AgeCurrent]]', appt.age_of_Current_Loan__c == null ? '' : appt.age_of_Current_Loan__c);
		ret = ret.replace('[[EmploymentStatus]]', appt.employment_Status__c == null ? '' : appt.employment_Status__c);
		ret = ret.replace('[[Industry]]', appt.industry__c == null ? '' : appt.industry__c);
		ret = ret.replace('[[AnnualIncome]]', appt.annual_Income__c == null ? '' : String.valueOf(appt.annual_Income__c));
		ret = ret.replace('[[CreditCardBalance]]', appt.credit_Card_Balance__c == null ? '' : String.valueOf(appt.credit_Card_Balance__c));
		ret = ret.replace('[[PartnerIncome]]', appt.partner_Income__c == null ? '' : String.valueOf(appt.partner_Income__c));
		ret = ret.replace('[[CarLoanBalance]]', appt.car_Loan_Balance__c == null ? '' : String.valueOf(appt.car_Loan_Balance__c));
		ret = ret.replace('[[PersonalLoanBalance]]', appt.personal_Loan_Balance__c == null ? '' : String.valueOf(appt.personal_Loan_Balance__c));
		return ret;
	}

	public static String constructEmailBodyToOldBroker(Appointment__c appt, EmailTemplate emailTemplate) {
		String ret = emailTemplate.htmlValue;
		ret = ret.replace('{!Broker.Name}', appt.Broker__r.name == null ? '' : appt.Broker__r.name);
		ret = ret.replace('[[apptref]]', appt.name == null ? '' : appt.Name);
		ret = ret.replace('[[customer name and address]]', appt.Street_Address__c != null || appt.City__c!= null || appt.Postal_Code__c != null || appt.State__c!= null ? '' : EventService.constructAppointmentEventLocation(appt, ' '));
		ret = ret.replace('[[appointment date and time]]', String.valueOf(appt.Appointment_Date_and_Time__c == null ? '' : appt.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
		return ret;
	}

}