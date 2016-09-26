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

	// Condition if Event is update, delete previous event and insert new Event
	public static void upsertSFEventAndGoogleEvent(List<Google_Recurring_Events__c> glist, List<Event> Evt_list) {
		try{
			Set<string> st = new Set<string>();
			List<Google_Recurring_Events__c> lstREinsert = new List<Google_Recurring_Events__c>();
			for(Google_Recurring_Events__c ob11 :glist){
				st.add(ob11.Google_Event_Id__c);
				Google_Recurring_Events__c g_obj = new Google_Recurring_Events__c();
				g_obj.Name=ob11.Name;
				g_obj.Start_date__c=ob11.Start_date__c;
				g_obj.End_date__c=ob11.End_date__c;
				g_obj.Summary__c=ob11.Summary__c;
				g_obj.Google_Event_Id__c=ob11.Google_Event_Id__c;
				g_obj.Description__c=ob11.Description__c;
				g_obj.Broker__c=ob11.Broker__c;
				if(ob11.Multiday__c==true){
					g_obj.Multiday__c=true;
				} else {
					g_obj.Recurring_Events__c=true;
					g_obj.Repeats_on__c=ob11.Repeats_on__c;
					if(ob11.ByDay__c!=null){
						g_obj.ByDay__c=ob11.ByDay__c;
					}
					if(ob11.Count__c!=null){
						g_obj.Count__c=ob11.Count__c;
					}
					if(ob11.Until__c!=null){
						g_obj.Until__c=ob11.Until__c;
					}
					g_obj.Freq__c=ob11.Freq__c;
					g_obj.Interval__c=ob11.Interval__c;
				}

				if(ob11.Assigned_To__c!=null) {
					g_obj.Assigned_To__c=ob11.Assigned_To__c;
				}
				lstREinsert.add(g_obj);
			}
			List<Event> lstEvent = new List<Event>();
			List<Google_Recurring_Events__c> lstRE = new List<Google_Recurring_Events__c>();
			lstRE = [select id,Google_Event_ID__c from Google_Recurring_Events__c where Google_Event_Id__c in :st];
			st = new Set<string>();
			for(Google_Recurring_Events__c ob22 :lstRE){
				st.add(ob22.id);
			}

			lstEvent = [select id from Event where Event_ID__c in :st];
			if(lstEvent.size() > 0) {
				delete lstEvent;
			}
			if(lstRE.size() > 0) {
				delete lstRE;
			}
			List<Google_Recurring_Events__c> lstREC1 = new List<Google_Recurring_Events__c>();
			if(lstREinsert.size() > 0){
				for(Google_Recurring_Events__c ob :lstREinsert) {
					lstREC1.add(ob);
				}
				//insert lstREC1;
				if(lstREC1.size()>0) {
					insert lstREinsert;
				}
			}
		} catch(Exception e){
			system.debug('!Bingo error=> '+e);
		}
		upsert Evt_list Google_Event_ID__c;
	}

	public static List<Saasfocus_EventClass> getRetrunList(List<Saasfocus_EventClass> eventList, Set<String> deleteEventIds, Set<String> recIds) {
		List<Saasfocus_EventClass> ret = new List<Saasfocus_EventClass>();
		for(Saasfocus_EventClass et : eventList) {
			if(!deleteEventIds.contains(et.email) && !recIds.contains(et.email)) {
				String[] Idarray = (et.Email).split('~');
				et.email = Idarray[1];
				ret.add(et);
			}
		}
		return ret;
	}
}
