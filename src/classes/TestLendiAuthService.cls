@isTest
public with sharing class TestLendiAuthService {

	private static testMethod void testGetAuthToken() {
		LendiApiTestUtilities.setLendiApiCustomSetting();

		Account acc = new Account();
		LendiAuthService.getLendiUser(acc);
	}

}
