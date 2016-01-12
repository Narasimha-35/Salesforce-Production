public class XmlUtilities {
	public static final String PARDOT_URL = 'https://pi.pardot.com/';
	public static final String FORM_HANDLER_URL = 'formHandler/read/id/';
	public static final String LANDING_PAGE_URL = 'landingPage/read/id/';
	public static final String OPPORTUNITY_URL = 'opportunity/read/id/';
	public static final String EMAIL_URL = 'email/read/id/';
	public static final String FORM_URL = 'form/read/id/';
	public static final String CUSTOM_URL = 'customUrl/read/id/';
	public static final String VISIT_URL = 'visit/read/id/';
	public static final String PROSPECT_ID = '/prospect_id/';
	
	public static String constructUrlLinkForActivity(Pardot_Visitor_Activity__c activity) {
		String url = null;
		if (activity.Form_Handler_Id__c != null && activity.Form_Handler_Id__c != '') {
			url = PARDOT_URL + FORM_HANDLER_URL + activity.Form_Handler_Id__c;
		} else if (activity.Landing_Page_Id__c != null && activity.Landing_Page_Id__c != '') {
			url = PARDOT_URL + LANDING_PAGE_URL + activity.Landing_Page_Id__c;
		} else if (activity.Opportunity_Id__c != null && activity.Opportunity_Id__c != '') {
			url = PARDOT_URL + OPPORTUNITY_URL + activity.Opportunity_Id__c;
		} else if (activity.Email_Id__c != null && activity.Email_Id__c != '') {
			url = PARDOT_URL + EMAIL_URL + activity.Email_Id__c;
		} else if (activity.Form_Id__c != null && activity.Form_Id__c != '') {
			url = PARDOT_URL + FORM_URL + activity.Form_Id__c;
		} else if (activity.Custom_Url_Id__c != null && activity.Custom_Url_Id__c != '') {
			url = PARDOT_URL + CUSTOM_URL + activity.Custom_Url_Id__c;
		} else if (activity.Visit_Id__c != null && activity.Visit_Id__c != ''
					&& activity.Prospect_Id__c != null && activity.Prospect_Id__c != '') {
			url = PARDOT_URL + VISIT_URL + activity.Visit_Id__c + PROSPECT_ID + activity.Prospect_Id__c;
		}
		return url;
	}
	
	//Sample soap response
  /*<?xml version="1.0" encoding="UTF-8"?>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 		<soapenv:Body>
 			 <ns1:GetAccountBalanceResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">
  			 	<GetAccountBalanceReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">
   			 		<AccountBalance ErrorCode="0" TelemarketerId="17897" WashOnlyUserId="">14950</AccountBalance>
   			 	</GetAccountBalanceReturn>
  			</ns1:GetAccountBalanceResponse>
 		</soapenv:Body>
	</soapenv:Envelope>*/
	public static String getAccountBalanceFromDNC(Dom.Document doc) {
		if (doc != null) {
			Dom.Xmlnode node = doc.getRootElement();
			if (node != null && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
				if (node.getName() == 'Envelope') {
					for (Dom.XMLNode child: node.getChildElements()) {
						if (child.getName() == 'Body') {
      						for (Dom.XMLNode child2: child.getChildElements()) {
      							if (child2.getName() == 'GetAccountBalanceResponse') {
      								for (Dom.XMLNode child3: child2.getChildElements()) {
      									if (child3.getName() == 'GetAccountBalanceReturn') {
      										for (Dom.XMLNode child4: child3.getChildElements()) {
      											if (child4.getName() == 'AccountBalance' && child4.getAttributeCount() > 0) {
      												String responed = child4.getAttributeValue(child4.getAttributeKeyAt(0), child4.getAttributeKeyNsAt(0));
      												if (responed == '0') {
      													String balance = child4.getText();
      													return balance;
      												}
      											}
      										}
      									}
      								}
      							}
      						}
						}
					}
				}
			}
		}
		return null;
	}
	
	//soap xml sample
	/*<?xml version="1.0" encoding="UTF-8"?>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	 <soapenv:Body>
	  <ns1:WashNumbersResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">
	   <WashNumbersReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">
	    <NumbersSubmitted AccountBalance="14946" ClientReferenceId="0415530313" ErrorCode="0" FinishDate="{ts 2015-03-30 00:00:00}" TelemarketerId="17897" TransactionId="16632326" WashOnlyUserId="">
	     <Number Result="N">0415530313</Number>
	    </NumbersSubmitted>
	   </WashNumbersReturn>
	  </ns1:WashNumbersResponse>
	 </soapenv:Body>
	</soapenv:Envelope>*/
	public static void getWashResultFromDNC(Dom.Document doc, Lead lead) {
		if (doc != null) {
			Dom.Xmlnode node = doc.getRootElement();
			if (node != null && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
				if (node.getName() == 'Envelope') {
					for (Dom.XMLNode child: node.getChildElements()) {
						if (child.getName() == 'Body') {
      						for (Dom.XMLNode child2: child.getChildElements()) {
      							if (child2.getName() == 'WashNumbersResponse') {
      								for (Dom.XMLNode child3: child2.getChildElements()) {
      									if (child3.getName() == 'WashNumbersReturn') {
      										for (Dom.XMLNode child4: child3.getChildElements()) {
      											if (child4.getName() == 'NumbersSubmitted') {
      												//check error code
      												String attribute3 = child4.getAttributeValue(child4.getAttributeKeyAt(2), child4.getAttributeKeyNsAt(2));
      												String transactionId = child4.getAttributeValue(child4.getAttributeKeyAt(5), child4.getAttributeKeyNsAt(5));
      												System.debug('transactionId ' + transactionId);
      												if (attribute3 == '0') {
      													List<DNCWashUtilities.DNCWashResultWrap> wrapList = new List<DNCWashUtilities.DNCWashResultWrap>();
      													for (Dom.XMLNode child5: child4.getChildElements()) {
      														if (child5.getName() == 'Number') {
      															String result = child5.getAttributeValue(child5.getAttributeKeyAt(0), child5.getAttributeKeyNsAt(0));
      															DNCWashUtilities.DNCWashResultWrap resultObject = new DNCWashUtilities.DNCWashResultWrap();
      															resultObject.washResult = result;
      															resultObject.washDate = Date.today();
      															resultObject.transactionId = transactionId;
      															wrapList.add(resultObject);
      														}
      													}
      													//Check result logic, then put it back to lead;
      													DNCWashUtilities.DNCWashResultWrap filterResult =  DNCWashUtilities.processWashResult(wrapList);
      													if (filterResult != null) {
      														lead.DNCR_Outcome__c = filterResult.washResult;
      														lead.DNCR_Wash_Date__c = filterResult.washDate;
      														lead.DNCR_Washing_Transaction_ID__c = filterResult.transactionId;
      													}
      												}
      											}
      										}
      									}
      								}
      							}
      						}
						}
					}
				}
			}
		}
		//Need comment out later, do update in batch instead;
		//update lead;
	}
	/*<?xml version="1.0" encoding="UTF-8"?>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	 <soapenv:Body>
	  <ns1:GetWashResultResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">
	   <GetWashResultReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">
	    <NumbersSubmitted AccountBalance="" ClientReferenceId="0415530313" ErrorCode="0" FinishDate="2015-03-30 16:14:41.0" TelemarketerId="17897" TransactionId="16632326" WashOnlyUserId="">
	     <Number Result="N">0415530313</Number>
	     <Number Result="N">0415530313</Number>
	    </NumbersSubmitted>
	   </GetWashResultReturn>
	  </ns1:GetWashResultResponse>
	 </soapenv:Body>
	</soapenv:Envelope>*/

	public static void getWashResultByReferenceId(Dom.Document doc, Lead lead) {
		if (doc != null) {
			Dom.Xmlnode node = doc.getRootElement();
			if (node != null && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
				if (node.getName() == 'Envelope') {
					for (Dom.XMLNode child: node.getChildElements()) {
						if (child.getName() == 'Body') {
      						for (Dom.XMLNode child2: child.getChildElements()) {
      							if (child2.getName() == 'GetWashResultResponse') {
      								for (Dom.XMLNode child3: child2.getChildElements()) {
      									if (child3.getName() == 'GetWashResultReturn') {
      										for (Dom.XMLNode child4: child3.getChildElements()) {
      											if (child4.getName() == 'NumbersSubmitted') {
		      										String errorCode = child4.getAttributeValue(child4.getAttributeKeyAt(2), child4.getAttributeKeyNsAt(2));
		      										String transactionId = child4.getAttributeValue(child4.getAttributeKeyAt(5), child4.getAttributeKeyNsAt(5));
		      										if (errorCode == '0') {
		      											List<DNCWashUtilities.DNCWashResultWrap> wrapList = new List<DNCWashUtilities.DNCWashResultWrap>();
		      											for (Dom.XMLNode child5: child4.getChildElements()) {
		      												String result = child5.getAttributeValue(child5.getAttributeKeyAt(0), child5.getAttributeKeyNsAt(0));
		      												DNCWashUtilities.DNCWashResultWrap resultObject = new DNCWashUtilities.DNCWashResultWrap();
  															resultObject.washResult = result;
  															resultObject.washDate = Date.today();
  															resultObject.transactionId = transactionId;
  															wrapList.add(resultObject);
		      											}
		      											DNCWashUtilities.DNCWashResultWrap filterResult =  DNCWashUtilities.processWashResult(wrapList);
      													if (filterResult != null) {
      														lead.DNCR_Outcome__c = filterResult.washResult;
      														lead.DNCR_Wash_Date__c = filterResult.washDate;
      														lead.DNCR_Washing_Transaction_ID__c = filterResult.transactionId;
      													}
		      										}
		      									}
      										}
      									}
      								}
      							}
      						}
						}
					}
				}
			}
		}
		System.debug('Here is the info ' + lead.DNCR_Outcome__c);
		update lead;
	}
		
	public static String getAPIKeyFromPardot(Dom.Document doc) {
		if (doc != null) {
			//Retrieve the root element for this document.
        	Dom.XMLNode node = doc.getRootElement();
        	if (node != null && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
        		if (node.getName() == 'rsp') {
        			//Get attribute
        			if (node.getAttributeCount() > 0) {
        				String responed = node.getAttributeValue(node.getAttributeKeyAt(0), node.getAttributeKeyNsAt(0));
        				if (responed != null && responed.contains('ok')) {
        					for (Dom.XMLNode child: node.getChildElements()) {
      							if (child.getName() == 'api_key') {
      								return child.getText();
      							}
    						}
        				}
        			}
        		}
        	}
		}
		return null;
	}
	
	public static String getProspectId(Dom.Document doc) {
		String prospectId = null;
		if (doc != null) {
			Dom.Xmlnode rootNode = doc.getRootElement();
			if (rootNode != null && rootNode.getNodeType() == DOM.XMLNodeType.ELEMENT
				&& rootNode.getName() == 'rsp' && rootNode.getAttributeCount() > 0) {
        			//Get attribute
    				String responed = rootNode.getAttributeValue(rootNode.getAttributeKeyAt(0), rootNode.getAttributeKeyNsAt(0));
    				if (responed != null && responed.contains('ok')) {
    					Dom.XMLNode prospectNode = rootNode.getChildElements().get(0);
    					if (prospectNode != null) {
    						for (Dom.XMLNode grandChild: prospectNode.getChildElements()) {
    							if (grandChild.getName() == 'id') {
    								return grandChild.getText();
    							}
    						}
    					}
    				}
				}
		}
		return prospectId;
	}
	
	public static Map<String, List<Visitor_Page_View__c>> getVisitPageView(Dom.Document doc) {
		Map<String, List<Visitor_Page_View__c>> visitIdMatchWithPageView = new Map<String, List<Visitor_Page_View__c>>();
		if (doc != null) {
			Dom.Xmlnode rootNode = doc.getRootElement();
			if (rootNode != null && rootNode.getNodeType() == DOM.XMLNodeType.ELEMENT
				&& rootNode.getName() == 'rsp' && rootNode.getAttributeCount() > 0) {
    			//Get attribute
				String responed = rootNode.getAttributeValue(rootNode.getAttributeKeyAt(0), rootNode.getAttributeKeyNsAt(0));
				if (responed != null && responed.contains('ok')) {
					//get the page view the deal with the data;
					Dom.Xmlnode resultNode = rootNode.getChildElements().get(0);
    				if (resultNode != null) {
    					for (Dom.Xmlnode visitNode : resultNode.getChildElements()) {
    						if (visitNode.getName() == 'visit') {
    							String visitId = null;
    							List<Visitor_Page_View__c> pageViews = new List<Visitor_Page_View__c>();
    							for (Dom.Xmlnode visitDetailNode : visitNode.getChildElements()) {
    								if (visitDetailNode.getName() == 'id') {
    									visitId = String.valueOf(visitDetailNode.getText());
    								}
    								if (visitDetailNode.getName() == 'visitor_page_views') {
    									for (Dom.Xmlnode visitPageView : visitDetailNode.getChildElements()) {
    										if (visitPageView.getName() == 'visitor_page_view') {
    										 	Visitor_Page_View__c pageView = new Visitor_Page_View__c();
    										 	for (Dom.Xmlnode visitPageViewDetail : visitPageView.getChildElements()) {
    										 		if (visitPageViewDetail.getName() == 'id') {
    										 			pageView.Visitor_Page_View_Id__c = String.valueOf(visitPageViewDetail.getText()) != null ? String.valueOf(visitPageViewDetail.getText()).trim() : '';
    										 		}
    										 		if (visitPageViewDetail.getName() == 'url') {
    										 			String url = String.valueOf(visitPageViewDetail.getText()) != null ? String.valueOf(visitPageViewDetail.getText()).trim() : '';
    										 			pageView.Visit_Url__c = Utilities.byteAbbreviate(url, 250);
    										 		}
    										 		if (visitPageViewDetail.getName() == 'title') {
    										 			pageView.Visit_Title__c = String.valueOf(visitPageViewDetail.getText()) != null ? String.valueOf(visitPageViewDetail.getText()).trim() : '';
    										 		}
    										 		if (visitPageViewDetail.getName() == 'created_at') {
    										 			if (visitPageViewDetail.getText() != null ) {
			  												//System.debug('String formate date ' + activitiesDetails.getText());
			  												Datetime dtValue = DateTime.valueOfGmt(visitPageViewDetail.getText());
			  												//System.debug('Ready to save date ' + dtValue);
			  												pageView.Visit_Created_At__c = dtValue;
			  											}
    										 		}
    										 	}
    										 	pageViews.add(pageView);
    										}
    									}
    								}
    							}					
    							if (visitId != null) {
    								visitIdMatchWithPageView.put(visitId,pageViews);
    							}
    						}
    					}
    				}
				}
			}
		}
		return visitIdMatchWithPageView;
	}
	
	public static List<Pardot_Visitor_Activity__c> getPardotActivitiesByProspectXml(Dom.Document doc, Lead lead, String prospectId) {
		List<Pardot_Visitor_Activity__c> visitorActivities = new List<Pardot_Visitor_Activity__c>();
		if (doc != null) {
			Dom.Xmlnode rootNode = doc.getRootElement();
			if (rootNode != null && rootNode.getNodeType() == DOM.XMLNodeType.ELEMENT
				&& rootNode.getName() == 'rsp' && rootNode.getAttributeCount() > 0) {
        			//Get attribute
    				String responed = rootNode.getAttributeValue(rootNode.getAttributeKeyAt(0), rootNode.getAttributeKeyNsAt(0));
    				if (responed != null && responed.contains('ok')) {
    					Dom.Xmlnode resultNode = rootNode.getChildElements().get(0);
    					if (resultNode != null) {
    						for(Dom.Xmlnode activityNode : resultNode.getChildElements()) {
  								if (activityNode.getName() == 'visitor_activity') {
  									//check if lead has the sum object
  									//if have get it
  									//otherwise create a new one
  									Pardot_Visitor_Activity__c activity = new Pardot_Visitor_Activity__c();
  									activity.Lead__c = lead.Id;
  									activity.Prospect_Id__c = prospectId;
  									for (Dom.XMLNode activitiesDetails : activityNode.getChildElements()) {
  										if (activitiesDetails.getName() == 'id') {
  											activity.Activity_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  										}
  										if (activitiesDetails.getName() == 'type') {
  											String actionTypeNumber = activitiesDetails.getText() != null && activitiesDetails.getText() != '' ? String.valueOf(activitiesDetails.getText()).trim() : 'Other';
  											activity.Type_Action__c = HardCodeVars.typeTable.get(actionTypeNumber);	
  										}
  										if (activitiesDetails.getName() == 'type_name') {
  											activity.Type_Name__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  										}
  										if (activitiesDetails.getName() == 'details') {
  											activity.Activity_Details__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  										}
  										if (activitiesDetails.getName() == 'created_at') {
  											if (activitiesDetails.getText() != null ) {
  												Datetime dtValue = DateTime.valueOfGmt(activitiesDetails.getText());
  												activity.Pardot_Created_Date__c = dtValue;
  											}
  										}
  										if (activitiesDetails.getName() == 'visitor_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Visitor_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'opportunity_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Opportunity_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'email_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Email_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'landing_page_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Landing_Page_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'visit_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Visit_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'form_handler_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Form_Handler_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'form_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Form_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'file_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.File_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'custom_url_id') {
  											if (activitiesDetails.getText() != null) {
  												activity.Custom_Url_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
  											}
  										}
  										if (activitiesDetails.getName() == 'campaign') {
  											for(Dom.XMLNode compaignDetail : activitiesDetails.getChildElements()) {
  												if (compaignDetail.getName() == 'id') {
  													activity.Campaign_Id__c = compaignDetail.getText() != null ? String.valueOf(compaignDetail.getText()).trim() : '';
  												}
  												if (compaignDetail.getName() == 'name') {
  													activity.Campaign_Name__c = compaignDetail.getText() != null ? String.valueOf(compaignDetail.getText()).trim() : '';
  												}
  											}
  										}
  									}
  									String url = constructUrlLinkForActivity(activity);
  									activity.Pardon_Activity_Link__c = url;
  									visitorActivities.add(activity);
	  							}
    						}
    					}		
    				}
				}
			}
			
			//The following code is trying to solve the duplicate Sum Id
			Set<String> allActivityId = new Set<String>();
			Pardot_Visitor_Activities_Sum__c sum;
			String sumId = null;
			for (Pardot_Visitor_Activity__c activity : visitorActivities) {
				allActivityId.add(activity.Activity_Id__c);
			}
			//select all the activity by visitor id in database
			List<Pardot_Visitor_Activity__c> activities = [Select Id, Name, Pardot_Visitor_Activities_Sum__c, Activity_Id__c From Pardot_Visitor_Activity__c where Activity_Id__c in :allActivityId ];
			//put it in map Activity id and SUM iD
			for (Pardot_Visitor_Activity__c activity : activities) {
				if (activity.Pardot_Visitor_Activities_Sum__c != null && String.valueOf(activity.Pardot_Visitor_Activities_Sum__c) != '') {
					sumId = activity.Pardot_Visitor_Activities_Sum__c;
					break;
				}
			}
			Map<String, List<Visitor_Page_View__c>> resultMap = PardotActivitiesUtilities.getAllVisitView(visitorActivities, prospectId);
			if (sumId == null) {
				Lead leadA = [Select (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Lead__c From Pardot_Visitor_Activities_Sums__r) From Lead l where l.Id = :lead.Id];
		  		List<Pardot_Visitor_Activities_Sum__c> activitySums = leadA.Pardot_Visitor_Activities_Sums__r;
	  			if (activitySums.size() == 0) {
		  			sum = new Pardot_Visitor_Activities_Sum__c();
		  			sum.Lead__c = lead.Id;
		  			insert sum;
		  			sumId = sum.Id;
				} else {
					sum = activitySums.get(0);
					sumId = sum.Id;
				}
			}
			for (Pardot_Visitor_Activity__c activity : visitorActivities) {
				if (activity.Pardot_Visitor_Activities_Sum__c == null) {
					activity.Pardot_Visitor_Activities_Sum__c = sumId;
				}
			}
			//upsert activity list by visitor id
			try {
			    // Perform some database operations that 
			    upsert visitorActivities Activity_Id__c;
			} catch(DmlException e) {
			    // DmlException handling code here.
			    // duplicate key handler
			    System.debug(e.getMessage());
			} catch(Exception e) {
			    // Generic exception handling code here.
				System.debug(e.getMessage());
			}
			
			
			//Now we have all the visitorActivities Id
			//Construct a map for mapping visitId and activity SF Id;
			Map<String, Id> visitIdActivitySFIdMatchMap = new Map<String, Id>();
			for (Pardot_Visitor_Activity__c activity : visitorActivities) {
				if (activity.Visit_Id__c != null && activity.Visit_Id__c != '') {
					visitIdActivitySFIdMatchMap.put(activity.Visit_Id__c, activity.Id);
				}
			}
			List<Visitor_Page_View__c> readyVisitorPageViews = new List<Visitor_Page_View__c>(); 
			for (String key : resultMap.keySet()) {
				Id activityId = visitIdActivitySFIdMatchMap.get(key);
				if (activityId != null) {
					for (Visitor_Page_View__c pageView : resultMap.get(key)) {
						pageView.Pardot_Visitor_Activity__c = activityId;
						readyVisitorPageViews.add(pageView);
					}
				}
			}
			upsert readyVisitorPageViews Visitor_Page_View_Id__c;
			lead.Is_Update_Activity__c = false;
			lead.Pardot_Visitor_Activities_Sum__c = sumId;
			update lead;
			return visitorActivities;
	}
	
	/*private static void getPardotActivities(Dom.Document doc, Lead lead) {
		List<Pardot_Visitor_Activity__c> visitorActivities = new List<Pardot_Visitor_Activity__c>();
		if (doc != null) {
			Dom.Xmlnode rootNode = doc.getRootElement();
			if (rootNode != null && rootNode.getNodeType() == DOM.XMLNodeType.ELEMENT
				&& rootNode.getName() == 'rsp' && rootNode.getAttributeCount() > 0) {
        			//Get attribute
    				String responed = rootNode.getAttributeValue(rootNode.getAttributeKeyAt(0), rootNode.getAttributeKeyNsAt(0));
    				if (responed != null && responed.contains('ok')) {
    					Dom.XMLNode prospectNode = rootNode.getChildElements().get(0);
    					if (prospectNode != null) {
    						Dom.XMLNode activitiesNode = null;
    						for (Dom.XMLNode grandChild: prospectNode.getChildElements()) {
  								if (grandChild.getName() == 'visitor_activities') {
  									activitiesNode = grandChild;
  									break;
  								}
  							}
  							if (activitiesNode != null) {
  								Lead leadA = [Select (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Lead__c From Pardot_Visitor_Activities_Sums__r) From Lead l where l.Id = :lead.Id];
	  							List<Pardot_Visitor_Activities_Sum__c> activitySums = leadA.Pardot_Visitor_Activities_Sums__r;
  								Pardot_Visitor_Activities_Sum__c sum;
  								if (activitySums.size() == 0) {
	  								sum = new Pardot_Visitor_Activities_Sum__c();
	  								sum.Lead__c = lead.Id;
	  								insert sum;
								} else {
									sum = activitySums.get(0);
								}
  								for (Dom.XMLNode activityNode: activitiesNode.getChildElements()) {
	  								if (activityNode.getName() == 'visitor_activity') {
	  									//check if lead has the sum object
	  									//if have get it
	  									//otherwise create a new one
	  									Pardot_Visitor_Activity__c activity = new Pardot_Visitor_Activity__c();
	  									activity.Lead__c = lead.Id;
	  									activity.Pardot_Visitor_Activities_Sum__c = sum.Id;
	  									for (Dom.XMLNode activitiesDetails : activityNode.getChildElements()) {
	  										if (activitiesDetails.getName() == 'id') {
	  											activity.Visitor_Id__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
	  										}
	  										if (activitiesDetails.getName() == 'type') {
	  											String actionTypeNumber = activitiesDetails.getText() != null && activitiesDetails.getText() != '' ? String.valueOf(activitiesDetails.getText()).trim() : 'Other';
	  											activity.Type_Action__c = HardCodeVars.typeTable.get(actionTypeNumber);	
	  										}
	  										if (activitiesDetails.getName() == 'type_name') {
	  											activity.Type_Name__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
	  										}
	  										if (activitiesDetails.getName() == 'details') {
	  											activity.Activity_Details__c = activitiesDetails.getText() != null ? String.valueOf(activitiesDetails.getText()).trim() : '';
	  										}
	  										if (activitiesDetails.getName() == 'created_at') {
	  											if (activitiesDetails.getText() != null ) {
	  												//System.debug('String formate date ' + activitiesDetails.getText());
	  												Datetime dtValue = DateTime.valueOfGmt(activitiesDetails.getText());
	  												//System.debug('Ready to save date ' + dtValue);
	  												activity.Pardot_Created_Date__c = dtValue;
	  											}
	  										}
	  										if (activitiesDetails.getName() == 'campaign') {
	  											for(Dom.XMLNode compaignDetail : activitiesDetails.getChildElements()) {
	  												if (compaignDetail.getName() == 'id') {
	  													activity.Campaign_Id__c = compaignDetail.getText() != null ? String.valueOf(compaignDetail.getText()).trim() : '';
	  												}
	  												if (compaignDetail.getName() == 'name') {
	  													activity.Campaign_Name__c = compaignDetail.getText() != null ? String.valueOf(compaignDetail.getText()).trim() : '';
	  												}
	  											}
	  										}
	  									}
	  									visitorActivities.add(activity);		
	  								}
	  							}
  							}
    					}
    				}
				}
			}
			//upsert activity list by visitor id
			upsert visitorActivities; // Activity_Id__c;
			lead.Is_Update_Activity__c = false;
			update lead;
		}*/
}