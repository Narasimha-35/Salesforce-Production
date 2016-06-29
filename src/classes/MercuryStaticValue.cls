public with sharing class MercuryStaticValue {
	public static final Integer CALLOUT_GET_TIMEOUT      = 120000;
	public static final Integer CALLOUT_POST_TIMEOUT     = 120000;

	public static final String API_USER_ID               = 'CA51708';
	public static final String ENCODING_SCHEME           = 'UTF-8';
	public static final String ACF_BRANCH_ID             = 'P200019';
	public static final String ACF_LEAD_SOURCE_ID        = '3f85d5db-5924-11e4-88e4-00155db85119';
	public static final String ACF_LEAD_SOURCE_DISPLAY   = 'ACF Client';
	public static final String DEFAULT_TRANSACTION_TYPE  = 'Loan';
	public static final Integer MERC_CLEAN_BATCH_SIZE    = 5;
	public static MercurySettings__c MERC_SETTINGS       = MercurySettings__c.getOrgDefaults();

	public static final Credential__c MERC_CREDENTIAL    = Credential__c.getAll().get('Mercury');
	public static final String USER_NAME                 = MERC_CREDENTIAL.Mercury_Username__c;
	public static final String PASSWORD                  = MERC_CREDENTIAL.Mercury_Password__c;
	public static final String LOGIN_END_POINT           = MERC_CREDENTIAL.Mercury_Login_End_Point__c;
	public static final String DOMAIN                    = MERC_CREDENTIAL.Mercury_Domain__c;
	public static final String APPLICATION               = MERC_CREDENTIAL.Mercury_Application__c;
	public static final String API_CHANNEL               = 'api';
	public static final String BASE_URL                  = DOMAIN + '/' + API_CHANNEL + '/' + APPLICATION + '/';
	public static final String TOKEN_PLACEHOLDER         = '{{token}}';
	public static final String RESOURCE_NAME_PLACEHOLDER = '{{resourceName}}';
	public static final String REQUEST_BASE_URL          = BASE_URL + TOKEN_PLACEHOLDER + '/' + RESOURCE_NAME_PLACEHOLDER;

	public static String DEBUG_EMAIL_TEMPLATE            = [select id, body from Document where name = 'DebugEmailTemplate' limit 1].get(0).body.toString(); //debugEmailTemplate

	//The object map between salesforce and mercury
	public static final Map<String, String> sfToMercuryObjectMap = new Map<String, String>{
		'account'     => 'person',
		'opportunity' => 'loan',
		'loanpeople'  => 'loanPeople'
	};
	//The item map between salesforce and mercury in response body {'success':'true', 'people':[....]}
	public static final Map<String, String> sfToMercuryItemMap = new Map<String, String>{
		'account'     => 'people',
		'opportunity' => 'loans',
		'loanpeople'  => 'loanPeople'
	};

	public static final Map<String, String> GENDER_MAP = new Map<String, String> {
		'M'      => 'Male',
		'Male'   => 'Male',
		'F'      => 'Female',
		'Female' => 'Female',
		''       => null
	};

	public static final Set<String> AVALIABLE_TITLE = new Set<String>{
		'Dr',
		'Miss',
		'Ms',
		'Mr',
		'Mrs',
		'Prof',
		'Rev'
	};

	public static final List<String> MERC_SYNC_TARGET_STATUS = new List<String>{
		'Signed',
		'Signed - Additional Docs Required',
		'Submit to Production',
		'Submitted - On Hold',
		'AIP',
		'Submit to Production WIP',
		'Submitted',
		'Submitted MIR',
		'Conditional Approval',
		'Unconditional Approval',
		'Pending Settlement',
		'Settled (not paid)',
		'Settled'
	};

	//key: SF value, value: Mercury value
	public static final Map<String, String> MERC_REPAYMENT_FREQUENCY_MAP = new Map<String, String> {
		'Monthly'     => 'monthly',
		'Weekly'      => 'weekly',
		'Fortnightly' => 'fortnightly',
		'Anually'     => 'annually'
	};

	public static MercuryModel.Params param1;
	static {
		param1 = new MercuryModel.Params();
		param1.transactionType = 'loan';
		param1.transactionTypeRaw = 'loan';
		param1.groupBy = 'Current Status';
		param1.dateTo = Utilities.getGMTTime((DateTime) Date.today()).getTime();
		param1.dateFrom = Utilities.getGMTTime(((DateTime) Date.today()).addDays(-1)).getTime();
		param1.dateSearchType = 'Target Status';
	}
	public static MercuryModel.Params param2;
	static {
		param2 = new MercuryModel.Params();
		param2.transactionType = 'loan';
		param2.transactionTypeRaw = 'loan';
		param2.groupBy = 'Current Status';
		param2.dateFrom = Utilities.getGMTTime(Utilities.getCurrentMonthStartTime()).getTime();
		param2.dateTo = Utilities.getGMTTime(Utilities.getCurrentMonthStartTime().addMonths(3)).getTime();
		param2.dateSearchType = 'Settlement';
		param2.targetStatus = 'All';
	}

	public static BrokerSelector bkrSelector = new BrokerSelector();
	public static Map<Id, Broker__c> brokerMap = new Map<Id, Broker__c>(bkrSelector.getAllActiveBroker());
}
