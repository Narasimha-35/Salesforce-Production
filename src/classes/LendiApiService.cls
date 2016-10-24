/*
* LendiApiService
* log info only for api call methods
*/
public class LendiApiService extends RestService {
	public static final String CLASS_NAME = LendiApiService.class.getName();
	public static final String ENCODING_SCHEME = 'UTF-8';

	public LendiApiService() {
		super(LendiApiStaticValue.LENDI_API_END_POINT, new Map<String, String> {
			'Content-Type'  => 'application/json',
			'Authorization' => LendiApiStaticValue.TOKEN
		});
	}

	public LendiModel.User getLendiUser(Account acc) {
		LendiModel.User user = new LendiModel.User(acc.lendi_user_uuid__pc, acc.firstName, acc.lastName);
		HttpRequest req = buildRequest('POST', '/' + LendiApiStaticValue.LOGIN_AS_RELATIVE_PATH, JSON.serialize(user));
		HttpRequestResponse httpReqRes = sendRequest(req);
		String data = LendiApiUtil.getData(httpReqRes, 'user');

		log(LoggingLevel.INFO, 'retrieved: ' + Service.DETAIL_PLACE_HOLDER + ' ...', new Map<String, String>{'data' => data}, CLASS_NAME);
		return (LendiModel.User) JSON.deserialize(data, LendiModel.User.class);
	}

	public String getAuthToken(String accId) {
		AccountSelector accSelector = new AccountSelector();
		Account acc = accSelector.getById(accId);
		LendiModel.User lendiUser = getLendiUser(acc);
		return lendiUser.token;
	}

	public LendiModel.ServiceCalculator getLendiServiceCalculator(Opportunitylineitem oppoProd, Double loanAmount, Double securityValue) {
		String filterParam = EncodingUtil.urlEncode(QSUtil.stringify('product_ids', (Object) new List<String>{oppoProd.product2Id}), ENCODING_SCHEME);
		String loanParam = EncodingUtil.urlEncode('loan_amount=' + loanAmount + '&security_value=' + securityValue, ENCODING_SCHEME);
		List<LendiModel.Product> lendiProducts = new List<LendiModel.Product>();
		LendiModel.Product lendiProd = new LendiModel.Product();
		lendiProd.is_interest_only = oppoProd.click_Type__c == 'Interest Only' ? true : false;
		lendiProd.final_rate = oppoProd.assessmentRate__c > oppoProd.acfRate__c + oppoProd.rateBuffer__c ? oppoProd.assessmentRate__c : oppoProd.acfRate__c + oppoProd.rateBuffer__c;
		lendiProd.interest_rate = oppoProd.acfRate__c;
		lendiProd.product_sf_id = oppoProd.product2Id;
		lendiProd.bank_sf_id = oppoProd.product2.click_Loans_Bank_Detail__c;
		lendiProducts.add(lendiProd);
		String productParam = EncodingUtil.urlEncode(QSUtil.stringify('products', lendiProducts), ENCODING_SCHEME);
		String urlParams = 'filter_data=' + filterParam;
		urlParams += '&application_id=' + oppoProd.opportunityId;
		urlParams += '&loan_data=' + loanParam;
		urlParams += '&product_data=' + productParam;

		HttpRequest req = buildRequest('GET', '/' + LendiApiStaticValue.PRODUCT_RESOURCE + '?' + urlParams);
		HttpRequestResponse httpReqRes = sendRequest(req);
		String data = LendiApiUtil.getData(httpReqRes, 'service_calculators');
		if(data.length() < 50) return null;
		return (LendiModel.ServiceCalculator) JSON.deserialize(data.subString(1, data.length() - 1), LendiModel.ServiceCalculator.class);
	}

}
