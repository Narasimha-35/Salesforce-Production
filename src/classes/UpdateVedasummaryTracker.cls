@isTest(seeAllData=false)

private class UpdateVedasummaryTracker {
    private static Lead objLead;
    private static User objUser;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static click_Applicant__c objclickappl;
    private static List<id> lstclickappl;
   
    static testMethod void Validate1()
    {
        Loaddata(); 
        Test.startTest();
        lstclickappl = new List<id>();
        lstclickappl.add(objclickappl.id);
        UpdateVedasummary c = new UpdateVedasummary(lstclickappl);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVeda());
        Database.executeBatch(c);
        Test.stopTest();
    }
    
    static testMethod void Validate2()
    {
        Loaddata1(); 
        Test.startTest();
        lstclickappl = new List<id>();
        lstclickappl.add(objclickappl.id);
        UpdateVedasummary c = new UpdateVedasummary(lstclickappl);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVeda());
        Database.executeBatch(c);
        Test.stopTest();
    }
 
 
    public static void Loaddata()
    {
        acfVeda__c objvedas = new acfVeda__c();
        objvedas.Name = 'Veda';
        objvedas.EndPoint__c = 'https://vedaxml.com/sys2/soap11/vedascore-apply-v2-0';
        objvedas.Password__c = 'U4YEb8cJXj';
        objvedas.UserName__c = 'AChrC1aMa4';
        insert objvedas;
        
        VedaRequest__c objVeda = new VedaRequest__c();
        objVeda.Name = 'Request';
        objVeda.account_type_code__c = 'RM'; 
        objVeda.enquiry_client_reference__c = 'Test1';
        objVeda.operator_id__c = 'I1N3';
        objVeda.operator_name__c = 'John Doe';
        objVeda.Permissiontypecode__c = 'XY';
        objVeda.Product_data_level_code__c = 'C';
        objVeda.scorecard_id__c = 'VSA_2.0_XY_CR,VSA_2.0_XY_NR'; 
        insert objVeda;
        
        createAccount();
        createuser();
        createOpportunity();
        createclickApplicant();       
    }
    
    public static void Loaddata1()
    {
        acfVeda__c objvedas = new acfVeda__c();
        objvedas.Name = 'Veda';
        objvedas.EndPoint__c = 'https://vedaxml.com/sys2/soap11/vedascore-apply-v2-0';
        objvedas.Password__c = 'U4YEb8cJXj';
        objvedas.UserName__c = 'AChrC1aMa4';
        insert objvedas;
        
        VedaRequest__c objVeda = new VedaRequest__c();
        objVeda.Name = 'Request';
        objVeda.account_type_code__c = 'RM'; 
        objVeda.enquiry_client_reference__c = 'Test1';
        objVeda.operator_id__c = 'I1N3';
        objVeda.operator_name__c = 'John Doe';
        objVeda.Permissiontypecode__c = 'XY';
        objVeda.Product_data_level_code__c = 'C';
        objVeda.scorecard_id__c = 'VSA_2.0_XY_CR,VSA_2.0_XY_NR'; 
        insert objVeda;
        
        createAccount1();
        createuser();
        createOpportunity();
        createclickApplicant1();       
    }
 
    static void createAccount()
    {
       objAccount = new Account();
       objAccount.Gender__pc = 'Male';  
       objAccount.acfWhat_is_your_postcode__pc = '12334';
       objAccount =  WLCommonTrackerClass.createAccount(objAccount);
    }
    
    static void createAccount1()
    {
       objAccount = new Account();
       objAccount.Gender__pc = 'Male';  
       objAccount =  WLCommonTrackerClass.createAccount(objAccount);
    }
 
     static void createuser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
 
    static void createOpportunity()
    {
        list<Account> lstAccount = [select id from Account where personContactId =: objUser.ContactId limit 1];
        objOpportunity = new Opportunity();
        objOpportunity.AccountId =lstAccount[0].id;
        objOpportunity.acfBankdetailStatus__c = 'Skipped';
        objOpportunity =  WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
    static void createclickApplicant()
    {
        objclickappl=new click_Applicant__c();       
        objclickappl= WLCommonTrackerClass.createApplicant(objclickappl,objaccount,objOpportunity);
        objclickappl.acf_applicant_DOB__c = string.valueof(System.now());
        objclickappl.acf_Applicant_Name__c = 'test';
        objclickappl.acfRelationship_code__c = '2'; 
        objclickappl.Gender__c = 'Male';
        update objclickappl;
    }
    
    static void createclickApplicant1()
    {
        objclickappl=new click_Applicant__c();       
        objclickappl= WLCommonTrackerClass.createApplicant(objclickappl,objaccount,objOpportunity);
    }
 }