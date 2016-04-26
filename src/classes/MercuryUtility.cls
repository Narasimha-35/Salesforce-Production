global without sharing class MercuryUtility {
	public static final Map<String, String> M2SF_OPPORTUNITY_LOAN_MAP;
	// public static final Map<String, String> opportunityLoanMap;
	public static final String OPPORTUNITY_STAGE = 'Closed Won - Signed';
	public static final String LEAD_SOURCE = 'Mercury';
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

	public class HttpSet {
		public HttpRequest req;
		public HttpResponse res;

		public HttpSet(HttpRequest req, HttpResponse res) {
			this.req = req;
			this.res = res;
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

	public static MercuryModel.People getAnyApplicantHaveEmail(List<MercuryModel.People> peopleList) {
		for(MercuryModel.People p : peopleList) if(p.email != null && p.email != '') return p;
		return null;
	}

	public static List<MercuryModel.LoanPeople> getLoanPeopleFromMercuryOpportunity(Mercury_Opportunity__c mercOppo) {
		return (List<MercuryModel.LoanPeople>) JSON.deserialize(mercOppo.merc_loanPeople__c, List<MercuryModel.LoanPeople>.class);
	}

	public static List<MercuryModel.People> getPeopleFromMercuryOpportunity(Mercury_Opportunity__c mercOppo) {
		return (List<MercuryModel.People>) JSON.deserialize(mercOppo.merc_people__c, List<MercuryModel.People>.class);
	}

	public static MercuryModel.People getApplicantWithValidEmailFromLoan(Mercury_Opportunity__c mercOppo) {
		List<MercuryModel.LoanPeople> loanPeopleList = getLoanPeopleFromMercuryOpportunity(mercOppo);
		List<MercuryModel.People> peopleList = getPeopleFromMercuryOpportunity(mercOppo);
		String primaryApplicantId = getPrimaryApplicantId(loanPeopleList);

		MercuryModel.People ret = getApplicantById(peopleList, primaryApplicantId);
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Primary Applicant' + ret);
		if(ret == null || ret.email == null || ret.email == '') ret = getAnyApplicantHaveEmail(peopleList);
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Applicant with valid Email Address' + ret);
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


	webservice static void cleanMercuryOpportunity(String input) {
		MercuryOpportunityCleanUpBatch b = new MercuryOpportunityCleanUpBatch();
		Database.executeBatch(b, 5);
	}

	public static Boolean removeMercuryOpportunityAndCreateOpportunity(Account applicantAcc, Opportunity oppo, Mercury_Opportunity__c merc_oppo) {
		//TODO: should use unit of work
		SavePoint sp = Database.setSavepoint();
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility] Upserting Account: ' + applicantAcc);
		Database.UpsertResult accRes = Database.upsert(applicantAcc, Account.Fields.Id, false);
		oppo.accountId = applicantAcc.id;
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility] Upserting Opportunity: ' + oppo);
		Database.SaveResult oppoRes = Database.insert(oppo, false);
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

	public static Account getApplicantAccount(MercuryModel.People applicant) {
		AccountSelector accSelector = new AccountSelector();
		Account applicantAcc = null;
		List<Account> matchingAccs = accSelector.getByMercuryPeople(applicant);
		System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getApplicantAccount] matchingAccs is: ' + matchingAccs);

		if(matchingAccs == null) {
			System.debug(LoggingLevel.ERROR, '[MercuryUtility.getApplicantAccount] Empty matching condition.');
			return null;
		} else if(matchingAccs.size() == 0) {
			//no match create.
			applicantAcc = applicant.convertToAccount(true);
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

	public class MercuryMismatchException extends Exception {
	}
}
