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
		public List<String> recurrence {get; set;}
		public String id {get; set;}

		public RequestBody(String jsonString) {
			jsonString = jsonString.replace('"end":', '"param_end":').replace('"start":', '"param_start":').replace('"dateTime":', '"param_dateTime":').replace('\\"', '');
			System.debug(jsonString);
			GoogleCalendarModel.RequestBody req = (GoogleCalendarModel.RequestBody) JSON.deserialize(jsonString, GoogleCalendarModel.RequestBody.class);
			param_end = req.param_end;
			param_start = req.param_start;
			description = req.description;
			attendees = req.attendees;
			summary = req.summary;
			location = req.location;
			guestsCanModify = req.guestsCanModify;
			guestsCanInviteOthers = req.guestsCanInviteOthers;
			recurrence = req.recurrence;
			id = req.id;
		}

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

	public class Recurrence {
		public String RRULE;
		public String EXRULE;
		public String RDATE;
		public String EXDATE;
	}

	// RECUR defined in rfc5545
	public class Recur extends Model {
		public String FREQ;
		public Datetime UNTIL;
		public Integer COUNT;
		public Integer INTERVAL;
		public List<Integer> BYSECOND;
		public List<Integer> BYMINUTE;
		public List<Integer> BYHOUR;
		public List<Integer> BYDAY;
		public List<Integer> BYMONTHDAY;
		public List<Integer> BYYEARDAY;
		public List<Integer> BYWEEKNO;
		public List<Integer> BYMONTH;
		public List<Integer> BYSETPOS;
		public String WKST;

		public Recur(String recur) {
			Map<String, String> recurMap = GoogleCalendarUtility.parseRecur(recur);
			String temp;
			for(String s : recurMap.keySet()) {
				if('FREQ' == s) {
					FREQ = recurMap.get(s);
				} else if('UNTIL' == s) {
					String datetm = recurMap.get(s);
					if(datetm.length() > 8) {
						temp = datetm.substring(0,4) + '-' + datetm.substring(4,6) + '-' + datetm.substring(6,11) + ':' + datetm.substring(11,13) + ':' + datetm.substring(13,16);
						temp = temp.replace('T',' ');
						temp = temp.replace('Z','');
					} else {
						temp = datetm.substring(0,4) + '-' + datetm.substring(4,6) + '-' + datetm.substring(6,8) + ' 00:00:00';
					}
					UNTIL = DateTime.valueOfGmt(temp);
				}
				// } else if('COUNT' == s) {
				// 	COUNT = recurMap.get(s);
				// } else if('INTERVAL' == s) {
				// 	INTERVAL = recurMap.get(s);
				// } else if('BYSECOND' == s) {
				// 	BYSECOND = recurMap.get(s);
				// } else if('BYMINUTE' == s) {
				// 	BYMINUTE = recurMap.get(s);
				// } else if('BYHOUR' == s) {
				// 	BYHOUR = recurMap.get(s);
				// } else if('BYDAY' == s) {
				// 	BYDAY = recurMap.get(s);
				// } else if('BYMONTHDAY' == s) {
				// 	BYMONTHDAY = recurMap.get(s);
				// } else if('BYYEARDAY' == s) {
				// 	BYYEARDAY = recurMap.get(s);
				// } else if('BYWEEKNO' == s) {
				// 	BYWEEKNO = recurMap.get(s);
				// } else if('BYMONTH' == s) {
				// 	BYMONTH = recurMap.get(s);
				// } else if('BYSETPOS' == s) {
				// 	BYSETPOS = recurMap.get(s);
				// } else if('WKST' == s) {
				// 	WKST = recurMap.get(s);
				// }
			}
		}
	}

}
