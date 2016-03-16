public class Saasfocus_HotTransfer_Controller {
    Public Allocate_Appointment__c  obj;
    public Boolean iscall{get;set;}
    public Id NewEventId;
    public Event e {get;set;}
    Public String appointmentId;
    public Appointment__c Appointob {get;set;}

    public Saasfocus_HotTransfer_Controller() {
        appointmentId= ApexPages.currentPage().getParameters().get('id');
        Appointob = new Appointment__c();
        Appointob =[SELECT Id,Name,Account_Name__c,Account_Email__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Date_and_Time__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id FROM Appointment__c where id=:appointmentId];
        obj =  Allocate_Appointment__c.getValues('Phone_Broker');
    }

    public PageReference ChangeBroker() {
        if(Appointob.Appointment_Type__c!='Phone Appointment') {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Appointment type must be Phone Appointment.');
            ApexPages.addMessage(myMsg);
            return null;
        } else {
            String[] broker_Name=Appointob.Speciality_Skills__c .split(';');
            List<Broker__c> list_Assignedbroker = [select id,Email__c,Name from Broker__c where Name in :broker_Name];
            if(list_Assignedbroker.size()==1) {
                Broker__c bb1=list_Assignedbroker[0];
                Broker__c Assignedbroker = [select id,Email__c from Broker__c where Name =:bb1.Name];
                system.debug('HHHHHH'+Assignedbroker);
                Appointment__c newapp = new Appointment__c(id = appointmentId);
                newapp.Broker__c = Assignedbroker.id;
                update newapp;
                //Broker__c Assignedbroker = [select id,Email__c from Broker__c where id =:Appointob.Broker__r.Id];
                List<User> brokeruser = [select id,Email from User where Email = :Assignedbroker.Email__c];
                e= new Event();
                if(brokeruser.size()>0)
                e.ownerid = brokeruser[0].id;

                e.startdatetime =Datetime.now();
                e.enddatetime = Datetime.now().addMinutes(Integer.valueof(obj.DurationOfMeeting__c));
                e.whatid= newapp.Broker__c;
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

                iscall= true;
                return null;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select one Broker in Appointment Speciality Skills. ');
                ApexPages.addMessage(myMsg);
                return null;
            }

        }
    }

    public PageReference InsertCalender() {
        if(iscall==true) {
            NewEventId= e.id;
            GoogleCalendarService.insertGoogleEvent(new list<ID>{NewEventId});
            iscall= false;
        }
        return new pagereference('/'+appointmentId);
    }

    public PageReference Back() {
        return new pagereference('/'+appointmentId);
    }
    
}
