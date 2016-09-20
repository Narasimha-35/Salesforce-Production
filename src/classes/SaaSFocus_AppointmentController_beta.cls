// --------------------------------------------------------------------------------------
// This class is for allocate appointment with their corresponding free Available broker

// Version#        Date             Author              Description
// --------------------------------------------------------------------------------------
//   2.0           08/09/2015    Laxman Singh         Updated Version
// --------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------
// Notes:
// --------------------------------------------------------------------------------------
//   Test coverage for SaaSFocus_AppointmentController :

public class SaaSFocus_AppointmentController_beta {
    public Integer offset ;
    public String note{get;set;}
    String appointmentId;
    public  String selectedtime{get;set;} //  Time chosen by user
    public Integer DurationOfMeeting;
    public Integer Buffer;
    public Integer IntervalOfMeeting;
    public String AppointmentType;
    public Time DayStartTime;
    public Time DayEndTime;
    public Map<Time,Set<Id>> MapTimetoBrokeridnew;
    Public Set<ID> Allbrokers;
    public Appointment__c Appointob {get;set;}
    public Set<id> BusyBrokerInThisTime;
    public Set<id> AvaialableBrokerInThisTime;
    public List<Market_Broker_Association__c> LstBrokerMarket;
    List<Broker__c > lstskilledbroker;
    public Map<Date,Map<Time,Set<id>>> FinalMap;
    public List<List<SelectOption>> CalList{set;get;}
    Map<Time,Set<Id>> innermap;
    public string selfid;
    public Time EventStarttime ;
    public Time EventEndtime;
    public Datetime AppointmentDate{set;get;}
    public Integer flag;
    public integer maxdays;
    public boolean chkcolor{set;get;}
    public Integer Tempvar{get;set;}
    public Integer Temp1{get;set;}

    public class Busy {
        public Boolean isBusy;
        public List<GoogleCalendarModel.BusyItem> busyItems;
        public String brokerEmail;
    }

    private Boolean isDynamicTimeOffset = Allocate_Appointment__c.getValues('System').dynamicTimeOffset__c;

    public Integer getSydneyLocalMinuteDiff(Datetime dt, String timezone) {
        Datetime ldt = Datetime.valueOf(dt.format('yyyy-MM-dd HH:mm:ss', timezone));
        return (Integer) ((dt.getTime() - ldt.getTime()) / (60 * 1000));
    }

    public SaaSFocus_AppointmentController_beta() {
        init(ApexPages.currentPage().getParameters().get('id'), false);
    }

    public SaaSFocus_AppointmentController_beta(String appId) {
        init(appId, true);
    }

    public void init(String appId, Boolean testMode) {
        appointmentId = appId;
        flag=0;
        Allbrokers = new Set<Id>();
        Appointob = new Appointment__c();
        Appointob =[SELECT Id,Name,Account_Name__c,Account_Email__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Date_and_Time__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id, Region__r.timeZone__c FROM Appointment__c where id=:appointmentId];

        BusyBrokerInThisTime= new Set<Id>();
        AvaialableBrokerInThisTime = new Set<ID>();
        lstskilledbroker = new List<Broker__c >();

        if(isDynamicTimeOffset) {
            offset = getSydneyLocalMinuteDiff(Appointob.Appointment_Date_and_Time__c, appointob.region__r.timeZone__c);
        } else {
            offset = (Integer) (Appointob.region__r.Sydney_Timezone_Offset__c *60);
        }

        system.debug('!limca' +offset );
        if(!testMode && ApexPages.currentPage().getParameters().get('err') != null && ApexPages.currentPage().getParameters().get('err') =='1') {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ApexPages.currentPage().getParameters().get('message'));
            ApexPages.addMessage(myMsg);
        }
        if(Appointob.Appointment_Type__c == 'Phone Appointment') {
            // If the type of Appointment is phone appointment
            Tempvar=10;
            Allocate_Appointment__c  obj =  Allocate_Appointment__c.getValues('Phone_Broker');

            DurationOfMeeting = Integer.valueOf(obj.DurationOfMeeting__c);
            Buffer  = Integer.valueOf(obj.Buffer__c);
            IntervalOfMeeting = Integer.valueOf(obj.IntervalOfMeeting__c);
            DayStartTime= Time.newInstance(Integer.valueOf(obj.DayStartTime__c),00,0,0);
            DayEndTime  =Time.newInstance(Integer.valueOf(obj.DayEndTime__c),00,0,0);
            LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where  Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c) and Broker__r.Channel__c ='Phone Broker' and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and  Broker__r.Active_Broker__c = true];// Input All brokerâs Id in the system.
            System.debug('List1' +LstBrokerMarket );
            if(Appointob.Speciality_Skills__c == null)
            LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Channel__c ='Phone Broker' and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and  Broker__r.Active_Broker__c = true];// Input All brokerâs Id in the system.
            System.debug('List2' +LstBrokerMarket );
        } else {
            Tempvar=0;
            // type of Appointment is face to face appointment
            Allocate_Appointment__c   obj2 =   Allocate_Appointment__c.getValues('Face_To_face');

            DurationOfMeeting =  Integer.valueOf(obj2.DurationOfMeeting__c);
            Buffer =  Integer.valueOf(obj2.Buffer__c);
            IntervalOfMeeting =  Integer.valueOf(obj2.IntervalOfMeeting__c);
            DayStartTime= Time.newInstance(Integer.valueOf(obj2.DayStartTime__c),00,0,0);
            DayEndTime  =Time.newInstance(Integer.valueOf(obj2.DayEndTime__c),00,0,0);

            LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where Market__r.Id=:Appointob.Market__r.Id and Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c) and Broker__r.Channel__c !='Phone Broker'and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and Market__r.Region__c = :Appointob.Region__c and Broker__r.Active_Broker__c = true];// Input All brokerâs Id in the system.
            System.debug('ListFaceToFace' +LstBrokerMarket );
            if(Appointob.Speciality_Skills__c == null)
            LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c  from Market_Broker_Association__c  where Market__r.Id=:Appointob.Market__r.Id  and Broker__r.Channel__c !='Phone Broker'and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName()  and Market__r.Region__c = :Appointob.Region__c and Broker__r.Active_Broker__c = true];// Input All brokerâs Id in the system.
            System.debug('ListFaceToFace' +LstBrokerMarket );
        }
    }

    public pagereference setDates() {
        //This method is used to generate the previous and next Appointment dates according to the custom setting.
        Date dt=Appointob.Appointment_Date_and_Time__c.date();
        FinalMap=new Map<Date,Map<Time,Set<Id>>>();
        Define_Appointment_Dates__c appdate= Define_Appointment_Dates__c.getValues('AppointmentDate');
        integer prevdays=Integer.valueOf(appdate.previous_days__c);
        maxdays=Integer.valueOf(appdate.Maximum_days__c);
        // if logged in user is a broker itself, get the broker
        if(ApexPages.currentPage().getParameters().get('aid') != null){

            List<id> ids = new List<id>();
            ids.add(ApexPages.currentPage().getParameters().get('aid'));
            system.debug('harish' +ids);
            Saasfocus_GoogleCalenderHelper.processEvent(ids);
            return new pagereference('/'+ApexPages.currentPage().getParameters().get('id'));

        }
        else
        {
            selfid = selfappointment();
            if(selfid != null )
            {
                if(Appointob.Speciality_Skills__c == null) {
                    LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Id =:selfid and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName()  and Broker__r.Active_Broker__c = true and Broker__r.Channel__c ='Phone Broker'];// Input All brokerâs Id in the system.
                    System.debug(LstBrokerMarket);
                } else {
                    LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c) and Broker__r.Id =:selfid and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and Broker__r.Active_Broker__c = true and Broker__r.Channel__c ='Phone Broker'];// Input All brokerâs Id in the system.
                    System.debug(LstBrokerMarket);
                }

                if( LstBrokerMarket.size()==0) {
                    LstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  from Market_Broker_Association__c  where Broker__r.Speciality_Skills__c includes(:Appointob.Speciality_Skills__c)  and Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() and Broker__r.Active_Broker__c = true and Broker__r.Channel__c ='Phone Broker'];// Input All brokerâs Id in the system.
                    System.debug(LstBrokerMarket);
                }

            }
            while(prevdays>=0)
            {
                if(dt.adddays(-prevdays)>=system.today())
                {
                    AppointmentDate=dt.adddays(-prevdays);
                    if(AppointmentDate.format('EEEE')=='Saturday' || AppointmentDate.format('EEEE')=='Sunday')
                    {
                        chkcolor=true;
                    }
                    else
                    {
                        chkcolor=false;
                    }
                    system.debug('Check with system Date'+dt.adddays(-prevdays)+'today date=>'+system.now());
                    Date dtnew=dt.adddays(-prevdays);

                    for(integer i=1;i<=maxdays;i++)
                    {
                        System.debug('forloop dates'+dtnew);
                        innermap=new Map<Time,Set<Id>>();
                        innermap=getFreeBrokers(dtnew);
                        FinalMap.put(dtnew,innermap);
                        dtnew=dtnew.adddays(1);
                    }
                    break;
                }
                prevdays--;
            }
        }
        return null;
    }


    public Map<Time,Set<id>> getFreeBrokers(DateTime appdt) {
        // Define method for getting free broker with their available  time

        if(LstBrokerMarket.size()==0) {
            // Error message
            system.debug('hhhhh');
            tempvar=tempvar+1;
            if(tempvar==maxdays) {
                tempvar=1;
            }
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
        //return null;
        for(Market_Broker_Association__c obj:LstBrokerMarket ) {
            Allbrokers.add(obj.Broker__r.Id);
        }

        Datetime sdt = Datetime.newInstance(appdt.date(),DayStartTime.addminutes(offset));
        Datetime edt = Datetime.newInstance(appdt.date(), DayEndTime.addminutes(-IntervalOfMeeting+DurationofMeeting+Offset));
        system.debug('think' +sdt );
        system.debug('think' +edt );

        List<Event> todaysevent  = [Select id,IsAllDayEvent,StartDateTime,EndDateTime,whatid from Event where whatid in:Allbrokers and ((startdatetime <= :sdt and enddatetime >:sdt) OR  (Startdatetime < :edt and Enddatetime >= :edt) OR  (Startdatetime >= :sdt and Enddatetime <= :edt) OR (Startdatetime <= :sdt and Enddatetime >= : edt)) ];
        System.debug('bingo222' +todaysevent);
        System.debug('madangle' +Allbrokers);
        DayEndTime = DayEndTime.addminutes(-IntervalOfMeeting);
        Time tempdt=DayEndTime.addminutes(IntervalOfMeeting);

        Map<Time,Set<Id>> MapTimetoBrokeridnew = new Map<Time,Set<Id>>();
        // This map will contain start time and occupied brokers
        for(Event eobj : todaysevent) {
            // Add logic of buffer hours
            system.debug('Event start time :'+eobj.StartDateTime);
            system.debug('Event End time :'+eobj.EndDateTime);

            EventStarttime = ((eobj.StartDateTime).time()).addminutes(-offset);

            EventEndtime = ((eobj.EndDateTime).time()).addminutes(-offset);
            system.debug('Event ye hai start time :'+EventStarttime );
            system.debug('Event ye hai end time :'+EventEndtime );
            // replace below with the method

            if(eobj.IsAllDayEvent || eobj.startdatetime <= sdt) {
                EventStarttime = Daystarttime;
                system.debug('info.'+EventEndtime );
            }



            if(eobj.IsAllDayEvent || eobj.enddatetime >= edt) {
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
            for(Time st=EventStarttime.addminutes((-1)*(Buffer+DurationOfMeeting-IntervalOfMeeting ));st<EventEndtime.addminutes(Buffer);st=st.addminutes(IntervalOfMeeting)) {
                system.debug('duster' +st);
                if( st< Daystarttime || st > DayEndTime )
                continue;

                st = RoundtoHour(st); // Round to nearest hour
                system.debug('possible' +st );

                if (MapTimetoBrokeridnew.get(st)== null)
                MapTimetoBrokeridnew.put(st,new set<id>());
                MapTimetoBrokeridnew.get(st).add(eobj.whatid);
            }
        }
        System.debug('neeraj' +MapTimetoBrokeridnew);

        // By end of below loop map will contain start time with free borker
        for(Time initialtime =DayStartTime; initialtime <= DayEndTime; initialtime = initialtime.addminutes(IntervalOfMeeting)) {
            set<id> tempAllbrokerid = Allbrokers.clone();
            System.debug('temp' +tempAllbrokerid );
            //if value existing in map
            if(MapTimetoBrokeridnew.get(initialtime )==null)
            MapTimetoBrokeridnew.put(initialtime ,Allbrokers.clone());
            else {
                Set<id> BusyBrokerInThisTime = MapTimetoBrokeridnew.get(initialtime );
                System.debug('hero' +BusyBrokerInThisTime );
                tempAllbrokerid.removeAll(BusyBrokerInThisTime);

                System.debug('ohoo' +tempAllbrokerid);
                MapTimetoBrokeridnew.put(initialTime,tempAllbrokerid );
                System.debug('link' +MapTimetoBrokeridnew);
            }
        }

        //  remove all blank keys
        for(Time eacht: MapTimetoBrokeridnew.keyset()) {
            if(MapTimetoBrokeridnew.get(eacht).size()==0)
            MapTimetoBrokeridnew.remove(eacht);
        }
        System.debug('neeheheh' +MapTimetoBrokeridnew);

        if(MapTimetoBrokeridnew.size() == 0 ) {
            flag++;
        }
        if(flag==maxdays) {
            ApexPages.Message myMsg6 = new ApexPages.Message(ApexPages.Severity.ERROR,'All brokers are busy on this date. Plese select another date');
            ApexPages.addMessage(myMsg6 );
        }
        DayEndTime = tempdt;
        return MapTimetoBrokeridnew;
    }

    public List<List<SelectOption>> getAvailableSchedule() {
        // Define a Method for chose time from given time list in apex page
        CalList = new List<List<SelectOption>>();
        for(Date eachdatetime: finalmap.keyset()) {

            Map<Time,Set<ID>> MapTimetoBrokerid = finalmap.get(eachdatetime);
            MapTimetoBrokeridnew=MapTimetoBrokerid;
            List<DateTime> LstMapKey = new List<DateTime>();
            List<SelectOption> Option = new List<SelectOption>();
            for(Time obj:MapTimetoBrokerid.keyset()) {
                LstMapKey.add(DateTime.newInstance(eachdatetime.year(),eachdatetime.month(),eachdatetime.day(),obj.hour(),obj.minute(),0));
            }
            LstMapKey.sort();

            Map<string,set<id>> showbrokers = new Map<string,set<id>>();

            for(DateTime eacht : LstMapKey) {
                Datetime dt = Datetime.newInstance(eachdatetime.year(),eachdatetime.month(),eachdatetime.day(),eacht.hour(),eacht.minute(),0);
                String ConvertDate = String.valueOf(eacht);
                Option.add(new SelectOption(ConvertDate,dt.format('hh:mm a') ));
            }
            System.debug('Finalmap' +Option);
            CalList.add(option);

        }
        return CalList;
    }

    Public Pagereference Confirm() {

        String IdBroker;
        Datetime EveStartTime;
        Datetime EveEndTime;
        List<Saasfocus_EventClass> CalenderEvents;
        datetime AppStarttime;

        SaaSFocus_Distribute_appointment  objct = new SaaSFocus_Distribute_appointment();
        Time selectedT = Datetime.valueOf(selectedtime).time();
        DateTime appdt=  Datetime.valueOf(selectedtime);
        MapTimetoBrokeridnew = finalmap.get(appdt.date());
        IdBroker= objct.Compensatory_appointment(MapTimetoBrokeridnew.get(selectedT),LstBrokerMarket);

        Appointob.Appointment_Date_and_Time__c=appdt;

        System.debug('vt' +IdBroker );
        System.debug('New Date'+appdt.date()+'String =>'+selectedtime);
        AppStarttime  =  Datetime.newInstance(Appointob.Appointment_Date_and_Time__c.date(),selectedT);
        AppStarttime  = AppStarttime.addminutes(offset );

        if(AppStarttime.time() == DayStartTime.addminutes(offset)){
            EveStartTime = AppStarttime;
            System.debug('appStarttime' +EveStartTime );
        } else {
            EveStartTime  = AppStarttime.addminutes((-1)*Buffer);
            System.debug('appStarttimeelse' +EveStartTime );
        }
        EveEndTime   = AppStarttime.addminutes(Buffer + DurationOfMeeting);

        if(AppStarttime.time().addMinutes(DurationOfMeeting)>=DayEndTime.addminutes(offset))
        EveEndTime = AppStarttime.addminutes(DurationOfMeeting);

        Saasfocus_GetGoogleEvent ob = new Saasfocus_GetGoogleEvent(); //DML
        system.debug('Eventtime===>'+EveStartTime+'EndTime===>'+EveEndTime+'ID of broker===>'+IdBroker);

        Busy b = new Busy();
        b.isBusy = true;
        CalenderEvents  = ob.getEventslist(EveStartTime,EveEndTime ,IdBroker, b);

        if(b.isBusy) {
            Utilities.sendEmail(new List<String>{'anthony.xuan@creditandfinance.com.au', 'chen@creditandfinance.com.au'}, 'out of sync', 'Broker Id:' + IdBroker + ' Start time:' + EveStartTime + ' End Time' + EveEndTime);

            TimeZone tz = UserInfo.getTimeZone();
            String message = 'Broker is busy: ';
            if(b.busyItems != null) {
                for(GoogleCalendarModel.BusyItem item : b.busyItems) {
                    message += ' from ' + item.start.addHours(-1).format('MM/dd/yyyy HH:mm:ss', tz.getID()) + ' to ' + item.param_rr_end.addHours(1).format('MM/dd/yyyy HH:mm:ss', tz.getID());
                }
            }

            pagereference pg= new pagereference('/apex/SaaSFocus_Allocate_Appointment_beta?id='+appointmentId +'&err=1&message=' + message);
            pg.setRedirect(true);
            return pg;
        } else {
            Appointob.Broker__c= IdBroker;

            System.debug('hey' +Appointob.Broker__c);
            Datetime DT = Datetime.newInstance(Appointob.Appointment_Date_and_Time__c.year(),Appointob.Appointment_Date_and_Time__c.month(),Appointob.Appointment_Date_and_Time__c.day(),selectedT.hour(),selectedT.minute(),0);
            Appointob.Appointment_Date_and_Time__c=DT ;
            //Appointob.Pre_Sales_Notes__c=note;
            update Appointob;
            Appointob.RecordTypeId = [Select Id from RecordType where Name='Confirmed Appointment' limit 1].id;
            update Appointob;
            Broker__c Assignedbroker = [select id, Email__c from Broker__c where id =:IdBroker];
            List<User> brokeruser = [select id ,Email from User where Email = :Assignedbroker.Email__c];
            Event e = new Event();
            if(brokeruser.size()>0)
            e.ownerid = brokeruser[0].id;
            e.Startdatetime= DT;
            e.Enddatetime= e.Startdatetime.addminutes(DurationOfMeeting);
            // calculate offset . Bijay
            if(offset !=null) {
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
            if(Appointob.Pre_Sales_Notes__c != null) {
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
            'Personal Loan Balance:'+' '+Appointob.Personal_Loan_Balance__c+
            'Presale notes:'+' '+Appointob.Pre_Sales_Notes__c;
            e.Description=e.Description.replace(',null','');
            e.Description=e.Description.replace('null,','');
            e.Description=e.Description.replace('null','N/A');

            System.debug('capacity' +e);
            insert e;
            SaaSFocus_Distribute_appointment  objct2 = new SaaSFocus_Distribute_appointment();
            objct2.compensatory_appointment_1(IdBroker); // Update complementary count / calendar

            ob.ob.updategooglesettings();

            Utilities.sendAppointmentConfirmEmail(appointmentId);
            pagereference pg = new pagereference('/apex/SaaSFocus_Allocate_Appointment_beta?id='+appointmentId+'&aid='+e.id);
            pg.setRedirect(true);
            return pg;
        }
    }


    Public Pagereference Cancel() {
        return new pagereference('/'+appointmentId);
    }

    public Time RoundtoHour( time EventStarttime  ) {
        Time temproundedtime;

        if(EventStarttime < DayStartTime) {
            for(Time initialtime =DayStartTime; initialtime >= EventStarttime  ; initialtime = initialtime.addminutes(-IntervalOfMeeting)) {
                temproundedtime = initialtime;
            }
        }
        else {
            for(Time initialtime =DayStartTime; initialtime <= EventStarttime  ; initialtime = initialtime.addminutes(IntervalOfMeeting)) {
                temproundedtime = initialtime;
            }
        }
        return  temproundedtime ;
    }


    public time  convertStringToTime(String selectedtime ) {// Define a method for convert string to time
        List<String> newLst = new List<String>();
        newLst= selectedtime.split(':');
        return Time.newInstance(Integer.valueOf(newLst[0]),Integer.valueOf(newLst[1]),0,0);
    }

    Public string selfappointment() {
        // if current logged in user Email matches with any of the broker's Email , return broker id else return null
        User current_user=[SELECT Email FROM User WHERE Id= :UserInfo.getUserId()] ;
        List<Broker__c> lst = [select Id,Email__c from Broker__c where Email__c=:current_user.Email ];
        if(lst.size()>0) {
            return lst[0].Id;
        }
        else return null;
    }

    public pagereference phoneapp() {
        Appointob.Appointment_Type__c = 'Phone Appointment';    // If the type of Appointment is phone appointment

        Appointment__c newapp = new Appointment__c(id = appointmentId);
        newapp.Appointment_Type__c= 'Phone Appointment';
        update newapp;
        Tempvar=10;
        pagereference pg = new pagereference('/apex/SaaSFocus_Allocate_Appointment_beta?id='+appointmentId);
        pg.setRedirect(true);
        return pg;
    }

}
