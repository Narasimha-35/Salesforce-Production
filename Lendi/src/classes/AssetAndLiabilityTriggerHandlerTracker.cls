@isTest
private class AssetAndLiabilityTriggerHandlerTracker
{
    private static Asset_And_Liability__c objAssetLiab;
    private static Account objAccount;
    private static Account objAccount1;
    private static Funding_Position__c objFundingpos;
    private static Opportunity objOpportunity;
    private static Funding_Position_Detail__c objFundingPosDetail;
    private static User objUser;
    private static State__c objState;
    private static Lead objLead;
    private static Product2 objPro;
    private static OpportunityLineItem oppLine;
    private static PricebookEntry pbEntry ;
    private static Opportunity objOpp;
    private static click_Applicant__c objApplicant;
    private static contact objContact;
    private static Income_And_Expense__c objIncomeandexpense;
    static List<Funding_Position__c> lstFpos=new List<Funding_Position__c>();
        
    static testMethod void validate()
    {
        LoadData();
        
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 
        
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj = new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
    
    static testMethod void validate1()
    {
        LoadData();
        
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Asset Real Estate';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.State__c='NSW';
        objAssetLiab.To_Be_Purchased__c=false;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
        mapobj1.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj1);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj1);
        Test.stopTest();
    }
    static testMethod void validate2()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        fundingobj.Detail_Type__c='Transfer Fee';
        insert fundingobj;

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Asset Real Estate';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c =null;
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.State__c='NSW';
        objAssetLiab.To_Be_Purchased__c=false;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
        mapobj1.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj1);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj1);
        Test.stopTest();
    }
    
    static testMethod void validate3()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=false;
        objAssetLiab.name='Liability Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        insert objAssetLiab;
        Test.stopTest();
    }
         
    static testMethod void validate4()
    {
        LoadData();
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Repayments__c=33;
        objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
        objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.Repayments__c=37;
        objAssetLiab.Current_Balance__c=987;

        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj; 
        update objAssetLiab;
        Test.stopTest();
    }
        
     static testMethod void validate5()
    {
        LoadData();
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=false;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
        objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);

        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos;   
        Test.stopTest();           
    }
        
    static testMethod void validate5a()
    {      
        LoadData();
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=false;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.Repayment_Frequency__c='Monthly';
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=88;
        objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
        objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);

        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos;   
        Test.stopTest();     
    }
        
     static testMethod void validate5b()
    {
        LoadData();
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=false;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.Repayment_Frequency__c='Anually';
        objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
        objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);

        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos;    
        Test.stopTest();  
    }
        
     static testMethod void validate5c()
    {
        LoadData();
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=false;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.Repayment_Frequency__c='Fortnightly';
        objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
        objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);

        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 
        Test.stopTest();            
    }
        
    static testMethod void validate6()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Asset Real Estate';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.State__c='NSW';
        objAssetLiab.To_Be_Purchased__c=false;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
        mapobj1.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj1);
        obj.insertAssetEstateSingleRecords(objAssetLiab,mapobj1,66);
        Test.stopTest();  
    }
        
    static testMethod void validate7()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Monthly';
        insert objAssetLiab;
        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validate7a()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Anually';
        insert objAssetLiab;
        
        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validate7b()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Fortnightly';
        insert objAssetLiab;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
            
    static testMethod void validate8()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validate8a()
    {
        LoadData();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.To_Be_Purchased__c=true; 
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validate8b()
    {
        LoadData();
        Test.startTest();
        Opportunity objOppo = new opportunity();
        objOppo.AccountId =objUser.AccountId ;
        objOppo.recordtypeid= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lendi').getRecordTypeId();
        objOppo.name = 'test';
        objOppo.Stagename = 'Application Taken';
        objOppo.CloseDate = System.today();
        objOppo.acfAsset_House_Worth__c = 200000;
        insert objOppo;
        
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 
        
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOppo.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.To_Be_Purchased__c=true; 
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Expense').getRecordTypeId();
        objIncomeandexpense = new Income_And_Expense__c();
        objIncomeandexpense.recordTypeId = IncomeRecordTypeId;
        objIncomeandexpense.Amount__c = 45;
        objIncomeandexpense.Category__c = 'Full Time - PAYG';
        objIncomeandexpense.Applicant__c = objApplicant.Id;
        objIncomeandexpense.Asset_And_Liability__c = objAssetLiab.Id;
        insert objIncomeandexpense;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
    
    static testMethod void validate9a()
    {
        
      /*  Test.startTest(); 
        LoadData();   
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 
        
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity .id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.To_Be_Purchased__c=true; 
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Income').getRecordTypeId();
        objIncomeandexpense = new Income_And_Expense__c();
        objIncomeandexpense.recordTypeId = IncomeRecordTypeId;
        objIncomeandexpense.Amount__c = 45;
        objIncomeandexpense.Category__c = 'Full Time - PAYG';
        //objIncomeandexpense.Applicant__c = objApplicant.Id;
        objIncomeandexpense.Asset_And_Liability__c = objAssetLiab.Id;
        insert objIncomeandexpense;
        
        Asset_And_Liability__c objAssetLiabs=new Asset_And_Liability__c();
        objAssetLiabs.Clearing_From_This_Loan__c=true;
        objAssetLiabs.name='Liability';
        objAssetLiabs.Opportunity__c=objOpportunity .id;
        objAssetLiabs.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiabs.Account__c = objAccount.Id;
        objAssetLiabs.Repayments__c=09876;
        objAssetLiabs.Current_Balance__c=99;
        objAssetLiabs.Limit__c=55;
        objAssetLiabs.Repayment_Frequency__c='Weekly';
        insert objAssetLiabs;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
        */
    }
    
    static testMethod void validateLenditest()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        objAssetLiab.Limit__c=59;
        update objAssetLiab;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj = new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
    
    static testMethod void validateLenditest1()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Asset Real Estate';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.State__c='NSW';
        objAssetLiab.To_Be_Purchased__c=false;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
        mapobj1.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj1);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj1);
        Test.stopTest();
    }
    
    static testMethod void validateLenditest2()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        fundingobj.Detail_Type__c='Transfer Fee';
        insert fundingobj;

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Asset Real Estate';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c =null;
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.State__c='NSW';
        objAssetLiab.To_Be_Purchased__c=false;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
        mapobj1.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj1);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj1);
        Test.stopTest();
    }
    
    static testMethod void validateLenditest3()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=false;
        objAssetLiab.name='Liability Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        insert objAssetLiab;
        Test.stopTest();
    }
         
    static testMethod void validateLenditest4()
    {
        LoadDatatest();
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Repayments__c=33;
        objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);
        objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.Repayments__c=37;
        objAssetLiab.Current_Balance__c=987;

        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj; 
        update objAssetLiab;
        Test.stopTest();
    }
        
     static testMethod void validateLenditest5()
    {
        LoadDatatest();
        Test.startTest();
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=false;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        objAssetLiab.recordtypeid = Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();  
        objAssetLiab=WLCommonTrackerClass.createAssetandLiablility(objAssetLiab,objAccount);

        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos;   
        Test.stopTest();           
    }
    
    static testMethod void validateLenditest6()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Asset Real Estate';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.State__c='NSW';
        objAssetLiab.To_Be_Purchased__c=false;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        Map<Id,Funding_Position__c> mapobj1=new Map<Id,Funding_Position__c> ();
        mapobj1.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj1);
        obj.insertAssetEstateSingleRecords(objAssetLiab,mapobj1,66);
        Test.stopTest();
    }
        
    static testMethod void validateLenditest7()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Monthly';
        insert objAssetLiab;
        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validateLenditest7a()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Anually';
        insert objAssetLiab;
        
        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validateLenditest7b()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liabilities Mortgage Loan';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Fortnightly';
        insert objAssetLiab;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
            
    static testMethod void validateLenditest8()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validateLenditest8a()
    {
        LoadDatatest();
        Test.startTest();
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 

        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOpportunity.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Used_as_Security__c = true;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.To_Be_Purchased__c=true; 
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
        
    static testMethod void validateLenditest8b()
    {
        LoadDatatest();
        Test.startTest();
        Opportunity objOppo = new opportunity();
        objOppo.AccountId =objUser.AccountId ;
        objOppo.recordtypeid= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lendi').getRecordTypeId();
        objOppo.name = 'test';
        objOppo.Stagename = 'Application Taken';
        objOppo.CloseDate = System.today();
        objOppo.acfAsset_House_Worth__c = 200000;
        insert objOppo;
        
        objFundingpos=new Funding_Position__c ();
        objFundingpos.Account__c=objAccount.id;
        objFundingPos.Opportunity__c = objOpportunity.id;
        insert objFundingpos; 
        
        objAssetLiab=new Asset_And_Liability__c();
        objAssetLiab.Clearing_From_This_Loan__c=true;
        objAssetLiab.name='Liability';
        objAssetLiab.Opportunity__c=objOppo.id;
        objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();    
        objAssetLiab.Account__c = objAccount.Id;
        objAssetLiab.Value__c = 100000;
        objAssetLiab.Primary_Purpose__c ='Owner Occupied';
        objAssetLiab.Repayments__c=09876;
        objAssetLiab.Current_Balance__c=99;
        objAssetLiab.Limit__c=55;
        objAssetLiab.To_Be_Purchased__c=true; 
        objAssetLiab.Repayment_Frequency__c='Weekly';
        insert objAssetLiab;
        
        Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Expense').getRecordTypeId();
        objIncomeandexpense = new Income_And_Expense__c();
        objIncomeandexpense.recordTypeId = IncomeRecordTypeId;
        objIncomeandexpense.Amount__c = 45;
        objIncomeandexpense.Category__c = 'Full Time - PAYG';
        objIncomeandexpense.Applicant__c = objApplicant.Id;
        objIncomeandexpense.Asset_And_Liability__c = objAssetLiab.Id;
        insert objIncomeandexpense;
        
        Funding_Position_Detail__c fundingobj=new Funding_Position_Detail__c();
        fundingobj.name='test';
        fundingobj.Detail_Type__c='Potential Accrued Interest';
        fundingobj.Asset_And_Liability__c=objAssetLiab.id;
        fundingobj.Amount__c=67;
        fundingobj.Funding_Position__c=objFundingpos.id;
        insert fundingobj;

        Map<Id,Funding_Position__c> mapobj=new Map<Id,Funding_Position__c> ();
        mapobj.put(objAssetLiab.Account__c ,objFundingpos);

        AssetAndLiabilityTriggerHandler obj=new AssetAndLiabilityTriggerHandler();
        obj.insertFPLiabilityOtherRecords(objAssetLiab,mapobj);
        obj.insertFPAssetEstateRecords(objAssetLiab,mapobj);
        Test.stopTest();
    }
    
    static void LoadData()
    {
        ACFSwitch__c acfswitch = new ACFSwitch__c();
        acfswitch.Asset_And_Liability_Switch__c = true;
        insert acfswitch;
        
        CoreLogic__c objcore=new CoreLogic__c();
        objcore.name='CoreLogic';
        objcore.UserName__c='test';
        objcore.password__c='AusCred4321';
        objcore.EndPoint__c='https://access-api.corelogic.asia';
        objcore.AvmEndpoint__c='test';
        objcore.ClientID__c='test';
        objcore.ClientSecret__c='test';
        objcore.TokenEndPoint__c='test';
        objcore.SearchApiEndPoint__c='test';
        insert objcore;

        objState=new State__c();
        objState.name='test';
        insert objState;

        objAccount1=new account();
        objAccount1=WLCommonTrackerClass.createAccount(objAccount1);

        objLead=new Lead();
        objLead.acf_partner_account__c=objAccount1.id;
        objLead.acfWhat_is_your_postcode__c='testinggg';
        objLead=WLCommonTrackerClass.createLead(objLead);

        objAccount=new account();
        objAccount=WLCommonTrackerClass.createAccount(objAccount);

        objContact=new contact();
        objContact=WLCommonTrackerClass.createContact(objContact,objAccount);

        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);

        objOpportunity = new Opportunity();
        objOpportunity.acfLegal_Fees__c=88;
        objOpportunity.clickEstablishment_Fee__c=99;
        objOpportunity.clickMortgage_Risk_Fee__c=888;
        objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
        
        objApplicant = new click_Applicant__c();
        objApplicant = WLCommonTrackerClass.createApplicant(objApplicant,objAccount,objOpportunity);
        
        objPro=new product2();
        objPro=WLCommonTrackerClass.createProduct(objPro);

        pbEntry = new PriceBookEntry();
        pbEntry.UnitPrice = 300;
        pbEntry.PriceBook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = objPro.Id;
        pbEntry.IsActive = true;
        insert pbEntry ;

        oppLine = new OpportunityLineItem();
        oppLine.pricebookentryid=pbEntry.Id;
        oppLine.TotalPrice=2000;
        oppLine.Quantity = 2;
        oppLine.lender__c='test';
        oppLine.OpportunityID = objOpportunity.Id;
        insert oppLine;

    }
    
    static void LoadDatatest()
    {
        ACFSwitch__c acfswitch = new ACFSwitch__c();
        acfswitch.Asset_And_Liability_Switch__c = true;
        insert acfswitch;
        
        CoreLogic__c objcore=new CoreLogic__c();
        objcore.name='CoreLogic';
        objcore.UserName__c='test';
        objcore.password__c='AusCred4321';
        objcore.EndPoint__c='https://access-api.corelogic.asia';
        objcore.AvmEndpoint__c='test';
        objcore.ClientID__c='test';
        objcore.ClientSecret__c='test';
        objcore.TokenEndPoint__c='test';
        objcore.SearchApiEndPoint__c='test';
        insert objcore;

        objState=new State__c();
        objState.name='test';
        insert objState;

        objAccount1=new account();
        objAccount1=WLCommonTrackerClass.createAccount(objAccount1);

        objLead=new Lead();
        objLead.acf_partner_account__c=objAccount1.id;
        objLead.acfWhat_is_your_postcode__c='testinggg';
        objLead=WLCommonTrackerClass.createLead(objLead);

        objAccount=new account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lendi').getRecordTypeId();
        objAccount=WLCommonTrackerClass.createAccount(objAccount);

        objContact=new contact();
        objContact=WLCommonTrackerClass.createContact(objContact,objAccount);

        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);

        objOpportunity = new Opportunity();
        objOpportunity.acfLegal_Fees__c=88;
        objOpportunity.clickEstablishment_Fee__c=99;
        objOpportunity.clickMortgage_Risk_Fee__c=888;
        objOpportunity = WLCommonTrackerClass.createOpportunity1(objOpportunity,objAccount);
        objOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lendi').getRecordTypeId();
        update objOpportunity;
        objApplicant = new click_Applicant__c();
        objApplicant = WLCommonTrackerClass.createApplicant(objApplicant,objAccount,objOpportunity);
        
        objPro=new product2();
        objPro=WLCommonTrackerClass.createProduct(objPro);

        pbEntry = new PriceBookEntry();
        pbEntry.UnitPrice = 300;
        pbEntry.PriceBook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = objPro.Id;
        pbEntry.IsActive = true;
        insert pbEntry ;

        oppLine = new OpportunityLineItem();
        oppLine.pricebookentryid=pbEntry.Id;
        oppLine.TotalPrice=2000;
        oppLine.Quantity = 2;
        oppLine.lender__c='test';
        oppLine.OpportunityID = objOpportunity.Id;
        insert oppLine;
    }
}