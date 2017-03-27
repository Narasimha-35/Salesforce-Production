@isTest
private class WLCustomerRegisterControllerTracker 
{
    static private String strSelectedAnswers = '';
  static private Lead objLead;
  static private User objUser;
   public static User objuser1;
  private static acfSuggested_Product__c objacfSuggested;
  static private Profile objUserProfile;
  private static string USER_PROFILE_NAME = 'Community User';
  private static Contact objContact;
  private static acfBank_Detail__c objBank ;
  private static Account objAccount;
  private static MortgageExpert__c objMortgageExpert;
  private static Profile objProfile;
  private static Product2 objProduct2;
  private static Required_Document__c objRequiredDocument;
  private static Document_Master__c objDocumentMaster;
  private static Opportunity objOpportunity;
  private static Script__c objScript;
  private static Question__c objQuestion;
   private static Click_Loans_Bank__c objclickloan;
   private static Asset_And_Liability__c objassetli;
   private static Click_Community_Setup__c objclcmm;
    private static Click_Community_Setup__c objcommunity;
    private static click_Applicant__c objclickappl;
     private static Twilio__c objtwilio;
    private static acfBank_Information__c objBankQuestions;
  private static Answer__c objAnswer;
   //private static username;
  
   /*static testMethod void ValidateRegistration()
  {
 
        LoadData();
         system.runas(objuser)
  {
        Lead objL = new Lead();
        objL.FirstName = '+619654922845';
        objL.LastName = '+619654922845';
        objL.Email = 'swati.sharma@saasfocus.com';
        objL.MobilePhone = '+619654922845';
        objL.Status = 'Open';
        objL.acfOneTimePassword__c = '724715';
        objL.acfIsMobileVerified__c =false;
        objL.acf_partner_account__c = objAccount.id;
        objL.acfLoan_Amount__c = 1000.00;
        objL.acfCurrentRate__c = 3;
         objL.Community__c =objclcmm.id;
        objL.acfWhat_is_your_current_payment_type__c = 'Cash';
        objL.acfApproximately_how_much_is_your_house__c = 2000.00;
        insert objL;
        
        RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Variable'];
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Variable';
        objPro.RecordtypeId= objRT.Id;
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
        objPro.Trailing_Commission__c=0.5;
       objPro.Upfront_Commission__c=0.6;
        insert objPro;
        
        objProduct2.recordtypeid = ClickCommon.GetRecordTypeId('product2','Fixed');
        objProduct2.acfTenure_in_Years__c = '3';
        objProduct2.acfvarTenure_In_Years__c = 3;
        update objProduct2;
                
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 51.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objProduct2.id;
        objLVR.acfLoan_Size__c = 1900.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 500.50;
        objLVR.clickLVR_From__c = 1.2;
        objLVR.acfApplication_Fee__c = 5000; 
        
        insert objLVR; 
        
        WLCustomerRegisterController.WrapperProducts wrap = new WLCustomerRegisterController.WrapperProducts();
        wrap.decRate = 10.01;
        wrap.strRateType ='test';
        wrap.decComparisionRate = 10.01;
        wrap.decApplicationFee = 10.50;
        wrap.strcomparisionType ='Fixed';
        wrap.decMonthlyPayment = 100;
        wrap.intTenureYrs = 1;
        wrap.strRating = 'good';
        wrap.ProductId = objProduct2.id;
        wrap.ProdLVRID = objLVR.id;
        wrap.IndexNo = 1;
        list<integer> lstint = new list<integer>();
        lstint.add(1);
        lstint.add(2);
        wrap.lstProductRating = lstint;
        wrap.IsDisplayHalfStar = true;
        wrap.EstimatedMonthlySaving = 10.11;
        wrap.strProdName = 'bottle';
        
        acfContentManagementSystem__c objContentManagementSystem = new acfContentManagementSystem__c();
   //     objContentManagementSystem.Name='Test';
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'ClickHome';
        objContentManagementSystem.acfSectionName__c = 'Registration Popup';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        insert objContentManagementSystem;
        
        objScript     = WLCommonTrackerClass.createScript('Pre-Login');//string strQuestion,Integer NewsequenceNo,string strType,boolean IsRefinence,boolean IsNew,Id ScriptID
        system.debug('!@#$%'+objScript.id);
        objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,objL.FirstName);
        objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,objL.FirstName);
        objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,objL.FirstName);
        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
                        
        Cookie ACFAnswers = new Cookie('ACFAnswers','acfPostcode__c'+'-:-'+201435+'-,-',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{ACFAnswers});
        Cookie LeadId = new Cookie('LeadId',''+objL.id+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{LeadId});
        Cookie strUserId = new Cookie('strUserId',''+userinfo.getuserid()+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{strUserId});
        Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','true','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
        Cookie currentUId = new Cookie('currentUId ',''+userinfo.getuserid()+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{currentUId });
        Cookie ACFLeadApiNames = new Cookie('ACFLeadApiNames',''+objQuestion+'-:-'+objQuestion+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{ACFLeadApiNames});
        Cookie utm_source = new Cookie('utm_source','Web',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{utm_source});
        Cookie utm_term= new Cookie('utm_term','2',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{utm_term});
        Cookie utm_content= new Cookie('utm_content','Web',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{utm_content});
        Cookie utm_campaign = new Cookie('utm_campaign','Web',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{utm_campaign});
        Cookie utm_medium= new Cookie('utm_medium','Web',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{utm_medium});
        

      //  acfCustomerRegisterController.generateReqDocs(LeadId.getvalue());
        
        WLCustomerRegisterController objacfCustomerRegisterController = new WLCustomerRegisterController();
        objacfCustomerRegisterController.username = 'swati.sharma_1@saasfocus.com';
        objacfCustomerRegisterController.password = 'swatisharma10';
        objacfCustomerRegisterController.mobile = '9212155244';
        objacfCustomerRegisterController.mobile_otp = '724715';
        objacfCustomerRegisterController.mobile_num = '9212155244';
        objacfCustomerRegisterController.strTimezoneId = 'Asia/Kolkata';
        objacfCustomerRegisterController.showformVar =false;
        
         objcommunity= new Click_Community_Setup__c();
        objcommunity.Name = 'Click';
        insert objcommunity;
        
        WLCustomerRegisterController.generateReqDocs(objL.Id,objclcmm);
        
        objacfCustomerRegisterController.getProductIdslist();
        objacfCustomerRegisterController.Login(); 
        objacfCustomerRegisterController.showResendOTPfrm();   
        objacfCustomerRegisterController.VerifyEmail();
        objacfCustomerRegisterController.IsUserAlreadyExist();
        
         objL.Community__c=objclcmm.id;
        update objL;
        objacfCustomerRegisterController.username='swati.sharma@saasfocus.com';
        objacfCustomerRegisterController.maptst.put('test','test');
       
        objacfCustomerRegisterController.Registration();
        objacfCustomerRegisterController.SendSmsAfterRegistration();
        objacfCustomerRegisterController.DisplayTop3Products(objL.id,WLCommonTrackerClass.testNetworkId) ; 
        objacfCustomerRegisterController.istermsConditionsConfirmed = true;      
        objacfCustomerRegisterController.verifyOTP();
        objacfCustomerRegisterController.mobile_num = '+918896292603';     
        //objacfCustomerRegisterController.resendOTP();
        objacfCustomerRegisterController.OK();
        objacfCustomerRegisterController.RedirectToLandingPage();
        objacfCustomerRegisterController.redirect();
        objacfCustomerRegisterController.DisplayEstimatedSaving(5.0,3.0,12000,'Interest Only',10);
        }
  }*/
  
  
   /*static testMethod void ValidateRegistration01()
  {
        LoadData();
        Lead objL = new Lead();
        objL.FirstName = '+619654922845';
        objL.LastName = '+619654922845';
        objL.Email = 'swati.sharma@saasfocus.com';
        objL.MobilePhone = '+619654922845';
        objL.Status = 'Open';
        objL.acfOneTimePassword__c = '724715';
        objL.acfIsMobileVerified__c =false;
        objL.acf_partner_account__c = objAccount.id;
        objL.acfLoan_Amount__c = 1000.00;
        objL.acfCurrentRate__c = 3;
        objL.acfWhat_is_your_current_payment_type__c = 'Cash';
        objL.acfApproximately_how_much_is_your_house__c = 2000.00;
        insert objL;
        
        objProduct2.recordtypeid = ClickCommon.GetRecordTypeId('product2','Variable');
        objProduct2.acfTenure_in_Years__c = '3';
        objProduct2.acfvarTenure_In_Years__c = 3;
        update objProduct2;
        
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 51.25;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objProduct2.id;
        objLVR.acfLoan_Size__c = 1900.20;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 500.50;
        objLVR.clickLVR_From__c = 1.2;
        objLVR.acfApplication_Fee__c = 5000; 
        insert objLVR; 
        
        
        acfContentManagementSystem__c objContentManagementSystem = new acfContentManagementSystem__c();
   //     objContentManagementSystem.Name='Test';
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'ClickHome';
        objContentManagementSystem.acfSectionName__c = 'Registration Popup';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = false;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        insert objContentManagementSystem;
        
        Cookie ACFAnswers = new Cookie('ACFAnswers',null,null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{ACFAnswers});
        Cookie LeadId = new Cookie('LeadId',''+objL.id+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{LeadId});
        Cookie strUserId = new Cookie('strUserId',''+userinfo.getuserid()+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{strUserId});
        Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','true','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
        Cookie currentUId = new Cookie('currentUId ',''+userinfo.getuserid()+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{currentUId });
        
        
        
        WLCustomerRegisterController objacfCustomerRegisterController = new WLCustomerRegisterController();
        objacfCustomerRegisterController.username = 'swati.sharma_1@saasfocus.com';
        objacfCustomerRegisterController.password = 'swatisharma10';
        objacfCustomerRegisterController.mobile = '9212155244';
        objacfCustomerRegisterController.mobile_otp = '724715';
        objacfCustomerRegisterController.mobile_num = '9212155244';
        objacfCustomerRegisterController.strTimezoneId = 'Asia/Kolkata';
        objacfCustomerRegisterController.showformVar =false;
        
        objcommunity= new Click_Community_Setup__c();
        objcommunity.Name = 'Click';
        insert objcommunity;
        
        WLCustomerRegisterController.generateReqDocs(objL.Id,objclcmm);
        
        objacfCustomerRegisterController.Login(); 
        objacfCustomerRegisterController.showResendOTPfrm();   
        objacfCustomerRegisterController.VerifyEmail();
        objacfCustomerRegisterController.IsUserAlreadyExist();
        objacfCustomerRegisterController.username='testtest';
        objacfCustomerRegisterController.Registration(); 
        objacfCustomerRegisterController.DisplayTop3Products(objL.id,WLCommonTrackerClass.testNetworkId) ; 
        objacfCustomerRegisterController.istermsConditionsConfirmed = true;      
        objacfCustomerRegisterController.verifyOTP();    
        objacfCustomerRegisterController.resendOTP();
        objacfCustomerRegisterController.OK();
        objacfCustomerRegisterController.RedirectToLandingPage();
        objacfCustomerRegisterController.DisplayEstimatedSaving(7.0,9.0,16000,'Interest Only',10);
        
  }
  

  
    static testMethod void ValidateRegistration1()
  {
        LoadData();
        Test.startTest();
        Cookie ACFAnswers = new Cookie('ACFAnswers','acfPostcode__c'+'-:-'+201435+'-,-',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{ACFAnswers});
        Lead objL1 = new Lead();
        objL1.FirstName = '+619654922845';
        objL1.LastName = '+619654922845';
        objL1.Email = 'swati.sharma@saasfocus.com';
        objL1.MobilePhone = '+619654922845';
        objL1.Status = 'Open';
        objL1.acfOneTimePassword__c = '724715';
        objL1.acfIsMobileVerified__c = true;
        objL1.acf_partner_account__c = objAccount.id;
        objL1.acfLoan_Amount__c = 1000.00;
        objL1.acfCurrentRate__c = 3;
        objL1.acfWhat_is_your_current_payment_type__c = 'Cash';
        objL1.acfApproximately_how_much_is_your_house__c = 2000.00;
        insert objL1;
        
        list<product2> lstpro = new list<product2>();
        
        product2 objProduct = new product2();
        objProduct.ACF_Comparison_Rate__c = 10;
        objProduct.IsActive = true;
        objProduct.Name = 'test';
      //  objProduct.acfRating__c = '1';
        lstpro.add(objProduct);
        
        
        
        
        WLCustomerRegisterController objacfCustomerRegisterController = new WLCustomerRegisterController();
        objacfCustomerRegisterController.username = 'swati.sharma@saasfocus.com';
        objacfCustomerRegisterController.password = 'swatisharma10';
        objacfCustomerRegisterController.mobile = '9212155244';
        objacfCustomerRegisterController.mobile_otp = '724715';
        objacfCustomerRegisterController.mobile_num = '9212155244';
        objacfCustomerRegisterController.confirmPassword = 'testing@007';
        objacfCustomerRegisterController.strProductLVRId = lstpro[0].id;
        objacfCustomerRegisterController.pList = lstpro;
        objacfCustomerRegisterController.objLead = objL1;
        
        objcommunity= new Click_Community_Setup__c();
        objcommunity.Name = 'Click';
        insert objcommunity;
        
        objDocumentMaster.Click_Community_Setup__c=objclcmm.id;
        update objDocumentMaster;
        WLCustomerRegisterController.generateReqDocs(objL1.Id,objclcmm);

        objacfCustomerRegisterController.Login(); 
        objacfCustomerRegisterController.showResendOTPfrm();   
        objacfCustomerRegisterController.VerifyEmail();
        objacfCustomerRegisterController.IsUserAlreadyExist();
        objacfCustomerRegisterController.username='testtest';
        objacfCustomerRegisterController.Registration();
            
        objacfCustomerRegisterController.resendOTP();
        objacfCustomerRegisterController.OK();
        objacfCustomerRegisterController.RedirectToLandingPage();
        objacfCustomerRegisterController.DisplayEstimatedSaving(5.0,3.0,12000,null,10);
        Test.stopTest();
        
  }   */
  
  private static void LoadData()
  {
    createAccount();
    createContact();
    createUser(); 
   // createUser1();
    createOpportunity();
    createProfile();
    createMortgageExpert();
     createAssetAndLiability();
     createclickApplicant();
    //createprofile();
      createBankDetail();
    createProduct();
    createacfSuggestedProduct();
    createclickCommunitySetup();
  
    createClickloan();
    createBankQuestions() ;
    createDocumentMaster();
    createRequiredDocument();
  }
  
  static void createuser()
  {    
         objuser= new User();
         objLead = WLCommonTrackerClass.createLeadForPortal();
         objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
         objuser    =  WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
         
   //      objuser = [select id,name,AccountID from User where profile.name = 'Community User' limit 1];
 //       objuser.ContactId = objContact.id;
  //      objUser = acfCommontrackerClass.createuser(objUser,objContact,objAccount);
     
  }
    /*
   static void createUser1()
   {
       objuser1=new User();
       objuser1=WLCommonTrackerClass.CreateUser(objuser1);
   }
  
 static void createProfile()
  {
      objUserProfile=new Profile();
      objUserProfile=WLCommonTrackerClass.createProfile('Community User');
  }*/
  
 static void createprofile()
  {
    objProfile = new Profile();
    objProfile =[Select id,Name from Profile where name='Community User' limit 1];
  }
   static void createAccount()
  {
    objAccount= new Account();
    objAccount.Lastname = 'Test';
    objAccount.PersonMobilePhone = '9866754678'; 
    objAccount.PersonEmail = 'sonalaggarwal@saasfocus.com';
    
    objAccount = WLCommonTrackerClass.CreatePersonAccount('Test','Last','+619899512039','test@gmail.com',null);   
    
  }
  
  static void createclickApplicant()
    {
         objclickappl=new click_Applicant__c();
         objclickappl= WLCommonTrackerClass.createApplicant(objclickappl,objaccount,objOpportunity);
    }
  
   static void createAssetAndLiability()
    {
        objassetli=new Asset_And_Liability__c ();
        objassetli=WLCommonTrackerClass.createAssetandLiablility(objassetli,objaccount);
  }
  static void createContact()
  {
    objContact = new Contact();
    //objContact.AccountId  = '001x000xxx35tPN';
    objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    
  }
  static void  createMortgageExpert()
    {
      objMortgageExpert= new MortgageExpert__c();
      objMortgageExpert = WLCommonTrackerClass.createMortgageExpert(objMortgageExpert);
    }
  
    static void  createproduct()
    {
      objProduct2= new Product2();
      objProduct2.Click_Loans_Bank_Detail__c = objBank.id;
      objProduct2 = WLCommonTrackerClass.createproduct(objProduct2);       
    }
    
    static void  createacfSuggestedProduct()
    {
    objacfSuggested=new acfSuggested_Product__c();
    objacfSuggested=WLCommonTrackerClass.createacfSuggestedProduct();
    
    }
   
    
    static void createBankQuestions() 
    {
    objBankQuestions=new acfBank_Information__c();
    objBankQuestions=WLCommonTrackerClass.createBankQuestions(); 
    }
    
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }

     static void createDocumentMaster()
    {
      objDocumentMaster = new Document_Master__c();
      objDocumentMaster = WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
  
    }
    
     static void createclickCommunitySetup() 
    {
        objclcmm= new Click_Community_Setup__c();
        objclcmm= WLCommonTrackerClass.createcommunitysetup();
       // objclcmm= ClickCommon.getCommunitySetup('');
    }
    
    static void createRequiredDocument()
    {
        objRequiredDocument = new Required_Document__c ();      
        objRequiredDocument = WLCommonTrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMaster,objOpportunity);
        
        system.debug('objRequiredDocument'+objRequiredDocument);
    }
    
    static void createBankDetail()
    {
        objBank = new acfBank_Detail__c();
        objBank =  WLCommonTrackerClass.createBankDetail();
    }
    
     static void createClickloan()
    {
         objclickloan=new Click_Loans_Bank__c();
        objclickloan=WLCommonTrackerClass.createClickloan(objBank,objclcmm);
    }
    
   /* static testMethod void ValidateRegistration02()
    {
        LoadData();
        test.starttest();
        Lead objL = new Lead();        
        objL.FirstName = '+619654922845';
        objL.LastName = '+619654922845';
        objL.Email = 'swati.sharma@saasfocus.com';
        objL.MobilePhone = '+619654922845';
        objL.Status = 'Open';
        objL.acfOneTimePassword__c = '724715';
        objL.acfIsMobileVerified__c =true;
        objL.acf_partner_account__c = objAccount.id;
        objL.acfLoan_Amount__c = 1000.00;
        objL.acfCurrentRate__c = 3;
        objL.acfWhat_is_your_current_payment_type__c = 'Cash';
        objL.acfApproximately_how_much_is_your_house__c = 2000.00;
        objL.acfIs_User_Registered__c = false;
        insert objL;
        
        objProduct2.recordtypeid = ClickCommon.GetRecordTypeId('product2','Fixed');
        objProduct2.acfTenure_in_Years__c = '3';
        objProduct2.acfvarTenure_In_Years__c = 3;
        objProduct2.Family='none';
        update objProduct2;
        
        LVR_Rate__c objLVR = new LVR_Rate__c();
        objLVR.acfLVR__c = 100;
        objLVR.acfRate__c = 10.25;
        objLVR.acfProduct__c = objProduct2.id;
        objLVR.acfLoan_Size__c = 10000000;
        objLVR.ACF_Comparison_Rate__c = 10.00; 
        objLVR.clickFixed_Interest_Rate__c = 9.00;
        objLVR.clickLoan_Size_From__c = 0;
        objLVR.clickLVR_From__c = 0;
        objLVR.acfApplication_Fee__c = 5000;        
        insert objLVR; 
        
        WLCustomerRegisterController.WrapperProducts wrap = new WLCustomerRegisterController.WrapperProducts();
        wrap.decRate = 10.01;
        wrap.strRateType ='test';
        wrap.decComparisionRate = 10.01;
        wrap.decApplicationFee = 10.50;
        wrap.strcomparisionType ='Fixed';
        wrap.decMonthlyPayment = 100;
        wrap.intTenureYrs = 1;
        wrap.strRating = 'good';
        wrap.ProductId = objProduct2.id;
        wrap.ProdLVRID = objLVR.id;
        wrap.IndexNo = 1;
        list<integer> lstint = new list<integer>();
        lstint.add(1);
        lstint.add(2);
        wrap.lstProductRating = lstint;
        wrap.IsDisplayHalfStar = true;
        wrap.EstimatedMonthlySaving = 10.11;
        wrap.strProdName = 'bottle';
        
        acfContentManagementSystem__c objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'ClickHome';
        objContentManagementSystem.acfSectionName__c = 'Registration Popup';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        insert objContentManagementSystem;
        
        objScript     = WLCommonTrackerClass.createScript('Post-Login');//string strQuestion,Integer NewsequenceNo,string strType,boolean IsRefinence,boolean IsNew,Id ScriptID
        system.debug('!@#$%'+objScript.id);
        objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,objL.FirstName);
        objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,objL.FirstName);
        objQuestion   = WLCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,objL.FirstName);
        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
            
        Cookie ACFAnswers = new Cookie('ACFAnswers','acfPostcode__c'+'-:-'+201435+'-,-',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{ACFAnswers});
        Cookie LeadId = new Cookie('LeadId',''+objL.id+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{LeadId});
        Cookie strUserId = new Cookie('strUserId',''+userinfo.getuserid()+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{strUserId});
        Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','false',null,72000,true);        
        ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
        Cookie ACFRequiredDocumentsAnswers = new Cookie('ACFRA',strSelectedAnswers,null,72000, false); 
        ApexPages.currentPage().setCookies( new Cookie[]{ACFRequiredDocumentsAnswers});
        
        Cookie ACFLeadApiNames = new Cookie('ACFLeadApiNames',''+objQuestion+'-:-'+objQuestion+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{ACFLeadApiNames});
                
        Cookie currentUId = new Cookie('currentUId ',''+userinfo.getuserid()+'','true',72000, false);
        currentUId =null;
        ApexPages.currentPage().setCookies( new Cookie[]{currentUId });
        
        WLCustomerRegisterController objacfCustomerRegisterController = new WLCustomerRegisterController();
        objacfCustomerRegisterController.username = 'swati.sharma_1@saasfocus.com';
        objacfCustomerRegisterController.password = 'swatisharma10';
        objacfCustomerRegisterController.mobile = '9212155244';
        objacfCustomerRegisterController.mobile_otp = '724715';
        objacfCustomerRegisterController.mobile_num = '9212155244';
        objacfCustomerRegisterController.strTimezoneId = 'Asia/Kolkata';
        objacfCustomerRegisterController.showformVar =false;
        objacfCustomerRegisterController.lstCommunity = objclcmm;
        
        objcommunity= new Click_Community_Setup__c();
        objcommunity.Name = 'Click';
        insert objcommunity;
        
        WLCustomerRegisterController.generateReqDocs(objL.Id,objclcmm);
        
        objacfCustomerRegisterController.getProductIdslist();
        objacfCustomerRegisterController.Login(); 
        objacfCustomerRegisterController.showResendOTPfrm();   
        objacfCustomerRegisterController.VerifyEmail();
        objacfCustomerRegisterController.IsUserAlreadyExist();
        
        objacfCustomerRegisterController.username='testtest';
        objacfCustomerRegisterController.Registration();
        objacfCustomerRegisterController.userId = objuser.id;
        objL.acfLoan_Amount__c = 12345.00;
        objL.acfApproximately_how_much_is_your_house__c = 21273.00;
        
        update objL;
        objacfCustomerRegisterController.objLead = objL;
        objtwilio=new Twilio__c();
        objtwilio.name='Twilio';
        objtwilio.Twilio__c=false;
        insert objtwilio;
        objAccount.Click_Community_Setup__c=objclcmm.id;
        
        update objAccount;
        
        test.stoptest();
        objacfCustomerRegisterController.SendSmsAfterRegistration();
        
        objacfSuggested.acfProduct__c=objProduct2.id;
        objacfSuggested.acfLead__c=objL.id;
        update objacfSuggested;
        
        objacfCustomerRegisterController.istermsConditionsConfirmed = true;      
        objacfCustomerRegisterController.verifyOTP();
        objacfCustomerRegisterController.mobile_num = '+918896292603';     
        objacfCustomerRegisterController.resendOTP();
        objacfCustomerRegisterController.OK();
        objacfCustomerRegisterController.RedirectToLandingPage();
        objacfCustomerRegisterController.redirect();
        objacfCustomerRegisterController.DisplayEstimatedSaving(5.0,3.0,12000,'Interest Only',10);
        
    }*/
 
}