@isTest
public class MercuryTestUtilities {

   public static void setMock(String oppoId, String accountId) {
      MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
      multimock.setStaticResource('https://api.connective.com.au/api/mercuryLogin5.jsp', 'MercuryLoginSuccessResponse');
      multimock.setStaticResource('https://api.connective.com.au/api/mercury5/aaf498ce-fc28-4e0c-a2c3-63cfd7d6ff18/loan/' + oppoId, 'MercuryLoanSuccessResponse');
      multimock.setStaticResource('https://api.connective.com.au/api/mercury5/aaf498ce-fc28-4e0c-a2c3-63cfd7d6ff18/loan/' + oppoId.left(15), 'MercuryLoanFail1Response');
      multimock.setStaticResource('https://api.connective.com.au/api/mercury5/aaf498ce-fc28-4e0c-a2c3-63cfd7d6ff18/person/' + accountId, 'MercuryPersonSuccessResponse');
      multimock.setStatusCode(200);
      multimock.setHeader('Content-Type', 'application/json');
      Test.setMock(HttpCalloutMock.class, multimock);
   }

   public static void setCredential() {
      Credential__c setting = new Credential__c(name = 'Mercury', Mercury_Application__c = 'mercury5', Mercury_Domain__c = 'https://api.connective.com.au', Mercury_Login_End_Point__c = 'https://api.connective.com.au/api/mercuryLogin5.jsp', Mercury_Password__c = 'password', Mercury_Username__c = 'username');
      insert setting;
   }

   public static void setMercurySettings(Boolean isQueued) {
      MercurySettings__c setting = new MercurySettings__c(SyncInQueue__c = isQueued, MercuryBatchId__c = '01pN0000000GKnSIAW');
      insert setting;
   }

   public static void setEmailSettings() {
      ACFEmailList__c setting = new ACFEmailList__c(Mercury_Email_Receiver__c = 'anthony.xuan@creditandfinance.com.au');
      insert setting;
   }

   public static void setACFSwitchSettings() {
      ACFSwitch__c setting = new ACFSwitch__c(Mercury_Email_Switch__c = false);
      insert setting;
   }

   public static void setCustomSettings(Boolean isQueued) {
      setCredential();
      setMercurySettings(isQueued);
      setEmailSettings();
      setACFSwitchSettings();
   }

}