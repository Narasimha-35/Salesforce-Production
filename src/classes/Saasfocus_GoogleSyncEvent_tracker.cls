// ----------------------------------------------------------------------------------
// This test class covers the controller class Saasfocus_GoogleSyncEvent in Salesforce

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0           27/04/2015    Amit kumar Sharma         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes: 
// ----------------------------------------------------------------------------------
//  
//
@isTest (seealldata=true)
class Saasfocus_GoogleSyncEvent_tracker 
{

@isTest 
    static void TestSaasfocus_GoogleSyncEvent() 
  {  
    Google_API_Setting__c  obj1 =  new Google_API_Setting__c(); 
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
        
   // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
    
    Saasfocus_GoogleSyncEvent obj=new Saasfocus_GoogleSyncEvent();
        Test.startTest();
        
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       // obj.InsertEventslist(); 
        
          Test.stopTest();
Saasfocus_Global ob=new Saasfocus_Global();
Saasfocus_Global.getGoogleId('amit');
     }
 @isTest     
     static void TestMyMethod()    
     {
       Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
         list<Broker__c> lstBroker=[select id,Email__c,Next_Sync_Token__c from Broker__c limit 5];
    Market__c ok= new Market__c();
        ok.Name='Amit';
        insert ok;
    Broker__c broker_obj= new Broker__c();
        broker_obj.Name='kripa';
        broker_obj.Email__c='testuser1@tpoint.com.au';
        broker_obj.MobilePhone__c='9719764989';
        broker_obj.Street_Address__c='ABC';
        broker_obj.City__c='dehradun';
        broker_obj.Primary_Market__c=ok.id;
        broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        //obj.InsertEventslist();  Google_API_Setting__c  obj1 =  new Google_API_Setting__c(); 
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
        
        
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          Saasfocus_GoogleSyncEvent obj=new Saasfocus_GoogleSyncEvent();
         Saasfocus_Global.GoogleSyncProces=True;
        obj.InsertEventslist(lstBroker); 
         Test.stopTest();

        }
        
        @isTest     
     static void TestMyMethod1()    
     {
    // GenerateToken_Saasfocus.TokenParse ob =  new  GenerateToken_Saasfocus.TokenParse ();
    //GenerateToken_Saasfocus.Claimset cs =  new  GenerateToken_Saasfocus.Claimset();
         list<Broker__c> lstBroker=[select id,Email__c,Next_Sync_Token__c from Broker__c limit 5];
    Market__c ok= new Market__c();
        ok.Name='Amit';
        insert ok;
    Broker__c broker_obj= new Broker__c();
        broker_obj.Name='kripa';
        broker_obj.Email__c='kripa@getmaxx.in';
        broker_obj.MobilePhone__c='9719764989';
        broker_obj.Street_Address__c='ABC';
        broker_obj.City__c='dehradun';
        broker_obj.Next_Sync_Token__c='fhsdjf';
        broker_obj.Primary_Market__c=ok.id;
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        //obj.InsertEventslist();  Google_API_Setting__c  obj1 =  new Google_API_Setting__c(); 
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
       // insert obj1;
        
         Saasfocus_GoogleSyncEvent obj=new Saasfocus_GoogleSyncEvent();
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        obj.InsertEventslist(lstBroker); 
         Test.stopTest();

        }
           @isTest     
     static void TestMyMethod2()    
     {
    // GenerateToken_Saasfocus.TokenParse ob =  new  GenerateToken_Saasfocus.TokenParse ();
    //GenerateToken_Saasfocus.Claimset cs =  new  GenerateToken_Saasfocus.Claimset();
         list<Broker__c> lstBroker=[select id,Email__c,Next_Sync_Token__c from Broker__c limit 10];
    Market__c ok= new Market__c();
        ok.Name='Amit';
        insert ok;
    Broker__c broker_obj= new Broker__c();
        broker_obj.Name='kripa';
        broker_obj.Email__c='kripa@getmaxx.in';
        broker_obj.MobilePhone__c='9719764989';
        broker_obj.Street_Address__c='ABC';
        broker_obj.City__c='dehradun';
        broker_obj.Next_Sync_Token__c='fhsdjf';
        broker_obj.Primary_Market__c=ok.id;
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        //obj.InsertEventslist();  Google_API_Setting__c  obj1 =  new Google_API_Setting__c(); 
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
       // insert obj1;
        
         Saasfocus_GoogleSyncEvent obj=new Saasfocus_GoogleSyncEvent();
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        obj.InsertEventslist(lstBroker); 
         Test.stopTest();
         
        
        }
        }