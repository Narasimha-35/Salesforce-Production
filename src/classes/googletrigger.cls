@isTest 
private class googletrigger{
    static void TestMyMethod2()    
     {
    // GenerateToken_Saasfocus.TokenParse ob =  new  GenerateToken_Saasfocus.TokenParse ();
    //GenerateToken_Saasfocus.Claimset cs =  new  GenerateToken_Saasfocus.Claimset();
       Test.startTest();
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
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         obj.InsertEventslist(lstBroker); 
         Test.stopTest();
         }
}