@isTest

public class clsSendEmailNotificationTracker{

private static Lead objLead;
private static Account objAccount;
private static Account objpersonAccount;
private static User objUser;
private static Opportunity objOpp;
private static Opportunity objOpp1;
private static Market__c objMarket;
private static Broker__c objBroker;
private static List<Opportunity> lstOpp;
private static Product2 objProduct2;
private static PriceBook2 objPricebook;
private static PricebookEntry objPricebookEntry;
private static OpportunityLineItem objLineItem;
private static List<OpportunityLineItem> lstLineItem;
private static Funding_Position__c objfunding;
private static click_Applicant__c objClickApp;
 private static LVR_Rate__c objLVR;

    
    public static testMethod void validate1()
    {
        LoadData();
        objClickApp.Applicant_Email__c = 'test@gmail.com';
        
        
        update objClickApp;
        objBroker.Channel__c = 'Partner';
        update objBroker;
        
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Preliminary Assesment';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }

    public static testMethod void validate2()
    {
        LoadData();
      
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
        objclsSendEmailNotification.sendDocs();
    }
    
    public static testMethod void validate3()
    {
        LoadDataNew();
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Preliminary Assesment';
        lstwrapselect.add(objWrappdf);
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
       // String docdate = '';
        
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
   
     public static testMethod void validate31()
    {
        LoadData();
             objFunding.LMI__c=null;
             update objFunding;
             
             objOpp.acfDate_Docs_Generated__c = null;
             update objOpp;
           
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Preliminary Assesment';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
    
    public static testMethod void validate32()
    {
        LoadData();
           
           objOpp.acfDate_Docs_Generated__c= null;
           update objOpp;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Preliminary Assesment';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
    
     public static testMethod void validate4()
    {
        LoadDataNew();
        objBroker.ACL_Holder__c =  '';
          update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Credit Guide';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
    
    public static testMethod void validate41()
    {
        LoadData();
        objBroker.ACL_Holder__c =  '';
        objBroker.Channel__c = 'Partner';
        objBroker.Representative_Business_Address__c = null;
          update objBroker;
          
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Credit Guide';
        
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
    
    public static testMethod void validateClick()
    {
        LoadData();
      //  objBroker.ACL_Holder__c =  '';
        objBroker.Channel__c = 'Click';
        objBroker.ACR_EDR_Membership_No__c = 'testmember';
        objBroker.ACL_Phone__c = '';
        objBroker.Representative_Business_Address__c = null;
          update objBroker;
          
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Preliminary Assesment';
        
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    } 
    
    public static testMethod void validate5()
    {
        LoadData();
        objBroker.ACL_Address__c = 'test';
        objBroker.ACL_Phone__c = '';
         objBroker.Channel__c = 'Employee';
          update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Credit Guide';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
    
    public static testMethod void validate6()
    {
        LoadData();
        objBroker.ACL_Address__c = 'test';
     // objBroker.ACR_EDR_Scheme_Name__c = 'testscheme';
      objBroker.ACR_EDR_Membership_No__c = '';
      
      
      objBroker.Channel__c = 'Partner';
          update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Credit Guide';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
    
    public static testMethod void validate7()
    {
        LoadData();
        objBroker.ACL_Address__c = 'test';
        objBroker.ACR_EDR_Scheme_Name__c = '';
          update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Credit Guide';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }
   
    public static testMethod void validate8()
    {
        LoadData();
        objBroker.ACL_Address__c = '';
        objBroker.ACL_Phone__c = '';
         objBroker.Channel__c = 'Click';
          update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Credit Guide';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
    }

     public static testMethod void validate10()
    {
        LoadData();
       
         objBroker.Channel__c = 'Click';
          update objBroker;
          objOpp.CurrentAssignedBroker__c = objBroker.Id;
          update objOpp;
          
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.IsDocSelected = true;
        objWrappdf.strDocName = 'Preliminary Assesment';
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs(); 
        objclsSendEmailNotification.getComplianceAttachment(objOpp); 
    }

    public static testMethod void validate9()
    {
        LoadDataNew();
        
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate11()
    {
        LoadData();
         objBroker.ACR__c= '';
                  objBroker.Channel__c = 'Employee';
       
         update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate12()
    {
        LoadData();
         objBroker.ACL_Licence__c= '';
         objBroker.Channel__c = 'Click';
         update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate13()
    {
        LoadData();
         objBroker.ACL_Email__c= '';
         update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate14()
    {
        LoadData();
         objBroker.ACL_EDR_Scheme__c= '';
         update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
       
        public static testMethod void validate15()
    {
        LoadData();
         objBroker.ACL_EDR_Membership_No__c= '';
         update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate16()
    {
        LoadData();
         objBroker.Name= '';
         update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate161()
    {
        LoadData();
         objBroker.Name= 'test';
         update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Proposal Disclosure';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate17()
        {
        LoadData();
        objBroker.Channel__c = 'Employee';
          update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'test';
        objWrappdf.IsDocSelected = false;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
        public static testMethod void validate18()
        {
        LoadData();
        objBroker.Channel__c = 'Partner';
          update objBroker;
        ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(objOpp);
        clsSendEmailNotification objclsSendEmailNotification = new clsSendEmailNotification(con);
       
        clsSendEmailNotification.wrapSelectPdf objWrappdf =new clsSendEmailNotification.wrapSelectPdf();
        List<clsSendEmailNotification.wrapSelectPdf> lstwrapselect = new List<clsSendEmailNotification.wrapSelectPdf>();
        objWrappdf.strDocName = 'Credit Guide';
        objWrappdf.IsDocSelected = true;
        lstwrapselect.add(objWrappdf);
        clsSendEmailNotification.lstwrapSelectpdf = lstwrapselect;
        objclsSendEmailNotification.lstwrapSelectpdfComp=lstwrapselect ;
        objclsSendEmailNotification.sendDocs();
        objclsSendEmailNotification.getComplianceAttachment(objOpp);
        }
        
      public static void LoadData()
    {
        createLead();
     //   createAccount();
        createPersonAccount();
        createPortalUser();
        createMarket();
        createBroker();
        createOpportunity();  
        createProduct2();   
        createPriceBook();
        createPricebookEntry();
        createFunding_Position();  
        createOpportunityLineItem();
        createclickApplicant();
        
         ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
    }
    
    public static void LoadDataNew()
    {
        createLead();
        createAccount();
        createPersonAccount();
        createPortalUser();
        createMarket();
        createBroker();
        createOpportunityNew();  
        createProduct2();   
        createPriceBook();
        createPricebookEntry();
        createFunding_Position();  
        createOpportunityLineItem();
        createclickApplicant();
        
         ApexPages.CurrentPage().getParameters().put('Id',objOpp.id);
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
    
    static void createMarket()
    {
       objMarket = new Market__c();
       objMarket = WLCommonTrackerClass.createMarket();
    
    }
    
    static void createBroker()
    {
       objBroker = new Broker__c();  
       objBroker = WLCommonTrackerClass.createBroker(objMarket);
    }
    
     static void createOpportunity()
    {
        objOpp= new Opportunity();
        objOpp.CurrentAssignedBroker__c = objBroker.Id;
        objOpp=WLCommonTrackerClass.createOpportunity(objOpp,objUser);
        lstOpp = new List<Opportunity>();
        lstOpp.add(objOpp);
    }
    
    static void createOpportunityNew()
    {
        objOpp= new Opportunity();
        objOpp=WLCommonTrackerClass.createOpportunity(objOpp,objUser);
        lstOpp = new List<Opportunity>();
        lstOpp.add(objOpp);
    }
    
     static void createProduct2()
    {
      objProduct2 = new Product2();
      objProduct2 = WLCommonTrackerClass.createProduct(objProduct2);   
    }
  
       static void createPriceBook()
    {
      objPricebook = new PriceBook2();
      objPricebook = WLCommonTrackerClass.createPriceBook2();
    }   
      
     static void createPricebookEntry()
   {  
       objPricebookEntry  = new PricebookEntry();
       objPricebookEntry =  WLCommonTrackerClass.createPricebookEntry(objPricebook,objProduct2);
   }
   
     static void  createOpportunityLineItem()
    {
       objLineItem = new OpportunityLineItem();
       lstLineItem = new List<OpportunityLineItem>();
       objLineItem = WLCommonTrackerClass.createOpportunityLineItem(objPricebookEntry,objOpp);
       lstLineItem.add(objLineItem);
    }
    
     static void createclickApplicant()
    {
       objClickApp = new click_Applicant__c();
       objClickApp.Applicant_Email__c = 'test@gmail.com';
       objClickApp = WLCommonTrackerClass.createApplicant(objClickApp,objpersonAccount,objOpp);
    } 
    
     static void createFunding_Position()
    {
       objfunding = new Funding_Position__c();
       objfunding = WLCommonTrackerClass.createFundingPosition(objpersonAccount,objOpp);
    } 
    
    static void createLVR()
  {
      objLVR = new LVR_Rate__c();
      objLVR.acfProduct__c = objProduct2.id;
      objLVR.clickFixed_Interest_Rate__c = 0.7;
      insert objLVR;
  }
     
}