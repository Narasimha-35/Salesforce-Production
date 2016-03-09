public with sharing class GoogleCalendarModel {

	public class RequestBody extends Model {
		public CalendarTime param_end {get; set;}
		public CalendarTime param_start {get; set;}
		public String description {get; set;}
		public List<Attendee> attendees {get; set;}
		public String summary {get; set;}
		public String location {get; set;}
		public Boolean guestsCanModify {get; set;}
		public Boolean guestsCanInviteOthers {get; set;}

		public RequestBody(Event e) {
			param_start = new CalendarTime(e.startDateTime, e.timeZone__c);
			param_end = new CalendarTime(e.endDateTime, e.timeZone__c);
			description = e.description;
			summary = e.subject;
			location = e.location;
			guestsCanModify = true;
			guestsCanInviteOthers = true;
		}

		public String getJSON() {
			return JSON.serialize(this).replace('param_','');
		}
	}

	public class CalendarTime extends Model {
		public Datetime param_dateTime {get; set;}
		public String timeZone {get; set;}

		public CalendarTime(Datetime dt, String TimeZone) {
			param_dateTime = dt;
			this.timeZone = timezone;
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
