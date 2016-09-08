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
	public static final String LOGIN_AS_RESOURCE_NAME = 'login-as'; //TODO: refactor need from api service.
	public static final String LOGIN_AS_RELATIVE_PATH = AUTH_RESOURCE + '/' + LOGIN_AS_RESOURCE_NAME;

	/**
	* DOC Servives
	*/
	public static final String DOC_RESOURCE           = Lendi__c.getOrgDefaults().apiDocs__c;
	public static final String DOC_SERVICE_ENDPOINT   = LENDI_API_END_POINT + '/' + DOC_RESOURCE; //TODO: refactor doc service
	public static final String MULTIPART_BOUNDARY     = '----S3ServiceMULTIPART_BOUNDARY' + Utilities.generateRandomString(10);
	public static final Integer TIME_OUT_MILLISEC     = 80000;
	public static final String PDF_MINE_TYPE          = 'application/pdf';
	public static final String TEXT_MINE_TYPE         = 'text/plain';

	/**
	* Product Service
	*/
	public static final String PRODUCT_RESOURCE       = Lendi__c.getOrgDefaults().apiProduct__c;

}
