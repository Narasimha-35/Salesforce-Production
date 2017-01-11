/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData = true)
private class ClickEnablePortalUserFromCRMTracker 
{
    private static Lead objLead;
    private static Account objAcc;
    private static Account objAccount;
    static testMethod void myUnitTest() 
    {
        objLead = WLCommonTrackerClass.createLeadForPortal(); 
        List<Click_Community_Setup__c> lstComm = [select id from Click_Community_Setup__c limit 1];
        objAcc = new Account ();
        objAcc = WLCommonTrackerClass.createAccount(objAcc);
        
        objAccount= new Account ();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
        
        ClickEnablePortalUserFromCRM obj = new ClickEnablePortalUserFromCRM();//string strLeadFName,string strLeadLName,string strLeadEmail,string strPhone,string strLeadId
        ClickEnablePortalUserFromCRM.createPortalUserFromCRM('test','test','test@fakeEmail.com','+6123456789',string.valueof(objLead.id));
        ClickEnablePortalUserFromCRM.createPortalUserFromCRMWithAccounts(objAcc.id,'test','test','test1@fakeEmail.com','+6123456789',string.valueof(objLead.id),lstComm[0].Id);
        ClickEnablePortalUserFromCRM.createPortalUserFromCRMWithAccount(objAccount.id,'test','test','test2@fakeEmail.com','+6123456789',string.valueof(objLead.id));
        ClickEnablePortalUserFromCRM.createPortalUserFromCRMOnLead('test','test','test3@fakeEmail.com','+6123456789',string.valueof(objLead.id),ClickCommon.GetRecordTypeId('Lead','Click Refi'));
    }
}