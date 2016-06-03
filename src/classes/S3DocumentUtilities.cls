public with sharing class S3DocumentUtilities {

	public static HttpRequest buildBasicRequest(String endPoint, String method) {
		HttpRequest req = new HttpRequest();
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Authorization', 'Bearer ' + S3DocumentService.TOKEN);
		req.setEndPoint(endPoint);
		req.setMethod(method);
		return req;
	}

	public static HttpRequestResponse insertS3Document(Blob content) {
		Http http = new Http();
		HttpRequest req = buildBasicRequest(S3DocumentService.SERVICE_DOMAIN, 'POST');
		req.setBodyAsBlob(content);
		HttpRequestResponse ret = new HttpRequestResponse(req, http.send(req));
		handleResponse(ret);
		return ret;
	}

	public static HttpRequestResponse getS3Document(S3Document__c doc) {
		Http http = new Http();
		HttpRequest req = buildBasicRequest(S3DocumentService.SERVICE_DOMAIN + '/file/' + doc.objectKey__c + '/' + doc.version__c, 'GET');
		HttpRequestResponse ret = new HttpRequestResponse(req, http.send(req));
		handleResponse(ret);
		return ret;
	}

	public static void handleResponse(HttpRequestResponse httpRR) {
		integer resStatusCode = httpRR.res.getStatusCode();
		if(resStatusCode < 200) {
			//not supported
		} else if(resStatusCode < 300) {
			//2xx success
		} else if(resStatusCode < 400) {
			//3xx redirect
		} else if(resStatusCode < 500) {
			//4xx
			//TODO: throw Developer Exception
			throw new HttpRequestResponse.HttpException();
		} else if(resStatusCode < 600) {
			//5xx
			//TODO: throw Service Excepton CC Developer
			throw new HttpRequestResponse.HttpException();
		} else {
			//Unknow
		}
	}

	public static List<Attachment> constructFailureAsAttachment(List<S3Document__c> s3Docs, Map<String, Blob> docMap) {
		List<Attachment> errorList = new List<Attachment>();
		for(S3Document__c doc : s3Docs) {
			if(doc.version__c == S3DocumentService.FAILED_VERSION_ID) {
				Attachment attachment = new Attachment();
				attachment.name = doc.name;
				attachment.body = docMap.get(doc.name);
				attachment.parentId = doc.id;
				errorList.add(attachment);
			}
		}
		return errorList;
	}

}
