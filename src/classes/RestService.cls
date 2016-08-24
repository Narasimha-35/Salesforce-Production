public virtual class RestService extends Service {
	public static final String CLASS_NAME = RestService.class.getName();
	private Http http = new Http();
	private String serviceEndPoint;
	private Map<String, String> defaultHeaderParams;

	public RestService(String endPoint) {
		this.serviceEndPoint = endPoint;
	}

	public RestService(String endPoint, Map<String, String> headerParams) {
		this.serviceEndPoint = endPoint;
		this.defaultHeaderParams = headerParams;
	}

	/**
	* for authenticate service.
	*/
	public HttpRequest buildRequest(String method, String urlParams) {
		return buildRequest(method, urlParams, null, null, null);
	}

	/**
	* for authenticate service.
	*/
	public HttpRequest buildRequest(String method, String urlParams, String body) {
		return buildRequest(method, urlParams, null, null, body);
	}

	/**
	* for authenticate service.
	*/
	public HttpRequest buildRequest(String method, String urlParams, Map<String, String> headerParams, Map<String, String> queryParams, String body) {
		HttpRequest req = new HttpRequest();

		String qParams = '';
		if(queryParams != null) {
			for(String key : queryParams.keySet()) qParams += key + '=' + queryParams.get(key) + '&';
		}
		String url = serviceEndPoint + urlParams + '?' + qParams;
		url = url.left(url.length() - 1);
		if(defaultHeaderParams != null) {
			for(String key : defaultHeaderParams.keySet()) req.setHeader(key, defaultHeaderParams.get(key));
		}
		if(headerParams != null) {
			for(String key : headerParams.keySet()) req.setHeader(key, headerParams.get(key));
		}
		req.setEndPoint(url);
		req.setMethod(method);
		req.setBody(body);

		return req;
	}

	/**
	* send rest request
	*/
	public HttpRequestResponse sendRequest(HttpRequest req) {
		log(LoggingLevel.DEBUG, 'Sending Request: ' + req.getEndPoint(), CLASS_NAME);
		HttpResponse res = http.send(req);
		return new HttpRequestResponse(req, res);
	}

	// public static String paramStringify(Object o) {
	// 	String jsonString = JSON.serialize(o);
	//
	// }

}
