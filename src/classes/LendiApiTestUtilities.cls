@isTest
public with sharing class LendiApiTestUtilities {

	public static testMethod void setLendiApiCustomSetting() {
		Lendi__c settings = new Lendi__c(
			apiHostName__c = 'http://lendi-api-dev.herokuapp.com',
			apiEntrence__c = 'api',
			apiVersion__c = 'v1',
			apiToken1__c = 'to',
			apiToken2__c = 'ken',
			apiAuth__c = 'auth',
			apiDocs__c = 'docs'
		);
		insert settings;
	}

}
