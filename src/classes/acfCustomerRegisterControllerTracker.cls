@isTest(seealldata=false)
private class acfCustomerRegisterControllerTracker 
{
  static private Lead objLead;
  static private User objUser;
  static private Profile objUserProfile;
  private static string USER_PROFILE_NAME = 'Community User';
  private static Contact objContact;
  private static Account objAccount;
  private static MortgageExpert__c objMortgageExpert;
  private static Profile objProfile;
  private static Product2 objProduct2;
  private static Required_Document__c objRequiredDocument;
  private static Document_Master__c objDocumentMaster;
  private static Opportunity objOpportunity;
  private static Script__c objScript;
  private static Question__c objQuestion;
  private static Answer__c objAnswer;
  
   static testMethod void ValidateRegistration()
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
        
 /*     RecordType objRT=[select id, name, SObjectType From RecordType Where SObjectType= 'product2' AND name= 'Variable'];
        product2 objPro = new product2();
        objPro.ACF_Comparison_Rate__c = 10;
        objPro.IsActive = true;
        objPro.acfType__c = 'Variable';
        objPro.Recordtype.Name = 'Variable';
        objPro.acfTenure_in_Years__c = '2'; 
        objPro.acfvarTenure_In_Years__c = 10;
        objPro.clickLoan_Type__c =  'Basic';
        objPro.acfOffset_Account__c = false;
        objPro.Name = 'test';
       // objPro.acfRating__c = '1';
        insert objPro;*/
        
        objProduct2.recordtypeid = acfCommon.GetRecordTypeId('product2','Fixed');
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
        
        acfCustomerRegisterController.WrapperProducts wrap = new acfCustomerRegisterController.WrapperProducts();
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
        
        objScript     = acfCommonTrackerClass.createScript('Post-Login');//string strQuestion,Integer NewsequenceNo,string strType,boolean IsRefinence,boolean IsNew,Id ScriptID
        system.debug('!@#$%'+objScript.id);
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,objL.FirstName);
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Button',true,false,objScript.id,objL.FirstName);
        objQuestion   = acfCommonTrackerClass.CreatePrePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,objL.FirstName);
        objAnswer     = acfCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
                        
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

      //  acfCustomerRegisterController.generateReqDocs(LeadId.getvalue());
        
        acfCustomerRegisterController objacfCustomerRegisterController = new acfCustomerRegisterController();
        objacfCustomerRegisterController.username = 'swati.sharma_1@saasfocus.com';
        objacfCustomerRegisterController.password = 'swatisharma10';
        objacfCustomerRegisterController.mobile = '9212155244';
        objacfCustomerRegisterController.mobile_otp = '724715';
        objacfCustomerRegisterController.mobile_num = '9212155244';
        objacfCustomerRegisterController.strTimezoneId = 'Asia/Kolkata';
        objacfCustomerRegisterController.showformVar =false;
        
        
        objacfCustomerRegisterController.getProductIdslist();
        objacfCustomerRegisterController.Login(); 
        objacfCustomerRegisterController.showResendOTPfrm();   
        objacfCustomerRegisterController.VerifyEmail();
        objacfCustomerRegisterController.IsUserAlreadyExist();
        
        objacfCustomerRegisterController.Registration();
        objacfCustomerRegisterController.userId = objuser.id;

        objacfCustomerRegisterController.SendSmsAfterRegistration();
        objacfCustomerRegisterController.DisplayTop3Products(objL.id) ; 
        objacfCustomerRegisterController.istermsConditionsConfirmed = true;      
        objacfCustomerRegisterController.verifyOTP();
        objacfCustomerRegisterController.mobile_num = '+918896292603';     
        objacfCustomerRegisterController.resendOTP();
        objacfCustomerRegisterController.OK();
        objacfCustomerRegisterController.RedirectToLandingPage();
        objacfCustomerRegisterController.redirect();
        objacfCustomerRegisterController.DisplayEstimatedSaving(5.0,3.0,12000,'Interest Only',10);
        
  }
  
   static testMethod void ValidateRegistration01()
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
        
        objProduct2.recordtypeid = acfCommon.GetRecordTypeId('product2','Variable');
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

        
        acfCustomerRegisterController objacfCustomerRegisterController = new acfCustomerRegisterController();
        objacfCustomerRegisterController.username = 'swati.sharma_1@saasfocus.com';
        objacfCustomerRegisterController.password = 'swatisharma10';
        objacfCustomerRegisterController.mobile = '9212155244';
        objacfCustomerRegisterController.mobile_otp = '724715';
        objacfCustomerRegisterController.mobile_num = '9212155244';
        objacfCustomerRegisterController.strTimezoneId = 'Asia/Kolkata';
        objacfCustomerRegisterController.showformVar =false;
        
        objacfCustomerRegisterController.Login(); 
        objacfCustomerRegisterController.showResendOTPfrm();   
        objacfCustomerRegisterController.VerifyEmail();
        objacfCustomerRegisterController.IsUserAlreadyExist();
        objacfCustomerRegisterController.Registration(); 
        objacfCustomerRegisterController.SendSmsAfterRegistration();
        objacfCustomerRegisterController.DisplayTop3Products(objL.id) ; 
        objacfCustomerRegisterController.istermsConditionsConfirmed = true;      
        //objacfCustomerRegisterController.verifyOTP();    
        objacfCustomerRegisterController.resendOTP();
        objacfCustomerRegisterController.OK();
        objacfCustomerRegisterController.RedirectToLandingPage();
        objacfCustomerRegisterController.DisplayEstimatedSaving(7.0,9.0,16000,'Interest Only',10);
        
  }
  

  
    static testMethod void ValidateRegistration1()
  {
        LoadData();
        Cookie ACFAnswers = new Cookie('ACFAnswers','acfPostcode__c'+'-:-'+201435+'-,-',null,72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{ACFAnswers});
/*        Cookie LeadId = new Cookie('LeadId',''+objLead.id+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{LeadId});
        Cookie strUserId = new Cookie('strUserId',''+objuser.id+'','true',72000, false);
        ApexPages.currentPage().setCookies( new Cookie[]{strUserId});*/
        Lead objL = new Lead();
        objL.FirstName = '+619654922845';
        objL.LastName = '+619654922845';
        objL.Email = 'swati.sharma@saasfocus.com';
        objL.MobilePhone = '+619654922845';
        objL.Status = 'Open';
        objL.acfOneTimePassword__c = '724715';
        objL.acfIsMobileVerified__c = true;
        objL.acf_partner_account__c = objAccount.id;
        objL.acfLoan_Amount__c = 1000.00;
        objL.acfCurrentRate__c = 3;
        objL.acfWhat_is_your_current_payment_type__c = 'Cash';
        objL.acfApproximately_how_much_is_your_house__c = 2000.00;
        insert objL;
        
        list<product2> lstpro = new list<product2>();
        
        product2 objProduct = new product2();
        objProduct.ACF_Comparison_Rate__c = 10;
        objProduct.IsActive = true;
        objProduct.Name = 'test';
      //  objProduct.acfRating__c = '1';
        lstpro.add(objProduct);
        
        
        
        
        acfCustomerRegisterController objacfCustomerRegisterController = new acfCustomerRegisterController();
        objacfCustomerRegisterController.username = 'swati.sharma@saasfocus.com';
        objacfCustomerRegisterController.password = 'swatisharma10';
        objacfCustomerRegisterController.mobile = '9212155244';
        objacfCustomerRegisterController.mobile_otp = '724715';
        objacfCustomerRegisterController.mobile_num = '9212155244';
        objacfCustomerRegisterController.confirmPassword = 'testing@007';
        objacfCustomerRegisterController.strProductLVRId = lstpro[0].id;
        objacfCustomerRegisterController.pList = lstpro;
        objacfCustomerRegisterController.objLead = objL;
        
        

        objacfCustomerRegisterController.Login(); 
        objacfCustomerRegisterController.showResendOTPfrm();   
        objacfCustomerRegisterController.VerifyEmail();
        objacfCustomerRegisterController.IsUserAlreadyExist();
        
        //user guestUser = acfCommonTrackerClass.CreatePortalUser(objAccount.id);
       
             objacfCustomerRegisterController.Registration();
             objacfCustomerRegisterController.SendSmsAfterRegistration();
       
            
        objacfCustomerRegisterController.resendOTP();
        objacfCustomerRegisterController.OK();
        objacfCustomerRegisterController.RedirectToLandingPage();
        objacfCustomerRegisterController.DisplayEstimatedSaving(5.0,3.0,12000,null,10);
        
  }
  
  private static void LoadData()
  {
    createAccount();
    createContact();
    createUser(); 
 //   createOpportunity();
    createMortgageExpert();
    createprofile();
    createProduct();
    createDocumentMaster();
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
  
  static void createprofile()
  {
    objProfile = new Profile();
    objProfile =[Select id,Name from Profile where name='Community User' limit 1];
  }
   static void createAccount()
  {
    objAccount= new Account(); 
    //objAccount.     
    objAccount = acfCommonTrackerClass.createAccount(objAccount);
    
  }
  
  static void createContact()
  {
    objContact = new Contact();
    //objContact.AccountId  = '001x000xxx35tPN';
    objContact = acfCommonTrackerClass.createContact(objContact,objAccount);
    
  }
  static void  createMortgageExpert()
    {
      objMortgageExpert= new MortgageExpert__c();
      objMortgageExpert = acfCommonTrackerClass.createMortgageExpert(objMortgageExpert);
    }
  
     static void  createproduct()
    {
      objProduct2= new Product2();
      objProduct2 = acfCommonTrackerClass.createproduct(objProduct2);      
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }

     static void createDocumentMaster()
    {
      objDocumentMaster = new Document_Master__c();
      objDocumentMaster = acfCommontrackerClass.createDocumentMaster(objDocumentMaster);
  
    }
    
    static void createRequiredDocument()
    {
        objRequiredDocument = new Required_Document__c ();      
        objRequiredDocument = acfCommontrackerClass.createRequiredDocument(objRequiredDocument,objDocumentMaster,objOpportunity);
        
        system.debug('objRequiredDocument'+objRequiredDocument);
    }
    
}