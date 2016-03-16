@isTest(SeeAllData=true)
public class Saasfocus_GoogleCalenderHelper_Tracker {

  static testmethod void TestSaasfocus_GoogleSyncEvent() {
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
    lstApp.add((String)ev.id);
    Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
    obj1.Name='Google_Setting';
    obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
    obj1.Google_Calender_ID__c='kripa@getmaxx.in';
    obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    GoogleCalendarService.insertGoogleEvent(lstApp);
    Test.stopTest();

    Datetime dt= Datetime.now();
  }

  static testmethod void TestSaasfocus_GoogleSyncEvent1() {
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

    insert ev;

    List<String> lstApp = new List<String>();
    lstApp.add((String)ev.id);
    Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
    obj1.Name='Google_Setting';
    obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
    obj1.Google_Calender_ID__c='kripa@getmaxx.in';
    obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    GoogleCalendarService.insertGoogleEvent(lstApp);
    Test.stopTest();
  }

  static testmethod void TestSaasfocus_GoogleSyncEvent2() {
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
    lstApp.add((String)ev.id);
    Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
    obj1.Name='Google_Setting';
    obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
    obj1.Google_Calender_ID__c='kripa@getmaxx.in';
    obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
    obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    GoogleCalendarService.insertGoogleEvent(lstApp);
    Test.stopTest();
  }

}
