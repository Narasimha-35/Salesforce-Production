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
class Saasfocus_GoogleSyncEventTrigger_tracker 
{
/*
@isTest 
    static void TestSaasfocus_GoogleSyncEvent() 
  {  
  Saasfocus_Global.GoogleSyncProces=false;
  
        Event ev= new Event();
        ev.Subject = 'AK';
        ev.StartDateTime = System.now();    
        ev.EndDateTime = System.now().addhours(1);
        insert ev;
  
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c(); 
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        //obj1.upto_period__c = System.today();
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
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
       
        Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'SU';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().addhours(1);
        grobj.Freq__c = 'weekly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now();
        grobj.Summary__c = 'amit';
        grobj.Until__c = System.now();
        insert grobj;
        
        
         Saasfocus_GoogleSyncEvent obj=new Saasfocus_GoogleSyncEvent();
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         obj.InsertEventslist(lstBroker); 
         Test.stopTest();
         }
       
        @isTest
        static void TestMyMethod4()    
         {
       Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
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
        static void TestMyTrigger()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'SU';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().addhours(1);
        grobj.Freq__c = 'weekly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now();
        grobj.Summary__c = 'amit';
        grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
         
          @isTest
        static void TestMyTrigger1()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
        Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'SU';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().addhours(1);
        grobj.Freq__c = 'Daily';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now();
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger2()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
         Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'SU';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().addhours(1);
        grobj.Freq__c = 'Daily';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now();
        grobj.Summary__c = 'amit';
        grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger3()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
         Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'SU';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().addhours(1);
        grobj.Freq__c = 'Daily';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now();
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger4()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'SU';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().addhours(1);
        grobj.Freq__c = 'Weekly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now();
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger5()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Weekly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger6()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
           Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'MO';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Weekly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger7()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
         Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Weekly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        grobj.Until__c = System.now();
        insert grobj;
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger8()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Monthly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger9()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
         Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Monthly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger10()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Monthly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger11()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Monthly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = '2';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger12()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Monthly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c ='2';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger13()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
         Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        grobj.ByDay__c = 'MO';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Monthly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = '2';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger14()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
         Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Yearly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger15()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        //grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Yearly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger16()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Yearly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        //grobj.Until__c = System.now();
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger17()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
          Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Yearly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        grobj.Until__c =System.now().adddays(4);
        //grobj.Assigned_To__c = us.id;
        insert grobj;
        
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
          @isTest
        static void TestMyTrigger18()    
         {
          Saasfocus_GoogleSyncEvent.TokenParse ob =  new  Saasfocus_GoogleSyncEvent.TokenParse ();
       //Saasfocus_GoogleSyncEvent.Claimset cs =  new Saasfocus_GoogleSyncEvent.Claimset();
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
        //broker_obj.Next_Sync_Token__c='fhsdjf';
        insert broker_obj;
       
        lstBroker.add(broker_obj);
        
        Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
        obj1.Name='Google_Setting'; 
        obj1.Access_Token_Time_Stamp__c= DateTime.now().addhours(2);
        obj1.Google_Calender_ID__c='kripa@getmaxx.in';
        obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
        obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
      //  insert obj1;
      
         
         Saasfocus_GoogleSyncEvent objnew=new Saasfocus_GoogleSyncEvent();
         Google_Recurring_Events__c grobj = new Google_Recurring_Events__c();
        grobj.Broker__c = broker_obj.id;
        //grobj.ByDay__c = 'MO';
        grobj.Count__c = 2;
        grobj.Description__c = 'fgbhfddndfb';
        grobj.End_date__c = System.now().adddays(3).addhours(1);
        grobj.Freq__c = 'Yearly';
        grobj.Google_Event_Id__c = 'i0p9fp6ggadidphoiuai5rouk~testuser2@tpoint.com.au'; 
        //grobj.GOOGLE_ID__c = 'dgdrf';
        //grobj.Google_Response__c = 'bgfdbn';
        grobj.Interval__c = 6;
        //grobj.Last_Event_Date__c = System.now();
        grobj.Multiday__c = true;
        //grobj.Recurring_duration__c = 5;
        grobj.Recurring_Events__c = true;
        grobj.Repeats_on__c = 'friday';
        grobj.Start_date__c = System.now().adddays(3);
        grobj.Summary__c = 'amit';
        grobj.Until__c =System.now().addyears(4);
        //grobj.Assigned_To__c = us.id;
        insert grobj;
         //obj.InsertEventslist(lstBroker);
          Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         objnew.InsertEventslist(lstBroker);
         System.debug('amit'+lstBroker); 
         Test.stopTest();

         }
         */
        }