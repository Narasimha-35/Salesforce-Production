/*
* LendiApiService
* log info only for api call methods
*/
public class LendiApiService extends RestService {
	public static final String CLASS_NAME = LendiApiService.class.getName();

	public LendiApiService() {
		super(LendiApiStaticValue.LENDI_API_END_POINT, new Map<String, String> {
			'Content-Type'  => 'application/json',
			'Authorization' => LendiApiStaticValue.TOKEN
		});
	}

	public LendiModel.User getLendiUser(Account acc) {
		logInfo('getting the token for ' + Service.DETAIL_PLACE_HOLDER + ' ...', new Map<String, String>{'account id' => acc.id, 'uuid' => acc.lendi_user_uuid__pc}, CLASS_NAME);

		LendiModel.User user = new LendiModel.User(acc.lendi_user_uuid__pc, acc.firstName, acc.lastName);
		HttpRequest req = buildRequest('POST', '/' + LendiApiStaticValue.LOGIN_AS_RESOURCE_NAME, JSON.serialize(user));
		HttpRequestResponse httpReqRes = sendRequest(req);
		String data = LendiApiUtil.getData(httpReqRes);

		logInfo('retrieved: ' + Service.DETAIL_PLACE_HOLDER + ' ...', new Map<String, String>{'data' => data}, CLASS_NAME);

		return (LendiModel.User) JSON.deserialize(data, LendiModel.User.class);
	}

	public String getAuthToken(String accId) {
		AccountSelector accSelector = new AccountSelector();
		Account acc = accSelector.getById(accId);
		LendiModel.User lendiUser = getLendiUser(acc);
		return lendiUser.token;
	}

}
