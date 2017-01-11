@isTest
public with sharing class TestMercuryService {
    private static Opportunity oppo;
    private static Account acc;
    private static Contact cont;
    private static Income_And_Expense__c income;
    private static click_Applicant__c applicant;
    private static Asset_And_Liability__c asset;
    private static MercuryModel.URLParams urlParam;
    static {
        acc = TestUtilities.createAccount(true);
        insert acc;
        cont = TestUtilities.createContact();
        insert cont;
        oppo = TestUtilities.createOpportunity();
        oppo.accountId = acc.id;
        oppo.Sync_With_Mercury_Success__c =true;
        oppo.Sync_With_Mercury__c =true ;
        //update oppo;
        insert oppo;
        applicant = TestUtilities.createApplicant(acc);
        applicant.clickOpportunity__c =oppo.id;
        insert applicant;
        income = TestUtilities.createIncomeAndExpense();
        income.Applicant__c =applicant.id;
        income.Synk_with_Mercury__c=false;
        insert income;
        asset = TestUtilities.createAssetAndLiability();
        List<RecordType> recordTypeIdList = [SELECT id, name, sobjectType FROM RecordType WHERE sobjectType = 'Asset_And_Liability__c'];
        asset.opportunity__c = oppo.id;
        asset.recordTypeId = recordTypeIdList[0].id;
        asset.account__c = acc.id; 
        insert asset;
        MercuryTestUtilities.setCustomSettings(true);
        MercuryTestUtilities.setEmailTemplateDocument();

        urlParam = new MercuryModel.URLParams();
        urlParam.currentPartnerId = 'P200019';
        urlParam.searchType = 'businessStats';
        urlParam.params = MercuryStaticValue.param2;

        MercuryTestUtilities.setMock(oppo.id, acc.id, urlParam);
    }

     private static testMethod void ValidateData() {
         
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        MercuryService.updateApplication(oppo);
        Test.stopTest();
     }
     
     private static testMethod void ValidateData1() {
         
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        DmlException dml = new DmlException();
        
        list<Exception>  ex = new List<Exception>(); 
        ex.add((Exception)dml);
        MercuryService.MercurySyncException cls = new  MercuryService.MercurySyncException(ex);
        cls.getErrorMessage();
        cls.getExceptions();
        Test.stopTest();
        }
        
         private static testMethod void updateAsset() {
        List<RecordType> recordTypeList = [SELECT id, name, sobjectType FROM RecordType WHERE sobjectType = 'Asset_And_Liability__c'];

        Asset_And_Liability__c aal = TestUtilities.createAssetAndLiability();
        insert aal;
        aal.opportunity__c = oppo.id;
        aal.recordTypeId = recordTypeList[0].id;
        aal.account__c = acc.id;
        update aal;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoginSuccessResponse');
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        MercuryModel.Loan loan = new MercuryModel.Loan(oppo, MercuryStaticValue.ACF_BRANCH_ID);
        MercuryService.updateAssetAndLiability(aal, loan, MercuryStaticValue.ACF_BRANCH_ID);
        Test.stopTest();
    }
      
        private static testMethod void updateIncome() {
        Account acct = TestUtilities.createAccount();
        acct.mercury_People_ID__c = '9c6f5809-08b1-464a-9cc7-71b31903e0aa';
        insert acct;

        Income_And_Expense__c iae = TestUtilities.createIncomeAndExpense();
        insert iae;
        iae.account__c = acct.id;
        iae.amount__c = 1;
        iae.balance__c = 2;
        iae.credit_Limit__c = 3;
        iae.category__c = 'Salary';
        iae.frequency__c = 'Yearly';
        iae.recordTypeId = IncomeRecordType.getInstance().id;
        update iae;

       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoginSuccessResponse');
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        MercuryModel.People peop = new MercuryModel.People(acct, MercuryStaticValue.ACF_BRANCH_ID);
        MercuryService.updateIncomeAndExpense(iae, peop, MercuryStaticValue.ACF_BRANCH_ID);
        Test.stopTest();
    }
  
     
    private static testMethod void testSyncWithMercury4011() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryService.syncWithMercury(oppoId, accountId);
        Test.stopTest();
    }
    
    
    private static testMethod void testSyncWithMercuryjjj4011() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.getLoansFromMercury('', '','',  ins);
        Test.stopTest();
    }
    
    private static testMethod void testSyncWithMercuryjjj40ddd11() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.getSyncBackLoanId(1);
        Test.stopTest();
    }
    
    
    private static testMethod void wwewe() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.getSyncBackLoanId(2);
        Test.stopTest();
    }
    
    private static testMethod void fff() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.getSyncBackLoanId(2);
        Test.stopTest();
    }
    
    private static testMethod void wdfwewe() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.syncBackLoan(2);
        Test.stopTest();
    }
    
    private static testMethod void loanid() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.getLoanPeole('');
        Test.stopTest();
    }
    
    private static testMethod void loanffid() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.getPeople('');
        Test.stopTest();
    }
    
    private static testMethod void loaniddd() {
    
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoanSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String accountId = acc.Id;
        String oppoId = oppo.Id;
        MercuryModel.Params  ins  = new MercuryModel.Params();
        MercuryService.startCleanMercuryOpportunityBatch();
        Test.stopTest();
    }

    // private static testMethod void getLoansFromMercuryTest() {
    //  Test.startTest();
    //  MercuryModel.LoanResponse res = MercuryService.getLoansFromMercury('Opportunity', 'P200019', 'businessStats', MercuryStaticValue.param2);
    //  System.assertEquals(1, res.idList.size());
    //  Test.stopTest();
    // }

    // TODO: can't get rid of _dc
    // private static testMethod void getLoansFromMercuryTest() {
    //  Test.startTest();
    //  MercuryService.getLoansFromMercury('Opportunity', 'P200019', 'businessStats', MercuryStaticValue.param2);
    //  Test.stopTest();
    // }

    private static testMethod void syncWithMercuryTest3() {
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoginSuccessResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        MercuryService.syncWithMercury(oppo.id,acc.id);
        Test.stopTest();
    }

    private static testMethod void getLoanTest() {
        Test.startTest();
        MercuryService.getLoan(oppo.id);
        Test.stopTest();
    }

    // private static testMethod void getSyncBackLoanIdTest() {
    //  Test.startTest();
    //  MercuryService.getSyncBackLoanId
    //  Test.stopTest();
    // }
    //
    // private static testMethod void syncBackLoanTest() {
    //  Test.startTest();
    //  MercuryService.syncBackLoan
    //  Test.stopTest();
    // }

    private static testMethod void testCreateIncomeAndExpense() {
        Account acct = TestUtilities.createAccount();
        acct.mercury_People_ID__c = '9c6f5809-08b1-464a-9cc7-71b31903e0aa';
        insert acct;

        Income_And_Expense__c iae = TestUtilities.createIncomeAndExpense();
        iae.account__c = acct.id;
        iae.amount__c = 1;
        iae.balance__c = 2;
        iae.credit_Limit__c = 3;
        iae.category__c = 'Salary';
        iae.frequency__c = 'Yearly';
        iae.recordTypeId = IncomeRecordType.getInstance().id;
        insert iae;

        Income_And_Expense__c iae2 = TestUtilities.createIncomeAndExpense();
        iae2.account__c = acct.id;
        iae2.amount__c = 1;
        iae2.balance__c = 2;
        iae2.credit_Limit__c = 3;
        iae2.category__c = 'Salary';
        iae2.frequency__c = 'Yearly';
        iae2.recordTypeId = ExpenseRecordType.getInstance().id;
        insert iae2;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoginSuccessResponse');
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        MercuryModel.People peop = new MercuryModel.People(acct, MercuryStaticValue.ACF_BRANCH_ID);
        MercuryService.createIncomeAndExpense(iae, peop, MercuryStaticValue.ACF_BRANCH_ID);
        MercuryService.createIncomeAndExpense(iae2, peop, MercuryStaticValue.ACF_BRANCH_ID);
        Test.stopTest();
    }

    private static testMethod void testCreateAssetAndLiability() {
        List<RecordType> recordTypeList = [SELECT id, name, sobjectType FROM RecordType WHERE sobjectType = 'Asset_And_Liability__c'];

        Asset_And_Liability__c aal = TestUtilities.createAssetAndLiability();
        aal.opportunity__c = oppo.id;
        aal.recordTypeId = recordTypeList[0].id;
        aal.account__c = acc.id;
        insert aal;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MercuryLoginSuccessResponse');
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        MercuryModel.Loan loan = new MercuryModel.Loan(oppo, MercuryStaticValue.ACF_BRANCH_ID);
        MercuryService.createAssetAndLiability(aal, loan, MercuryStaticValue.ACF_BRANCH_ID);
        Test.stopTest();
    }
   

}