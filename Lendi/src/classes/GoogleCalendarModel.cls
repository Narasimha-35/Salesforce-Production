/*
* GoogleCalendarModel
*/

public class GoogleCalendarModel {

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

	public class FreeBusyRequest extends Model {
		//The start of the interval for the query.
		public Datetime timeMin;
		//The end of the interval for the query.
		public Datetime timeMax;
		//Time zone used in the response. Optional. The default is UTC.
		public String timeZone;
		//Maximal number of calendar identifiers to be provided for a single group. Optional. An error will be returned for a group with more members than this value.
		public Integer groupExpansionMax;
		//Maximal number of calendars for which FreeBusy information is to be provided. Optional.
		public Integer calendarExpansionMax;
		//List of calendars and/or groups to query.
		public List<FreeBusyQueryItem> items;

		public FreeBusyRequest() {
		}

		public FreeBusyRequest(Datetime timeMin, Datetime timeMax, List<String> ids) {
			this.timeMin = timeMin;
			this.timeMax = timeMax;
			this.items = new List<FreeBusyQueryItem>();

			for(String id : ids) {
				items.add(new FreeBusyQueryItem(id));
			}
		}
	}

	public class FreeBusyQueryItem extends Model {
		//The identifier of a calendar or a group.
		public String id;

		public FreeBusyQueryItem(String id) {
			this.id = id;
		}
	}

	public class FreeBusyResponse extends Model {
		//Type of the resource ("calendar#freeBusy").
		public String kind;
		//The start of the interval.
		public Datetime timeMin;
		//The end of the interval.
		public Datetime timeMax;
		//Expansion of groups.
		public Map<String, GroupsItems> groups;
		public Map<String, CalendarsItem> calendars;
	}

	public class GroupsItems extends Model {
		public List<Error> errors;
		public List<String> calendars;
	}

	public class Error extends Model {
		public String domain;
		public String reason;
	}

	public class CalendarsItem extends Model {
		public List<Error> errors;
		public List<BusyItem> busy;
	}

	public class BusyItem extends Model {
		public Datetime start;
		public Datetime param_rr_end;
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