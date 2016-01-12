@isTest(seealldata=true)
public class WLCommonTrackerClass
{
    static private Recordtype objRT;
    
    //static private User objUser;
    public static Script__c objScript;
    private string strNetworkId;
    private Click_Community_Setup__c objCommSetup;
    ClickCommon clickcommonobj = new ClickCommon(); 
    public static string testNetworkId
    {
        get
        {
            list<Network> lstnetwork = [SELECT id FROM Network limit 1];
            if(lstnetwork != null & lstnetwork.size() >0)
                return lstnetwork[0].Id;
            else
                return null;
        }
        set;
    }
    
    
   // Methods Created By Lokesh
   //This Method is used to create Pre/post Login Questions.
  public static Question__c  CreatePrePostLoginQuestions(string strQuestion,Integer NewsequenceNo,string strType,boolean IsRefinence,boolean IsNew,Id ScriptID,string strLeadApiName)
   {
        Question__c objQuest                 = new Question__c ();
        objQuest.acf_Question__c             = strQuestion;
        objQuest.acf_Active__c               = true;
        objQuest.acfRefinance_Sequence_No__c = NewsequenceNo;
        objQuest.acf_Type__c                 = strType;
        objQuest.acfNew_Loan_Sequence_No__c  = NewsequenceNo;
        objQuest.acfIs_refinance__c          = IsRefinence;
        objQuest.acf_Script__c               = ScriptID;
        objQuest.acfIs_New_Loan__c           = IsNew;
        objQuest.acf_ApiName__c              = strLeadApiName;
        insert objQuest;
        return objQuest;
   }
   
   public static Question__c  CreatePostLoginQuestions(string strQuestion,Integer NewsequenceNo,string strType,boolean IsRefinence,boolean IsNew,Id ScriptID,string strLeadApiName,string strdependentObjectName,boolean Deprndent,string strApp2ApiName,boolean appques)
   {
        Question__c objQuest                 = new Question__c ();
        objQuest.acf_Question__c             = strQuestion;
        objQuest.acf_Active__c               = true;
        objQuest.acfRefinance_Sequence_No__c = NewsequenceNo;
        objQuest.acf_Type__c                 = strType;
        objQuest.acfNew_Loan_Sequence_No__c  = NewsequenceNo;
        objQuest.acfIs_refinance__c          = IsRefinence;
        objQuest.acf_Script__c               = ScriptID;
        objQuest.acfIs_New_Loan__c           = IsNew;
        objQuest.acf_ApiName__c              = strLeadApiName;
        objQuest.acfDependent_Object_Name__c = strdependentObjectName;
        objQuest.acfDependent_Field_Name__c  = 'acfApproximately_how_much_is_your_house__c';
        objQuest.acf_Dependents__c           = Deprndent;
        objQuest.acfApplicant_2_Api_Name__c  = strApp2ApiName;
        objQuest.acfIs_Applicant_Question__c = appques;
        objQuest.acf_Active__c               = true;
        insert objQuest;
        return objQuest;
   }
   
    public static Script__c createScript (string strtype)
    {
        objScript                      = new Script__c();
        Id recorsTypeId                = acfCommon.GetRecordTypeId('Script__c',strtype);
        objScript.RecordTypeId         = recorsTypeId;
        objScript.acf_Type__c          = 'Pre-Login';
        objScript.acf_Sequence_no__c   = 1;
        objScript.acf_Question_Type__c = 'Applicant Details';
        objScript.Click_Community_Setup__c = ClickCommon.getCommunitySetup(testNetworkId).Id;
        insert objScript;
        system.assert(objScript.id != null);
        return objScript;
    }
   
   public static acfBank_Detail__c createBankDetail ()
   {
        acfBank_Detail__c objBankDetail     = new acfBank_Detail__c();
        objBankDetail.acfBank_Name__c       = 'Bank of Statements';
        objBankDetail.acfBankSlugName__c    = 'bank_of_statements';
        insert objBankDetail;
        system.assert(objBankDetail.id != null);
        return objBankDetail;
   }
   
   public static Answer__c createAnswer (Id QuesId,Id RelatedQuesId,string strAnswer)
    {
        Answer__c objAnswer               = new Answer__c();
        objAnswer.acf_Question__c         = QuesId; 
        objAnswer.acf_Related_Question__c = RelatedQuesId;
        objAnswer.acf_Answer__c           = strAnswer;
        objAnswer.acfSequence_No__c = 1;
        insert objAnswer;
        system.assert(objAnswer.id != null);
        return objAnswer;
    }
    
    
    public static user CreatePortalUser(Id ContactId)
    {
            List<Profile> lstCommUserProfile = [select id,name from profile where name='Community User' limit 1];
            List<Account>lstPersonContact    = [select id,PersonContactId from Account where id=:ContactId];
         
            User objUser = new User();
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
            return objUser;
    }
    public static User CreatePortalUserNew(Id ContactId)
    {
            List<Profile> lstCommUserProfile = [select id,name from profile where name='Community User' limit 1];
            List<Account>lstPersonContact    = [select id,PersonContactId from Account /*where id=:ContactId*/];
            User objUser = new User();
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
            return objUser;
    }
    
    public static Account CreatePersonAccount(string strLeadFName,string LName,string strPhone,string strLeadEmail,Id strLeadId)
    {
        Account objPersonAccount      = new Account();
        objPersonAccount.FirstName    = strLeadFName; 
        objPersonAccount.LastName     = LName;
        objPersonAccount.PersonMobilePhone        = strPhone;
        objPersonAccount.PersonEmail  = strLeadEmail;
        list<lead> lstLead = [select id,isConverted from lead where id =: strLeadId];
        if(lstLead != null && lstLead.size()>0)
        {
            if(lstLead[0].isConverted == false)
                objPersonAccount.acf_Lead__pc = strLeadId;
        }
        objPersonAccount.acf_Applicant_Name__pc = 'test';
        insert objPersonAccount;
        return objPersonAccount;
    }
    
    public static id CreatePersonAccountNew(Id strLeadId)
    {
        Account objPersonAccount      = new Account();
        objPersonAccount.FirstName    = 'test'; 
        objPersonAccount.LastName     = 'test';
        objPersonAccount.PersonMobilePhone        = '+612456654';
        objPersonAccount.PersonEmail  = 'test@gmail.com';
        objPersonAccount.acf_Lead__pc = strLeadId;
        objPersonAccount.acf_Applicant_Name__pc = 'test';
        insert objPersonAccount;
        return objPersonAccount.id;
    }
    
    public static Lead createLeadForPortal()
    {
        Lead objLead = new Lead();
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = recorsTypeId;
        objLead.acfOneTimePassword__c = '724715';
        insert objLead;
        system.assert(objLead.id != null);
        return objLead; 
    }
   
   ////=========================================================END==============================================================================================




  public static Lead createLead(Lead objLead)
    {
        objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'Lead' AND name= 'Click Refi'];
        objLead.FirstName = '+619654922845';
        objLead.LastName = '+619654922845';
        objLead.Email = 'swati.sharma@saasfocus.com';
        objLead.MobilePhone = '+619654922845';
        objLead.Status = 'Open';
        objLead.RecordTypeId = objRT.id;
        objLead.acfOneTimePassword__c = '724715';
        insert objLead;
        system.assert(objLead.id != null);
        return objLead; 
    }
    
  public static Profile createProfile(String strProfileName)
    {
        list<Profile> lstProfile = [Select Id,Name from Profile where Name =: strProfileName limit 1];
        
        system.assert(lstProfile != null);
        system.assert(lstProfile.size() > 0);
        
        return lstProfile[0];
    }
  
  public static Account createAccount(Account objAccount)
    {
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
        objAccount.acfCurrent_Rate__pc = 10;
        insert objAccount;
        system.assert(objAccount.id != null);
        return objAccount;   
    }
    
 
    
   public static User CreateUser(User objUser)
   {
        //profile.name = 'Partners Profile' AND
        user objSiteUser = [select id,name,profile.name from user where  name like '%guest%' limit 1];
        system.debug('@@@@User'+objSiteUser);
        list<profile> profileid = [select id, name from profile where name='Community User' limit 1];
        UserRole RoleId = [select id from UserRole where Name =: 'Executive Team' ];
        List<MortgageExpert__c> List_mExpert = MortgageExpert__c.getall().values();
        String OwnerId = '';
        if(List_mExpert != null && List_mExpert .size()>0)
        OwnerId  = List_mExpert[0].User_ID__c;
        //objUser = new User();
        system.runAs(objSiteUser)
        {
            
            objUser.email='test@gmail.com'; 
            objUser.profileId = profileid[0].id;                
            objUser.UserName='test-user@fakeemail.com'; 
            objUser.alias='tuser1';
            objUser.CommunityNickName='tuser1'; 
            objUser.TimeZoneSidKey='America/New_York'; 
            objUser.LocaleSidKey='en_US'; 
            objUser.EmailEncodingKey='ISO-8859-1'; 
            objUser.LanguageLocaleKey='en_US';
            objUser.FirstName = 'Sunny';
            objUser.LastName = 'Sharma' ;
            objUser.Phone='8989898989';
            objUser.MobilePhone='+619889823456';
            objUser.IsActive = true;
            insert objUser;
           //objUser.UserRoleId = RoleId.id;
           if(OwnerId != null && OwnerId  <> '')
            objUser.id = Site.createPersonAccountPortalUser(objUser,OwnerId,'12345');
            system.debug('!@#$%'+objUser);
        }
        return objUser;
        
   }
    
     public static Contact createContact(Contact objContact,Account objAccount)
    {
//        objContact.Account = objAccount.id;
        objContact.LastName = 'test';
        objContact.email = 'swati.sharma@saasfocus.com';
//        insert objContact;
        //system.assert(objContact.id != null);
        return objContact;   
    }
    
    public static MortgageExpert__c createMortgageExpert(MortgageExpert__c objMortgageExpert)
    {
        objMortgageExpert = new MortgageExpert__c ();
        //objMortgageExpert.Languages__c = 'English';
        objMortgageExpert.User_ID__c = userInfo.getUserId();
        objMortgageExpert.Name = 'test';
        insert objMortgageExpert;
        
        system.assert(objMortgageExpert.id != null);
        return objMortgageExpert;   
    }
    
    public static Product2 createProduct(Product2 objProduct2)
    {
        objProduct2.ACF_Comparison_Rate__c = 10;
        objProduct2.IsActive = true;
        objProduct2.Name = 'test';
       // objProduct2.acfRating__c = '1';
        objProduct2.acfTenure_in_Years__c = '2';
        insert objProduct2;
        system.assert(objProduct2.id != null);
        return objProduct2;   
    }
    
     public static Question__c createQuestion (Question__c objQuestion)
    {
        objQuestion.acf_Question__c = 'Who is your current lender?';
        objQuestion.acf_Active__c = true;
        objQuestion.acf_Sequence_No__c = 2.0;
        objQuestion.acf_Type__c = 'Button';
        objQuestion.acfRefinance_Sequence_No__c = 1;
        objQuestion.acfIs_refinance__c = true;
        //objQuestion.acf_Script__c = objScript1.id;
        insert objQuestion;
         system.assert(objQuestion.id != null);
        return objQuestion;
    }
  
    public static Answer__c createAnswer (Answer__c objAnswer)
    {
        objAnswer.acf_Answer__c = 'test';
        objAnswer.acfSequence_No__c = 1;
        insert objAnswer;
        system.assert(objAnswer.id != null);
        return objAnswer;
    }
    
   
    
    public static acfBank_Detail__c createBankDetail (acfBank_Detail__c objBankDetail)
    {
        objBankDetail.acfBank_Name__c = 'Bank of Statements';
        objBankDetail.acfBankSlugName__c = 'nab';
        insert objBankDetail;
        system.assert(objBankDetail.id != null);
        return objBankDetail;
    }
    
    
    public static acfContentManagementSystem__c CreateContentManagementSystem (acfContentManagementSystem__c objContentManagementSystem)
    {
        objContentManagementSystem = new acfContentManagementSystem__c();
        //objContentManagementSystem.Name='Test';
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'ClickHome';
        objContentManagementSystem.acfSectionName__c = 'Footer Links';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;

        insert objContentManagementSystem;

        system.assert(objContentManagementSystem.id != null);
        return objContentManagementSystem;
    }
    
    public static acfTask_Master__c createtask(acfTask_Master__c objTask)
    {
        objtask = new acfTask_Master__c();
        objtask.acfIsActive__c = true;
        objtask.acfStage__c = 'Opportunity Creation';
        objtask.acfSubject__c = 'test';
        
        insert objtask;
        
        system.assert(objtask.id != null);
        return objtask;
    }
    
    public static Opportunity createOpportunity(Opportunity objOpportunity,User objUser)
    {
        objOpportunity = new Opportunity();
        objOpportunity.AccountId = objuser.AccountId;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        insert objOpportunity;
        
        system.assert(objOpportunity.id != null);
        return objOpportunity;
    }
    
    public static Document_Master__c createDocumentMaster(Document_Master__c objDocumentMaster)
    {
        objDocumentMaster  = new Document_Master__c();
        objDocumentMaster.name = 'test';
        objDocumentMaster.acfActive__c = true;
        objDocumentMaster.acf_Source__c = 'Bank Statement';
        insert objDocumentMaster;
        
        system.debug(objDocumentMaster.id != null);
        return objDocumentMaster;
    } 
    
    public static Required_Document__c createRequiredDocument(Required_Document__c objRequiredDocument,Document_Master__c objDocumentMaster,Opportunity objOpportunity)
    {
        objRequiredDocument  = new Required_Document__c();
        objRequiredDocument.name = 'test';
        objRequiredDocument.acfStatus__c = 'Pending';
        objRequiredDocument.acfOpportunity__c = objOpportunity.id;
        objRequiredDocument.acfDocument_Master__c = objDocumentMaster.id;
        insert objRequiredDocument;
        
        system.debug(objRequiredDocument.id != null);
        return objRequiredDocument;
    } 
}