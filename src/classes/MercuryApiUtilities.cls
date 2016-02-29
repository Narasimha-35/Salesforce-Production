public without sharing class MercuryApiUtilities extends AbstractWebService{
	// public static final String CLICK_PEP_BRANCH_ID = 'c68fcac0-79ab-4a73-b1b3-592f4a3adae6';
	private static final Credential__c credential          = Credential__c.getAll().get('Mercury');
	private static final String USER_NAME                  = credential.Mercury_Username__c;
	private static final String PASSWORD                   = credential.Mercury_Password__c;
	private static final String LOGIN_END_POINT            = credential.Mercury_Login_End_Point__c;
	private static final String DOMAIN                     = credential.Mercury_Domain__c;
	private static final String APPLICATION                = credential.Mercury_Application__c;
	private static final String API_VERSION                = 'api';
	private static Boolean emailSwh                        = false;
	private static List<String> recipients                 = null;
	private static String debugEmailTemplate               = null;
	private static List<Map<String, String>> pendingEmails = null;

	//The object map between salesforce and mercury
	public static final Map<String, String> sfToMercuryObjectMap;
	//The item map between salesforce and mercury in response body {'success':'true', 'people':[....]}
	public static final Map<String, String> sfToMercuryItemMap;
	static {
		sfToMercuryObjectMap = new Map<String, String>{
			'account'     => 'person',
			'opportunity' => 'loan'
		};
		sfToMercuryItemMap = new Map<String, String>{
			'account'     => 'people',
			'opportunity' => 'loans'
		};

		ACFSwitch__c acfswh         = ACFSwitch__c.getOrgDefaults();
		emailSwh                    = (Boolean) acfswh.get('Mercury_Email_Switch__c');
		if(emailSwh) {
			ACFEmailList__c emaiSetting = ACFEmailList__c.getOrgDefaults();
			recipients                  = ((String) emaiSetting.get('Mercury_Email_Receiver__c')).split(',');
			Document doc                = [select id, body from Document where name = 'DebugEmailTemplate' limit 1];
			debugEmailTemplate          = doc.body.toString();
			pendingEmails               = new List<Map<String, String>>();
		}
		system.debug(LoggingLevel.INFO, 'Email Switch: ' + emailSwh);
		system.debug(LoggingLevel.INFO, 'Email Recipients: ' + recipients);
	}

	public static void syncWithMercury(String oppoId, String accountId)  {
		String branchId = getBrokerBranch(oppoId);
		Id oId = oppoId;
		Id aId = accountId;

		//Create Oppo
		System.debug(oppoId);
		Opportunity oppo = MercuryApiUtilities.createOppoInMercury(oppoId, branchId);
		//Create People
		System.debug(accountId);
		Contact contact = MercuryApiUtilities.createPeopleInMercury(accountId, branchId);
		//Create Connection between Oppo and People
		String oppoAndaccountId = oId + '-' + aId;
		MercuryApiUtilities.createLoanPeopleInMercury(oppoAndaccountId, oId, aId);

		update oppo;
		update contact;
		sendEmail();
		pendingEmails = new List<Map<String, String>>();
	}

	@future(callout=true)
	public static void updateAccountF(String accountId, String oppoId) {
		if (oppoId != null && accountId != null) {

			if (oppoId.length() == 18) {
				oppoId = oppoId.left(15);
			}
			if (accountId.length() == 18) {
				accountId = accountId.left(15);
			}
			String branchId = getBrokerBranch(oppoId);
			String token = MercuryAuth.getInstance().getToken();
			MercuryApiUtilities.updatePeopleInMercury(accountId, token, branchId);
		}
	}

	public static Opportunity createOppoInMercury(String oppoId, String branchId) {
		return createOppoInMercury(oppoId, branchId, false);
	}

	public static Opportunity createOppoInMercury(String oppoId, String branchId, Boolean testMode) {
		Opportunity oppo = [Select Id, Current_Loan_Value__c, Sync_With_Mercury__c, Sync_With_Mercury_Success__c, Current_Assigned_Broker__c, Pre_Sales_Notes__c, Transaction_Type__c,  Name From Opportunity Where Id = : oppoId];
		return createOppoInMercury(oppo, branchId, testMode);
	}

	public static Opportunity createOppoInMercury(Opportunity oppo, String branchId, Boolean testMode) {
		String token = MercuryAuth.getInstance().getToken();
		if(checkRecord('Opportunity', oppo.id) && !testMode) return oppo;

		if (oppo != null) {
			String createdTime = convertCurrentTimeToGMTWithTimeZone();
			HttpRequest req = new HttpRequest();
			HttpResponse res = new HttpResponse();
			Http http = new Http();
			String jsonChange = '["company","createdBy","createdOn","transactionType","personActing","status","lender","lenderNameShort","loanName","agent","personResponsible","partnerSharedWithName","leadSourceDisplay","campaignName","leadSourceId","partnerSharedWithId","campaignId","partnerReference","workspaceUsers","partnerName","sitRep","tranxType","lenderReference","nextGenId","metaData","notePadText","lenderComments","discountType"]';
			req.setHeader('Content-Type', 'application/json');
			req.setEndPoint('https://api.connective.com.au/api/mercury5/' + token + '/loan?changes=' + Encodingutil.urlEncode(jsonChange, 'UTF-8'));
			Decimal loanValue = oppo.Current_Loan_Value__c != null ? oppo.Current_Loan_Value__c : 0;
			String transactionType = oppo.Transaction_Type__c != null ? oppo.Transaction_Type__c : '';
			String jsonToSendOver = '{"uniqueId":"' + oppo.id + '","isDeleted":false,"createdOn":"' + createdTime + '","deletedOn":null,"loanName":"' + oppo.Name + '","amount":' + loanValue + ',"lvr":0,"lender":"","lenderNameShort":"","status":"Lead","agent":"","personActing":"CA47482","financeDate":null,"expectedSettlementDate":null,"confirmedSettlementDate":null,"discount":0,"existingAmount":0,"lmi":0,"settlementDateConfirmed":false,"connectiveLodgeId":0,"peResidualAmount":0,"peRepaymentAmount":0,"peInterestRate":0,"peEffectiveRate":0,"peBrokerage":0,"loanTerm":0,"nextAction":null,"fixedRateExpiry":null,"depositDueDate":null,"vbo":false,"statusLastUpdated":null,"interestOnlyExpiry":null,"securityValue":0,"company":"' + branchId + '","createdBy":"CA47482","transactionType":"Loan","personResponsible":"CA42779","partnerSharedWithName":"","leadSourceDisplay":"ACF Client","campaignName":"","leadSourceId":"3f85d5db-5924-11e4-88e4-00155db85119","partnerSharedWithId":"","campaignId":"","partnerReference":"","workspaceUsers":"","partnerName":"","sitRep":"","tranxType":"' + transactionType + '","lenderReference":"","nextGenId":"","metaData":"","notePadText":"","lenderComments":"","discountType":null}';
			req.setBody(jsonToSendOver);
			req.setMethod(AbstractWebService.HTTP_METHOD_POST);
			if (Test.isRunningTest()) {
				res.setStatusCode(200);
			} else {
				res = http.send(req);
			}
			System.debug(jsonToSendOver);
			System.debug(res.getBody());

			if(res.getStatusCode() == 200) {
				//Mark sync with mercury checkbox ticked
				oppo.Sync_With_Mercury__c = true;
				//Mark sync with mercury success ticked
				oppo.Sync_With_Mercury_Success__c = true;
			} else {
				//Mark sync with mercury checkbox ticked
				oppo.Sync_With_Mercury__c = true;
				pendingEmails.add(new Map<String, String>{'methodName' => 'createOppoInMercury', 'details' => generateDetailPart(req, res)});
				throw new MercurySyncException('StatusCode: ' + res);
			}
			return oppo;
		}
		return oppo;
	}

	public static Contact createPeopleInMercury(String accountId, String branchId) {
		return createPeopleInMercury(accountId, branchId, false);
	}

	public static Contact createPeopleInMercury(String accountId, String branchId, Boolean testMode) {
		AccountSelector accSelector = new AccountSelector();
		Account account = accSelector.getById(accountId);
		// Account account = [Select id, name, FirstName, LastName, PersonContactId FROM Account where id =: accountId];
		Contact contact = [Select id, name, Sync_With_Mercury__c, Sync_With_Mercury_Success__c, Job_Title__c, Gender__c, Title, Phone, FirstName, LastName, Birthday__c, Email, Annual_Income__c, MobilePhone, Marital_Status__c, Employer_Name__c, Current_Role__c, Number_of_Children__c, Employment_Status__c FROM Contact where id = :account.PersonContactId];
		return createPeopleInMercury(account, contact, branchId, testMode);
	}

	public static Contact createPeopleInMercury(Account account, Contact contact, String branchId, Boolean testMode) {
		String token = MercuryAuth.getInstance().getToken();
		if(checkRecord('Account', account.id) && !testMode) return contact;

		if (account != null && account.PersonContactId != null) {
			String createdTime = convertCurrentTimeToGMTWithTimeZone();
			String peopleFirstName = account.FirstName != null && account.FirstName != '' ? account.FirstName : 'defaultFirstName';
			String peopleLastName = account.LastName != null && account.LastName != '' ? account.LastName : 'defaultLastName';
			String email = contact.Email != null && contact.Email.trim() != '' ? contact.Email : '';
			Decimal annualSalary = contact.Annual_Income__c != null && contact.Annual_Income__c > 0 ? contact.Annual_Income__c : 0 ;
			String mobile = contact.MobilePhone != null && contact.MobilePhone.trim() != '' ? contact.MobilePhone : '';
			String homePhone = contact.Phone != null && contact.Phone.trim() != '' ? contact.Phone : '';
			String maritalStatus = contact.Marital_Status__c != null && contact.Marital_Status__c.trim() != '' ? contact.Marital_Status__c : '';
			String employerName = contact.Employer_Name__c != null && contact.Employer_Name__c.trim() != '' ? contact.Employer_Name__c : '';
			String currentRole = contact.Current_Role__c != null && contact.Current_Role__c.trim() != '' ? contact.Current_Role__c : '';
			Integer childrenNum;
			if(contact.Number_of_Children__c == '5+') {
				childrenNum = 5;
			} else {
				childrenNum = contact.Number_of_Children__c != null && contact.Number_of_Children__c != '' ? Integer.valueOf(contact.Number_of_Children__c) : 0;
			}


			String employmentType = contact.Employment_Status__c != null && contact.Employment_Status__c.trim() != '' ? contact.Employment_Status__c : '';
			String gender = contact.Gender__c != null && contact.Gender__c.trim() != '' ? contact.Gender__c : '';
			String birthday = contact.Birthday__c != null ? '"' + convertCurrentTimeToGMTWithTimeZone(contact.Birthday__c) + '"' : null;
			String title = contact.Title != null ? contact.Title : '';
			if (gender == 'Male') {
				gender = 'M';
			} else if (gender == 'Female') {
				gender = 'F';
			}
			String jobTitle = contact.Job_Title__c !=  null ? contact.Job_Title__c : '';
			//String
			HttpRequest req = new HttpRequest();
			HttpResponse res = new HttpResponse();
			Http http = new Http();
			String jsonChange = '["driversLicenceState","company","createdBy","createdOn","mobile","businessPhone","title","firstName","lastName","middleName","salutation","gender","dateOfBirth","maritalStatus","numberOfDependents","lastNameCompany","firstNameCompany","abnCompany","acnCompany","trustNameCompany","relationshipManagerCompany","textfield-3451-inputEl","textfield-3466-inputEl","cbEmailType","emailValue","email","addressDisplay","textareafield-3483-inputEl","employer","occupation","jobTitle","employmentStatus","employmentCommenced","annualSalary","driversLicenceNumber","driversLicenceExpiry","textareafield-3503-inputEl","textareafield-3510-inputEl","relationshipManager","notes"]';
			req.setHeader('Content-Type', 'application/json');
			req.setEndPoint('https://api.connective.com.au/api/mercury5/' + token + '/person?changes=' + Encodingutil.urlEncode(jsonChange, 'UTF-8'));
			String jsonToSendOver = '{"uniqueId":"' + account.id + '","isDeleted":false,"createdOn":"' + createdTime + '","deletedOn":null,"firstName":"' + peopleFirstName + '","lastName":"' + peopleLastName + '","driversLicenceExpiry":"","dateOfBirth":' + birthday + ',"employmentCommenced":"","phoneDisplayType1":"Home","phoneDisplayType2":"Mobile","phoneDisplayType3":"Business","phoneDisplayType4":"Business Fax","addressDisplay":"","numberOfDependents":' + childrenNum + ',"personDataType":"Full","contactType":null,"doNotMail":false,"markAsPrivate":false,"annualSalary":' + annualSalary + ',"emailBounced":false,"driversLicenceState":"NSW","company":"' + branchId + '","createdBy":"CA47482","homePhone":"' + homePhone + '","mobile":"' + mobile + '","businessPhone":"","title":"' + title + '","middleName":"","salutation":"","gender":"' + gender +'","maritalStatus":"' + maritalStatus + '","lastNameCompany":"","firstNameCompany":"","abnCompany":"","acnCompany":"","trustNameCompany":"","relationshipManagerCompany":"CA48099","textfield-3310-inputEl":"","cbEmailType":"Email 1","emailValue":"' + email + '","email":"' + email +'","textareafield-3327-inputEl":"","employer":"' + employerName + '","occupation":"' + currentRole + '","jobTitle":"' + jobTitle + '","employmentStatus":"' + employmentType + '","driversLicenceNumber":"","textareafield-3347-inputEl":"","textareafield-3354-inputEl":"","relationshipManager":"","notes":"","contactMethods":[{"uniqueId":"' + account.id + '-contactHome' + '","isDeleted":false,"createdOn":null,"deletedOn":null,"content":"' + homePhone.replace('+','') + '","contactMethod":"Home","personID":"' + account.id + '"},{"uniqueId":"' + account.id + '-contactMobile' + '","isDeleted":false,"createdOn":null,"deletedOn":null,"content":"' + mobile.replace('+','') + '","contactMethod":"Mobile","personID":"' + account.Id + '"},{"uniqueId":"' + account.id + '-contactBusiness' + '","isDeleted":false,"createdOn":null,"deletedOn":null,"content":"","contactMethod":"Business","personID":"' + account.id + '"},{"uniqueId":"' + account.id + '-contactBusinessFax' + '","isDeleted":false,"createdOn":null,"deletedOn":null,"content":"","contactMethod":"Business Fax","personID":"' + account.id + '"},{"uniqueId":"' + account.id + '-contactEmail' + '","isDeleted":false,"createdOn":null,"deletedOn":null,"content":"' + email +  '","contactMethod":"Email 1","personID":"' + account.id + '"}]}';
			req.setBody(jsonToSendOver);
			System.debug(jsonToSendOver);
			req.setMethod(AbstractWebService.HTTP_METHOD_POST);
			if (Test.isRunningTest()) {
				res.setStatusCode(200);
			} else {
				res = http.send(req);
			}

			System.debug(res.getBody());
			System.debug(res.getStatusCode());

			if (res.getStatusCode() == 200) {
				//Mark sync with mercury checkbox ticked
				contact.Sync_With_Mercury__c = true;
				//Mark sync with mercury success ticked
				contact.Sync_With_Mercury_Success__c = true;
				System.debug('People is created success');
			} else {
				//Mark sync with mercury checkbox ticked
				contact.Sync_With_Mercury__c = true;
				pendingEmails.add(new Map<String, String>{'methodName' => 'createPeopleInMercury', 'details' => generateDetailPart(req, res)});
				throw new MercurySyncException('StatusCode: ' + res);
			}

			//update opportunity
			return contact;
		}
		return null;
	}

	//Sync relationship between opportunity and account
	public static void createLoanPeopleInMercury(String oppoAndaccountId, String oppId, String accountId) {
		String token = MercuryAuth.getInstance().getToken();
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		String createdTime = convertCurrentTimeToGMTWithTimeZone();
		req.setHeader('Content-Type', 'application/json');
		req.setEndPoint('https://api.connective.com.au/api/mercury5/' + token + '/loanPeople');
		String jsonToSendOver = '{"uniqueId":"' + oppoAndaccountId + '","isDeleted":false,"createdOn":"' + createdTime + '","deletedOn":null,"company":"P200019","createdBy":"CA47482","loanID":"' + oppId + '","personID":"' + accountId + '","fullName":"' + oppoAndaccountId + '","relationship":"Primary Applicant"}';
		req.setBody(jsonToSendOver);
		req.setMethod(AbstractWebService.HTTP_METHOD_POST);
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

	//When call this method, check if mercury loan Id on oppo and mercury people id on account is exist, otherwise pass salesforce 18 ids
	public static void getDataBack(String oppoId, Boolean isSalesforceOppoId, String accountId, Boolean isSalesforceAccountId) {
		if (oppoId != null && accountId != null) {
			Id tempId = null;
			if(isSalesforceOppoId) {
				tempId = oppoId;
				oppoId = tempId;
			}

			if(isSalesforceAccountId) {
				tempid = accountId;
				accountId = tempid;
			}

			String token = MercuryAuth.getInstance().getToken();
			getOpportunityAndSaveOnOppo(oppoId, isSalesforceOppoId);
			getPeopleAndSaveOnAccount(accountId, isSalesforceAccountId);
		}
	}

	public static String getBrokerBranch(String oppoId) {
		//default ACF Branch
		String acfBranch = 'P200019';
		List<Opportunity> oppos = [Select Id, Current_Assigned_Broker__c From Opportunity Where Id = :oppoId];
		if (oppos.size() == 1) {
			if (oppos.get(0).Current_Assigned_Broker__c != null) {
				List<Broker__c> brokers = [Select Id, Mercury_Branch__c, Channel__c From Broker__c where Name = :oppos.get(0).Current_Assigned_Broker__c];
				if (brokers.size() == 1) {
					if (brokers.get(0).Channel__c == 'Phone Broker') {
						return acfBranch;
					} else {
						if(brokers.get(0).Mercury_Branch__c == null || brokers.get(0).Mercury_Branch__c == '') return acfBranch;
						return brokers.get(0).Mercury_Branch__c;
					}
				}
			}
		}
		return acfBranch;
	}

	public static void updatePeopleInMercury(String accountId, String token, String branchId) {
		AccountSelector accSelector = new AccountSelector();
		Account account = accSelector.getById(accountId);
		if (account != null && account.PersonContactId != null) {
			Contact contact = [Select id, name, acf_applicant_DOB__c, acf_Applicant_Dependants__c, acfAnnual_Salary__c, acf_applicant_Marital_Status__c, acf_Applicant_Employment_Type__c, acf_applicant_Monthlly_Salary__c, acf_applicant_Employer_Name__c, Sync_With_Mercury__c, Sync_With_Mercury_Success__c, Job_Title__c, Gender__c, Title, Phone, FirstName, LastName, Birthday__c, Email, Annual_Income__c, MobilePhone, Marital_Status__c, Employer_Name__c, Current_Role__c, Number_of_Children__c, Employment_Status__c FROM Contact where id = :account.PersonContactId];
			String createdTime = convertCurrentTimeToGMTWithTimeZone();
			String peopleFirstName = account.FirstName != null && account.FirstName != '' ? account.FirstName : 'defaultFirstName';
			String peopleLastName = account.LastName != null && account.LastName != '' ? account.LastName : 'defaultLastName';
			String email = contact.Email != null && contact.Email.trim() != '' ? contact.Email : '';
			Decimal annualSalary = contact.acf_applicant_Monthlly_Salary__c != null && contact.acf_applicant_Monthlly_Salary__c > 0 ? contact.acf_applicant_Monthlly_Salary__c : contact.Annual_Income__c != null && contact.Annual_Income__c > 0 ? contact.Annual_Income__c : 0;
			String mobile = contact.MobilePhone != null && contact.MobilePhone.trim() != '' ? contact.MobilePhone : '';
			String homePhone = contact.Phone != null && contact.Phone.trim() != '' ? contact.Phone : '';
			String maritalStatus = contact.Marital_Status__c != null && contact.Marital_Status__c.trim() != '' ? contact.Marital_Status__c : '';
			String employerName = contact.Employer_Name__c != null && contact.Employer_Name__c.trim() != '' ? contact.Employer_Name__c : '';
			String currentRole = contact.Current_Role__c != null && contact.Current_Role__c.trim() != '' ? contact.Current_Role__c : '';
			Integer childrenNum;
			if(contact.Number_of_Children__c == '5+') {
				childrenNum = 5;
			} else {
				childrenNum = contact.Number_of_Children__c != null && contact.Number_of_Children__c != '' ? Integer.valueOf(contact.Number_of_Children__c) : 0;
			}

			String employmentType = contact.Employment_Status__c != null && contact.Employment_Status__c.trim() != '' ? contact.Employment_Status__c : '';
			String gender = contact.Gender__c != null && contact.Gender__c.trim() != '' ? contact.Gender__c : '';
			String birthday = contact.Birthday__c != null ? '"' + convertCurrentTimeToGMTWithTimeZone(contact.Birthday__c) + '"' : null;
			List<String> chagnesets = new List<String>();
			//convert string birthday to date birthday
			String birthdayNew = contact.acf_applicant_DOB__c;
			if (birthdayNew != null && birthdayNew != '') {
				String[] dateValues = birthdayNew.split('/');
				System.debug(dateValues);
				if (dateValues.size() == 3) {
					Date birthdayDateNew = Date.newInstance(Integer.valueOf(dateValues[2]), Integer.valueOf(dateValues[1]), Integer.valueOf(dateValues[0]));
					if (birthdayDateNew != contact.Birthday__c ) {
						chagnesets.add('dateOfBirth');
						birthday = '"' + convertCurrentTimeToGMTWithTimeZone(birthdayDateNew) + '"';
					}
				}
			}
			//String birthday = contact.acf_applicant_DOB__c != null ? convertCurrentTimeToGMTWithTimeZone(contact.acf_applicant_DOB__c) : null;
			String title = contact.Title != null ? contact.Title : '';
			if (gender == 'Male') {
				gender = 'M';
			} else if (gender == 'Female') {
				gender = 'F';
			}
			String jobTitle = contact.Job_Title__c !=  null ? contact.Job_Title__c : '';
			//String
			HttpRequest req = new HttpRequest();
			HttpResponse res = new HttpResponse();
			Http http = new Http();
			req.setHeader('Content-Type', 'application/json');
			//construct change log
			if (currentRole != null && currentRole != '') {
				chagnesets.add('occupation');
				chagnesets.add('jobTitle');
			}

			if (contact.acf_applicant_Marital_Status__c != null && contact.acf_applicant_Marital_Status__c != '' && contact.acf_applicant_Marital_Status__c != maritalStatus) {
				chagnesets.add('maritalStatus');
				maritalStatus = contact.acf_applicant_Marital_Status__c;
			}

			if (contact.acf_applicant_Employer_Name__c != null && contact.acf_applicant_Employer_Name__c != '' && contact.acf_applicant_Employer_Name__c != employerName) {
				chagnesets.add('employer');
				employerName = contact.acf_applicant_Employer_Name__c;
			}

			if (annualSalary != contact.Annual_Income__c) {
				chagnesets.add('annualSalary');
			}
			Integer oldChildrenNumber = contact.Number_of_Children__c != null && contact.Number_of_Children__c != '' ? Integer.valueOf(contact.Number_of_Children__c) : 0;
			if (childrenNum != oldChildrenNumber) {
				chagnesets.add('numberOfDependents');
			}
			String changeString = '';
			if (chagnesets.size() > 0) {
				changeString = changeString + '[';
				for (Integer i = 0; i < chagnesets.size(); i ++) {
					if (i == chagnesets.size() - 1) {
						changeString = changeString + '"' + chagnesets.get(i) + '"';
					} else {
						changeString = changeString + '"' + chagnesets.get(i) + '",';
					}
				}
				changeString = changeString + ']';
			}
			if (account.Mercury_People_ID__c != null ) {
				accountId = account.Mercury_People_ID__c;
			}
			req.setEndPoint('https://api.connective.com.au/api/mercury5/' + token + '/person/' + accountId + '?changes=' + Encodingutil.urlEncode(changeString, 'UTF-8'));
			System.debug('https://api.connective.com.au/api/mercury5/' + token + '/person/' + accountId + '?changes=' + Encodingutil.urlEncode(changeString, 'UTF-8'));
			String jsonToSendOver = '{"uniqueId":"' + accountId + '","isDeleted":false,"createdOn":null,"deletedOn":null,"firstName":"' + peopleFirstName + '","lastName":"' + peopleLastName + '","driversLicenceExpiry":null,"dateOfBirth":' + birthday + ',"employmentCommenced":null,"phoneDisplayType1":"Home","phoneDisplayType2":"Mobile","phoneDisplayType3":"Business","phoneDisplayType4":"Business Fax","addressDisplay":"","numberOfDependents":' + childrenNum + ',"personDataType":"Full","contactType":null,"doNotMail":false,"markAsPrivate":false,"annualSalary":' + annualSalary + ',"emailBounced":false,"company":"' + branchId + '","deletedBy":null,"createdBy":"CA47482","isNew":null,"middleName":"","salutation":"","title":"","occupation":"' + currentRole + '","employer":"' + employerName + '","jobTitle":"' + currentRole + '","maritalStatus":"' + maritalStatus + '","driversLicenceNumber":"","driversLicenceState":"","gender":"","employmentStatus":"","homePhone":"","businessPhone":"","mobile":"","email":"","notes":"","relationshipManager":"","abn":null,"acn":null,"trustName":null,"homeSuburb":null,"funambolUsers":null,"importDocumentId":"","partnerName":"","webPassword":"","webAccess":false,"fullName":"","salutationOrFirstName":"","lastNameCompany":"","firstNameCompany":"","abnCompany":"","acnCompany":"","trustNameCompany":"","relationshipManagerCompany":"","textfield-1575-inputEl":"","textfield-1580-inputEl":"","textfield-1585-inputEl":"","textfield-1590-inputEl":"","cbEmailType":"Email 1","emailValue":"' + email + '","textareafield-1607-inputEl":"","textareafield-1627-inputEl":"","textareafield-1634-inputEl":""}';
			req.setBody(jsonToSendOver);
			System.debug(jsonToSendOver);
			req.setMethod('PUT');
			if (Test.isRunningTest()) {
				res.setBody('');
			} else {
				res = http.send(req);
			}
			System.debug(res.getBody());
		}
	}

	@future(callout=true)
	public static void getOpportunityAndSaveOnOppo(String oppoId, Boolean isSalesforceId) {
		String token = MercuryAuth.getInstance().getToken();
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setEndpoint('https://api.connective.com.au/api/mercury5/' + token + '/loan/' + oppoId);
		req.setMethod(AbstractWebService.HTTP_METHOD_GET);
		if (Test.isRunningTest()) {
			res.setBody('{"success":true,"totalVolume":0.0,"total":1,"loans":[{"uniqueId":"c3170974-3632-4d3e-8960-ef20f127e908","company":"P200019","isDeleted":false,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"loanName":",","amount":0.0,"lender":"","lenderNameShort":null,"status":"Lead","agent":"","personActing":"CA42767","personResponsible":"","lenderReference":"","financeDate":null,"expectedSettlementDate":null,"confirmedSettlementDate":null,"leadSourceId":null,"leadSourceDisplay":null,"discount":0.0,"existingAmount":0.0,"lmi":0.0,"settlementDateConfirmed":false,"discountType":"","loanPersonRelationship":null,"transactionType":"Loan","notePadText":null,"partnerReference":"","nextGenId":null,"parentId":null,"workspaceUsers":"","tranxType":"","connectiveLodgeId":0,"peResidualAmount":0.0,"peRepaymentAmount":0.0,"peEffectiveRate":0.0,"peInterestRate":0.0,"peBrokerage":0.0,"assetDescription":null,"nextAction":null,"loanTerm":0,"metaData":null,"fixedRateExpiry":null,"depositDueDate":null,"vbo":false,"barCodeId":null,"agentName":" ","personActingName":"Cristina Jarina","personResponsibleName":" ","defaultPath":null,"partnerName":"Australian Credit and Finance","partnerSharedWithId":null,"partnerSharedWithName":null,"statusLastUpdated":1405417339000,"lenderComments":null,"sitRep":null,"campaignId":null,"campaignName":null,"securityValue":0.0,"aliApplicationId":"","interestOnlyExpiry":null}]}');
		} else {
			res = http.send(req);
		}
		System.debug('json back: ' + res.getBody());
		Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
		if (results != null && results.get('success') != null && Boolean.valueOf(results.get('success'))) {
			List<Object> allLoans = (List<Object>) results.get('loans');
			if (allLoans.size() > 0) {
				Map<String, Object> subResult = (Map<String, Object>) allLoans.get(0);
				if (subResult != null) {
					String loanName = subResult.get('loanName') != null ? String.valueOf(subResult.get('loanName')) : '';
					Decimal amount = subResult.get('amount') != null ? Decimal.valueOf(String.valueOf(subResult.get('amount'))) : 0;
					String lender = subResult.get('lender') != null ? String.valueOf(subResult.get('lender')) : '';
					String status = subResult.get('status') != null ? String.valueOf(subResult.get('status')) : '';
					String agent = subResult.get('agent') != null ? String.valueOf(subResult.get('agent')) : '';
					Decimal discount = subResult.get('discount') != null ? Decimal.valueOf(String.valueOf(subResult.get('discount'))) : 0;
					Decimal existingAmount = subResult.get('existingAmount') != null ? Decimal.valueOf(String.valueOf(subResult.get('existingAmount'))) : 0;
					Decimal lmi = subResult.get('lmi') != null ? Decimal.valueOf(String.valueOf(subResult.get('lmi'))) : 0;
					Boolean settlementDateConfirmed = subResult.get('settlementDateConfirmed') != null ? Boolean.valueOf(String.valueOf(subResult.get('settlementDateConfirmed'))) : false;
					String discountType = subResult.get('discountType') != null ? String.valueOf(subResult.get('discountType')) : '';
					String transactionType = subResult.get('transactionType') != null ? String.valueOf(subResult.get('transactionType')) : ''; // Opportunity Type
					String notePadText = subResult.get('notePadText') != null ? String.valueOf(subResult.get('notePadText')) : '';
					String partnerReference = subResult.get('partnerReference') != null ? String.valueOf(subResult.get('partnerReference')) : '';
					String tranxType = subResult.get('tranxType') != null ? String.valueOf(subResult.get('tranxType')) : '';
					long statusLastUpdated = long.valueOf(String.valueOf(subResult.get('statusLastUpdated')));
					Decimal securityValue = subResult.get('securityValue') != null ? Decimal.valueOf(String.valueOf(subResult.get('securityValue'))) : 0;
					String partnerName = subResult.get('partnerName') != null ? String.valueOf(subResult.get('partnerName')) : '';
					if (isSalesforceId) {
						List<Opportunity> oppos = [Select Id, Name, Current_Loan_Value__c, Current_Lender__c, StageName, Mercury_Branch__c, Mercury_Note__c From Opportunity Where Id = :oppoId];
						if (oppos.size() == 1) {
							Opportunity oppo = oppos.get(0);
							oppo.Current_Lender__c = lender;
							oppo.Current_Loan_Value__c = amount;
							oppo.StageName = status;
							oppo.Mercury_Branch__c = partnerName;
							oppo.Mercury_Note__c = notePadText;
							update oppo;
						}
					} else {
						List<Opportunity> oppos = [Select Id, Name, Current_Loan_Value__c, Current_Lender__c, StageName, Mercury_Branch__c, Mercury_Note__c From Opportunity Where Mercury_Loan_ID__c = :oppoId];
						if (oppos.size() == 1) {
							Opportunity oppo = oppos.get(0);
							oppo.Current_Lender__c = lender;
							oppo.Current_Loan_Value__c = amount;
							oppo.StageName = status;
							oppo.Mercury_Branch__c = partnerName;
							oppo.Mercury_Note__c = notePadText;
							update oppo;
						}
					}
				}
			}
		}
	}

	@future(callout=true)
	public static void getPeopleAndSaveOnAccount(String accountId, Boolean isSalesforceId) {
		if(!checkRecord('Account', accountId)) {
			accountId = accountId.left(15);
			if(!checkRecord('Account', accountId)) return;
		}

		String token = MercuryAuth.getInstance().getToken();
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		String url = 'https://api.connective.com.au/api/mercury5/' + token + '/person/' + accountId;
		req.setEndpoint(url);
		req.setMethod(AbstractWebService.HTTP_METHOD_GET);
		if (Test.isRunningTest()) {
			res.setBody('{"success":true,"people":{"uniqueId":"33e1600c-2d1b-4685-8cec-43b5acb397e6","company":"P200019","isDeleted":false,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":"CA42767","isNew":null,"firstName":"","lastName":"","middleName":null,"salutation":null,"title":null,"occupation":"","employer":null,"jobTitle":null,"maritalStatus":null,"driversLicenceNumber":null,"driversLicenceExpiry":null,"driversLicenceState":null,"gender":null,"dateOfBirth":null,"employmentStatus":"","employmentCommenced":null,"phoneDisplayType1":"Home","phoneDisplayType2":"Mobile","phoneDisplayType3":"Business","phoneDisplayType4":"Business Fax","addressDisplay":"Home","homePhone":"","businessPhone":null,"mobile":"","email":"","personDataType":"Full","notes":null,"relationshipManager":null,"annualSalary":0.0,"contactType":null,"abn":null,"acn":null,"trustName":null,"homeSuburb":null,"numberOfDependents":0,"doNotMail":false,"funambolUsers":"CA45753","markAsPrivate":false,"importDocumentId":"","partnerName":"Australian Credit and Finance","emailBounced":false,"webPassword":"","webAccess":false,"contactMethods":[{"uniqueId":"2ca1b6fa-0c02-11e4-ad0e-00155d0a3619","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"personID":"33e1600c-2d1b-4685-8cec-43b5acb397e6","contactMethod":"Home","content":"","type":"phone"},{"uniqueId":"2ca26af4-0c02-11e4-ad0e-00155d0a3619","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"personID":"33e1600c-2d1b-4685-8cec-43b5acb397e6","contactMethod":"Mobile","content":"","type":"phone"},{"uniqueId":"2ca372c8-0c02-11e4-ad0e-00155d0a3619","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"personID":"33e1600c-2d1b-4685-8cec-43b5acb397e6","contactMethod":"Email 1","content":"","type":"email"}],"fullName":" ","salutationOrFirstName":""}}');
		} else {
			res = http.send(req);
		}
		// Analyst json reponse and save them into contact
		Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
		if (results != null && results.get('success') != null && Boolean.valueOf(results.get('success'))) {
			Map<String, Object> subResult = (Map<String, Object>) results.get('people');
			if (subResult != null) {
				String abn = subResult.get('abn') != null ? String.valueOf(subResult.get('abn')) : '';
				String acn = subResult.get('acn') != null ? String.valueOf(subResult.get('acn')) : '';
				String firstName = subResult.get('firstName') != null ? String.valueOf(subResult.get('firstName')) : '';
				String lastName = subResult.get('lastName') != null ? String.valueOf(subResult.get('lastName')) : '';
				String middleName = subResult.get('middleName') != null ? String.valueOf(subResult.get('middleName')) : '';
				String salutation = subResult.get('salutation') != null ? String.valueOf(subResult.get('salutation')) : '';
				String title = subResult.get('title') != null ? String.valueOf(subResult.get('title')) : '';
				String occupation = subResult.get('occupation') != null ? String.valueOf(subResult.get('occupation')) : '';
				String employer = subResult.get('employer') != null ? String.valueOf(subResult.get('employer')) : '';
				String jobTitle = subResult.get('jobTitle') != null ? String.valueOf(subResult.get('jobTitle')) : '';
				String maritalStatus = subResult.get('maritalStatus') != null ? String.valueOf(subResult.get('maritalStatus')) : '';
				String gender = subResult.get('gender') != null ? String.valueOf(subResult.get('gender')) : '';
				long dateOfBirth = 0L;
				if (subResult.get('dateOfBirth') != null) {
					dateOfBirth = long.valueOf(String.valueOf(subResult.get('dateOfBirth')));
				}
				String employmentStatus = subResult.get('employmentStatus') != null ? String.valueOf(subResult.get('employmentStatus')) : '';
				String employmentCommenced = subResult.get('employmentCommenced') != null ? String.valueOf(subResult.get('employmentCommenced')) : '';
				String homePhone = subResult.get('homePhone') != null ? String.valueOf(subResult.get('homePhone')) : '';
				String businessPhone = subResult.get('businessPhone') != null ? String.valueOf(subResult.get('businessPhone')) : '';
				String mobile = subResult.get('mobile') != null ? String.valueOf(subResult.get('mobile')) : '';
				String email = subResult.get('email') != null ? String.valueOf(subResult.get('email')) : '';
				Decimal annualSalary = subResult.get('annualSalary') != null ? Decimal.valueOf(String.valueOf(subResult.get('annualSalary'))) : 0;
				Integer numberOfDependents = subResult.get('numberOfDependents') != null ? Integer.valueOf(subResult.get('numberOfDependents')) : 0;
				if (isSalesforceId) {
					// Saving it into contact
					List<Account> accounts = [Select id, name, FirstName, LastName, PersonContactId FROM Account where id =: accountId];
					if (accounts.size() == 1) {
						Account account = accounts.get(0);
						if (account != null && account.PersonContactId != null) {
							Contact contact = [Select Id, Name, acf_applicant_DOB__c, acf_Applicant_Name__c, acf_applicant_Marital_Status__c, acf_Applicant_Dependants__c, acf_applicant_Monthlly_Salary__c, acf_applicant_Employer_Name__c, Current_Role__c, acfHome_Phone__c FROM Contact where Id = :account.PersonContactId];
							//System.debug('dateOfBirth ' + dateOfBirth);
							if (dateOfBirth > 0) {
								Datetime dob = DateTime.newInstance(dateOfBirth);
								String dateString = dob.format('dd/MM/yyyy');
								System.debug(dateString);
								contact.acf_applicant_DOB__c = dateString;
							}
							contact.acf_Applicant_Name__c = firstName + ' ' + lastName;
							contact.acf_applicant_Marital_Status__c = maritalStatus;
							contact.acf_Applicant_Dependants__c = numberOfDependents + '';
							contact.acf_applicant_Monthlly_Salary__c = annualSalary;
							contact.acf_applicant_Employer_Name__c = employer;
							contact.Current_Role__c = occupation;
							update contact;
						}
					}
				} else {
					List<Account> accounts = [Select id, name, FirstName, LastName, PersonContactId FROM Account where Mercury_People_ID__c =: accountId];
					if (accounts.size() == 1) {
						Account account = accounts.get(0);
						if (account != null && account.PersonContactId != null) {
							Contact contact = [Select Id, Name, acf_applicant_DOB__c, acf_Applicant_Name__c, acf_applicant_Marital_Status__c, acf_Applicant_Dependants__c, acf_applicant_Monthlly_Salary__c, acf_applicant_Employer_Name__c, Current_Role__c, acfHome_Phone__c FROM Contact where Id = :account.PersonContactId];
							System.debug('dateOfBirth ' + dateOfBirth);
							if (dateOfBirth > 0) {
								Datetime dob = DateTime.newInstance(dateOfBirth);
								String dateString = dob.format('dd/MM/yyyy');
								System.debug(dateString);
								contact.acf_applicant_DOB__c = dateString;
							}
							contact.acf_Applicant_Name__c = firstName + ' ' + lastName;
							contact.acf_applicant_Marital_Status__c = maritalStatus;
							contact.acf_Applicant_Dependants__c = numberOfDependents + '';
							contact.acf_applicant_Monthlly_Salary__c = annualSalary;
							contact.acf_applicant_Employer_Name__c = employer;
							contact.Current_Role__c = occupation;
							update contact;
						}
					}
				}
			}
		}
	}

	// 	public static void createSecondApplicationInMercury(String token, String accountId) {
	// 		// check if there is a second applicant
	// 		//sync it over and connect with the current opportunity.
	// 		Account account = [Select id, name, FirstName, LastName, PersonContactId FROM Account where id =: accountId];
	// 		if (account != null && account.PersonContactId != null) {
	// 				Contact contact = [Select Id, Name, acfNumber_Of_Applicants__c, acfApplicant2_email__c, acfApplicant2_phone__c, acfApplicant2_Name__c, acfApplicant2_Monthly_Salary__c, acfApplicant2_Marital_Status__c, acfApplicant2_Employer_Name__c, acfApplicant2_Dependents__c, acfApplicant2_Employment_Type__c, acfApplicant2_DOB__c From Contact where id = :account.PersonContactId];
	// 			if (contact.acfNumber_Of_Applicants__c != null && Integer.valueOf(contact.acfNumber_Of_Applicants__c) == 2) {
	// 				String createdTime = convertCurrentTimeToGMTWithTimeZone();
	// 				String peopleFirstName = contact.acfApplicant2_Name__c != null & contact.acfApplicant2_Name__c.trim() != '' ? contact.acfApplicant2_Name__c : '';
	// 				String peopleLastName = contact.acfApplicant2_Name__c != null & contact.acfApplicant2_Name__c.trim() != '' ? contact.acfApplicant2_Name__c : '';
	// 				String email = contact.acfApplicant2_email__c != null && contact.acfApplicant2_email__c.trim() != '' ? contact.acfApplicant2_email__c : '';
	// 				String mobile = contact.acfApplicant2_phone__c != null && contact.acfApplicant2_phone__c.trim() != '' ? contact.acfApplicant2_phone__c : '';
	// 				Decimal annualSalary = contact.acfApplicant2_Monthly_Salary__c != null && contact.acfApplicant2_Monthly_Salary__c > 0 ? contact.acfApplicant2_Monthly_Salary__c : 0;
	// 				String maritalStatus = contact.acfApplicant2_Marital_Status__c != null && contact.acfApplicant2_Marital_Status__c.trim() != '' ? contact.acfApplicant2_Marital_Status__c : '';
	// 				String employerName = contact.acfApplicant2_Employer_Name__c != null && contact.acfApplicant2_Employer_Name__c.trim() != '' ? contact.acfApplicant2_Employer_Name__c : '';
	// 				String currentRole = '';
	// 				Integer childrenNum = contact.acfApplicant2_Dependents__c != null && contact.acfApplicant2_Dependents__c != '' ? Integer.valueOf(contact.acfApplicant2_Dependents__c) : 0;
	// 				String employmentType = contact.acfApplicant2_Employment_Type__c != null && contact.acfApplicant2_Employment_Type__c.trim() != '' ? contact.acfApplicant2_Employment_Type__c : '';
	// 				String gender = '';
	// 				String birthday = null;
	// 				String birthdayNew = contact.acfApplicant2_DOB__c;
	// 				if (birthdayNew != null && birthdayNew != '') {
	// 					String[] dateValues = birthdayNew.split('/');
	// 					if (dateValues.size() == 3) {
	// 						Date birthdayDateNew = Date.newInstance(Integer.valueOf(dateValues[2]), Integer.valueOf(dateValues[1]), Integer.valueOf(dateValues[0]));
	// 						birthday = '"' + convertCurrentTimeToGMTWithTimeZone(birthdayDateNew) + '"';
	// 					}
	// 				}
	// 				String title = '';
	// 				String jobTitle = '';

	// 				HttpRequest req = new HttpRequest();
	// 		        HttpResponse res = new HttpResponse();
	// 		        Http http = new Http();
	// 		        req.setHeader('Content-Type', 'application/json');


	// 			}
	// 		}
	// 	}

	public static void getAllPersonalBranches(String token) {
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		String url = 'https://api.connective.com.au/api/mercury5/' + token + '/partner';
		req.setEndpoint(url);
		req.setMethod(AbstractWebService.HTTP_METHOD_GET);
		if (Test.isRunningTest()) {
			res.setBody('{"success":true,"partnerList":[{"uniqueId":"09942540-da5d-47ba-b662-b0315c52ef5f","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"parentId":"P200019","name":"Adam Harling","businessEntityName":null,"postalAddressLine1":null,"postalAddressLine2":null,"postalCity":null,"postalState":null,"postalPostCode":null,"phone":null,"fax":null,"otherPhone":null,"abn":null,"userDefinedId":"AH","zendeskId":null,"bdm":null,"myMarketingPlanId":null,"oneTouch":null,"children":null,"linkedPartners":null,"vcCategories":null,"finconnect":false,"ybr":false}]}');
		} else {
			res = http.send(req);
		}
		// Analyst json reponse and save them into contact
		Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
		if (results != null && results.get('success') != null && Boolean.valueOf(results.get('success'))) {
			List<Object> partnerList = (List<Object>) results.get('partnerList');
			List<Broker__c> brokersU = new List<Broker__c>();
			Map<String, String> brokerAndMercury = new Map<String, String>();
			Set<String> brokerNames = new Set<String>();
			if (partnerList.size() > 0) {
				for (Integer i = 0 ; i < partnerList.size(); i ++) {
					Map<String, Object> partner = (Map<String, Object>) partnerList.get(i);
					System.debug(partner.get('name') + ' ' + partner.get('uniqueId'));
					String brokerName = partner.get('name') != null ? String.valueOf(partner.get('name')) : null;
					String mercuryId = partner.get('uniqueId') != null ? String.valueOf(partner.get('uniqueId')) : null;
					if (brokerName != null && mercuryId != null) {
						brokerAndMercury.put(brokerName, mercuryId);
						brokerNames.add(brokerName);

					}
				}
			}
			List<Broker__c> brokers = [Select Id, Mercury_Branch__c, Name From Broker__c where Name in :brokerNames];
			for (Broker__c broker : brokers) {
				if (brokerAndMercury.get(broker.Name) != null) {
					//TODO: name is dangous
					broker.Mercury_Branch__c = brokerAndMercury.get(broker.Name);
					brokersU.add(broker);
				}
			}
			update brokersU;
		}
	}

	public static boolean getApproveFromXml(Dom.Document doc) {
		Boolean ret = false;

		if(doc != null) {
			Dom.Xmlnode node = doc.getRootElement();
			if (node != null && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
				if (node.getName() == 'login') {
					for (Dom.XMLNode child: node.getChildElements()) {
						if (child.getName() == 'approved') {
							ret = Boolean.valueOf(child.getText());
						}
					}
				}
			}
		}

		return ret;
	}

	public static String getTokenFromXml(Dom.Document doc) {
		String token = null;
		if (doc != null) {
			Dom.Xmlnode node = doc.getRootElement();
			if (node != null && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
				if (node.getName() == 'login') {
					for (Dom.XMLNode child: node.getChildElements()) {
						if (child.getName() == 'token') {
							token = child.getText();
						}
					}
				}
			}
		}
		return token;
	}

	//Move to Utilities Class?
	public static String convertCurrentTimeToGMTWithTimeZone(Datetime birthday) {
		String gmtTimeValue = String.valueOfGmt(birthday);
		gmtTimeValue = gmtTimeValue.replace(' ', 'T') + '+10:00';
		System.debug(gmtTimeValue);
		return gmtTimeValue;
	}

	//Move to Utilities Class?
	public static String convertCurrentTimeToGMTWithTimeZone() {
		String gmtTimeValue = String.valueOfGmt(Datetime.now());
		gmtTimeValue = gmtTimeValue.replace(' ', 'T') + '+10:00';
		System.debug(gmtTimeValue);
		return gmtTimeValue;
	}

	public static void sendEmail() {
		if(emailSwh) {
			system.debug(LoggingLevel.INFO, 'Sending Email to subscribers...');
			for(Map<String, String> pe : pendingEmails) {
				String body = generateHTMLEmailBody(APPLICATION, 'MercuryApiUtilities', pe.get('methodName'), pe.get('details'));
				Utilities.sendEmail(recipients, 'Salesforce Debug', body);
			}
		}
	}

	public static String generateDetailPart(HttpRequest req, HttpResponse res) {
		String ret = '';

		ret += '<span>Header</span>';
		ret += '<p>' + 'Content-Type: ' + req.getHeader('Content-Type') + '</p>';
		ret += '<span>End Point</span>';
		ret += '<p>' + req.getEndpoint() + '</p>';
		ret += '<span>Http Method</span>';
		ret += '<p>' + req.getMethod() + '</p>';
		ret += '<span>Request Body<span>';
		ret += '<p>' + req.getBody() + '</p>';
		ret += '<span>========================================</span><br/>';
		ret += '<span>Status Code</span>';
		ret += '<p>' + res.getStatusCode() + '</p>';
		ret += '<span>Response Body</span>';
		ret += '<p>\"'+ res.getBody() + '\"</p>';

		return ret;
	}

	public static String getAuthToken() {
		HttpRequest req  = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http        = new Http();
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.setEndPoint(LOGIN_END_POINT);
		req.setBody('username=' + USER_NAME + '&password=' + PASSWORD + '&application=' + APPLICATION);
		req.setMethod(AbstractWebService.HTTP_METHOD_POST);
		res = http.send(req);

		Dom.Document doc = res.getBodyDocument();
		String token     = MercuryApiUtilities.getTokenFromXml(doc);
		System.debug(LoggingLevel.INFO, 'getAuthToken: ' + token);
		if(res.getStatusCode() != 200 || !MercuryApiUtilities.getApproveFromXml(doc) || token == null) {
			Map<String, String> email = new Map<String, String>{
				'methodName' => 'loginToMercury',
				'details'    => MercuryApiUtilities.generateDetailPart(req, res)
			};
			pendingEmails.add(email);
		}
		return token;
	}

	public static Map<String, Object> handleGetResponse(HttpResponse res) {
		//re authenticate if get status code equals 401
		if(res.getStatusCode() == 401) MercuryAuth.getInstance().auth();
		if(res.getStatusCode() != 200 || res.getBody() == '') return null;
		Map<String, Object> ret = null;
		try {
			ret = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
			System.Debug(LoggingLevel.INFO, ret);
		} catch (Exception e) {
			return null;
		}

		if(ret.get('success') != true) return null;
		return ret;
	}

	public static HttpResponse sendGetRequest(String endPoint) {
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setHeader('Content-Type', 'application/json');
		req.setEndPoint(endPoint);
		system.debug(req.getEndpoint());
		req.setMethod(AbstractWebService.HTTP_METHOD_GET);
		res = http.send(req);
		if(res.getStatusCode() != 200) {
			pendingEmails.add(new Map<String, String>{'methodName' => 'sendGetRequest', 'details' => generateDetailPart(req, res)});
		}
		system.debug(LoggingLevel.INFO, res);
		return res;
	}

	public static HttpResponse sendGetRequest(String sfObjectName, MercuryModel.URLParams urlParams) {
		String token = MercuryAuth.getInstance().getToken();
		String endPoint = DOMAIN + '/' + API_VERSION + '/' + APPLICATION + '/' + token + '/' + sfToMercuryObjectMap.get(sfObjectName.toLowerCase()) + '?';
		return sendGetRequest(endPoint + urlParams.toString());
	}

	public static HttpResponse sendGetRequest(String sfObjectName, String rid) {
		String token = MercuryAuth.getInstance().getToken();
		String endPoint = DOMAIN + '/' + API_VERSION + '/' + APPLICATION + '/' + token + '/' + sfToMercuryObjectMap.get(sfObjectName.toLowerCase()) + '/' + rid;
		return sendGetRequest(endPoint);
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
			return checkRecordFromResMap(handleGetResponse(sendGetRequest(sfObjectName, tempIdString)), sfObjectName, tempIdString);
		} else {
			return checkRecordFromResMap(resMap, sfObjectName, rid);
		}
	}

	public static boolean checkRecordFromResMap(Map<String, Object> resMap, String sfObjectName, String rid) {
		if(resMap == null) return false;
		if(rid.length() == 18) return true;

		Object temp = resMap.get(sfToMercuryItemMap.get(sfObjectName.toLowerCase()));
		Map<String, Object> m = null;
		if(temp instanceOf Map<String, Object>) {
			m = (Map<String, Object>) temp;
		} else {
			List<Object> ml = (List<Object>) temp;
			m = (Map<String, Object>) ml[0];
		}

		system.Debug(m);
		system.debug(m.get('uniqueId'));
		System.Debug(rid);
		if(String.valueOf(m.get('uniqueId')).equals(rid)) return true;
		return false;
	}

	public static String generateHTMLEmailBody(String projectName, String className, String methodName, String detail) {
		if(debugEmailTemplate == null) {
			Document doc = [select id, body from Document where name = 'DebugEmailTemplate' limit 1];
			debugEmailTemplate = doc.body.toString();
		}
		return debugEmailTemplate.replace('%%projectName%%', projectName).replace('%%className%%', className).replace('%%methodName%%', methodName).replace('%%details%%', detail);
	}

	public class MercurySyncException extends Exception {}

	}
