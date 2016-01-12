global class Chen_GoogleCalenderHelper {
	
	public static Boolean deleteEventOnGoogleCalendar(String emailAddress, String googleEventId, Boolean sendNotification) {
		Boolean result = false;
		Saasfocus_GenerateToken ob= new Saasfocus_GenerateToken();
        Google_API_Setting__c  obj= ob.CheckAccessToken();
        String brokerEmail = null;
        if (emailAddress.contains('%')) {
        	String[] emails = emailAddress.split('%');
        	brokerEmail = emails[0];
        } else {
        	brokerEmail = emailAddress;
        }
        String endPoint = 'https://www.googleapis.com/calendar/v3/calendars/' + brokerEmail + '/events/' + googleEventId + '?sendNotifications=true&key='+obj.API_KEY__c;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);     
        //req.setHeader('Content-Type','application/json');
        //req.setHeader('Accept','application/x-www-form-urlencoded');
        // req.setHeader('Content-length', '200');  
        req.setHeader('Authorization','Bearer '+obj.Access_Token__c);
        //req.setBody(strBody);
        req.setMethod('DELETE');
        String request = req.getBody();
        Http http = new Http();
        if (Test.isRunningTest()) {
        	Httpresponse res = new Httpresponse();
        	res.setStatusCode(204);
        	if(res.getStatusCode() == 204) {
	        	System.debug('Reach to here mate, success');
	        	//delete the salesforce event as well;
	        	String constructGoogleEventId = googleEventId + '~' + emailAddress;
	        	List<Event> eventToBeDeleted = [select Id, Google_Event_ID__c, Subject from event where Google_Event_ID__c = :constructGoogleEventId];
	        	if (eventToBeDeleted.size() > 0) {
	        		delete eventToBeDeleted.get(0);
	        	}
	        }
        } else {
        	Httpresponse res = http.send(req);
	        //To indicate success, you can return any of the following status codes: 200, 201, 202, 204, or 102
	        if(res.getStatusCode() == 204) {
	        	result = true;
	        	System.debug('Reach to here mate, success');
	        	//delete the salesforce event as well;
	        	String constructGoogleEventId = googleEventId + '~' + emailAddress;
	        	List<Event> eventToBeDeleted = [select Id, Google_Event_ID__c, Subject from event where Google_Event_ID__c = :constructGoogleEventId];
	        	if (eventToBeDeleted.size() > 0) {
	        		delete eventToBeDeleted.get(0);
	        	}
	        } else {
	        	String bodyText = 'req : ' + req.getBody() + ' res : ' + res.getBody();
	        	//send chen email about the failure
	        	sendChenFailedEmail(bodyText);
	        }
	        System.debug('finish the program');
        }
        return result;
	}
	
	public static Datetime getGMT(Datetime l) {    
        Date d = l.dateGmt();
        Time t = l.timeGmt();
         return Datetime.newInstance(d,t);
    }
	
	public static Datetime getLocalDateTime(Datetime z, decimal offset) {
		System.debug(z);    
		TimeZone tz = UserInfo.getTimeZone();
		Datetime localTime = z.AddSeconds(tz.getOffset(z)/1000);
		localTime = localTime.addMinutes((Integer)(offset * 60));
		System.debug(localTime);
		return localTime;
    }
	
	Webservice static Boolean deleteEventByAppointment(Id appointmentId) {
		Boolean result = false;
		//email, and appointment ref
		List<Appointment__c> appointments = [select Id, Name, Region__r.Sydney_Timezone_Offset__c, Appointment_Date_and_Time__c, Broker_Email__c from Appointment__c where Id = :appointmentId];
		if (appointments.size() > 0) {
			if (appointments.get(0).Broker_Email__c != null && appointments.get(0).Name != null) {
				String subjectLike = '\'' + appointments.get(0).Name + '%' + '\'';
				Datetime localTime = getLocalDateTime(appointments.get(0).Appointment_Date_and_Time__c, appointments.get(0).Region__r.Sydney_Timezone_Offset__c);
				System.debug(localTime);
				String googleEventIdLike = '\'' + '%' + appointments.get(0).Broker_Email__c + '%\'';
				String query = 'Select Id, Google_Event_ID__c from event where Subject like ' + subjectLike + ' and Google_Event_ID__c like ' + googleEventIdLike;
				System.debug(query);
				List<event> events = Database.query(query);
				if (events.size() > 0 && events.size() == 1 && events.get(0).Google_Event_ID__c != null) {
					String[] googleEmail = events.get(0).Google_Event_ID__c.split('~');
					if (googleEmail.size() == 2) {
						result = deleteEventOnGoogleCalendar(googleEmail[1], googleEmail[0], true);
					}
				}
			}
		}
		return result;
	}
	
	Webservice static void rescheduleAppointment(Id appointmentId) {
		List<Appointment__c> appointments = [select Id, RecordTypeId, Broker_Mobile__c, Broker__c, Appointment_Status__c From Appointment__c where Id = :appointmentId];
		if (appointments.size() > 0) {
			Boolean result = deleteEventByAppointment(appointmentId);
			// need a new field to mark this is a rescheudled appointment
			appointments.get(0).Is_Rescheduled_Appointment__c = true;
			// record type to new
			Id devRecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('New').getRecordTypeId();
			appointments.get(0).RecordTypeId = devRecordTypeId;
			//save the phone number
			String oldBrokerMobile = appointments.get(0).Broker_Mobile__c;
			appointments.get(0).Previous_Broker_Mobile__c = oldBrokerMobile;
			// status to new
			appointments.get(0).Appointment_Status__c = 'New';
			// broker to ? workflow
			Broker__c broker = [select Id from Broker__c where email__c = 'who@creditandfinance.com.au'];
			appointments.get(0).Broker__c = broker.Id;
			update appointments;
			if (!result) {
				String bodyText = 'Appointment reschedule is failed: ' + appointmentId;
	        	//send chen email about the failure
	        	sendChenFailedEmail(bodyText);
			}
			
		}
	}
	
	public static void sendChenFailedEmail(String bodyText) {
		List<Messaging.SingleEmailMessage> mailsS = new List<Messaging.SingleEmailMessage>();
        	Messaging.SingleEmailMessage mailsSc = new Messaging.SingleEmailMessage();
        	List<String> sendToEmails = new List<String>();
      		sendToEmails.add('chen@creditandfinance.com.au');
      		mailsSc.setToAddresses(sendToEmails);
      		
      		mailsSc.setReplyTo('chen@creditandfinance.com.au');
      		mailsSc.setSenderDisplayName('Reschedule Checker');
      		mailsSc.setSubject('Reschedule Failed');
      		
      		mailsSc.setHtmlBody(bodyText);
      		mailsS.add(mailsSc);
      		Messaging.sendEmail(mailsS);
	}
}