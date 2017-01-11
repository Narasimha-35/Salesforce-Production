@isTest
public class acfCheckVedaExpiryTracker
{
    private static Lead objLead;
    private static Account objAccount;
    private static Account objpersonAccount;
    private static User objUser;
    private static Opportunity objOpp;
    private static click_Applicant__c objClickApp;
    private static E_Consent__c objE_Consent;
    private static acfVeda__c objVeda;
    
    static testMethod void validate()
  {
         LoadData();
         
         acfVedaApplicantLink__c obj=new acfVedaApplicantLink__c();
         obj.name='10/06/2016Neha Gupta';
         obj.Veda_Status__c='active';
         obj.Record_Creation_date__c=System.today();
         obj.Applicant__c=objClickApp.id;
         insert obj;
        // acfCheckVedaExpiry obj=new acfCheckVedaExpiry ();
         acfCheckVedaExpiry.checkRercord(obj);
         acfCheckVedaExpiry.mapRecords(obj,objClickApp);
         }
           public static void LoadData()
    {
            
        createLead();
        createAccount();
        createPersonAccount();
        createPortalUser();
        createOpportunity();
        createclickApplicant();
         
                
        createVeda();
       
    }
    
     static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommonTrackerClass.createLead(objLead); 
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
      //  objAccount .Gender__pc='Male';
       // objAccount .acfWhat_is_your_postcode__pc='123455';
       // update objAccount ;
        
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
    
    static void createclickApplicant()
    {
         objClickApp = new click_Applicant__c();
         objClickApp = WLCommonTrackerClass.createApplicant(objClickApp,objAccount,objOpp);
         
        
        
        
         
    }    
    
     static void createE_Consent()
    {
         objE_Consent = new E_Consent__c();
         objE_Consent = WLCommonTrackerClass.createEConsent(objClickApp);
         objE_Consent.Applicant__c=objClickApp.id;
         objE_Consent.Consent_Completed__c=true;
         
         update objE_Consent;
    }
    
     static void createVeda()
    {
    objVeda = new acfVeda__c();
    objVeda.name= 'Veda';
    objVeda.EndPoint__c = 'qwerty';
    objVeda.Password__c = 'qwerty';
    objVeda.UserName__c = 'qwerty';
    insert objVeda ;
  
    }
}