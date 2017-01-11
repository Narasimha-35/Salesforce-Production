global without sharing class MercuryUtility {
	public static final Map<String, String> M2SF_OPPORTUNITY_LOAN_MAP;
	// public static final Map<String, String> opportunityLoanMap;
	public static final String OPPORTUNITY_STAGE = 'Closed Won - Signed';
	public static final String LEAD_SOURCE = 'Mercury';
	public static final String ACCOUNT_EMAIL_FIELD_USED = 'PersonEmail';
	public static final String ACCOUNT_PHONE_FIELD_USED = 'personHomePhone';
	public static final String ACCOUNT_MOBILE_FIELD_USED = 'personMobilePhone';
	public static final String ACCOUNT_MERCURY_ID_USED = 'mercury_People_ID__c';
	public static final Map<String, String> loanOpportunityMap;
	static {
		M2SF_OPPORTUNITY_LOAN_MAP = new Map<String, String> {
			'merc_uniqueId__c'             => 'uniqueId',
			'merc_branch__c'               => 'company',
			'merc_transaction_name__c'     => 'loanName',
			'merc_loan_writer__c'          => 'agentName',
			'merc_admin__c'                => 'personActingName',
			'merc_supervisor__c'           => 'personResponsibleName',
			'merc_current_status__c'       => 'status',
			'merc_lead_source__c'          => 'leadSourceDisplay',
			'merc_campagin__c'             => 'campaignName',
			'merc_internal_reference__c'   => 'partnerReference',
			'merc_opportunity_type__c'     => 'tranxType',
			'merc_lender__c'               => 'lender',
			'merc_loan_amount__c'          => 'amount',
			'merc_existing_amount__c'      => 'existingAmount',
			'merc_security_value__c'       => 'securityValue',
			'merc_lmi__c'                  => 'lmi',
			'merc_status_notes__c'         => 'sitRep',
			'merc_transaction_type__c'     => 'tranxType',
			'merc_lender_reference__c'     => 'lenderReference',
			'merc_apply_online_id__c'      => 'nextGenId',
			'merc_finance_date__c'         => 'financeDate',
			'merc_deposit_due_date__c'     => 'depositDueDate',
			'merc_settlement_date__c'      => 'confirmedSettlementDate',
			'merc_fixed_rate_expiry__c'    => 'fixedRateExpiry',
			'merc_interest_only_expiry__c' => 'interestOnlyExpiry',
			'merc_categories__c'           => 'metaData'
		};

		loanOpportunityMap = new Map<String, String>();
		for(String k : M2SF_OPPORTUNITY_LOAN_MAP.keySet()) {
			loanOpportunityMap.put(M2SF_OPPORTUNITY_LOAN_MAP.get(k), k);
		}
	}

	public static String getPrimaryApplicantId(List<MercuryModel.LoanPeople> loanPeopleList) {
		for(MercuryModel.LoanPeople lp : loanPeopleList) if(lp.relationship == 'Primary Applicant') return lp.personID;
		return null;
	}

	public static MercuryModel.People getApplicantById(List<MercuryModel.People> peopleList, String primaryApplicantId) {
		for(MercuryModel.People p : peopleList) if(p.uniqueId.toLowerCase() == primaryApplicantId.toLowerCase()) return p;
		return null;
	}

	public static MercuryModel.People getAnyApplicantHaveValue(List<MercuryModel.People> peopleList, Set<String> fieldNameSet) {
		String temp;
		for(MercuryModel.People p : peopleList) {
			for(String field : fieldNameSet) {
				temp = (String) p.get(field);
				if(temp != null && temp != '') return p;
			}
		}
		return null;
	}

	public static List<MercuryModel.LoanPeople> getLoanPeopleFromMercuryOpportunity(Mercury_Opportunity__c mercOppo) {
		return (List<MercuryModel.LoanPeople>) JSON.deserialize(mercOppo.merc_loanPeople__c, List<MercuryModel.LoanPeople>.class);
	}

	public static List<MercuryModel.People> getPeopleFromMercuryOpportunity(Mercury_Opportunity__c mercOppo) {
		return (List<MercuryModel.People>) JSON.deserialize(mercOppo.merc_people__c, List<MercuryModel.People>.class);
	}

	public static MercuryModel.People getApplicant(Mercury_Opportunity__c mercOppo) {
		List<MercuryModel.LoanPeople> loanPeopleList = getLoanPeopleFromMercuryOpportunity(mercOppo);
		List<MercuryModel.People> peopleList = getPeopleFromMercuryOpportunity(mercOppo);
		String primaryApplicantId = getPrimaryApplicantId(loanPeopleList);

		MercuryModel.People ret = getApplicantById(peopleList, primaryApplicantId);
		if(ret == null || ((ret.email == null || ret.email == '') && (ret.mobile == null || ret.mobile == '') && (ret.homePhone == null || ret.homePhone == ''))) {
			ret = getAnyApplicantHaveValue(peopleList, new Set<String>{'email', 'mobile', 'homePhone'});
		}
		return ret;
	}

	public static Account getMostRecentAppointmentAccountWithouSynced(List<Account> scope) {
		Map<Id, Account> accMap = new Map<Id, Account>(scope);
		Set<Id> scopeIds = accMap.keySet();
		//even though use appointment date and time is not accurate, but this is sufficient.
		List<Opportunity> ol = [SELECT id, accountId FROM Opportunity WHERE accountId IN :scopeIds AND merc_current_status__c = null AND current_Appointment_Date_Time__c != null ORDER BY current_Appointment_Date_Time__c DESC];
		if(ol.size() == 0) return scope[0];
		return accMap.get(ol[0].accountId);
	}

	public static Boolean removeMercuryOpportunityAndCreateOpportunity(Account applicantAcc, Opportunity oppo, Mercury_Opportunity__c merc_oppo) {
		//TODO: should use unit of work
		SavePoint sp = Database.setSavepoint();
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility] Upserting Account: ' + applicantAcc);
		Database.UpsertResult accRes = Database.upsert(applicantAcc, Account.Fields.Id, false);
		oppo.accountId = applicantAcc.id;
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility] Upserting Opportunity: ' + oppo);
		Database.UpsertResult oppoRes = Database.upsert(oppo, Opportunity.Fields.Id, false);
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility] Deleting Mercury Opportunity: ' + merc_oppo);
		Database.DeleteResult delMercOppoRes = Database.delete(merc_oppo, false);

		if(!accRes.isSuccess() || !oppoRes.isSuccess() || !delMercOppoRes.isSuccess()) {
			//TODO: should throw exception
			System.debug(LoggingLevel.ERROR, '[MercuryUtility] Error Message' + accRes.getErrors());
			System.debug(LoggingLevel.ERROR, '[MercuryUtility] Error Message' + oppoRes.getErrors());
			System.debug(LoggingLevel.ERROR, '[MercuryUtility] Error Message' + delMercOppoRes.getErrors());
			Database.rollback(sp);
			return false;
		}
		return true;
	}

	public static String getStandardMobileFormat(String mobile) {
		if(mobile == null) return null;
		mobile = mobile.replace(' ', '');
		Pattern mobilePattern1 = Pattern.compile('04[0-9]{8}');
		Pattern mobilePattern2 = Pattern.compile('4[0-9]{8}');

		if(mobilePattern1.matcher(mobile).matches()) {
			return '+61' + mobile.subString(1);
		}

		if(mobilePattern2.matcher(mobile).matches()) {
			return '+61' + mobile;
		}

		return null;
	}

	public static Opportunity mergeWithLastNotSyncedOppo(Opportunity oppo, Account acc) {
		Opportunity op = [SELECT id, stageName, closeDate, leadSource FROM Opportunity WHERE accountId = :acc.id AND merc_current_status__c = null ORDER BY lastmodifieddate DESC LIMIT 1]; //not good for soql performance
		oppo.id = op.id;
		oppo.leadSource = op.leadSource;
		oppo.closeDate = op.closeDate;
		oppo.stageName = op.stageName;
		return oppo;
	}

	public static Account getApplicantAccount(MercuryModel.People applicant) {
		AccountSelector accSelector = new AccountSelector();
		Account applicantAcc = applicant.convertToAccount(true);

		applicantAcc.put(ACCOUNT_PHONE_FIELD_USED, getStandardMobileFormat((String) applicantAcc.get(ACCOUNT_PHONE_FIELD_USED)));
		applicantAcc.put(ACCOUNT_MOBILE_FIELD_USED, getStandardMobileFormat((String) applicantAcc.get(ACCOUNT_MOBILE_FIELD_USED)));

		List<Account> matchingAccs = accSelector.getSimilarAccountsByAccount(applicantAcc, new Set<String>{ACCOUNT_EMAIL_FIELD_USED, ACCOUNT_PHONE_FIELD_USED, ACCOUNT_MOBILE_FIELD_USED}, ACCOUNT_MERCURY_ID_USED);
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getApplicantAccount] matchingAccs is: ' + matchingAccs);

		if(matchingAccs == null) {
			System.debug(LoggingLevel.ERROR, '[MercuryUtility.getApplicantAccount] Empty matching condition.');
			return null;
		} else if(matchingAccs.size() == 0) {
			//no match create.
			System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getApplicantAccount] The applicant\'s Account from Direct Conversion: ' + applicantAcc);
		} else if(matchingAccs.size() == 1) {
			//Email match but not sure is match or not.
			applicantAcc = applicant.mergeToAccount(matchingAccs.get(0), true);
			System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getApplicantAccount] The applicant\'s Account from Merge Single Account: ' + applicantAcc);
		} else {
			//multiple Account Matches.
			applicantAcc = MercuryUtility.getMostRecentAppointmentAccountWithouSynced(matchingAccs);
			applicantAcc = applicant.mergeToAccount(applicantAcc, true);
			System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getApplicantAccount] The applicant\'s Account from Merge Multiple Account: ' + applicantAcc);
		}

		return applicantAcc;
	}

	public static Opportunity constructOpportunityFromMercuryOpp(Mercury_Opportunity__c merc_oppo) {
		Opportunity oppo = null;
		oppo = MercuryOpportunityService.castOpportunity(merc_oppo, true);
		oppo.name = oppo.merc_transaction_name__c;
		oppo.stageName = OPPORTUNITY_STAGE;
		oppo.closeDate = oppo.merc_settlement_date__c != null ? oppo.merc_settlement_date__c.date() : Date.today();
		oppo.leadSource = LEAD_SOURCE;
		oppo.mercury_Loan_Id__c = oppo.merc_uniqueId__c;
		return oppo;
	}

	public static Boolean checkRecordFromResMap(Map<String, Object> resMap, String sfObjectName, String rid) {
		if(resMap == null) return false;
		if(rid.length() == 18) return true;

		Object temp = resMap.get(MercuryStaticValue.sfToMercuryItemMap.get(sfObjectName.toLowerCase()));
		Map<String, Object> m = null;
		if(temp instanceOf Map<String, Object>) {
			m = (Map<String, Object>) temp;
		} else {
			List<Object> ml = (List<Object>) temp;
			m = (Map<String, Object>) ml[0];
		}

		System.Debug(LoggingLevel.DEBUG, '[MercuryUtility] result map: ' + m);
		System.Debug(LoggingLevel.DEBUG, '[MercuryUtility] uniqueId: ' + m.get('uniqueId'));
		System.Debug(LoggingLevel.DEBUG, '[MercuryUtility] rid: ' + rid);
		if(String.valueOf(m.get('uniqueId')).equals(rid)) return true;
		return false;
	}

	//Move to Utilities Class? @depricate
	public static String convertCurrentTimeToGMTWithTimeZone(Datetime birthday) {
		String gmtTimeValue = String.valueOfGmt(birthday);
		gmtTimeValue = gmtTimeValue.replace(' ', 'T') + '+10:00';
		System.debug(gmtTimeValue);
		return gmtTimeValue;
	}

	//Move to Utilities Class? @depricate
	public static String convertCurrentTimeToGMTWithTimeZone() {
		String gmtTimeValue = String.valueOfGmt(Datetime.now());
		gmtTimeValue = gmtTimeValue.replace(' ', 'T') + '+10:00';
		System.debug(gmtTimeValue);

	return gmtTimeValue;
	}

	public static String getBrokerBranch(String oppoId) {
		String acfBranch = getBrokerBranchRaw(oppoId);
		if(acfBranch == null || acfBranch == '') {
			return MercuryStaticValue.ACF_BRANCH_ID;
		}
		return acfBranch;
	}

	public static String getBrokerBranchRaw(String oppoId) {
		//default ACF Branch
		String acfBranch = MercuryStaticValue.ACF_BRANCH_ID;
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

	public static void sendEmail() {
		if(MercuryApiUtilities.emailSwh) {
			system.debug(LoggingLevel.INFO, 'Sending Email to subscribers...');
			for(Map<String, String> pe : MercuryApiUtilities.pendingEmails) {
				String body = generateHTMLEmailBody(MercuryStaticValue.APPLICATION, 'MercuryApiUtilities', pe.get('methodName'), pe.get('details'));
				Utilities.sendEmail(MercuryApiUtilities.recipients, 'Salesforce Debug', body);
			}
		}
	}

	public static String generateHTMLEmailBody(String projectName, String className, String methodName, String detail) {
		if(MercuryStaticValue.DEBUG_EMAIL_TEMPLATE == null) {
			Document doc = [select id, body from Document where name = 'DebugEmailTemplate' limit 1];
			MercuryStaticValue.DEBUG_EMAIL_TEMPLATE = doc.body.toString();
		}
		return MercuryStaticValue.DEBUG_EMAIL_TEMPLATE.replace('%%projectName%%', projectName).replace('%%className%%', className).replace('%%methodName%%', methodName).replace('%%details%%', detail);
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

	public static Boolean getApproveFromXml(Dom.Document doc) {
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

	public static String getEncodedChangeList(Model mod) {
		Set<String> notNullFields = mod.getNonNullAttributeSet();
		notNullFields.remove('webAccess');
		notNullFields.remove('uniqueId');
		return EncodingUtil.urlEncode(JSON.serialize(notNullFields), MercuryStaticValue.ENCODING_SCHEME);
	}

	public class MercuryMismatchException extends Exception {
	}
}