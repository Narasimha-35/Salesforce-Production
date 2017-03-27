public class BrokerAppointmentReportBrokerController {
    public List<Appointment__c> appointments { get; set; }
    public Id currentAppointmentId { get; set; }
    public Map<Id, Appointment__c> appointmentMap { get; set; }
    public String[] closeLostReason { get; set; } 
    public String feedback { get; set; }
    public String oppoDescription { get; set; }
    public String actionContent { get; set; }
    public Boolean presalesAction { get; set; }
    public Id currentUserManager { get; set; }
    public Boolean needHelp { get; set; }
    public Boolean haveUnreportedInterview { get; set; } 
    public List<String> ruleObjectList { get; set; }
    
    public BrokerAppointmentReportBrokerController () {
        appointments = new List <Appointment__c>();
        appointmentMap = new Map<Id, Appointment__c>();
        appointments = getAllAppointmentFromCurrentUser();
        if (appointments != null && appointments.size() > 0) {
            haveUnreportedInterview = true;
            for (Appointment__c appointment : appointments) {
                appointmentMap.put(appointment.Id, appointment);
            }
        }
        feedback = '';
    }
    
    public List<Appointment__c> getAllAppointmentFromCurrentUser() {
        Id currentUserId = UserInfo.getUserId();
        if (currentUserId != null) {
            User user = [Select Id, Email, ManagerId From User where Id =:currentUserId and IsActive = true];
            if (user != null) {
                currentUserManager = user.ManagerId;
                Datetime currentTime = System.now();
                List<Appointment__c> appointments = [Select Id, Name, Opp_Owner_Email__c, Account_Id__c, Appointment_Status__c, Broker_Email__c, Appointment_Type__c, Appointment_Date_and_Time__c, Account_Name_Text__c, Account_Email__c, Phone__c, Mobile__c, Postal_Code__c, Street_Address__c, State__c, City__c, Pre_Sales_User__c, Opportunity__c, Opportunity__r.Future_Followed_Date__c, Opportunity__r.Second_Appointment_Date__c, Opportunity__r.Description, Opportunity__r.StageName, Opportunity__r.Closed_Lost_Reason__c, Potential_Deal__c, STP_Forecast_Date__c From Appointment__c where Broker_Email__c = :user.Email and Appointment_Status__c = 'Allocated' and Appointment_Date_and_Time__c < :currentTime order by Appointment_Date_and_Time__c DESC];
                return appointments;
            }
        } 
        return null;
    }
    
    public List<SelectOption> getAppStatusItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Appointment Held','Appointment Held'));
        options.add(new SelectOption('No Show','No Show'));
        return options;
    }
    
    public List<SelectOption> getOppoStatusItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Work In Progress', 'Work In Progress'));
        options.add(new SelectOption('2nd Appt Booked', '2nd Appt Booked'));
        options.add(new SelectOption('Future Opportunity', 'Future Opportunity'));
        options.add(new SelectOption('Closed Won - Signed','Closed Won - Signed'));
        options.add(new SelectOption('Closed Lost','Closed Lost'));
        return options;
    }
    
    public List<SelectOption> getClosedLostReasons() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Not Enough Deposit', 'Not Enough Deposit'));
        options.add(new SelectOption('Not Enough Equity', 'Not Enough Equity'));
        options.add(new SelectOption('Currently Unemployed', 'Currently Unemployed'));
        options.add(new SelectOption('Too Old','Too Old'));
        options.add(new SelectOption('Language Issues','Language Issues'));
        
        options.add(new SelectOption('Bad Credit History','Bad Credit History'));
        options.add(new SelectOption('Couldn\'t Show Enough Savings','Couldn\'t Show Enough Savings'));
        options.add(new SelectOption('Recently Refinanced','Recently Refinanced'));
        options.add(new SelectOption('Fixed Rate Break Fee Too High','Fixed Rate Break Fee Too High'));
        options.add(new SelectOption('Doesn\'t Service','Doesn\'t Service'));
        options.add(new SelectOption('Self Employed <1yr','Self Employed <1yr'));
        
        options.add(new SelectOption('Tax Returns/BAS Incomplete','Tax Returns/BAS Incomplete'));
        options.add(new SelectOption('Family Law Issue Pending','Family Law Issue Pending'));
        options.add(new SelectOption('Legal Issues Pending','Legal Issues Pending'));
        options.add(new SelectOption('Didn\'t Want to Leave Current Lender','Didn\'t Want to Leave Current Lender'));
        options.add(new SelectOption('Not Proceeding Despite Best Efforts','Not Proceeding Despite Best Efforts'));
        return options;
    }
    
    public void saveAndProcess() {
        //System.debug('appt stat : ' + currentSelectedAppointmentStatus);
        //System.debug('appt Id ' + currentAppointmentId);
        Appointment__c appointment = appointmentMap.get(currentAppointmentId);
        //System.debug('appt status ' + appointment.Appointment_Status__c);
        //System.debug('oppo stat : ' + appointment.Opportunity__r.StageName);
        //String result = String.join(closeLostReason, ';');
        /*System.debug('close and lost reason : ' + appointment.Opportunity__r.Closed_Lost_Reason__c);
        System.debug('f o date : ' + appointment.Opportunity__r.Future_Followed_Date__c);
        System.debug('s a date : ' + appointment.Opportunity__r.Second_Appointment_Date__c);
        System.debug('oppo comment : ' + appointment.Opportunity__r.Description);
        System.debug('action requirement : ' + presalesAction);
        System.debug('action content : ' + actionContent);*/
        System.debug('appointment ' + appointment);
        update appointment;
        Opportunity oppo = [Select Id, Name, StageName, Description, Closed_Lost_Reason__c, Second_Appointment_Date__c, Future_Followed_Date__c From Opportunity Where Id = : appointment.Opportunity__c];
        if (appointment.Appointment_Status__c != 'No Show') {
            //logic for saving on the opportunity
            if (oppo != null) {
                if (appointment.Opportunity__r.StageName == 'Work In Progress') {
                    oppo.StageName = 'Appointed';
                } else if (appointment.Opportunity__r.StageName == '2nd Appt Booked') {
                    oppo.StageName = 'Appointed';
                    oppo.Second_Appointment_Date__c = appointment.Opportunity__r.Second_Appointment_Date__c;
                } else if (appointment.Opportunity__r.StageName == 'Future Opportunity') {
                    oppo.StageName = 'Appointed';
                    oppo.Future_Followed_Date__c = appointment.Opportunity__r.Future_Followed_Date__c;
                } else if (appointment.Opportunity__r.StageName == 'Closed Won - Signed') {
                    oppo.StageName = 'Closed Won - Signed';
                } else if (appointment.Opportunity__r.StageName == 'Closed Lost') {
                    oppo.StageName = 'Closed Lost';
                    if (appointment.Opportunity__r.Closed_Lost_Reason__c != null) {
                        String[] picklistlines = new String[]{};
                        picklistlines = appointment.Opportunity__r.Closed_Lost_Reason__c.replace('[', '').replace(']', '').split(',');
                        String result = String.join(picklistlines, ';');
                        oppo.Closed_Lost_Reason__c = result;
                    }
                }
            }
        }
        if (oppo != null) {
            oppo.Description = appointment.Opportunity__r.Description;
            update oppo;
        }
        //create case put on the queue
        if (presalesAction) {
            Group presalesGroup = [Select Id, Name from Group where Name = 'Presales Action Req - Appts'];
            if (presalesGroup != null) {
                Case presalesCase = new Case();
                presalesCase.OwnerId = presalesGroup.Id;
                presalesCase.Appointment__c = appointment.Id;
                presalesCase.AccountId = appointment.Account_Id__c;
                presalesCase.Status = 'New';
                presalesCase.Priority = 'High';
                presalesCase.Subject = 'Presales action required';
                presalesCase.Description = actionContent;
                insert presalesCase;
            }
        } 
        //send email
        String emailContent = 'We have received your appointment eod details.<br/>';
        emailContent += 'Thanks!<br/>';
        emailContent += 'Timestamp :: ' + System.now() + '<br/>';
        emailContent += 'Username :: ' + appointment.Broker_Email__c + '<br/>';
        emailContent += 'Customer Name :: ' + appointment.Account_Name_Text__c + '<br/>';
        emailContent += 'Appointment Reference :: ' + appointment.Name + '<br/>';
        emailContent += 'Opportunity Status ' + appointment.Appointment_Status__c + ' - ' + oppo.StageName + '<br/>';
        emailContent += 'Opportunity Comments :: ' + oppo.Description + '<br/>';
        if (appointment.Opportunity__r.Closed_Lost_Reason__c != null) {
            emailContent += 'Closed Lost Reasons :: ' + appointment.Opportunity__r.Closed_Lost_Reason__c.replace('[', '').replace(']', '') + '<br/>';
        }
        emailContent += '2nd Appt Date :: ' + oppo.Second_Appointment_Date__c + '<br/>';
        emailContent += 'future followed date :: ' + oppo.Future_Followed_Date__c + '<br/>';
        emailContent += 'Presales Action Required? :: ' + presalesAction + '<br/>';
        emailContent += 'Presales Actions :: ' + actionContent + '<br/>';
        emailContent += 'Presales Rep :: ' + appointment.Pre_Sales_User__c + '<br/>';
        emailContent += 'Timestamp :: ' + System.now() + '<br/>';
        String emailSubject = '[brokerdailyreport] ACF Broker EOD - Successfully Submitted';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(appointment.Broker_Email__c);
        sendTo.add('brokerdailyreport@creditandfinance.com.au');
        sendTo.add(appointment.Opp_Owner_Email__c);
        //sendTo.add('cche5425@uni.sydney.edu.au');
        mail.setToAddresses(sendTo);
        mail.setSubject(emailSubject);
        mail.setHtmlBody(emailContent);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails.add(mail);
        Messaging.sendEmail(mails);
        
        System.debug('needHelp ' + needHelp);
        if (needHelp && currentUserManager != null) {
            //send message to chatter
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = ' I need help with this scenario ';
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            mentionSegmentInput.id = currentUserManager;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = oppo.Id;
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
        	
        	//Send email to josef
        	List<Messaging.SingleEmailMessage> mailsS = new List<Messaging.SingleEmailMessage>();
        	Messaging.SingleEmailMessage mailsSc = new Messaging.SingleEmailMessage();
        	List<String> sendToEmails = new List<String>();
      		sendToEmails.add('scenarios@creditandfinance.com.au');
      		mailsSc.setToAddresses(sendToEmails);
      		
      		mailsSc.setReplyTo(appointment.Broker_Email__c);
      		mailsSc.setSenderDisplayName('Scenario Help');
      		mailsSc.setSubject('Broker Needs Help');
      		
      		String body = 'Need help with appointment ' + appointment.Name + ', broker email is ' + appointment.Broker_Email__c;
      		mailsSc.setHtmlBody(body);
      		mailsS.add(mailsSc);
      		Messaging.sendEmail(mailsS);
        }
    }
    
}