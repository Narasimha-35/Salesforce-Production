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
}
