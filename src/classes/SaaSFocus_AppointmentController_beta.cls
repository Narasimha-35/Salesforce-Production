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
    public Integer offset;
    public String appointmentId;
    public String selectedtime {get; set;}
    public Integer durationOfMeeting;
    public Integer buffer;
    public Integer intervalOfMeeting;
    public Time dayStartTime;
    public Time dayEndTime;
    public Map<Time, Set<Id>> mapTimetoBrokeridnew;
    Public Set<id> allbrokers;
    public Appointment__c appointob {get; set;}
    public Set<id> busyBrokerInThisTime;
    public List<Market_Broker_Association__c> lstBrokerMarket;
    public Map<Date, Map<Time, Set<id>>> finalMap;
    public String selfid;
    public Time eventStarttime;
    public Time eventEndtime;
    public Datetime appointmentDate {set; get;}
    public Integer flag;
    public Integer maxdays;
    public Boolean chkcolor {get; set;}
    public Integer tempvar {get; set;}
    public List<List<SelectOption>> availableOptions {
        get {
            //TODO: use free busy api instead of below.

            // Define a Method for chose time From given time list in apex page
            List<List<SelectOption>> ret = new List<List<SelectOption>>();
            for(Date d: finalMap.keyset()) {
                Map<Time, Set<ID>> MapTimetoBrokerid = finalMap.get(d);
                mapTimetoBrokeridnew = MapTimetoBrokerid;
                List<DateTime> LstMapKey = new List<DateTime>();
                List<SelectOption> Option = new List<SelectOption>();
                for(Time obj : MapTimetoBrokerid.keyset()) LstMapKey.add(DateTime.newInstance(d.year(), d.month(), d.day(), obj.hour(), obj.minute(), 0));
                LstMapKey.sort();

                Map<string,set<id>> showbrokers = new Map<string,set<id>>();

                for(DateTime eacht : LstMapKey) {
                    Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day(), eacht.hour(), eacht.minute(), 0);
                    String ConvertDate = String.valueOf(eacht);
                    Option.add(new SelectOption(ConvertDate,dt.format('hh:mm a')));
                }
                ret.add(option);
            }
            return ret;
        }
    }

    public class Busy {
        public Boolean isBusy;
        public List<GoogleCalendarModel.BusyItem> busyItems;
        public String brokerEmail;
    }

    private Boolean isDynamicTimeOffset = Allocate_Appointment__c.getValues('System').dynamicTimeOffset__c;

    public static Integer getSydneyLocalMinuteDiff(Datetime dt, String timezone) {
        Datetime ldt = Datetime.valueOf(dt.format('yyyy-MM-dd HH:mm:ss', timezone));
        Datetime sdt = Datetime.valueOf(dt.format('yyyy-MM-dd HH:mm:ss', 'Australia/Sydney'));
        return (Integer) ((sdt.getTime() - ldt.getTime()) / (60 * 1000));
    }

    public SaaSFocus_AppointmentController_beta() {
        init(ApexPages.currentPage().getParameters().get('id'), false);
    }

    public SaaSFocus_AppointmentController_beta(String appId) {
        init(appId, true);
    }

    public void init(String appId, Boolean testMode) {
        appointmentId = appId;
        flag = 0;
        allbrokers = new Set<Id>();
        appointob = new Appointment__c();
        appointob =[SELECT Id,Name,Account_Name__c,Account_Email__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Date_and_Time__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id, Region__r.timeZone__c From Appointment__c Where id=:appointmentId];

        busyBrokerInThisTime= new Set<Id>();

        if(isDynamicTimeOffset) {
            offset = getSydneyLocalMinuteDiff(appointob.Appointment_Date_and_Time__c, appointob.region__r.timeZone__c);
        } else {
            offset = (Integer) (appointob.region__r.Sydney_Timezone_Offset__c * 60);
        }

        if(!testMode && ApexPages.currentPage().getParameters().get('err') != null && ApexPages.currentPage().getParameters().get('err') =='1') {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ApexPages.currentPage().getParameters().get('message'));
            ApexPages.addMessage(myMsg);
        }

        if(appointob.Appointment_Type__c == 'Phone Appointment' || appointob.Appointment_Type__c == 'Lendi Phone Appointment') {
            // If the type of Appointment is phone appointment
            tempvar = 10;
            Allocate_Appointment__c  obj = Allocate_Appointment__c.getValues('Phone_Broker');

            durationOfMeeting = Integer.valueOf(obj.DurationOfMeeting__c);
            buffer = Integer.valueOf(obj.Buffer__c);
            intervalOfMeeting = Integer.valueOf(obj.IntervalOfMeeting__c);
            dayStartTime = Time.newInstance(Integer.valueOf(obj.DayStartTime__c), 00, 0, 0);
            dayEndTime = Time.newInstance(Integer.valueOf(obj.DayEndTime__c), 00, 0, 0);
            // Input All brokerâs Id in the system.
            lstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c From Market_Broker_Association__c Where Broker__r.Speciality_Skills__c includes(:appointob.Speciality_Skills__c) And Broker__r.Channel__c ='Phone Broker' And Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() And  Broker__r.Active_Broker__c = true];
            if(appointob.Speciality_Skills__c == null)
            // Input All brokerâs Id in the system.
            lstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c From Market_Broker_Association__c Where Broker__r.Channel__c = 'Phone Broker' And Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() And Broker__r.Active_Broker__c = true];
        } else {
            tempvar = 0;
            // type of Appointment is face to face appointment
            Allocate_Appointment__c obj2 = Allocate_Appointment__c.getValues('Face_To_face');

            durationOfMeeting = Integer.valueOf(obj2.DurationOfMeeting__c);
            buffer = Integer.valueOf(obj2.Buffer__c);
            intervalOfMeeting = Integer.valueOf(obj2.IntervalOfMeeting__c);
            dayStartTime = Time.newInstance(Integer.valueOf(obj2.DayStartTime__c), 00, 0, 0);
            dayEndTime = Time.newInstance(Integer.valueOf(obj2.DayEndTime__c), 00, 0, 0);

            // Input All brokerâs Id in the system.
            lstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c From Market_Broker_Association__c Where Market__r.Id=:appointob.Market__r.Id And Broker__r.Speciality_Skills__c includes(:appointob.Speciality_Skills__c) And Broker__r.Channel__c !='Phone Broker' And Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() And Market__r.Region__c = :appointob.Region__c And Broker__r.Active_Broker__c = true];
            if(appointob.Speciality_Skills__c == null)
            // Input All brokerâs Id in the system.
            lstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Email__c From Market_Broker_Association__c Where Market__r.Id=:appointob.Market__r.Id And Broker__r.Channel__c !='Phone Broker'And Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() And Market__r.Region__c = :appointob.Region__c And Broker__r.Active_Broker__c = true];
        }
    }

    public pagereference setDates() {
        //This method is used to generate the previous And next Appointment dates according to the custom setting.
        Date dt = appointob.Appointment_Date_and_Time__c.date();
        finalMap = new Map<Date,Map<Time,Set<Id>>>();
        Define_Appointment_Dates__c appdate = Define_Appointment_Dates__c.getValues('AppointmentDate');
        integer prevdays = Integer.valueOf(appdate.previous_days__c);
        maxdays = Integer.valueOf(appdate.Maximum_days__c);
        // if logged in user is a broker itself, get the broker
        if(ApexPages.currentPage().getParameters().get('aid') != null) {
            List<id> ids = new List<id>();
            ids.add(ApexPages.currentPage().getParameters().get('aid'));
            Saasfocus_GoogleCalenderHelper.processEvent(ids);
            return new pagereference('/' + ApexPages.currentPage().getParameters().get('id'));
        } else {
            selfid = selfappointment();
            if(selfid != null) {
                if(appointob.Speciality_Skills__c == null) {
                    // Input All brokerâs Id in the system.
                    lstBrokerMarket = [Select Id, Broker__r.Id, Broker__r.Name, Broker__r.Email__c From Market_Broker_Association__c Where Broker__r.Id =: selfid And Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() And Broker__r.Active_Broker__c = true And Broker__r.Channel__c ='Phone Broker'];
                } else {
                    // Input All brokerâs Id in the system.
                    lstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  From Market_Broker_Association__c  Where Broker__r.Speciality_Skills__c includes(:appointob.Speciality_Skills__c) And Broker__r.Id =:selfid And Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() And Broker__r.Active_Broker__c = true And Broker__r.Channel__c ='Phone Broker'];
                }

                if(lstBrokerMarket.size() == 0) {
                    // Input All brokerâs Id in the system.
                    lstBrokerMarket = [Select Id,Broker__r.Id,Broker__r.Name,Broker__r.Email__c  From Market_Broker_Association__c  Where Broker__r.Speciality_Skills__c includes(:appointob.Speciality_Skills__c)  And Broker__r.Name != :Saasfocus_Global.getUnallocatedBrokerName() And Broker__r.Active_Broker__c = true And Broker__r.Channel__c ='Phone Broker'];
                }
            }
            while(prevdays >= 0) {
                if(dt.adddays(-prevdays) >= system.today()) {
                    appointmentDate = dt.adddays(-prevdays);
                    if(appointmentDate.format('EEEE') == 'Saturday' || appointmentDate.format('EEEE') == 'Sunday') chkcolor = true;
                    else chkcolor = false;
                    Date dtnew = dt.adddays(-prevdays);

                    for(Integer i = 1; i <= maxdays; i++) {
                        finalMap.put(dtnew, getFreeBrokers(dtnew));
                        dtnew = dtnew.adddays(1);
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

        if(lstBrokerMarket.size() == 0) {
            // Error message
            tempvar = tempvar + 1;
            if(tempvar == maxdays) {
                tempvar = 1;
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
        for(Market_Broker_Association__c obj : lstBrokerMarket) allbrokers.add(obj.Broker__r.Id);

        Datetime sdt = Datetime.newInstance(appdt.date(),dayStartTime.addminutes(offset));
        Datetime edt = Datetime.newInstance(appdt.date(), dayEndTime.addminutes(-intervalOfMeeting+durationOfMeeting+Offset));

        List<Event> todaysevent  = [Select id, IsAllDayEvent, StartDateTime, EndDateTime, whatid From Event Where whatid IN :allbrokers And ((startdatetime <= :sdt And enddatetime >:sdt) OR (Startdatetime < :edt And Enddatetime >= :edt) OR (Startdatetime >= :sdt And Enddatetime <= :edt) OR (Startdatetime <= :sdt And Enddatetime >= : edt)) ];
        dayEndTime = dayEndTime.addminutes(-intervalOfMeeting);
        Time tempdt = dayEndTime.addminutes(intervalOfMeeting);

        Map<Time,Set<Id>> mapTimetoBrokeridnew = new Map<Time,Set<Id>>();
        // This map will contain start time And occupied brokers
        for(Event eobj : todaysevent) {
            // Add logic of buffer hours
            eventStarttime = ((eobj.StartDateTime).time()).addminutes(-offset);
            eventEndtime = ((eobj.EndDateTime).time()).addminutes(-offset);
            // replace below with the method

            if(eobj.IsAllDayEvent || eobj.startdatetime <= sdt) eventStarttime = dayStartTime;
            if(eobj.IsAllDayEvent || eobj.enddatetime >= edt) eventEndtime = dayEndTime;

            //TODO: could be a bug
            if( eventEndtime < dayStartTime || eventStarttime >dayEndTime)
            // continue;

            eventStarttime =RoundtoHour(eventStarttime);
            // loop From start time to end time .. make user busy starttime - buffer time TO end time + interval time
            for(Time st=eventStarttime.addminutes((-1)*(buffer+durationOfMeeting-intervalOfMeeting ));st<eventEndtime.addminutes(buffer);st=st.addminutes(intervalOfMeeting)) {
                if( st< dayStartTime || st > dayEndTime ) continue;
                st = RoundtoHour(st); // Round to nearest hour
                //TODO: could be a bug
                if (mapTimetoBrokeridnew.get(st)== null)
                mapTimetoBrokeridnew.put(st,new set<id>());
                mapTimetoBrokeridnew.get(st).add(eobj.whatid);
            }
        }

        // By end of below loop map will contain start time with free borker
        for(Time initialtime = dayStartTime; initialtime <= dayEndTime; initialtime = initialtime.addminutes(intervalOfMeeting)) {
            Set<id> tempAllbrokerid = allbrokers.clone();
            //if value existing in map
            if(mapTimetoBrokeridnew.get(initialtime) == null) {
                mapTimetoBrokeridnew.put(initialtime ,allbrokers.clone());
            } else {
                Set<id> busyBrokerInThisTime = mapTimetoBrokeridnew.get(initialtime);
                tempAllbrokerid.removeAll(busyBrokerInThisTime);

                mapTimetoBrokeridnew.put(initialTime,tempAllbrokerid);
            }
        }

        //  remove all blank keys
        for(Time eacht: mapTimetoBrokeridnew.keyset()) {
            if(mapTimetoBrokeridnew.get(eacht).size() == 0)
            mapTimetoBrokeridnew.remove(eacht);
        }

        if(mapTimetoBrokeridnew.size() == 0) flag++;
        if(flag == maxdays) {
            ApexPages.Message myMsg6 = new ApexPages.Message(ApexPages.Severity.ERROR,'All brokers are busy on this date. Plese select another date');
            ApexPages.addMessage(myMsg6);
        }
        dayEndTime = tempdt;
        return mapTimetoBrokeridnew;
    }

    Public Pagereference Confirm() {
        String IdBroker;
        Datetime EveStartTime;
        Datetime EveEndTime;
        List<Saasfocus_EventClass> CalenderEvents;
        datetime AppStarttime;

        SaaSFocus_Distribute_appointment objct = new SaaSFocus_Distribute_appointment();
        Time selectedT = Datetime.valueOf(selectedtime).time();
        DateTime appdt = Datetime.valueOf(selectedtime);
        mapTimetoBrokeridnew = finalMap.get(appdt.date());
        IdBroker = objct.Compensatory_appointment(mapTimetoBrokeridnew.get(selectedT),lstBrokerMarket);

        appointob.Appointment_Date_and_Time__c = appdt;

        AppStarttime  =  Datetime.newInstance(appointob.Appointment_Date_and_Time__c.date(),selectedT);
        AppStarttime  = AppStarttime.addminutes(offset );

        if(AppStarttime.time() == dayStartTime.addminutes(offset)) EveStartTime = AppStarttime;
        else EveStartTime  = AppStarttime.addminutes((-1)*buffer);
        EveEndTime = AppStarttime.addminutes(buffer + durationOfMeeting);

        if(AppStarttime.time().addMinutes(durationOfMeeting) >= dayEndTime.addminutes(offset))
        EveEndTime = AppStarttime.addminutes(durationOfMeeting);

        Saasfocus_GetGoogleEvent ob = new Saasfocus_GetGoogleEvent(); //DML

        Busy b = new Busy();
        b.isBusy = true;
        CalenderEvents  = ob.getEventslist(EveStartTime,EveEndTime ,IdBroker, b);

        if(b.isBusy) {
            Utilities.sendEmail(new List<String>{'anthony.xuan@creditandfinance.com.au', 'chen@creditandfinance.com.au'}, 'out of sync', 'Broker Id:' + IdBroker + ' Start time:' + EveStartTime + ' End Time' + EveEndTime);

            TimeZone tz = UserInfo.getTimeZone();
            String message = 'Broker is busy: ';
            if(b.busyItems != null) {
                for(GoogleCalendarModel.BusyItem item : b.busyItems) {
                    message += ' From ' + item.start.addHours(-1).format('MM/dd/yyyy HH:mm:ss', tz.getID()) + ' to ' + item.param_rr_end.addHours(1).format('MM/dd/yyyy HH:mm:ss', tz.getID());
                }
            }
            message += ' please book again';

            pagereference pg = new pagereference('/apex/SaaSFocus_Allocate_Appointment_beta?id='+appointmentId +'&err=1&message=' + message);
            pg.setRedirect(true);
            return pg;
        } else {
            appointob.broker__c = IdBroker;

            System.debug('hey' + appointob.broker__c);
            Datetime dt = Datetime.newInstance(appointob.Appointment_Date_and_Time__c.year(), appointob.Appointment_Date_and_Time__c.month(), appointob.Appointment_Date_and_Time__c.day(), selectedT.hour(), selectedT.minute(), 0);
            appointob.Appointment_Date_and_Time__c = dt ;
            update appointob;
            appointob.RecordTypeId = [Select Id From RecordType Where Name = 'Confirmed Appointment' limit 1].id;
            update appointob;
            broker__c Assignedbroker = [select id, Email__c From broker__c Where id =: IdBroker];
            List<User> brokeruser = [select id ,Email From User Where Email = :Assignedbroker.Email__c];
            Event e = new Event();
            if(brokeruser.size() > 0)
            e.ownerid = brokeruser[0].id;
            e.Startdatetime = dt;
            e.Enddatetime = e.Startdatetime.addminutes(durationOfMeeting);
            // calculate offset . Bijay
            if(offset != null) {
                e.startdatetime = e.startdatetime.addMinutes(offset);
                e.enddatetime = e.enddatetime.addMinutes(offset);
            }

            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

            e.whatid= appointob.broker__c;
            e.subject = appointob.name+ '-' + appointob.street_Address__c + ' ' + appointob.city__c + ' ' + appointob.state__c + ' ' + appointob.postal_Code__c + '-' + appointob.phone__c + '-' + appointob.appointment_Type__c;
            e.subject = e.subject.replace('-null', '');
            e.subject = e.subject.replace('null-', '');
            e.subject = e.subject.replace('null', '');
            e.location = appointob.street_Address__c + ',' + appointob.city__c + ',' + appointob.state__c + ',' + appointob.postal_Code__c;
            e.location = e.location.replace(',null','');
            e.location = e.location.replace('null,','');
            e.location = e.location.replace('null','N/A');

            String s1 = '';
            if(appointob.pre_Sales_Notes__c != null) {
                s1 = appointob.pre_Sales_Notes__c;
                s1 = s1.stripHtmlTags();
            }

            String nextline = '\n';
            e.description = 'Appointment Reference: ' + appointob.name + nextline + 'Date And Time Of Appointment:' + ' ' + appointob.appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a') + nextline +
            'Customer Mobile:' + ' ' + appointob.Mobile__c + nextline +
            'Customer Phone:'+' '+ appointob.Phone__c +nextline+
            'Customer Location:'+' '+appointob.Street_Address__c+','+appointob.City__c+','+appointob.State__c+','+appointob.Postal_Code__c+nextline+
            'Customer Email:'+' '+appointob.Account_Email__c+nextline+
            'Customer Name:'+' '+appointob.Account_Name_Text__c+nextline+nextline+
            'Notes From Pre Sales' +nextline+
            s1+nextline+nextline+
            'Opportunity Details:'+' '+nextline+
            'Transaction Type:'+' '+appointob.Transaction_Type__c+nextline+
            'Current Lender:'+' ' +appointob.Current_Lender__c+nextline+
            'Current Loan Value:'+' ' +appointob.Current_Loan_Value__c+nextline+
            'Current Loan Type:' +' '+appointob.Current_Loan_Type__c+nextline+
            'Current Interest Rate:'+' '+appointob.Current_Interest_Rate__c+nextline+
            'Current Interest Rate Type:'+' '+appointob.Current_Interest_Rate_Type__c+nextline+
            'Current Financials Up to Date:'+' '+appointob.Current_Financials_Up_to_Date__c+nextline+
            'Last Refinanced: '+' '+appointob.Last_Refinance__c+nextline+
            'Fixed Rate Expiry:'+' '+appointob.Fixed_Rate_Expiry__c+nextline+
            'Age of Current Loan:'+' '+appointob.Age_of_Current_Loan__c+nextline+nextline+nextline+
            'Income And Liability Details:'+' ' +nextline+
            'Employment Status:'+' '+ appointob.Employment_Status__c +nextline+
            'Industry: '+' '+appointob.Industry__c +nextline+
            'Annual Income:'+' '+appointob.Annual_Income__c +nextline+
            'Partner Annual Income: '+' '+appointob.Partner_Income__c +nextline+
            'Credit Card Balance: '+' '+appointob.Credit_Card_Balance__c +nextline+
            'Personal Loan Balance:'+' '+appointob.Personal_Loan_Balance__c+
            'Presale notes:'+' '+appointob.Pre_Sales_Notes__c;
            e.Description=e.Description.replace(',null','');
            e.Description=e.Description.replace('null,','');
            e.Description=e.Description.replace('null','N/A');

            insert e;
            SaaSFocus_Distribute_appointment objct2 = new SaaSFocus_Distribute_appointment();
            // Update complementary count / calendar
            objct2.compensatory_appointment_1(IdBroker);

            GoogleCalendarUtility.updateGoogleSetting();
            Utilities.sendAppointmentConfirmEmail(appointmentId);
            pagereference pg = new pagereference('/apex/SaaSFocus_Allocate_Appointment_beta?id=' + appointmentId + '&aid=' + e.id);
            pg.setRedirect(true);
            return pg;
        }
    }

    Public Pagereference Cancel() {
        return new pagereference('/' + appointmentId);
    }

    public Time RoundtoHour(time eventStarttime) {
        Time temproundedtime;

        if(eventStarttime < dayStartTime) {
            for(Time initialtime = dayStartTime; initialtime >= eventStarttime; initialtime = initialtime.addminutes(-intervalOfMeeting)) temproundedtime = initialtime;
        } else {
            for(Time initialtime = dayStartTime; initialtime <= eventStarttime; initialtime = initialtime.addminutes(intervalOfMeeting)) temproundedtime = initialtime;
        }
        return temproundedtime ;
    }

    // Define a method for convert string to time
    public Time convertStringToTime(String selectedtime) {
        List<String> newLst = selectedtime.split(':');
        return Time.newInstance(Integer.valueOf(newLst[0]), Integer.valueOf(newLst[1]), 0, 0);
    }

    Public string selfappointment() {
        // if current logged in user Email matches with any of the broker's Email , return broker id else return null
        User current_user = [SELECT Email From User Where Id =: UserInfo.getUserId()] ;
        List<broker__c> lst = [SELECT Id,Email__c From broker__c Where Email__c =: current_user.Email ];
        if(lst.size() > 0) return lst[0].Id;
        else return null;
    }

    public pagereference phoneapp() {
        // If the type of Appointment is phone appointment
        appointob.Appointment_Type__c = 'Phone Appointment';

        Appointment__c newapp = new Appointment__c(id = appointmentId);
        newapp.Appointment_Type__c = 'Phone Appointment';
        update newapp;
        tempvar = 10;
        pagereference pg = new pagereference('/apex/SaaSFocus_Allocate_Appointment_beta?id=' + appointmentId);
        pg.setRedirect(true);
        return pg;
    }

}
