public with sharing class S3DocumentModel {

	public class UploadRequest extends Model {
		public String name;
		public Blob data;
		public Id docId;

		public UploadRequest() {
		}

		public UploadRequest(String name, Blob data) {
			this.name = name;
			this.data = data;
		}

		public UploadRequest(Attachment att) {
			this.name = att.name;
			this.data = att.body;
			this.docId = att.parentId;
		}
	}

	public class GetResponse extends Model {
		public String url;
	}

	public class PostResponse extends Model {
		public String status;
		public String file;
		public String version;
	}

	public class Response extends Model {
		public String statusCode;
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
		public String original_name;
		public String encoding;
		public String mime_type;
		public String filename;
		public Integer size;
		public String version;
	}

}
