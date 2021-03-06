@isTest(SeeAllData=true)
public class ChangeBrokerTest {
    static Broker__c objBrk;
    static Opportunity o;
    static Market__c m ;
    static State__c s;
    static Region__c r;
    static Appointment__c app;

    static testMethod void TestChangeAppointment() {
        loadData();
        Test.startTest();
        Allocate_Appointment__c custobj = new Allocate_Appointment__c(Name = 'Phone_Broker');
        ApexPages.currentPage().getParameters().put('id',app.id);
        ChangeBrokerController obj = new ChangeBrokerController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        obj.save2();
        obj.save3();

        obj.getBroker();
        obj.brokerId = objBrk.id;

        System.assertNotEquals(objBrk,null);

        //obj.save();
        obj.Cancel();
        Test.stopTest();
    }

    static testMethod void TestCallouts() {
    }

    static void loadData() {
        insertBroker();
        insertAppointment();
        insertCustomSetting();
    }

    static void insertCustomSetting() {
    }

    static void insertBroker() {
        m = new Market__c();
        m.Name = 'Dash';
        m.Market_Region__c= 'North';
        insert m;

        objBrk = new Broker__c();
        objBrk.name = 'testuser2';
        objBrk.Active_Broker__c = true;
        objBrk.Email__c = UserInfo.getUserEmail();
        objBrk.MobilePhone__c = '9719764989';
        objBrk.Street_Address__c = 'ABC';
        objBrk.City__c = 'dehradun';
        objBrk.Primary_Market__c = m.id;
        objBrk.Next_Sync_Token__c ='fhsdjf';
        insert objBrk;
    }

    static void insertAppointment() {
        o = new Opportunity();
        o.RecordTypeId = '01290000000thgD';
        o.Name = 'nee';
        o.StageName = 'Appointed';
        o.CloseDate = System.Today();
        o.Transaction_Type__c = 'Refinance';
        o.Current_Lender__c = 'AMP';
        o.Current_Loan_Value__c = 8888;
        o.Current_Loan_Type__c = 'Construction';
        o.Personal_Loan_Balance__c = 7879;
        o.Credit_Card_Balance__c = 8973;
        o.Car_Loan_Balance__c  = 8748;
        insert o;

        s = new State__c();
        s.Name = 'sim';
        insert s;

        r = new Region__c();
        r.State__c = s.Id;
        r.Name = 'North';
        r.Sydney_Timezone_Offset__c = 10;
        r.timeZone__c = 'Perth/Australia';
        insert r;

        m = new Market__c();
        m.Name = 'Dash';
        m.Market_Region__c = 'North';
        m.region__c = r.id;
        insert m;

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