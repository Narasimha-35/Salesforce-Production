global class ResponseHandler {
	public String status {get; set;}
	public List<SObject> dataCollection {get; set;}
	public String message {get; set;}
	public String errorCode {get; set;}
	
	global static boolean isNotNullOrEmpty(String str) {
		return str!=null || !String.isBlank(str);
	}
}