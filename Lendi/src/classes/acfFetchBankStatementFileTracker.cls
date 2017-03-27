@isTest
public class acfFetchBankStatementFileTracker
{
public static  Account objacc;
static private User objUser1;  
private static Opportunity objOpportunity;
public static Document_Master__c ObjDocument; 
public static Required_Document__c objReqDoc;
    private static testMethod void validate()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerators2());
        acfFetchBankStatementFile obj =new acfFetchBankStatementFile();
        test.starttest();
        acfFetchBankStatementFile.BankStatementFetchFile('test','test','bankName','https://test.bankstatements','ZECRGOWFWVUOLELF4HF','');
        test.stoptest();
        
    }
}