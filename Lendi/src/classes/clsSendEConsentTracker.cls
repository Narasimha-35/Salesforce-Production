@isTest
public class clsSendEConsentTracker
{

private static User objUser;
private static Account objpersonAccount;
private static Opportunity objOpp;
private static Lead objLead;
private static Click_Community_Setup__c objclcmm;
private static Required_Document__c objre;
private static Document_Master__c objmas;
 private static E_Consent__c  objEcon;
  private static acfBank_Detail__c objBank ;
 private static click_Applicant__c objclickappl;


    public static testMethod void validate1()
    {
    loaddata();
    string mobileMessage = '';
    objclcmm.Click_Page_Prefix__c = 'ACF';
    update objclcmm;
    clsSendEConsent clsobj = new clsSendEConsent();
    clsSendEConsent.SendEonsent(objEcon.id);
    clsSendEConsent.sendEconsentEmailSMS(objclickappl.id,objclcmm.id);
    clsSendEConsent.SendEmail(objBank.id,objclickappl.id,objre.id,objEcon.id,objclcmm.id);
    
    }
    
     public static void loaddata()
    {
        createclickCommunitySetup();
        createBankDetail();
        createLead();
        createPersonAccount();
        createPortalUser();
        createOpportunity();
        createmasterdoc();
        createrequireddoc();
        createclickApplicant();
        createEconsent();
     }   
    
    static void createclickApplicant()
    {
         objclickappl=new click_Applicant__c();
         objclickappl= WLCommonTrackerClass.createApplicant(objclickappl,objpersonAccount,objOpp);
    }
    
    static void createEconsent()
    {
        objEcon =new E_Consent__c();
        objEcon = WLCommonTrackerClass.createEconsent(objclickappl); 
    }
    
     static void createclickCommunitySetup() 
    {
        objclcmm= new Click_Community_Setup__c();
         objclcmm= WLCommonTrackerClass.createcommunitysetup();
        objclcmm= ClickCommon.getCommunitySetup('');
        system.debug('setup1234'+objclcmm);
    }
    
     static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead); 
    }
    
    static void createPersonAccount()
    {
        objpersonAccount= new Account();
        objpersonAccount=WLCommonTrackerClass.CreatePersonAccount('Fname','LName','strPhone','strLead12Email@gmail.com',objLead.Id);
    }
    
    static void createPortalUser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
    }
    
    static void createOpportunity()
    {
        objOpp= new Opportunity();
        objOpp.AccountId =objuser.AccountId;
        objOpp.name = 'test';
        objOpp.Stagename = 'Settlement';
        objOpp=WLCommonTrackerClass.createOpportunity(objOpp,objUser);
    }
    
    static void createrequireddoc()
    {
        objre= new Required_Document__c();
        objre= WLCommonTrackerClass.createRequiredDocument(objre,objmas,objOpp);
        objre.Lead__c = objLead .id;
       update objre;
    }
    
    static void createBankDetail()
    {
        objBank = new acfBank_Detail__c();
        objBank =  WLCommonTrackerClass.createBankDetail();
    }
    
     static void createmasterdoc()
    {
        objmas= new Document_Master__c(); 
        objmas= WLCommonTrackerClass.createDocumentMaster(objmas);
    }
    
}