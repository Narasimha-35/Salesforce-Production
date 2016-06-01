public with sharing class HttpRequestResponse {
	public HttpRequest req;
	public HttpResponse res;

	public HttpRequestResponse(HttpRequest req, HttpResponse res) {
		this.req = req;
		this.res = res;
	}

	public class HttpException extends Exception {
		HttpRequestResponse httpRR;

		public HttpException(HttpRequestResponse httpRR) {
			this.httpRR = httpRR;
		}

		//Default method to send Email in Default recipants Email address
		public void sendExceptionEmail(String projectName, String className, String methodName) {
			ACFEmailList__c emaiSetting = ACFEmailList__c.getOrgDefaults();
			List<String> recipients     = ((String) emaiSetting.get('Mercury_Email_Receiver__c')).split(',');
			String body = MercuryUtility.generateHTMLEmailBody(projectName , className, methodName, MercuryUtility.generateDetailPart(httpRR.req, httpRR.res));
			Utilities.sendEmail(recipients, 'Salesforce Debug', body);
		}
	}

}
