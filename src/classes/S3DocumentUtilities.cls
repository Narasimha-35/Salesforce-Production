public with sharing class S3DocumentUtilities {

	public static HttpRequest buildBasicRequest(String endPoint, String method) {
		HttpRequest req = new HttpRequest();
		req.setHeader('Authorization', 'Bearer ' + S3StaticValue.TOKEN);
		req.setEndPoint(endPoint);
		System.debug(LoggingLevel.DEBUG, '[S3DocumentUtilities] End Point: ' + endPoint);
		req.setMethod(method);
		return req;
	}

	public static String buildMultipartBody(List<S3DocumentModel.UploadRequest> uploadRequests) {
		String body = '';
		for(S3DocumentModel.UploadRequest uploadReq : uploadRequests) {
			body += '--' + S3StaticValue.MULTIPART_BOUNDARY + '\r\n';
			body += 'Content-Disposition: form-data; name="documents"; filename="' + uploadReq.name + '"\r\n';
			body += 'Content-Type: ' + uploadReq.type + '\r\n';
			body += 'content-transfer-encoding: base64\r\n';
			body += '\r\n';
			body += EncodingUtil.base64Encode(uploadReq.data) + '\r\n';
			body += '\r\n';
		}
		body += '--' + S3StaticValue.MULTIPART_BOUNDARY + '--\r\n';

		return body;
	}

	public static HttpRequestResponse insertS3Document(List<S3DocumentModel.UploadRequest> uploadRequests) {
		Http http = new Http();
		HttpRequest req = buildBasicRequest(S3StaticValue.S3_SERVICE_ENDPOINT, 'PUT');
		req.setHeader('Content-Type', 'multipart/form-data; MULTIPART_BOUNDARY=' + S3StaticValue.MULTIPART_BOUNDARY);
		req.setBody(buildMultipartBody(uploadRequests));
		req.setTimeout(S3StaticValue.TIME_OUT_MILLISEC);
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

	public static List<Attachment> constructFailureAsAttachment(List<S3Document__c> s3Docs, List<S3DocumentModel.UploadRequest> uploadRequests) {
		List<Attachment> errorList = new List<Attachment>();
		for(integer i = 0; i < s3Docs.size(); i++) {
			if(s3Docs[i].isSuccess__c == false) {
				Attachment attachment = new Attachment();
				attachment.name = s3Docs[i].name;
				attachment.body = uploadRequests[i].data;
				attachment.parentId = s3Docs[i].id;
				errorList.add(attachment);
			}
		}
		return errorList;
	}

	//Used when upload fail, when error occurs cast the Doc into Attachment then store in SF
	public static List<Attachment> getRelatedAttachments(List<S3Document__c> docs) {
		List<String> docIds = (List<String>) new List<Id>((new Map<Id, S3Document__c>(docs)).keySet());
		AttachmentSelector attSelecotr = new AttachmentSelector();
		return attSelecotr.getByParentId(docIds);
	}

}
