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

}
