public with sharing class MercuryApiUtilitiesChen {
	//TODO: chen's method
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

	@future(callout=true)
	public static void updateAccountF(String accountId, String oppoId) {
		if (oppoId != null && accountId != null) {

			if (oppoId.length() == 18) {
				oppoId = oppoId.left(15);
			}
			if (accountId.length() == 18) {
				accountId = accountId.left(15);
			}
			String branchId = MercuryUtility.getBrokerBranch(oppoId);
			String token = MercuryAuth.getInstance().getToken();
			updatePeopleInMercury(accountId, token, branchId);
		}
	}

	public static void updatePeopleInMercury(String accountId, String token, String branchId) {
		AccountSelector accSelector = new AccountSelector();
		Account account = accSelector.getById(accountId);
		if (account != null && account.PersonContactId != null) {
			Contact contact = [Select id, name, acf_applicant_DOB__c, acf_Applicant_Dependants__c, acfAnnual_Salary__c, acf_applicant_Marital_Status__c, acf_Applicant_Employment_Type__c, acf_applicant_Monthlly_Salary__c, acf_applicant_Employer_Name__c, Sync_With_Mercury__c, Sync_With_Mercury_Success__c, Job_Title__c, Gender__c, Title, Phone, FirstName, LastName, Birthday__c, Email, Annual_Income__c, MobilePhone, Marital_Status__c, Employer_Name__c, Current_Role__c, Number_of_Children__c, Employment_Status__c FROM Contact where id = :account.PersonContactId];
			String createdTime = MercuryUtility.convertCurrentTimeToGMTWithTimeZone();
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
			String birthday = contact.Birthday__c != null ? '"' + MercuryUtility.convertCurrentTimeToGMTWithTimeZone(contact.Birthday__c) + '"' : null;
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
						birthday = '"' + MercuryUtility.convertCurrentTimeToGMTWithTimeZone(birthdayDateNew) + '"';
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
		req.setMethod('GET');
		if (Test.isRunningTest()) {
			res.setBody('{"success":true,"totalVolume":0.0,"total":1,"loans":[{"uniqueId":"c3170974-3632-4d3e-8960-ef20f127e908","company":"' + MercuryStaticValue.ACF_BRANCH_ID + '","isDeleted":false,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"loanName":",","amount":0.0,"lender":"","lenderNameShort":null,"status":"Lead","agent":"","personActing":"CA42767","personResponsible":"","lenderReference":"","financeDate":null,"expectedSettlementDate":null,"confirmedSettlementDate":null,"leadSourceId":null,"leadSourceDisplay":null,"discount":0.0,"existingAmount":0.0,"lmi":0.0,"settlementDateConfirmed":false,"discountType":"","loanPersonRelationship":null,"transactionType":"Loan","notePadText":null,"partnerReference":"","nextGenId":null,"parentId":null,"workspaceUsers":"","tranxType":"","connectiveLodgeId":0,"peResidualAmount":0.0,"peRepaymentAmount":0.0,"peEffectiveRate":0.0,"peInterestRate":0.0,"peBrokerage":0.0,"assetDescription":null,"nextAction":null,"loanTerm":0,"metaData":null,"fixedRateExpiry":null,"depositDueDate":null,"vbo":false,"barCodeId":null,"agentName":" ","personActingName":"Cristina Jarina","personResponsibleName":" ","defaultPath":null,"partnerName":"Australian Credit and Finance","partnerSharedWithId":null,"partnerSharedWithName":null,"statusLastUpdated":1405417339000,"lenderComments":null,"sitRep":null,"campaignId":null,"campaignName":null,"securityValue":0.0,"aliApplicationId":"","interestOnlyExpiry":null}]}');
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
		if(!MercuryApiUtilities.checkRecord('Account', accountId)) {
			accountId = accountId.left(15);
			if(!MercuryApiUtilities.checkRecord('Account', accountId)) return;
		}

		String token = MercuryAuth.getInstance().getToken();
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		String url = 'https://api.connective.com.au/api/mercury5/' + token + '/person/' + accountId;
		req.setEndpoint(url);
		req.setMethod('GET');
		if (Test.isRunningTest()) {
			res.setBody('{"success":true,"people":{"uniqueId":"33e1600c-2d1b-4685-8cec-43b5acb397e6","company":"' + MercuryStaticValue.ACF_BRANCH_ID + '","isDeleted":false,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":"CA42767","isNew":null,"firstName":"","lastName":"","middleName":null,"salutation":null,"title":null,"occupation":"","employer":null,"jobTitle":null,"maritalStatus":null,"driversLicenceNumber":null,"driversLicenceExpiry":null,"driversLicenceState":null,"gender":null,"dateOfBirth":null,"employmentStatus":"","employmentCommenced":null,"phoneDisplayType1":"Home","phoneDisplayType2":"Mobile","phoneDisplayType3":"Business","phoneDisplayType4":"Business Fax","addressDisplay":"Home","homePhone":"","businessPhone":null,"mobile":"","email":"","personDataType":"Full","notes":null,"relationshipManager":null,"annualSalary":0.0,"contactType":null,"abn":null,"acn":null,"trustName":null,"homeSuburb":null,"numberOfDependents":0,"doNotMail":false,"funambolUsers":"CA45753","markAsPrivate":false,"importDocumentId":"","partnerName":"Australian Credit and Finance","emailBounced":false,"webPassword":"","webAccess":false,"contactMethods":[{"uniqueId":"2ca1b6fa-0c02-11e4-ad0e-00155d0a3619","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"personID":"33e1600c-2d1b-4685-8cec-43b5acb397e6","contactMethod":"Home","content":"","type":"phone"},{"uniqueId":"2ca26af4-0c02-11e4-ad0e-00155d0a3619","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"personID":"33e1600c-2d1b-4685-8cec-43b5acb397e6","contactMethod":"Mobile","content":"","type":"phone"},{"uniqueId":"2ca372c8-0c02-11e4-ad0e-00155d0a3619","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"personID":"33e1600c-2d1b-4685-8cec-43b5acb397e6","contactMethod":"Email 1","content":"","type":"email"}],"fullName":" ","salutationOrFirstName":""}}');
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

	public static void getAllPersonalBranches(String token) {
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		String url = 'https://api.connective.com.au/api/mercury5/' + token + '/partner';
		req.setEndpoint(url);
		req.setMethod('GET');
		if (Test.isRunningTest()) {
			res.setBody('{"success":true,"partnerList":[{"uniqueId":"09942540-da5d-47ba-b662-b0315c52ef5f","company":null,"isDeleted":null,"deletedBy":null,"deletedOn":null,"createdOn":null,"createdBy":null,"isNew":null,"parentId":"' + MercuryStaticValue.ACF_BRANCH_ID + '","name":"Adam Harling","businessEntityName":null,"postalAddressLine1":null,"postalAddressLine2":null,"postalCity":null,"postalState":null,"postalPostCode":null,"phone":null,"fax":null,"otherPhone":null,"abn":null,"userDefinedId":"AH","zendeskId":null,"bdm":null,"myMarketingPlanId":null,"oneTouch":null,"children":null,"linkedPartners":null,"vcCategories":null,"finconnect":false,"ybr":false}]}');
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

}