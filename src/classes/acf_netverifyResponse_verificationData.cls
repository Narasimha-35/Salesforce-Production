public class acf_netverifyResponse_verificationData{
  public String timestamp;  //2014-11-21T14:13:53.451Z
  public String scanReference;  //936c24ff-d48f-4f9a-9227-08a1f8f78bff
  public cls_document document;
  public cls_transaction_response transaction_response;
  public cls_verification verification;
  
  public class cls_document {
    public String type_response;  //ID_CARD
    public String dob;  //1989-06-08
    public String firstName;  //PRASHANT
    public String issuingCountry;  //IND
    public String lastName;  //KUMAR
    public String number_response;  //BNSPK6990D
    public String status;  //APPROVED_VERIFIED
    public cls_address address;//added by karthik on 11/05/2016
  }
  public class cls_address {
        public String country;  //AUS
        public String streetNumber; //4
        public String streetName;   //STREETON
        public String streetSuffix; //RD
        public String city; //BAYSWATER
        public String stateCode;    //AU-VIC
        public String zip;  //3153
  }
  public class cls_transaction_response{
    public String clientIp;  //125.63.92.90
    public String date_response;  //2014-11-18T12:15:48.183Z
    public String merchantScanReference;  //TestScanReference
    public String source;  //WEB_CAM
    public String status;  //DONE
  }
  public class cls_verification {
    public String faceMatch;  //92
    public String mrzCheck;  //NOT_AVAILABLE
    public cls_rejectReason rejectReason;
  }
  public class cls_rejectReason {
    public String rejectReasonCode; //200
    public String rejectReasonDescription;  //NOT_READABLE_DOCUMENT
//    public cls_rejectReasonDetails rejectReasonDetail;
    public cls_rejectReasonDetails[] rejectReasonDetails;
  }
  public class cls_rejectReasonDetails {
    public String detailsCode;  //2001
    public String detailsDescription;   //BLURRED
  }
  public static acf_netverifyResponse_verificationData parse(String json){
    system.debug('json-------------------'+json);
    if(json.contains('rejectReasonDetails') && !json.contains('rejectReasonDetails":['))
    {
        json = json.replace('rejectReasonDetails":','rejectReasonDetails":[');
        string lastThreechar = json.right(3);
        json = json.removeEnd(lastThreechar);
        json = json +']'+ lastThreechar;
        system.debug('json-------------------'+json);
    }
    return (acf_netverifyResponse_verificationData) System.JSON.deserialize(json, acf_netverifyResponse_verificationData.class);
  }  
}