public with sharing class GoogleCalendarUtility {
	private static final String SERVER_NAME = 'https://www.googleapis.com';
	private static final String APPLICATION_NAME = 'calendar';
	private static final String API_VERSION = 'v3';

	public static String getAccessToken() {
		Saasfocus_GenerateToken ob = new Saasfocus_GenerateToken();
		Google_API_Setting__c  obj = ob.CheckAccessToken();
		return obj.Access_Token__c;
	}

	public static String constructEndPoint(Event e, String googleAccount) {
		String ret;
		String baseURL = SERVER_NAME + '/' + APPLICATION_NAME + '/' + API_VERSION + '/' + 'calendars';
		String params = '?sendNotifications=true';

		if(e.googleId__c == null) {
			ret = baseURL + '/' + googleAccount + '/events' + params;
		} else {
			ret = baseURL + '/' + googleAccount + '/events/' + e.googleId__c + params;
		}

		return ret;
	}

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

	//TODO: remove broker and make this class can handle a list of event
	public static GoogleCalendarModel.ResponseBody insertCalenderEvent(Event event, Broker__c broker) {
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
		return handleResponse(http.send(req));
	}

	// This Method will make callOut Request and create Data On Google
	// This method will id of event as an argument which are related to the Broker.
	// TODO: input List<id> instead of List<String>
	// TODO: handle whatid == null
	public static void insertGoogleEvent(List<String> ids){
		List<Event> successSyncedEventList = new List<Event>();
		EventSelector es = new EventSelector();
		List<Event> eventList = new List<Event>();

		eventList = es.getById(ids);
		Map<Id, Broker__c> bmap = EventService.getRelatedBrokerMap(eventList);

		for(Event event: eventList){
			if(event.Google_Event_ID__c != null) continue;
			Broker__c broker = bmap.get(event.whatId);
			GoogleCalendarModel.ResponseBody res = GoogleCalendarUtility.insertCalenderEvent(event, broker);
			system.debug(LoggingLevel.INFO, '[GoogleCalendarUtility] Google ResponseBody: ' + res);
			event.google_Event_ID__c = GoogleCalendarUtility.generateGoogleEventId(res.id, broker.email__c);
			event.googleId__c = res.id;
			successSyncedEventList.add(event);
		}

		system.debug(LoggingLevel.INFO, '[GoogleCalendarUtility] success Synced Event List: ' + successSyncedEventList);
		update successSyncedEventList;
	}

	public static void addDebugEmailRequest(String className, String methodName, String detail, HttpRequest req, HttpResponse res) {
		List<String> recipients = ((String) ACFEmailList__c.getOrgDefaults().get('GoogleCalendarEmailReceiver__c')).split(',');

		SFModel.DebugEmailRequest ret = new SFModel.DebugEmailRequest();
		ret.recipients = recipients;
		ret.subject = 'Salesforce Debug';
		ret.projectName = 'Google Calendar Sync';
		ret.className = className;
		ret.methodName = methodName;
		if(req != null && res != null) {
			ret.setDetails(req, res);
		} else {
			ret.detail = detail;
		}
		GoogleCalendarService.DebugEmailRequests.add(ret);
	}

	public class SyncException extends Exception {
	}

	public class DataException extends Exception {
	}
}
