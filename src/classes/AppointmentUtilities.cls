public with sharing class AppointmentUtilities {
	// Email Notification to old broker
   public static void sendEmailToOldBroker(Appointment__c currentAppointment) {
      EmailTemplate templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'Old_BrokerTemplate' AND isActive=true];
      string body1='';
      body1=templateId.HtmlValue;
      if(currentAppointment.Broker__r.name != null) {
         body1=body1.replace('{!Broker.Name}',currentAppointment.Broker__r.name);
      } else {
         body1=body1.replace('{!Broker.Name}','');
      }

      if(currentAppointment.Name != null) {
         body1=body1.replace('[[apptref]]',currentAppointment.Name);
      } else {
         body1=body1.replace('[[apptref]]','');
      }

      if(currentAppointment.Street_Address__c != null || currentAppointment.City__c!= null || currentAppointment.Postal_Code__c != null || currentAppointment.State__c!= null) {
         body1=body1.replace('[[customer name and address]]',currentAppointment.Account_Name__c+' '+currentAppointment.Street_Address__c+' '+currentAppointment.City__c+' '+currentAppointment.Postal_Code__c+' '+currentAppointment.State__c);
      } else {
         body1=body1.replace('[[customer name and address]]','');
      }

      if(currentAppointment.Appointment_Date_and_Time__c != null) {
         body1=body1.replace('[[appointment date and time]]',String.valueOf(currentAppointment.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
      } else {
         body1=body1.replace('[[apptref]]','');
      }

      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

      email.setSubject(templateId.subject);
      email.setToAddresses( new string [] {currentAppointment.Broker_Email__c});
      email.setHtmlBody(body1);
      email.setBccSender(true);

      Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
   }

   // Email Notification to New broker
   public static void sendEmailToNewBroker(Appointment__c currentAppointment) {
      Appointment__c newAppointment = [Select name,Car_Loan_Balance__c,Personal_Loan_Balance__c,Credit_Card_Balance__c,Partner_Income__c,Annual_Income__c,Industry__c,Employment_Status__c,Age_of_Current_Loan__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Current_Financials_Up_to_Date__c,Current_Interest_Rate_Type__c,Current_Interest_Rate__c,Current_Loan_Type__c,Current_Loan_Value__c,Current_Lender__c,Transaction_Type__c,Pre_Sales_Notes__c,Appointment_Type__c,Street_Address__c,City__c,Postal_Code__c,State__c,Alternate_Phone__c,Phone__c,Mobile__c,Account_Name__c,Account_Email__c,Pre_Sales_User__c,Broker__r.name,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c from Appointment__c where id=:currentAppointment.id ];

      EmailTemplate templateIdnew = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'New_BrokerTemplate' AND isActive=true];
      string body2='';
      body2=templateIdnew.HtmlValue;

      if(newAppointment.Broker__r.name!= null) {
         body2=body2.replace('{!Broker.Name}',newAppointment.Broker__r.name);
      } else {
         body2=body2.replace('{!Broker.Name}','');
      }

      if(newAppointment.name != null) {
         body2=body2.replace('[[AppRef]]',newAppointment.name);
      } else {
         body2=body2.replace('[[AppRef]]','');
      }

      if(newAppointment.Pre_Sales_User__c != null) {
         body2=body2.replace('[[Presales]]',newAppointment.Pre_Sales_User__c);
      } else {
         body2=body2.replace('[[Presales]]','');
      }

      if(newAppointment.Account_Name__c != null) {
         body2=body2.replace('[[CustName]]',newAppointment.Account_Name__c);
      } else {
         body2=body2.replace('[[CustName]]','');
      }

      if(newAppointment.Account_Email__c != null) {
         body2=body2.replace('[[CustEmail]]',newAppointment.Account_Email__c);
      } else {
         body2=body2.replace('[[CustEmail]]','');
      }

      if(newAppointment.Mobile__c != null) {
         body2=body2.replace('[[Mobile]]',newAppointment.Mobile__c);
      } else {
         body2=body2.replace('[[Mobile]]','');
      }

      if(newAppointment.Phone__c != null) {
         body2=body2.replace('[[Phone]]',newAppointment.Phone__c);
      } else {
         body2=body2.replace('[[Phone]]','');
      }

      if(newAppointment.Alternate_Phone__c != null) {
         body2=body2.replace('[[AlternatePhone]]',newAppointment.Alternate_Phone__c);
      } else {
         body2=body2.replace('[[AlternatePhone]]','');
      }

      if(newAppointment.Appointment_Date_and_Time__c != null) {
         body2=body2.replace('[[AppDateTime]]',String.valueOf(newAppointment.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
      } else {
         body2=body2.replace('[[AppDateTime]]','');
      }

      if(newAppointment.Street_Address__c != null) {
         body2=body2.replace('[[StreetAddress]]',newAppointment.Street_Address__c);
      } else {
         body2=body2.replace('[[StreetAddress]]','');
      }

      if(newAppointment.City__c!= null) {
         body2=body2.replace('[[City]]',newAppointment.City__c);
      } else {
         body2=body2.replace('[[City]]','');
      }

      if(newAppointment.Postal_Code__c != null) {
         body2=body2.replace('[[PostalCode]]',newAppointment.Postal_Code__c);
      } else {
         body2=body2.replace('[[PostalCode]]','');
      }

      if(newAppointment.State__c!= null) {
         body2=body2.replace('[[State]]',newAppointment.State__c);
      } else {
         body2=body2.replace('[[State]]','');
      }

      if(newAppointment.Appointment_Type__c != null) {
         body2=body2.replace('[[AppType]]',newAppointment.Appointment_Type__c);
      } else {
         body2=body2.replace('[[AppType]]','');
      }

      if(newAppointment.Pre_Sales_Notes__c != null) {
         body2=body2.replace('[[preNote]]',newAppointment.Pre_Sales_Notes__c);
      } else {
         body2=body2.replace('[[preNote]]','');
      }

      if(newAppointment.Transaction_Type__c != null) {
         body2=body2.replace('[[TransactionType]]',newAppointment.Transaction_Type__c);
      } else {
         body2=body2.replace('[[TransactionType]]','');
      }

      if(newAppointment.Current_Lender__c != null) {
         body2=body2.replace('[[CurrentLender]]',newAppointment.Current_Lender__c);
      } else {
         body2=body2.replace('[[CurrentLender]]','');
      }

      if(newAppointment.Current_Loan_Value__c != null) {
         body2=body2.replace('[[CurrentLoanValue]]',String.valueOf(newAppointment.Current_Loan_Value__c));
      } else {
         body2=body2.replace('[[CurrentLoanValue]]','');
      }

      if(newAppointment.Current_Loan_Type__c != null) {
         body2=body2.replace('[[CurrentLoanType]]',newAppointment.Current_Loan_Type__c);
      } else {
         body2=body2.replace('[[CurrentLoanType]]','');
      }

      if(newAppointment.Current_Interest_Rate__c != null) {
         body2=body2.replace('[[CurrentInterestRate]]',String.valueOf(newAppointment.Current_Interest_Rate__c));
      } else {
         body2=body2.replace('[[CurrentInterestRate]]','');
      }

      if(newAppointment.Current_Interest_Rate_Type__c != null) {
         body2=body2.replace('[[CurrentInterestRateType]]',newAppointment.Current_Interest_Rate_Type__c);
      } else {
         body2=body2.replace('[[CurrentInterestRateType]]','');
      }

      if(newAppointment.Current_Financials_Up_to_Date__c != null) {
         body2=body2.replace('[[CurrentFinancials]]',newAppointment.Current_Financials_Up_to_Date__c);
      } else {
         body2=body2.replace('[[CurrentFinancials]]','');
      }

      if(newAppointment.Fixed_Rate_Expiry__c != null) {
         body2=body2.replace('[[FixedRate]]',String.valueOf(newAppointment.Fixed_Rate_Expiry__c));
      } else {
         body2=body2.replace('[[FixedRate]]','');
      }

      if(newAppointment.Last_Refinance__c != null) {
         body2=body2.replace('[[lastRefinance]]',String.valueOf(newAppointment.Last_Refinance__c));
      } else {
         body2=body2.replace('[[lastRefinance]]','');
      }

      if(newAppointment.Age_of_Current_Loan__c != null) {
         body2=body2.replace('[[AgeCurrent]]',newAppointment.Age_of_Current_Loan__c);
      } else {
         body2=body2.replace('[[AgeCurrent]]','');
      }

      if(newAppointment.Employment_Status__c!= null) {
         body2=body2.replace('[[EmploymentStatus]]',newAppointment.Employment_Status__c);
      } else {
         body2=body2.replace('[[EmploymentStatus]]','');
      }

      if(newAppointment.Industry__c != null) {
         body2=body2.replace('[[Industry]]',newAppointment.Industry__c);
      } else {
         body2=body2.replace('[[Industry]]','');
      }

      if(newAppointment.Annual_Income__c != null) {
         body2=body2.replace('[[AnnualIncome]]',String.valueOf(newAppointment.Annual_Income__c));
      } else {
         body2=body2.replace('[[AnnualIncome]]','');
      }

      if(newAppointment.Partner_Income__c != null) {
         body2=body2.replace('[[PartnerIncome]]',String.valueOf(newAppointment.Partner_Income__c));
      } else {
         body2=body2.replace('[[PartnerIncome]]','');
      }

      if(newAppointment.Credit_Card_Balance__c != null) {
         body2=body2.replace('[[CreditCardBalance]]',String.valueOf(newAppointment.Credit_Card_Balance__c));
      } else {
         body2=body2.replace('[[CreditCardBalance]]','');
      }

      if(newAppointment.Personal_Loan_Balance__c != null) {
         body2=body2.replace('[[PersonalLoanBalance]]',String.valueOf(newAppointment.Personal_Loan_Balance__c));
      } else {
         body2=body2.replace('[[PersonalLoanBalance]]','');
      }

      if(newAppointment.Car_Loan_Balance__c != null) {
         body2=body2.replace('[[CarLoanBalance]]',String.valueOf(newAppointment.Car_Loan_Balance__c));
      } else {
         body2=body2.replace('[[CarLoanBalance]]','');
      }

      Messaging.SingleEmailMessage emailnew = new Messaging.SingleEmailMessage();

      emailnew.setSubject(templateIdnew.subject);
      emailnew.setToAddresses( new string [] {newAppointment.Broker_Email__c});
      emailnew.setHtmlBody(body2);
      emailnew.setBccSender(true);

      Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailnew});
   }
}
