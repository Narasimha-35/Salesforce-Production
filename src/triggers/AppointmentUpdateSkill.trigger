trigger AppointmentUpdateSkill on Appointment__c (before update) {
	// for appointment type == phone appointment
	// check if the receive phone appointment is not there
	// if not 
	
	for (Appointment__c appobj:trigger.new) {
		if (appobj.Appointment_Type__c != null && appobj.Appointment_Type__c == 'Phone Appointment') {
			if (appobj.Speciality_Skills__c == null || appobj.Speciality_Skills__c == '') {
				appobj.Speciality_Skills__c = 'Receive Phone Appointment';
			} else if (!appobj.Speciality_Skills__c.contains('Receive Phone Appointment')) {
				//if it contains SK-, do not have the receive phone appointment
				if (!appobj.Speciality_Skills__c.contains('SK-')) {
					appobj.Speciality_Skills__c = appobj.Speciality_Skills__c + ';Receive Phone Appointment';
				}
			}
		}
	}
}