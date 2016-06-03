public with sharing class S3DocumentModel {

	public class GetResponse extends Model {
		public String url;
	}

	public class PostResponse extends Model {
		public String status;
		public String file;
		public String version;
	}

}
