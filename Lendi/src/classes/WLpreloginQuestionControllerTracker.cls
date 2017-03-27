@isTest
public class WLpreloginQuestionControllerTracker
{
    private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static product2 objPro;
    private static PriceBookEntry pbEntry;
    private static OpportunityLineItem oppLine;
    private static Click_Community_Setup__c  cmmset;
    private static Script__c objScript;
    private static Question__c  objQuestion;
    private static Question__c  MasobjQuestion;
    private static Document_Master__c objDocumentMaster;
    private static Answer__c ansobj;
    
    static testMethod void validate()
  {
    LoadData();
  
    ApexPages.currentPage().getParameters().put('utm_source','test');
    ApexPages.currentPage().getParameters().put('utm_medium','test1');
    ApexPages.currentPage().getParameters().put('utm_term','test2');
    ApexPages.currentPage().getParameters().put('utm_content','test3');
    ApexPages.currentPage().getParameters().put('utm_campaign','test4');
    ApexPages.currentPage().getParameters().put('type','refi');
    
    Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','true','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
    
           
    Cookie Bname= new Cookie('Bname','true','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{Bname});
    
    Cookie WLACFQuestions= new Cookie('WLACFQuestions','true','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{WLACFQuestions});

    cmmset.Click_Support_Team_Name__c='test';
    cmmset.Click_Page_Prefix__c=null;
    update cmmset;
      
    WLpreloginQuestionController wlobj=new WLpreloginQuestionController();
   
   
  }
   static testMethod void validate1()
  {
    LoadData();
  
     ApexPages.currentPage().getParameters().put('utm_source','test');
     ApexPages.currentPage().getParameters().put('utm_medium','test1');
     ApexPages.currentPage().getParameters().put('utm_term','test2');
     ApexPages.currentPage().getParameters().put('utm_content','test3');
     ApexPages.currentPage().getParameters().put('utm_campaign','test4');
     ApexPages.currentPage().getParameters().put('type','test4');
    
     Cookie clickACFQues= new Cookie('clickACFQues','true','true',72000, true); 
     ApexPages.currentPage().setCookies( new Cookie[]{clickACFQues});
     
         
     Cookie Bname= new Cookie('Bname','true','true',72000, true); 
     ApexPages.currentPage().setCookies( new Cookie[]{Bname});
      
     cmmset.Click_Support_Team_Name__c='test';
     update cmmset;
    
     acfBank_Detail__c bnkobj=new acfBank_Detail__c();
     bnkobj.click_Show_on_Current_Lender_question__c=true;
    bnkobj.acfBank_Name__c='testing';
    insert bnkobj;
      
    WLpreloginQuestionController wlobj=new WLpreloginQuestionController();
    wlobj.RelatedQuestions();    
    wlobj.previousQuestion();
    WLpreloginQuestionController.AutoCompleteBanklList('test');
    wlobj.IsValidId('test');
    wlobj.resumePreviousSession();
    wlobj.clearCookies();
   
  }
  
  static testMethod void validate3()
  {
    LoadData1();
    Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','true','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
     
    Cookie Bname= new Cookie('Bname','true','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{Bname});
    try
    {
    Cookie ClickACFQues= new Cookie(null,'true','true',72000, true); 
    ApexPages.currentPage().setCookies( new Cookie[]{ClickACFQues});
    }
    catch(exception ex)
    {} 
    WLpreloginQuestionController wlobj=new WLpreloginQuestionController();
  }
  
    private static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
        createUser();
        createOpportunity();
        createProduct();
        createPriceBookEntry();
        createOpportunityLineItem();
        createcommunitysetup();
        createScript();
        createMasquestion();
        createquestion();
        CreateDocumentMaster();
        createAnswer();
       
   } 
   
   private static void LoadData1()
   {
        createcommunitysetup();
        createScript();
        createMasquestion();
        createquestion();
        CreateDocumentMaster();
        createAnswer();
    }      
   
        static void createLead()
      {
    
        objLead=new Lead();
        objLead=WLCommonTrackerClass.createLead(objLead);
   }
    
    static void createAccount()
    {
        objAccount = new Account();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','88','test@gmail.com',objLead.id);
        objAccount.acfAsset_House_Worth__c=55;
        update objAccount; 
    }
    
    static void createContact()
     {
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount );
   }
    
    static void createuser()
    {
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();

      
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
      objOpportunity.AccountId = objAccount.id;
      objOpportunity.acfLoan_Amount_c__c=3000;
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity.acfApproximately_how_much_is_your_house__c=90;
      objOpportunity.create_from_custom_clone_button__c=true;
      objOpportunity.acfAsset_House_Worth__c=20;
      update objOpportunity;
    }
    static void createProduct()
    {
       objPro=new product2();
       objPro=WLCommonTrackerClass.createProduct(objPro);
  }
     static void createPriceBookEntry()
    {
        pbEntry = new PriceBookEntry();
        pbEntry.UnitPrice = 300;
        pbEntry.PriceBook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = objPro.Id;
        pbEntry.IsActive = true;
        insert pbEntry ; 
    }
    
     static void createOpportunityLineItem()
    {
        oppLine = new OpportunityLineItem();
        oppLine.pricebookentryid=pbEntry.Id;
        oppLine.TotalPrice=2000;
        oppLine.Quantity = 2;
        oppLine.lender__c='test';
        oppLine.OpportunityID = objOpportunity.Id;
        insert oppLine;
   }
    static void createcommunitysetup()
    {
       cmmset= new Click_Community_Setup__c ();
       cmmset=WLCommonTrackerClass.createcommunitysetup();
       
  }
   static void createScript()
   {
        objScript = new Script__c();
        objScript.recordtypeid =Schema.SObjectType.Script__c.getRecordTypeInfosByName().get('Pre-Login').getRecordTypeId();
        objScript.acf_Type__c ='Pre-Login';
        objScript.acf_Sequence_no__c   = 1;
        objScript.acf_Question_Type__c = 'Applicant Details';
        objScript.Click_Community_Setup__c =cmmset.id;
        insert objScript;
   }
   static void createquestion()
   {
        objQuestion=new Question__c();
        objQuestion.acf_Question__c = 'Who is your current lender?';
        objQuestion.acf_Active__c = true;
        objQuestion.acf_Sequence_No__c = 2.0;
        objQuestion.acf_Type__c = 'Button';
        objQuestion.acfRefinance_Sequence_No__c = 1;
        objQuestion.acfIs_refinance__c = true;
        objQuestion.acfIs_New_Loan__c=true;
        objQuestion.Click_Is_Broker_Question__c=false;
        objQuestion.acf_Master_Question__c=MasobjQuestion.id;
        objQuestion.acfBubble_Text__c='test';        
        insert objQuestion;
        
   }
    static void createMasquestion()
   {
        MasobjQuestion=new Question__c();
        MasobjQuestion.acf_Question__c = 'Who is your current lender?';
        MasobjQuestion.acf_Active__c = true;
        MasobjQuestion.acf_Sequence_No__c = 2.0;
        MasobjQuestion.acf_Type__c = 'Text';
        MasobjQuestion.acfRefinance_Sequence_No__c = 1;
        MasobjQuestion.acfIs_refinance__c = true;
        MasobjQuestion.acfIs_New_Loan__c=true;
        MasobjQuestion.Click_Is_Broker_Question__c=false;
        MasobjQuestion.acf_Script__c=objScript.id;
        //objQuestion.acf_Script__c = objScript1.id;
        insert MasobjQuestion;
   }
   static void CreateDocumentMaster()
  {
   objDocumentMaster=new Document_Master__c();
   objDocumentMaster=WLCommonTrackerClass.createDocumentMaster(objDocumentMaster);
   }
   
   static void createAnswer()
   {
   ansobj=new Answer__c();
   ansobj=WLCommonTrackerClass.createAnswer(objQuestion.id,objQuestion.id,'test');
   }
   
}