// --------------------------------------------------------------------------------------
// This class is for allocate appointment with their corresponding free Available broker

// Version#        Date             Author              Description
// --------------------------------------------------------------------------------------
//   1.0           17/04/2015    Neeraj Rawat         Initial Version
// --------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------
// Notes:
// --------------------------------------------------------------------------------------
//   Test coverage for SaaSFocus_AppointmentController :

public class SaaSFocus_AppointmentController
{

public String IdBroker{get;set;}
 public  Datetime EveStartTime;
 public  Datetime EveEndTime;
  public List<Saasfocus_EventClass> CalenderEvents;
  public datetime AppStarttime;
  public Integer offset ;
  public Set<id> freebroker;
  String appointmentId;
  public  String selectedtime{get;set;} //  Time chosen by user
  public Integer DurationOfMeeting;
  public Integer Buffer;
  public Integer IntervalOfMeeting;
  public String AppointmentType;
  public Time DayStartTime;
  public Time DayEndTime;
  public Map<Time,Set<Id>> MapTimetoBrokerid;
  Public Set<ID> Allbrokers;
  public Set<ID> NewSet;
  public Appointment__c Appointob {get;set;}
  public Set<id> BusyBrokerInThisTime;
  public Set<id> AvaialableBrokerInThisTime;
  public List<Market_Broker_Association__c> LstBrokerMarket;
  public String displaytime;
  public String Stringtime;
  List<Broker__c > lstskilledbroker;
  public Time  Stime;
  public Time NewConvertedtime;
  Public  datetime queryDatetime;
  Public string usertype;
  Public Map<string,set<id>> showbrokers {get;set;}
  public Time EventStarttime ;
  public Time EventEndtime;


public SaaSFocus_AppointmentController()
     // Constructor
  {   Allbrokers = new Set<Id>();
      appointmentId= ApexPages.currentPage().getParameters().get('id');    // Get id from apex page
      Appointob = new Appointment__c();
      Appointob =[SELECT Id,Name,Account_Name__c,Account_Email__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Date_and_Time__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id FROM Appointment__c where id=:appointmentId];

      BusyBrokerInThisTime= new Set<Id>();
      AvaialableBrokerInThisTime = new Set<ID>();
      lstskilledbroker = new List<Broker__c >();

       offset = (Integer) (Appointob.region__r.Sydney_Timezone_Offset__c *60);
       system.debug('!limca' +offset );
       if(ApexPages.currentPage().getParameters().get('err') != null && ApexPages.currentPage().getParameters().get('err') =='1')
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The system was found to be out of sync. Please try again');
           ApexPages.addMessage(myMsg);
       }
      if(Appointob.Appointment_Type__c == 'Phone Appointment')    // If the type of Appointment is phone appointment
      {

       Allocate_Appointment__c  obj =  Allocate_Appointment__c.getValues('Phone_Broker');

       DurationOfMeeting = Integer.valueOf(obj.DurationOfMeeting__c);
                 Buffer  = Integer.valueOf(obj.Buffer__c);
       IntervalOfMeeting = Integer.valueOf(obj.IntervalOfMeeting__c);
        DayStartTime= Time.newInstance(Integer.valueOf(obj.DayStartTime__c),00,0,0);
        DayEndTime  =Time.newInstance(Integer.valueOf(obj.DayEndTime__c),00,0,0);
        LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where  Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c) and Broker__r.Channel__c ='Phone Broker' and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and  Broker__r.Active_Broker__c = true];// Input All broker’s Id in the system.
         System.debug('List1' +LstBrokerMarket );
        if(Appointob.Speciality_Skills__c == null)
        LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Channel__c ='Phone Broker' and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and  Broker__r.Active_Broker__c = true];// Input All broker’s Id in the system.
         System.debug('List2' +LstBrokerMarket );
      }
     else
       {
        // type of Appointment is face to face appointment
        Allocate_Appointment__c   obj2 =   Allocate_Appointment__c.getValues('Face_To_face');

       DurationOfMeeting =  Integer.valueOf(obj2.DurationOfMeeting__c);
                  Buffer =  Integer.valueOf(obj2.Buffer__c);
       IntervalOfMeeting =  Integer.valueOf(obj2.IntervalOfMeeting__c);
         DayStartTime= Time.newInstance(Integer.valueOf(obj2.DayStartTime__c),00,0,0);
        DayEndTime  =Time.newInstance(Integer.valueOf(obj2.DayEndTime__c),00,0,0);

        LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where Market__r.Id=:Appointob.Market__r.Id and Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c) and Broker__r.Channel__c !='Phone Broker'and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and Market__r.Region__c = :Appointob.Region__c and Broker__r.Active_Broker__c = true];// Input All broker’s Id in the system.
         System.debug('ListFaceToFace' +LstBrokerMarket );
        if(Appointob.Speciality_Skills__c == null)
        LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where Market__r.Id=:Appointob.Market__r.Id  and Broker__r.Channel__c !='Phone Broker'and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName()  and Market__r.Region__c = :Appointob.Region__c and Broker__r.Active_Broker__c = true];// Input All broker’s Id in the system.
         System.debug('ListFaceToFace' +LstBrokerMarket );

  }

  }
   public pagereference getFreeBrokers()
   // Define method for getting free broker with their available  time
{
    // if logged in user is a broker itself, get the broker
   if(ApexPages.currentPage().getParameters().get('aid') != null){
        //Event e = new Event();
        //e = [select id, ];
        List<id> ids = new List<id>();
        ids.add(ApexPages.currentPage().getParameters().get('aid'));
        system.debug('harish' +ids);
        GoogleCalendarService.insertGoogleEvent(ids);
        return new pagereference('/'+ApexPages.currentPage().getParameters().get('id'));
   }else{
   string selfid = selfappointment();
   if(selfid != null )
   {
    if(Appointob.Speciality_Skills__c == null)
    LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Id =:selfid and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName()  and Broker__r.Active_Broker__c = true and Broker__r.Channel__c ='Phone Broker'];// Input All broker’s Id in the system.
    else
    LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c) and Broker__r.Id =:selfid and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and Broker__r.Active_Broker__c = true and Broker__r.Channel__c ='Phone Broker'];// Input All broker’s Id in the system.

   if( LstBrokerMarket.size()==0)

    LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c)  and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and Broker__r.Active_Broker__c = true and Broker__r.Channel__c ='Phone Broker'];// Input All broker’s Id in the system.
   }

 if(LstBrokerMarket.size()==0)
 {
  // Error message

   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'No Broker found for this date with either or All of the below mentioned reasons. Please select another date.');
   ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,' No Broker with Speciality skills');
   ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,' No Broker in selected Market');
   ApexPages.Message myMsg4 = new ApexPages.Message(ApexPages.Severity.ERROR,' No Broker in the selected Region');
   ApexPages.Message myMsg5 = new ApexPages.Message(ApexPages.Severity.ERROR,'No Active Broker');

   ApexPages.addMessage(myMsg1);
   ApexPages.addMessage(myMsg2);
   ApexPages.addMessage(myMsg3);
   ApexPages.addMessage(myMsg4);
   ApexPages.addMessage(myMsg5);

 }

   for(Market_Broker_Association__c obj:LstBrokerMarket )
           {
              Allbrokers.add(obj.Broker__r.Id);
            }

                Datetime sdt = Datetime.newInstance(Appointob.Appointment_Date_and_Time__c.date(),DayStartTime.addminutes(offset));
                Datetime edt = Datetime.newInstance(Appointob.Appointment_Date_and_Time__c.date(), DayEndTime.addminutes(-IntervalOfMeeting+DurationofMeeting+Offset));
                system.debug('think' +sdt );
                system.debug('think' +edt );




                List<Event> todaysevent  = [Select id,IsAllDayEvent,StartDateTime,EndDateTime,whatid from Event where whatid in:Allbrokers and ((startdatetime <= :sdt and enddatetime >:sdt) OR  (Startdatetime < :edt and Enddatetime >= :edt) OR  (Startdatetime >= :sdt and Enddatetime <= :edt) OR (Startdatetime <= :sdt and Enddatetime >= : edt)) ];
                System.debug('bingo222' +todaysevent);
                System.debug('madangle' +Allbrokers);
                DayEndTime = DayEndTime.addminutes(-IntervalOfMeeting);


                    MapTimetoBrokerid = new Map<Time,Set<Id>>();
                   // This map will contain start time and occupied brokers
                    for(Event eobj : todaysevent)
                     {
                          // Add logic of buffer hours
                          system.debug('Event start time :'+eobj.StartDateTime);
                          system.debug('Event End time :'+eobj.EndDateTime);

                             EventStarttime = ((eobj.StartDateTime).time()).addminutes(-offset);

                             EventEndtime = ((eobj.EndDateTime).time()).addminutes(-offset);
                             system.debug('Event ye hai start time :'+EventStarttime );
                             system.debug('Event ye hai end time :'+EventEndtime );
                              // replace below with the method

                             if(eobj.IsAllDayEvent || eobj.startdatetime <= sdt  )
                             {
                                 EventStarttime = Daystarttime;
                                 system.debug('info.'+EventEndtime );

                             }



                             if(eobj.IsAllDayEvent || eobj.enddatetime >= edt)
                             {
                                  EventEndtime = DayEndTime;
                                  system.debug('kkkk '+EventEndtime );
                             }


                              System.debug('areeee' +EventStarttime );
                              System.debug('areeee bhai' +EventEndtime );

                   if( EventEndtime < Daystarttime || EventStarttime >DayEndTime )
                   // continue;

                    EventStarttime =RoundtoHour(EventStarttime );
                     system.debug('kkkkkk :'+EventStarttime );
                   // loop from start time to end time .. make user busy starttime - buffer time TO end time + interval time
                   for(Time st=EventStarttime.addminutes((-1)*(Buffer+DurationOfMeeting-IntervalOfMeeting ));st<EventEndtime.addminutes(Buffer);st=st.addminutes(IntervalOfMeeting))
                     {
                          system.debug('duster' +st);


                       if( st< Daystarttime || st > DayEndTime )
                       continue;

                        st = RoundtoHour(st); // Round to nearest hour
                         system.debug('possible' +st );

                       if (MapTimetoBrokerid.get(st)== null)
                       MapTimetoBrokerid.put(st,new set<id>());
                       MapTimetoBrokerid.get(st).add(eobj.whatid);

                     }

                 }
                     System.debug('neeraj' +MapTimetoBrokerid);

               // By end of below loop map will contain start time with free borker
       for(Time initialtime =DayStartTime; initialtime <= DayEndTime; initialtime = initialtime.addminutes(IntervalOfMeeting))
            {
                 set<id> tempAllbrokerid = Allbrokers.clone();
                  System.debug('temp' +tempAllbrokerid );
                   //if value existing in map
                if(MapTimetoBrokerid.get(initialtime )==null)
                MapTimetoBrokerid.put(initialtime ,Allbrokers.clone());
                else
                {
                  Set<id> BusyBrokerInThisTime = MapTimetoBrokerid.get(initialtime );
                  System.debug('hero' +BusyBrokerInThisTime );
                  tempAllbrokerid.removeAll(BusyBrokerInThisTime);

                  System.debug('ohoo' +tempAllbrokerid);
                  MapTimetoBrokerid.put(initialTime,tempAllbrokerid );
                  System.debug('link' +MapTimetoBrokerid);

                 }
            }

            //  remove all blank keys
            for(Time eacht: MapTimetoBrokerid.keyset())
            {
                if(MapTimetoBrokerid.get(eacht).size()==0)
                MapTimetoBrokerid.remove(eacht);
            }
                System.debug('neeheheh' +MapTimetoBrokerid);

           IF(  MapTimetoBrokerid.size() == 0 )
           {
               ApexPages.Message myMsg6 = new ApexPages.Message(ApexPages.Severity.ERROR,'All brokers are busy on this date. Plese select another date');

               ApexPages.addMessage(myMsg6 );
           }

     }
     return null;
}


       public List<SelectOption> getAvailableSchedule()
       // Define a Method for chose time from given time list in apex page

         {
         List<DateTime> LstMapKey = new List<DateTime>();
         List<SelectOption> Option = new List<SelectOption>();
         for(Time obj:MapTimetoBrokerid.keyset())
         {
          LstMapKey.add(DateTime.newInstance(2015,12,12,obj.hour(),obj.minute(),0));
         }
         LstMapKey.sort();

         showbrokers = new Map<string,set<id>>();

         for(DateTime eacht : LstMapKey)
        {
         Datetime dt = Datetime.newInstance(2015,12,12,eacht.hour(),eacht.minute(),0);
         String ConvertDate = String.valueOf(eacht);
         Option.add(new SelectOption(ConvertDate,dt.format('hh:mm a') ));


         }
          System.debug('Finalmap' +Option);
          return Option;
          }

           Public Pagereference Confirm()
        {
             SaaSFocus_Distribute_appointment  objct = new SaaSFocus_Distribute_appointment();
             Time selectedT = Datetime.valueOf(selectedtime).time();
             IdBroker= objct.Compensatory_appointment(MapTimetoBrokerid.get(selectedT),LstBrokerMarket);


             System.debug('vt' +IdBroker );

             AppStarttime  =  Datetime.newInstance(Appointob.Appointment_Date_and_Time__c.date(),selectedT);
             AppStarttime  = AppStarttime.addminutes(offset );

             if(AppStarttime.time() == DayStartTime.addminutes(offset)){
             EveStartTime = AppStarttime;
             System.debug('appStarttime' +EveStartTime );
             }
             else
             {
             EveStartTime  = AppStarttime.addminutes((-1)*Buffer);
             System.debug('appStarttimeelse' +EveStartTime );
             }

             EveEndTime   = AppStarttime.addminutes(Buffer + DurationOfMeeting);

              if(AppStarttime.time().addMinutes(DurationOfMeeting)>=DayEndTime.addminutes(offset))
              EveEndTime = AppStarttime.addminutes(DurationOfMeeting);


             Saasfocus_GetGoogleEvent ob = new Saasfocus_GetGoogleEvent();
             CalenderEvents  = ob.getEventslist(EveStartTime,EveEndTime ,IdBroker);


              if(CalenderEvents.size() > 0)

         {

            // getFreeBrokers();
            pagereference pg= new pagereference('/apex/SaaSFocus_Allocate_Appointment?id='+appointmentId +'&err=1');
            pg.setRedirect(true);
            return pg;



         }

             else
              {

             Appointob.Broker__c= IdBroker;

             System.debug('hey' +Appointob.Broker__c);
             Datetime DT = Datetime.newInstance(Appointob.Appointment_Date_and_Time__c.year(),Appointob.Appointment_Date_and_Time__c.month(),Appointob.Appointment_Date_and_Time__c.day(),selectedT.hour(),selectedT.minute(),0);
             Appointob.Appointment_Date_and_Time__c=DT ;
             update Appointob;
             Appointob.RecordTypeId = [Select Id from RecordType where Name='Confirmed Appointment' limit 1].id;
             update Appointob;

              Broker__c Assignedbroker = [select id,Email__c from Broker__c where id =:IdBroker];

              List<User> brokeruser = [select id ,  Email from User where Email = :Assignedbroker.Email__c];

             Event e = new Event();

             if(brokeruser.size()>0)
             e.ownerid = brokeruser[0].id;

             e.Startdatetime= DT;
             e.Enddatetime= e.Startdatetime.addminutes(DurationOfMeeting);
             // calculate offset . Bijay
              if(offset !=null)
              {
               e.startdatetime = e.startdatetime.addMinutes(offset);
               e.enddatetime = e.enddatetime.addMinutes(offset);
               }


             String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();


             e.whatid= Appointob.Broker__c;
             e.Subject= Appointob.Name+ '-' +Appointob.Street_Address__c +' ' +Appointob.City__c +' ' +Appointob.State__c +' '  +Appointob.Postal_Code__c +'-' +Appointob.Phone__c +'-' +Appointob.Appointment_Type__c;
             e.Subject=e.Subject.replace('-null','');
             e.Subject=e.Subject.replace('null-','');
             e.Subject=e.Subject.replace('null','');
             e.Location = Appointob.Street_Address__c+','+Appointob.City__c+','+Appointob.State__c+','+Appointob.Postal_Code__c;
             e.Location =e.Location.replace(',null','');
             e.Location =e.Location.replace('null,','');
             e.Location =e.Location.replace('null','N/A');

              string s1 = '';
             if(Appointob.Pre_Sales_Notes__c != null){
                 s1 = Appointob.Pre_Sales_Notes__c;
                 s1=  s1.stripHtmlTags();
             }
             system.debug('neeeeeeee'+Appointob.Pre_Sales_Notes__c);
             system.debug('neeee2222'+Appointob.Street_Address__c);
             string nextline = '\n';
             e.Description = 'Appointment Reference: ' + Appointob.Name + nextline+ 'Date and Time Of Appointment:'+' '+Appointob.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')+nextline+
             'Customer Mobile:'+' '+Appointob.Mobile__c+nextline+
             'Customer Phone:'+' '+ Appointob.Phone__c +nextline+
             'Customer Location:'+' '+Appointob.Street_Address__c+','+Appointob.City__c+','+Appointob.State__c+','+Appointob.Postal_Code__c+nextline+
             'Customer Email:'+' '+Appointob.Account_Email__c+nextline+
             'Customer Name:'+' '+Appointob.Account_Name_Text__c+nextline+nextline+
             'Notes from Pre Sales' +nextline+
             +s1+nextline+nextline+
             'Opportunity Details:'+' '+nextline+
             'Transaction Type:'+' '+Appointob.Transaction_Type__c+nextline+
             'Current Lender:'+' ' +Appointob.Current_Lender__c+nextline+
             'Current Loan Value:'+' ' +Appointob.Current_Loan_Value__c+nextline+
             'Current Loan Type:' +' '+Appointob.Current_Loan_Type__c+nextline+
             'Current Interest Rate:'+' '+Appointob.Current_Interest_Rate__c+nextline+
             'Current Interest Rate Type:'+' '+Appointob.Current_Interest_Rate_Type__c+nextline+
             'Current Financials Up to Date:'+' '+Appointob.Current_Financials_Up_to_Date__c+nextline+
             'Last Refinanced: '+' '+Appointob.Last_Refinance__c+nextline+
             'Fixed Rate Expiry:'+' '+Appointob.Fixed_Rate_Expiry__c+nextline+
             'Age of Current Loan:'+' '+Appointob.Age_of_Current_Loan__c+nextline+nextline+nextline+
             'Income and Liability Details:'+' ' +nextline+
             'Employment Status:'+' '+ Appointob.Employment_Status__c +nextline+
             'Industry: '+' '+Appointob.Industry__c +nextline+
             'Annual Income:'+' '+Appointob.Annual_Income__c +nextline+
             'Partner Annual Income: '+' '+Appointob.Partner_Income__c +nextline+
             'Credit Card Balance: '+' '+Appointob.Credit_Card_Balance__c +nextline+
             'Personal Loan Balance:'+' '+Appointob.Personal_Loan_Balance__c;
              e.Description=e.Description.replace(',null','');
              e.Description=e.Description.replace('null,','');
              e.Description=e.Description.replace('null','N/A');


             System.debug('capacity' +e);
             insert e;
            SaaSFocus_Distribute_appointment  objct2 = new SaaSFocus_Distribute_appointment();
             objct2.compensatory_appointment_1(IdBroker); // Update complementary count / calendar

             ob.ob.updategooglesettings();

            Utilities.sendAppointmentConfirmEmail(appointmentId);
           // return new pagereference('/'+appointmentId);
           pagereference pg = new pagereference('/apex/SaaSFocus_Allocate_Appointment?id='+appointmentId+'&aid='+e.id);
           pg.setRedirect(true);
           return pg;
         }

      }


       Public Pagereference Cancel()
        {
         return new pagereference('/'+appointmentId);
         }


      public Time RoundtoHour( time EventStarttime  )
      {

             Time temproundedtime;

             if(EventStarttime < DayStartTime)
             {
                 for(Time initialtime =DayStartTime; initialtime >= EventStarttime  ; initialtime = initialtime.addminutes(-IntervalOfMeeting))
                 {
                   temproundedtime = initialtime;

                 }

             }
             else
             {

             for(Time initialtime =DayStartTime; initialtime <= EventStarttime  ; initialtime = initialtime.addminutes(IntervalOfMeeting))
                 {
                   temproundedtime = initialtime;

                 }

               }
                return  temproundedtime ;
       }


   public time  convertStringToTime(String selectedtime ) // Define a method for convert string to time
{
    List<String> newLst = new List<String>();
    newLst= selectedtime.split(':');
    return Time.newInstance(Integer.valueOf(newLst[0]),Integer.valueOf(newLst[1]),0,0);

}

Public string selfappointment()
{
  // if current logged in user Email matches with any of the broker's Email , return broker id else return null
   User current_user=[SELECT Email FROM User WHERE Id= :UserInfo.getUserId()] ;
   List<Broker__c> lst = [select Id,Email__c from Broker__c where Email__c=:current_user.Email ];
   if(lst.size()>0)
   {
       return lst[0].Id;
   }
   else
   return null;
}

    }
