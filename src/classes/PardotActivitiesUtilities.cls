global class PardotActivitiesUtilities {
	public static final String USER_KEY = Utilities.getPardotUserKey();
	public static final String USER_PASSWORD = Utilities.getPardotUserPassword();
	public static final String USER_EMAIL = Utilities.getPardotUserEmail();
	public static String apiKey {get; set;}
	public static final String HTTP_METHOD_GET = 'GET';
	public static final String HTTP_METHOD_POST = 'POST';
	
	public static String loginToPardot() {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String loginErrorMessage = '';
        req.setEndPoint('https://pi.pardot.com/api/login/version/3');
        req.setBody('email=' + USER_EMAIL +
                    '&password=' + USER_PASSWORD +
                    '&user_key=' + USER_KEY);  
                             
        req.setMethod(HTTP_METHOD_POST);
        res = http.send(req);
        Dom.Document doc = res.getBodyDocument();
        apiKey = XmlUtilities.getAPIKeyFromPardot(doc);
        return apiKey;  
    }
    
    Webservice static void getPardotActivitiesJS(String leadId) {
    	Lead lead =LeadDAO.getLeadById(leadId);
    	if (lead != null && lead.Email != '') {
    		getPardoctVisitorActivities(lead.Email, lead);
    	}
    }
    
   	public static void getPardoctVisitorActivities(String emailAsId, Lead lead) {
   		if (Test.isRunningTest()) {
   			String xmlToParse = '<?xml version="1.0" encoding="UTF-8"?><rsp stat="ok" version="1.0"><prospect><id>64729856x</id><visitor_activities><visitor_activity><id>25637212x</id><type>4</type><type_name>Form Handler</type_name><details>Form - Affiliate - kobi - Mortgage Checkbox</details><form_handler_id>26</form_handler_id><campaign><id>634</id><name>Affiliate - Mortgage Checkbox</name></campaign><created_at>2015-02-02 10:30:08</created_at></visitor_activity></visitor_activities></prospect></rsp>';
   			DOM.Document doc = new DOM.Document();      
		  	try {
		    	doc.load(xmlToParse);    
		    	String prospectId = XmlUtilities.getProspectId(doc);
		        //Get all the activities information
		        getAllPardotActivitiesByProspect(prospectId, lead);
		 	 } catch (System.XMLException e) {  // invalid XML
			    System.debug(e.getMessage());
			 }
   		} else {
   			apiKey = loginToPardot();
	        HttpRequest req = new HttpRequest();
	        HttpResponse res = new HttpResponse();
	        Http http = new Http();
	                  
	        //user_key is the 'API User Key' field on the 'Settings' page in Pardot
	         // Ensure that the specified user account has at least "Marketing" access privileges.
	        req.setEndPoint('https://pi.pardot.com/api/prospect/version/3/do/read/email/' + emailAsId + '?');
	        req.setBody('api_key=' + apiKey +
	                    '&user_key=' + USER_KEY +
	                    '&email=' + emailAsId +
	                    '&output=full' +
	                    '&format=xml');
	                             
	        req.setMethod('POST');
	        res = http.send(req);
	        Dom.Document doc = res.getBodyDocument();
	        String prospectId = XmlUtilities.getProspectId(doc);
	        //Get all the activities information
	        getAllPardotActivitiesByProspect(prospectId, lead);
	        //XmlUtilities.getPardotActivities(doc, lead);
   		}
   	}
   	
   	public static void getAllPardotActivitiesByProspect(String prospectId, Lead lead) {
   		if (Test.isRunningTest()) {
   			String xmlToParse = '<?xml version="1.0" encoding="UTF-8"?><rsp stat="ok" version="1.0"><result><total_results>3</total_results><visitor_activity><id>11109005x</id><prospect_id>64729856x</prospect_id><type>6</type><type_name>Email</type_name><details>Free Property Report</details><email_id>2414023x</email_id><campaign><id>718</id><name>How much is your property worth?</name></campaign><created_at>2015-01-14 21:26:30</created_at></visitor_activity><visitor_activity><id>15713522x</id><visitor_id>4547794x</visitor_id><prospect_id>64729856x</prospect_id><type>20</type><type_name>Visit</type_name><details>3 page views</details><visit_id>5393814x</visit_id><campaign><id>228x</id><name>Had your mortgage for more than 2 years</name></campaign><created_at>2015-01-20 09:07:57</created_at></visitor_activity><visitor_activity><id>19687198x</id><visitor_id>4547794x</visitor_id><prospect_id>64729856</prospect_id><type>20</type><type_name>Visit</type_name><details>2 page views</details><visit_id>6836828</visit_id><campaign><id>228</id><name>Had your mortgage for more than 2 years</name></campaign><created_at>2015-01-24 20:40:51</created_at></visitor_activity></result></rsp>';
   			DOM.Document doc = new DOM.Document();
   			try {
   				doc.load(xmlToParse);
   				XmlUtilities.getPardotActivitiesByProspectXml(doc, lead, prospectId);
   			} catch (System.XMLException e) {
   				System.debug(e.getMessage());
   			}
   		} else {
   			if (prospectId != null) {
   				HttpRequest req = new HttpRequest();
		        HttpResponse res = new HttpResponse();
		        Http http = new Http();
		        
		        req.setEndPoint('https://pi.pardot.com/api/visitorActivity/version/3/do/query?');
		        req.setBody('api_key=' + apiKey +
	                    '&user_key=' + USER_KEY +
	                    '&prospect_id=' + prospectId);
		        req.setMethod('POST');
	        	res = http.send(req);
	        	Dom.Document doc = res.getBodyDocument();
	        	//System.debug(res.getBody());
	        	XmlUtilities.getPardotActivitiesByProspectXml(doc, lead, prospectId);
	        	//getAllVisitView(activities, prospectId);
   			}
   		}
   	}
   
   	public static Map<String, List<Visitor_Page_View__c>> getAllVisitView(List<Pardot_Visitor_Activity__c> activities, String prospectId) {
   		Map<String, List<Visitor_Page_View__c>> resultMap = new Map<String, List<Visitor_Page_View__c>>();
   			if (activities != null && activities.size() > 0) {
   				//Map<String, Id> activityIdMatchWithVisitId = new Map<String, Id>();
   				Map<String, String> visitIdMatchWithVisitorId = new Map<String, String>();
   				Map<String, List<String>> visitorIdMatchedWithVisitIds= new Map<String, List<String>>();
   				for (Pardot_Visitor_Activity__c activity : activities) {
   					if (activity.Type_Action__c == 'Visit') {
   						//activityIdMatchWithVisitId.put(activity.Visit_Id__c, activity.Id);
   						visitIdMatchWithVisitorId.put(activity.Visit_Id__c, activity.Visitor_Id__c);
   						if (visitorIdMatchedWithVisitIds.get(activity.Visitor_Id__c) != null) {
   							visitorIdMatchedWithVisitIds.get(activity.Visitor_Id__c).add(activity.Visit_Id__c);
   						} else {
   							List<String> idList = new List<String>();
   							idList.add(activity.Visit_Id__c);
   							visitorIdMatchedWithVisitIds.put(activity.Visitor_Id__c, idList);
   						}
   					}
   				}
   				//cant beyond 7, otherwise broken the batch, can do in other batch
   				//but at this stage, do in this way, and data is not that huge, no
   				//need to trigger other batch in a batch
   				Integer loopSize = visitorIdMatchedWithVisitIds.size() > 7 ? 7 : visitorIdMatchedWithVisitIds.size();
   				Integer i = 0;
   				for (String id : visitorIdMatchedWithVisitIds.keySet()) {
   					i = i + 1;
   					if (i == 8) {
   						break;
   					} else {
   						//constructId;
   						List<String> ids = visitorIdMatchedWithVisitIds.get(id);
   						String idsString = '';
   						for (Integer n = 0; n < ids.size(); n++) {
   							if (n == ids.size() - 1) {
   								idsString = idsString + ids.get(n);
   							} else {
   								idsString = idsString +  ids.get(n) + '%2C';
   							}
   						}
   						if (Test.isRunningTest()) {
   							String xmlToParse = '<?xml version="1.0" encoding="UTF-8"?><rsp stat="ok" version="1.0"><result><total_results>3</total_results><visit><id>5393814x</id><visitor_id>4547794x</visitor_id><prospect_id>64729856x</prospect_id><visitor_page_view_count>3</visitor_page_view_count><first_visitor_page_view_at>2015-01-20 09:04:35</first_visitor_page_view_at><last_visitor_page_view_at>2015-01-20 09:07:57</last_visitor_page_view_at><duration_in_seconds>202</duration_in_seconds><visitor_page_views><visitor_page_view><id>12397804x</id><url>http://go.creditandfinance.com.au/compare-home-loans-new?utm_source=affiliate&amp;utm_medium=email&amp;utm_campaign=refinance</url><title>Australian Credit and Finance</title><created_at>2015-01-20 09:04:35</created_at></visitor_page_view><visitor_page_view><id>12399174x</id><url>http://go.creditandfinance.com.au/compare-home-loans-new</url><title>Australian Credit and Finance</title><created_at>2015-01-20 09:06:56</created_at></visitor_page_view><visitor_page_view><id>12399826x</id><url>http://go.creditandfinance.com.au/compare-home-loans-new?utm_source=affiliate&amp;utm_medium=email&amp;utm_campaign=refinance</url><title>Australian Credit and Finance</title><created_at>2015-01-20 09:07:57</created_at></visitor_page_view></visitor_page_views></visit></result></rsp>';
   							DOM.Document doc = new DOM.Document();
   							try {
   								doc.load(xmlToParse);
   								 Map<String, List<Visitor_Page_View__c>> result = XmlUtilities.getVisitPageView(doc);
				            	resultMap.putAll(result);
   							} catch (System.XMLException e) {
				   				System.debug(e.getMessage());
				   			}
   						} else {
   							HttpRequest req = new HttpRequest();
					        HttpResponse res = new HttpResponse();
					        Http http = new Http();
					        req.setEndPoint('https://pi.pardot.com/api/visit/version/3/do/query?');
					        req.setBody('api_key=' + apiKey +
		                    	'&user_key=' + USER_KEY +
		                    	'&prospect_id=' + prospectId +
		                    	'&ids='+idsString +
		                    	'&visitor_id=' + id);
		                   	req.setMethod('POST');
				            res = http.send(req);
				            System.debug(res.getBody());
				            Dom.Document doc = res.getBodyDocument();
				            Map<String, List<Visitor_Page_View__c>> result = XmlUtilities.getVisitPageView(doc);
				            resultMap.putAll(result);
   						}	
   					}
   				}
   			}
   		
   		return resultMap;
   	}
}