/*
* GoogleCalendarUtility
*/

public class GoogleCalendarUtility {
	private static final String SERVER_NAME = 'https://www.googleapis.com';
	private static final String APPLICATION_NAME = 'calendar';
	private static final String API_VERSION = 'v3';
	private static GoogleAuth gAuth;

	public static String getAccessToken() {
		gAuth = GoogleAuth.getInstance('calendar');
		return gAuth.getAccessToken();
	}

	public static void updateGoogleSetting() {
		gAuth = GoogleAuth.getInstance('calendar');
		gAuth.updateAccessToken();
	}

	//TODO: remove broker and make this class can handle a list of event
	public static HttpRequestResponse insertCalenderEvent(Event event, Broker__c broker) {
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
		return new HttpRequestResponse(req, http.send(req));
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

	public static GoogleCalendarModel.ResponseBody handleResponse(HttpRequestResponse httpRR) {
		GoogleCalendarModel.ResponseBody ret = null;
		system.debug(LoggingLevel.INFO, '[GoogleCalendarUtility] Google Response: ' + httpRR.res.getBody());

		if(httpRR.res.getStatusCode() == 200) {
			ret = (GoogleCalendarModel.ResponseBody)JSON.deserialize(httpRR.res.getBody(), GoogleCalendarModel.ResponseBody.Class);
		} else {
			throw new HttpRequestResponse.HttpException(httpRR);
		}
		return ret;
	}

	public static Boolean isBusy(Datetime startTime, Datetime endTime, List<Saasfocus_EventClass> events) {
		for(Saasfocus_EventClass e : events) if(isBusy(startTime, endTime, e)) return true;
		return false;
	}

	public static Boolean isBusy(Datetime startTime, Datetime endTime, Saasfocus_EventClass event) {
		Datetime st = Datetime.valueOf(event.startDateTime);
		Datetime ed = Datetime.valueOf(event.endDateTime);

		if(startTime.getTime() < st.getTime() && endTime.getTime() > ed.getTime()) return true;
		if(st.getTime() < startTime.getTime() && startTime.getTime() < ed.getTime()) return true;
		if(st.getTime() < endTime.getTime() && endTime.getTime() < ed.getTime()) return true;
		return false;
	}

	public static HttpRequest constructFreeBusyReq() {
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint('https://www.googleapis.com/calendar/v3/freeBusy');
		req.setHeader('Content-Type','application/json');
		req.setHeader('Authorization','Bearer ' + getAccessToken());
		return req;
	}

	public static GoogleCalendarModel.FreeBusyResponse getFreeBusy(GoogleCalendarModel.FreeBusyRequest fbReq) {
		HttpRequest req = constructFreeBusyReq();
		req.setBody(fbReq.serializeJSON());
		Http http = new Http();
		HttpResponse res = http.send(req);
		System.debug(res.getBody());
		return (GoogleCalendarModel.FreeBusyResponse) Model.deserializeJSON(res.getBody(), GoogleCalendarModel.FreeBusyResponse.class);
	}

	public static GoogleCalendarModel.FreeBusyResponse getFreeBusy(Datetime timeMin, Datetime timeMax, String calendarId) {
		GoogleCalendarModel.FreeBusyRequest fbReq = new GoogleCalendarModel.FreeBusyRequest(timeMin, timeMax, new List<String>{calendarId});
		return getFreeBusy(fbReq);
	}

	public static List<GoogleCalendarModel.BusyItem> getListOfBusyItems(Datetime timeMin, Datetime timeMax, String calendarId) {
		return getFreeBusy(timeMin, timeMax, calendarId).calendars.get(calendarId).busy;
	}

}
