public with sharing class S3StaticValue {
	public static final String S3_SERVICE_DOMAIN   = S3DocumentSetting__c.getOrgDefaults().domain__c;
	public static final String TOKEN               = S3DocumentSetting__c.getOrgDefaults().token__c;
	public static final String API_VERSION         = S3DocumentSetting__c.getOrgDefaults().apiVersion__c;
	public static final String ENTRENCE            = S3DocumentSetting__c.getOrgDefaults().entrence__c;
	public static final String RESOURCE            = S3DocumentSetting__c.getOrgDefaults().resources__c;
	public static final String S3_SERVICE_ENDPOINT = S3_SERVICE_DOMAIN + '/' + ENTRENCE + '/' + API_VERSION + '/' + RESOURCE;

	public static final String MULTIPART_BOUNDARY  = '----S3ServiceMULTIPART_BOUNDARY' + Utilities.generateRandomString(10);
	public static final Integer TIME_OUT_MILLISEC  = 80000;
	public static final String PDF_MINE_TYPE       = 'application/pdf';
	public static final String TEXT_MINE_TYPE      = 'text/plain';
}