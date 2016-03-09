@isTest(SeeAllData=true)
public class Saasfocus_GoogleCalenderHelper_Tracker
{

  static testmethod void TestSaasfocus_GoogleSyncEvent()
  {
    Saasfocus_GoogleCalenderHelper obj = new Saasfocus_GoogleCalenderHelper();


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
    insert broker_obj;
    Event ev=new Event();
    ev.StartDateTime=Datetime.now();
    ev.EndDateTime=Datetime.now().addhours(2);
    ev.Subject='asadg';
    ev.Location='fhgj';
    ev.Description='gfhf';
    ev.Whatid = broker_obj.id;
    ev.Google_Event_ID__c='rsen87vvo231f9b04592bsl9ic~testuser1@tpoint.com.au';

    insert ev;
    List<String> lstApp = new List<String>();
    //List<Event> ids = [Select Id from Event];
    //for(Event ex:ids )
    //{
    //lstApp.add((String)ex.id);
    // }
    lstApp.add((String)ev.id);
    //List<String> lstApp = new List< Event>();
    //lstApp.add(ev);
    //insert lstApp;
    //Saasfocus_GoogleCalenderHelper.processEvent(lstApp);
    /*Test.startTest();
    Saasfocus_GoogleCalenderHelper.isApexTest = true;
    Test.stopTest();*/
    /*
    document dc = new document();
    dc.Body = Blob.valueOf(EncodingUtil.base64Encode(Blob.valueOf('{"private_key_id": "8fead440f01df30df3acef1c6ac671a12dd80073",  "private_key": "-----BEGIN PRIVATE KEY-----\nMIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAPbNnbdX954ssxes\nwdAw9mAOghsXFgMsbkmnSu2mju0+H8bgRmVA/lJt8LBHaWb+TLamWc2wYozQLJdA\n/C/964Gg+X50j91iQy96f9A+YuhjOzZ+XcMbAY+i9d1l8Ni3UtmmPWS7EJ9NkBcc\nVt+8IR9Akw6pV/e1rw7g2F/QnR8HAgMBAAECgYB5VBfGvE4UynC4oMse6BMWoctA\nOhcuNDd7qexh7FGzO6kvga3ZtRvRtg5u+oxMf5OC70CSp7Wq9+QT73SKu098kVw1\nrWIMSc+r8oxVB5bImnBBBWVTpunpTQLZTpk9iwaEHk6S03foRhX2XmjwewPvhBHv\nIRIIvPtNWPgiAn70UQJBAPvl/bWgCQvMozJrxqajYMKtWF8on76Q9biq7ztfeQJ/\nulTNQh3kz78JxjPgXHuSVhKPDoLaqXIN9b19iYsuS2sCQQD60mLfY9NqyfczDSC/\nZke/obBfU/WzxLbpCTs6zgwhLJFd2A7kWCqqA/fpT4oBq7yDlMPJGbKk6w5EGI+I\nN93VAkEA02ENROM1lBw1+nKscVt6MAMsvDWnz09vk3aFaEpWjn1GjDDuQY2ns0Tt\neMzWbq++4LYBVFdPh7ElPMzipdPEXwJAFYUtlIslHZl8izXKJIHrEAcYceVrRGRR\naUcwfMgnBEWlp06dYHwsFPBIOg1oAuKwRv3hmoSI7lt4muEcl4xrjQJAP4Fg+WBe\nL+49yGd0wPB6THRFSDw8x8YtzBKSKm8PUSZGCdojLIiCoCq03rwCs/DE08TvmKLR\nwIQTfnAY8k6wwg\u003d\u003d\n-----END PRIVATE KEY-----\n",  "client_email": "762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com",  "client_id": "762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1.apps.googleusercontent.com",  "type": "service_account"}')));
    dc.Name = 'Private Key';
    dc.DeveloperName = 'Private_Key';
    dc.ContentType = '.json';
    dc.FolderId = UserInfo.getUserId();
    insert dc;
    */
    Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
    obj1.Name='Google_Setting';
    obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
    obj1.Google_Calender_ID__c='kripa@getmaxx.in';
    obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    //insert obj1;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    //Saasfocus_Global.GoogleSyncProces=True;
    Saasfocus_GoogleCalenderHelper.processEvent(lstApp);
    Test.stopTest();

    // Saasfocus_GoogleCalenderHelper.JsonDataForGoogle nw = new Saasfocus_GoogleCalenderHelper.JsonDataForGoogle(ev);
    Datetime dt= Datetime.now();
    // Saasfocus_GoogleCalenderHelper.End_Z ob = new Saasfocus_GoogleCalenderHelper.End_Z(dt);
    // Saasfocus_GoogleCalenderHelper.Attendee ob1 = new Saasfocus_GoogleCalenderHelper.Attendee('amit','ashu');
    //
    // Saasfocus_GoogleCalenderHelper.ParseEventInsertResponse ob2 = new Saasfocus_GoogleCalenderHelper.ParseEventInsertResponse();
  }

  static testmethod void TestSaasfocus_GoogleSyncEvent1()
  {
    Saasfocus_Global.GoogleSyncProces=True;
    Saasfocus_GoogleCalenderHelper obj = new Saasfocus_GoogleCalenderHelper();
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
    insert broker_obj;
    Event ev=new Event();
    ev.StartDateTime=Datetime.now();
    ev.EndDateTime=Datetime.now().addhours(2);
    ev.Subject='asadg';
    ev.Location='fhgj';
    ev.Description='gfhf';
    ev.whatid=broker_obj.id;
    //ev.Google_Event_ID__c='rsen87vvo231f9b04592bsl9ic~testuser1@tpoint.com.au';

    insert ev;


    List<String> lstApp = new List<String>();
    //List<Event> ids = [Select Id from Event];
    //for(Event ex:ids )
    //{
    // lstApp.add((String)ex.id);
    // }
    lstApp.add((String)ev.id);
    Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
    obj1.Name='Google_Setting';
    obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
    obj1.Google_Calender_ID__c='kripa@getmaxx.in';
    obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    //insert obj1;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    Saasfocus_GoogleCalenderHelper.processEvent(lstApp);
    Test.stopTest();
  }

  static testmethod void TestSaasfocus_GoogleSyncEvent2()
  {
    Saasfocus_Global.GoogleSyncProces=True;
    Saasfocus_GoogleCalenderHelper obj = new Saasfocus_GoogleCalenderHelper();
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
    insert broker_obj;
    Event ev=new Event();
    ev.StartDateTime=Datetime.now();
    ev.EndDateTime=Datetime.now().addhours(2);
    ev.Subject='asadg';
    ev.Location='fhgj';
    ev.Description='gfhf';
    ev.whatid=broker_obj.id;
    ev.Google_Event_ID__c='rsen87vvo231f9b04592bsl9ic~testuser1@tpoint.com.au';

    insert ev;


    List<String> lstApp = new List<String>();
    //List<Event> ids = [Select Id from Event];
    //for(Event ex:ids )
    //{
    // lstApp.add((String)ex.id);
    // }
    lstApp.add((String)ev.id);
    Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
    obj1.Name='Google_Setting';
    obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
    obj1.Google_Calender_ID__c='kripa@getmaxx.in';
    obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    //insert obj1;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    Saasfocus_GoogleCalenderHelper.processEvent(lstApp);
    Test.stopTest();
  }

}
