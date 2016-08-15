public with sharing class LendiApiStaticValue {

	public static final String HOST_NAME = Lendi__c.getOrgDefaults().apiHostName__c;
	public static final String ENTRENCE = Lendi__c.getOrgDefaults().apiEntrence__c;
	public static final String API_VERSION = Lendi__c.getOrgDefaults().apiVersion__c;
	public static final String TOKEN = 'Bearer ' + Lendi__c.getOrgDefaults().apiToken1__c + Lendi__c.getOrgDefaults().apiToken2__c;
	public static final String AUTH_RESOURCE = Lendi__c.getOrgDefaults().apiAuth__c;

	public static final String AUTH_SERVICE_ENDPOINT = HOST_NAME + '/' + ENTRENCE + '/' + API_VERSION + '/' + AUTH_RESOURCE;

}
