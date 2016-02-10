@istest(SeeAllData=true)
public class Saasfocus_MercuryIntegrationTracker
{
        static Broker__c objBrk;
        static Opportunity  o;
        static Market__c  m ;
        static State__c  s;
        static Region__c  r;
        static Appointment__c app; 
       static testMethod void Mercuryinti() 
       { 
          loadData(); 
           Test.startTest();
           Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
           Saasfocus_MercuryIntegration mobj=new Saasfocus_MercuryIntegration();
           Test.stopTest();           
       }
    
      static void loadData()
       {
           insertBroker();
           insertAppointment();
           insertCustomSetting();
      
       }

    static void insertCustomSetting()
    {
       /* Allocate_Appointment__c custobj = new Allocate_Appointment__c();
        custobj.Name = 'Phone_Broker';
        custobj.Buffer__c = '15';
        custobj.DayEndTime__c = '20';
        custobj.DayStartTime__c = '8';
        custobj.DurationOfMeeting__c = '30';
        custobj.IntervalOfMeeting__c = '15';
        insert custobj;*/
    }
   
   static void insertBroker()
   {
       
       m = new Market__c();
       m.Name = 'Dash';
       m.Market_Region__c= 'North'; 
       insert m;
       
          
       objBrk = new Broker__c();
       objBrk.name = 'testuser2';
       objBrk.Active_Broker__c = true;
       objBrk.Email__c='testuser1@tpoint.com.au';
       objBrk.MobilePhone__c='9719764989';
       objBrk.Street_Address__c='ABC';
       objBrk.City__c='dehradun';
       objBrk.Primary_Market__c= m.id;
       objBrk.Next_Sync_Token__c='fhsdjf';
       insert objBrk;
       
        
    }
   
   static void insertAppointment()
   {
       o = new Opportunity();
       o.RecordTypeId= '01290000000thgD';
       o.Name = 'nee';
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
       
       m = new Market__c();
       m.Name = 'Dash';
       m.Market_Region__c= 'North'; 
       insert m;
       
       s = new State__c();
       s.Name    = 'sim';
       insert s;
       
       r = new Region__c();
       r.State__c = s.Id ;
       r.Name  = 'North';
       r.Sydney_Timezone_Offset__c =10;
       insert r;
       
       app = new Appointment__c();
       app.RecordTypeId= '01290000000ttUO';
       app.Opportunity__c= o.Id;
       app.Broker__c = objBrk.Id;
       app.Market__c = m.Id;
       app.Region__c = r.Id ;
       app.Appointment_Date_and_Time__c = System.now();
       app.Appointment_Status__c   = 'New';
       app.Appointment_Type__c   = 'Phone Appointment';
       app.Speciality_Skills__c = '';
       app.Street_Address__c = 'abc'; 
       app.State__c = 'Victoria';
       app.City__c  = 'real street';
       app.Postal_Code__c = '6387';
       app.Pre_Sales_Notes__c='jlkasdhakj';
       app.Alternate_Phone__c = '78979878';
       app.Pre_Sales_Notes__c = 'kjbfjkdshfkjds';
       insert app;
 
      }
   }