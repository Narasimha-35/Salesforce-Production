public with sharing class SFModel {

	public class DebugEmailRequest extends Model {
		public List<String> recipients {get; set;}
		public String subject {get; set;}
		public String projectName {get; set;}
		public String className {get; set;}
		public String methodName {get; set;}
		public String detail {get; set;}

		public void setDetails(HttpRequest req, HttpResponse res) {
			detail = Utilities.generateDebugEmailDetailPart(req, res);
		}

	}

}
