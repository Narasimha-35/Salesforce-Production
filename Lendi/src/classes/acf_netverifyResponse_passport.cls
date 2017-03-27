/*====================================================
				Click Loans
========================================================*/
public class acf_netverifyResponse_passport{

	public String timestamp;	//2014-11-21T14:13:53.451Z
	public String scanReference;	//936c24ff-d48f-4f9a-9227-08a1f8f78bff
	public cls_document document;
	public cls_transaction transaction_response;
	public cls_verification verification;
	
	public class cls_document {
		public String type_response;	//ID_CARD
		public String dob;	//1989-06-08
		public String firstName;	//PRASHANT
		public String issuingCountry;	//IND
		public String lastName;	//KUMAR
		public String number_response;	//BNSPK6990D
		public String status;	//APPROVED_VERIFIED
		public String expiry;
	}
	public class cls_transaction {
		public String clientIp;	//125.63.92.90
		public String date_response;	//2014-11-18T12:15:48.183Z
		public String merchantScanReference;	//TestScanReference
		public String source;	//WEB_CAM
		public String status;	//DONE
	}
	public class cls_verification {
		public String mrzCheck;	//NOT_AVAILABLE
	}
	public static acf_netverifyResponse_passport parse(String json){
		system.debug('json-------------------'+json);
		return (acf_netverifyResponse_passport) System.JSON.deserialize(json, acf_netverifyResponse_passport.class);
	}
}