public with sharing class S3DocumentModel {

	public class UploadRequest extends Model {
		public String name;
		public Blob data;
		public Id sf_s3DocumentId; //salesforce s3 document id
		public String type;
		public String objectKey;

		public UploadRequest() {
		}

		public UploadRequest(String name, Blob data, String type) {
			this.name = name;
			this.data = data;
			this.type = type;
		}

		public UploadRequest(Attachment att, String type) {
			this.name = att.name;
			this.data = att.body;
			this.sf_s3DocumentId = att.parentId;
			this.type = type;
		}

		public UploadRequest(S3Document__c s3Doc, Blob data) {
			this.name = s3Doc.name;
			this.data = data;
			this.type = s3Doc.contentType__c;
		}
	}

	public class Response extends Model {
		public Integer statusCode;
		public String error;
		public String message;
		public Meta meta;
		public Data data;
	}

	public class Meta extends Model {
		public String api_version;
		public String community;
	}

	public class Data extends Model {
		public List<S3DocumentModel.Document> documents;
	}

	public class Document extends Model {
		public String key;
		public String version;
	}

}
