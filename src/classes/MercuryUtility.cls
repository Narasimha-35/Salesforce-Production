global without sharing class MercuryUtility {
	public static final Map<String, String> M2SF_OPPORTUNITY_LOAN_MAP;
	// public static final Map<String, String> opportunityLoanMap;
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

	public static List<MercuryModel.LoanPeople> getLoanPeople(Mercury_Opportunity__c mercOppo) {
		return (List<MercuryModel.LoanPeople>) JSON.deserialize(mercOppo.merc_loanPeople__c, List<MercuryModel.LoanPeople>.class);
	}

	public static List<MercuryModel.People> getPeople(Mercury_Opportunity__c mercOppo) {
		return (List<MercuryModel.People>) JSON.deserialize(mercOppo.merc_people__c, List<MercuryModel.People>.class);
	}

	public static MercuryModel.People getApplicantWithValidEmailFromLoan(Mercury_Opportunity__c mercOppo) {
		List<MercuryModel.LoanPeople> loanPeopleList = getLoanPeople(mercOppo);
		List<MercuryModel.People> peopleList = getPeople(mercOppo);
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
		List<Opportunity> ol = [SELECT id, accountId FROM Opportunity WHERE accountId IN :scopeIds AND merc_current_status__c = null AND current_Appointment_Date_Time__c != null ORDER BY current_Appointment_Date_TIme__c DESC];
		if(ol.size() == 0) return scope[0];
		return accMap.get(ol[0].accountId);
	}


	webservice static void cleanMercuryOpportunity(String input) {
		MercuryOpportunityCleanUpBatch b = new MercuryOpportunityCleanUpBatch();
		Database.executeBatch(b, 5);
	}

	public class MercuryMismatchException extends Exception {
	}
}
