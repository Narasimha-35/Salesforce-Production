@isTest
public class acfCreateNewOpportunityTracker 
{
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Account objpersonAccount;
    private static Question__c objQue;
    private static Question__c objQue1;
    private static List<Question__c> lstQue;
    private static Answer__c objAns;
    private static List<Answer__c > lstAns;
    private static Lead objLead;
    private static Income_And_Expense__c objIAE;
    private static Opportunity objOpportunity;
    private static click_Applicant__c objCappl;
    private static Asset_And_Liability__c objAsali;
    private static Script__c objScript;
    private static Click_Community_Setup__c cmmset;
    private static product2 objPro;
    private static PriceBookEntry pbEntry;
    private static OpportunityLineItem oppLine;
    
    static TestMethod void Validate01()
     { 
        LoadData();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);      
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        objScript.acf_Type__c='test1' ; 
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        PageReference pageRef = Page.cloneOpportunities;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('accid',lcr.getAccountId());
        
        List<string> lststr= new List<string>();
        Lststr.add('test');
        
        ApexPages.StandardController sc = new ApexPages.standardController(objOpportunity);
        acfCreateNewOpportunity obj=new acfCreateNewOpportunity(sc);
        obj.selectedLoanType = 'New Purchase';
        
        List <acfCreateNewOpportunity.WrapperIncomeAndExpense> lstWIAE=new List<acfCreateNewOpportunity.WrapperIncomeAndExpense>();
        acfCreateNewOpportunity.WrapperIncomeAndExpense objWIAE=new acfCreateNewOpportunity.WrapperIncomeAndExpense();
        objWIAE.objWrapIncomeExpense = objIAE;
        objWIAE.SelectedIE=true;
        lstWIAE.add(objWIAE);
        
        List<acfCreateNewOpportunity.WrapperApplicant> lstWrapl=new List<acfCreateNewOpportunity.WrapperApplicant>();
        acfCreateNewOpportunity.WrapperApplicant objWrapl=new acfCreateNewOpportunity.WrapperApplicant();
        objWrapl.objWrapApplicant = objCappl;
        objWrapl.SelectedApplicant=true;
        objWrapl.lstIe=lstWIAE;
        lstWrapl.add(objWrapl);
        
        List<acfCreateNewOpportunity.WrapperAssetAndLiability> lstWraali=new List<acfCreateNewOpportunity.WrapperAssetAndLiability>();
        acfCreateNewOpportunity.WrapperAssetAndLiability objWraali=new acfCreateNewOpportunity.WrapperAssetAndLiability();
        objWraali.objWrapAl=objAsali;
        objWraali.SelectedAl=true;
        objWraali.lstIe=lstWIAE;
        lstWraali.add(objWraali);
        
        
        List<acfCreateNewOpportunity.Questions> lstwraps = new List<acfCreateNewOpportunity.Questions>();
        acfCreateNewOpportunity.Questions objwraps = new acfCreateNewOpportunity.Questions();
        objwraps.objWrapQuestion = objQue;
        objwraps.strWrapAnswer='test';
        objwraps.lstSelectOpt = obj.getLoanType();
        objwraps.lstSelectOptions=lstAns;
        objwraps.lstCheckBoxAnswer=lststr;
        lstwraps.add(objwraps);
        
        acfCreateNewOpportunity.WrapperQuestions objwrap = new acfCreateNewOpportunity.WrapperQuestions();
        objwrap.lstRelatedQuestion = lstwraps ;
        objwrap.objWrapQuestion =objQue;
        objwrap.strWrapAnswer='test';
        objwrap.lstSelectOpt=obj.getLoanType();
        objwrap.lstSelectOptions= lstAns;
        objwrap.lstCheckBoxAnswer=Lststr;
        objwrap.lstWrapperApplicant=lstWrapl;
        objwrap.lstWrapperAssetAndLiability=lstWraali;
        
        obj.getNewAccountDetails();
        obj.getOPPDetails();
        obj.PreLoginQuestion();
        obj.getWrapperApplicant();
        obj.getWrapperAssetAndLiability();
        obj.getLoanType();
        obj.getBankNames();
        obj.CreateNewOpportunnit();
     }
 
      static TestMethod void Validate02()
     { 
        LoadData(); 
        ApexPages.StandardController sc = new ApexPages.standardController(objOpportunity);
        acfCreateNewOpportunity obj=new acfCreateNewOpportunity(sc);
        obj.getNewAccountDetails();
     }
     
     static testMethod void validate03()
     {
        LoadData();
        test.starttest();
        objQue1 = new Question__c ();
        objQue1=WLCommonTrackerClass.createQuestion(objQue1);
        objQue1.acf_Script__c = objScript.id;
        update objQue1;
        
        objQue.acf_Master_Question__c=objQue1.id;
        update objQue;
        
        objIAE.Asset_And_Liability__c = objAsali.id;
        update objIAE;
        
        ApexPages.currentPage().getParameters().put('accid',objpersonAccount.id);
        objpersonAccount.Click_Community_Setup__c  =cmmset.id;
        update objpersonAccount;
        
        objOpportunity.AccountId =objpersonAccount.id;
        objOpportunity.Transaction_Type__c='New Purchase';
        objOpportunity.StageName='Application Taken';
        objOpportunity.name='New';
        objOpportunity.RecordTypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId();
        update objOpportunity;
        
        objCappl.click_Account__c=objpersonAccount.id;
        objCappl.clickOpportunity__c=objOpportunity.id;
        update objCappl;
        
        objAsali.Opportunity__c  = objOpportunity.id;
        update objAsali;
        
        acfBank_Detail__c obj=new acfBank_Detail__c();
        obj.click_Show_on_Current_Lender_question__c=true;
        
        obj.acfBank_Name__c='test';
        insert obj;

        set<string> objset=new set<string>();
        objset.add('tesr');
        
        Click_Loans_Bank__c loanobj=new Click_Loans_Bank__c();
        loanobj.name='test';
        loanobj.Click_Loans_Bank_Detail__c=obj.id;
        obj.click_Show_on_Current_Lender_question__c=true;
        loanobj.Community_Setup__c=cmmset.id;
        insert loanobj;
        
        Document_Master__c docobj=new Document_Master__c();
        docobj.name='test';
        docobj.Click_Community_Setup__c=cmmset.id;
        insert docobj;
        
        Dependent_Document__c depobj=new Dependent_Document__c();
        depobj.name='test';
        depobj.acfDocument_Master__c=docobj.id;
        depobj.acfActive__c=true;
        insert depobj;
        
        acfDependent_Product__c productobj=new acfDependent_Product__c ();
        productobj.acfAnswer__c=objAns.id;
        productobj.acfProduct__c=objPro.id;
        insert productobj;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);      
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        test.stoptest();
        
        acfCreateNewOpportunity oppobj=new acfCreateNewOpportunity (new ApexPages.StandardController(objOpportunity));
        oppobj.selectedLoanType='New Purchase';
        oppobj.getBankNames();
        oppobj.getLoanType();
        oppobj.getOPPDetails();
        oppobj.getNewAccountDetails();
        oppobj.getWrapperAssetAndLiability();
        //oppobj.CreateNewOpportunnit();
        acfCreateNewOpportunity.getRequiredDocumentsFromAnswersFromCRM(objLead.id,objset,cmmset.id);
        acfCreateNewOpportunity.getSuggestedProductsFromAnswers(objLead.id,objset,cmmset.id);
     }
     
     static testMethod void validate04()
     {
        LoadData();
        test.starttest();
        objAsali.Opportunity__c =objOpportunity.id;
        update objAsali;
        
        objQue1 = new Question__c ();
        objQue1=WLCommonTrackerClass.createQuestion(objQue1);
        objQue1.acf_Script__c = objScript.id;
        update objQue1;
       
        objQue.acf_Master_Question__c=objQue1.id;
        update objQue;
        ApexPages.currentPage().getParameters().put('accid',objpersonAccount.id);
        objpersonAccount.Click_Community_Setup__c  =cmmset.id;
        update objpersonAccount;
        
        objOpportunity.AccountId =objpersonAccount.id;
        objOpportunity.Transaction_Type__c='New Purchase';
        objOpportunity.StageName='Application Taken';
        objOpportunity.name='New';
        update objOpportunity;
        
        objCappl.click_Account__c=objpersonAccount.id;
        objCappl.clickOpportunity__c=objOpportunity.id;
        update objCappl;
        
        objAsali.Opportunity__c  = objOpportunity.id;
        update objAsali;
        acfBank_Detail__c obj=new acfBank_Detail__c();
        obj.click_Show_on_Current_Lender_question__c=true;
        
        obj.acfBank_Name__c='test';
        insert obj;
        
        
        set<string> objset=new set<string>();
        objset.add(string.valueof(objAns.id));
        
        Click_Loans_Bank__c loanobj=new Click_Loans_Bank__c();
        loanobj.name='test';
        loanobj.Click_Loans_Bank_Detail__c=obj.id;
        obj.click_Show_on_Current_Lender_question__c=true;
        loanobj.Community_Setup__c=cmmset.id;
        insert loanobj;
        
        Document_Master__c docobj=new Document_Master__c();
        docobj.name='test';
        docobj.Click_Community_Setup__c=cmmset.id;
        insert docobj;
        
        Dependent_Document__c depobj=new Dependent_Document__c();
        depobj.name='test';
        depobj.acfDocument_Master__c=docobj.id;
        depobj.acfAnswer__c = objAns.id;
        depobj.acfActive__c=true;
        insert depobj;
        
        objPro.Click_Loans_Bank_Detail__c = loanobj.Click_Loans_Bank_Detail__c;
        update objPro;
        
        acfDependent_Product__c productobj = new acfDependent_Product__c ();
        productobj.acfAnswer__c=objAns.id;
        productobj.acfProduct__c=objPro.id;
        insert productobj;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);      
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        test.stoptest();
        
        acfCreateNewOpportunity oppobj=new acfCreateNewOpportunity (new ApexPages.StandardController(objOpportunity));
        oppobj.selectedLoanType='Refinance';
        oppobj.getBankNames();
        oppobj.getLoanType();
        oppobj.getOPPDetails();
        oppobj.getNewAccountDetails();
        oppobj.PreLoginQuestion();
        acfCreateNewOpportunity.getRequiredDocumentsFromAnswersFromCRM(objOpportunity.id,objset,cmmset.id);
        acfCreateNewOpportunity.getSuggestedProductsFromAnswers(objOpportunity.id,objset,cmmset.id);
     }
     
     static testMethod void validate05()
     {
        LoadDatas();
        test.starttest();
        objAsali.Opportunity__c =objOpportunity.id;
        update objAsali;
        
        objQue1 = new Question__c ();
        objQue1=WLCommonTrackerClass.createQuestion(objQue1);
        objQue1.acf_Script__c = objScript.id;
        update objQue1;
       
        objQue.acf_Master_Question__c=objQue1.id;
        update objQue;
        
        objpersonAccount.Click_Community_Setup__c  =cmmset.id;
        update objpersonAccount;
        ApexPages.currentPage().getParameters().put('accid',objpersonAccount.id);

        objOpportunity.AccountId =objpersonAccount.id;
        objOpportunity.Transaction_Type__c='Refinance';
        objOpportunity.StageName='Application Taken';
        objOpportunity.name='New';
        update objOpportunity;
        
        objCappl.click_Account__c=objpersonAccount.id;
        objCappl.clickOpportunity__c=objOpportunity.id;
        update objCappl;
        
        objAsali.Opportunity__c  = objOpportunity.id;
        update objAsali;
        
        acfBank_Detail__c obj=new acfBank_Detail__c();
        obj.click_Show_on_Current_Lender_question__c=true;
        
        obj.acfBank_Name__c='test';
        insert obj;

        //set<string> objset=new set<string>();
        //objset.add(string.valueof(objAns.id));
        
        Click_Loans_Bank__c loanobj=new Click_Loans_Bank__c();
        loanobj.name='test';
        loanobj.Click_Loans_Bank_Detail__c=obj.id;
        obj.click_Show_on_Current_Lender_question__c=true;
        loanobj.Community_Setup__c=cmmset.id;
        insert loanobj;
        
        Document_Master__c docobj=new Document_Master__c();
        docobj.name='test';
        docobj.Click_Community_Setup__c=cmmset.id;
        insert docobj;
        
        /*Dependent_Document__c depobj=new Dependent_Document__c();
        depobj.name='test';
        depobj.acfDocument_Master__c=docobj.id;
        depobj.acfAnswer__c = objAns.id;
        depobj.acfActive__c=true;
        insert depobj;
        
        objPro.Click_Loans_Bank_Detail__c = loanobj.Click_Loans_Bank_Detail__c;
        update objPro;
        
        acfDependent_Product__c productobj = new acfDependent_Product__c ();
        productobj.acfAnswer__c=objAns.id;
        productobj.acfProduct__c=objPro.id;
        insert productobj; */
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);      
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        test.stoptest();
        acfCreateNewOpportunity oppobj=new acfCreateNewOpportunity (new ApexPages.StandardController(objOpportunity));
        oppobj.selectedLoanType= 'Refinance';
        oppobj.getBankNames();
        oppobj.getLoanType();
        oppobj.getOPPDetails();
        oppobj.getNewAccountDetails();
        oppobj.PreLoginQuestion();
        oppobj.getPreLoginQuestion(cmmset.id);
        oppobj.CreateNewOpportunnit();
        //acfCreateNewOpportunity.getRequiredDocumentsFromAnswersFromCRM(objOpportunity.id,objset,cmmset.id);
        //acfCreateNewOpportunity.getSuggestedProductsFromAnswers(objOpportunity.id,objset,cmmset.id);
     }

     private static void LoadData()
     {
        createLead();
        createPersonAccount();
        createcommunitysetup();
        createContact();
        createUser();
        createOpportunity();
        createProduct();
        createPriceBookEntry();
        createOpportunityLineItem();
        createScript();
        createQuestion();
        createanswer();
        createclickApplicant();
        createAssetAndLiability();
        createIncomeAndExpense();
    }
    
    private static void LoadDatas()
    {
        createcommunitysetup();     
        createLead();
        createPersonAccount();
        createContact();
        createUser();
        createOpportunitys();
        createProduct();
        createPriceBookEntry();
        createOpportunityLineItem();
        createScript();
        createQuestion();
        createanswer();
        createclickApplicant();
        createAssetAndLiability();
        createIncomeAndExpense();
    }
    
    static void createLead()
    {
        objLead=new Lead();
        objLead=WLCommonTrackerClass.createLead(objLead);
    }
    
     static void createScript()
    {
        objScript = new Script__c();
        objScript = WLCommonTrackerClass.createScript('Pre-Login');
        update objScript;
    }
    
    static void createPersonAccount()
    {
        objpersonAccount= new Account();
        objpersonAccount=WLCommonTrackerClass.CreatePersonAccount('Fname','LName','strPhone','strLead12Email@gmail.com',objLead.Id);
    }
    
    static void createcommunitysetup()
    {
        cmmset= new Click_Community_Setup__c ();
        cmmset=WLCommonTrackerClass.createcommunitysetup();
        cmmset.Click_Page_Prefix__c = 'Click';
        update cmmset;
    }
    
    static void createContact()
    {
        objContact = new Contact();
        objContact = WLCommonTrackerClass.createContact(objContact,objpersonAccount);
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
    }
    
     static void createQuestion()
    {
        objQue = new Question__c ();
        objQue.acfIs_New_Loan__c=true;
        objQue.Click_Is_Broker_Question__c=false;
        objQue.acf_Question__c = 'Who is your current lender?';
        objQue.acf_Active__c = true;
        objQue.acf_Sequence_No__c = 2.0;
        objQue.acf_Type__c = 'Button';
        objQue.acfRefinance_Sequence_No__c = 1;
        objQue.acfIs_refinance__c = true;
        insert objQue;
        lstQue=new List<Question__c>();
        lstQue.add(objQue);
    }
    
    static void createanswer()
    {
       objAns = new Answer__c ();
       objAns.acf_Question__c = objQue.id;
       objAns=WLCommonTrackerClass.createAnswer(objAns);
       lstAns=new List<Answer__c >();
       lstAns.add(objAns);
    }
    
    static void createIncomeAndExpense()
    {
         objIAE=new Income_And_Expense__c ();
         objIAE=WLCommonTrackerClass.createIncomeExpense(objIAE,objCappl);
    }
    
    static void createclickApplicant()
    {
         objCappl=new click_Applicant__c();
         objCappl = WLCommonTrackerClass.createApplicant(objCappl,objpersonAccount,objOpportunity );
    }
    
     static void createAssetAndLiability()
    {
        objAsali=new Asset_And_Liability__c ();
        objAsali=WLCommonTrackerClass.createAssetandLiablility(objAsali,objpersonAccount);
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.AccountId =objpersonAccount.id;
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity =  WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
     }
     
     static void createOpportunitys()
    {
        objOpportunity = new Opportunity();
        objOpportunity.AccountId =objUser.AccountId ;
        objOpportunity.Community_Setup__c=ClickCommon.getCommunitySetup('null').Id;
        objOpportunity.recordtypeid= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Click Refi').getRecordTypeId();
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();
        objOpportunity.acfAsset_House_Worth__c = 200000;
        insert objOpportunity;
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
    
 }