public with sharing class MercuryStaticValue {
	public static final String API_USER_ID = 'CA51708';
	public static final String ENCODING_SCHEME = 'UTF-8';
	public static final String ACF_BRANCH_ID = 'P200019';
	public static final String ACF_LEAD_SOURCE_ID = '3f85d5db-5924-11e4-88e4-00155db85119';
	public static final String DEFAULT_TRANSACTION_TYPE = 'Loan';
	public static final Integer MERC_CLEAN_BATCH_SIZE = 5;

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
}
