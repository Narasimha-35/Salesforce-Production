// ----------------------------------------------------------------------------------
// This class Used For Return the Event List

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       15-June-2015      Ashutosh Kumar         Initial version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------

public class Saasfocus_GetGoogleEvent
{
    public Set<String> deleteEvent_IDset= new Set<String>();
    public Set<String> deleteEvent_RecurIDset= new Set<String>();
    public List<Event> cancel_event_list= new List<Event>();
    Public List<Google_Recurring_Events__c> googleEventlst= new List<Google_Recurring_Events__c>();
    Public List<Google_Recurring_Events__c> cancel_Geventlist= new List<Google_Recurring_Events__c>();
    List<Event> del_list= new List<Event>();
    public set<String> recid_set= new set<String>();
    Public String request {get;set;}
    public Saasfocus_GenerateToken ob{get;set;}
    public List<Event>Evt_list = new List<Event>();
    Public List<Google_Recurring_Events__c> glist= new List<Google_Recurring_Events__c>();

    // This Method is used for get the Event from the Google Calender and return the list of events
    public List<Saasfocus_EventClass> getEventslist(DateTime StartDateTime ,DateTime EndDateTime, String BrokerId, SaaSFocus_AppointmentController_beta.Busy b)
    {
        System.debug('NEESTARTTIME'+StartDateTime );
        TimeZone tz = UserInfo.getTimeZone();

        // Call the CheckAccessToken Method of GenerateToken_Saasfocus class for checking the access token is valid or not
        ob= new Saasfocus_GenerateToken();
        Google_API_Setting__c  obj= ob.CheckAccessToken();

        // Convert the Provided DateTime in the specific format as required in the endpoint URL
        String Starttime= String.valueOfGMT(StartDateTime );
        Starttime= Starttime.trim();
        Starttime= Starttime.replace(' ','T');
        Starttime= Starttime+'Z';

        String endtime = String.valueOfGMT(EndDateTime);
        endtime = endtime.trim();
        endtime = endtime.replace(' ','T');
        endtime = endtime+'Z';
        System.debug(Starttime+'ENDTIME'+endtime);

        List<Saasfocus_EventClass> Event_list= new List<Saasfocus_EventClass>();
        List<Object> items = new List<Object>();

        // Get the List of Broker
        list<Broker__c> broker_list =[select id,Email__c from Broker__c where id =: BrokerId];

        // Logic for get the Google calender Event
        for(Broker__c bobject : broker_list )
        {
            string Endpoint = 'https://www.googleapis.com/calendar/v3/calendars/'+bobject.Email__c+'/events?access_token='+obj.Access_Token__c+'&timeMin='+Starttime+'&timeMax='+endtime+'&timeZone=GMT';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Endpoint);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+obj.Access_Token__c);
            req.setMethod('GET');
            request = req.getBody();
            Http http = new Http();
            Httpresponse res = http.send(req);
            System.debug('GOOGLE CALENDER RESPONSE::::::'+res.getBody());

            b.busyItems = GoogleCalendarUtility.getListOfBusyItems(StartDateTime, EndDateTime, bobject.Email__c);
            b.isBusy = b.busyItems.size() > 0;
            b.brokerEmail = bobject.Email__c;
            System.debug(LoggingLevel.INFO, 'the account: ' + bobject.Email__c + ' @: ' + StartDateTime + ' to ' + EndDateTime + ' isBusy: ' + b.isBusy);
            GoogleCalendarUtility.updateGoogleSetting();

            // Check If Google Calender Contains Events or Not
            if((res.getBody().contains('items'))) {
                Map<String, Object> EventRes = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                items = (List<Object>)EventRes.get('items');

                Map<String,Id>  User_Eml_Id_Map= new Map<String,Id>();  // Create Map of user email and id
                List<User>  Ulist= [select id,Email from User ];     // Create List of User for getting the id and Email

                for (User u_obj : Ulist) {
                    User_Eml_Id_Map.put(u_obj.Email, u_obj.id);  // add email id in the map
                }

                for (Object item : items) {
                    Map<String, Object> Event_item = (Map<String, Object>)item;
                    Map<String,Object>Stime =(Map<String,Object>)(Event_item .get('start'));
                    Map<String,Object>Etime =(Map<String,Object>)(Event_item .get('end'));
                    List<object> RecRule=(List<Object>)(Event_item .get('recurrence'));

                    // Condition if single event, multiday and recurring event is Delete from google calender
                    if((String)Event_item.get('status')=='cancelled') {
                        deleteEvent_IDset.add(Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'data'));
                        system.debug('HHHHHHI'+deleteEvent_IDset);
                    }
                    if(/*(String)Event_item.get('status')=='cancelled'  && */ Event_item.get('recurringEventId')!=null) {
                        recid_set.add(Saasfocus_Global.setGoogleId((String)Event_item.get('recurringEventId'),bobject.Email__c,'data'));
                    }

                    // Create Event Class Object and assign the event Broker Email Id, Starttime and End Time
                    Saasfocus_EventClass e= new Saasfocus_EventClass();
                    //e.Email=(String)bobject.Email__c;
                    if(RecRule != null) {
                        if(Stime != null && Etime != null && (String)Event_item.get('status')!='cancelled') {
                            //Logic to Convert the event start and End  DateTime in the specific format as required to assign th event Start And End time
                            System.debug('Stime ' + Stime +' Etime ' + Etime );
                            String sttm=(String)Stime.get('dateTime');
                            Boolean IsAllDayEvent = false;
                            // In case of a whole day event
                            if(sttm == null) {
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
                            // In case of a whole day event
                            if(entm == null) {
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

                            // Assign the values in Saasfocus_EventClass Object and add object in the list
                            e.Email=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'date');
                            if(e.Email.contains('_R')) {
                                e.Email=e.Email.substringBefore('_R')+'~'+bobject.Email__c;
                            } else {
                                e.Email=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'date');
                            }
                            e.StartDateTime = sttm;
                            e.EndDateTime = entm;
                            // Event_list.add(e);

                            String condition;
                            for(Object recobj:RecRule) {
                                String rc=(String)recobj;
                                system.debug('recobj => '+recobj);
                                if(rc.contains('RRULE')) {
                                    condition = rc;
                                }
                            }
                            condition=condition.replace('RRULE:','');
                            String [] con_array= condition.split(';',4);

                            Google_Recurring_Events__c GObj= new Google_Recurring_Events__c();
                            if(((String)Event_item.get('summary'))!=null) {
                                if(((String)Event_item.get('summary')).length()>=80) {
                                    GObj.Name=((String)Event_item.get('summary')).left(79);
                                } else {
                                    GObj.Name=(String)Event_item.get('summary');
                                }

                                if(((String)Event_item.get('summary')).length()>=255) {
                                    GObj.Summary__c=((String)Event_item.get('summary')).left(250);
                                } else {
                                    GObj.Summary__c=(String)Event_item.get('summary');
                                }
                            }
                            GObj.Description__c=(String)Event_item.get('description');
                            GObj.Start_Date__c=DateTime.valueOfGmt(sttm);
                            GObj.End_date__c=DateTime.valueOfGmt(entm);
                            GObj.Google_Event_Id__c=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,sttm);
                            GObj.Recurring_Events__c=true;
                            GObj.Broker__c=bobject.id;

                            if(User_Eml_Id_Map.containsKey(bobject.Email__c)) {
                                GObj.Assigned_To__c=User_Eml_Id_Map.get(bobject.Email__c);
                            }
                            Gobj.Last_Event_Date__c=DateTime.valueOfGmt(sttm);

                            if(con_array.size()==1) {
                                GObj.Interval__c=1;
                            }

                            Integer Interval,Count;
                            String g_res=condition.replace('RRULE:','');

                            //Condition For Interval between Events
                            if(con_array.size()>2) {
                                if(con_array[2].contains('INTERVAL=')) {
                                    String qt=con_array[2];
                                    GObj.Interval__c =Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                                } else {
                                    if(con_array[1].contains('INTERVAL=')&&con_array[2].contains('BYDAY=')) {
                                        String qt=con_array[1];
                                        GObj.Interval__c=Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                                    } else {
                                        GObj.Interval__c =1;
                                    }
                                }
                            }

                            if(con_array.size()==2) {
                                if(con_array[1].contains('INTERVAL=')) {
                                    String qt=con_array[1];
                                    GObj.Interval__c=Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                                } else {
                                    GObj.Interval__c=1;
                                }
                            }
                            // Condition For Day Of the week(BYDAY)
                            String []dayarray;
                            if(g_res.contains('BYDAY=')) {
                                Integer i=g_res.indexOf('BYDAY');
                                system.debug(i);
                                integer j=i+6;
                                string qt=g_res.substring(i,g_res.length());
                                system.debug(qt);
                                qt= qt.replace('BYDAY=','');
                                String byday=qt.replace(',',';');
                                GObj.ByDay__c= byday;
                            }

                            // Condition for No. of Events(Count)
                            if(con_array.size()>=2) {
                                if(con_array[1].contains('COUNT=')) {
                                    String qt=con_array[1];
                                    GObj.Count__c=Integer.ValueOf(String.valueOf(qt.replace('COUNT=','')));
                                    system.debug(GObj.Count__c);
                                }
                            }

                            // Condition for late Event Date(UNTIL)
                            if( con_array.size()>=2) {
                                if(con_array[1].contains('UNTIL=')) {
                                    String datetm=con_array[1].replace('UNTIL=','');
                                    String st='';
                                    if(datetm.length()>8) {
                                        st=datetm.substring(0,4)+'-'+datetm.substring(4,6)+'-'+datetm.substring(6,11)+':'+datetm.substring(11,13)+':'+datetm.substring(13,16);
                                        st=st.replace('T',' ');
                                        st=st.replace('Z','');
                                    } else {
                                        st=datetm.substring(0,4)+'-'+datetm.substring(4,6)+'-'+datetm.substring(6,8)+' 00:00:00';
                                    }
                                    GObj.Until__c=DateTime.valueOfGmt(st);
                                }
                            }

                            // Condition for Weekly Event
                            if(con_array[0]=='FREQ=WEEKLY') {
                                String resday=condition.replace('RRULE:','');
                                if(!resday.contains('BYDAY=')) {
                                    String byd=(GObj.Start_Date__c).format('E').left(2);
                                    GObj.ByDay__c=byd.toUpperCase();
                                    System.debug(byd+'hhhhhh'+GObj.ByDay__c);
                                }
                                GObj.Freq__c='WEEKLY';
                            }

                            // Condition for Daily Event
                            if(con_array[0]=='FREQ=DAILY') {
                                GObj.Freq__c='DAILY';
                            }

                            // Condition for Monthly Event
                            if(con_array[0]=='FREQ=MONTHLY') {
                                if(g_res.contains('BYDAY=')) {
                                    Integer i=g_res.indexOf('BYDAY');
                                    system.debug(i);
                                    integer j=i+6;
                                    string qt=g_res.substring(i,g_res.length());
                                    system.debug(qt);
                                    String bydayst = qt.replace('BYDAY=','');
                                    if(bydayst.contains('-1')){
                                        GObj.Repeats_on__c=(String)bydayst.substring(0,2);
                                        GObj.ByDay__c=bydayst.substring(2);
                                        system.debug( GObj.Repeats_on__c+'hhhhhhh'+GObj.ByDay__c);
                                    } else {
                                        GObj.Repeats_on__c=(String)bydayst.substring(0,1);
                                        GObj.ByDay__c=bydayst.substring(1);
                                        system.debug( GObj.Repeats_on__c+'hhhhhhh'+GObj.ByDay__c);
                                    }
                                }
                                GObj.Freq__c='MONTHLY';
                            }

                            // Condition for Yearly Event
                            if(con_array[0]=='FREQ=YEARLY') {
                                GObj.Freq__c='YEARLY';
                            }

                            if(GObj.Until__c!=null) {
                                if(GObj.Until__c>system.today()){
                                    Event_list.add(e);
                                }
                            } else {
                                Event_list.add(e);
                            }
                            // Add Recurring Event in the List here
                            glist.add(GObj);

                        }
                    } else {
                        if(Stime != null && Etime != null && (String)Event_item.get('status')!='cancelled') {
                            System.debug('Stime ' + Stime +' Etime ' + Etime );

                            //Logic to Convert the event start and End  DateTime in the specific format as required to assign th event Start And End time
                            String sttm=(String)Stime.get('dateTime');
                            Boolean IsAllDayEvent = false;
                            // In case of a whole day event
                            if(sttm == null) {
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
                            // In case of a whole day event
                            if(entm == null) {
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

                            // Assign the values in Saasfocus_EventClass Object and add object in the list
                            // e.Email=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'date');
                            if(((String)Event_item.get('id')).contains('_')) {
                                e.Email=((String)Event_item.get('id')).substringBefore('_')+'~'+bobject.Email__c;
                            } else {
                                e.Email=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'date');
                            }
                            e.StartDateTime=sttm;
                            e.EndDateTime=entm;
                            Event_list.add(e);

                            Event enr= new Event();                            // Event object Is Created Here

                            //Condition for Single Event and Assign the values in the event object
                            if(((String)Event_item.get('summary'))!=null) {
                                if(((String)Event_item.get('summary')).length()>=255) {
                                    enr.Subject=((String)Event_item.get('summary')).left(250);
                                } else {
                                    enr.Subject=(String)Event_item.get('summary');
                                }
                            }
                            // enr.Subject=(String)Event_item.get('summary');
                            enr.Description=(String)Event_item.get('description');
                            if(User_Eml_Id_Map.containsKey(bobject.Email__c)) {
                                enr.ownerid=User_Eml_Id_Map.get(bobject.Email__c);                 // Assign to its owner
                            }

                            enr.whatid=bobject.id;
                            enr.Google_Event_ID__c=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,sttm);
                            enr.StartDateTime=DateTime.valueOfGmt(sttm);
                            enr.EndDateTime=DateTime.valueOfGmt(entm);
                            enr.IsAllDayEvent = IsAllDayEvent ;

                            if(enr.EndDateTime < enr.StartDateTime.addDays(1)) {
                                Evt_list.add(enr);  // Add event in the List
                            }

                            // Condition For Multiday Event
                            if(DateTime.valueOfGmt(sttm).adddays(1) <=DateTime.valueOfGmt(entm)) {
                                Google_Recurring_Events__c GObj= new Google_Recurring_Events__c();
                                if(((String)Event_item.get('summary'))!=null) {
                                    if(((String)Event_item.get('summary')).length()>=80) {
                                        GObj.Name=((String)Event_item.get('summary')).left(79);
                                    } else {
                                        GObj.Name=(String)Event_item.get('summary');
                                    }

                                    if(((String)Event_item.get('summary')).length()>=255) {
                                        GObj.Summary__c=((String)Event_item.get('summary')).left(250);
                                    } else {
                                        GObj.Summary__c=(String)Event_item.get('summary');
                                    }
                                }
                                GObj.Description__c=(String)Event_item.get('description');
                                GObj.Start_Date__c=DateTime.valueOfGmt(sttm);
                                GObj.End_date__c=DateTime.valueOfGmt(entm);
                                GObj.Google_Event_Id__c=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,sttm);
                                GObj.Multiday__c=true;
                                GObj.Broker__c=bobject.id;
                                if(User_Eml_Id_Map.containsKey(bobject.Email__c)) {
                                    GObj.Assigned_To__c=User_Eml_Id_Map.get(bobject.Email__c);
                                }
                                glist.add(GObj);
                            }
                        }
                    }
                }
            }
        }

        // condition for delete Mutliday Event and Recur Event and Google Event object from salesforce
        Set<Id> GobjId_set= new Set<ID>();
        cancel_Geventlist=[select id from Google_Recurring_Events__c where (Multiday__c=true OR   Recurring_Events__c=true) AND Google_Event_Id__c in : deleteEvent_IDset];
        system.debug('HHHH'+cancel_Geventlist);
        if(cancel_Geventlist.size()>0) {
            for(Google_Recurring_Events__c obj2 :cancel_Geventlist ) {
                GobjId_set.add(obj2.id);
                googleEventlst.add(obj2);
            }
        }
        List<Event> Evtobj1= [select id from Event where Event_ID__c in :GobjId_set];
        if(Evtobj1.size()>0) {
            for(Event evt : Evtobj1) {
                system.debug('EEEE'+Evtobj1);
                del_list.add(evt);
            }
        }
        // upsert  glist Google_Event_Id__c;

        // Condition if Event is update, delete previous event and insert new Event
        try{
            Set<string> st = new Set<string>();
            List<Google_Recurring_Events__c> lstREinsert = new List<Google_Recurring_Events__c>();
            for(Google_Recurring_Events__c ob11 :glist){
                st.add(ob11.Google_Event_Id__c);
                Google_Recurring_Events__c g_obj = new Google_Recurring_Events__c();
                g_obj.Name=ob11.Name;
                g_obj.Start_date__c=ob11.Start_date__c;
                g_obj.End_date__c=ob11.End_date__c;
                g_obj.Summary__c=ob11.Summary__c;
                g_obj.Google_Event_Id__c=ob11.Google_Event_Id__c;
                g_obj.Description__c=ob11.Description__c;
                g_obj.Broker__c=ob11.Broker__c;
                if(ob11.Multiday__c==true){
                    g_obj.Multiday__c=true;
                } else {
                    g_obj.Recurring_Events__c=true;
                    g_obj.Repeats_on__c=ob11.Repeats_on__c;
                    if(ob11.ByDay__c!=null){
                        g_obj.ByDay__c=ob11.ByDay__c;
                    }
                    if(ob11.Count__c!=null){
                        g_obj.Count__c=ob11.Count__c;
                    }
                    if(ob11.Until__c!=null){
                        g_obj.Until__c=ob11.Until__c;
                    }
                    g_obj.Freq__c=ob11.Freq__c;
                    g_obj.Interval__c=ob11.Interval__c;
                }

                if(ob11.Assigned_To__c!=null) {
                    g_obj.Assigned_To__c=ob11.Assigned_To__c;
                }
                lstREinsert.add(g_obj);
            }
            List<Event> lstEvent = new List<Event>();
            List<Google_Recurring_Events__c> lstRE = new List<Google_Recurring_Events__c>();
            lstRE = [select id,Google_Event_ID__c from Google_Recurring_Events__c where Google_Event_Id__c in :st];
            st = new Set<string>();
            for(Google_Recurring_Events__c ob22 :lstRE){
                st.add(ob22.id);
            }

            lstEvent = [select id from Event where Event_ID__c in :st];
            if(lstEvent.size() > 0) {
                delete lstEvent;
            }
            if(lstRE.size() > 0) {
                delete lstRE;
            }
            List<Google_Recurring_Events__c> lstREC1 = new List<Google_Recurring_Events__c>();
            if(lstREinsert.size() > 0){
                for(Google_Recurring_Events__c ob :lstREinsert) {
                    lstREC1.add(ob);
                }
                //insert lstREC1;
                if(lstREC1.size()>0) {
                    insert lstREinsert;
                }
            }
        } catch(Exception e){
            system.debug('!Bingo error=> '+e);
        }
        System.debug('RECLIST'+glist);
        upsert Evt_list Google_Event_ID__c ;
        System.debug('OUT'+Event_list);

        // Condition delete events from salesforce
        cancel_event_list= [select id from Event where Google_Event_ID__c in : deleteEvent_IDset];
        system.debug('HHHHHHI'+cancel_event_list);
        if(cancel_event_list.size()>0) {
            for(Event evtobj:cancel_event_list) {
                del_list.add(evtobj);
            }
        }

        if(del_list.size()>0) {
            Set<Event> myset = new Set<Event>();
            List<Event> result = new List<Event>();
            for (Event s : del_list) {
                if(myset.contains(s) == false) {
                    myset.add(s);
                    result.add(s);
                }
                system.debug('RRR'+result);
            }
            delete result;
        }

        // Delete Google recurring Event object from salesforce
        try{
            if(googleEventlst.size()>0) {
                Set<Google_Recurring_Events__c> myset = new Set<Google_Recurring_Events__c>();
                List<Google_Recurring_Events__c> result = new List<Google_Recurring_Events__c>();
                for (Google_Recurring_Events__c s : googleEventlst) {
                    if(myset.contains(s) == false) {
                        myset.add(s);
                        result.add(s);
                    }
                    system.debug('RRR'+result);
                }
                delete result;
            }
        }
        catch(Exception e){
            system.debug('!Bingo delete error=> '+e);
        }

        list<Saasfocus_EventClass> elist = new List<Saasfocus_EventClass>();
        for(Saasfocus_EventClass et : Event_list) {
            system.debug(deleteEvent_IDset+'kkkkkkkk'+et.email+':::::'+recid_set);
            if(!deleteEvent_IDset.contains(et.email) && !recid_set.contains(et.email)) {
                String []Idarray=(et.Email).split('~');
                et.email=Idarray[1];
                elist.add(et);
            }
        }
        system.debug('RRRTURN'+elist);
        return elist;
    }
}
