@isTest
public with sharing class TestSFModel {

	private static testMethod void testDugEmailRequest() {
		SFModel.DebugEmailRequest der = new SFModel.DebugEmailRequest();
		der.projectName = null;
		der.className = null;
		der.methodName = null;
		der.detail = null;
	}

}
