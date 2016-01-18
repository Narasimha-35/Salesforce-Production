public class ChangeAppointment_Class {
public List<Broker__c > BrokerList {get;set;}
public Broker__c Brkobj {get;set;}
public Appointment__c Appobj {get;set;}
public Appointment__c Appobjnew {get;set;}
public Event evobj{get;set;}
public string brokername{get;set;}
public id idb{get;set;}
public String brk;
public Integer DurationOfMeeting;
public Integer offset;
public  String selectedtime;
public datetime AppStarttime;
public boolean save1completed {get;set;}
public boolean save2completed {get;set;}
public Id NewEventId;


public List<SelectOption> getBroker()
    {
    
         idb = ApexPages.currentPage().getParameters().get('id');
        BrokerList =new list<Broker__c >();
         Appointment__c Appobjtemp = [Select Name,Broker__r.name,Broker__c,Appointment_Type__c,Broker_Email__c,Broker_Mobile__c from Appointment__c where id=:idb ];
         if(Appobjtemp.Appointment_Type__c == 'Phone Appointment')
         {
             BrokerList = [Select name from Broker__c where Active_Broker__c = true AND name != 'Unallocated Broker' AND Channel__c='Phone Broker'];
         }else
         {
              BrokerList = [Select name from Broker__c where Active_Broker__c = true AND name != 'Unallocated Broker' AND (Channel__c='Partner' OR Channel__c='Employee')];
         }
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--Please select a Broker--'));
        
        for (Broker__c br: BrokerList )
        {
            if(br.id != Appobjtemp.Broker__c )
            options.add(new SelectOption(br.id ,br.name));
            
        }
        return options;
 
    }
    
    public ChangeAppointment_Class()
    {
     idb = ApexPages.currentPage().getParameters().get('id');
     Appobj = [Select Name,Account_Name__c,Street_Address__c,City__c,Postal_Code__c,State__c,Broker__c,Appointment_Date_and_Time__c,Broker__r.name,Broker_Email__c,Broker_Mobile__c from Appointment__c where id=:idb ];
     
     save1completed = false;
     save2completed = false;
    
    }
    
    public void updateBroker()    
    {
       Appointment__c newapp = new Appointment__c(id = idb);
       newapp.Broker__c = brokername;
      // Appobj.Broker__c = brokername;
       update newapp;     
    }
    
    public void save()
    {
    
    //Brkobj  = new Broker__c();
  
    Appobjnew = new Appointment__c();
   
    // Step 1
    updateBroker();
   
   // Step 2 
   SendNoticationNew();
   SendNoticationOld();
   
   
   // Step 3   
    NewEventId =  InsertEvent();
     
  
      
      
        save1completed = true;
        system.debug('save1completed called save 2');
    }
    
   
    Public pagereference save2()
    {
     // Step 4  
     system.debug('Debug called save 2');
      Saasfocus_GoogleCalenderHelper.processEvent(new list<ID>{NewEventId});
      save2completed = true; 
      return null;
    }
    
    public pagereference Save3()
    {    
    
    // Step 5 - Send SMS to new broker.
    Appointment__c Appobjnew = [Select Name, Street_Address__c,City__c,Broker__c,Postal_Code__c,State__c,Broker__r.name ,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c from Appointment__c where id=:idb ];
     // Define SMS template++
    String NewSMSTemplate = 'The appointment '+Appobjnew.Name+' with '+Appobjnew.Street_Address__c+' '+Appobjnew.City__c+' '+Appobjnew.Postal_Code__c+' '+Appobjnew.State__c+' on '+Appobjnew.Appointment_Date_and_Time__c+' is allocated to you.';
     
     
     acfCommon.sendSMS(Appobjnew.Broker__r.name,Appobjnew.Broker_Mobile__c,NewSMSTemplate,true);
     System.debug('MobileNew'+Appobjnew.Broker_Mobile__c);
    
    // Step 6 - Delete old Event from salesforce and google calendar
    
    List<Event> lstevobj = [Select id,Google_Event_ID__c from Event where whatid =: Appobj.Broker__c AND Subject like :Appobj.Name+'%'  LIMIT 1];
  
      if(lstevobj.size()>0)
      {   
        if(lstevobj[0].Google_Event_ID__c != null)
        {
            System.debug('Amit'+lstevobj[0].Google_Event_ID__c);
            String st= Saasfocus_Global.getGoogleId(lstevobj[0].Google_Event_ID__c);
            System.debug('Bingo'+st);
            Chen_GoogleCalenderHelper.deleteEventOnGoogleCalendar(Appobj.Broker_Email__c,st,true);
        }
        else
         {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+'No Google Event Id Found!'));
         }
        
     }
    
    
    
    // Step 7 - Email to old broker
        
    
    // Step 8 - SMS to Old broker
    
    String OldSMSTemplate = 'The appointment '+Appobj.Name+' with '+Appobj.Street_Address__c+' '+Appobj.City__c+' '+Appobj.Postal_Code__c+' '+Appobj.State__c+' on '+Appobj.Appointment_Date_and_Time__c+'  is cancelled.';
     
     
     acfCommon.sendSMS(Appobj.Broker__r.name,Appobj.Broker_Mobile__c,OldSMSTemplate ,true);
     System.debug('MobileOld'+Appobj.Broker_Mobile__c);
     return new pagereference('/'+idb);
     //return null;
     }
               
      // Email Notification to old broker       
     public void SendNoticationOld()
     {
          EmailTemplate templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'Old_BrokerTemplate' AND isActive=true];
          string body1='';
          body1=templateId.HtmlValue;
          if(Appobj.Broker__r.name != null)
          {
          body1=body1.replace('{!Broker.Name}',Appobj.Broker__r.name);
          }
          else
          {
          body1=body1.replace('{!Broker.Name}','');
          }
          if(Appobj.Name != null)
          {
          body1=body1.replace('[[apptref]]',Appobj.Name);
          }
          else
          {
          body1=body1.replace('[[apptref]]','');
          }
          if(Appobj.Street_Address__c != null || Appobj.City__c!= null || Appobj.Postal_Code__c != null || Appobj.State__c!= null)
          {
          body1=body1.replace('[[customer name and address]]',Appobj.Account_Name__c+' '+Appobj.Street_Address__c+' '+Appobj.City__c+' '+Appobj.Postal_Code__c+' '+Appobj.State__c);
          }
          else
          {
          body1=body1.replace('[[customer name and address]]','');
          }
          if(Appobj.Appointment_Date_and_Time__c != null)
          {
          body1=body1.replace('[[appointment date and time]]',String.valueOf(Appobj.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
          }
          else
          {
          body1=body1.replace('[[apptref]]','');
          }

          Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();   
          
          email.setSubject(templateId.subject);
          email.setToAddresses( new string [] {Appobj.Broker_Email__c});
          email.setHtmlBody(body1);
          email.setBccSender(true);
        
          Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});  
        
            
            
      }
            // Email Notification to New broker   
            public void SendNoticationNew()
            {
            
                Appobjnew = [Select name,Car_Loan_Balance__c,Personal_Loan_Balance__c,Credit_Card_Balance__c,Partner_Income__c,Annual_Income__c,Industry__c,Employment_Status__c,Age_of_Current_Loan__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Current_Financials_Up_to_Date__c,Current_Interest_Rate_Type__c,Current_Interest_Rate__c,Current_Loan_Type__c,Current_Loan_Value__c,Current_Lender__c,Transaction_Type__c,Pre_Sales_Notes__c,Appointment_Type__c,Street_Address__c,City__c,Postal_Code__c,State__c,Alternate_Phone__c,Phone__c,Mobile__c,Account_Name__c,Account_Email__c,Pre_Sales_User__c,Broker__r.name,Appointment_Date_and_Time__c,Broker_Email__c,Broker_Mobile__c from Appointment__c where id=:idb ];
                
                EmailTemplate templateIdnew = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'New_BrokerTemplate' AND isActive=true];
                  string body2='';
                  body2=templateIdnew.HtmlValue;
                  if(Appobjnew.Broker__r.name!= null)
                  {
                  body2=body2.replace('{!Broker.Name}',Appobjnew.Broker__r.name);
                  }
                  else
                  {
                  body2=body2.replace('{!Broker.Name}','');
                  }
                  if(Appobjnew.name != null)
                  {
                  body2=body2.replace('[[AppRef]]',Appobjnew.name);
                  }
                  else
                  {
                  body2=body2.replace('[[AppRef]]','');
                  }
                  if(Appobjnew.Pre_Sales_User__c != null)
                  {
                  body2=body2.replace('[[Presales]]',Appobjnew.Pre_Sales_User__c);
                  }
                  else
                  {
                  body2=body2.replace('[[Presales]]','');
                  }
                  if(Appobjnew.Account_Name__c != null)
                  {
                  body2=body2.replace('[[CustName]]',Appobjnew.Account_Name__c);
                  }
                  else
                  {
                  body2=body2.replace('[[CustName]]','');
                  }
                  if(Appobjnew.Account_Email__c != null)
                  {
                  body2=body2.replace('[[CustEmail]]',Appobjnew.Account_Email__c);
                  }
                  else
                  {
                  body2=body2.replace('[[CustEmail]]','');
                  }
                  if(Appobjnew.Mobile__c != null)
                  {
                  body2=body2.replace('[[Mobile]]',Appobjnew.Mobile__c);
                  }
                  else
                  {
                  body2=body2.replace('[[Mobile]]','');
                  }
                  if(Appobjnew.Phone__c != null)
                  {
                  body2=body2.replace('[[Phone]]',Appobjnew.Phone__c);
                  }
                  else
                  {
                  body2=body2.replace('[[Phone]]','');
                  }
                  if(Appobjnew.Alternate_Phone__c != null)
                  {
                  body2=body2.replace('[[AlternatePhone]]',Appobjnew.Alternate_Phone__c);
                  }
                  else
                  {
                  body2=body2.replace('[[AlternatePhone]]','');
                  }
                  if(Appobjnew.Appointment_Date_and_Time__c != null)
                  {
                  body2=body2.replace('[[AppDateTime]]',String.valueOf(Appobjnew.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
                  }
                  else
                  {
                  body2=body2.replace('[[AppDateTime]]','');
                  }
                  if(Appobjnew.Street_Address__c != null)
                  {
                  body2=body2.replace('[[StreetAddress]]',Appobjnew.Street_Address__c);
                  }
                  else
                  {
                  body2=body2.replace('[[StreetAddress]]','');
                  }
                  if(Appobjnew.City__c!= null)
                  {
                  body2=body2.replace('[[City]]',Appobjnew.City__c);
                  }
                  else
                  {
                  body2=body2.replace('[[City]]','');
                  }
                  if(Appobjnew.Postal_Code__c != null)
                  {
                  body2=body2.replace('[[PostalCode]]',Appobjnew.Postal_Code__c);
                  }
                  else
                  {
                  body2=body2.replace('[[PostalCode]]','');
                  }
                  if(Appobjnew.State__c!= null)
                  {
                  body2=body2.replace('[[State]]',Appobjnew.State__c);
                  }
                  else
                  {
                  body2=body2.replace('[[State]]','');
                  }
                  if(Appobjnew.Appointment_Type__c != null)
                  {
                  body2=body2.replace('[[AppType]]',Appobjnew.Appointment_Type__c);
                  }
                  else
                  {
                  body2=body2.replace('[[AppType]]','');
                  }
                  if(Appobjnew.Pre_Sales_Notes__c != null)
                  {
                  body2=body2.replace('[[preNote]]',Appobjnew.Pre_Sales_Notes__c);
                  }
                  else
                  {
                  body2=body2.replace('[[preNote]]','');
                  }
                  if(Appobjnew.Transaction_Type__c != null)
                  {
                  body2=body2.replace('[[TransactionType]]',Appobjnew.Transaction_Type__c);
                  }
                  else
                  {
                  body2=body2.replace('[[TransactionType]]','');
                  }
                  if(Appobjnew.Current_Lender__c != null)
                  {
                  body2=body2.replace('[[CurrentLender]]',Appobjnew.Current_Lender__c);
                  }
                  else
                  {
                  body2=body2.replace('[[CurrentLender]]','');
                  }
                  if(Appobjnew.Current_Loan_Value__c != null)
                  {
                  body2=body2.replace('[[CurrentLoanValue]]',String.valueOf(Appobjnew.Current_Loan_Value__c));
                  }
                  else
                  {
                  body2=body2.replace('[[CurrentLoanValue]]','');
                  }
                  if(Appobjnew.Current_Loan_Type__c != null)
                  {
                  body2=body2.replace('[[CurrentLoanType]]',Appobjnew.Current_Loan_Type__c);
                  }
                  else
                  {
                  body2=body2.replace('[[CurrentLoanType]]','');
                  }
                  if(Appobjnew.Current_Interest_Rate__c != null)
                  {
                  body2=body2.replace('[[CurrentInterestRate]]',String.valueOf(Appobjnew.Current_Interest_Rate__c));
                  }
                  else
                  {
                  body2=body2.replace('[[CurrentInterestRate]]','');
                  }
                  if(Appobjnew.Current_Interest_Rate_Type__c != null)
                  {
                  body2=body2.replace('[[CurrentInterestRateType]]',Appobjnew.Current_Interest_Rate_Type__c);
                  }
                  else
                  {
                  body2=body2.replace('[[CurrentInterestRateType]]','');
                  }
                  if(Appobjnew.Current_Financials_Up_to_Date__c != null)
                  {
                  body2=body2.replace('[[CurrentFinancials]]',Appobjnew.Current_Financials_Up_to_Date__c);
                  }
                  else
                  {
                  body2=body2.replace('[[CurrentFinancials]]','');
                  }
                  if(Appobjnew.Fixed_Rate_Expiry__c != null)
                  {
                  body2=body2.replace('[[FixedRate]]',String.valueOf(Appobjnew.Fixed_Rate_Expiry__c));
                  }
                  else
                  {
                  body2=body2.replace('[[FixedRate]]','');
                  }
                  if(Appobjnew.Last_Refinance__c != null)
                  {
                  body2=body2.replace('[[lastRefinance]]',String.valueOf(Appobjnew.Last_Refinance__c));
                  }
                  else
                  {
                  body2=body2.replace('[[lastRefinance]]','');
                  }
                  if(Appobjnew.Age_of_Current_Loan__c != null)
                  {
                  body2=body2.replace('[[AgeCurrent]]',Appobjnew.Age_of_Current_Loan__c);
                  }
                  else
                  {
                  body2=body2.replace('[[AgeCurrent]]','');
                  }
                  if(Appobjnew.Employment_Status__c!= null)
                  {
                  body2=body2.replace('[[EmploymentStatus]]',Appobjnew.Employment_Status__c);
                  }
                  else
                  {
                  body2=body2.replace('[[EmploymentStatus]]','');
                  }
                  if(Appobjnew.Industry__c != null)
                  {
                  body2=body2.replace('[[Industry]]',Appobjnew.Industry__c);
                  }
                  else
                  {
                  body2=body2.replace('[[Industry]]','');
                  }
                  if(Appobjnew.Annual_Income__c != null)
                  {
                  body2=body2.replace('[[AnnualIncome]]',String.valueOf(Appobjnew.Annual_Income__c));
                  }
                  else
                  {
                  body2=body2.replace('[[AnnualIncome]]','');
                  }
                  if(Appobjnew.Partner_Income__c != null)
                  {
                  body2=body2.replace('[[PartnerIncome]]',String.valueOf(Appobjnew.Partner_Income__c));
                  }
                  else
                  {
                  body2=body2.replace('[[PartnerIncome]]','');
                  }
                  if(Appobjnew.Credit_Card_Balance__c != null)
                  {
                  body2=body2.replace('[[CreditCardBalance]]',String.valueOf(Appobjnew.Credit_Card_Balance__c));
                  }
                  else
                  {
                  body2=body2.replace('[[CreditCardBalance]]','');
                  }
                  if(Appobjnew.Personal_Loan_Balance__c != null)
                  {
                  body2=body2.replace('[[PersonalLoanBalance]]',String.valueOf(Appobjnew.Personal_Loan_Balance__c));
                  }
                  else
                  {
                  body2=body2.replace('[[PersonalLoanBalance]]','');
                  }
                  if(Appobjnew.Car_Loan_Balance__c != null)
                  {
                  body2=body2.replace('[[CarLoanBalance]]',String.valueOf(Appobjnew.Car_Loan_Balance__c));
                  }
                  else
                  {
                  body2=body2.replace('[[CarLoanBalance]]','');
                  }
         
                 Messaging.SingleEmailMessage emailnew = new Messaging.SingleEmailMessage();   
                  
                emailnew.setSubject(templateIdnew.subject);
                emailnew.setToAddresses( new string [] {Appobjnew.Broker_Email__c});
                emailnew.setHtmlBody(body2);
                emailnew.setBccSender(true);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailnew});
            
            }
    
           public time  convertStringToTime(String selectedtime) // Define a method for convert string to time
            {
            List<String> newLst = new List<String>();
            newLst= selectedtime.split(':');
            return Time.newInstance(Integer.valueOf(newLst[0]),Integer.valueOf(newLst[1]),0,0);
           
            }
    
    // Insert Event under new Broker
    public Id InsertEvent()
    {
        //Broker__c Brkobjnew = new Broker__c();
        //Brkobjnew = [Select id,Name,Email__c,MobilePhone__c from Broker__c where Id=:brokername limit 1];
        
       
       Allocate_Appointment__c  objappAll =  Allocate_Appointment__c.getValues('Phone_Broker');
       DurationOfMeeting = Integer.valueOf(objappAll.DurationOfMeeting__c);
       
       
       
       Appointment__c obj = new Appointment__c();
       obj =[SELECT Id,Name,Account_Name__c,Account_Email__c, Account_Name_Text__c, Mobile__c,Phone__c,Employment_Status__c,Industry__c,Annual_Income__c,Partner_Income__c,Credit_Card_Balance__c,Personal_Loan_Balance__c,Appointment_Date_and_Time__c,Street_Address__c,City__c,State__c, Pre_Sales_Notes__c,Transaction_Type__c,Current_Lender__c,Current_Loan_Value__c,Current_Loan_Type__c,Current_Interest_Rate__c,Current_Interest_Rate_Type__c,Current_Financials_Up_to_Date__c,Last_Refinance__c,Fixed_Rate_Expiry__c,Age_of_Current_Loan__c,Postal_Code__c,Appointment_Type__c,Speciality_Skills__c,region__r.Sydney_Timezone_Offset__c,Market__r.Id,Market__r.Name,Region__r.Name,Region__c,Broker__r.Id FROM Appointment__c where id=:idb ];
       
        Time selectedT = Datetime.valueOf(obj.Appointment_Date_and_Time__c).time();
       //offset = (Integer) (obj.region__r.Sydney_Timezone_Offset__c *60);
       
       
         Broker__c Assignedbroker = [select id,Email__c,Primary_Market__r.Region__r.Sydney_Timezone_Offset__c from Broker__c where id =:brokername];
          
          List<User> brokeruser = [select id , Email from User where Email = :Assignedbroker.Email__c];
          AppStarttime  =  Datetime.newInstance(obj.Appointment_Date_and_Time__c.date(),selectedT);
          Datetime DT = Datetime.newInstance(obj.Appointment_Date_and_Time__c.year(),obj.Appointment_Date_and_Time__c.month(),obj.Appointment_Date_and_Time__c.day(),selectedT.hour(),selectedT.minute(),0);
         
         
         Event e = new Event();
         
         if(brokeruser.size()>0)
         e.ownerid = brokeruser[0].id;
         
      //   e.Startdatetime= DT;
        // e.Enddatetime= e.Startdatetime.addminutes(DurationOfMeeting);
        
        
          List<Event> lstevobj = [Select id,Google_Event_ID__c,startdatetime,enddatetime from Event where whatid =: Appobj.Broker__c AND Subject like :Appobj.Name+'%'  LIMIT 1];
          if(lstevobj.size()>0)
          {
          e.startdatetime = lstevobj[0].startdatetime ;
          e.enddatetime = lstevobj[0].enddatetime ;
          }
        
          if(offset !=null) 
          {  
               e.startdatetime = e.startdatetime.addMinutes(offset);
               e.enddatetime = e.enddatetime.addMinutes(offset);
          }
          
          
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

         e.whatid= Appobjnew.Broker__c;
                 if(Test.isRunningTest()){
                    
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
        
        public pagereference Cancel()
        {
            PageReference pageRef = new PageReference('/'+idb );
            return pageRef;
        }
}