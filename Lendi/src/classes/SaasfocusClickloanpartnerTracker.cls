@isTest(SeeAllData = false)
private class SaasfocusClickloanpartnerTracker 
{
    private static Account objAccount1;
    private static Opportunity objOpportunity1;
    private static Account objAccount2;
    private static Opportunity objOpportunity2;
    private static Account objAccount3;
    private static Opportunity objOpportunity3;
    private static User objUser;
    private static Contact objContact;
    static Broker__c objBrk;
    static Opportunity  o;
    static Market__c  m ;
    static State__c  s;
    static Region__c  r;
    static Appointment__c app;
    
    static testMethod void validate() 
    {
       
       
        LoadData();
        Saasfocus_ClickLoanPartnerController obj=new Saasfocus_ClickLoanPartnerController();
        Saasfocus_ClickLoanPartnerController.PageValues cobj=new Saasfocus_ClickLoanPartnerController.PageValues();
        cobj.name=objAccount1.name;
        cobj.AccId=objaccount1.id;
        cobj.opprecordtype='Click Refi';
        cobj.address='Australia';
        cobj.CurrentLender='WBA';
        cobj.CurrentLoanSize=2000;
        cobj.TransactionType='New purchase';
        cobj.lastappointment=system.now();
        cobj.opportunitystatus='New purchase';
        cobj.type='pending';
        cobj.transtypeoptn='New purchase';
        obj.divchk=false;
        obj.cmpLnType='New';
        obj.cmpAccid=objaccount1.id;
        obj.opptype='Settled';
        obj.getselectlist();
        obj.getPageval();
        obj.opptype='Settled';
        obj.getselectlist();
        obj.getPageval();
        obj.opptype='Dashboard';
        obj.getselectlist();
        obj.getPageval();
        obj.opptype='Approved';
        obj.getselectlist();
        obj.getPageval();
        obj.opptype='submitted';
        obj.getselectlist();
        obj.getPageval(); 
        obj.opptype=null;
        obj.getPageval(); 
        obj.oppoid=o.id; 
        
        obj.startclickloan();
       
        account acobj=new Account();
        acobj.PersonEmail='laxman.singh@saasfocus.com';
        acobj.Lastname='testacc';
        acobj.PersonMobilePhone='1234567890';
        
        obj.accobj=acobj;
         obj.Lastname='test';
        obj.mobile='1234567890';
       o = new Opportunity();
       //o.RecordTypeId= '01290000000thgD';
       //o.accountid=objaccount1.id;
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
       o.CurrentAssignedBroker__c=objbrk.id;
      // insert o;
        
        obj.oppobj=o;
        MortgageExpert__c   obj2 = new MortgageExpert__c();
        obj2.name='Click_David Hyman';
        obj2.User_ID__c=userinfo.getuserId();
        insert obj2;   
        obj.createAccount();
        obj.detail=1;
        obj.aid=objAccount1.id;
        obj.showDetails();
        
 
    }
    
    private static void LoadData()
    {
        createAccount();
        insertBroker();
        insertAppointment();
        //insertCustomSetting();
        //createContact();
        //createuser();
        //createOpportunity();
    }
    
    
    
    static void createAccount()
    {
        objAccount1 = new Account();
        objAccount1 = acfCommontrackerClass.createAccount(objAccount1);
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
       objBrk.Email__c='laxman.singh@saasfocus.com';
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
       //o.RecordTypeId= '01290000000thgD';
       o.accountid=objaccount1.id;
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
       o.CurrentAssignedBroker__c=objbrk.id;
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