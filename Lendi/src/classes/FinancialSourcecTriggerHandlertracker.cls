@isTest(SeeAllData=false)
public class FinancialSourcecTriggerHandlertracker{

    
    static testmethod void myTestMethod1() {
     // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 's3ndt', Email='tech@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='tech@teorg.com');
      System.RunAs(u) {
      Financials_Source__c  obj = new Financials_Source__c ();
      insert obj;
      
      }

     
      
    }
    }