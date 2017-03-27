// ----------------------------------------------------------------------------------
// This class Insert The Google Calender Event in Salesforce

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0           17/04/2015    Ashutosh kumar         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes:
// ----------------------------------------------------------------------------------
//
//
public class Saasfocus_GoogleSyncEvent
{
    public Set<String> deleteEvent_IDset= new Set<String>();
    public Set<String> deleteEvent_RecurIDset= new Set<String>();
    public set<DateTime> Single_eventSet= new Set<Datetime>();
    public List<Event> cancel_event_list= new List<Event>();
    Public List<Google_Recurring_Events__c> googleEventlst= new List<Google_Recurring_Events__c>();
    Public List<Google_Recurring_Events__c> cancel_Geventlist= new List<Google_Recurring_Events__c>();
    Public String request {get;set;}
    public Saasfocus_GetNextSyncToken Stoken{get;set;}
    Public string nextpagetoken;
    Google_API_Setting__c  obj;
    String Starttime;
    String endtime;
    List<Event> Event_list= new List<Event>();
    List<Event> del_list= new List<Event>();
    public Map<String,Id>User_Eml_Id_Map{get;set;}
    public List<User> Ulist{get;set;}
    public String recrule;
    TimeZone tz = UserInfo.getTimeZone();
    Public List<Google_Recurring_Events__c> glist= new List<Google_Recurring_Events__c>();
    public Integer Eventdaylimit{get;set;}

    Public Saasfocus_GoogleSyncEvent()
    {
        Google_API_Setting__c  obj =  Google_API_Setting__c.getValues('Google_Setting');   // Call the custom setting for calender value
        Eventdaylimit = (Integer) obj.upto_period__c *7;
    }

// This Method is used for insert the Event in the salesforce
    public void InsertEventslist(list<Broker__c> broker_list )
    {

// Call CheckAccessToken method of class GenerateToken_Saasfocus for Checking the access token is valid or not
        Saasfocus_GenerateToken ob= new Saasfocus_GenerateToken();
        obj= ob.CheckAccessToken();

//Logic to Convert the DateTime in the specific format as required in endpoint URL
        Datetime StartDateTime=Datetime.now();
        Integer hh=StartDateTime.hour();
        Integer mm=StartDateTime.minute();
        Integer ss=StartDateTime.second();
        StartDateTime =StartDateTime.addhours(-hh);
        StartDateTime =StartDateTime.addMinutes(-mm);
        StartDateTime =StartDateTime.addSeconds(-ss);
        Starttime= String.valueOf(StartDateTime );

        Starttime= Starttime.trim();
        Starttime= Starttime.replace(' ','T');
        Starttime= Starttime+'Z';

        endtime = String.valueOf(StartDateTime.addDays(Eventdaylimit));
        endtime = endtime.trim();
        endtime = endtime.replace(' ','T');
        endtime = endtime+'Z';

        User_Eml_Id_Map= new Map<String,Id>();  // Create Map of user email and id
        Ulist= [select id,Email from User];     // Create List of User for getting the id and Email

        for (User u_obj : Ulist){
            User_Eml_Id_Map.put(u_obj.Email, u_obj.id);  // add email id in the map
        }
        nextpagetoken = null;
        for(Broker__c bobject : broker_list )
        {
            callgoogleAPI(bobject);                           // Call the method callgoogleAPI()
        }
        Database.upsert(Event_list, Event.Fields.Google_Event_ID__c,false);    // upsert events
        update broker_list;
        system.debug(glist +'EEE11111'+Event_list);

// Condition for insert new event in salesforce
        List<Event> lstEvent = new List<Event>();
        try{
            Set<string> st = new Set<string>();
            List<Google_Recurring_Events__c> lstREinsert = new List<Google_Recurring_Events__c>();
            for(Google_Recurring_Events__c ob11 :glist){
                st.add(ob11.Google_Event_Id__c);
                Google_Recurring_Events__c obj = new Google_Recurring_Events__c();
                obj.Name=ob11.Name;
                obj.Start_date__c=ob11.Start_date__c;
                obj.End_date__c=ob11.End_date__c;
                obj.Summary__c=ob11.Summary__c;
                obj.Google_Event_Id__c=ob11.Google_Event_Id__c;
                obj.Description__c=ob11.Description__c;
                obj.Broker__c=ob11.Broker__c;

                if(ob11.Multiday__c==true){
                    obj.Multiday__c=true;
                }
                else
                {
                    obj.Recurring_Events__c=true;
                    obj.Repeats_on__c=ob11.Repeats_on__c;
                    if(ob11.ByDay__c!=null){
                        obj.ByDay__c=ob11.ByDay__c;
                    }
                    if(ob11.Count__c!=null){
                        obj.Count__c=ob11.Count__c;
                    }
                    if(ob11.Until__c!=null){
                        obj.Until__c=ob11.Until__c;
                    }
                    obj.Freq__c=ob11.Freq__c;
                    obj.Interval__c=ob11.Interval__c;

                }

                if(ob11.Assigned_To__c!=null){
                    obj.Assigned_To__c=ob11.Assigned_To__c;
                }
                lstREinsert.add(obj);
            }
            List<Google_Recurring_Events__c> lstRE = new List<Google_Recurring_Events__c>();
            lstRE = [select id from Google_Recurring_Events__c where Google_Event_Id__c in :st];
            st = new Set<string>();
            for(Google_Recurring_Events__c ob22 :lstRE){
                st.add(ob22.id);
            }
            lstEvent = [select id from Event where Event_ID__c in :st];
            system.debug('AKKK'+lstEvent);

            if(lstEvent.size() > 0){
                delete lstEvent;
            }

            if(lstRE.size() > 0){
                delete lstRE;
            }
            if(lstREinsert.size() > 0){
                insert lstREinsert;
            }
        }
        catch(Exception e){
            system.debug('!Bingo error=> '+e);
        }
        System.debug('DELLIST'+glist);

// Condition delete events from salesforce

        cancel_event_list= [select id from Event where Google_Event_ID__c in : deleteEvent_IDset];
        system.debug('HHHHHHI'+cancel_event_list);
        if(cancel_event_list.size()>0){
            for(Event evtobj:cancel_event_list){
                del_list.add(evtobj);
             }
        }
        try{
            if(del_list.size()>0){
                Set<Event> myset = new Set<Event>();
                List<Event> result = new List<Event>();
                for (Event s : del_list) {
                    if(myset.contains(s) == false){
                        myset.add(s);
                        result.add(s);
                    }
                    system.debug('RRR'+result);
                }
                //delete result;
                Database.delete(result, False);
            }

// Delete Google recurring Event object from salesforce
            if(googleEventlst.size()>0){
                Set<Google_Recurring_Events__c> myset = new Set<Google_Recurring_Events__c>();
                List<Google_Recurring_Events__c> result = new List<Google_Recurring_Events__c>();
                for (Google_Recurring_Events__c s : googleEventlst) {
                    if(myset.contains(s) == false){
                         myset.add(s);
                         result.add(s);
                    }
                 system.debug('RRR'+result);
                }
                // delete result;
                Database.delete(result, False);
            }

        }
        catch(Exception e){
            system.debug('!Bingo delete error=> '+e);
        }
// update google settings
         ob.updategooglesettings();
    }

// This method is used for Get the google calender Event
    Public void callgoogleAPI(Broker__c bobject)
    {
        String Endpoint = 'https://www.googleapis.com/calendar/v3/calendars/'+bobject.Email__c+'/events?access_token='+obj.Access_Token__c+'&timeMin='+Starttime+'&timeMax='+endtime +'&timeZone=GMT';
        if(bobject.Next_Sync_Token__c== null)
        {
            Endpoint = 'https://www.googleapis.com/calendar/v3/calendars/'+bobject.Email__c+'/events?access_token='+obj.Access_Token__c+'&timeMin='+Starttime+'&timeMax='+endtime +'&timeZone=GMT';
        }

        else If(nextpagetoken != null && bobject.Next_Sync_Token__c!= null )
        {
            Endpoint = 'https://www.googleapis.com/calendar/v3/calendars/'+bobject.Email__c+'/events?access_token='+obj.Access_Token__c+'&syncToken='+bobject.Next_Sync_Token__c+'&pageToken='+nextpagetoken+'&timeZone=GMT';
        }

        else if(nextpageToken == null && bobject.Next_Sync_Token__c!= null)
        {
            Endpoint = 'https://www.googleapis.com/calendar/v3/calendars/'+bobject.Email__c+'/events?access_token='+obj.Access_Token__c+'&syncToken='+bobject.Next_Sync_Token__c+'&timeZone=GMT';
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint(Endpoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization','Bearer '+obj.Access_Token__c);
        req.setMethod('GET');
        request = req.getBody();

//Logic for response to google calender event
        Http http = new Http();
        Httpresponse res = http.send(req);

        if(res.getStatusCode()== 410) // Sync token is no longer valid, a full sync is required.
        {
            bobject.Next_Sync_Token__c =null;
            callgoogleAPI(bobject);
            return;
        }

        if(res.getStatusCode()!= 200) // If Google server has returned any error , return for this broker
        return;

        String resbd = res.getBody();
        System.debug('RESPONSE'+resbd);

        // Get the next sync token form the response

        Stoken= (Saasfocus_GetNextSyncToken)JSON.deserialize( res.getBody(),Saasfocus_GetNextSyncToken.Class);
        system.debug('stoken***'+Stoken);
        // Assign the nextsynctoken into the Broker Field NextSyncToken

// Check If Google Calender Contains Events or Not
        if((resbd.contains('items')))
        {
            Map<String, Object> EventRes = (Map<String, Object>)JSON.deserializeUntyped(resbd);
            nextpagetoken = (String) EventRes.get('nextPageToken');

            List<Object> items = new List<Object>();
            items = (List<Object>)EventRes.get('items');

            for (Object item : items) {
                Map<String, Object> Event_item = (Map<String, Object>)item;
                Map<String,Object>Stime =(Map<String,Object>)(Event_item .get('start'));
                Map<String,Object>Etime =(Map<String,Object>)(Event_item .get('end'));
                List<object> RecRule=(List<Object>)(Event_item .get('recurrence'));

// Condition if single event, multiday and recurring event is Delete from google calender
                if((String)Event_item.get('status')=='cancelled'){
                    deleteEvent_IDset.add(Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'data'));
                    system.debug('HHHHHHI'+deleteEvent_IDset);
                }


// condition if google calender contains recurring event
    if(RecRule != null)
    {
        if(Stime != null && Etime != null && (String)Event_item.get('status')!='cancelled')
        {
//Logic to Convert the event start and End  DateTime in the specific format as required to assign th event Start And End time
            System.debug('Stime ' + Stime +' Etime ' + Etime );
            String sttm=(String)Stime.get('dateTime');
            Boolean IsAllDayEvent = false;
            if(sttm == null)                     // In case of a All day event
            {
                sttm = (String)Stime.get('date');
                sttm = sttm+' 00:00:00';
                Datetime alldt=DateTime.valueOf(sttm);
                Integer hh1= (tz.getOffset(alldt))/(1000*60);
                sttm = string.valueof(alldt.addMinutes(-hh1));
                sttm = sttm.replace(' ','T');
                sttm =sttm+'Z';
             }
            sttm=sttm.replace('T',' ');
            sttm=sttm.replace('Z','');

            String entm=(String)Etime .get('dateTime');
            if(entm == null)                     // In case of a All day event
            {
                entm=(String)Etime .get('date');
                entm = entm+' 00:00:00';
                Datetime alldt=DateTime.valueof(entm);
                Integer hh1= (tz.getOffset(alldt))/(1000*60);
                entm = string.valueof(alldt.addMinutes(-hh1));
                entm= entm.replace(' ','T');
                entm = entm+'Z';
            }
            entm=entm.replace('T',' ');
            entm=entm.replace('Z','');

// Logic for get the recurring event info. from response
            String condition;
            system.debug('RecRule => '+RecRule);
            for(Object recobj:RecRule){
                String rc=(String)recobj;
                system.debug('recobj => '+recobj);
                if(rc.contains('RRULE')){
                    condition=rc;
                }
                //condition=(String)RecRule.get(0);
            }
            condition=condition.replace('RRULE:','');
            String [] con_array= condition.split(';',4);

// Google recurring event is created and assign the values in object
            Google_Recurring_Events__c GObj= new Google_Recurring_Events__c();
            if(((String)Event_item.get('summary'))!=null){
                if(((String)Event_item.get('summary')).length()>=80)
                {
                GObj.Name=((String)Event_item.get('summary')).left(79);
                }
                else{
                GObj.Name=(String)Event_item.get('summary');
                }

               if(((String)Event_item.get('summary')).length()>=255)
               {
               GObj.Summary__c=((String)Event_item.get('summary')).left(250);
               }else
               {
               GObj.Summary__c=(String)Event_item.get('summary');
               }
            }
            GObj.Description__c=(String)Event_item.get('description');
            GObj.Start_Date__c=DateTime.valueOfGmt(sttm);
            GObj.End_date__c=DateTime.valueOfGmt(entm);
            GObj.Google_Event_Id__c=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,sttm);
            GObj.Recurring_Events__c=true;
            GObj.Broker__c=bobject.id;
            if(User_Eml_Id_Map.containsKey(bobject.Email__c))
            {
                GObj.Assigned_To__c=User_Eml_Id_Map.get(bobject.Email__c);
            }
            Gobj.Last_Event_Date__c=DateTime.valueOfGmt(sttm);
            if(con_array.size()==1){
                GObj.Interval__c =1;
            }
            Integer Interval,Count;
            String g_res=condition.replace('RRULE:','');

// Condition for get the interval between the event
            if(con_array.size()>2)
             {
                if(con_array[2].contains('INTERVAL='))
                {
                    String qt=con_array[2];
                    GObj.Interval__c =Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                }
                else
                {
                    if(con_array[1].contains('INTERVAL=')&&con_array[2].contains('BYDAY='))
                    {
                        String qt=con_array[1];
                        GObj.Interval__c=Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                    }
                    else
                    {
                        GObj.Interval__c =1;
                    }
                }
             }

            if(con_array.size()==2)
            {
                if(con_array[1].contains('INTERVAL='))
                {
                    String qt=con_array[1];
                    GObj.Interval__c=Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                }
                else
                {
                    GObj.Interval__c=1;
                }
            }

            String []dayarray;

// Condition if event  repeat on weekday
            if(g_res.contains('BYDAY='))
            {
                Integer i=g_res.indexOf('BYDAY');
                system.debug(i);
                integer j=i+6;
                string qt=g_res.substring(i,g_res.length());
                system.debug(qt);
                qt= qt.replace('BYDAY=','');
                String byday=qt.replace(',',';');
                GObj.ByDay__c= byday;
            }

// Condition how many times Event will be repeated(Count)
             if(con_array.size()>=2)
            {
                if(con_array[1].contains('COUNT='))
                {
                    String qt=con_array[1];
                    GObj.Count__c=Integer.ValueOf(String.valueOf(qt.replace('COUNT=','')));
                    system.debug(GObj.Count__c);
                }
            }

// Condition for last date event will be repeated(UNTIL)
            if( con_array.size()>=2)
            {
                if(con_array[1].contains('UNTIL='))
                {
                    String datetm=con_array[1].replace('UNTIL=','');
                    String st='';
                    if(datetm.length()>8){
                    st=datetm.substring(0,4)+'-'+datetm.substring(4,6)+'-'+datetm.substring(6,11)+':'+datetm.substring(11,13)+':'+datetm.substring(13,16);
                    st=st.replace('T',' ');
                    st=st.replace('Z','');
                   }
                    else
                    {
                    st=datetm.substring(0,4)+'-'+datetm.substring(4,6)+'-'+datetm.substring(6,8)+' 00:00:00';

                    }
                    GObj.Until__c=DateTime.valueOfGmt(st);
                }
            }

// Condition if event is a weekly Event
            if(con_array[0]=='FREQ=WEEKLY')
            {
                String resday=condition.replace('RRULE:','');

                if(!resday.contains('BYDAY='))
                {
                    String byd=(GObj.Start_Date__c).format('E').left(2);
                    GObj.ByDay__c=byd.toUpperCase();
                    System.debug(byd+'hhhhhh'+GObj.ByDay__c);
                }
                GObj.Freq__c='WEEKLY';
             }

// Condition if event is a daily event
            if(con_array[0]=='FREQ=DAILY')
            {
                GObj.Freq__c='DAILY';
            }

// Condition if event is a Monthly Event
            if(con_array[0]=='FREQ=MONTHLY')
             {
                if(g_res.contains('BYDAY='))
                {
                    Integer i=g_res.indexOf('BYDAY');
                    system.debug(i);
                    integer j=i+6;
                    string qt=g_res.substring(i,g_res.length());
                    system.debug(qt);
                    String bydayst = qt.replace('BYDAY=','');
                    if(bydayst.contains('-1'))
                    {
                        GObj.Repeats_on__c=(String)bydayst.substring(0,2);
                        GObj.ByDay__c=bydayst.substring(2);
                        system.debug( GObj.Repeats_on__c+'hhhhhhh'+GObj.ByDay__c);
                    }
                    else
                    {
                        GObj.Repeats_on__c=(String)bydayst.substring(0,1);
                        GObj.ByDay__c=bydayst.substring(1);
                        system.debug( GObj.Repeats_on__c+'hhhhhhh'+GObj.ByDay__c);
                    }
                 }
                GObj.Freq__c='MONTHLY';
             }

// Condition if Event is a yealy Event
            if(con_array[0]=='FREQ=YEARLY')
            {
               GObj.Freq__c='YEARLY';
            }

      glist.add(GObj);

       }
    }

  else
       {
        if(Stime != null && Etime != null && (String)Event_item.get('status')!='cancelled')
        {
            System.debug('Stime ' + Stime +' Etime ' + Etime );

//Logic to Convert the event start and End  DateTime in the specific format as required to assign th event Start And End time
            String sttm=(String)Stime.get('dateTime');
            Boolean IsAllDayEvent = false;

            if(sttm == null)             // In case of a All day event
            {
                sttm = (String)Stime.get('date');
                sttm = sttm+' 00:00:00';
                Datetime alldt=DateTime.valueOf(sttm);
                Integer hh1= (tz.getOffset(alldt))/(1000*60);
                sttm = string.valueof(alldt.addMinutes(-hh1));
                sttm = sttm.replace(' ','T');
                sttm =sttm+'Z';
            }
            sttm=sttm.replace('T',' ');
            sttm=sttm.replace('Z','');

            String entm=(String)Etime .get('dateTime');
            if(entm == null) // In case of a All day event
            {
                entm=(String)Etime .get('date');
                entm = entm+' 00:00:00';
                Datetime alldt=DateTime.valueof(entm);
                Integer hh1= (tz.getOffset(alldt))/(1000*60);
                entm = string.valueof(alldt.addMinutes(-hh1));
                entm= entm.replace(' ','T');
                entm = entm+'Z';
            }
            entm=entm.replace('T',' ');
            entm=entm.replace('Z','');

            Event e= new Event();    // Event object Is Created

// Assign the values in the event object
          if(((String)Event_item.get('summary'))!=null){
                if(((String)Event_item.get('summary')).length()>=255)
                   {
                       e.Subject=((String)Event_item.get('summary')).left(250);
                   }else
                   {
                       e.Subject=(String)Event_item.get('summary');
                   }
             }
       // e.Subject=(String)Event_item.get('summary');
           if(User_Eml_Id_Map.containsKey(bobject.Email__c)){
                e.ownerid=User_Eml_Id_Map.get(bobject.Email__c);
            }
            e.whatid=bobject.id;
            e.Description=(String)Event_item.get('description');
            e.Google_Event_ID__c=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,sttm);
            e.StartDateTime=DateTime.valueOfGmt(sttm);
            e.EndDateTime=DateTime.valueOfGmt(entm);
            e.IsAllDayEvent = IsAllDayEvent ;
            if(e.EndDateTime <e.StartDateTime.addDays(1)){
                Event_list.add(e);                          // Add event in the List
            }

// condition if event is more than one day
        if(DateTime.valueOfGmt(sttm).adddays(1) <=DateTime.valueOfGmt(entm)){
            Google_Recurring_Events__c GObj= new Google_Recurring_Events__c();

            if(((String)Event_item.get('summary'))!=null)
             {
                if(((String)Event_item.get('summary')).length()>=80)
                {
                    GObj.Name=((String)Event_item.get('summary')).left(79);
                }
                else{
                    GObj.Name=(String)Event_item.get('summary');
                }

               if(((String)Event_item.get('summary')).length()>=255)
               {
                   GObj.Summary__c=((String)Event_item.get('summary')).left(250);
               }else
               {
                   GObj.Summary__c=(String)Event_item.get('summary');
               }
             }
            GObj.Description__c=(String)Event_item.get('description');
            GObj.Start_Date__c=DateTime.valueOfGmt(sttm);
            GObj.End_date__c=DateTime.valueOfGmt(entm);
            GObj.Google_Event_Id__c=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,sttm);
            GObj.Multiday__c=true;
            GObj.Broker__c=bobject.id;
            if(User_Eml_Id_Map.containsKey(bobject.Email__c)){
                GObj.Assigned_To__c=User_Eml_Id_Map.get(bobject.Email__c);
            }
            glist.add(GObj);
            system.debug('AMIT'+GObj);
        }

     }
     }

    }
  }


// condition for delete Mutliday Event and Recur Event and Google Event object from salesforce
          Set<Id> GobjId_set= new Set<ID>();
           cancel_Geventlist=[select id from Google_Recurring_Events__c where (Multiday__c=true OR   Recurring_Events__c=true) AND Google_Event_Id__c in : deleteEvent_IDset];
           system.debug('HHHH'+cancel_Geventlist);
           if(cancel_Geventlist.size()>0){
                 for(Google_Recurring_Events__c obj :cancel_Geventlist ){
                        GobjId_set.add(obj.id);
                        googleEventlst.add(obj);
                 }
           }
           List<Event> Evtobj1= [select id from Event where Event_ID__c in :GobjId_set];
           if(Evtobj1.size()>0){
               for(Event evt : Evtobj1){
                   system.debug('EEEE'+Evtobj1);
                   del_list.add(evt);
               }
           }


//  This is a recursion condition and assign the nextsynctoken to the broker nextsynctoken field
        if(Stoken.nextSyncToken != null){
            bobject.Next_Sync_Token__c =Stoken.nextSyncToken;
            return;
        }
        else if(nextpageToken!=null){
            callgoogleAPI(bobject);
        }
  }
    Public Class Claimset
    {
     Public String iss;
     Public String scope;
     Public String aud;
     Public String exp;
     Public String iat;
     Public String sub;
     }
    public class TokenParse
    {
        public String access_token;
        public String token_type;
        public Integer expires_in;
    }

    public class InsertEventslist1Exception extends Exception {
    }

    public class InsertEventslist2Exception extends Exception {
    }

}