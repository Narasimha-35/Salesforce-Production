@isTest

public class EConsentTriggerHandlerTracker
{
    private static Lead objLead;
    private static Account objAccount;
    //private static Account objpersonAccount;
    private static User objUser;
    private static Document_Master__c objDocumentMaster;
    private static Opportunity objOpportunity;
    private static click_Applicant__c objApplicant;
    private static E_Consent__c objEConsent ;
    private static acfVeda__c objVeda;
    
    public static testMethod void validate1()
    {
         loadData();
         objApplicant.acf_applicant_Employer_Name__c=null;
         objApplicant.acfRelationship_code__c=null;
         update objApplicant;
         acfVedaApplicantLink__c obj=new acfVedaApplicantLink__c();
         obj.name='10/06/2016Neha Gupta';
         obj.Veda_Status__c='active';
         obj.Applicant__c=objApplicant.id;
        // insert obj;
        
           objEConsent = new E_Consent__c();
           objEconsent.Applicant__c = objApplicant.id;
           objEconsent.Consent_Completed__c = true;
           objEconsent.Consent_IP__c = '192.168.0.1';
           objEconsent.Consent_Method__c = 'trigger';
           objEconsent.Consent_Time_and_Date__c = system.now();
           insert objEconsent;
           
           objEConsent.Applicant__c=objApplicant.id;
           objEConsent.Consent_Completed__c=true;
         
           update objEConsent;
 
    }
    
   
   public static testMethod void validate()
    { 
         LoadData();
         acfVedaApplicantLink__c obj=new acfVedaApplicantLink__c();
         obj.name='10/06/2016Neha Gupta';
         obj.Veda_Status__c='active';
         obj.Applicant__c=objApplicant.id;
         insert obj;
         
           objEConsent = new E_Consent__c();
           objEconsent.Applicant__c = objApplicant.id;
           objEconsent.Consent_Completed__c = true;
           objEconsent.Consent_IP__c = '192.168.0.1';
           objEconsent.Consent_Method__c = 'trigger';
           objEconsent.Consent_Time_and_Date__c = system.now();
           insert objEconsent;
           objEConsent.Applicant__c=objApplicant.id;
           objEConsent.Consent_Completed__c=true;
         
           update objEConsent;
    }
     public static testMethod void validate5()
    { 
         LoadData();
         acfVedaApplicantLink__c obj=new acfVedaApplicantLink__c();
         obj.name='10/06/2016Neha Gupta';
         obj.Veda_Status__c='active';
         //obj.Applicant__c=objApplicant.id;
         insert obj;
         
           objEConsent = new E_Consent__c();
           objEconsent.Applicant__c = objApplicant.id;
           objEconsent.Consent_Completed__c = true;
           objEconsent.Consent_IP__c = '192.168.0.1';
           objEconsent.Consent_Method__c = 'trigger';
           objEconsent.Consent_Time_and_Date__c = system.now();
           insert objEconsent;
           objEConsent.Applicant__c=objApplicant.id;
           objEConsent.Consent_Completed__c=true;
         
           update objEConsent;
    }
    
    
    public static void LoadData()
    {
             
     ACFSwitch__c acfswitch = new ACFSwitch__c();
        acfswitch.E_Consent_Switch__c = true;    
        insert acfswitch;
    
     
        objLead = new Lead();
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = recorsTypeId;
        objLead.acfOneTimePassword__c = '724715';
        insert objLead;
        
        objDocumentMaster = new Document_Master__c();
        objDocumentMaster = WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
         objDocumentMaster.acf_Source__c = 'E-consent';
         update objDocumentMaster;
   
        objAccount = new Account();
        objAccount.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('ACF Refi').getRecordTypeId();
        objAccount.LastName = 'test';
        objAccount.PersonEmail = 'swati.sharma@saasfocus.com';
        objAccount.PersonMobilePhone = '+619654922845';
        objAccount.Employment_Status__pc = 'Casual';
        objAccount.Marital_Status__pc = 'Single';
        objAccount.Housing_Status__pc = 'Renting';
        objAccount.Number_of_Children__pc = '1';
        objAccount.Annual_Income__pc = 100000;
        objAccount.Partner_Annual_Income__pc = 50000;
        objAccount.Super_Balance__pc = 20000;
        objAccount.Partner_Super_Balance__pc = 2000;
        objAccount.acfCurrent_Loan_Amount__pc = 20000;
        objAccount.acfApproximately_how_much_is_your_house__pc = 10000;
        objAccount.acfAsset_House_Worth__c = 12332;
        objAccount.acfCurrent_Rate__pc = 10;
        objAccount.IsMaster__c=true;
        insert objAccount;
       
        objUser = new User();
         List<Profile> lstCommUserProfile = [select id,name from profile where name='Community User' limit 1];
            List<Account>lstPersonContact    = [select id,PersonContactId from Account where id=:objAccount.id];
            // system.debug('lstPersonContact***'+lstPersonContact);
           // objUser = new User();
            objUser.FirstName = 'test';
            objUser.LastName = 'test';
            objUser.Alias  = ('test'+String.valueof(Math.random())).substring(0,5);
            objUser.LocaleSidKey = 'en_AU';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.MobilePhone = '+6145678904';
            
            objUser.Username = 'test@fakeEmail.com';
            objUser.Email = 'test@fakeEmail.com';
            objUser.ProfileId = lstCommUserProfile[0].id;
            objUser.ContactId = lstPersonContact[0].PersonContactId;
            objuser.EmailEncodingKey = 'UTF-8';
            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
            objUser.TimeZoneSidKey = 'Australia/Brisbane';
            objUser.acfIs_Password_Reset__c = true;          
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            objUser.setOptions(dlo);
            insert(objUser);
   
        objOpportunity= new Opportunity();
       // objOpportunity.AccountId =objuser.AccountId;
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Settlement';
        objOpportunity.AccountId =objUser.AccountId ;
        //objOpportunity.Community_Setup__c=ClickCommon.getCommunitySetup(testNetworkId).Id;
       objOpportunity.recordtypeid= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Click New Loans').getRecordTypeId();
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        objOpportunity.acfAsset_House_Worth__c = 200000;
        insert objOpportunity;
   
         
         objApplicant= new click_Applicant__c();
         
        objApplicant.clickOpportunity__c = objOpportunity.id;
       //  objApplicant.acfAnnual_profit_income__c = 3250;
         objApplicant.acf_applicant_Monthlly_Salary__c = 45;
         objApplicant.clickApp_1_Monthly_Expenses__c  = 654;
         objApplicant.click_Applicant_Number__c = '1';
         objApplicant.acf_applicant_DOB__c='10/06/2016';
         objApplicant.acfRelationship_code__c='1';
         objApplicant.click_Account__c = objAccount.id;
         objApplicant.acf_Applicant_Name__c='Neha Gupta';
          objApplicant.acf_applicant_Employer_Name__c='test';
         insert objApplicant;
         
    objVeda = new acfVeda__c();
    objVeda.name= 'Veda';
    objVeda.EndPoint__c = 'qwerty';
    objVeda.Password__c = 'qwerty';
    objVeda.UserName__c = 'qwerty';
    insert objVeda ;
  
}}