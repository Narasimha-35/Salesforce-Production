/*
	@name: LendiApiStaticValue
*/
public with sharing class LendiApiStaticValue {
	/**
	* Org level defaults
	*/
	public static final String HOST_NAME              = Lendi__c.getOrgDefaults().apiHostName__c;
	public static final String ENTRENCE               = Lendi__c.getOrgDefaults().apiEntrence__c;
	public static final String API_VERSION            = Lendi__c.getOrgDefaults().apiVersion__c;
	public static final String TOKEN                  = 'Bearer ' + Lendi__c.getOrgDefaults().apiToken1__c + Lendi__c.getOrgDefaults().apiToken2__c;
	public static final String LENDI_API_END_POINT    = HOST_NAME + '/' + ENTRENCE + '/' + API_VERSION;

	/**
	* Auth Service
	*/
	public static final String AUTH_RESOURCE          = Lendi__c.getOrgDefaults().apiAuth__c;
	public static final String AUTH_SERVICE_ENDPOINT  = LENDI_API_END_POINT + '/' + AUTH_RESOURCE;
	public static final String LOGIN_AS_RESOURCE_NAME = 'login-as';
	public static final String LOGIN_AS_END_POINT     = AUTH_SERVICE_ENDPOINT + '/' + LOGIN_AS_RESOURCE_NAME;

	/**
	* DOC Servives
	*/
	public static final String DOC_RESOURCE           = Lendi__c.getOrgDefaults().apiDocs__c;
	public static final String DOC_SERVICE_ENDPOINT   = LENDI_API_END_POINT + '/' + DOC_RESOURCE;
	public static final String MULTIPART_BOUNDARY     = '----S3ServiceMULTIPART_BOUNDARY' + Utilities.generateRandomString(10);
	public static final Integer TIME_OUT_MILLISEC     = 80000;
	public static final String PDF_MINE_TYPE          = 'application/pdf';
	public static final String TEXT_MINE_TYPE         = 'text/plain';
}
