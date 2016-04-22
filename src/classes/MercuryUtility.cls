public without sharing class MercuryUtility {
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

	public static MercuryModel.People getApplicantWithValidEmailFromLoan(Mercury_Opportunity__c mercOppo) {
		List<MercuryModel.LoanPeople> loanPeopleList = (List<MercuryModel.LoanPeople>) JSON.deserialize(mercOppo.merc_loanPeople__c, List<MercuryModel.LoanPeople>.class);
		List<MercuryModel.People> peopleList = (List<MercuryModel.People>) JSON.deserialize(mercOppo.merc_people__c, List<MercuryModel.People>.class);
		String primaryApplicantId = null;

		for(MercuryModel.LoanPeople lp : loanPeopleList) {
			System.debug(LoggingLevel.FINEST, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Working on LoanPeople: ' + lp.uniqueId);
			if(lp.relationship == 'Primary Applicant') {
				System.debug(LoggingLevel.FINEST, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Found primary applicant uniqueId: ' + lp.personID);
				primaryApplicantId = lp.personID;
			}
		}
		for(MercuryModel.People p : peopleList) {
			System.debug(LoggingLevel.FINEST, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Working on People: ' + p.uniqueId);
			if(p.uniqueId.toLowerCase() == primaryApplicantId.toLowerCase()) {
				System.debug(LoggingLevel.FINEST, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Found primary applicant: ' + p);
				return p;
			}
		}

		for(MercuryModel.People p : peopleList) {
			System.debug(LoggingLevel.FINEST, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Working on People: ' + p.uniqueId);
			if(p.email != null) {
				System.debug(LoggingLevel.FINEST, '[MercuryUtility.getApplicantWithValidEmailFromLoan] Found valid applicant: ' + p);
				return p;
			}
		}

		return null;
	}

	public static String getEmailOfPrimaryApplicantFromMercuryOpportunity(Mercury_Opportunity__c mercOppo) {
		return getEmailListFromMercuryOpportunity(mercOppo)[0];
	}

	public static List<String> getEmailListFromMercuryOpportunity(Mercury_Opportunity__c mercOppo) {
		List<String> ret = new List<String>();
		List<String> temp = new List<String>();
		List<MercuryModel.LoanPeople> loanPeopleList = (List<MercuryModel.LoanPeople>) JSON.deserialize(mercOppo.merc_loanPeople__c, List<MercuryModel.LoanPeople>.class);
		for(MercuryModel.LoanPeople lp : loanPeopleList) {
			System.debug(LoggingLevel.DEBUG, '[MercuryUtility.getEmailListFromMercuryOpportunity] Processing Loan People: ' + lp);
			if(lp.relationship == 'Primary Applicant') {
				ret.add(lp.email);
			} else {
				temp.add(lp.email);
			}
		}
		ret.addAll(temp);
		return ret;
	}

	public static Account getMostRecentAppointmentAccountWithouSynced(List<Account> scope) {
		Map<Id, Account> accMap = new Map<Id, Account>(scope);
		Set<Id> scopeIds = accMap.keySet();
		List<Opportunity> ol = [SELECT id, accountId FROM Opportunity WHERE accountId IN :scopeIds AND merc_current_status__c = null AND current_Appointment_Date_Time__c != null ORDER BY current_Appointment_Date_TIme__c DESC];
		if(ol.size() == 0) return scope[0];
		return accMap.get(ol[0].accountId);
	}

	public class MercuryMismatchException extends Exception {
	}
}
