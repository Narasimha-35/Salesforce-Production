@isTest
public with sharing class TestCreateVedaClass {
    private static Opportunity oppo;
    private static Account acc;
    private static Contact cont;
    private static acfVedaApplicantLink__c vedaApp ;
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
        
        insert oppo;
        applicant = TestUtilities.createApplicant(acc);
        applicant.clickOpportunity__c =oppo.id;
        applicant.acf_applicant_DOB__c = '07/08/1982';
        applicant.Last_name__C = 'test';
        applicant.first_name__C = 'test';
        insert applicant;
        income = TestUtilities.createIncomeAndExpense();
        income.Applicant__c =applicant.id;
        income.Synk_with_Mercury__c=false;
        insert income;
       
        vedaApp = new acfVedaApplicantLink__c();
        vedaApp.Name = '07/08/1982test test';
        vedaApp.Veda_Status__c = 'Active';
        vedaApp.Applicant__c = applicant.id;
        insert vedaApp ;
        
        asset = TestUtilities.createAssetAndLiability();
        List<RecordType> recordTypeIdList = [SELECT id, name, sobjectType FROM RecordType WHERE sobjectType = 'Asset_And_Liability__c'];
        asset.opportunity__c = oppo.id;
        asset.recordTypeId = recordTypeIdList[0].id;
        asset.account__c = acc.id; 
        insert asset;
  
    }

     private static testMethod void ValidateData() {
         CreateVedaClass.createVedaApplicantLink(applicant.id);
         CreateVedaClass.callVedaApi(applicant);
     }
     
     private static testMethod void ValidateData1() {
        vedaApp.Veda_Status__c = 'InActive';
        update vedaApp;
         CreateVedaClass.createVedaApplicantLink(applicant.id);
         CreateVedaClass.callVedaApi(applicant);
     }
}