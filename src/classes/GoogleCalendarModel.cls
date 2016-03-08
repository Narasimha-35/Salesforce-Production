public with sharing class GoogleCalendarModel {

	public class RequestBody extends Model {
		public CalendarTime endTime {get; set;}
		public CalendarTime startTime {get; set;}
		public String param_end {get; set;}
		public String param_start {get; set;}
		public String description {get; set;}
		public List<Attendee> attendees {get; set;}
		public String summary {get; set;}
		public String location {get; set;}
		public Boolean guestsCanModify {get; set;}
		public Boolean guestsCanInviteOthers {get; set;}

		public RequestBody(Event e) {
			startTime = new CalendarTime(e.startDateTime, e.timeZone__c);
			endTime = new CalendarTime(e.endDateTime, e.timeZone__c);
			param_start = startTime.getJSON();
			param_end = endTime.getJSON();
			description = e.description;
			summary = e.subject;
			location = e.location;
			guestsCanModify = true;
			guestsCanInviteOthers = true;
		}

		public String getJSON() {
			return JSON.serialize(this).replace('param_','').replace('\\', '');
		}
	}

	public class CalendarTime extends Model {
		public Datetime param_dateTime {get; set;}
		public String timeZone {get; set;}

		public CalendarTime(Datetime dt, String TimeZone) {
			param_dateTime = dt;
			this.timeZone = timezone;
		}

		public String getJSON() {
			return '{"dateTime":"' + param_dateTime.format('yyyy-MM-dd\'T\'HH:mm:ss', timezone) + '", "timeZone":"' + timeZone + '"}';
		}
	}

	public class Attendee extends Model {
		public String email {get; set;}
		public String displayName {get; set;}
	}

	public class ResponseBody {
		public String id;
	}

}
