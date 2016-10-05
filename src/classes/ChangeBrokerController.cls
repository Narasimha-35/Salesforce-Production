public class ChangeBrokerController {
    public List<Broker__c> brokerList {get; set;}
    public Appointment__c appobj {get; set;}
    public Appointment__c appobjnew {get; set;}
    public String brokerId {get; set;}
    public Id apptId {get; set;}
    public Boolean save1completed {get; set;}
    public Boolean save2completed {get; set;}
    public Id newEventId;

    public static Integer getSydneyLocalMinuteDiff(Datetime dt, String timezone) {
        Datetime ldt = Datetime.valueOf(dt.format('yyyy-MM-dd HH:mm:ss', timezone));
        Datetime sdt = Datetime.valueOf(dt.format('yyyy-MM-dd HH:mm:ss', 'Australia/Sydney'));
        return (Integer) ((sdt.getTime() - ldt.getTime()) / (60 * 1000));
    }

    public List<SelectOption> getBroker() {
        apptId = ApexPages.currentPage().getParameters().get('id');
        Appointment__c Appobjtemp = [SELECT Name,Broker__r.name,Broker__c,Appointment_Type__c,Broker_Email__c,Broker_Mobile__c FROM Appointment__c WHERE id=:apptId];
        if(Appobjtemp.Appointment_Type__c == 'Phone Appointment') {
            brokerList = [SELECT name FROM Broker__c WHERE Active_Broker__c = true AND name != 'Unallocated Broker' AND Channel__c = 'Phone Broker'];
        } else {
            brokerList = [SELECT name FROM Broker__c WHERE Active_Broker__c = true AND name != 'Unallocated Broker' AND (Channel__c = 'Partner' OR Channel__c = 'Employee')];
        }

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Please SELECT a Broker--'));
        for (Broker__c br: brokerList) {
            if(br.id != Appobjtemp.Broker__c) options.add(new SelectOption(br.id ,br.name));
        }
        return options;
    }

    public ChangeBrokerController() {
        apptId = ApexPages.currentPage().getParameters().get('id');
        appobj = [SELECT name, account_Name__c, street_Address__c, city__c, postal_Code__c, state__c, broker__c, appointment_Date_and_Time__c, broker__r.name, broker_Email__c, broker_Mobile__c FROM Appointment__c WHERE id =: apptId];
        save1completed = false;
        save2completed = false;
    }

    public void updateBroker() {
        Appointment__c newapp = new Appointment__c(id = apptId);
        newapp.Broker__c = brokerId;
        update newapp;
    }

    public void save() {
        appobjnew = new Appointment__c();
        // Step 1
        updateBroker();
        // Step 2
        SendNoticationNew();
        SendNoticationOld();
        // Step 3
        newEventId = InsertEvent();
        save1completed = true;
    }

    Public pagereference save2() {
        // Step 4
        Saasfocus_GoogleCalenderHelper.processEvent(new list<ID>{newEventId});
        save2completed = true;
        return null;
    }

    public pagereference Save3() {
        // Step 5 - Send SMS to new broker.
        Appointment__c appobjnew = [SELECT Name, Street_Address__c,City__c,Broker__c,Postal_Code__c,State__c,Broker__r.name ,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c FROM Appointment__c WHERE id=:apptId ];
        // Define SMS template++
        String NewSMSTemplate = 'The appointment '+appobjnew.Name+' with '+appobjnew.Street_Address__c+' '+appobjnew.City__c+' '+appobjnew.Postal_Code__c+' '+appobjnew.State__c+' on '+appobjnew.Appointment_Date_and_Time__c+' is allocated to you.';
        acfCommon.sendSMS(appobjnew.Broker__r.name,appobjnew.Broker_Mobile__c,NewSMSTemplate,true);
        // Step 6 - Delete old Event FROM salesforce and google calendar
        List<Event> lstevobj = [SELECT id,Google_Event_ID__c FROM Event WHERE whatid =: appobj.Broker__c AND Subject like :appobj.Name+'%'  LIMIT 1];
        if(lstevobj.size()>0) {
            if(lstevobj[0].Google_Event_ID__c != null) {
                String st= Saasfocus_Global.getGoogleId(lstevobj[0].Google_Event_ID__c);
                Chen_GoogleCalenderHelper.deleteEventOnGoogleCalendar(appobj.Broker_Email__c,st,true);
            } else {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+'No Google Event Id Found!'));
            }
        }
        // Step 7 - Email to old broker
        // Step 8 - SMS to Old broker
        String OldSMSTemplate = 'The appointment '+appobj.Name+' with '+appobj.Street_Address__c+' '+appobj.City__c+' '+appobj.Postal_Code__c+' '+appobj.State__c+' on '+appobj.Appointment_Date_and_Time__c+'  is cancelled.';
        acfCommon.sendSMS(appobj.Broker__r.name,appobj.Broker_Mobile__c,OldSMSTemplate ,true);
        return new pagereference('/' + apptId);
    }

    // Email Notification to old broker
    public void SendNoticationOld() {
        EmailTemplate templateId = [SELECT id,subject,body, name,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Old_BrokerTemplate' AND isActive=true];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(templateId.subject);
        email.setToAddresses(new List<String>{appobj.broker_Email__c});
        email.setHtmlBody(AppointmentService.constructEmailBodyToOldBroker(appobj, templateId));
        email.setBccSender(true);
        if(!Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }

    // Email Notification to New broker
    public void SendNoticationNew() {
        Appointment__c appobjnew = [SELECT name,Car_Loan_Balance__c,Personal_Loan_Balance__c,Credit_Card_Balance__c,Partner_Income__c,Annual_Income__c,Industry__c,Employment_Status__c,Age_of_Current_Loan__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Current_Financials_Up_to_Date__c,Current_Interest_Rate_Type__c,Current_Interest_Rate__c,Current_Loan_Type__c,Current_Loan_Value__c,Current_Lender__c,Transaction_Type__c,Pre_Sales_Notes__c,Appointment_Type__c,Street_Address__c,City__c,Postal_Code__c,State__c,Alternate_Phone__c,Phone__c,Mobile__c,Account_Name__c,Account_Email__c,Pre_Sales_User__c,Broker__r.name,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c FROM Appointment__c WHERE id=:apptId LIMIT 1];
        EmailTemplate templateIdnew = [SELECT id, subject, body, name, htmlValue FROM EmailTemplate WHERE developerName = 'New_BrokerTemplate' AND isActive = true];
        Messaging.SingleEmailMessage emailnew = new Messaging.SingleEmailMessage();
        emailnew.setSubject(templateIdnew.subject);
        emailnew.setToAddresses(new List<String>{appobjnew.broker_Email__c});
        emailnew.setHtmlBody(AppointmentService.constructEmailBodyToNewBroker(appobjnew, templateIdnew));
        emailnew.setBccSender(true);
        if(!Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailnew});
    }

    // Insert Event under new Broker
    public Id InsertEvent() {
        Appointment__c appt      = [SELECT Id, Name, BrokerChannel__c, Account_Name__c, Account_Email__c,Appointment_Date_and_Time__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Time_and_Date_Adj__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id, market__r.region__r.timeZone__c FROM Appointment__c WHERE id = :apptId];
        Broker__c assignedBroker = [SELECT id, Email__c, Primary_Market__r.Region__r.Sydney_Timezone_Offset__c FROM Broker__c WHERE id = :brokerId];
        User brokeruser          = [SELECT id, Email FROM User WHERE Email =: assignedBroker.email__c LIMIT 1];
        System.debug(appt.appointment_Date_and_Time__c);
        System.debug(appt.market__r.region__r.timeZone__c);
        Datetime apptStartTime   = appt.appointment_Date_and_Time__c.addMinutes(getSydneyLocalMinuteDiff(appt.appointment_Date_and_Time__c, appt.market__r.region__r.timeZone__c));

        Event e = AppointmentService.constructEvent(appt, apptStartTime, brokeruser.id);
        insert e;
        return e.id;
    }

    public pagereference Cancel() {
        PageReference pageRef = new PageReference('/' + apptId);
        return pageRef;
    }
}
