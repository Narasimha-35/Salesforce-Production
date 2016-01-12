// ----------------------------------------------------------------------------------
// This class Insert The Google Calender Event in Salesforce

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0           17/04/2015    Amit kumar         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes: This trigger is used to create multiple single events based on the recurssion criteria
// ----------------------------------------------------------------------------------
//  
//

trigger Saasfocus_GenerateMultipleEvents on Google_Recurring_Events__c (after insert) 
{
    List<Event> lste = new List<Event>();
    List<Google_Recurring_Events__c > lstgre = new List<Google_Recurring_Events__c >();
    Saasfocus_Global.GoogleSyncProces=True;
    TimeZone tz = UserInfo.getTimeZone();
    set<ID> gobj_set= new Set<ID>();
    for(Google_Recurring_Events__c obj : trigger.new)
    {
      gobj_set.add(obj.id);
    }
    List<Google_Recurring_Events__c> gevent_list =[select id,Broker__r.Primary_Market__r.Region__r.Name from Google_Recurring_Events__c where id in:gobj_set ];
    Map<ID,String> Id_region_Map= new Map<ID,String>();
    for(Google_Recurring_Events__c gobj : gevent_list )
    {
    Id_region_Map.put(gobj.id,gobj.Broker__r.Primary_Market__r.Region__r.Name);
    }
    
    for(Google_Recurring_Events__c obje : trigger.new)
    {
    Google_Recurring_Events__c  gre = new Google_Recurring_Events__c (id = obje.id);
    
      
        // #### Condition for Multiday Event
        If(obje.Multiday__c)
        { 
           Datetime Startdatetime = obje.Start_date__c;
           while(true)
           {
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                newEve.startdatetime = Startdatetime ;
                newEve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,newEve.startdatetime);
                Decimal Daydiff = (Decimal) (obje.End_date__c.getTime() - Startdatetime.getTime()) /1000/60/60/24 ;
                system.debug(daydiff);
                if(Daydiff > 14)
                {
                    newEve.Enddatetime = Startdatetime.adddays(13);
                    Startdatetime =newEve.Enddatetime ;
                    neweve.whatid = obje.Broker__c;
                    neweve.Event_ID__c = obje.id;
                    if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c;  
                    } 
                    gre.last_event_date__c = neweve.startdatetime;              
                    lste.add(neweve);
                }
                else
                {
                
                    newEve.Enddatetime =obje.End_date__c;
                    neweve.whatid = obje.Broker__c;
                    neweve.Event_ID__c = obje.id;
                     if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c;  
                    }          
                    gre.last_event_date__c = neweve.startdatetime;        
                    lste.add(neweve);
                    break;
                }
                   
            }
    
        } 
    
    // # Multiday Event Ends here.
    
    
    
    // # Conditions for recurring events starts here.
    Google_API_Setting__c objGset = Google_API_Setting__c.getValues('Google_Setting');
    Integer Eventdaylimit = (Integer) objGset.upto_period__c *7;
    Datetime Eventlimit = system.now().addDays(Eventdaylimit -1);
        if(obje.Recurring_Events__c)
        {
            // # An event of type daily with interval N
            if(obje.Freq__c == 'Daily' && obje.Interval__c !=null && obje.Until__c == null & obje.count__c == null )
            {
               
               Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
                 integer tempcondition=0;
                //Datetime startdatetime = obje.start_date__c;
                system.debug('OBJECT::::'+obje.start_date__c+'::ID::::'+obje.id+':::ENDDATE::'+obje.end_date__c);
               // Datetime enddatetime = obje.end_date__c;
               while(tmpOB.start_date__c<= Eventlimit)
               {
               if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                 if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22');
                     }
                
                neweve.whatid = obje.Broker__c;
                 if(obje.Assigned_To__c!=null)
                {
                neweve.ownerid= obje.Assigned_To__c; 
                }  
                neweve.Event_ID__c = obje.id;
                
                system.debug('STTIME222'+neweve.startdatetime);
             if(neweve.startdatetime>=System.now())
              { 
                lste.add(neweve);
                gre.last_event_date__c = neweve.startdatetime;
               }
                tmpOB.start_date__c= tmpOB.start_date__c.addDays((Integer)obje.Interval__c);
                tmpOB.end_date__c= tmpOB.end_date__c.addDays((Integer)obje.Interval__c);    
               }
            
            }
            
            // # A daily recurring event with until defined
            if(obje.Freq__c == 'Daily' && obje.Interval__c !=null && obje.Until__c != null & obje.count__c == null )
            {
            Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
                 integer tempcondition=0;
               while(tmpOB.start_date__c <= Eventlimit && tmpOB.start_date__c<= obje.Until__c )
               {
               if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                 if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22'+neweve.startdatetime);
                     }
                
                neweve.whatid = obje.Broker__c;
                 if(obje.Assigned_To__c!=null)
               {
                neweve.ownerid= obje.Assigned_To__c;  
                }      
                neweve.Event_ID__c = obje.id;  
                if(neweve.startdatetime>=System.now())
                {          
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c= tmpOB.start_date__c.addDays((Integer)obje.Interval__c);
                tmpOB.end_date__c= tmpOB.end_date__c.addDays((Integer)obje.Interval__c);    
               }
            
            }
            
            // # A daily recurring event with count defined
            if(obje.Freq__c == 'Daily' && obje.Interval__c !=null && obje.Until__c == null & obje.count__c != null )
            {
                Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                //Datetime startdatetime = obje.start_date__c;                
                //Datetime enddatetime = obje.end_date__c;
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
                Integer count = 1;
                integer tempcondition=0;
               while(tmpOB.start_date__c <= Eventlimit && count <= obje.count__c  )
               {
               if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                 if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22');
                     }
                neweve.whatid = obje.Broker__c;
                 if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c; 
                    }   
                neweve.Event_ID__c = obje.id;  
                if(neweve.startdatetime>=System.now())
                {              
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c = tmpOB.start_date__c.addDays((Integer)obje.Interval__c);
                tmpOB.end_date__c = tmpOB.end_date__c.addDays((Integer)obje.Interval__c);    
                count++;
               }
            
            }
            
            // # A never ending weekly recurring event with an interval
            if(obje.Freq__c == 'Weekly' && obje.Interval__c !=null &&obje.byday__c != null && obje.Until__c == null & obje.count__c == null )
            {
                
                Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
                Datetime Intraweekstartdt= obje.start_date__c;
                Datetime Intraweekenddt= obje.end_date__c;
              
               
               Datetime Startdatetime = Intraweekstartdt;
               Datetime Enddatetime = Intraweekenddt;
                system.debug('OBJECT::::'+obje.start_date__c+'::ID::::'+obje.id+':::ENDDATE::'+obje.end_date__c);
               
               List<String> tmSt = obje.byday__c.split(';');
             
                Integer i = tmst.size();
                Integer j = 0; 
                integer tempcondition=0;
               while(startdatetime <= Eventlimit  )
               {
              // Condition for daylight saving
              
              if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
               system.debug('DDDDD'+tmpOB.start_date__c);
                //String DOW = obje.start_date__c.format('E').left(2);
                String DOW = tmpOB.start_date__c.format('E').left(2);
                system.debug(obje.byday__c+'hhhhh'+DOW);
                If(obje.byday__c.contains(DOW.toUpperCase()))
                {
                
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
               if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
               
               }
                else if(stoff>Evtoff)
                {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                    
                }else
                {
                     neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                     neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                     if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                } 
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22'+neweve.startdatetime);
                     }
                system.debug(neweve.startdatetime+':::::TIME:::::'+neweve.enddatetime);
                neweve.whatid = obje.Broker__c;
                
                 if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c; 
                    }        
                neweve.Event_ID__c = obje.id;
                if(neweve.startdatetime>=System.now())
                {           
                lste.add(neweve);gre.last_event_date__c = neweve.startdatetime;
                }
            
                startdatetime = startdatetime.addDays(1);
                enddatetime = startdatetime.addDays(1);  
                j++;
                if(i == j){
                    tmpOB.start_date__c= tmpOB.start_date__c.addDays((Integer)(7*(obje.Interval__c -1)));
                    tmpOB.end_date__c= tmpOB.end_date__c.addDays((Integer)(7*(obje.Interval__c -1)));
                    j=0;
                }
                 
                system.debug('Elist'+lste);
                }  
                
                
                if(DOW.toUpperCase() == 'SA')
                {
                    Intraweekstartdt = Intraweekstartdt.addDays((Integer)(7*obje.Interval__c));
                    Intraweekenddt= Intraweekenddt.addDays((Integer)(7*obje.Interval__c));
                    
                    Intraweekstartdt = Datetime.newInstance(Intraweekstartdt.date().toStartofWeek() , Intraweekstartdt.time());
                    Intraweekenddt = Datetime.newInstance(Intraweekenddt.date().toStartofWeek() , Intraweekenddt.time());
                   
                    Startdatetime =Intraweekstartdt;
                    Enddatetime = Intraweekenddt;
                     system.debug('HI');
                     system.debug(Enddatetime+'::::::: '+Startdatetime);
                }
                  
                    tmpOB.start_date__c= tmpOB.start_date__c.addDays(1);
                    tmpOB.end_date__c= tmpOB.end_date__c.addDays(1);
                    
               }
            
            }
            
            // # A weekly recurring event with an until date
            if(obje.Freq__c == 'Weekly' && obje.Interval__c !=null && obje.byday__c != null && obje.Until__c == null & obje.count__c != null )
            {
                
                Datetime Intraweekstartdt= obje.start_date__c;
                Datetime Intraweekenddt= obje.end_date__c;
                Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
                Datetime Startdatetime = Intraweekstartdt;
                Datetime Enddatetime = Intraweekenddt;
                Integer count =1;
                List<String> tmSt = obje.byday__c.split(';');
                Integer i = tmst.size();
                Integer j = 0; 
                integer tempcondition=0;
               while(startdatetime <= Eventlimit && count <=obje.count__c )
               {
                
              if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
              //  String DOW = obje.start_date__c.format('E').left(2);
                 String DOW = tmpOB.start_date__c.format('E').left(2);
                  system.debug(obje.byday__c+'hhhhh'+DOW);
                If(obje.byday__c.contains(DOW.toUpperCase()))
                {
                
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22');
                     }
               // neweve.startdatetime = startdatetime ;
               // neweve.enddatetime = enddatetime ; 
                neweve.whatid = obje.Broker__c;
                 if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c; 
                    }                  
                neweve.Event_ID__c = obje.id; 
                if(neweve.startdatetime>=System.now())
                {
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                startdatetime = startdatetime.addDays(1);
                enddatetime = startdatetime.addDays(1);  
                system.debug(lste);
                j++;
                if(i == j){
                    tmpOB.start_date__c = tmpOB.start_date__c.addDays((Integer)(7*(obje.Interval__c -1)));
                    tmpOB.end_date__c= tmpOB.end_date__c.addDays((Integer)(7*(obje.Interval__c -1)));
                    j=0;
                }
                count++;
                }  
                
                if(DOW.toUpperCase() == 'SA')
                {
                    Intraweekstartdt = Intraweekstartdt.addDays((Integer)(7*obje.Interval__c));
                    Intraweekenddt = Intraweekenddt.addDays((Integer)(7*obje.Interval__c));
                    
                     Intraweekstartdt = Datetime.newInstance(Intraweekstartdt.date().toStartofWeek() , Intraweekstartdt.time());
                    Intraweekenddt = Datetime.newInstance(Intraweekenddt.date().toStartofWeek() , Intraweekenddt.time());
                    
                    Startdatetime =Intraweekstartdt;
                    Enddatetime = Intraweekenddt;
                }
                
                
                tmpOB.start_date__c = tmpOB.start_date__c.addDays(1);
                tmpOB.end_date__c= tmpOB.end_date__c.addDays(1);
                
               }
            
            }
            
            // # A never ending weekly recurring event with an until date
            if(obje.Freq__c == 'Weekly' && obje.Interval__c !=null && obje.byday__c != null && obje.Until__c != null & obje.count__c == null )
            {
                
                Datetime Intraweekstartdt= obje.start_date__c;
                Datetime Intraweekenddt= obje.end_date__c;
                
               Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
               tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
               
                Datetime Startdatetime = Intraweekstartdt;
                Datetime Enddatetime = Intraweekenddt;
                List<String> tmSt = obje.byday__c.split(';');
                Integer i = tmst.size();
                Integer j = 0; 
                integer tempcondition=0;
               while(startdatetime <= Eventlimit && tmpOB.start_date__c <= obje.until__c  )
               {
                
              if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
               // String DOW = obje.start_date__c.format('E').left(2);
               String DOW = tmpOB.start_date__c.format('E').left(2);
               system.debug(obje.byday__c+'hhhhh'+DOW);
                If(obje.byday__c.contains(DOW.toUpperCase()))
                {
                
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                } 
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22');
                     }
                //neweve.startdatetime = startdatetime ;
                //neweve.enddatetime = enddatetime ; 
                neweve.whatid = obje.Broker__c;
                 if(obje.Assigned_To__c!=null)
                    {
                neweve.ownerid= obje.Assigned_To__c; 
                }             
                neweve.Event_ID__c = obje.id; 
                if(neweve.startdatetime>=System.now())
               {     
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                
                startdatetime = startdatetime.addDays(1);
                enddatetime = startdatetime.addDays(1);  
                j++;
                if(i == j){
                    tmpOB.start_date__c= tmpOB.start_date__c.addDays((Integer)(7*(obje.Interval__c -1)));
                    tmpOB.end_date__c = tmpOB.end_date__c.addDays((Integer)(7*(obje.Interval__c -1)));
                    j=0;
                }
                }  
                
                if(DOW.toUpperCase() == 'SA')
                {
                    Intraweekstartdt = Intraweekstartdt.addDays((Integer)(7*obje.Interval__c));
                    Intraweekenddt = Intraweekenddt.addDays((Integer)(7*obje.Interval__c));
                    
                     Intraweekstartdt = Datetime.newInstance(Intraweekstartdt.date().toStartofWeek() , Intraweekstartdt.time());
                    Intraweekenddt = Datetime.newInstance(Intraweekenddt.date().toStartofWeek() , Intraweekenddt.time());
                    
                    Startdatetime =Intraweekstartdt;
                    Enddatetime = Intraweekenddt;
                    system.debug(Startdatetime+':::::::'+Enddatetime);
                }
                tmpOB.start_date__c= tmpOB.start_date__c.addDays(1);
                tmpOB.end_date__c = tmpOB.end_date__c.addDays(1);
               }
            
            }
            
            // # A never ending event of type Monthly with interval N
            if(obje.Freq__c == 'Monthly' && obje.Interval__c !=null && obje.byday__c == null && obje.Until__c == null & obje.count__c == null )
            {
                Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
                //Datetime startdatetime = obje.start_date__c;
               // Datetime enddatetime = obje.end_date__c;
               integer tempcondition=0;
               while(tmpOB.start_date__c<= Eventlimit )
               {
               if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22');
                     }
                neweve.Event_ID__c = obje.id;
                neweve.whatid = obje.Broker__c;
                 if(obje.Assigned_To__c!=null)
                    {
                neweve.ownerid= obje.Assigned_To__c;  
                } 
                if(neweve.startdatetime>=System.now())
                {
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c= tmpOB.start_date__c.addMonths((Integer)obje.Interval__c);
                tmpOB.end_date__c= tmpOB.end_date__c.addMonths((Integer)obje.Interval__c);    
               }
               system.debug('EVLIST'+lste);
            
            }
            
            // # A Monthly recurring event with until defined
            if(obje.Freq__c == 'Monthly' && obje.Interval__c !=null && obje.byday__c == null && obje.Until__c != null & obje.count__c == null )
            {
               Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
               // Datetime startdatetime = obje.start_date__c;
               // Datetime enddatetime = obje.end_date__c;
               integer tempcondition=0;
               while(tmpOB.start_date__c<= Eventlimit && tmpOB.start_date__c<= obje.Until__c )
               {
               if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22');
                     }
                neweve.whatid = obje.Broker__c; 
                 if(obje.Assigned_To__c!=null)
                    {
                neweve.ownerid= obje.Assigned_To__c;   
                }                
                neweve.Event_ID__c = obje.id;
                if(neweve.startdatetime>=System.now())
                {
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c= tmpOB.start_date__c.addMonths((Integer)obje.Interval__c);
                tmpOB.end_date__c= tmpOB.end_date__c.addMonths((Integer)obje.Interval__c);    
               }
            
            }
            
            // # A Monthly recurring event with count defined
            if(obje.Freq__c == 'MOnthly' && obje.Interval__c !=null && obje.byday__c == null && obje.Until__c == null & obje.count__c != null )
            {
               Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
               // Datetime startdatetime = obje.start_date__c;
               // Datetime enddatetime = obje.end_date__c;
                Integer count = 1;
                integer tempcondition=0;
               while(tmpOB.start_date__c<= Eventlimit && count <= obje.count__c  )
               {
               if((tz.getOffset(tmpOB.start_date__c))/(1000*60*60)==11 && tmpOB.start_date__c.minute()<59 && tmpOB.start_date__c.hour()==0 && tmpOB.start_date__c.month()==10)
               {
                tmpOB.start_date__c= tmpOB.start_date__c.addHours(-1);
                tmpOB.end_date__c=tmpOB.end_date__c.addHours(-1);
                system.debug('DDDDD111'+tmpOB.start_date__c);
                 tempcondition=1;
               }
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                 
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                if(tempcondition==1){
                       neweve.startdatetime = tmpOB.start_date__c;
                       neweve.enddatetime = tmpOB.end_date__c;
                   }
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      if(tempcondition==1)
                      {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                      }
                      system.debug('AAA22');
                     }
                neweve.whatid = obje.Broker__c; 
                 if(obje.Assigned_To__c!=null)
               {
                neweve.ownerid= obje.Assigned_To__c; 
                }         
                neweve.Event_ID__c = obje.id;   
                if(neweve.startdatetime>=System.now())
                {     
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c= tmpOB.start_date__c.addMonths((Integer)obje.Interval__c);
                tmpOB.end_date__c = tmpOB.end_date__c .addMonths((Integer)obje.Interval__c);    
                count++;
               }
            
            }
            
            if(obje.Freq__c == 'MONTHLY' && obje.Repeats_on__c!=null && obje.Interval__c !=null &&obje.byday__c != null && obje.Until__c == null & obje.count__c == null )
            {
               Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = DateTime.newInstance(obje.start_date__c.year(),obje.start_date__c.month(),1,obje.start_date__c.hour(),obje.start_date__c.minute(),obje.start_date__c.second());
                tmpOB.end_date__c = DateTime.newInstance(obje.end_date__c.year(),obje.end_date__c.month(),1,obje.end_date__c.hour(),obje.end_date__c.minute(),obje.end_date__c.second());
                //Datetime tmpSD = DateTime.newInstance(obje.start_date__c.year(),obje.start_date__c.month(),1,1,1,1);
               // Datetime enddatetime = obje.end_date__c;
                Datetime Intraweekstartdt= obje.start_date__c;
                Datetime Intraweekenddt= obje.end_date__c;
              
               
               Datetime Startdatetime = Intraweekstartdt;
               Datetime Enddatetime = Intraweekenddt;
                system.debug('OBJECT::::'+obje.start_date__c+'::ID::::'+obje.id+':::ENDDATE::'+obje.end_date__c);
               
               List<String> tmSt = obje.byday__c.split(';');
             
                Integer i = tmst.size();
                Integer j = 0; 
                Integer k = 0; 
                Datetime tempST = tmpOB.start_date__c.addMonths(1).addDays(-1);
                Datetime tempST3 = tmpOB.start_date__c.addMonths(1);
                Datetime tempST4 = tmpOB.start_date__c.addMonths(1).addDays(-1);
                while(tempST < system.now()){
                    tempST = tempST.addMonths(1);
                }
                Datetime tempST2 = tempST.addDays(-7);
               while(tmpOB.start_date__c <= Eventlimit  )
               {
               
                //String DOW = obje.start_date__c.format('E').left(2);
                String DOW = tmpOB.start_date__c.format('E').left(2);
                system.debug(obje.byday__c+'hhhhh'+DOW);
                If(obje.byday__c.contains(DOW.toUpperCase()))
                {
                    k++;
                     system.debug(tmpOB.start_date__c+':::::kkkkkkk::::'+k);
                    if((k == Integer.valueOf(obje.Repeats_on__c)) || (Integer.valueOf(obje.Repeats_on__c) < 0 && tmpOB.start_date__c >= tempST2)){
                        tempST2 = tempST2.addMonths(1);
                        Event neweve = new Event(); neweve.subject = obje.summary__c;
                        neweve.Description= obje.Description__c;
                        neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c); 
                       Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                }
                if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      system.debug('AAA22');
                     }
                        neweve.Event_ID__c = obje.id;
                        neweve.whatid = obje.Broker__c;
                        system.debug(neweve.startdatetime+':::::EEEEE::::'+k);
                         if(obje.Assigned_To__c!=null)
                            {
                            neweve.ownerid= obje.Assigned_To__c;  
                        } 
                        if(neweve.startdatetime>=System.now())
                        {
                        lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                        }
                         
                    }
                    
               }
                  
               system.debug('EVLIST'+lste);
               system.debug(tempST4+'EVLIST2222'+tmpOB.start_date__c);
               if(tempST4 == tmpOB.start_date__c){
                   system.debug(tempST3+' !Bingo '+tempST4);
                   k = 0;
                   tempST4 = tempST3.addMonths(1).addDays(-1);
                   tempST3 = tempST3.addMonths(1);                   
               }
               tmpOB.start_date__c= tmpOB.start_date__c.addDays(1);
               tmpOB.end_date__c= tmpOB.end_date__c.addDays(1);
            
            }
            }
            if(obje.Freq__c == 'MONTHLY' && obje.Repeats_on__c!=null && obje.Interval__c !=null &&obje.byday__c != null && obje.Until__c!= null & obje.count__c == null )
            {
                Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = DateTime.newInstance(obje.start_date__c.year(),obje.start_date__c.month(),1,obje.start_date__c.hour(),obje.start_date__c.minute(),obje.start_date__c.second());
                tmpOB.end_date__c = DateTime.newInstance(obje.end_date__c.year(),obje.end_date__c.month(),1,obje.end_date__c.hour(),obje.end_date__c.minute(),obje.end_date__c.second());
                //Datetime tmpSD = DateTime.newInstance(obje.start_date__c.year(),obje.start_date__c.month(),1,1,1,1);
               // Datetime enddatetime = obje.end_date__c;
                Datetime Intraweekstartdt= obje.start_date__c;
                Datetime Intraweekenddt= obje.end_date__c;
              
               
               Datetime Startdatetime = Intraweekstartdt;
               Datetime Enddatetime = Intraweekenddt;
                system.debug('OBJECT::::'+obje.start_date__c+'::ID::::'+obje.id+':::ENDDATE::'+obje.end_date__c);
               
               List<String> tmSt = obje.byday__c.split(';');
             
                Integer i = tmst.size();
                Integer j = 0; 
                Integer k = 0; 
               Datetime tempST = tmpOB.start_date__c.addMonths(1).addDays(-1);
                Datetime tempST3 = tmpOB.start_date__c.addMonths(1);
                Datetime tempST4 = tmpOB.start_date__c.addMonths(1).addDays(-1);
                while(tempST < system.now()){
                    tempST = tempST.addMonths(1);
                }
                Datetime tempST2 = tempST.addDays(-7);
               while(tmpOB.start_date__c <= Eventlimit && tmpOB.start_date__c<= obje.Until__c )
               {
               
                //String DOW = obje.start_date__c.format('E').left(2);
                String DOW = tmpOB.start_date__c.format('E').left(2);
                system.debug(obje.byday__c+'hhhhh'+DOW);
                If(obje.byday__c.contains(DOW.toUpperCase()))
                {
                    k++;
                     system.debug(tmpOB.start_date__c+':::::kkkkkkk::::'+k);
                    if((k == Integer.valueOf(obje.Repeats_on__c)) || (Integer.valueOf(obje.Repeats_on__c) < 0 && tmpOB.start_date__c >= tempST2)){
                        tempST2 = tempST2.addMonths(1);
                        Event neweve = new Event(); neweve.subject = obje.summary__c;
                        neweve.Description= obje.Description__c;
                        neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                        Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                        Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                        if(stoff==Evtoff)
                        {
                        neweve.startdatetime = tmpOB.start_date__c;
                        neweve.enddatetime = tmpOB.end_date__c;
                        }
                        else if(stoff>Evtoff)
                        {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                        }else
                        {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                        }
                        if(Id_region_Map.get(obje.id)=='Brisbane')
                     {
                      neweve.startdatetime = tmpOB.start_date__c;
                      neweve.enddatetime = tmpOB.end_date__c;
                      system.debug('AAA22');
                     }
                        neweve.Event_ID__c = obje.id;
                        neweve.whatid = obje.Broker__c;
                        system.debug(neweve.startdatetime+':::::EEEEE::::'+k);
                         if(obje.Assigned_To__c!=null)
                            {
                        neweve.ownerid= obje.Assigned_To__c;  
                        } 
                        if(neweve.startdatetime>=System.now())
                        {
                        lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                        }
                         
                    }
                    
               }
                  
               system.debug('EVLIST'+lste);
               
               if(tempST4 == tmpOB.start_date__c){
                   k = 0;
                   tempST4 = tempST3.addMonths(1).addDays(-1);
                   tempST3 = tempST3.addMonths(1);                   
               }
                tmpOB.start_date__c= tmpOB.start_date__c.addDays(1);
               tmpOB.end_date__c= tmpOB.end_date__c.addDays(1);
            }
            }
            if(obje.Freq__c == 'MONTHLY' && obje.Repeats_on__c!=null && obje.Interval__c !=null &&obje.byday__c != null && obje.Until__c == null & obje.count__c!= null )
            {
             Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = DateTime.newInstance(obje.start_date__c.year(),obje.start_date__c.month(),1,obje.start_date__c.hour(),obje.start_date__c.minute(),obje.start_date__c.second());
                tmpOB.end_date__c = DateTime.newInstance(obje.end_date__c.year(),obje.end_date__c.month(),1,obje.end_date__c.hour(),obje.end_date__c.minute(),obje.end_date__c.second());
                //Datetime tmpSD = DateTime.newInstance(obje.start_date__c.year(),obje.start_date__c.month(),1,1,1,1);
               // Datetime enddatetime = obje.end_date__c;
                Datetime Intraweekstartdt= obje.start_date__c;
                Datetime Intraweekenddt= obje.end_date__c;
              
               
               Datetime Startdatetime = Intraweekstartdt;
               Datetime Enddatetime = Intraweekenddt;
                system.debug('OBJECT::::'+obje.start_date__c+'::ID::::'+obje.id+':::ENDDATE::'+obje.end_date__c);
               
               List<String> tmSt = obje.byday__c.split(';');
             
                Integer i = tmst.size();
                Integer j = 0; 
                Integer k = 0; 
                Datetime tempST = tmpOB.start_date__c.addMonths(1).addDays(-1);
                Datetime tempST3 = tmpOB.start_date__c.addMonths(1);
                Datetime tempST4 = tmpOB.start_date__c.addMonths(1).addDays(-1);
                while(tempST < system.now()){
                    tempST = tempST.addMonths(1);
                }
                Datetime tempST2 = tempST.addDays(-7);
                Integer count = 1;
               while(tmpOB.start_date__c <= Eventlimit && count <= obje.count__c )
               {
               
                //String DOW = obje.start_date__c.format('E').left(2);
                String DOW = tmpOB.start_date__c.format('E').left(2);
                system.debug(obje.byday__c+'hhhhh'+DOW);
                If(obje.byday__c.contains(DOW.toUpperCase()))
                {
                    k++;
                     system.debug(tmpOB.start_date__c+':::::kkkkkkk::::'+k);
                    if((k == Integer.valueOf(obje.Repeats_on__c)) || (Integer.valueOf(obje.Repeats_on__c) < 0 && tmpOB.start_date__c >= tempST2)){
                        tempST2 = tempST2.addMonths(1);
                        Event neweve = new Event(); neweve.subject = obje.summary__c;
                        neweve.Description= obje.Description__c;
                        neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                        Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                        Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                        if(stoff==Evtoff)
                        {
                        neweve.startdatetime = tmpOB.start_date__c;
                        neweve.enddatetime = tmpOB.end_date__c;
                        }
                        else if(stoff>Evtoff)
                        {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                        }else
                        {
                        neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                        neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                        }
                        if(Id_region_Map.get(obje.id)=='Brisbane')
                         {
                          neweve.startdatetime = tmpOB.start_date__c;
                          neweve.enddatetime = tmpOB.end_date__c;
                          system.debug('AAA22');
                         }
                        neweve.Event_ID__c = obje.id;
                        neweve.whatid = obje.Broker__c;
                        system.debug(neweve.startdatetime+':::::EEEEE::::'+k);
                         if(obje.Assigned_To__c!=null)
                            {
                        neweve.ownerid= obje.Assigned_To__c;  
                        } 
                        if(neweve.startdatetime>=System.now())
                        {
                        lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                        count++;
                        }
                         
                    }
                    
               }
                  
               system.debug('EVLIST'+lste);
               
               system.debug('');
               if(tempST4 == tmpOB.start_date__c){
               
                   k = 0;
                    tempST4 = tempST3.addMonths(1).addDays(-1);
                   tempST3 = tempST3.addMonths(1);                   
               }
                tmpOB.start_date__c= tmpOB.start_date__c.addDays(1);
               tmpOB.end_date__c= tmpOB.end_date__c.addDays(1);
            }
            }
            
            // # A never ending event of type Yearly with interval N
            if(obje.Freq__c == 'Yearly' && obje.Interval__c !=null && obje.byday__c == null && obje.Until__c == null & obje.count__c == null )
            {
               Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
                //Datetime startdatetime = obje.start_date__c;
               // Datetime enddatetime = obje.end_date__c;
               while(tmpOB.start_date__c <= Eventlimit )
               {
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                }
                 if(Id_region_Map.get(obje.id)=='Brisbane')
                         {
                          neweve.startdatetime = tmpOB.start_date__c;
                          neweve.enddatetime = tmpOB.end_date__c;
                          system.debug('AAA22');
                         }
                neweve.whatid = obje.Broker__c;  
                 if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c;  
                    }        
                neweve.Event_ID__c = obje.id; 
                if(neweve.startdatetime>=System.now())
                {       
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c = tmpOB.start_date__c .addYears((Integer)obje.Interval__c);
                tmpOB.end_date__c= tmpOB.end_date__c.addYears((Integer)obje.Interval__c);    
               }
            
            }
            
            // # A Yearly recurring event with until defined
            if(obje.Freq__c == 'Yearly' && obje.Interval__c !=null && obje.byday__c == null && obje.Until__c != null & obje.count__c == null )
            {
               Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
              //  Datetime startdatetime = obje.start_date__c;
              //  Datetime enddatetime = obje.end_date__c;
               while(tmpOB.start_date__c<= Eventlimit && tmpOB.start_date__c<= obje.Until__c )
               {
                Event neweve = new Event(); neweve.subject = obje.summary__c;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                }
                 if(Id_region_Map.get(obje.id)=='Brisbane')
                         {
                          neweve.startdatetime = tmpOB.start_date__c;
                          neweve.enddatetime = tmpOB.end_date__c;
                          system.debug('AAA22');
                         }
                neweve.whatid = obje.Broker__c; 
                 if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c; 
                    }                  
                neweve.Event_ID__c = obje.id;
                if(neweve.startdatetime>=System.now())
                {
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c= tmpOB.start_date__c.addYears((Integer)obje.Interval__c);
                tmpOB.end_date__c= tmpOB.end_date__c.addYears((Integer)obje.Interval__c);    
               }
            
            }
            
            // # A Yearly recurring event with count defined
            if(obje.Freq__c == 'Yearly' && obje.Interval__c !=null && obje.byday__c == null && obje.Until__c == null & obje.count__c != null )
            {
              Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                tmpOB.start_date__c = obje.start_date__c;
                tmpOB.end_date__c = obje.end_date__c;
               // Datetime startdatetime = obje.start_date__c;
               // Datetime enddatetime = obje.end_date__c;
                Integer count = 1;
               while(tmpOB.start_date__c<= Eventlimit && count <= obje.count__c  )
               {
                Event neweve = new Event(); neweve.subject = obje.summary__c; neweve.subject = obje.summary__c ;
                neweve.Description= obje.Description__c;
                neweve.Google_Event_Id__c=Saasfocus_Global.recurid(obje.Google_Event_Id__c,tmpOB.start_date__c);
                Integer stoff= (tz.getOffset(obje.start_date__c))/(1000*60*60);
                Integer Evtoff= (tz.getOffset(tmpOB.start_date__c))/(1000*60*60);
                if(stoff==Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c;
                neweve.enddatetime = tmpOB.end_date__c;
                }
                else if(stoff>Evtoff)
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(1);
                }else
                {
                neweve.startdatetime = tmpOB.start_date__c.addHours(-1);
                neweve.enddatetime = tmpOB.end_date__c.addHours(-1);
                }
                 if(Id_region_Map.get(obje.id)=='Brisbane')
                         {
                          neweve.startdatetime = tmpOB.start_date__c;
                          neweve.enddatetime = tmpOB.end_date__c;
                          system.debug('AAA22');
                         }
                neweve.whatid = obje.Broker__c;  
                 if(obje.Assigned_To__c!=null)
                    {
                    neweve.ownerid= obje.Assigned_To__c; 
                    }            
                neweve.Event_ID__c = obje.id;  
                if(neweve.startdatetime>=System.now())
                {   
                lste.add(neweve); gre.last_event_date__c = neweve.startdatetime;
                }
                tmpOB.start_date__c= tmpOB.start_date__c.addYears((Integer)obje.Interval__c);
                tmpOB.end_date__c= tmpOB.end_date__c.addYears((Integer)obje.Interval__c);    
                count++;
               }
            
            }    
        // insert condition here
        }
lstgre.add(gre);
}
if(lste.size() > 0){
    system.debug(lste);
   // Insert lste;
     try{
                 Set<String> myset = new Set<String>();
                 List<Event> result = new List<Event>();
                  for (Event s : lste) {
                 
                  if(myset.contains(s.Google_Event_Id__c) == false)
                  {
                              myset.add(s.Google_Event_Id__c);
                              result.add(s);
                  }
                 system.debug('RRR'+result);
              }
          upsert result Google_Event_ID__c;
      
        
        }
        catch(Exception e){
            system.debug('!Bingo delete error=> '+e);
        }
}
if(lstgre.size() > 0){
    update lstgre;
}


}