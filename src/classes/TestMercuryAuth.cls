@isTest(SeeAllData=true)
private class TestMercuryAuth {

	@isTest static void testMercuryAuth() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

		mock.setStaticResource('MercuryLoginSuccessResponse');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		String token = MercuryAuth.getInstance(true).getToken();
		System.assertEquals('aaf498ce-fc28-4e0c-a2c3-63cfd7d6ff18', token);
		Test.stopTest();
	}

}
