trigger AppointmentPreCheckBox on Appointment__c (before insert) {
	//check the current user profile Id
	User currentUser = [select ManagerId, Profile.Name from User where id = :userinfo.getuserid()];
	//check the box
	if (currentUser != null && currentUser.Profile.Name == 'PreSales Team') {
		for (Appointment__c appt : trigger.new ) {
			appt.Test_New_Appointment_Allocation__c = true;
		}
	}
}