public with sharing class GoogleCalendarUtility {
	private static final String SERVER_NAME = 'https://www.googleapis.com';
	private static final String APPLICATION_NAME = 'calendar';
	private static final String API_VERSION = 'v3';

	public static String getAccessToken() {
		Saasfocus_GenerateToken ob = new Saasfocus_GenerateToken();
		Google_API_Setting__c  obj = ob.CheckAccessToken();
		return obj.Access_Token__c;
	}

	//TODO: remove broker and make this class can handle a list of event
	public static HttpResponse insertCalenderEvent(Event event, Broker__c broker) {
		GoogleCalendarModel.RequestBody reqBody = new GoogleCalendarModel.RequestBody(event);
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint(constructEndPoint(event, broker.email__c));
		req.setHeader('Content-Type','application/json');
		req.setHeader('Authorization','Bearer ' + GoogleCalendarUtility.getAccessToken());
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

	public class SyncException extends Exception {
	}

}
