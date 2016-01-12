@isTest
private class SaaSFocus_AppointmentController_Tracker
{      
   static testMethod void MethodSaaSFocus_AppointmentController() 
    {
         Account a = new Account();
        a.PersonEmail = 'nee8979@gmail.com';
        a.PersonMobilePhone= '+618979707981';
        a.LastName  = 'NameLastWala';
        a.Employment_Status__pc ='Casual';
        a.Marital_Status__pc = 'Single';
        a.Housing_Status__pc = 'Renting';
        a.Number_of_Children__pc = '2';
        a.Partner_Annual_Income__pc = 89489;
        a.Partner_Super_Balance__pc = 7897;
        a.Super_Balance__pc = 89786;
        a.Annual_Income__pc= 5768;
        insert a;
            
       Opportunity  o = new Opportunity();
       o.RecordTypeId= '01290000000thgD';
       o.Name = 'nee';
       o.AccountId= a.id;
       o.StageName= 'Appointed';
       o.CloseDate = System.Today();
       o.Transaction_Type__c= 'Refinance';
       o.Current_Lender__c= 'AMP';
       o.Current_Loan_Value__c = 8888;
       o.Current_Loan_Type__c = 'Construction';
       o.Personal_Loan_Balance__c = 7879;
       o.Credit_Card_Balance__c = 8973;
       o.Car_Loan_Balance__c  = 8748;
       insert o;
       
       Market__c  m = new Market__c();
       m.Name = 'Dash';
       m.Market_Region__c= 'North'; 
       insert m;
       
       State__c  s = new State__c();
       s.Name    = 'sim';
       insert s;
       
       Region__c  r = new Region__c();
       r.State__c = s.Id ;
       r.Name  = 'North';
       r.Sydney_Timezone_Offset__c =10;
       insert r;
              
       Broker__c bro =  new Broker__c();
       bro.Name    = 'Nee';
       bro.MobilePhone__c ='8979707981'; 
       bro.Email__c  = 'nee8979@gmail.com';
       bro.Street_Address__c = 'hgjk';
       bro.City__c  = 'srinagar';
       bro.Channel__c  = 'Phone Broker';
       bro.Primary_Market__c= m.id;
       bro.Active_Broker__c= true;
       bro.State__c   = s.Id;
       bro.Speciality_Skills__c='Specialist';
       insert bro;       
       System.debug('brokerkiId' +bro.id);
       
       Market_Broker_Association__c MB = new Market_Broker_Association__c();
       MB.Name = 'hjk';
       MB.Broker__c =bro.Id;
       MB.Market__c=m.Id;
       MB.Priority__c='Primary Market';
       insert MB;
       
       Appointment__c app = new Appointment__c();
       app.RecordTypeId= '01290000000ttUO';
       app.Opportunity__c= o.Id;
       app.Broker__c = bro.Id;
       app.Market__c = m.Id;
       app.Region__c = r.Id ;
       app.Appointment_Date_and_Time__c = datetime.newInstance(2015, 12, 5, 8, 30, 2);
       app.Appointment_Status__c   = 'New';
       app.Appointment_Type__c   = 'Phone Appointment';
       app.Speciality_Skills__c = '';
       app.Street_Address__c = 'abc'; 
       app.State__c = 'Victoria';
       app.City__c  = 'real street';
       app.Postal_Code__c = '6387';
       app.Pre_Sales_Notes__c='jlkasdhakj';
       insert app;
       
            System.debug('Appointmentbroker' +app.Broker__c);
            ApexPages.currentPage().getParameters().put('id', app.Id);
            Allocate_Appointment__c   allobj =   new Allocate_Appointment__c();
            allobj.Name='Phone_Broker';
            allobj.DurationOfMeeting__c= '60';
            allobj.Buffer__c=  '20';
            allobj.IntervalOfMeeting__c= '20';
            allobj.DayStartTime__c= '8';
            allobj.DayEndTime__c   ='17';
            insert allobj;    
            
            Saasfocus_Global.GoogleSyncProces=True;
            Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
            obj1.Name='Google_Setting'; 
            obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
            obj1.Google_Calender_ID__c='kripa@getmaxx.in';
            obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
            obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
            insert obj1;
                  SaaSFocus_AppointmentController obj = new SaaSFocus_AppointmentController();
                  
                  Test.startTest();
                  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                  Test.stopTest();         
            
                Event ev=new Event();
                ev.StartDateTime=Datetime.newInstance(2015, 12, 5, 0, 30, 2);
                ev.Type ='Email';
                ev.EndDateTime=Datetime.newInstance(2015, 12, 5, 1, 30, 2);
                ev.Subject='asadg';
                ev.Description='gfhf';
                ev.whatid =bro.id;
                insert ev;
               
                System.debug('event....'+ev);
                obj.getFreeBrokers();
                obj.roundToHour(system.now().time());
                obj.getAvailableSchedule();
                System.debug('selectkarotime'+obj.selectedtime); 
                obj.Cancel();                        
      }
      static testMethod void MyMethod2()
    {
    
       Account a = new Account();
        a.PersonEmail = 'nee8979@gmail.com';  
        a.PersonMobilePhone= '+618979707981';
        a.LastName  = 'NameLastWala';
        a.Employment_Status__pc ='Casual';
        a.Marital_Status__pc = 'Single';
        a.Housing_Status__pc = 'Renting';
        a.Number_of_Children__pc = '2';
        a.Partner_Annual_Income__pc = 89489;
        a.Partner_Super_Balance__pc = 7897;
        a.Super_Balance__pc = 89786;
        a.Annual_Income__pc= 5768;
        insert a;
        
       Opportunity  o = new Opportunity();
       o.RecordTypeId= '01290000000thgD';
       o.Name = 'nee';
       o.AccountId= a.id;
       o.StageName= 'Appointed';
       o.CloseDate = System.Today();
       o.Transaction_Type__c= 'Refinance';
       o.Current_Lender__c= 'AMP';
       o.Current_Loan_Value__c = 8888;
       o.Current_Loan_Type__c = 'Construction';
       o.Personal_Loan_Balance__c = 7879;
       o.Credit_Card_Balance__c = 8973;
       o.Car_Loan_Balance__c  = 8748;
       insert o;
       
       Market__c  m = new Market__c();
       m.Name = 'Dash';
       m.Market_Region__c= 'North'; 
       insert m;
       
       State__c  s = new State__c();
       s.Name    = 'sim';
       insert s;
       
       Region__c  r = new Region__c();
       r.State__c = s.Id ;
       r.Name  = 'North';
       r.Sydney_Timezone_Offset__c =10;
       insert r;
              
       Broker__c bro =  new Broker__c();
       bro.Name    = 'Nee';
       bro.MobilePhone__c ='8979707981'; 
       bro.Email__c  = 'nee8979@gmail.com';
       bro.Street_Address__c = 'hgjk';
       bro.City__c  = 'srinagar';
       bro.Channel__c  = 'Employee';
       bro.Primary_Market__c= m.id;
       bro.Active_Broker__c= true;
       bro.State__c   = s.Id;
       bro.Speciality_Skills__c='Specialist';
       insert bro;       
       
        
       Market_Broker_Association__c MB = new Market_Broker_Association__c();
       MB.Name = 'hjk';
       MB.Broker__c =bro.Id;
       MB.Market__c=m.Id;
       MB.Priority__c='Primary Market';
       insert MB;
       
       Appointment__c app = new Appointment__c();
       app.RecordTypeId= '01290000000ttUO';
       app.Opportunity__c= o.Id;
       app.Broker__c = bro.Id;
       app.Market__c = m.Id;
       app.Region__c = r.Id ;
       app.Appointment_Date_and_Time__c =  datetime.newInstance(2015, 12, 5, 8, 30, 2);
       app.Appointment_Status__c   = 'New';
       app.Appointment_Type__c   = 'First Appointment';
       app.Speciality_Skills__c = '';
       app.Street_Address__c = 'abc'; 
       app.State__c = 'Victoria';
       app.City__c  = 'real street';
       app.Postal_Code__c = '6387';
       insert app;   

            ApexPages.currentPage().getParameters().put('id', app.Id);
            Allocate_Appointment__c   allobj =   new Allocate_Appointment__c();
            allobj.Name='Face_To_face';
            allobj.DurationOfMeeting__c= '60';
            allobj.Buffer__c=  '20';
            allobj.IntervalOfMeeting__c= '20';
            allobj.DayStartTime__c= '8';
            allobj.DayEndTime__c   ='17';
            insert allobj; 
           
                  Saasfocus_Global.GoogleSyncProces=True;
                  Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
                  obj1.Name='Google_Setting'; 
                  obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
                  obj1.Google_Calender_ID__c='kripa@getmaxx.in';
                  obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
                  obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
                  insert obj1;
                    
                  SaaSFocus_AppointmentController obj = new SaaSFocus_AppointmentController();
                  Test.startTest();
                  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());                  
                  Test.stopTest();    
                    
                
                Event ev=new Event();
                ev.StartDateTime=Datetime.newInstance(2015, 12, 5, 0, 30, 2);
                ev.Type ='Email';
                ev.EndDateTime=Datetime.newInstance(2015, 12, 5, 1, 30, 2);
                ev.Subject='asadg';
                ev.Description='gfhf';
                ev.whatid =bro.id;
                insert ev;

                System.debug('anothertimeEvent' +ev);
                obj.convertStringToTime(String.valueOf(datetime.newInstance(2015, 2, 17,4,15,0).time()));
                obj.getFreeBrokers();
                obj.roundToHour(datetime.newInstance(2015, 2, 17,4,15,00).time());  
                obj.selectedtime = String.valueOf(datetime.newInstance(2015, 2, 17,3,15,0)); 
               // obj.Confirm();                
     }   
    
     static testMethod void MyMethod3()
    {
     
        Account a = new Account();
        a.PersonEmail = 'nee8979@gmail.com';  
        a.PersonMobilePhone= '+618979707981';
        a.LastName  = 'NameLastWala';
        a.Employment_Status__pc ='Casual';
        a.Marital_Status__pc = 'Single';
        a.Housing_Status__pc = 'Renting';
        a.Number_of_Children__pc = '2';
        a.Partner_Annual_Income__pc = 89489;
        a.Partner_Super_Balance__pc = 7897;
        a.Super_Balance__pc = 89786;
        a.Annual_Income__pc= 5768;
        insert a;
        
       Opportunity  o = new Opportunity();
       o.RecordTypeId= '01290000000thgD';
       o.Name = 'nee';
       o.AccountId= a.id;
       o.StageName= 'Appointed';
       o.CloseDate = System.Today();
       o.Transaction_Type__c= 'Refinance';
       o.Current_Lender__c= 'AMP';
       o.Current_Loan_Value__c = 8888;
       o.Current_Loan_Type__c = 'Construction';
       o.Personal_Loan_Balance__c = 7879;
       o.Credit_Card_Balance__c = 8973;
       o.Car_Loan_Balance__c  = 8748;
       insert o;
       
       Market__c  m = new Market__c();
       m.Name = 'Dash';
       m.Market_Region__c= 'North'; 
       insert m;
       
       State__c  s = new State__c();
       s.Name    = 'sim';
       insert s;
       
       Region__c  r = new Region__c();
       r.State__c = s.Id ;
       r.Name  = 'North';
       r.Sydney_Timezone_Offset__c =10;
       insert r;
              
       Broker__c bro =  new Broker__c();
       bro.Name    = 'Nee';
       bro.MobilePhone__c ='8979707981'; 
       bro.Email__c  = 'nee8979@gmail.com';
       bro.Street_Address__c = 'hgjk';
       bro.City__c  = 'srinagar';
       bro.Channel__c  = 'Employee';
       bro.Primary_Market__c= m.id;
       bro.Active_Broker__c= true;
       bro.State__c   = s.Id;
       bro.Speciality_Skills__c='Specialist';
       insert bro;       
               
       Market_Broker_Association__c MB = new Market_Broker_Association__c();
       MB.Name = 'hjk';
       MB.Broker__c =bro.Id;
       MB.Market__c=m.Id;
       MB.Priority__c='Primary Market';
       insert MB;
       
       Appointment__c app = new Appointment__c();
       app.RecordTypeId= '01290000000ttUO';
       app.Opportunity__c= o.Id;
       app.Broker__c = bro.Id;
       app.Market__c = m.Id;
       app.Region__c = r.Id ;
       app.Appointment_Date_and_Time__c =  datetime.newInstance(2015, 12, 5, 8, 30, 2);
       app.Appointment_Status__c   = 'New';
       app.Appointment_Type__c   = 'First Appointment';
       app.Speciality_Skills__c = 'Specialist';
       app.Street_Address__c = 'abc'; 
       app.State__c = 'Victoria';
       app.City__c  = 'real street';
       app.Postal_Code__c = '6387';
       insert app;   

            ApexPages.currentPage().getParameters().put('id', app.Id);
            Allocate_Appointment__c   allobj =   new Allocate_Appointment__c();
            allobj.Name='Face_To_face';
            allobj.DurationOfMeeting__c= '60';
            allobj.Buffer__c=  '20';
            allobj.IntervalOfMeeting__c= '20';
            allobj.DayStartTime__c= '8';
            allobj.DayEndTime__c   ='17';
            insert allobj; 
           
            Saasfocus_Global.GoogleSyncProces=True;
            Google_API_Setting__c  obj1 =  new Google_API_Setting__c();
            obj1.Name='Google_Setting'; 
            obj1.Access_Token_Time_Stamp__c= DateTime.now().addDays(-2);
            obj1.Google_Calender_ID__c='kripa@getmaxx.in';
            obj1.Client_Email_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
            obj1.Client_ID__c='762657576047-4gg9618bagvckjbrk4t0ju5lej191ai1@developer.gserviceaccount.com';
            insert obj1;
            
                  SaaSFocus_AppointmentController obj = new SaaSFocus_AppointmentController();
                  Test.startTest();
                  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());                  
                  Test.stopTest();    
                 
                Event ev=new Event();
                ev.StartDateTime=Datetime.newInstance(2015, 12, 5, 0, 30, 2);
                ev.Type ='Email';
                ev.EndDateTime=Datetime.newInstance(2015, 12, 5, 1, 30, 2);
                ev.Subject='asadg';
                ev.Description='gfhf';
                ev.whatid =bro.id;
                insert ev;
                System.debug('another2timeEvent2' +ev);
    }   
}