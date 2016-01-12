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
    public set<DateTime> Single_eventSet= new Set<Datetime>();
    public List<Event> cancel_event_list= new List<Event>();
    Public List<Google_Recurring_Events__c> googleEventlst= new List<Google_Recurring_Events__c>();
    Public List<Google_Recurring_Events__c> cancel_Geventlist= new List<Google_Recurring_Events__c>();
     List<Event> del_list= new List<Event>();
    public set<String> recid_set= new set<String>();
    Public String request {get;set;}
    Public String resbody{get;set;}
    public string Accesstoken{get;set;}
    Public String Starttime;
    Public String endtime;
    public Saasfocus_GenerateToken ob{get;set;}
    public List<Event>Evt_list = new List<Event>();
    Public List<Google_Recurring_Events__c> glist= new List<Google_Recurring_Events__c>();
    
 // This Method is used for get the Event from the Google Calender and return the list of events   
   
  public List<Saasfocus_EventClass> getEventslist(DateTime StartDateTime ,DateTime EndDateTime, String BrokerId )
    {
              
             Saasfocus_Global.GoogleSyncProces=True;
              System.debug('NEESTARTTIME'+StartDateTime );
              
        // Call the CheckAccessToken Method of GenerateToken_Saasfocus class for checking the access token is valid or not     
             
             ob= new Saasfocus_GenerateToken();
             Google_API_Setting__c  obj= ob.CheckAccessToken();
              
        // Convert the Provided DateTime in the specific format as required in the endpoint URL
          String Starttime= String.valueOfGMT(StartDateTime );
                
              Starttime= Starttime.trim();
              Starttime= Starttime.replace(' ','T');
              Starttime= Starttime+'Z';
              System.Debug('STARTTIME'+Starttime);
              
              DateTime ddate=(StartDateTime.addHours(1));
              
           
           String endtime = String.valueOfGMT(EndDateTime);
              
              endtime = endtime.trim();
              endtime = endtime.replace(' ','T');
              endtime = endtime+'Z';
               System.debug('ENDTIME'+endtime); 
             
             /*  TimeZone tz= UserInfo.getTimeZone();
               Integer sec= (tz.getOffset(StartDateTime))/1000;
               System.Debug('OFFSET'+sec);
               StartDateTime=StartDateTime.addSeconds(sec);
                
               
                Integer hh=StartDateTime.hour();
                Integer mm=StartDateTime.minute();
                Integer ss=StartDateTime.second(); 
                StartDateTime =StartDateTime.addhours(-hh);
                StartDateTime =StartDateTime.addMinutes(-mm);
                StartDateTime =StartDateTime.addSeconds(-ss);
                String Starttime= String.valueOf(StartDateTime );
                
                  Starttime= Starttime.trim();
                  Starttime= Starttime.replace(' ','T');
                  Starttime= Starttime+'Z';
                  System.debug('STARTTIME'+Starttime);
           
                  DateTime ddate=(StartDateTime.addHours(24));
            
              endtime = String.valueOf(ddate);
              
              endtime = endtime.trim();
              endtime = endtime.replace(' ','T');
              endtime = endtime+'Z';
               System.debug('ENDTIME'+endtime); */
              List<Saasfocus_EventClass> Event_list= new List<Saasfocus_EventClass>();
              
              resbody=' ';
            
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
             resbody = res.getBody();
         
    
           System.debug('GOOGLE CALENDER RESPONSE::::::'+resbody);
            
         
         
       // Check If Google Calender Contains Events or Not  
        
         if((res.getBody().contains('items')))
           {   
       
         Map<String, Object> EventRes = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
         
            items = (List<Object>)EventRes.get('items');
            
           Map<String,Id>  User_Eml_Id_Map= new Map<String,Id>();  // Create Map of user email and id
             List<User>  Ulist= [select id,Email from User ];     // Create List of User for getting the id and Email
              
              for (User u_obj : Ulist) 
              {
            
                User_Eml_Id_Map.put(u_obj.Email, u_obj.id);  // add email id in the map
            
              } 
            
          
           for (Object item : items) {
          
            Map<String, Object> Event_item = (Map<String, Object>)item;
            Map<String,Object>Stime =(Map<String,Object>)(Event_item .get('start'));
            Map<String,Object>Etime =(Map<String,Object>)(Event_item .get('end'));
           List<object> RecRule=(List<Object>)(Event_item .get('recurrence'));
           
         //  if(Event_item.get('status')=='cancelled')
          //    continue;
             // Condition if single event, multiday and recurring event is Delete from google calender         
       if((String)Event_item.get('status')=='cancelled'){
            deleteEvent_IDset.add(Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'data'));
            system.debug('HHHHHHI'+deleteEvent_IDset);
          }
          if((String)Event_item.get('status')=='cancelled' && Event_item.get('recurringEventId')!=null)
            {
               recid_set.add(Saasfocus_Global.setGoogleId((String)Event_item.get('recurringEventId'),bobject.Email__c,'data'));
            }
            
            Saasfocus_EventClass e= new Saasfocus_EventClass();   // Create Event Class Object and assign the event Broker Email Id, Starttime and End Time
           
           // e.Email=(String)Event_item.get('id')+'~'+(String)bobject.Email__c;
            if(RecRule != null)
           {
                 if(Stime != null && Etime != null)
           {
            
       //Logic to Convert the event start and End  DateTime in the specific format as required to assign th event Start And End time 
            System.debug('Stime ' + Stime +' Etime ' + Etime );
            String sttm=(String)Stime.get('dateTime');
           
           Boolean IsAllDayEvent = false;
           
            if(sttm == null) // In case of a whole day event
            {
                sttm = (String)Stime.get('date');
                sttm = sttm+' 00:00:00';
               // IsAllDayEvent =true;
                Datetime alldt=DateTime.valueOf(sttm);
                sttm = string.valueof(alldt.addhours(-10));
                sttm = sttm.replace(' ','T');
                sttm =sttm+'Z';
            }
            
            
            sttm=sttm.replace('T',' ');
            sttm=sttm.replace('Z','');
           
            String entm=(String)Etime .get('dateTime');
            
            if(entm == null) // In case of a whole day event
            {
                entm=(String)Etime .get('date');
                entm = entm+' 00:00:00';
                Datetime alldt=DateTime.valueof(entm);
                entm = string.valueof(alldt.addhours(-10));
                entm= entm.replace(' ','T');
                entm = entm+'Z';
            }
            
            entm=entm.replace('T',' ');
            entm=entm.replace('Z','');
           String condition;
            for(Object recobj:RecRule)
              {
                String rc=(String)recobj;              
              system.debug('recobj => '+recobj);
                  if(rc.contains('RRULE'))
                  {
                    condition=rc;
                  }
                 //condition=(String)RecRule.get(0);
              }
            
           // String condition=(String)RecRule.get(0);
            condition=condition.replace('RRULE:','');
            String [] con_array= condition.split(';',4);
            
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
               
               if(con_array.size()==1)
                {
                   GObj.Interval__c=1;
                }
              Integer Interval,Count;
              String g_res=condition.replace('RRULE:','');
                /* if(g_res.contains('INTERVAL='))
                    {
                
                         Integer i=g_res.indexOf('INTERVAL'); 
                         system.debug(i);
                         integer j=i+10;
                         string qt=g_res.substring(i,j);
                         GObj.Interval__c=Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                         Interval=Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                         
                     }
                     else
                     {
                     GObj.Interval__c=1;
                     Interval=1;
                     }  
                    */
                       if(con_array.size()>2)
                        { 
                             if(con_array[2].contains('INTERVAL='))
                            {
                                String qt=con_array[2];
                                GObj.Interval__c =Integer.ValueOf(String.valueOf(qt.replace('INTERVAL=','')));
                            }
                            else
                            {
                                //GObj.Interval__c =1;
                            
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
                      if(g_res.contains('BYDAY='))
                {
                    //st=st.replace('BYDAY=','1');
                     Integer i=g_res.indexOf('BYDAY'); 
                    system.debug(i);
                   integer j=i+6;
                   string qt=g_res.substring(i,g_res.length());
                    system.debug(qt);
                    //GObj.Repeats_on__c= qt.replace('BYDAY=','');
                     qt= qt.replace('BYDAY=','');
                     String byday=qt.replace(',',';');
                     GObj.ByDay__c= byday;
                    
                  }
                     
                    /*    String st1=condition.replace('RRULE:','');
                      if(st1.contains('COUNT='))
                    {
                
                         Integer i=st1.indexOf('COUNT'); 
                         system.debug(i);
                         integer j=i+7;
                         string qt=st1.substring(i,j);
                         system.debug(qt);
                         GObj.Count__c=Integer.ValueOf(String.valueOf(qt.replace('COUNT=','')));
                         Count=Integer.ValueOf(String.valueOf(qt.replace('COUNT=','')));
                       if(con_array[0]=='FREQ=WEEKLY')
                        {
                         Gobj.Last_Event_Date__c=DateTime.valueOfGmt(sttm).addDays(7*(Interval*count-Interval));
                        }
                        if(con_array[0]=='FREQ=DAILY')
                       {
                        Gobj.Last_Event_Date__c=DateTime.valueOfGmt(sttm).addDays(Interval*count-Interval);
                       }
                       if(con_array[0]=='FREQ=MONTHLY')
                       {
                        Gobj.Last_Event_Date__c=DateTime.valueOfGmt(sttm).addMonths(Interval*count-Interval);
                       }
                       if(con_array[0]=='FREQ=YEARLY')
                       {
                        Gobj.Last_Event_Date__c=DateTime.valueOfGmt(sttm).addYears(Interval*count-Interval);
                       
                       }
                    



                     }  */
                          if(con_array.size()>=2)
                    {   
                         if(con_array[1].contains('COUNT='))
                            { 
                                 String qt=con_array[1];
                                 GObj.Count__c=Integer.ValueOf(String.valueOf(qt.replace('COUNT=','')));
                                    system.debug(GObj.Count__c);
                                    } 
                            }   
                
                     
                    

               
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
               
               
               if(con_array[0]=='FREQ=DAILY')
               {
                 
                          
                 GObj.Freq__c='DAILY';
                 // Gobj.EndDATETIME=DateTime.valueOfGmt(sttm).adddays(Interval*count-Interval);
               }
              
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
                // Gobj.EndDATETIME=DateTime.valueOfGmt(sttm).addMonths(Interval*count-Interval);
               }
               
                if(con_array[0]=='FREQ=YEARLY')
                    {
                      
                      GObj.Freq__c='YEARLY';
                      // Gobj.EndDATETIME=DateTime.valueOfGmt(sttm).addYears(Interval*count-Interval);
                    }
                      
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
                    
               // Gobj.Recurring_duration__c=1;// Integer.ValueOf(String.ValueOf((DateTime.valueOfGmt(entm).Hour)-(DateTime.valueOfGmt(sttm).Hour())*60));
              
              
             //  Gobj.Google_Response__c=condition.replace('RRULE:','');
                
                
                     
               glist.add(GObj);
             
            
           } 
           }
           
           else
           {   
               if(Stime != null && Etime != null)
               {
                
           //Logic to Convert the event start and End  DateTime in the specific format as required to assign th event Start And End time 
                System.debug('Stime ' + Stime +' Etime ' + Etime );
                String sttm=(String)Stime.get('dateTime');
               
               Boolean IsAllDayEvent = false;
               
                if(sttm == null) // In case of a whole day event
                {
                    sttm = (String)Stime.get('date');
                    sttm = sttm+' 00:00:00';
                   // IsAllDayEvent =true;
                    Datetime alldt=DateTime.valueOf(sttm);
                    sttm = string.valueof(alldt.addhours(-10));
                    sttm = sttm.replace(' ','T');
                    sttm =sttm+'Z';
                }
                
                
                sttm=sttm.replace('T',' ');
                sttm=sttm.replace('Z','');
               
                String entm=(String)Etime .get('dateTime');
                
                if(entm == null) // In case of a whole day event
                {
                    entm=(String)Etime .get('date');
                    entm = entm+' 00:00:00';
                    Datetime alldt=DateTime.valueof(entm);
                    entm = string.valueof(alldt.addhours(-10));
                    entm= entm.replace(' ','T');
                    entm = entm+'Z';
                }
                
                entm=entm.replace('T',' ');
                entm=entm.replace('Z','');
               
              
                Event enr= new Event();                            // Event object Is Created ,nonrecursive
                
             // Assign the values in the event object
               if(((String)Event_item.get('summary'))!=null){
            if(((String)Event_item.get('summary')).length()>=255)
               { 
               enr.Subject=((String)Event_item.get('summary')).left(250);
               }else
               {
               enr.Subject=(String)Event_item.get('summary');
               }
             }  
               // enr.Subject=(String)Event_item.get('summary');
                if(User_Eml_Id_Map.containsKey(bobject.Email__c))
                {
                enr.ownerid=User_Eml_Id_Map.get(bobject.Email__c); // Assign to its owner
                }
                
                enr.whatid=bobject.id;
                enr.Google_Event_ID__c=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,sttm);
                enr.StartDateTime=DateTime.valueOfGmt(sttm);
                enr.EndDateTime=DateTime.valueOfGmt(entm);
                enr.IsAllDayEvent = IsAllDayEvent ;
                
               
               if(enr.EndDateTime < enr.StartDateTime.addDays(1))
            {   
               Evt_list.add(enr);  // Add event in the List
              }
               if(DateTime.valueOfGmt(sttm).adddays(1) <=DateTime.valueOfGmt(entm))
             {
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
               GObj.Multiday__c=true;
               GObj.Broker__c=bobject.id;
                if(User_Eml_Id_Map.containsKey(bobject.Email__c))
                {
                GObj.Assigned_To__c=User_Eml_Id_Map.get(bobject.Email__c);
                }
               glist.add(GObj);
             }
             }
           } 
           if(Stime != null && Etime != null){
            e.Email=Saasfocus_Global.setGoogleId((String)Event_item.get('id'),bobject.Email__c,'date');
            e.StartDateTime=(String)(Stime.get('dateTime'));
            e.EndDateTime=(String)(Etime.get('dateTime'));
             
              System.debug('eventclass'+e.Email);
               System.debug('EVTTIME'+Stime .get('dateTime'));
               System.debug('recset'+recid_set);
               // if(recid_set.contains(e.Email))
                //{
                 
                 //e.Email=(String)bobject.Email__c;
                 Event_list.add(e);                // Add the Event Object in the list
                //}
              System.debug('EVENT LIST RES'+Event_list); 
            }
         }  
       }    
          
          } 
          // condition for delete Mutliday Event and Recur Event and Google Event object from salesforce    
         Set<Id> GobjId_set= new Set<ID>();
           cancel_Geventlist=[select id from Google_Recurring_Events__c where (Multiday__c=true OR   Recurring_Events__c=true) AND Google_Event_Id__c in : deleteEvent_IDset];
           system.debug('HHHH'+cancel_Geventlist);
           if(cancel_Geventlist.size()>0){
                 for(Google_Recurring_Events__c obj2 :cancel_Geventlist ){
                        GobjId_set.add(obj2.id);
                        googleEventlst.add(obj2);
                 }
           }
           List<Event> Evtobj1= [select id from Event where Event_ID__c in :GobjId_set];
           if(Evtobj1.size()>0){
               for(Event evt : Evtobj1){
                   system.debug('EEEE'+Evtobj1);
                   del_list.add(evt);
               }
           } 
          // upsert  glist Google_Event_Id__c;
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
                if(ob11.Multiday__c==true)
                {
                g_obj.Multiday__c=true;
                }
                else
                {
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
                
                if(ob11.Assigned_To__c!=null)
                {
                    g_obj.Assigned_To__c=ob11.Assigned_To__c;
                }        
                lstREinsert.add(g_obj);
            }
            List<Event> lstEvent = new List<Event>();
            List<Google_Recurring_Events__c> lstRE = new List<Google_Recurring_Events__c>();
            lstRE = [select id,Google_Event_ID__c from Google_Recurring_Events__c where Google_Event_Id__c in :st];
            st = new Set<string>();
            for(Google_Recurring_Events__c ob22 :lstRE){
              if(!recid_set.contains(ob22.Google_Event_ID__c))
               {
                st.add(ob22.id);
                }
            }
            
            lstEvent = [select id from Event where Event_ID__c in :st];
            if(lstEvent.size() > 0){
            
                   delete lstEvent; 
                  
            }
            if(lstRE.size() > 0){
                delete lstRE;
            }
            List<Google_Recurring_Events__c> lstREC1 = new List<Google_Recurring_Events__c>();
            if(lstREinsert.size() > 0){
                for(Google_Recurring_Events__c ob :lstREinsert)
                {
                  if(!recid_set.contains(ob.Google_Event_ID__c))
                  {
                   lstREC1.add(ob);
                  }
                }
                if(lstREC1.size()>0){ insert lstREC1;
                //insert lstREinsert;
                }
            }
        }catch(Exception e){
            system.debug('!Bingo error=> '+e);
        }
           System.debug('RECLIST'+glist);
          upsert Evt_list Google_Event_ID__c ;
           System.debug('OUT'+Event_list);
           
                  
// Condition delete events from salesforce  
    cancel_event_list= [select id from Event where Google_Event_ID__c in : deleteEvent_IDset];
            system.debug('HHHHHHI'+cancel_event_list);
            if(cancel_event_list.size()>0){
            for(Event evtobj:cancel_event_list){
                 del_list.add(evtobj);
                 
                }
            }
                
  if(del_list.size()>0){
/* set<String> st1= new set<String>();
 if(lstEvent.size()>0){
    for( Event evt :lstEvent)
    {
      st1.add(evt.id);
    }
       
           
         Set<Event> myset = new Set<Event>();
         List<Event> result = new List<Event>();
          for (Event s : del_list) {
         
          if(myset.contains(s) == false)
          {
                    myset.add(s);
                    if(st1.contains(s.id)==false){ 
                      result.add(s);
                     }
                     
            }
         system.debug('RRR'+result);
      
      
      }
      delete result;
      }else  */
      {
      Set<Event> myset = new Set<Event>();
         List<Event> result = new List<Event>();
          for (Event s : del_list) {
         
          if(myset.contains(s) == false)
          {
                     myset.add(s);
                      result.add(s);
                     
            }
         system.debug('RRR'+result);
      
      
      }
      delete result;
     }
      
    }
   
// Delete Google recurring Event object from salesforce
try{   
     if(googleEventlst.size()>0){
        Set<Google_Recurring_Events__c> myset = new Set<Google_Recurring_Events__c>();
         List<Google_Recurring_Events__c> result = new List<Google_Recurring_Events__c>();
          for (Google_Recurring_Events__c s : googleEventlst) {
         
          if(myset.contains(s) == false)
          {
                     myset.add(s);
                      result.add(s);
                     
            }
         system.debug('RRR'+result);
      
      
      }
      delete result;
         //delete googleEventlst;
     }
   }
   catch(Exception e){
            system.debug('!Bingo delete error=> '+e);
        }
           
         //  ob.updateGoogleSettings();  // Update the Custom setting
  list<Saasfocus_EventClass> elist = new List<Saasfocus_EventClass>();
          for(Saasfocus_EventClass et : Event_list)
          {
             if(!recid_set.contains(et.Email))
             {
               et.email=Saasfocus_Global.getGoogleId(et.email);
              elist.add(et);
             }
          }
         // return Event_list;            // Return the List of events
           
           return elist;
    }
 
 }