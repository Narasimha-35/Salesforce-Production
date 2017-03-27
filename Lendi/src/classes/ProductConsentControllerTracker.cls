@isTest(seeAllData = true)
public class ProductConsentControllerTracker {
    
    private static Account objAccount;
    private static Opportunity objOpportunity;
    private static User objUser;
    private static Contact objContact;
    private static Click_Applicant__c oppClick;
    private static Click_Community_Setup__c clickSetup;
    private static acf_Bank_Template__c banktemp;
    private static  E_Consent__c eObj;
    private static Document_Master__c docObj;
    private static Required_Document__c rdocs;
    
    static testMethod void validate(){
        LoadData();
           string encodedDate=string.valueOf(System.currentTimeMillis());
           acfBank_Detail__c acfBank = new acfBank_Detail__c();
          // acfBank.acfBank_Name__c = 'bank';
           insert acfBank ;
          
            acf_Bank_Template__c  ccc= new acf_Bank_Template__c();
            ccc.Body__c ='';
           ccc.Click_Loans_Bank_Detail__c=    acfBank .ID;
           insert ccc;
           
            rdocs.Bankid__C = ccc.iD ;
            Update rdocs;
          String  econsentId=encodedDate+'-'+ oppClick.Id+'-'+banktemp.id+'-'+rdocs.Id+'-'+eObj.ID;
          system.debug('###'+econsentId);
                                         
                            
        ApexPages.currentPage().getParameters().put('EconsentId',econsentId);
        ProductConsentController obj = new ProductConsentController();
        obj.updateConsentScreen();
    }
    private static void LoadData(){
        createAccountObj();
        createContactObj();
        createUser();
        createOpportunityObj();
        createClickApplicantObj();
        createEConsentObj();
        createClickCommunitySetupObj();
        createBankTampletesObj();
        createDocumentMasterObj();
        createRequiredDocumentObj();
    }
    static void createAccountObj(){
        objAccount = new Account();
        objAccount = new Account();
        objAccount.acfApproximately_how_much_is_your_house__pc = 10000000;
        objAccount.acfAsset_House_Worth__c = 765;
        objAccount = WLCommonTrackerClass.createAccount(objAccount);
    }
    static void createContactObj(){
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objAccount);
    }
     static void createUser(){
        objUser = new User();
        objuser.ContactId = objContact.id;
        objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
    }
    static void createOpportunityObj(){
      objOpportunity = new Opportunity();
      objOpportunity.accountid=  objAccount.Id;
      objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
    }
    static void createClickApplicantObj(){
        oppClick = new Click_Applicant__c();
        oppClick = WLCommonTrackerClass.createApplicant(oppClick,objAccount,objOpportunity);
    }
    static void createEConsentObj(){
        eObj = new E_Consent__c();
        eObj = WLCommonTrackerClass.createEconsent(oppClick);
    }
    static void createClickCommunitySetupObj(){
        clickSetup = new Click_Community_Setup__c();
        clickSetup = WLCommonTrackerClass.createcommunitysetup();
        clickSetup.Click_Page_Prefix__c='ACF';
        update clickSetup;
    }
    static void createBankTampletesObj(){
    acfBank_Detail__c acfBank = new acfBank_Detail__c();
          // acfBank.acfBank_Name__c = 'bank';
           insert acfBank ;
         bankTemp = new acf_Bank_Template__c();
        // bankTemp.Bank_Name__c = 'ING Direct1';
         bankTemp.Click_Loans_Bank_Detail__c=    acfBank .ID;
         bankTemp.Body__c='This is for ING Direct1';
         insert banktemp;
         
           
          
            
    }
    static void createDocumentMasterObj(){
        docObj = new Document_Master__c();
        docObj = WLCommonTrackerClass.createDocumentMaster(docObj);
    }
    static void createRequiredDocumentObj(){
        rdocs = new Required_Document__c();
        rdocs = WLCommonTrackerClass.createRequiredDocument(rdocs, docObj, objOpportunity);
    }
    
}