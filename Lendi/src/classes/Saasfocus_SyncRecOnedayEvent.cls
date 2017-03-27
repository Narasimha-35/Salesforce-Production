Public class Saasfocus_SyncRecOnedayEvent
{
  public Map<String,Id>User_Eml_Id_Map{get;set;}
  public Map<String,Broker__c>Broker_map= new Map<String,Broker__c>(); 
  public List<User> Ulist{get;set;}
  public List<Google_Recurring_Events__c> Google_Event_Objlst = new List<Google_Recurring_Events__c>();
  public List<Event>Sin_evtlist= new List<Event>(); 
  public set<String> event_id_set= new set<String>();
  
    public void OnedayEvent(List<Google_Recurring_Events__c> RSet)
    {
       Saasfocus_Global.GoogleSyncProces=True;
       
       // List<Google_Recurring_Events__c> RSet = new List<Google_Recurring_Events__c>();
      //  RSet = [Select Repeats_on__c,id,Description__c, byday__c,Last_Event_Date__c,Count__c,Interval__c,Freq__c,Until__c,Google_Event_Id__c,Start_date__c,End_date__c,Summary__c from Google_Recurring_Events__c where Recurring_Events__c= true AND Broker__r.Active_Broker__c = true ];
        if(RSet.size() > 0){
            Google_API_Setting__c objGset = Google_API_Setting__c.getValues('Google_Setting');
            Integer Eventdaylimit = (Integer) objGset.upto_period__c *7;
            Datetime Eventlimit = system.now().addDays(Eventdaylimit);
            User_Eml_Id_Map= new Map<String,Id>();  // Create Map of user email and id
            Ulist= [select id,Email from User where IsActive = true];     // Create List of User for getting the id and Email
            for (User u_obj : Ulist){
                User_Eml_Id_Map.put(u_obj.Email, u_obj.id);  // add email id in the map
            }    
            for(Google_Recurring_Events__c  obj1 :RSet)
            {
                 event_id_set.add(obj1.id);
            }       
            //system.Debug('Set'+event_id_set);     
            List<Event>Elist= [Select Whatid,StartDateTime,EndDateTime,Event_ID__c, createdDate from Event where Event_ID__c in:event_id_set order by Event_ID__c];
           // system.debug('HELLO'+Elist);
            Map<string, integer> mp = new Map<string, integer>();
            for(Event ob :Elist){
                Integer i = 0;
                if(mp.get(ob.Event_ID__c) != null){
                    i = mp.get(ob.Event_ID__c);
                    //system.debug(mp.get(ob.Event_ID__c)+' JJJ::: '+i+' => '+ob.Event_ID__c);
                    mp.put(ob.Event_ID__c,i + 1);
                    
                }else{
                    mp.put(ob.Event_ID__c,1);
                    //system.debug('iiii::::'+i);
                }
            }
            List<Google_Recurring_Events__c> rlst = new List<Google_Recurring_Events__c>();
            //system.debug(Elist.size()+' =>>>> '+RSet.size());
            for(Google_Recurring_Events__c gre :RSet){                
                integer i = 0;
                for(Event ob :Elist){
               // system.debug(gre.Count__c+' 11111 '+mp.get(ob.Event_ID__c));
                    if(gre.id == ob.Event_ID__c && ((gre.Count__c != null && mp.get(ob.Event_ID__c) < gre.Count__c) || (gre.Until__c != null && gre.Until__c > gre.Last_Event_Date__c) ||(gre.Until__c == null && gre.Count__c == null))){
                        i++;
                        //system.debug('222222');
                        //break;
                    }
                }
               // system.debug('iiii:::'+i);
                if(i > 0){
                    rlst.add(gre);
                }
            }
           // system.debug('2323 '+rlst);
    
          Set<String> email_set= new Set<String>();
          List<Broker__c> broker_list= new List<Broker__c>();
          for(Google_Recurring_Events__c obj:rlst)
          {
                string st=obj.Google_Event_Id__c;
                String [] emailarray = (st).split('~',2);
                String emailid =emailarray[1];          
                email_set.add(emailid);
          }
       // system.debug('GList'+rlst);
        broker_list=[select id,Email__c from Broker__c Where Email__c in:email_set];
        
        for (Broker__c b_obj : broker_list){
                Broker_map.put(b_obj.Email__c, b_obj);  // add email id in the map
            }   
        
        for(Google_Recurring_Events__c obj:rlst)
        {
           
                Google_Recurring_Events__c cusobj= new Google_Recurring_Events__c();
                cusobj = obj;
                string st=obj.Google_Event_Id__c;
                String [] emailarray = (st).split('~',2);
                Broker__c bobject = new Broker__c();
                if(Broker_map.get(emailarray[1]) != null){
                    bobject = Broker_map.get(emailarray[1]);
                }
                //broker_list=[select id from Broker__c Where Email__c in:email_set];
                             
                Event et= new Event();
                et.Subject=obj.Summary__c;

                if(User_Eml_Id_Map.containsKey(emailarray[1])){
                        et.ownerid=User_Eml_Id_Map.get(emailarray[1]);
                    }
             
                           et.whatid=bobject.id;
                           
                           et.Description=obj.Description__c; 
                           et.Event_ID__c=obj.id;
                          
                         //  Integer hh=(obj.End_date__c).hour()-(obj.Start_date__c).hour();
                          Long mm=(obj.End_date__c).getTime()-(obj.Start_date__c).getTime();
                           Integer hh= (Integer)(mm/1000)/60;
                           
                           
                           //et.StartDateTime=(obj.Last_Event_Date__c).addDays(1);
                          // et.EndDateTime=(obj.Last_Event_Date__c).addDays(1).addHours(hh);
              
                 if(obj.Freq__c=='DAILY')
                     {
                       if(obj.Interval__c !=null && obj.Until__c== null && obj.count__c == null )
                           {
                              
                               et.StartDateTime=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c);
                               et.EndDateTime=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c).addMinutes(hh);
                               cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c);
                               et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);          
                           }
                             
                        else
                        {
                        if(obj.Interval__c !=null && obj.Until__c!= null && obj.count__c== null )
                            {
                              if(obj.Last_Event_Date__c<=obj.Until__c)
                                  {
                                    et.StartDateTime=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c);
                                    et.EndDateTime=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c).addMinutes(hh); 
                                    cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c);    
                                    et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);
                                   }
                             }
        
                         else
                            {
                                 Integer count=(Integer)((obj.Interval__c*obj.count__c)-(obj.Interval__c));
                                 if(obj.Last_Event_Date__c<obj.Start_date__c.addDays(count))
                                  {
                                //    system.debug('Hi');
                                    et.StartDateTime=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c);
                                    et.EndDateTime=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c).addMinutes(hh);
                                    cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addDays((Integer)obj.Interval__c);
                                    et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);             
                                  //  system.debug('STDATE'+et.StartDateTime);
                                   // system.debug('ENDATE'+et.EndDateTime);
                                  }     
                            }
                          }
                         
                          // Sin_evtlist.add(et);  
                     }
                         
                 if(obj.Freq__c=='WEEKLY')
                    {
                            
                          DateTime dt =  obj.Last_Event_Date__c.addDays(1);                          
                          DateTime ett = obj.Last_Event_Date__c.addDays(10);
                        while(dt <= ett){
                            //system.debug(ett+'!! '+dt);
                            String DOW = dt.format('E').left(2);
                            if(obj.byday__c.contains(DOW.toUpperCase())){
                               // system.debug('!!!! '+dt);
                                if(obj.Interval__c !=null && obj.Until__c== null && obj.count__c == null ){
                                  et.StartDateTime=(dt).addDays((Integer)(7*(obj.Interval__c -1 )));
                                  et.EndDateTime=(dt).addDays((Integer)(7*(obj.Interval__c -1 ))).addMinutes(hh);
                                  cusobj.Last_Event_Date__c=(dt).addDays((Integer)(7*(obj.Interval__c -1 ))); 
                                  et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);          
                                 // system.debug('!!!!!! '+dt);
                                  break;                                  
                                }else{
                                    if(obj.Interval__c !=null && obj.Until__c!= null && obj.count__c== null ){
                                      if(obj.Last_Event_Date__c<=obj.Until__c)
                                      {
                                        et.StartDateTime=(dt).addDays((Integer)(7*(obj.Interval__c -1 )));
                                        et.EndDateTime=(dt).addDays((Integer)(7*(obj.Interval__c -1 ))).addMinutes(hh); 
                                        cusobj.Last_Event_Date__c=(dt).addDays((Integer)(7*(obj.Interval__c -1 )));
                                        et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);           
                                       // system.debug('!!!!!! '+dt);
                                        break;
                                      }
                                    }else{
                                       Integer count=(Integer)((obj.Interval__c*obj.count__c)-(obj.Interval__c));
                                       if(obj.Last_Event_Date__c<obj.Start_date__c.addDays(7*count))
                                          {
                                            et.StartDateTime=(dt).addDays((Integer)(7*(obj.Interval__c -1 )));
                                            et.EndDateTime=(dt).addDays((Integer)(7*(obj.Interval__c -1 ))).addMinutes(hh);
                                            cusobj.Last_Event_Date__c=(dt).addDays((Integer)(7*(obj.Interval__c -1 ))); 
                                            et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);          
                                          //  system.debug('!!!!!! '+dt);
                                            break;                                          
                                          }     
                                    }
                                }  
                            }
                            dt = dt.addDays(1);
                        }
                 //  Sin_evtlist.add(et);  
                  }
              
           if(obj.Freq__c=='MONTHLY')
             {
                if(obj.Repeats_on__c!=null && obj.byday__c != null){
                    Google_Recurring_Events__c tmpOB = new Google_Recurring_Events__c();
                    Datetime tempST = obj.Last_Event_Date__c.addMonths(1);
                    
                    tmpOB.start_date__c = DateTime.newInstance(tempST.year(),tempST.month(),1,obj.Last_Event_Date__c.hour(),obj.Last_Event_Date__c.minute(),obj.Last_Event_Date__c.second());
                    tmpOB.end_date__c = DateTime.newInstance(tempST.year(),tempST.month(),1,obj.Last_Event_Date__c.hour(),obj.Last_Event_Date__c.minute(),obj.Last_Event_Date__c.second());
                    tempST = tmpOB.start_date__c.addMonths(1).addDays(-1);
                    Integer j = 0;
                    Datetime tempST2 = tempST.addDays(-7);
                    //system.debug(tempST+' !!BINGO '+tmpOB.start_date__c);
                    while(tmpOB.start_date__c <= tempST){
                        //system.debug(tempST+'!! '+tmpOB.start_date__c);
                        String DOW = tmpOB.start_date__c.format('E').left(2);
                        
                        if(obj.byday__c.contains(DOW.toUpperCase())){
                            j++;
                           // system.debug(j+'!!! '+obj.byday__c);
                            if(j == Integer.valueOf(obj.Repeats_on__c) || ( obj.Repeats_on__c == '-1' && tempST2 < tmpOB.start_date__c)){
                               // system.debug('!!!! '+j);  
                                if(obj.Interval__c !=null && obj.Until__c== null && obj.count__c == null )
                                {
                                    et.StartDateTime=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1);
                                    et.EndDateTime=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1).addMinutes(hh);       
                                    cusobj.Last_Event_Date__c=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1); 
                                    et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);           
                                 }
                               else
                               {  
                                 if(obj.Interval__c !=null && obj.Until__c!= null && obj.count__c== null )
                                {
                                     if(obj.Last_Event_Date__c<=obj.Until__c)
                                     {
                                        et.StartDateTime=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1);
                                        et.EndDateTime=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1).addMinutes(hh);
                                        cusobj.Last_Event_Date__c=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1); 
                                        et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);             
                                     }
                                
                                  }

                               else
                                {
                                     Integer count=(Integer)((obj.Interval__c*obj.count__c)-(obj.Interval__c));
                                     if(obj.Last_Event_Date__c<obj.Start_date__c.addMonths(count))
                                     {
                                        et.StartDateTime=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1);
                                        et.EndDateTime=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1).addMinutes(hh);  
                                        cusobj.Last_Event_Date__c=(tmpOB.start_date__c).addMonths((Integer)obj.Interval__c - 1);
                                        et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);            
                                     }
                                
                                }
                            }
                        }
                    }
                    tmpOB.start_date__c= tmpOB.start_date__c.addDays(1);
                    tmpOB.end_date__c= tmpOB.end_date__c.addDays(1);
                }
            }else{
                if(obj.Interval__c !=null && obj.Until__c== null && obj.count__c == null )
                    {
                       
                        et.StartDateTime=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c);
                        et.EndDateTime=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c).addMinutes(hh);       
                        cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c);
                        et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);            
                     }
                   else
                   {  
                     if(obj.Interval__c !=null && obj.Until__c!= null && obj.count__c== null )
                    {
                         if(obj.Last_Event_Date__c<=obj.Until__c)
                         {
                            et.StartDateTime=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c);
                            et.EndDateTime=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c).addMinutes(hh);
                            cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c); 
                            et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);             
                         }
                    
                      }

                   else
                    {
                         Integer count=(Integer)((obj.Interval__c*obj.count__c)-(obj.Interval__c));
                         if(obj.Last_Event_Date__c<obj.Start_date__c.addMonths(count))
                         {
                            et.StartDateTime=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c);
                            et.EndDateTime=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c).addMinutes(hh);  
                            cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addMonths((Integer)obj.Interval__c);
                            et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);           
                         }
                    
                    }
                }
            }
            // Sin_evtlist.add(et);  
       }
     
      if(obj.Freq__c=='YEARLY')
       {
        if(obj.Interval__c !=null && obj.Until__c== null && obj.count__c == null )
                    {
                       
                        et.StartDateTime=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c);
                        et.EndDateTime=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c).addMinutes(hh);  
                        cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c);
                        et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);                
                         
                     }
                    else
                    { 
                     if(obj.Interval__c !=null && obj.Until__c!= null && obj.count__c== null )
                    {
                         if(obj.Last_Event_Date__c<=obj.Until__c)
                         {
                            et.StartDateTime=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c);
                            et.EndDateTime=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c).addMinutes(hh);  
                            cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c); 
                            et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);          
                         }
                    
                    }

                    else
                    {
                         Integer count=(Integer)((obj.Interval__c*obj.count__c)-(obj.Interval__c));
                         if(obj.Last_Event_Date__c<obj.Start_date__c.addYears(count))
                         {
                            et.StartDateTime=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c);
                            et.EndDateTime=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c).addMinutes(hh); 
                            cusobj.Last_Event_Date__c=(obj.Last_Event_Date__c).addYears((Integer)obj.Interval__c); 
                            et.Google_Event_Id__c=Saasfocus_Global.recurid(obj.Google_Event_Id__c,et.StartDateTime);           
                         }
                    
                    }
                  }
                  
          }
          if(et.StartDateTime != null && et.StartDateTime.date()<Eventlimit.date()){
               if(obj.Until__c != null ){
                   if(obj.Until__c >= et.StartDateTime){
                        Google_Event_Objlst.add(cusobj);
                        Sin_evtlist.add(et);   
                        //system.debug(et.StartDateTime+'Second'+obj.Until__c);
                    }
                }else{
                    // system.debug(et.StartDateTime+'First'+obj.Until__c);
                    Google_Event_Objlst.add(cusobj);
                    Sin_evtlist.add(et);
                }                       
            }
        }
        if(Google_Event_Objlst.size()>0)
        {
        update Google_Event_Objlst;
       }
       try{
        if(Sin_evtlist.size()>0){
        
                 Set<String> myset = new Set<String>();
                 List<Event> result = new List<Event>();
                  for (Event s : Sin_evtlist) {
                 
                  if(myset.contains(s.Google_Event_Id__c) == false)
                  {
                              myset.add(s.Google_Event_Id__c);
                              result.add(s);
                  }
                 system.debug('RRR'+result);
              
              
              }
        insert result;
      
       // insert Sin_evtlist;
       // system.debug('!Bingo '+Sin_evtlist);
        }
        }
        catch(Exception e){
            system.debug('!Bingo delete error=> '+e);
        }
   }
   
 }
}