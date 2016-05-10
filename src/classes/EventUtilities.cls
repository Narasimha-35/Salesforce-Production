public with sharing class EventUtilities {
	// Insert Event under new Broker
   public static Id InsertEvent(Id currentAppointmentId, String brokername, Appointment__c newAppointment) {
      Allocate_Appointment__c  objappAll =  Allocate_Appointment__c.getValues('Phone_Broker');
      Integer durationOfMeeting = Integer.valueOf(objappAll.durationOfMeeting__c);

      Appointment__c obj = new Appointment__c();
      obj =[SELECT Id,Name,Account_Name__c,Account_Email__c,Appointment_Date_and_Time__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Time_and_Date_Adj__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id FROM Appointment__c where id=:currentAppointmentId ];

      Time selectedT = Datetime.valueOf(obj.Appointment_Time_and_Date_Adj__c).time();
      //offset = (Integer) (obj.region__r.Sydney_Timezone_Offset__c *60);
      Broker__c Assignedbroker = [select id,Email__c,Primary_Market__r.Region__r.Sydney_Timezone_Offset__c from Broker__c where id =:brokername];

      List<User> brokeruser = [select id , Email from User where Email = :Assignedbroker.Email__c];
      Datetime DT = Datetime.newInstance(obj.Appointment_Time_and_Date_Adj__c.year(),obj.Appointment_Time_and_Date_Adj__c.month(),obj.Appointment_Time_and_Date_Adj__c.day(),selectedT.hour(),selectedT.minute(),0);

      Event e = new Event();

      if(brokeruser.size()>0)
      e.ownerid = brokeruser[0].id;

      e.Startdatetime= DT;
      e.Enddatetime= e.Startdatetime.addminutes(durationOfMeeting);

      //TODO: new offset
      // if(offset !=null) {
      //    e.startdatetime = e.startdatetime.addMinutes(offset);
      //    e.enddatetime = e.enddatetime.addMinutes(offset);
      // }

      String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

      e.whatid= newAppointment.Broker__c;
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
      if(obj.Pre_Sales_Notes__c != null){
         s1 = obj.Pre_Sales_Notes__c;
         s1=  s1.stripHtmlTags();
      }
      system.debug('neeeeeeee'+obj .Pre_Sales_Notes__c);
      system.debug('neeee2222'+obj .Street_Address__c);
      string nextline = '\n';
      e.Description = 'Appointment Reference: ' + obj .Name + nextline+ 'Date and Time Of Appointment:'+' '+obj .Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')+nextline+
      'Customer Mobile:'+' '+obj .Mobile__c+nextline+
      'Customer Phone:'+' '+ obj .Phone__c +nextline+
      'Customer Location:'+' '+obj .Street_Address__c+','+obj .City__c+','+obj .State__c+','+obj .Postal_Code__c+nextline+
      'Customer Email:'+' '+obj .Account_Email__c+nextline+
      'Customer Name:'+' '+obj .Account_Name_Text__c+nextline+nextline+
      'Notes from Pre Sales' +nextline+
      +s1+nextline+nextline+
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

      System.debug('capacity' +e);
      insert e;

      return e.id;
   }
}
