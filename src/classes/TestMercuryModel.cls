@isTest
public with sharing class TestMercuryModel {
    static {
        MercuryTestUtilities.setCustomSettings(true);
        MercuryTestUtilities.setEmailTemplateDocument();
    }

    private static testMethod void test() {
        MercuryModel.Partner p = new MercuryModel.Partner();
        p = (MercuryModel.Partner) p.put('name', 'test', MercuryModel.Partner.class);
        System.assertEquals('test', p.get('name'));
        System.assertEquals(2, p.getAttributes().size());
    }

    private static testMethod void testPartner() {
        MercuryModel.Partner p = new MercuryModel.Partner();
        p.uniqueId = 'test';
        p.name = 'test';
    }

    private static testMethod void testPartnerResponse() {
        MercuryModel.Partner p = new MercuryModel.Partner();
        MercuryModel.PartnerResponse pr = new MercuryModel.PartnerResponse();
        pr.success = true;
        pr.partnerList = new List<MercuryModel.Partner>{p};
    }
/*
    private static testMethod void testPeople() {
        MercuryModel.People p = new MercuryModel.People();
        p.uniqueId = null;
        p.company = null;
        p.isDeleted = null;
        p.deletedBy = null;
        p.deletedOn = null;
        p.createdOn = null;
        p.createdBy = null;
        p.isNew = null;
        p.firstName = null;
        p.lastName = null;
        p.middleName = null;
        p.salutation = null;
        p.title = null;
        p.occupation = null;
        p.employer = null;
        p.jobTitle = null;
        p.maritalStatus = null;
        p.driversLicenceNumber = null;
        p.driversLicenceExpiry = null;
        p.driversLicenceState = null;
        p.gender = null;
        p.dateOfBirth = null;
        p.employmentStatus = null;
        p.employmentCommenced = null;
        p.phoneDisplayType1 = null;
        p.phoneDisplayType2 = null;
        p.phoneDisplayType3 = null;
        p.phoneDisplayType4 = null;
        p.addressDisplay = null;
        p.homePhone = null;
        p.businessPhone = null;
        p.mobile = null;
        p.email = null;
        p.personDataType = null;
        p.notes = null;
        p.relationshipManager = null;
        p.annualSalary = null;
        p.contactType = null;
        p.abn = null;
        p.acn = null;
        p.trustName = null;
        p.homeSuburb = null;
        p.numberOfDependents = null;
        p.doNotMail = null;
        p.funambolUsers = null;
        p.markAsPrivate = null;
        p.importDocumentId = null;
        p.partnerName = null;
        p.emailBounced = null;
        p.webPassword = null;
        p.webAccess = null;
        p.relationshipManagerName = null;
        p.fullName = null;
        p.salutationOrFirstName = null;
        

        
        Account acc = TestUtilities.createAccount();
        insert acc;
        Click_Applicant__c app = TestUtilities.createApplicant(acc);
        test.starttest();
         MercuryModel.People p12 = new MercuryModel.People(app , ' ');
         
        HttpRequestResponse  res =  MercuryApiUtilities.getAddress(p12);
        test.stoptest();
    }*/

    private static testMethod void testPersonResponse() {
        MercuryModel.PersonResponse p = new MercuryModel.PersonResponse();
        p.success = true;
        p.people = new MercuryModel.people();
    }

    private static testMethod void testLoan() {
        MercuryModel.Loan l = new MercuryModel.Loan();
        l.uniqueId = null;
        l.company = null;
        l.isDeleted = null;
        l.deletedBy = null;
        l.deletedOn = null;
        l.createdOn = null;
        l.createdBy = null;
        l.isNew = null;
        l.loanName = null;
        l.amount = null;
        l.lender = null;
        l.lenderNameShort = null;
        l.status = null;
        l.agent = null;
        l.personActing = null;
        l.personResponsible = null;
        l.lenderReference = null;
        l.financeDate = null;
        l.expectedSettlementDate = null;
        l.confirmedSettlementDate = null;
        l.leadSourceId = null;
        l.leadSourceDisplay = null;
        l.discount = null;
        l.existingAmount = null;
        l.lmi = null;
        l.settlementDateConfirmed = null;
        l.discountType = null;
        l.loanPersonRelationship = null;
        l.transactionType = null;
        l.notePadText = null;
        l.partnerReference = null;
        l.nextGenId = null;
        l.parentId = null;
        l.workspaceUsers = null;
        l.tranxType = null;
        l.connectiveLodgeId = null;
        l.peResidualAmount = null;
        l.peRepaymentAmount = null;
        l.peEffectiveRate = null;
        l.peInterestRate = null;
        l.peBrokerage = null;
        l.assetDescription = null;
        l.nextAction = null;
        l.loanTerm = null;
        l.metaData = null;
        l.fixedRateExpiry = null;
        l.depositDueDate = null;
        l.vbo = null;
        l.barCodeId = null;
        l.agentName = null;
        l.personActingName = null;
        l.personResponsibleName = null;
        l.defaultPath = null;
        l.partnerName = null;
        l.partnerSharedWithId = null;
        l.partnerSharedWithName = null;
        l.statusLastUpdated = null;
        l.lenderComments = null;
        l.sitRep = null;
        l.campaignId = null;
        l.campaignName = null;
        l.securityValue = null;
        l.aliApplicationId = null;
        l.metlifeApplicationId = null;
        l.interestOnlyExpiry = null;
        
        // code added by prateek
         Account acc = TestUtilities.createAccount();
            insert acc;
            Click_Applicant__c app = TestUtilities.createApplicant(acc);
         MercuryModel.People p = new MercuryModel.People(app  ,  '');
         MercuryModel.getResourceName(p);
           Opportunity opp = new Opportunity ();
          MercuryModel.Loan l2 = new MercuryModel.Loan(opp ,  '' );
          Mercury_Opportunity__c  jcjc = new Mercury_Opportunity__c();
          insert jcjc;
         // MercuryModel.Loan l3 = new MercuryModel.Loan(jcjc  );
        l.uniqueId = null;
    }

    private static testMethod void testLoanResponse() {
        MercuryModel.LoanResponse lr = new MercuryModel.LoanResponse();
        lr.success = true;
        lr.total = 0;
        lr.loans = new List<MercuryModel.Loan>{new MercuryModel.Loan()};
        system.debug(lr.idList);
    }

    private static testMethod void testURLParams() {
        MercuryModel.URLParams u = new MercuryModel.URLParams();
        u.toString();
    }

    private static testMethod void testParams() {
        MercuryModel.Params p = new MercuryModel.Params();
    }

    private static testMethod void testConstructPeopleFromAcc() {
        Account acc = TestUtilities.createAccount();
        insert acc;
        MercuryModel.People p = new MercuryModel.People(acc, '');
        System.assertEquals(acc.id, p.uniqueId);
        System.assertEquals(MercuryStaticValue.ACF_BRANCH_ID, p.company);
    }

    private static testMethod void testConstructPeopleFromApp() {
        Account acc = TestUtilities.createAccount();
        insert acc;
        Click_Applicant__c app = TestUtilities.createApplicant(acc);
            MercuryModel.People  obj = new MercuryModel.People();
            obj.convertToAccount();
            obj.mergeToAccount(acc);
    }
    
    private static testMethod void testIncome() 
    {
     Account acc = TestUtilities.createAccount();
        insert acc;
            Income_And_Expense__c iae  = new Income_And_Expense__c();
            MercuryModel.People p = new MercuryModel.People(acc, '');
            MercuryModel.Income Income = new MercuryModel.Income(iae  ,p,'');
       
        
    }
    
    private static testMethod void testExpense() 
    {
     Account acc = TestUtilities.createAccount();
        insert acc;
            Income_And_Expense__c iae  = new Income_And_Expense__c();
            MercuryModel.People p = new MercuryModel.People(acc, '');
            MercuryModel.Expense Income = new MercuryModel.Expense(iae  ,p,'');
       
        
    }
    
   
    private static testMethod void testIncjome() 
    {
            Income_And_Expense__c iae  = new Income_And_Expense__c();
            
            Account acc = TestUtilities.createAccount();
                insert acc;
            MercuryModel.Address Income = new MercuryModel.Address(acc,'');
            MercuryModel.People p = new MercuryModel.People(acc, '');
       
        
    }
    
    private static testMethod void testAsset() 
    {
           account     objAccount = new account();
    objAccount = WLCommonTrackerClass.createAccount(objAccount);
   Asset_And_Liability__c  objAssetandLiablility = new Asset_And_Liability__c();
    objAssetandLiablility= WLCommonTrackerClass.createAssetandLiablility(objAssetandLiablility,objAccount);
            
            Account acc = TestUtilities.createAccount();
                insert acc;
            MercuryModel.Loan Loan = new MercuryModel.Loan();
            MercuryModel.Asset p = new MercuryModel.Asset(objAssetandLiablility, Loan ,'');
       
        
    }
    
    

}