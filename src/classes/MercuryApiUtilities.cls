public without sharing class MercuryApiUtilities {
	public static Boolean emailSwh                        = false;
	public static List<String> recipients                 = null;
	public static List<Map<String, String>> pendingEmails = null;

	static {
		ACFSwitch__c acfswh         = ACFSwitch__c.getOrgDefaults();
		emailSwh                    = (Boolean) acfswh.get('Mercury_Email_Switch__c');
		if(emailSwh) {
			ACFEmailList__c emaiSetting = ACFEmailList__c.getOrgDefaults();
			recipients                  = ((String) emaiSetting.get('Mercury_Email_Receiver__c')).split(',');
		}
		pendingEmails = new List<Map<String, String>>();
		system.debug(LoggingLevel.INFO, 'Email Switch: ' + emailSwh);
		system.debug(LoggingLevel.INFO, 'Email Recipients: ' + recipients);
	}

	//@dep
	public static void getDataBack(String oppoId, Boolean isSalesforceOppoId, String accountId, Boolean isSalesforceAccountId) {
		MercuryApiUtilitiesChen.getDataBack(oppoId, isSalesforceOppoId, accountId, isSalesforceAccountId);
	}

	//@dep
	public static void updateAccountF(String accountId, String oppoId) {
		MercuryApiUtilitiesChen.updateAccountF(accountId, oppoId);
	}

	//@dep
	public static void updatePeopleInMercury(String accountId, String token, String branchId) {
		MercuryApiUtilitiesChen.updatePeopleInMercury(accountId, token, branchId);
	}

	//@dep
	public static void getOpportunityAndSaveOnOppo(String oppoId, Boolean isSalesforceId) {
		MercuryApiUtilitiesChen.getOpportunityAndSaveOnOppo(oppoId, isSalesforceId);
	}

	//@dep
	public static void getPeopleAndSaveOnAccount(String accountId, Boolean isSalesforceId) {
		MercuryApiUtilitiesChen.getPeopleAndSaveOnAccount(accountId, isSalesforceId);
	}


	public static Opportunity createOppoInMercury(String oppoId, String branchId) {
		return createOppoInMercury(oppoId, branchId, false);
	}

	public static Opportunity createOppoInMercury(String oppoId, String branchId, Boolean testMode) {
		OpportunitySelector os = new OpportunitySelector();
		Opportunity oppo = os.getById(oppoId);
		return createOppoInMercury(oppo, branchId, testMode);
	}

	public static Opportunity createOppoInMercury(Opportunity oppo, String branchId, Boolean testMode) {
		String token = MercuryAuth.getInstance().getToken();
		if(checkRecord('Opportunity', oppo.id) && !testMode) return oppo;
		MercuryModel.Loan loan = new MercuryModel.Loan(oppo, branchId);

		HttpRequestResponse hs = insertMercuryRecord(loan);
		HttpRequest req = hs.req;
		HttpResponse res = hs.res;

		oppo.Sync_With_Mercury__c = true;
		if(res.getStatusCode() == 200) {
			//Mark sync with mercury success ticked
			oppo.Sync_With_Mercury_Success__c = true;
		} else {
			pendingEmails.add(new Map<String, String>{'methodName' => 'createOppoInMercury', 'details' => MercuryUtility.generateDetailPart(req, res)});
			throw new Utilities.CalloutResponseException(req, res);
		}
		return oppo;

	}

	public static Account createPeopleInMercury(String accountId, String branchId) {
		return createPeopleInMercury(accountId, branchId, false);
	}

	public static Account createPeopleInMercury(String accountId, String branchId, Boolean testMode) {
		AccountSelector accSelector = new AccountSelector();
		Account account = accSelector.getById(accountId);
		return createPeopleInMercury(account, branchId, testMode);
	}

	public static Account createPeopleInMercury(Account account, String branchId, Boolean testMode) {
		if(checkRecord('Account', account.id) && !testMode) return account;
		MercuryModel.People peop = new MercuryModel.People(account, branchId);

		HttpRequestResponse hs = insertMercuryRecord(peop);
		HttpRequest req = hs.req;
		HttpResponse res = hs.res;
		account.Sync_With_Mercury__pc = true;
		if (res.getStatusCode() == 200) {
			//Mark sync with mercury success ticked
			account.Sync_With_Mercury_Success__pc = true;
		} else {
			System.debug(LoggingLevel.DEBUG, 'Create People fail: ' + res);
			pendingEmails.add(new Map<String, String>{'methodName' => 'createPeopleInMercury', 'details' => MercuryUtility.generateDetailPart(req, res)});
			throw new Utilities.CalloutResponseException(req, res);
		}

		//update opportunity
		return account;
	}

	public static void createLoanPeopleInMercury(Account acc, Opportunity oppo) {
		MercuryModel.LoanPeople lp = new MercuryModel.LoanPeople(acc, oppo);
		HttpRequestResponse hs = insertMercuryRecord(lp);
	}

	public static HttpRequestResponse createLoanPeopleInMercury(MercuryModel.People peop, MercuryModel.Loan loan) {
		MercuryModel.LoanPeople lp = new MercuryModel.LoanPeople(peop, loan);
		return insertMercuryRecord(lp);
	}

	//Sync relationship between opportunity and account
	public static void createLoanPeopleInMercury(String oppoAndaccountId, String oppId, String accountId) {
		String token = MercuryAuth.getInstance().getToken();
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		String createdTime = MercuryUtility.convertCurrentTimeToGMTWithTimeZone();
		req.setHeader('Content-Type', 'application/json');
		req.setEndPoint(MercuryStaticValue.BASE_URL + token + '/loanPeople');
		String jsonToSendOver = '{"uniqueId":"' + oppoAndaccountId + '","isDeleted":false,"createdOn":"' + createdTime + '","deletedOn":null,"company":"' + MercuryStaticValue.ACF_BRANCH_ID + '","createdBy":"CA47482","loanID":"' + oppId + '","personID":"' + accountId + '","fullName":"' + oppoAndaccountId + '","relationship":"Primary Applicant"}';
		req.setBody(jsonToSendOver);
		req.setMethod('POST');
		if (Test.isRunningTest()) {
			res.setBody('');
			res.setStatusCode(200);
		} else {
			res = http.send(req);
		}
		if (String.valueOf(res.getBody()) == '') {
			System.debug('Loan People is created success');
		}
		System.debug(res.getBody());
	}

	public static String getAuthToken() {
		HttpRequest req  = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http        = new Http();
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.setEndPoint(MercuryStaticValue.LOGIN_END_POINT);
		req.setBody('username=' + MercuryStaticValue.USER_NAME + '&password=' + MercuryStaticValue.PASSWORD + '&application=' + MercuryStaticValue.APPLICATION);
		req.setMethod('POST');
		res = http.send(req);

		Dom.Document doc = res.getBodyDocument();
		String token     = MercuryUtility.getTokenFromXml(doc);
		System.debug(LoggingLevel.INFO, 'getAuthToken: ' + token);
		if(res.getStatusCode() != 200 || !MercuryUtility.getApproveFromXml(doc) || token == null) {
			Map<String, String> email = new Map<String, String>{
				'methodName' => 'loginToMercury',
				'details'    => MercuryUtility.generateDetailPart(req, res)
			};
			pendingEmails.add(email);
		}
		return token;
	}

	public static Map<String, Object> handleGetResponse(HttpResponse res) {
		if(res.getStatusCode() != 200 || res.getBody() == '') return null;
		Map<String, Object> ret = null;
		try {
			ret = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
			System.Debug(LoggingLevel.DEBUG, ret);
		} catch (Exception e) {
			return null;
		}

		if(ret.get('success') != true) return null;
		return ret;
	}

	public static Boolean checkRecord(String sfObjectName, String rid) {
		Id tempId = null;
		String tempIdString = '';
		HttpResponse res = sendGetRequest(sfObjectName, rid);
		Map<String, Object> resMap = handleGetResponse(res);

		if(resMap == null ) {
			try {
				tempId = rid;
				System.debug(tempId);
			} catch (Exception e) {
				// the input id is not a instance of salesforce id
				return false;
			}

			tempIdString += tempId;
			//if rid is 18 digit id temp id is 15 digit else 18 digit
			if(((String)tempId).length() == rid.length()) tempIdString = tempIdString.left(15);
			return MercuryUtility.checkRecordFromResMap(handleGetResponse(sendGetRequest(sfObjectName, tempIdString)), sfObjectName, tempIdString);
		} else {
			return MercuryUtility.checkRecordFromResMap(resMap, sfObjectName, rid);
		}
	}

	public static HttpResponse sendGetRequest(String endPoint) {
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setHeader('Content-Type', 'application/json');
		req.setEndPoint(endPoint);
		system.debug(req.getEndpoint());
		req.setMethod('GET');
		req.setTimeout(MercuryStaticValue.CALLOUT_GET_TIMEOUT);
		res = http.send(req);
		if(res.getStatusCode() != 200) {
			system.debug(LoggingLevel.INFO, '[MercuryApiUtilities.sendGetRequest] Error: ' + res);
			pendingEmails.add(new Map<String, String>{'methodName' => 'sendGetRequest', 'details' => MercuryUtility.generateDetailPart(req, res)});
			throw new Utilities.CalloutResponseException(req, res);
		}
		system.debug(LoggingLevel.DEBUG, res);
		return res;
	}

	public static HttpResponse sendGetRequest(String sfObjectName, MercuryModel.URLParams urlParams) {
		String token = MercuryAuth.getInstance().getToken();
		String endPoint = MercuryStaticValue.BASE_URL + token + '/' + MercuryStaticValue.sfToMercuryObjectMap.get(sfObjectName.toLowerCase()) + '?';
		return sendGetRequest(endPoint + urlParams.toString());
	}

	public static HttpResponse sendGetRequest(String sfObjectName, String rid) {
		String token = MercuryAuth.getInstance().getToken();
		String endPoint = MercuryStaticValue.BASE_URL + token + '/' + MercuryStaticValue.sfToMercuryObjectMap.get(sfObjectName.toLowerCase()) + '/' + rid;
		return sendGetRequest(endPoint);
	}

	public static HttpRequestResponse lodgeLoan(MercuryModel.Loan loan, String branchId) {
		String token = MercuryAuth.getInstance().getToken();
		String endPoint = MercuryStaticValue.BASE_URL + token + '/' + 'nextgen?loanId=' + loan.uniqueId + '&actionType=lodgeLoan&currentPartnerId=' + branchId;

		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setHeader('Content-Type', 'application/json');
		req.setEndPoint(endPoint);
		system.debug(req.getEndpoint());
		req.setMethod('GET');
		req.setTimeout(MercuryStaticValue.CALLOUT_GET_TIMEOUT);
		return new HttpRequestResponse(req, http.send(req));
	}

	public static HttpRequest buildRequest(String endPointTemplate, String method, Model mercModel, Integer timeout) {
		HttpRequest req = new HttpRequest();

		String token = MercuryAuth.getInstance().getToken();
		String resourceName = MercuryModel.getResourceName(mercModel);
		req.setHeader('Content-Type', 'application/json');
		req.setEndPoint(endPointTemplate.replace(MercuryStaticValue.TOKEN_PLACEHOLDER, token).replace(MercuryStaticValue.RESOURCE_NAME_PLACEHOLDER, resourceName));
		req.setMethod(method);
		req.setTimeout(timeout);
		String payload = JSON.serialize(mercModel);
		if(mercModel.isContainsReservedName()) payload = payload.replace(Model.REMOVE_RESERVE_PATTEN, '');
		req.setBody(payload);
		return req;
	}

	public static HttpRequestResponse getAddress(MercuryModel.People people) {
		String token = MercuryAuth.getInstance().getToken();
		String endPoint = MercuryStaticValue.BASE_URL + token + '/address?personId=' + people.get('uniqueId') + '&parentType=person';

		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setEndPoint(endPoint);
		system.debug(req.getEndpoint());
		req.setMethod('GET');
		req.setTimeout(MercuryStaticValue.CALLOUT_GET_TIMEOUT);
		return new HttpRequestResponse(req, http.send(req));
	}

	public static HttpRequestResponse deleteAddress(MercuryModel.Address address) {
		String token = MercuryAuth.getInstance().getToken();
		String endPoint = MercuryStaticValue.BASE_URL + token + '/address/' + address.get('uniqueId');

		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setEndPoint(endPoint);
		system.debug(req.getEndpoint());
		req.setMethod('DELETE');
		req.setTimeout(MercuryStaticValue.CALLOUT_GET_TIMEOUT);
		return new HttpRequestResponse(req, http.send(req));
	}

	public static HttpRequestResponse sendGetRequest(Model mercModel) {
		HttpRequest req = buildRequest(MercuryStaticValue.REQUEST_BASE_URL + '/' + mercModel.get('uniqueId'), 'GET', mercModel, MercuryStaticValue.CALLOUT_GET_TIMEOUT);
		Http http = new Http();
		return new HttpRequestResponse(req, http.send(req));
	}

	public static HttpRequestResponse insertMercuryRecord(Model mercModel) {
		HttpRequest req = buildRequest(MercuryStaticValue.REQUEST_BASE_URL, 'POST', mercModel, MercuryStaticValue.CALLOUT_GET_TIMEOUT);
		Http http = new Http();
		return new HttpRequestResponse(req, http.send(req));
	}

	public static HttpRequestResponse updateMercuryRecord(Model mercModel) {
		String endPointTemplate = MercuryStaticValue.REQUEST_BASE_URL + '/' + mercModel.get('uniqueId') + '?changes=' + MercuryUtility.getEncodedChangeList(mercModel);
		HttpRequest req = buildRequest(endPointTemplate, 'PUT', mercModel, MercuryStaticValue.CALLOUT_GET_TIMEOUT);
		Http http = new Http();
		return new HttpRequestResponse(req, http.send(req));
	}

	public static Boolean handleResponse(HttpRequestResponse hs, String operation) {
		if(hs.res.getStatusCode() != 200) {
			System.debug(LoggingLevel.INFO, '[MercuryApiUtilities.handleResponse] ' + operation + ': Failed...');
			System.debug(LoggingLevel.DEBUG, '[MercuryApiUtilities.handleResponse] Fail Response: ' + hs.res);
			return false;
		}
		System.debug(LoggingLevel.INFO, '[MercuryApiUtilities.handleResponse] ' + operation + ': Successed...');
		return true;
	}

	@future(callout=true)
	public static void futureSyncWithMercury(String oppoId, String accountId) {
		try {
			MercuryService.syncWithMercury(oppoId, accountId);
		} catch (Exception e) {

		}
	}

	@future(callout=true)
	public static void futureSyncWithMercury(Id reqId) {
		AsyncRequestSelector ars = new AsyncRequestSelector();
		AsyncRequest__c req = ars.getById(new List<Id>{reqId})[0];
		Map<String, Object> param = (Map<String, Object>) JSON.deserializeUntyped((String)(req.get('params__c')));
		try {
			MercuryService.syncWithMercury((String) param.get('oppoId'), (String) param.get('accId'));
			Delete req;
		} catch (Exception e) {

		}
	}

}
