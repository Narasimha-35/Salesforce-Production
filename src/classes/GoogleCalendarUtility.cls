public with sharing class GoogleCalendarUtility {
	private static final String SERVER_NAME = 'https://www.googleapis.com';
	private static final String APPLICATION_NAME = 'calendar';
	private static final String API_VERSION = 'v3';

	public class SyncException extends Exception {
	}

	public static String getAccessToken() {
		Saasfocus_GenerateToken ob = new Saasfocus_GenerateToken();
		Google_API_Setting__c  obj = ob.CheckAccessToken();
		return obj.Access_Token__c;
	}

	//TODO: remove broker and make this class can handle a list of event
	public static HttpResponse insertCalenderEvent(Event event, Broker__c broker) {
		System.debug(LoggingLevel.INFO, '[GoogleCalendarUtility.insertCalenderEvent] event: ' + event);
		System.debug(LoggingLevel.INFO, '[GoogleCalendarUtility.insertCalenderEvent] broker: ' + broker);
		GoogleCalendarModel.RequestBody reqBody = new GoogleCalendarModel.RequestBody(event);
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint(constructEndPoint(event, broker.email__c));
		req.setHeader('Content-Type','application/json');
		req.setHeader('Authorization','Bearer ' + GoogleCalendarUtility.getAccessToken());
		System.debug(LoggingLevel.INFO, '[GoogleCalendarUtility.insertCalenderEvent] request body: ' + reqBody.getJSON());
		req.setBody(reqBody.getJSON());

		Http http = new Http();
		return http.send(req);
	}

	public static String constructEndPoint(Event e, String googleAccount) {
		String ret;
		String baseURL = SERVER_NAME + '/' + APPLICATION_NAME + '/' + API_VERSION + '/' + 'calendars';
		String params = '?sendNotifications=true';

		if(e.Google_Event_ID__c == null) {
			ret = baseURL + '/' + googleAccount + '/events' + params;
		} else {
			ret = baseURL + '/' + googleAccount + '/events/' + e.Google_Event_ID__c + params;
		}

		return ret;
	}

	//could remove
	public static String generateGoogleEventId(String googleId, String brokerEmail) {
		return googleId + '~' + brokerEmail;
	}

	public static GoogleCalendarModel.ResponseBody handleResponse(HttpResponse res) {
		GoogleCalendarModel.ResponseBody ret = null;
		system.debug(LoggingLevel.INFO, '[GoogleCalendarUtility] Google Response: '+res.getBody());

		if(res.getStatusCode() == 200) {
			ret = (GoogleCalendarModel.ResponseBody)JSON.deserialize(res.getBody(), GoogleCalendarModel.ResponseBody.Class);
		} else {
			throw new SyncException();
		}
		return ret;
	}

	public static GoogleCalendarModel.Recurrence parseRecurrence(List<String> recurrence) {
		GoogleCalendarModel.Recurrence ret = new GoogleCalendarModel.Recurrence();
		for(String s : recurrence) {
			if(s.startsWith('RRULE')) {
				ret.RRULE = s;
			} else if(s.startsWith('EXRULE')) {
				ret.EXRULE = s;
			} else if(s.startsWith('RDATE')) {
				ret.RDATE = s;
			} else if(s.startsWith('EXDATE')) {
				ret.EXDATE = s;
			}
		}
		return ret;
	}

	public static Map<String, String> parseRecur(String recur) {
		Map<String, String> ret = new Map<String, String>();
		List<String> tList = recur.substringAfter(':').split(';');
		for(String s : tList) {
			List<String> param = s.split('=');
			ret.put(param[0], param[1]);
		}
		return ret;
	}

	public static Google_Recurring_Events__c castGoogleEvent(GoogleCalendarModel.RequestBody req, Broker__c broker) {
		Google_Recurring_Events__c ret = new Google_Recurring_Events__c();
		if(req.summary != null) {
			ret.name = req.summary.left(80);
			ret.summary__c = req.summary.left(255);
		}
		ret.description__c = req.description;
		ret.start_Date__c = req.param_start.param_dateTime;
		ret.end_date__c = req.param_end.param_dateTime;
		ret.google_Event_Id__c = req.id + '~' + broker.email__c;
		if(req.recurrence == null || req.recurrence.size() == 0) {
			ret.recurring_Events__c = true;
			Map<String, String> reqMap = parseRecur(req.recurrence[0]);
			ret.freq__c = reqMap.get('freq');
		} else {
			ret.recurring_Events__c = false;
		}

		ret.broker__c = broker.id;

		return ret;
	}

	public static Google_Recurring_Events__c parseRecurrence(Map<String, String> rRuleRecurMap, Google_Recurring_Events__c GObj) {
		if(rRuleRecurMap.get('FREQ') == 'WEEKLY') { // Condition for Weekly Event
			if(rRuleRecurMap.get('BYDAY') != null) {
				String byd = (GObj.Start_Date__c).format('E').left(2);
				GObj.ByDay__c = byd.toUpperCase();
			}
			GObj.Freq__c='WEEKLY';
		} else if (rRuleRecurMap.get('FREQ') == 'DAILY') { // Condition for Daily Event
			GObj.Freq__c='DAILY';
		} else if (rRuleRecurMap.get('FREQ') == 'MONTHLY') { // Condition for Monthly Event
			if(rRuleRecurMap.get('BYDAY') != null) {
				String bydayst = rRuleRecurMap.get('BYDAY');
				if(bydayst.contains('-1')) {
					GObj.Repeats_on__c = (String)bydayst.substring(0,2);
					GObj.ByDay__c = bydayst.substring(2);
					system.debug(GObj.Repeats_on__c+'hhhhhhh'+GObj.ByDay__c);
				} else {
					GObj.Repeats_on__c = (String)bydayst.substring(0,1);
					GObj.ByDay__c = bydayst.substring(1);
					system.debug(GObj.Repeats_on__c+'hhhhhhh'+GObj.ByDay__c);
				}
			}
			GObj.Freq__c='MONTHLY';
		} else if (rRuleRecurMap.get('FREQ') == 'YEARLY') { // Condition for Yearly Event
			GObj.Freq__c='YEARLY';
		}
		return GObj;
	}

}
