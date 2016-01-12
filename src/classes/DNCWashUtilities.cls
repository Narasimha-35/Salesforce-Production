public class DNCWashUtilities {
	public static final String TELE_MARKETER_ID = Utilities.getDNCRTeleMarketerId();
	public static final String TELE_MARKETER_PASSWORD = Utilities.getDNCRTeleMarketerPassword();
	public static final String DNC_END_URL = Utilities.getDNCRTEndUrlId();
	public static final String QUERY_TYPE_FIELD = 'field';
	public static final String QUERY_TYPE_COUNT = 'count';
	
	//Get account balance from DNC Center
	public static String getCurrentAccountBalanceDNC() {
		//Construct the soap body
		String accountBalance = null;
		String telemarketerId = TELE_MARKETER_ID;
		String telemarketerPassword = TELE_MARKETER_PASSWORD;
		String WashOnlyUserId;
		String endUrl = DNC_END_URL;
		String soapBody = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rtw="http://rtw.dncrtelem"><soapenv:Header/><soapenv:Body><rtw:GetAccountBalance soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><TelemarketerId xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema-instance">' + TELE_MARKETER_ID +'</TelemarketerId><WashOnlyUserId xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema-instance"></WashOnlyUserId><TelemarketerPassword xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema- instance">'+ TELE_MARKETER_PASSWORD + '</TelemarketerPassword></rtw:GetAccountBalance> </soapenv:Body></soapenv:Envelope>';
		Integer ContentLength = 0; 
		ContentLength = soapBody.length();
		Http http = new Http(); 
		HttpRequest req = new HttpRequest(); 
		HttpResponse res = new HttpResponse(); 
		req.setMethod('POST'); 
		req.setEndPoint(endUrl); 
		req.setHeader('Content-type','text/xml'); 
		req.setHeader('Content-Length',ContentLength.format());
		req.setHeader('SOAPAction', '');
		req.setBody(soapBody);
		try {
			if (Test.isRunningTest()) {
				String xmlToParse = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:GetAccountBalanceResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"><GetAccountBalanceReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap"><AccountBalance ErrorCode="0" TelemarketerId="17897" WashOnlyUserId="">14950</AccountBalance></GetAccountBalanceReturn></ns1:GetAccountBalanceResponse></soapenv:Body></soapenv:Envelope>';
    			DOM.Document doc = new DOM.Document();
    			doc.load(xmlToParse);
    			accountBalance = XmlUtilities.getAccountBalanceFromDNC(doc);
			} else {
				res = http.send(req);
				Dom.Document doc = res.getBodyDocument();
				accountBalance = XmlUtilities.getAccountBalanceFromDNC(doc);
				System.debug(accountBalance);
			}
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
		return accountBalance;
	}
	
	public static void washPhoneNumbers(String counter, Lead lead) {
		List<String> phoneNumbers = new List<String>();
		if (lead.phone != null) {
			phoneNumbers.add(lead.phone);
		}
		if (lead.MobilePhone != null) {
			phoneNumbers.add(lead.MobilePhone);
		}
		if (phoneNumbers.size() == 0) {
			return;
		}
		String numberString = '';
		for (String phoneNumber : phoneNumbers) {
			phoneNumber = phoneNumber.replace('+61', '0');
			numberString = numberString + '<Number xsi:type="xsd:string">' + phoneNumber + '</Number>';
		}
		String telemarketerId = TELE_MARKETER_ID;
		String telemarketerPassword = TELE_MARKETER_PASSWORD;
		System.debug('telemarketerId ' + telemarketerId);
		System.debug('telemarketerPassword ' + telemarketerPassword);
		System.debug('phoneNumber ' + numberString);
		//Construct soap request
		String soapBody = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rtw="http://rtw.dncrtelem" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"><soapenv:Header/> <soapenv:Body><rtw:WashNumbers soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><TelemarketerId xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema-instance">' + TELE_MARKETER_ID + '</TelemarketerId><WashOnlyUserId xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema-instance"></WashOnlyUserId><TelemarketerPassword xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema- instance">' + TELE_MARKETER_PASSWORD + '</TelemarketerPassword><ClientReferenceId xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema-instance">' + counter + '</ClientReferenceId><NumbersToWash xsi:type="rtw:ArrayOf_xsd_anyType" soapenc:arrayType="xsd:anyType[]">' + numberString + '</NumbersToWash></rtw:WashNumbers></soapenv:Body></soapenv:Envelope>';
		Integer ContentLength = 0; 
		ContentLength = soapBody.length();
		Http http = new Http(); 
		HttpRequest req = new HttpRequest(); 
		HttpResponse res = new HttpResponse(); 
		req.setMethod('POST'); 
		req.setEndPoint(DNC_END_URL); 
		req.setHeader('Content-type','text/xml'); 
		req.setHeader('Content-Length',ContentLength.format());
		req.setHeader('SOAPAction', '');
		req.setBody(soapBody);
		try {
			if (Test.isRunningTest()) {
				String xmlToParse = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:WashNumbersResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"><WashNumbersReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap"><NumbersSubmitted AccountBalance="14946" ClientReferenceId="0415530313" ErrorCode="0" FinishDate="{ts 2015-03-30 00:00:00}" TelemarketerId="17897" TransactionId="16632326" WashOnlyUserId=""><Number Result="N">0415530313</Number></NumbersSubmitted></WashNumbersReturn></ns1:WashNumbersResponse></soapenv:Body></soapenv:Envelope>';
    			DOM.Document doc = new DOM.Document();
    			doc.load(xmlToParse);
    			XmlUtilities.getWashResultFromDNC(doc, lead);
			} else {
				res = http.send(req);
				//System.debug(res.getBody());
				Dom.Document doc = res.getBodyDocument();
				XmlUtilities.getWashResultFromDNC(doc, lead);
			}		
		} catch (Exception e) {
			//Need to handle timeout issue
			//if it is happened, scheudle get result call in 1 minutes later
			if (String.valueOf(e.getMessage()).contains('timed out')) {
				//schedule Get result in a minutes
				Datetime sysTime = System.now();
				sysTime = sysTime.addSeconds(60);
				String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
			    ScheduleGetDNCResult scheduler = new ScheduleGetDNCResult(counter, String.valueOf(lead.Id));
				//Schedule the next job, and give it the system time so name is unique
				System.schedule('CMP2 ' + sysTime,chron_exp,scheduler);
			}
		}
	}
	
	@future(Callout=true)
	public static void getWashResult(String referenceId, String leadId) {
		String telemarketerId = TELE_MARKETER_ID;
		String telemarketerPassword = TELE_MARKETER_PASSWORD;
		String endUrl = DNC_END_URL;
		String soapBody = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rtw="http://rtw.dncrtelem"><soapenv:Header/> <soapenv:Body><rtw:GetWashResult soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><TelemarketerId xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema-instance">' + TELE_MARKETER_ID + '</TelemarketerId><WashOnlyUserId xsi:type="xsd:string" xs:type="type:string" xmlns:xs="http://www.w3.org/2000/XMLSchema-instance"></WashOnlyUserId><TelemarketerPassword xsi:type="xsd:string" xmlns:xs="http://www.w3.org/2000/XMLSchema- instance">' + TELE_MARKETER_PASSWORD + '</TelemarketerPassword><ClientReferenceId xsi:type="xsd:string" xmlns:xs="http://www.w3.org/2000/XMLSchema- instance">' + referenceId + '</ClientReferenceId></rtw:GetWashResult></soapenv:Body></soapenv:Envelope>';
		Integer ContentLength = 0; 
		ContentLength = soapBody.length();
		Http http = new Http(); 
		HttpRequest req = new HttpRequest(); 
		HttpResponse res = new HttpResponse(); 
		req.setMethod('POST'); 
		req.setEndPoint(DNC_END_URL); 
		req.setHeader('Content-type','text/xml'); 
		req.setHeader('Content-Length',ContentLength.format());
		req.setHeader('SOAPAction', '');
		req.setBody(soapBody);
		try {
			if (Test.isRunningTest()) {
				String xmlToParse = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:GetWashResultResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"><GetWashResultReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap"><NumbersSubmitted AccountBalance="" ClientReferenceId="0415530313" ErrorCode="0" FinishDate="2015-03-30 16:14:41.0" TelemarketerId="17897" TransactionId="16632326" WashOnlyUserId=""><Number Result="N">0415530313</Number></NumbersSubmitted></GetWashResultReturn></ns1:GetWashResultResponse></soapenv:Body></soapenv:Envelope>';
				DOM.Document doc = new DOM.Document();
    			doc.load(xmlToParse);
    			Lead lead = LeadDAO.getLeadById(leadId);
    			XmlUtilities.getWashResultByReferenceId(doc, lead);
			} else {
				res = http.send(req);
				System.debug(res.getBody());
				Dom.Document doc = res.getBodyDocument();
				//Need to get lead by Id
				Lead lead = LeadDAO.getLeadById(leadId);
				XmlUtilities.getWashResultByReferenceId(doc, lead);	
			}	
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
	}
	
	public static DNCRuleResult countPhoneNumberFromAllLeadsFitRule() {
		String query = constructDynamicSoqlForDNCR(QUERY_TYPE_COUNT);
		if (query.contains('From Lead where')) { 
			String querySec = ' And DoNotCall != true And (NOT Status like \'%Closed Lost%\' ) And ConvertedDate = null And DNCR_Wash_Date__c != Today';
			query = query + querySec;
		} else {
			String querySec = ' Where ConvertedDate = null And DNCR_Wash_Date__c != Today And DoNotCall != true And (NOT Status like \'%Closed Lost%\' )';
		}
		Integer countLead = database.countQuery(query);
		Integer result = 0;
		String query1 = query + ' And MobilePhone != null And Phone != null';
		String query2 = query + ' And MobilePhone != null And Phone = null';
		String query3 = query + ' And MobilePhone = null And Phone != null';
		Integer count1 = database.countQuery(query1);
		Integer count2 = database.countQuery(query2);
		Integer count3 = database.countQuery(query3);
		//System.debug('1 ' + count1 + ' ' + count2 + ' ' + count3);
		result = count1 * 2 + count2 + count3;
		
		DNCRuleResult resultObj = new DNCRuleResult();
		resultObj.leadCount = countLead;
		resultObj.leadPhoneAndMobileCount = result;
		return resultObj;
	}
	
	public static String constructDynamicSoqlForDNCR(String queryType) {
		List<DNC_Wash_Rule__c> rules = [Select Id, Name, Api_Field_Name__c, Field_Value__c, Operator__c From DNC_Wash_Rule__c];
		String query = '';
		if (QUERY_TYPE_COUNT == queryType) {
			query = 'Select count() From Lead';
		} else {
			query = 'Select vhc__targetOutboundCampaignId__c, vhc__CallFile__c, smagicinteract__SMSOptOut__c, pi__utm_term__c, pi__utm_source__c, pi__utm_medium__c, pi__utm_content__c, pi__utm_campaign__c, pi__url__c, pi__score__c, pi__notes__c, pi__last_activity__c, pi__grade__c, pi__first_touch_url__c, pi__first_search_type__c, pi__first_search_term__c, pi__first_activity__c, pi__created_date__c, pi__conversion_object_type__c, pi__conversion_object_name__c, pi__conversion_date__c, pi__comments__c, pi__campaign__c, affiliate_source__c, Vehicle_Price__c, Vehicle_Build_Year__c, UnbounceSubmissionTime__c, UnbounceSubmissionDate__c, UnbouncePageVariant__c, UnbouncePageID__c, Transaction__c, Transaction_Type__c, Total_Calls__c, Too_Many_Credit_Enquiries__c, Title, SystemModstamp, Super_Balance__c, Sugar_Lead_Source__c, Sugar_Date_Created__c, SubmitterIP__c, Street, Status, StateCode, State, Source__c, Send_Property_Report__c, Salutation, Remove_from_Callfile__c, RecordTypeId, Pre_Sales_Notes__c, PostalCode, PhotoUrl, Phone, Partner_Super_Balance__c, Partner_Annual_Income__c, Paid_or_Unpaid_Defaults__c, OwnerId, Number_of_Children__c, NumberOfEmployees, No_Credit_History__c, Name, Modified_in_last_4_Hours__c, Model__c, MobilePhone, MasterRecordId, Marital_Status__c, Make__c, MC4SF__MC_Subscriber__c, Longitude, Loan_Value__c, Loan_Deposit__c, Lead_Type__c, LeadSource, Latitude, Last_Refinance__c, Last_Pardot_Form_Handler__c, LastViewedDate, LastReferencedDate, LastName, LastModifiedDate, LastModifiedById, LastActivityDate, Landing_Page__c, Job_Title__c, JigsawContactId, Is_Updated__c, Is_Update_Activity__c, IsUnreadByOwner, IsDeleted, IsConverted, Internal_Referrer_Name__c, Industry, In_Line_Status_Update__c, Id, Housing_Status__c, HasOptedOutOfEmail, Gender__c, Fixed_Rate_Expiry__c, FirstName, Est_Location__c, Employment_Status__c, Employment_Start_Date__c, Employer_Name__c, EmailBouncedReason, EmailBouncedDate, Email, DoNotCall, Discharged_from_Part_9_or_Bankruptcy__c, Description, DNCR_Washing_Transaction_ID__c, DNCR_Wash_Expiry__c, DNCR_Wash_Date__c, DNCR_Outcome__c, Current_Property_Value__c, Current_Loan_Value__c, Current_Loan_Type__c, Current_Lender__c, Current_Interest_Rate__c, Current_Interest_Rate_Type__c, Current_Financials_Up_to_Date__c, Credit_History__c, Credit_Guide_Quote_Privacy__c, CreatedDate, CreatedById, CountryCode, Country, ConvertedOpportunityId, ConvertedDate, ConvertedContactId, ConvertedAccountId, Company, City, Calls_Last_Disposition__c, Birthday__c, Annual_Income__c, Amount__c, Age_of_Current_Loan__c, Affiliate_campaign__c, Address From Lead';
		}
		Integer counter = 0;
		if (rules.size() > 0 ) {
			for (DNC_Wash_Rule__c rule : rules) {
				if (counter == 0) {
					if (rule.Operator__c == 'is equal to') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + ' where ' + fieldName + ' = ' + value + ' ';
					} else if (rule.Operator__c == 'is not equal to') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + ' where ' + fieldName + ' != ' + value + ' ';
					} else if (rule.Operator__c == 'contains with') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + ' where ' + fieldName + ' like ' + value + ' ';
					} else if (rule.Operator__c == 'is greater than') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + ' where ' + fieldName + ' > ' + value + ' ';
					} else if (rule.Operator__c == 'is less than') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + ' where ' + fieldName + ' < ' + value + ' ';
					}
				} else if (counter == rules.size() - 1) {
					if (rule.Operator__c == 'is equal to') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' = ' + value;
					} else if (rule.Operator__c == 'is not equal to') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' != ' + value;
					} else if (rule.Operator__c == 'contains with') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' +  fieldName + ' like ' + value;
					} else if (rule.Operator__c == 'is greater than') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' > ' + value;
					} else if (rule.Operator__c == 'is less than') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' < ' + value;
					}
				} else {
					if (rule.Operator__c == 'is equal to') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' = ' + value + ' ';
					} else if (rule.Operator__c == 'is not equal to') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' != ' + value + ' ';
					} else if (rule.Operator__c == 'contains with') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' +  fieldName + ' like ' + value + ' ';
					} else if (rule.Operator__c == 'is greater than') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' > ' + value + ' ';
					} else if (rule.Operator__c == 'is less than') {
						String value = Utilities.accordingToFieldValueToReturnQuery(rule);
						String fieldName = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.FIELD_NAME);
						query = query + 'AND ' + fieldName + ' < ' + value + ' ';
					}
				}
				counter ++; 
			}
		}
		
		//Add all the checkbox conditions here
		return query;
	}
	
	public static DNCWashUtilities.DNCWashResultWrap processWashResult(List<DNCWashUtilities.DNCWashResultWrap> wrapList) {
		if (wrapList.size() == 1) {
			return wrapList.get(0);
		} else if (wrapList.size() > 1) {
			boolean bothI = true;
			boolean bothN = true;
			for (DNCWashUtilities.DNCWashResultWrap result : wrapList) {
				if (result.washResult == 'Y') {
					return result;
				}
				if (result.washResult == 'I') {
					bothN = false;
				}
				if (result.washResult == 'N') {
					bothI = false;
				}
			}
			if (bothI) {
				return wraplist.get(0);
			}
			if (bothN) {
				return wraplist.get(0);
			}
			if (!bothN && !bothI) {
				for (DNCWashUtilities.DNCWashResultWrap result : wrapList) {
					if (result.washResult == 'N') {
						return result;
					}
				}
			}
		}
		return null;
	}
	
	public class DNCWashResultWrap {
		public String washResult { get; set;}
		public Date washDate { get; set; }
		public String transactionId { get; set; }
	}
	
	public class DNCRuleResult {
		public Integer leadCount { get; set; }
		public Integer leadPhoneAndMobileCount { get; set; }
	}
}