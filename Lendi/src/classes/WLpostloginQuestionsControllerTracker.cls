@isTest
public class WLpostloginQuestionsControllerTracker
{
private static Lead objLead ;
    private static User objUser;
    private static Click_Community_Setup__c objcommunity;
    private static account accperson;
    private static account objAccount;
    private static Contact objContact;
    private static Opportunity objOpportunity;

static testMethod void validate()
{
LoadData();
 System.runAs(objuser) 
        {
        click_Applicant__c obj=new click_Applicant__c();
       // obj.name='test';
        obj.click_Applicant_Number__c='1';
        obj.acfEconsent__c='I Consent';
        obj.click_Account__c=accperson.id;
        insert obj;
        
        Script__c scobj=new Script__c();
        scobj.acf_Type__c='Post-Login';
        scobj.Click_Community_Setup__c=objcommunity.id;
        scobj.clickAsk_for_every_applicant__c=false;
        insert scobj;
        
        Question__c queobj=new Question__c();
        queobj.acf_Active__c=true;
        queobj.Click_Is_Broker_Question__c=false;
        queobj.acfEmployment_Type__c=true;
        queobj.acf_ApiName__c='test';
        insert queobj;
        
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=scobj.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.click_is_EConsent__c=true;
        queobj1.acfDependent_Object_Name__c='Contact';
        insert queobj1;  
              
        
       
        
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=queobj.id;
        insert ansobj;
        queobj.acf_Master_Question__c=queobj1.id;
        update queobj;
       /* WLpostloginQuestionsController.ApplicantDetailsWrapper objwrap=new  WLpostloginQuestionsController.ApplicantDetailsWrapper();
        objwrap.applicantNo='23';
        objwrap.applicantRecNo=10;
        objwrap.appEmail='test@gmail.com';
        objwrap.appMobile='12121212';*/
       
        
       
        WLpostloginQuestionsController wlobj=new WLpostloginQuestionsController();
        }
        }

static testMethod void validate1()
{
LoadData();
 System.runAs(objuser) 
        {
        click_Applicant__c obj=new click_Applicant__c();
       // obj.name='test';
        obj.click_Applicant_Number__c='4';
        obj.acfEconsent__c='I Consent';
        obj.click_Account__c=accperson.id;
        insert obj;
        
         Script__c scobj=new Script__c();
        scobj.acf_Type__c='Post-Login';
        scobj.Click_Community_Setup__c=objcommunity.id;
        scobj.clickAsk_for_every_applicant__c =true;
        insert scobj;
        
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=scobj.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.acfDependent_Object_Name__c='Lead';
        queobj1.acfEmployment_Type__c=true;
        insert queobj1;  
              
        Question__c queobj=new Question__c();
        queobj.acf_Active__c=true;
        queobj.Click_Is_Broker_Question__c=false;
        insert queobj;
               
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=queobj.id;
        insert ansobj;
        queobj.acf_Master_Question__c=queobj1.id;
        update queobj;
        
        WLpostloginQuestionsController wlobj=new WLpostloginQuestionsController();
     }
       }
       static testMethod void validate2()
{
LoadData();
 System.runAs(objuser) 
        {
        click_Applicant__c obj=new click_Applicant__c();
       // obj.name='test';
        obj.click_Applicant_Number__c='4';
        obj.acfEconsent__c='I Consent';
        obj.click_Account__c=accperson.id;
        insert obj;
        
         Script__c scobj=new Script__c();
        scobj.acf_Type__c='Post-Login';
        scobj.Click_Community_Setup__c=objcommunity.id;
        scobj.clickAsk_for_every_applicant__c =true;
        insert scobj;
        
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=scobj.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.acfDependent_Object_Name__c='click_Applicant__c';
        queobj1.acfEmployment_Type__c=true;
        insert queobj1;  
              
        Question__c queobj=new Question__c();
        queobj.acf_Active__c=true;
        queobj.Click_Is_Broker_Question__c=false;
        
        insert queobj;
       
        
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=queobj.id;
        insert ansobj;
        queobj.acf_Master_Question__c=queobj1.id;
        update queobj;
        
        WLpostloginQuestionsController wlobj=new WLpostloginQuestionsController();
     }
       }
        static testMethod void validate3()
{
LoadData();
 System.runAs(objuser) 
        {
        click_Applicant__c obj=new click_Applicant__c();
       // obj.name='test';
        obj.click_Applicant_Number__c='4';
        obj.acfEconsent__c='I Consent';
        obj.click_Account__c=accperson.id;
        insert obj;
        
         Script__c scobj=new Script__c();
        scobj.acf_Type__c='Post-Login';
        scobj.Click_Community_Setup__c=objcommunity.id;
        insert scobj;
        
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=scobj.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.acfDependent_Object_Name__c='Applicant';
        insert queobj1;  
              
        Question__c queobj=new Question__c();
        queobj.acf_Active__c=true;
        queobj.Click_Is_Broker_Question__c=false;
        
        insert queobj;
       
        
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=queobj.id;
        insert ansobj;
        queobj.acf_Master_Question__c=queobj1.id;
        update queobj;
        
        WLpostloginQuestionsController wlobj=new WLpostloginQuestionsController();
     }
       }
   private static void LoadData()
    {
        createLead(); 
        createAccount();
        CreatePersonAccount(); 
        createclickCommunitySetup();
        createContact();
        createUser();
        createOpportunity1();
    }
    
   
   
    static void createLead()
    {
       objLead = new Lead();
       
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = recorsTypeId;
        objLead.acfOneTimePassword__c = '724715';
        objLead.acfApproximately_how_much_is_your_house__c = 100.01;
        objLead.acfLoan_Amount__c = 100.20;
        objLead.acfIs_Bank_Statement_Submitted__c = true;
        //objLead.acfIs_Identity_Document_Submitted__c = true;
        objLead.acfIs_Post_Login_Ques_Attempted__c =true;
        //objLead.acfIs_Identity_Document_Submitted__c =true;
        insert objLead;
        
 //   objLead = acfCommonTrackerClass.createLeadForPortal();
    }

    static void createLead1()
    {
        objLead = new Lead();
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click New Loans');
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = recorsTypeId;
        objLead.acfOneTimePassword__c = '724715';
        objLead.acfApproximately_how_much_is_your_house__c = 100.01;
        objLead.acfLoan_Amount__c = 100.20;
        objLead.acfIs_Bank_Statement_Submitted__c = true;
        //objLead.acfIs_Identity_Document_Submitted__c = true;
        objLead.acfIs_Post_Login_Ques_Attempted__c =true;
        //objLead.acfIs_Identity_Document_Submitted__c =true;
        insert objLead;
    }

    
    static void createContact()
    {
        objContact = new Contact();
        objContact.acf_lead__c = objLead.id;
        objContact = WLCommontrackerClass.createContact(objContact,objAccount);
    }
    
    static void createuser()
    {
         objUser = new User();
         objUser = WLCommonTrackerClass.CreatePortalUser(accperson.id);
    }
    
    static void createOpportunity1()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
     static void  createAccount()
     {
     objAccount =new account();
     objAccount=WLCommontrackerClass.createAccount(objAccount);
     }
     
   static void CreatePersonAccount()
   {
       accperson=new account();
       accperson=WLCommontrackerClass.CreatePersonAccount('test','test','test','test@gmail.com',objLead.id);
       accperson.acfAsset_House_Worth__c=44;
       update accperson;
       objLead.acf_partner_account__c=accperson.id;
       update objLead;
   }
    
    static void CreatePersonAccount1()
    {
       accperson=new account();
       accperson=WLCommontrackerClass.CreatePersonAccount('test','test','test','test@gmail.com',objLead.id);
    // accperson.acfAsset_House_Worth__c=44;
       update accperson;
       objLead.acf_partner_account__c=accperson.id;
       update objLead;
    }
     static void createclickCommunitySetup() 
    {
        objcommunity = new Click_Community_Setup__c();
        objcommunity = WLCommontrackerClass.createcommunitysetup();
    }
}