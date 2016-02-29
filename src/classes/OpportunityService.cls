global with sharing class OpportunityService {
	public static final Map<String, Schema.DisplayType> fieldTypeMap;
	static {
		fieldTypeMap = new Map<String, Schema.DisplayType>();
		Map<String, Schema.SObjectField> m = Schema.SObjectType.Opportunity.fields.getMap();
		for(String s : m.keySet()) {
			fieldTypeMap.put(s, m.get(s).getDescribe().getType());
		}
		System.debug(LoggingLevel.INFO, '[OpportunityService] fieldTypeMap: ' + fieldTypeMap);
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

	webservice static void syncOppoToMercury(Id oppoId) {
		OpportunitySelector os = new OpportunitySelector();
		Opportunity o = os.getById(oppoId);

		system.debug(LoggingLevel.INFO, o);
		insert AsyncRequestService.createSyncToRequst(o.AccountId, o.id);
	}

	public static Opportunity castLoan(MercuryModel.Loan loan) {
		Opportunity ret = new Opportunity();
		Id rid = null;
		Object vo = null;
		String fieldName = null;

		for(String f : syncList) {
			if(!MercuryModel.loanOpportunityMap.containsKey(f)) continue;
			fieldName = MercuryModel.loanOpportunityMap.get(f);
			vo = Utilities.parseValue(fieldTypeMap, fieldName, loan.get(f));
			System.debug(LoggingLevel.INFO, '[OpportunityService] field:' + fieldName + ' field Type: ' + fieldTypeMap.get(fieldName));

			if(f == 'uniqueId') {
				rid = Utilities.castId(((String) vo));
				if(rid != null) ret.id = rid;
			}
			ret.put(fieldName, vo);
		}
		return ret;
	}

	public static Mercury_Opportunity__c castMercuryOpportunity(Opportunity o) {
		Mercury_Opportunity__c ret = new Mercury_Opportunity__c();
		for(String f : syncList) {
			ret.put(MercuryModel.loanOpportunityMap.get(f), o.get(MercuryModel.loanOpportunityMap.get(f)));
		}
		return ret;
	}

}
