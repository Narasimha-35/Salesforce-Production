public class ChangeAppointment_Class {
    public List<Broker__c > brokerList {get;set;}
    public Broker__c brkobj {get;set;}
    public Appointment__c appobj {get;set;}
    public Appointment__c appobjnew {get;set;}
    public Event evobj {get;set;}
    public String brokername {get;set;}
    public Id idb {get;set;}
    public String brk;
    public Integer durationOfMeeting;
    public Integer offset;
    public String selectedtime;
    public datetime appStarttime;
    public Boolean save1completed {get;set;}
    public Boolean save2completed {get;set;}
    public Id newEventId;


    public List<SelectOption> getBroker() {
        idb = ApexPages.currentPage().getParameters().get('id');
        brokerList =new List<Broker__c >();
        Appointment__c Appobjtemp = [Select Name,Broker__r.name,Broker__c,Appointment_Type__c,Broker_Email__c,Broker_Mobile__c FROM Appointment__c WHERE id=:idb ];
        if(Appobjtemp.Appointment_Type__c == 'Phone Appointment') {
            brokerList = [Select name FROM Broker__c WHERE Active_Broker__c = true AND name != 'Unallocated Broker' AND Channel__c = 'Phone Broker'];
        } else {
            brokerList = [Select name FROM Broker__c WHERE Active_Broker__c = true AND name != 'Unallocated Broker' AND (Channel__c = 'Partner' OR Channel__c = 'Employee')];
        }

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Please select a Broker--'));

        for (Broker__c br: brokerList) {
            if(br.id != Appobjtemp.Broker__c )
            options.add(new SelectOption(br.id ,br.name));
        }
        return options;
    }

    public ChangeAppointment_Class() {
        idb = ApexPages.currentPage().getParameters().get('id');
        appobj = [SELECT name, account_Name__c, street_Address__c, city__c, postal_Code__c, state__c, broker__c, appointment_Date_and_Time__c, broker__r.name, broker_Email__c, broker_Mobile__c FROM Appointment__c WHERE id =: idb];
        save1completed = false;
        save2completed = false;
    }

    public void updateBroker() {
        Appointment__c newapp = new Appointment__c(id = idb);
        newapp.Broker__c = brokername;
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
        system.debug('save1completed called save 2');
    }

    Public pagereference save2() {
        // Step 4
        system.debug('Debug called save 2');
        Saasfocus_GoogleCalenderHelper.processEvent(new list<ID>{newEventId});
        save2completed = true;
        return null;
    }

    public pagereference Save3() {
        // Step 5 - Send SMS to new broker.
        Appointment__c appobjnew = [Select Name, Street_Address__c,City__c,Broker__c,Postal_Code__c,State__c,Broker__r.name ,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c FROM Appointment__c WHERE id=:idb ];
        // Define SMS template++
        String NewSMSTemplate = 'The appointment '+appobjnew.Name+' with '+appobjnew.Street_Address__c+' '+appobjnew.City__c+' '+appobjnew.Postal_Code__c+' '+appobjnew.State__c+' on '+appobjnew.Appointment_Date_and_Time__c+' is allocated to you.';
        acfCommon.sendSMS(appobjnew.Broker__r.name,appobjnew.Broker_Mobile__c,NewSMSTemplate,true);
        System.debug('MobileNew'+appobjnew.Broker_Mobile__c);
        // Step 6 - Delete old Event FROM salesforce and google calendar
        List<Event> lstevobj = [Select id,Google_Event_ID__c FROM Event WHERE whatid =: appobj.Broker__c AND Subject like :appobj.Name+'%'  LIMIT 1];
        if(lstevobj.size()>0) {
            if(lstevobj[0].Google_Event_ID__c != null) {
                System.debug('Amit'+lstevobj[0].Google_Event_ID__c);
                String st= Saasfocus_Global.getGoogleId(lstevobj[0].Google_Event_ID__c);
                System.debug('Bingo'+st);
                Chen_GoogleCalenderHelper.deleteEventOnGoogleCalendar(appobj.Broker_Email__c,st,true);
            } else {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+'No Google Event Id Found!'));
            }
        }
        // Step 7 - Email to old broker
        // Step 8 - SMS to Old broker
        String OldSMSTemplate = 'The appointment '+appobj.Name+' with '+appobj.Street_Address__c+' '+appobj.City__c+' '+appobj.Postal_Code__c+' '+appobj.State__c+' on '+appobj.Appointment_Date_and_Time__c+'  is cancelled.';
        acfCommon.sendSMS(appobj.Broker__r.name,appobj.Broker_Mobile__c,OldSMSTemplate ,true);
        System.debug('MobileOld'+appobj.Broker_Mobile__c);
        return new pagereference('/'+idb);
    }

    // Email Notification to old broker
    public void SendNoticationOld() {
        EmailTemplate templateId = [select id,subject,body, name,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Old_BrokerTemplate' AND isActive=true];
        string body1='';
        body1=templateId.HtmlValue;
        if(appobj.Broker__r.name != null) {
            body1=body1.replace('{!Broker.Name}',appobj.Broker__r.name);
        } else {
            body1=body1.replace('{!Broker.Name}','');
        }
        if(appobj.Name != null) {
            body1=body1.replace('[[apptref]]',appobj.Name);
        } else {
            body1=body1.replace('[[apptref]]','');
        }
        if(appobj.Street_Address__c != null || appobj.City__c!= null || appobj.Postal_Code__c != null || appobj.State__c!= null) {
            body1=body1.replace('[[customer name and address]]',appobj.Account_Name__c+' '+appobj.Street_Address__c+' '+appobj.City__c+' '+appobj.Postal_Code__c+' '+appobj.State__c);
        } else {
            body1=body1.replace('[[customer name and address]]','');
        }
        if(appobj.Appointment_Date_and_Time__c != null) {
            body1=body1.replace('[[appointment date and time]]',String.valueOf(appobj.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
        } else {
            body1=body1.replace('[[apptref]]','');
        }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setSubject(templateId.subject);
        email.setToAddresses( new string [] {appobj.Broker_Email__c});
        email.setHtmlBody(body1);
        email.setBccSender(true);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
    // Email Notification to New broker
    public void SendNoticationNew() {
        appobjnew = [Select name,Car_Loan_Balance__c,Personal_Loan_Balance__c,Credit_Card_Balance__c,Partner_Income__c,Annual_Income__c,Industry__c,Employment_Status__c,Age_of_Current_Loan__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Current_Financials_Up_to_Date__c,Current_Interest_Rate_Type__c,Current_Interest_Rate__c,Current_Loan_Type__c,Current_Loan_Value__c,Current_Lender__c,Transaction_Type__c,Pre_Sales_Notes__c,Appointment_Type__c,Street_Address__c,City__c,Postal_Code__c,State__c,Alternate_Phone__c,Phone__c,Mobile__c,Account_Name__c,Account_Email__c,Pre_Sales_User__c,Broker__r.name,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c FROM Appointment__c WHERE id=:idb ];
        EmailTemplate templateIdnew = [select id,subject,body, name,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'New_BrokerTemplate' AND isActive=true];
        string body2='';
        body2=templateIdnew.HtmlValue;
        if(appobjnew.Broker__r.name!= null) {
            body2=body2.replace('{!Broker.Name}',appobjnew.Broker__r.name);
        } else {
            body2=body2.replace('{!Broker.Name}','');
        }
        if(appobjnew.name != null) {
            body2=body2.replace('[[AppRef]]',appobjnew.name);
        } else {
            body2=body2.replace('[[AppRef]]','');
        }

        if(appobjnew.Pre_Sales_User__c != null) {
            body2=body2.replace('[[Presales]]',appobjnew.Pre_Sales_User__c);
        } else {
            body2=body2.replace('[[Presales]]','');
        }

        if(appobjnew.Account_Name__c != null) {
            body2=body2.replace('[[CustName]]',appobjnew.Account_Name__c);
        } else {
            body2=body2.replace('[[CustName]]','');
        }

        if(appobjnew.Account_Email__c != null) {
            body2=body2.replace('[[CustEmail]]',appobjnew.Account_Email__c);
        } else {
            body2=body2.replace('[[CustEmail]]','');
        }
        if(appobjnew.Mobile__c != null) {
            body2=body2.replace('[[Mobile]]',appobjnew.Mobile__c);
        } else {
            body2=body2.replace('[[Mobile]]','');
        }
        if(appobjnew.Phone__c != null) {
            body2=body2.replace('[[Phone]]',appobjnew.Phone__c);
        } else {
            body2=body2.replace('[[Phone]]','');
        }
        if(appobjnew.Alternate_Phone__c != null) {
            body2=body2.replace('[[AlternatePhone]]',appobjnew.Alternate_Phone__c);
        } else {
            body2=body2.replace('[[AlternatePhone]]','');
        }
        if(appobjnew.Appointment_Date_and_Time__c != null) {
            body2=body2.replace('[[AppDateTime]]',String.valueOf(appobjnew.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
        } else {
            body2=body2.replace('[[AppDateTime]]','');
        }
        if(appobjnew.Street_Address__c != null) {
            body2=body2.replace('[[StreetAddress]]',appobjnew.Street_Address__c);
        } else {
            body2=body2.replace('[[StreetAddress]]','');
        }
        if(appobjnew.City__c!= null) {
            body2=body2.replace('[[City]]',appobjnew.City__c);
        } else {
            body2=body2.replace('[[City]]','');
        }
        if(appobjnew.Postal_Code__c != null) {
            body2=body2.replace('[[PostalCode]]',appobjnew.Postal_Code__c);
        } else {
            body2=body2.replace('[[PostalCode]]','');
        }

        if(appobjnew.State__c!= null) {
            body2=body2.replace('[[State]]',appobjnew.State__c);
        } else {
            body2=body2.replace('[[State]]','');
        }

        if(appobjnew.Appointment_Type__c != null) {
            body2=body2.replace('[[AppType]]',appobjnew.Appointment_Type__c);
        } else {
            body2=body2.replace('[[AppType]]','');
        }
        if(appobjnew.Pre_Sales_Notes__c != null) {
            body2=body2.replace('[[preNote]]',appobjnew.Pre_Sales_Notes__c);
        } else {
            body2=body2.replace('[[preNote]]','');
        }
        if(appobjnew.Transaction_Type__c != null) {
            body2=body2.replace('[[TransactionType]]',appobjnew.Transaction_Type__c);
        } else {
            body2=body2.replace('[[TransactionType]]','');
        }
        if(appobjnew.Current_Lender__c != null) {
            body2=body2.replace('[[CurrentLender]]',appobjnew.Current_Lender__c);
        } else {
            body2=body2.replace('[[CurrentLender]]','');
        }
        if(appobjnew.Current_Loan_Value__c != null) {
            body2=body2.replace('[[CurrentLoanValue]]',String.valueOf(appobjnew.Current_Loan_Value__c));
        } else {
            body2=body2.replace('[[CurrentLoanValue]]','');
        }
        if(appobjnew.Current_Loan_Type__c != null) {
            body2=body2.replace('[[CurrentLoanType]]',appobjnew.Current_Loan_Type__c);
        } else {
            body2=body2.replace('[[CurrentLoanType]]','');
        }
        if(appobjnew.Current_Interest_Rate__c != null) {
            body2=body2.replace('[[CurrentInterestRate]]',String.valueOf(appobjnew.Current_Interest_Rate__c));
        }
        else {
            body2=body2.replace('[[CurrentInterestRate]]','');
        }
        if(appobjnew.Current_Interest_Rate_Type__c != null) {
            body2=body2.replace('[[CurrentInterestRateType]]',appobjnew.Current_Interest_Rate_Type__c);
        } else {
            body2=body2.replace('[[CurrentInterestRateType]]','');
        }
        if(appobjnew.Current_Financials_Up_to_Date__c != null) {
            body2=body2.replace('[[CurrentFinancials]]',appobjnew.Current_Financials_Up_to_Date__c);
        } else {
            body2=body2.replace('[[CurrentFinancials]]','');
        }
        if(appobjnew.Fixed_Rate_Expiry__c != null) {
            body2=body2.replace('[[FixedRate]]',String.valueOf(appobjnew.Fixed_Rate_Expiry__c));
        } else {
            body2=body2.replace('[[FixedRate]]','');
        }
        if(appobjnew.Last_Refinance__c != null) {
            body2=body2.replace('[[lastRefinance]]',String.valueOf(appobjnew.Last_Refinance__c));
        } else {
            body2=body2.replace('[[lastRefinance]]','');
        }
        if(appobjnew.Age_of_Current_Loan__c != null) {
            body2=body2.replace('[[AgeCurrent]]',appobjnew.Age_of_Current_Loan__c);
        } else {
            body2=body2.replace('[[AgeCurrent]]','');
        }
        if(appobjnew.Employment_Status__c!= null) {
            body2=body2.replace('[[EmploymentStatus]]',appobjnew.Employment_Status__c);
        }
        else {
            body2=body2.replace('[[EmploymentStatus]]','');
        }
        if(appobjnew.Industry__c != null) {
            body2=body2.replace('[[Industry]]',appobjnew.Industry__c);
        } else {
            body2=body2.replace('[[Industry]]','');
        }
        if(appobjnew.Annual_Income__c != null) {
            body2=body2.replace('[[AnnualIncome]]',String.valueOf(appobjnew.Annual_Income__c));
        } else {
            body2=body2.replace('[[AnnualIncome]]','');
        }
        if(appobjnew.Partner_Income__c != null) {
            body2=body2.replace('[[PartnerIncome]]',String.valueOf(appobjnew.Partner_Income__c));
        } else {
            body2=body2.replace('[[PartnerIncome]]','');
        }
        if(appobjnew.Credit_Card_Balance__c != null) {
            body2=body2.replace('[[CreditCardBalance]]',String.valueOf(appobjnew.Credit_Card_Balance__c));
        } else {
            body2=body2.replace('[[CreditCardBalance]]','');
        }
        if(appobjnew.Personal_Loan_Balance__c != null) {
            body2=body2.replace('[[PersonalLoanBalance]]',String.valueOf(appobjnew.Personal_Loan_Balance__c));
        } else {
            body2=body2.replace('[[PersonalLoanBalance]]','');
        }
        if(appobjnew.Car_Loan_Balance__c != null) {
            body2=body2.replace('[[CarLoanBalance]]',String.valueOf(appobjnew.Car_Loan_Balance__c));
        } else {
            body2=body2.replace('[[CarLoanBalance]]','');
        }

        Messaging.SingleEmailMessage emailnew = new Messaging.SingleEmailMessage();

        emailnew.setSubject(templateIdnew.subject);
        emailnew.setToAddresses( new string [] {appobjnew.Broker_Email__c});
        emailnew.setHtmlBody(body2);
        emailnew.setBccSender(true);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailnew});
    }

    // Define a method for convert string to time
    public Time  convertStringToTime(String selectedtime) {
        List<String> newLst = new List<String>();
        newLst= selectedtime.split(':');
        return Time.newInstance(Integer.valueOf(newLst[0]),Integer.valueOf(newLst[1]),0,0);
    }

    // Insert Event under new Broker
    public Id InsertEvent() {
        Allocate_Appointment__c  objappAll =  Allocate_Appointment__c.getValues('Phone_Broker');
        durationOfMeeting = Integer.valueOf(objappAll.DurationOfMeeting__c);
        Appointment__c obj = new Appointment__c();
        obj = [SELECT Id,Name,Account_Name__c,Account_Email__c,Appointment_Date_and_Time__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Time_and_Date_Adj__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id FROM Appointment__c WHERE id=:idb ];

        Time selectedT = Datetime.valueOf(obj.Appointment_Time_and_Date_Adj__c).time();
        Broker__c Assignedbroker = [select id,Email__c,Primary_Market__r.Region__r.Sydney_Timezone_Offset__c FROM Broker__c WHERE id =:brokername];

        List<User> brokeruser = [select id , Email FROM User WHERE Email = :Assignedbroker.Email__c];
        appStarttime  =  Datetime.newInstance(obj.Appointment_Time_and_Date_Adj__c.date(),selectedT);
        Datetime DT = Datetime.newInstance(obj.Appointment_Time_and_Date_Adj__c.year(),obj.Appointment_Time_and_Date_Adj__c.month(),obj.Appointment_Time_and_Date_Adj__c.day(),selectedT.hour(),selectedT.minute(),0);

        Event e = new Event();

        if(brokeruser.size() > 0)
        e.ownerid = brokeruser[0].id;

        e.Startdatetime = DT;
        e.Enddatetime = e.Startdatetime.addminutes(durationOfMeeting);

        if(offset != null) {
            e.startdatetime = e.startdatetime.addMinutes(offset);
            e.enddatetime = e.enddatetime.addMinutes(offset);
        }

        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        e.whatid= appobjnew.Broker__c;
        if(Test.isRunningTest()) {
            e.IsAllDayEvent = true;
            e.ActivityDate = System.today();
        }

        e.Subject= obj.Name+ '-' +obj.Street_Address__c +' ' +obj.City__c +' ' +obj.State__c +' '  +obj.Postal_Code__c +'-' +obj.Phone__c +'-' +obj.Appointment_Type__c;
        e.Subject=e.Subject.replace('-null','');
        e.Subject=e.Subject.replace('null-','');
        e.Subject=e.Subject.replace('null','');
        e.Location = obj.Street_Address__c+','+obj.City__c+','+obj.State__c+','+obj.Postal_Code__c;
        e.Location =e.Location.replace(',null','');
        e.Location =e.Location.replace('null,','');
        e.Location =e.Location.replace('null','N/A');

        string s1 = '';
        if(obj.Pre_Sales_Notes__c != null) {
            s1 = obj.Pre_Sales_Notes__c;
            s1=  s1.stripHtmlTags();
        }
        string nextline = '\n';
        e.Description = 'Appointment Reference: ' + obj .Name + nextline+ 'Date and Time Of Appointment:'+' '+obj .Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')+nextline+
        'Customer Mobile:'+' '+obj .Mobile__c+nextline+
        'Customer Phone:'+' '+ obj .Phone__c +nextline+
        'Customer Location:'+' '+obj .Street_Address__c+','+obj .City__c+','+obj .State__c+','+obj .Postal_Code__c+nextline+
        'Customer Email:'+' '+obj .Account_Email__c+nextline+
        'Customer Name:'+' '+obj .Account_Name_Text__c+nextline+nextline+
        'Notes FROM Pre Sales' +nextline+ s1+nextline+nextline+
        'Opportunity Details:'+' '+nextline+
        'Transaction Type:'+' '+obj .Transaction_Type__c+nextline+
        'Current Lender:'+' ' +obj .Current_Lender__c+nextline+
        'Current Loan Value:'+' ' +obj .Current_Loan_Value__c+nextline+
        'Current Loan Type:' +' '+obj .Current_Loan_Type__c+nextline+
        'Current Interest Rate:'+' '+obj .Current_Interest_Rate__c+nextline+
        'Current Interest Rate Type:'+' '+obj .Current_Interest_Rate_Type__c+nextline+
        'Current Financials Up to Date:'+' '+obj .Current_Financials_Up_to_Date__c+nextline+
        'Last Refinanced: '+' '+obj .Last_Refinance__c+nextline+
        'Fixed Rate Expiry:'+' '+obj .Fixed_Rate_Expiry__c+nextline+
        'Age of Current Loan:'+' '+obj .Age_of_Current_Loan__c+nextline+nextline+nextline+
        'Income and Liability Details:'+' ' +nextline+
        'Employment Status:'+' '+ obj .Employment_Status__c +nextline+
        'Industry: '+' '+obj .Industry__c +nextline+
        'Annual Income:'+' '+obj .Annual_Income__c +nextline+
        'Partner Annual Income: '+' '+obj .Partner_Income__c +nextline+
        'Credit Card Balance: '+' '+obj .Credit_Card_Balance__c +nextline+
        'Personal Loan Balance:'+' '+obj .Personal_Loan_Balance__c;
        e.Description=e.Description.replace(',null','');
        e.Description=e.Description.replace('null,','');
        e.Description=e.Description.replace('null','N/A');
        insert e;
        return e.id;
    }

    public pagereference Cancel() {
        PageReference pageRef = new PageReference('/' + idb);
        return pageRef;
    }
}
