@isTest
private class WLQuoteDetailTracker
{
    private static Lead objLead ;
    private static User objUser;
    private static Click_Community_Setup__c objcommunity;
    private static account accperson;
    private static account objAccount;
    private static Contact objContact;
    private static Opportunity objOpportunity;
    private static acfSuggested_Product__c objSuggestedProduct;
    private static acfBank_Detail__c objBankDatail;
    private static product2 objProduct;
    private static product2 objProducts;
    private static LVR_Rate__c objLvrRate;
    private static Script__c scobj;
    private static Click_Loans_Bank__c objClickLoanBankDetail;
    private static Question__c  objQuestion;
    

    static testMethod void validate1()
    {
        LoadData();            
        PageReference pageRef =Page.ClickPostloginQuestionnaires;
        Test.setCurrentPage(pageRef);
        system.runas(objUser)
        {
            WLQuoteDetail wlobj=new WLQuoteDetail ();
            wlobj.pge_name='ClickPostloginQuestionnaires';
            WLQuoteDetail.setProgressBarWidth(11,22,'ClickPostloginQuestionnaires','test');
        }      
    }
    static testMethod void validate2()
    {
        LoadData();
        PageReference pageRef = Page.ClickBankInfoDetails;
        Test.setCurrentPage(pageRef);
        system.runas(objUser)
        {
            WLQuoteDetail wlobj=new WLQuoteDetail ();
            wlobj.pge_name='ClickBankInfoDetails';
            WLQuoteDetail.setProgressBarWidth(11,22,'ClickBankInfoDetails','test');
        }
    }
    
    static testMethod void validate3()
    {
        LoadData();
        PageReference pageRef = Page.ClickPreLoginQuestions;
        Test.setCurrentPage(pageRef);
        system.runas(objUser)
        {
            WLQuoteDetail wlobj=new WLQuoteDetail ();
            wlobj.pge_name='ClickPreLoginQuestions';
            WLQuoteDetail.setProgressBarWidth(11,22,'ClickPreLoginQuestions','test');
        }
    }
    
    static testMethod void validate4()
    {
        LoadData1();            
        PageReference pageRef =Page.ClickPostloginQuestionnaires;
        Test.setCurrentPage(pageRef);
        system.runas(objUser)
        {
            WLQuoteDetail wlobj=new WLQuoteDetail ();
            wlobj.pge_name='ClickPostloginQuestionnaires';
        }      
    }
    
    private static void LoadData()
    {
        createclickCommunitySetup();
        createLead(); 
        CreatePersonAccount();      
        createContact();
        createUser();
        createProducts();
        createProduct();
        createsuggestedProducts();
        createbankDetails();
        createLvrRate();
        createScript();
        createQuestion();
        createClickLoanBankDetails();
        createOpportunity1();
        
    }
    
    private static void LoadData1()
    {
        createLead1(); 
        CreatePersonAccount1(); 
        createclickCommunitySetup();
        createContact();
        createUser();
        createProducts();
        createProduct();
        createsuggestedProducts(); 
        createOpportunity1();   
    }
   
    static void createLead()
    {
        objLead = new Lead();
        Id recorsTypeId  = ClickCommon.GetRecordTypeId('Lead','Click Refi');
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
        objLead.acfIs_Post_Login_Ques_Attempted__c =true;
        insert objLead;
    }

    static void createLead1()
    {
        objLead = new Lead();
        Id recorsTypeId  = ClickCommon.GetRecordTypeId('Lead','Click New Loans');
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
        objLead.acfIs_Post_Login_Ques_Attempted__c =true;
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
       update accperson;
       objLead.acf_partner_account__c=accperson.id;
       update objLead;
    }
    
     static void createclickCommunitySetup() 
    {
        objcommunity = new Click_Community_Setup__c();
        objcommunity = WLCommontrackerClass.createcommunitysetup();
    }
    
    static void createsuggestedProducts() 
    {
         objSuggestedProduct               = new acfSuggested_Product__c();
         objSuggestedProduct.acfLead__c    = objLead.Id;
         objSuggestedProduct.acfProduct__c = objProduct.id;
         objSuggestedProduct = WLCommontrackerClass.createSuggestedProduct();
    }
    
    static void createbankDetails() 
    {
         objBankDatail =new acfBank_Detail__c();
         objBankDatail = WLCommontrackerClass.createBankDetail();
    }
    
    static void createProducts() 
    {
         objProduct = new product2();
         objProduct = WLCommontrackerClass.createProduct(objProduct);
    }
    
    static void createProduct() 
    {
         objProducts = new product2();
         objProducts = WLCommontrackerClass.createProduct(objProducts);
    }
    
    static void createLvrRate() 
    {
         objLvrRate = new LVR_Rate__c();
         objLvrRate= WLCommontrackerClass.createLvrRate(objProduct);
    }
    
    static void createScript() 
    {
        scobj = new Script__c();
        scobj.recordtypeid = Schema.SObjectType.Script__c.getRecordTypeInfosByName().get('Post-Login').getRecordTypeId();
        scobj.acf_Type__c          = 'Post-Login';
        scobj.acf_Sequence_no__c   = 1;
        scobj.acf_Question_Type__c = 'Applicant Details';
        scobj.Click_Community_Setup__c = ClickCommon.getCommunitySetup('testNetworkId').Id;
        insert scobj;
    }
    
    static void createClickLoanBankDetails() 
    {
         objClickLoanBankDetail = new Click_Loans_Bank__c();
         objClickLoanBankDetail = WLCommontrackerClass.createClickloan(objBankDatail,objcommunity);
    }
    
    static void createQuestion() 
    {
         objQuestion = new Question__c();
         objQuestion = WLCommontrackerClass.CreatePostLoginQuestions('Who is your current Lender',2,'Post-Login',true,true,scobj.id,'acfApproximately_how_much_is_your_house__c','Question__c',false,'acfAsset_House_Worth__c',true,true);
    }
}