public class LendiApiService {
	public Http http = new Http();

	public HttpRequest buildBasicRequest(String endPoint, String method, String jwtToken) {
		HttpRequest req = new HttpRequest();
		req.setHeader('Authorization', jwtToken);
		req.setEndPoint(endPoint);
		req.setMethod(method);
		return req;
	}

	public HttpRequestResponse sendRequest(HttpRequest req) {
		return new HttpRequestResponse(req, http.send(req));
	}

	public String getData(HttpRequestResponse result) {
		Map<String, Object> lendiRes = (Map<String, Object>) JSON.deserializeUntyped(result.res.getBody());
		Map<String, Object> dataMap = (Map<String, Object>) lendiRes.get('data');
		String objectName = (new List<String>(dataMap.keySet()))[0];
		String ret = JSON.serialize(dataMap.get(objectName));
		return ret;
	}
}
