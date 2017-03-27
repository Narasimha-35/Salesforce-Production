@isTest(seealldata = true)
public class acfNetVerifyTracker
{
    public static testmethod void myUnitTest()
    {
        String json='{"timestamp":"2016-02-22T20:12:27.614Z","scanReference":"268ff9ec-f0e7-45cf-aab2-77f3d488e1e8","document":{"type_response":"DRIVING_LICENSE","issuingCountry":"AUS","status":"ERROR_NOT_READABLE_ID"},"transaction_response":{"clientIp":"58.106.253.220","date_response":"2016-02-06T22:46:38.414Z","merchantScanReference":"00Q6F00000wFr4tUAC","source":"WEB_UPLOAD","status":"DONE"},"verification":{"mrzCheck":"NOT_AVAILABLE","rejectReason":{"rejectReasonCode":"200","rejectReasonDescription":"NOT_READABLE_DOCUMENT","rejectReasonDetails":{"detailsCode":"2001","detailsDescription":"BLURRED"}}}}';
                     
        acf_netverifyResponse_verificationData obj = acf_netverifyResponse_verificationData.parse(json);
    }
}