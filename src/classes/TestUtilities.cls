@isTest
public class TestUtilities {

   public static Lead createLead(String lastName) {
      return new Lead(lastName = lastname);
   }

   public static Lead createLead() {
      return createLead('test');
   }

   public static List<Lead> createLeads(Integer numOfRecords) {
      List<Lead> ret = new List<Lead>();
      for(Integer i = 0; i < numOfRecords; i++) {
         ret.add(createLead('test' + i));
      }

      return ret;
   }

   public static List<Lead> createLeads(Integer numOfRecords, Lead lead) {
      List<Lead> ret = new List<Lead>();
      Lead temp = null;
      for(Integer i = 0; i < numOfRecords; i++) {
         temp = lead.clone(false, true, false, false);
         temp.lastName = lead.lastName + i;
         ret.add(temp);
      }

      return ret;
   }

   public static AsyncRequest__c createAsyncRequest(String reqType, String reqParam) {
      AsyncRequest__c req = new AsyncRequest__c(type__c = reqType, params__c = reqParam);
      return req;
   }

   public static AsyncRequest__c createAsyncRequest(Id oppoId, Id accId) {
      String params = '{"oppoId":"'+ oppoId + '", "accId":"' + accId + '"}';
      return createAsyncRequest('' + AsyncRequestType.SF_TO_MERCURY, params);
   }

   public static Account createAccount(String accName, Boolean isPersonAccount) {
      Account ret = new Account();
      if(isPersonAccount) {
         RecordTypeSelector rts = new RecordTypeSelector();
         RecordType personAccountRT = rts.getUniqueRecordType('Account', 'PersonAccount');
         ret.Recordtypeid = personAccountRT.id;
         ret.lastName = accName;
      } else {
         ret.name = accName;
      }
      return ret;
   }

   public static Account createAccount(Boolean isPersonAccount) {
      return createAccount('test', isPersonAccount);
   }

   public static Account createAccount() {
      return createAccount(true);
   }

   public static List<Account> createAccounts(Integer numOfRecords, Boolean isPersonAccount) {
      List<Account> ret = new List<Account>();
      for(Integer i = 0; i < numOfRecords; i++) {
         ret.add(createAccount('test' + i, isPersonAccount));
      }

      return ret;
   }

   public static List<Account> createAcconts(Integer numOfRecords, Account a) {
      List<Account> ret = new List<Account>();
      Account temp = null;
      for(Integer i = 0; i < numOfRecords; i++) {
         temp = a.clone(false, true, false, false);
         temp.name = a.name + i;
         ret.add(temp);
      }

      return ret;
   }

   public static Contact createContact(String lastName) {
      return new Contact(lastName = lastname);
   }

   public static Contact createContact() {
      return createContact('test');
   }

   public static List<Contact> createContacts(Integer numOfRecords) {
      List<Contact> ret = new List<Contact>();
      for(Integer i = 0; i < numOfRecords; i++) {
         ret.add(createContact('test' + i));
      }

      return ret;
   }

   public static List<Contact> createContacts(Integer numOfRecords, Contact c) {
      List<Contact> ret = new List<Contact>();
      Contact temp = null;
      for(Integer i = 0; i < numOfRecords; i++) {
         temp = c.clone(false, true, false, false);
         temp.lastName = c.lastName + i;
         ret.add(temp);
      }

      return ret;
   }

   public static Opportunity createOpportunity(String name, String stageName, Date closeDate) {
      return new Opportunity(name = name, stageName = stageName, closeDate = closeDate);
   }

   public static Opportunity createOpportunity() {
      return createOpportunity('test', 'Appointed', Date.today());
   }

   public static List<Opportunity> createOpportunities(Integer numOfRecords) {
      List<Opportunity> ret = new List<Opportunity>();
      for(Integer i = 0; i < numOfRecords; i++) {
         ret.add(createOpportunity('test' + i, 'Appointed', Date.today()));
      }

      return ret;
   }

   public static List<Opportunity> createOpportunities(Integer numOfRecords, Opportunity o) {
      List<Opportunity> ret = new List<Opportunity>();
      Opportunity temp = null;
      for(Integer i = 0; i < numOfRecords; i++) {
         temp = o.clone(false, true, false, false);
         temp.name = o.name + i;
         ret.add(temp);
      }

      return ret;
   }

   public static Market__c createMarket() {
      return new Market__c();
   }

   public static Broker__c createBroker(String name, String mobile, String email, String street, String city, Market__c market, Boolean isActive) {
      return new Broker__c(name = name, MobilePhone__c = mobile, Email__c = email, Street_Address__c = street, City__c = city, Primary_Market__c = market.id, Active_Broker__c = isActive);
   }

   public static Broker__c createBroker() {
      Market__c m = createMarket();
      insert m;
      return createBroker('testBroker', '0000000000', 'test@test.com', 'street', 'city', m, true);
   }

   public static Appointment__c createAppointment() {
      Opportunity o = createOpportunity();
      Broker__c b = createBroker();
      Market__c m = createMarket();

      insert o;
      insert b;
      insert m;
      return new Appointment__c(Opportunity__c = o.id, Broker__c = b.id, Market__c = m.id, Appointment_Date_and_Time__c = DateTime.now());
   }

   //@deprecated
   public static List<Account> createTestAccountsWithName(Integer num) {
      Account temp = null;
      List<Account> ret = new List<Account>();

      for(Integer i = 0; i < num; i++) {
         temp = new Account(name = 'testAccount' + i);
         ret.add(temp);
      }

      return ret;
   }

   //@deprecated
   public static List<vhc__Campaign__c> createTestCallFile(Integer num) {
      vhc__Campaign__c temp = null;
      List<vhc__Campaign__c> ret = new List<vhc__Campaign__c>();

      for(Integer i = 0; i < num; i++) {
         temp = new vhc__Campaign__c(name = 'testCallFile' + i, vhc__Outgoing_Campaign__c = 'a0w900000048Fh2');
         ret.add(temp);
      }

      return ret;
   }

   //@deprecated
   public static List<vhc__Campaign_Member__c> createTestCallFileMember(Map<vhc__Campaign__c, Integer> campNumMap) {
      vhc__Campaign_Member__c temp = null;
      List<vhc__Campaign_Member__c> ret = new List<vhc__Campaign_Member__c>();

      for(vhc__Campaign__c c : campNumMap.keySet()) {
         for(Integer i = 0; i < campNumMap.get(c); i++) {
            temp = new vhc__Campaign_Member__c(vhc__Campaign__c = c.id);
            ret.add(temp);
         }
      }

      return ret;
   }

   public static Income_And_Expense__c createIncomeAndExpense() {
      Income_And_Expense__c iae = new Income_And_Expense__c();
      return iae;
   }

   public static Click_Applicant__c createApplicant(Account acc) {
      Click_Applicant__c app = new Click_Applicant__c();
      app.click_Account__c = acc.id;
      app.acf_Applicant_Name__c = 'test acc';
      return app;
   }

   public static Asset_And_Liability__c createAssetAndLiability() {
      Asset_And_Liability__c aal = new Asset_And_Liability__c();
      return aal;
   }

   public static S3Document__c createS3Document() {
      return createS3Document('testDoc', 'f9c2b7e0-2863-11e6-80bb-bb4552b59e84', 'GCOWn09kbNBHPWuqmA5dLss9STLEb15s', LendiApiStaticValue.PDF_MINE_TYPE);
   }

   public static S3Document__c createS3Document(String name, String objKey, String version, String contentType) {
      S3Document__c doc = new S3Document__c();
      doc.name = name;
      doc.objectKey__c = objKey;
      doc.version__c = version;
      doc.isSuccess__c = true;
      doc.contentType__c = contentType;
      return doc;
   }

   public static List<S3Document__c> createS3Documents(Integer numOfRecords) {
      List<S3Document__c> ret = new List<S3Document__c>();
      for(Integer i = 0; i < numOfRecords; i++) {
         ret.add(createS3Document('testDoc' + i, 'testObjectKey' + i, 'testVersionId' + i, LendiApiStaticValue.PDF_MINE_TYPE));
      }
      return ret;
   }

}
