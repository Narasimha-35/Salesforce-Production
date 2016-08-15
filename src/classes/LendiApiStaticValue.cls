/*
	@name: LendiApiStaticValue
*/
public with sharing class LendiApiStaticValue {
	/**
	* Org level defaults
	*/
	public static final String HOST_NAME             = Lendi__c.getOrgDefaults().apiHostName__c;
	public static final String ENTRENCE              = Lendi__c.getOrgDefaults().apiEntrence__c;
	public static final String API_VERSION           = Lendi__c.getOrgDefaults().apiVersion__c;
	public static final String TOKEN                 = 'Bearer ' + Lendi__c.getOrgDefaults().apiToken1__c + Lendi__c.getOrgDefaults().apiToken2__c;

	/**
	* Auth Service
	*/
	public static final String AUTH_RESOURCE         = Lendi__c.getOrgDefaults().apiAuth__c;
	public static final String AUTH_SERVICE_ENDPOINT = HOST_NAME + '/' + ENTRENCE + '/' + API_VERSION + '/' + AUTH_RESOURCE;

	/**
	* DOC Servives
	*/
	public static final String DOC_RESOURCE          = Lendi__c.getOrgDefaults().apiDocs__c;
	public static final String DOC_SERVICE_ENDPOINT  = HOST_NAME + '/' + ENTRENCE + '/' + API_VERSION + '/' + DOC_RESOURCE;
	public static final String MULTIPART_BOUNDARY    = '----S3ServiceMULTIPART_BOUNDARY' + Utilities.generateRandomString(10);
	public static final Integer TIME_OUT_MILLISEC    = 80000;
	public static final String PDF_MINE_TYPE         = 'application/pdf';
	public static final String TEXT_MINE_TYPE        = 'text/plain';
}
