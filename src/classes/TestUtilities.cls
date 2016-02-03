@isTest
public class TestUtilities {

   public static Account createAccount(String accName) {
      return new Account(name = accName);
   }

   public static Account createAccount() {
      return createAccount('test');
   }

   public static List<Account> createAccounts(Integer numOfRecords) {
      List<Account> ret = new List<Account>();
      for(Integer i = 0; i < numOfRecords; i++) {
         ret.add(createAccount('test' + i));
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

}