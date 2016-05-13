global with sharing class MercuryOpportunityService {
	public static final Map<String, Schema.DisplayType> fieldTypeMap;
	static {
		fieldTypeMap = new Map<String, Schema.DisplayType>();
		Map<String, Schema.SObjectField> m = Schema.SObjectType.Mercury_Opportunity__c.fields.getMap();
		for(String s : m.keySet()) {
			fieldTypeMap.put(s, m.get(s).getDescribe().getType());
		}
		System.debug(LoggingLevel.INFO, '[MercuryOpportunityService] fieldTypeMap: ' + fieldTypeMap);
	}

	public static final List<String> syncList = new List<String>{
		'uniqueId',
		'company',
		'loanName',
		'agentName',
		'personActingName',
		'personResponsibleName',
		'status',
		'leadSourceDisplay',
		'campaignName',
		'partnerReference',
		'tranxType',
		'lender',
		'amount',
		'existingAmount',
		'securityValue',
		'lmi',
		'sitRep',
		'tranxType',
		'lenderReference',
		'nextGenId',
		'financeDate',
		'depositDueDate',
		'confirmedSettlementDate',
		'fixedRateExpiry',
		'interestOnlyExpiry',
		'metaData'
	};

	public static Mercury_Opportunity__c getRelatedMercuryOpportunity(MercuryModel.Loan loan) {
		MercuryOpportunitySelector selector = new MercuryOpportunitySelector();
		Mercury_Opportunity__c ret = null;
		try{
			ret = selector.getByMercuryUniqueId(loan.uniqueId);
		} catch (Exception e){
		}

		if(ret == null) return new Mercury_Opportunity__c();
		return ret;
	}

	public static Mercury_Opportunity__c castMercuryOpportunity(MercuryModel.Loan loan) {
		//TODO: not good design
		Mercury_Opportunity__c ret = getRelatedMercuryOpportunity(loan);
		Id rid = null;
		Object tempObj = null;
		String fieldName = null;

		for(String field : syncList) {
			if(!MercuryUtility.loanOpportunityMap.containsKey(field)) continue;
			fieldName = MercuryUtility.loanOpportunityMap.get(field);
			tempObj = Utilities.parseValue(fieldTypeMap, fieldName, loan.get(field));
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityService.castMercuryOpportunity] field:' + fieldName + ' field Type: ' + fieldTypeMap.get(fieldName));
			ret.put(fieldName, tempObj);
		}

		if(ret.merc_first_sync_time__c == null) ret.merc_first_sync_time__c = Datetime.now();
		ret.merc_last_sync_time__c = Datetime.now();
		return ret;
	}

	public static Opportunity getRelatedOpportunity(Mercury_Opportunity__c merc_oppo) {
		//TODO: not good design
		OpportunitySelector os = new OpportunitySelector();
		Opportunity ret = null;
		try {
			ret = os.getById(merc_oppo.merc_uniqueId__c);
		} catch(Exception e) {
		}

		if(ret == null) {
			try {
				ret = os.getByMercuryId(merc_oppo.merc_uniqueId__c);
			} catch (Exception e1) {
			}
		}
		if(ret == null) ret = new Opportunity();
		return ret;
	}

	public static Opportunity castOpportunity(Mercury_Opportunity__c merc_oppo) {
		return castOpportunity(merc_oppo, false);
	}

	public static Opportunity castOpportunity(Mercury_Opportunity__c merc_oppo, Boolean isNew) {
		Opportunity ret = isNew ? new Opportunity() : getRelatedOpportunity(merc_oppo);
		for(String field : syncList) {
			ret.put(MercuryUtility.loanOpportunityMap.get(field), merc_oppo.get(MercuryUtility.loanOpportunityMap.get(field)));
		}
		ret.merc_first_sync_time__c = merc_oppo.merc_first_sync_time__c;
		ret.merc_last_sync_time__c = merc_oppo.merc_last_sync_time__c;
		return ret;
	}

	public static Boolean cleanMercuryOpportunity(Mercury_Opportunity__c merc_oppo) {
		MercuryModel.People applicant = null;
		Opportunity oppo = null;
		Account applicantAcc = null;

		if(merc_oppo.merc_people__c == null || merc_oppo.merc_loanPeople__c == null) return false;
		System.debug(LoggingLevel.INFO, '[MercuryOpportunityService] Start cleaning on: ' + merc_oppo);
		applicant = MercuryUtility.getApplicant(merc_oppo);
		System.debug(LoggingLevel.DEBUG, '[MercuryOpportunityService] The applicant is: ' + applicant);
		if(applicant == null) {
			System.debug(LoggingLevel.ERROR, '[MercuryOpportunityService] There is no valid Email address in all contacts.');
			return false;
		}
		System.debug(LoggingLevel.INFO, '[MercuryOpportunityService] Complete Cast People');

		System.debug(LoggingLevel.INFO, '[MercuryOpportunityService] Start Cast Loan');
		oppo = MercuryUtility.constructOpportunityFromMercuryOpp(merc_oppo);
		System.debug(LoggingLevel.INFO, '[MercuryOpportunityService] Complete Cast Loan: ' + oppo);

		applicantAcc = MercuryUtility.getApplicantAccount(applicant);
		System.debug(LoggingLevel.INFO, '[MercuryOpportunityService] The applicant Account is: ' + applicantAcc);
		if(applicantAcc == null) return false;

		if(MercuryUtility.removeMercuryOpportunityAndCreateOpportunity(applicantAcc, oppo, merc_oppo)) return true;
		return false;
	}

}
