@isTest
private class Generate_Di_XMLTracker
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
    private static List<Funding_Position__c> lstFpos=new List<Funding_Position__c>();
    private static acfVedaApplicantLink__c objVedaApplicantLink;
    private static Veda_Summary__c objVedaSummary;
        
    static testMethod void validate()
    {
        LoadData(); 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForDiXML());
        test.starttest();
        Generate_Di_XML.Generate_Di_XML(objOpportunity.Id);
        test.stoptest(); 
    }
    
    static testMethod void validate1()
    {
        LoadData(); 
        objAccount.acfWhat_is_your_current_payment_type__pc = 'Interest Only';
        update objAccount;
        
        objApplicant.acfLast_2_years_Tax_Return_or_ATO_NOA__c = 'Yes, I\'ve got one of these';
        objApplicant.click_Applicant_Number__c = '2';
        objApplicant.ABN__C = 'test';
        objApplicant.Title__c = 'test';
        objApplicant.acf_Applicant_Name__c = 'test';
        objApplicant.gender__c = 'Male';
        objApplicant.acf_applicant_Marital_Status__c = 'Married';
        objApplicant.acf_applicant_Dependants__c= '1';
        objApplicant.Citizen_ship__c = 'Citizen';
        objApplicant.Address__c = '1 test test';
        objApplicant.acfEmployment_Type__c = 'test';
        objApplicant.acf_How_Long_have_you_been_employed__c = string.valueof(System.now());
        objApplicant.Gst_Registered__C = 'test';
        objApplicant.Gst_Months__C = 'May';
        update objApplicant;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForDiXML());
        test.starttest();
        Generate_Di_XML.Generate_Di_XML(objOpportunity.Id);
        test.stoptest(); 
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
        objAccount.acfCurrent_Loan_Amount__pc = 200000;
        objAccount.acfApproximately_how_much_is_your_house__pc = 4000000;
        objAccount.acfWhat_is_your_current_payment_type__pc = 'Principal and Interest';
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
        
        objVedaSummary = new Veda_Summary__c();
        objVedaSummary.Applicant__c = objApplicant.id;
        objVedaSummary.ApplicantRecId__c = string.valueof(objApplicant.id);
        objVedaSummary.Error__c = '';
        objVedaSummary.Opportunity__c = objOpportunity.id;
        insert objVedaSummary;
        
        objVedaApplicantLink = new acfVedaApplicantLink__c();
        objVedaApplicantLink.Applicant__c = objApplicant.id;
        objVedaApplicantLink.Record_Creation_date__c = System.now();
        objVedaApplicantLink.Veda_Status__c = 'Active';
        objVedaApplicantLink.Veda_Summary__c = objVedaSummary.Id;
        insert objVedaApplicantLink;
        
        Attachment objAttach = new Attachment();
        objAttach.Body = blob.valueof('test');
        objAttach.parentid = objVedaSummary.id;
        objAttach.Name = 'test';
        insert objAttach;
        
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