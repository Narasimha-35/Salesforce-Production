public with sharing class MercuryOpportunityService {
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
		Mercury_Opportunity__c ret = getRelatedMercuryOpportunity(loan);
		Id rid = null;
		Object tempObj = null;
		String fieldName = null;

		for(String field : syncList) {
			if(!MercuryModel.loanOpportunityMap.containsKey(field)) continue;
			fieldName = MercuryModel.loanOpportunityMap.get(field);
			tempObj = Utilities.parseValue(fieldTypeMap, fieldName, loan.get(field));
			System.debug(LoggingLevel.INFO, '[MercuryOpportunityService.castMercuryOpportunity] field:' + fieldName + ' field Type: ' + fieldTypeMap.get(fieldName));
			ret.put(fieldName, tempObj);
		}

		if(ret.merc_first_sync_time__c == null) ret.merc_first_sync_time__c = Datetime.now();
		ret.merc_last_sync_time__c = Datetime.now();
		return ret;
	}

	public static Opportunity getRelatedOpportunity(Mercury_Opportunity__c merc_oppo) {
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
		Opportunity ret = getRelatedOpportunity(merc_oppo);
		for(String field : syncList) {
			ret.put(MercuryModel.loanOpportunityMap.get(field), merc_oppo.get(MercuryModel.loanOpportunityMap.get(field)));
		}
		ret.merc_first_sync_time__c = merc_oppo.merc_first_sync_time__c;
		ret.merc_last_sync_time__c = merc_oppo.merc_last_sync_time__c;
		return ret;
	}

}
