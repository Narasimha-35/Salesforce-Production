@isTest(seealldata=true)
public class WLCommonTrackerClass
{
    static private Recordtype objRT;
    
    //static private User objUser;
    public static Script__c objScript;
    private string strNetworkId;
    public Click_Community_Setup__c objCommSetup;
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
   
   public static Question__c  CreatePostLoginQuestions(string strQuestion,Integer NewsequenceNo,string strType,boolean IsRefinence,boolean IsNew,Id ScriptID,string strLeadApiName,string strdependentObjectName,boolean Deprndent,string strApp2ApiName,boolean appques,boolean str)
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
        objQuest.click_is_EConsent__c=str;
        objQuest.Click_Is_Broker_Question__c=false;
        insert objQuest;
        return objQuest;
   }
   
    public static Script__c createScript (string strtype)
    {
        objScript                      = new Script__c();
               objScript.recordtypeid=Schema.SObjectType.Script__c.getRecordTypeInfosByName().get('Pre-Login').getRecordTypeId();

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
        objBankDetail.clickShow_on_Bank_Statements_Integration__c = true;
        objBankDetail.acfBankSlugName__c    = 'HSBC';
        objBankDetail.acfBank_Short_Name__c = 'test';
        insert objBankDetail;
        system.assert(objBankDetail.id != null);
        return objBankDetail;
   }
   
    // Methods Created By Ashna
  
   public static acfBank_Information__c createBankQuestions()
   {
        acfBank_Information__c objBankQuestions = new acfBank_Information__c ();
        objBankQuestions.name='ACFScreen 1';
        objBankQuestions.acfDescription_Text__c='Description ofBank';
        objBankQuestions.acfHeader_Text__c= 'acfHeader_Text__c';
        insert objBankQuestions ;
        system.assert(objBankQuestions.id!=null);
        return objBankQuestions;
   }
   
    public static Click_Community_Setup__c createcommunitysetup()
   {
        Click_Community_Setup__c objcommunitysetup=new Click_Community_Setup__c();
        objcommunitysetup.Name='test';
        objcommunitysetup.Click_Network_ID__c='test';
        objcommunitysetup.Click_URL__c='test';
        objcommunitysetup.Click_IsActive__c  = true;
        objcommunitysetup.Community_User_Name_Prefix__c='test';
        objcommunitysetup.Click_Page_Prefix__c='click';
        objcommunitysetup.click_Home_Page_URL__c='https://www.google.co.in/';
        insert objcommunitysetup;
        system.assert(objcommunitysetup.id!=null);
        return objcommunitysetup;
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
             system.debug('lstPersonContact***'+lstPersonContact);
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
        objPersonAccount.acfCurrent_Loan_Amount__pc = 123;
        objPersonAccount.acfWhat_is_your_current_payment_type__pc = 'qwerty';
        objPersonAccount.PersonMobilePhone        = strPhone;
        objPersonAccount.Click_Community_Setup__c = ClickCommon.getCommunitySetup(testNetworkId).Id;
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
        objAccount.acfAsset_House_Worth__c = 12332;
        objAccount.acfCurrent_Rate__pc = 10;
        objAccount.IsMaster__c=true;
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
          // objUser.profileId = profileid[0].id;                
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
        objContact.acfWhat_is_your_current_payment_type__c='test';
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
        //objProduct2 = new Product2();
        objProduct2.ACF_Comparison_Rate__c = 10;
        objProduct2.IsActive = true;
        objProduct2.Name = 'test';
        objProduct2.Trailing_Commission__c=0.5;
       objProduct2.Upfront_Commission__c=0.6;
       // objProduct2.acfRating__c = '1';
        objProduct2.acfTenure_in_Years__c = '2';
        objProduct2.acfApplication_Fee__c = 250;
        objProduct2 .recordtypeid=Schema.SObjectType.product2.getRecordTypeInfosByName().get('Variable').getRecordTypeId();
        objProduct2 .acfOffset_Account__c=false;
        objProduct2.acfvarTenure_In_Years__c = 1234;
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
        //objOpportunity = new Opportunity();
        objOpportunity.AccountId =objUser.AccountId ;
        objOpportunity.Community_Setup__c=ClickCommon.getCommunitySetup(testNetworkId).Id;
       objOpportunity.recordtypeid= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Click New Loans').getRecordTypeId();
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        objOpportunity.acfAsset_House_Worth__c = 200000;
        insert objOpportunity;
       
        system.assert(objOpportunity.id != null);
           system.debug('objOpportunity-------'+objOpportunity.id);
           // system.debug('objOpportunity-------'+objid);
           system.debug('objOpportunity-------'+objOpportunity.name );
        return objOpportunity;
     
    }
    //Method created by Ashna
    
    public static Opportunity createOpportunity1(Opportunity objOpportunity,Account objpersonaccount)
    {
       // objOpportunity = new Opportunity();
        objOpportunity.AccountId =objpersonaccount.id ;
        objOpportunity.Community_Setup__c=objpersonaccount.Click_Community_Setup__c;
        //objOpportunity.Community_Setup__c=ClickCommon.getCommunitySetup(testNetworkId).Id;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        objOpportunity.acfAsset_House_Worth__c = 200000;
        insert objOpportunity;
        system.debug('objOpportunity-------'+objpersonaccount.id);
        system.debug('objOpportunity-------'+objOpportunity.Community_Setup__c);
        return objOpportunity;
       }
    
    public static Document_Master__c createDocumentMaster(Document_Master__c objDocumentMaster)
    {
        objDocumentMaster  = new Document_Master__c();
        objDocumentMaster.name = 'test';
        objDocumentMaster.acfActive__c = true;
        //objDocumentMaster.Click_Community_Setup__c = ClickCommon.getCommunitySetup(testNetworkId).Id;
        objDocumentMaster.acf_Source__c = 'Bank Statement';
        insert objDocumentMaster;
        
        system.debug(objDocumentMaster.id != null);
        return objDocumentMaster;
    } 
    
    public static Required_Document__c createRequiredDocument(Required_Document__c objRequiredDocument,Document_Master__c objDocumentMaster,Opportunity objOpportunity)
    {
       // objRequiredDocument  = new Required_Document__c();
        objRequiredDocument.name = 'test';
        objRequiredDocument.acfStatus__c = 'Pending';
        objRequiredDocument.acf_Bank_Statement_Doc__c = true;
        objRequiredDocument.acfOpportunity__c = objOpportunity.id;
        objRequiredDocument.acfDocument_Master__c = objDocumentMaster.id;
        insert objRequiredDocument;
        
        system.debug(objRequiredDocument.id != null);
        return objRequiredDocument;
    } 
    
    
    public static Asset_And_Liability__c createAssetandLiablility(Asset_And_Liability__c objAssetandLiablility, Account objAccount)
    {
     // Id AssetRecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
      objAssetandLiablility = new Asset_And_Liability__c();
      objAssetandLiablility.Account__c = objAccount.Id;
      objAssetandLiablility.Account_Name__c = 'Bhasin Test';
      objAssetandLiablility.Account_Number__c ='ACN123456';
     // objAssetandLiablility.RecordTypeId = AssetRecordTypeId;
      objAssetandLiablility.Type__c ='Asset';
      objAssetandLiablility.Value__c = 100000;
      objAssetandLiablility.Primary_Purpose__c ='Owner Occupied';
      objAssetandLiablility.Repayments__c=09876;
      objAssetandLiablility.Used_as_Security__c = true;
      insert objAssetandLiablility;
      
      system.assert(objAssetandLiablility.id !=null);
      return objAssetandLiablility;
   }  
     
     public static click_Applicant__c createApplicant(click_Applicant__c objApplicant,Account objAccount,Opportunity objOpportunity ){
     
         objApplicant = new click_Applicant__c();
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

         system.assert(objApplicant.id !=null);
         return objApplicant;
     
     }
     
      public static PriceBook2 createPriceBook2()
      {
          PriceBook2 objPriceBook2  = new PriceBook2();
          objPriceBook2.IsActive = true;
          objPriceBook2.Description = 'testDescription';
          //objPriceBook2.IsStandard = true;
          objPriceBook2.Name = 'test';
           insert objPriceBook2;

         system.assert(objPriceBook2.id !=null);
         return objPriceBook2;
      }
      
        public static Income_And_Expense__c createIncomeExpense(Income_And_Expense__c objIncome, click_Applicant__c objApp){
     
         Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Income').getRecordTypeId();
         objIncome = new Income_And_Expense__c();
         objIncome.recordTypeId = IncomeRecordTypeId;
         objIncome.Amount__c = 45;
         objIncome.Category__c = 'Full Time - PAYG';
         objIncome.Applicant__c = objApp.Id;
         insert objIncome;
         
         system.assert(objIncome.id !=null);
         return objIncome;
     }
       
     public static Income_And_Expense__c createIncomeAndExpense1(click_Applicant__c objApp){
         Id IncomeRecordTypeId = Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosByName().get('Income').getRecordTypeId();
         Income_And_Expense__c  objIncome = new Income_And_Expense__c();
         objIncome.recordTypeId = IncomeRecordTypeId;
         objIncome.Amount__c = 45;
         objIncome.Category__c = 'Full Time - PAYG';
         objIncome.Applicant__c = objApp.Id;
         insert objIncome;
         
         system.assert(objIncome.id !=null);
         return objIncome;
     
     }
     
       public static acfSuggested_Product__c createacfSuggestedProduct()
    {
        acfSuggested_Product__c  objsuggestedproduct = new acfSuggested_Product__c();
        objsuggestedproduct.acfFilter__c='Exclude';
      //  objsuggestedproduct.acfLead__c=objlead;
        objsuggestedproduct.Services_Funds_Requested__c=true;
        insert objsuggestedproduct;
        system.assert(objsuggestedproduct.id != null);
        return objsuggestedproduct;
    }
    
    public static Click_Loans_Bank__c createClickloan(acfBank_Detail__c objacfbankdetail,Click_Community_Setup__c objcommunity)
    {
        Click_Loans_Bank__c  objclickloan=new Click_Loans_Bank__c();
        objclickloan.Click_Loans_Bank_Detail__c=objacfbankdetail.id;
        objclickloan.Community_Setup__c=objcommunity.id;
        insert objclickloan;
        system.assert(objclickloan.id != null);
        return objclickloan;
    
    }
    
         public static Funding_Position__c createFundingPosition(Account objAccount,Opportunity objOpportunity )
         {
             Funding_Position__c objFunding = new Funding_Position__c();
             objFunding.Account__c=objAccount.id;
             objFunding.Opportunity__c= objOpportunity.id;
             objFunding.LMI__c=1223;
             insert objFunding;
             system.assert(objFunding.id != null);
            return objFunding;
         }
    
        public static PricebookEntry  createPricebookEntry(Pricebook2 objPricebook2 , Product2 objProduct2)
         {
             PricebookEntry  objPricebookEntry  = new PricebookEntry();
             objPricebookEntry.Product2 = objProduct2;
            // objPricebookEntry.Pricebook2 = objPricebook2;
            // objPricebookEntry.ProductCode = 'text';
            objPricebookEntry.IsActive = true;
            objPricebookEntry.UnitPrice = 200;
            //objPricebookEntry.StandardPrice=1234;
           // objPricebookEntry.UseStandardPrice=true;
            objPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
            objPricebookEntry.Product2Id =objProduct2.id;
             insert objPricebookEntry;
             system.assert(objPricebookEntry.id != null);
            return objPricebookEntry;
         }
         
         public static OpportunityLineItem  createOpportunityLineItem(PricebookEntry objPricebookEntry,Opportunity objOpportunity )
         {
            OpportunityLineItem objLineItem = new OpportunityLineItem();
            objLineItem.PriceBookEntryId = objPricebookEntry.Id;
            objLineItem.OpportunityId = objOpportunity .Id;
            objLineItem.Quantity = 1;
            objLineItem.Unitprice = 500;
            Insert objLineItem;
            System.assert(objLineItem.id != null);
            return objLineItem;
          }
         
        
     public static Funding_Position_Detail__c createFundingPositionDetail(Asset_And_Liability__c objAssetLiability,Funding_Position__c objFunding)
      {
          Funding_Position_Detail__c  objFundingDetail = new Funding_Position_Detail__c();
          objFundingDetail .Funding_Position__c = objFunding.id;
          objFundingDetail .Asset_And_Liability__c = objAssetLiability.id;
          objFundingDetail .Amount__c = 1234;
          objFundingDetail .Category__c = 'Debt';
          objFundingDetail .Detail_Type__c = 'Purchase Stamp Duty'; 
          //objFundingDetail .CreatedDate = Date.newInstance(22,12,2012);
          insert objFundingDetail ;
             system.assert(objFundingDetail .id != null);
            return objFundingDetail ;
      } 
      
        public static Market__c createMarket()
      {
          Market__c objMarket = new  Market__c();
          objMarket.name='test';
          objMarket.Market_Region__c = 'Adelaide';
          insert objMarket;
           system.assert(objMarket.id != null);
            return objMarket;
      
      }
      public static Broker__c createBroker(Market__c objMarket)
      {
          Broker__c  objBroker = new Broker__c();
          objBroker.Name = 'test';
          objBroker.Email__c = 'test@gmail.com';
          objBroker.Channel__c = 'Partner';
          objBroker.MobilePhone__c = '123456788';
          objBroker.Street_Address__c = 'test' ;
          objBroker.City__c = 'test';
          objBroker.Primary_Market__c = objMarket.id;
          objBroker.ACL_Licence__c = 'test';
          objBroker.Representative_Email__c = 'test@gmail.com';
          objBroker.ACL_EDR_Membership_No__c = 'test';
          objBroker.ACL_EDR_Scheme__c = 'test';
          objBroker.ACL_Email__c = 'test@gmail.com';
          objBroker.ACL_Holder__c =  'test';
          objBroker.Representative_Business_Address__c = 'testtexarea';
          objBroker.ACR__c = 'test';
          objBroker.ACL_Phone__c = '123456788';
          objBroker.ACR_EDR_Membership_No__c = 'test';
          objBroker.ACR_EDR_Expiry__c = system.today();
          objBroker.ACR_EDR_Scheme_Name__c = 'test';
          insert objBroker;
          system.assert(objBroker.id != null);
          return objBroker;
      }
      public static acfSuggested_Product__c createSuggestedProduct()
      {
          acfSuggested_Product__c objSuggestedProduct = new acfSuggested_Product__c();
          objSuggestedProduct.acfFilter__c = 'Exclude';
          insert objSuggestedProduct;
          system.assert(objSuggestedProduct.id != null);
          return objSuggestedProduct;
      }
      
      public static LVR_Rate__c createLvrRate(product2 objProducts)
      {
           LVR_Rate__c objLvr = new LVR_Rate__c();
           objLvr.clickLoan_Size_From__c=20;
           objLvr.acfLoan_Size__c=150;
           objLvr.clickLVR_From__c=2;
           objLvr.acfLVR__c=20;
           objLvr.acfProduct__c=objProducts.id;
           insert objLvr;
           system.assert(objLvr.id != null);
           return objLvr;
      }
      
      public static E_Consent__c createEconsent(click_Applicant__c objApplicant)
      {
           E_Consent__c objEconsent = new E_Consent__c();
           objEconsent.Applicant__c = objApplicant.id;
           objEconsent.Consent_Completed__c = true;
           objEconsent.Consent_IP__c = '192.168.0.1';
           objEconsent.Consent_Method__c = 'trigger';
           objEconsent.Consent_Time_and_Date__c = system.now();
           insert objEconsent;
           system.assert(objEconsent.id != null);
           return objEconsent;
      }
      
      public static ServicingCalculator__c createServicecalculator(opportunity objOpp)
      {
          ServicingCalculator__c objServicing = new ServicingCalculator__c();
          objServicing.Max_Borrowing_Power__c = 654323456;
          objServicing.Net_Monthly_Surplus__c = 7654;
          objServicing.Opportunity__c = objOpp.id;
          objServicing.Services_Funds_Requested__c = false;
          objServicing.Services_Funds_Required__c = false;
          insert objServicing;
          system.assert(objServicing.id != null);
          return objServicing;
      }
      
      public static EmailHistory__c createEmailHistory(opportunity objOpp)
      {
           EmailHistory__c objEmailHistory = new EmailHistory__c();
           objEmailHistory.ccRecipants__c = 'ankit2gmail.com';
           objEmailHistory.emailContent__c = 'ankit2gmail.com';
           objEmailHistory.AcfOpportunity__c = objOpp.Id;
           objEmailHistory.recipants__c = 'ankit2gmail.com';
           objEmailHistory.subject__c = 'Ankit Singh';
           insert objEmailHistory;
           system.assert(objEmailHistory.id != null);
           return objEmailHistory;
      }
      
      public static Global_DealIQ_Condition__c createGlobalDealIqCondition(Document_Master__c objDocumentMaster)
      {
          Global_DealIQ_Condition__c objGlobalDealIq = new Global_DealIQ_Condition__c();
          objGlobalDealIq.Document_Master__c = objDocumentMaster.id;
          objGlobalDealIq.Name = 'testglobaldeal';
          objGlobalDealIq.Category__c = 'Character';
          objGlobalDealIq.Object_Rule_Works_On__c = 'Product';
          objGlobalDealIq.RecordRuleWorksOn__c = 'test1323';
          objGlobalDealIq.Req_Doc_Created__c = true;
          objGlobalDealIq.acfRule_Description__c = 'desc';
          objGlobalDealIq.Active__c = true;
          insert objGlobalDealIq;
          system.assert(objGlobalDealIq.Id != null);
          return objGlobalDealIq;
      }
      
      public static acfDealIQ_Condition__c createDealIqCondition(opportunity objOpp,Global_DealIQ_Condition__c objGlobalDealIq)
      {
           acfDealIQ_Condition__c objDealIqCondition = new acfDealIQ_Condition__c();
           objDealIqCondition.acfComments__c = 'test';
           objDealIqCondition.acfOpportunity__c = objOpp.Id;
           objDealIqCondition.acfStatus__c = 'Open';
           objDealIqCondition.acfGlobal_DealIQ_Rule__c = objGlobalDealIq.Id; 
           insert objDealIqCondition;
           system.assert(objDealIqCondition.id != null);
           return objDealIqCondition;
      }
      
      
      
}