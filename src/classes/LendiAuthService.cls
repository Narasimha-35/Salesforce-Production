global with sharing class LendiAuthService {
	public static LendiApiService lendiService = new LendiApiService();
	public static final String LOGIN_AS_RESOURCE_NAME = 'login-as';
	public static final String LOGIN_AS_END_POINT = LendiApiStaticValue.AUTH_SERVICE_ENDPOINT + '/' + LOGIN_AS_RESOURCE_NAME;

	public static LendiModel.User getLendiUser(Account acc) {
		LendiModel.User user = new LendiModel.User(acc.lendi_user_uuid__pc, acc.firstName, acc.lastName);
		HttpRequest req = lendiService.buildBasicRequest(LOGIN_AS_END_POINT, 'POST', LendiApiStaticValue.TOKEN);
		req.setHeader('Content-Type', 'application/json');
		req.setBody(JSON.serialize(user));
		HttpRequestResponse httpReqRes = lendiService.sendRequest(req);
		String data = lendiService.getData(httpReqRes);
		System.debug(data);
		return (LendiModel.User) JSON.deserialize(data, LendiModel.User.class);
	}

	webservice static String getAuthToken(String accId) {
		AccountSelector accSelector = new AccountSelector();
		Account acc = accSelector.getById(accId);
		System.debug(LoggingLevel.INFO, '[LendiAuthService] getting the token for account: ' + acc.id + ' uuid: ' + acc.lendi_user_uuid__pc);
		LendiModel.User lendiUser = getLendiUser(acc);
		System.debug(LoggingLevel.INFO, '[LendiAuthService] successfully retrieved lendi user:' + lendiUser);
		return lendiUser.token;
	}

}
