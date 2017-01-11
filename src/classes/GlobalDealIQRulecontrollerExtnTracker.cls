@isTest
public class GlobalDealIQRulecontrollerExtnTracker
{ 

     private static Lead objLead;
     private static User objUser;
     private static Contact objContact;
     private static Account objAccount;
     private static Opportunity objOpportunity;
     private static product2 objPro;
     private static PriceBookEntry pbEntry;
     private static OpportunityLineItem oppLine;
     private static Document_Master__c docobj;
     private static acfBank_Detail__c acfBankDt;
     
     static testMethod void validate()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
 
    GlobalDealIQRulecontrollerExtn.WrapperAddRow ob=new GlobalDealIQRulecontrollerExtn.WrapperAddRow();
    ob.orderNo= 5;
    ob.nameField='test';
   ob.operatorname = 'test';
   ob.expressionValue = 'test';
   
    List<GlobalDealIQRulecontrollerExtn.Outerwrapper> lstOuterWrap=new List<GlobalDealIQRulecontrollerExtn.Outerwrapper>();
    
    globalobj.OuterwrapperList =lstOuterWrap;
    acfBank_Detail__c bnkobj=new acfBank_Detail__c();
    bnkobj.acfBank_Name__c='test';
    insert bnkobj;
   GlobalDealIQRulecontrollerExtn.BankWrapper objBankWrap = new GlobalDealIQRulecontrollerExtn.BankWrapper(true,'hsbc',string.valueof(bnkobj.id));
    globalobj.nameObject = 'test';
    globalobj.operatorName ='test';
    globalobj.title = 'test';
    globalobj.expressionValue = '';
    globalobj.selectedVal='Bank';
    globalobj.saveConditionRules();
    
    
    docobj=new Document_Master__c ();
    docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
    globalobj.reqdoc=true;
   globalobj.hasNext = true;
    }
    
    static testMethod void validate1()
     {
    LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
   
     List<GlobalDealIQRulecontrollerExtn.Outerwrapper> lstOuterWrap=new List<GlobalDealIQRulecontrollerExtn.Outerwrapper>();
    GlobalDealIQRulecontrollerExtn.Outerwrapper obj1 = new GlobalDealIQRulecontrollerExtn.Outerwrapper();
    obj1.counterWrap = 0;
    obj1.sObjectName = 'Account';
    lstOuterWrap.add(obj1);
    globalobj.OuterwrapperList =lstOuterWrap;
    ApexPages.currentPage().getParameters().put('recName','0');
      globalobj.addFilter();
      globalobj.addObjectField();
      globalobj.getOperator();
      globalobj.getDocumentMaster();
    }
    
     static testMethod void validate3()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
     GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
   GlobalDealIQRulecontrollerExtn.wrapperAddRow obj2 = new GlobalDealIQRulecontrollerExtn.wrapperAddRow();
   list<GlobalDealIQRulecontrollerExtn.wrapperAddRow> lstadd = new list<GlobalDealIQRulecontrollerExtn.wrapperAddRow>();
     List<GlobalDealIQRulecontrollerExtn.Outerwrapper> lstOuterWrap=new List<GlobalDealIQRulecontrollerExtn.Outerwrapper>();
     lstadd.add(obj2);
    GlobalDealIQRulecontrollerExtn.Outerwrapper obj1 = new GlobalDealIQRulecontrollerExtn.Outerwrapper();
    obj1.wrapObjectList = lstadd ;
    lstOuterWrap.add(obj1);
    globalobj.OuterwrapperList =lstOuterWrap;
    ApexPages.currentPage().getparameters().put('orderName','0-0');
    globalobj.removeFilter();
    
    }
    
     static testMethod void validate4()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
     List<GlobalDealIQRulecontrollerExtn.Outerwrapper> lstOuterWrap=new List<GlobalDealIQRulecontrollerExtn.Outerwrapper>();
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
    ApexPages.currentPage().getparameters().put('orderNameGlobal','0');
    globalobj.removeGlobalFilter();
    
    }
    
     static testMethod void validate5()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
     List<GlobalDealIQRulecontrollerExtn.Outerwrapper> lstOuterWrap=new List<GlobalDealIQRulecontrollerExtn.Outerwrapper>();
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
     globalobj.OuterwrapperList =lstOuterWrap;
    globalobj.addFilterObject();
    }
    
    static testMethod void validate6()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
    globalobj.getcategoryqwe();
    }
    
    static testMethod void validate7()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
    globalobj.getoperator();
    }
    
    static testMethod void validate8()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
    globalobj.addObjectFieldByParam(3);
    }
    
     static testMethod void validate9()
     {
     LoadData();
      
     docobj=new Document_Master__c ();
     docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    
        Global_DealIQ_Condition__c objcon=new Global_DealIQ_Condition__c();
        objcon.name='test';
        objcon.Category__c='Character';
        objcon.Active__c=true;
        objcon.Object_Rule_Works_On__c='Product';
        objcon.RecordRuleWorksOn__c='tesrt';
        objcon.Req_Doc_Created__c=true;
        objcon.Document_Master__c=docobj.id;
        insert objcon;
    
    ApexPages.currentPage().getParameters().put('dealId',objcon.id);
   
    
    Global_DealIQ_Condition_Detail__c obj=new Global_DealIQ_Condition_Detail__c();
    obj.acfGlobal_DealIQ_Rulea__c=objcon.id;
    obj.acfField__c='test';
    obj.Object__c='lead';
    insert obj;
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
    globalobj.addObjectField();
    }
    
    static testMethod void validate2()
    {
    LoadData();
    
    GlobalDealIQRulecontrollerExtn globalobj=new GlobalDealIQRulecontrollerExtn();
    
    GlobalDealIQRulecontrollerExtn.WrapperAddRow ob=new GlobalDealIQRulecontrollerExtn.WrapperAddRow();
    ob.orderNo= 5;
    ob.nameField='test';
   ob.operatorname = 'test';
   ob.expressionValue = 'test';
   
    List<GlobalDealIQRulecontrollerExtn.Outerwrapper> lstOuterWrap=new List<GlobalDealIQRulecontrollerExtn.Outerwrapper>();
    
    globalobj.OuterwrapperList =lstOuterWrap;
    acfBank_Detail__c bnkobj=new acfBank_Detail__c();
    bnkobj.acfBank_Name__c='test';
    insert bnkobj;
    GlobalDealIQRulecontrollerExtn.BankWrapper objBankWrap = new GlobalDealIQRulecontrollerExtn.BankWrapper(true,'hsbc',string.valueof(bnkobj.id));
    globalobj.nameObject = 'test';
    globalobj.operatorName ='test';
    globalobj.title = 'test';
    globalobj.expressionValue = '';
    globalobj.selectedVal='Bank';
    globalobj.saveConditionRules();
    
    globalobj.getbankname();
    globalobj.selectedVal='Product';
    globalobj.getFieldType('Global_DealIQ_Condition_Detail__c','FieldType__c');
    globalobj.saveConditionRules();
    
    docobj=new Document_Master__c ();
    docobj=WLCommonTrackerClass.createDocumentMaster(docobj);
    globalobj.reqdoc=true;
    globalobj.getdocumentmaster();
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
        createACFBankDetails();
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
      objOpportunity.acfLoan_Amount_c__c=12;
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
    static void createACFBankDetails(){
        acfBankDt = new acfBank_Detail__c();
        acfBankDt.acfBank_Name__c= 'Test Bank';
        insert acfBankDt;
        
    }
}