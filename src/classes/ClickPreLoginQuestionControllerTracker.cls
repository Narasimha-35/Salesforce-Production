@isTest
public class   ClickPreLoginQuestionControllerTracker
{
    private static Lead objLead ;
    private static User objUser;
    private static Click_Community_Setup__c objcommunity;
    private static List<Click_Community_Setup__c> lstcommunity;
    private static account objpersonAccount;
    private static account objAccount;
    private static account objAccount1;
    public static Question__c objQuestion;
    private static click_Applicant__c objclickappl;
    private static Contact objContact;
    private static Lead objLead12;
    private static Opportunity objOpportunity;
    public static Script__c  objScript;
    
    static testMethod void validate()
    {
        LoadData();
        
        objAccount1 =new account();
        objAccount1.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount1.lastname='test';
        objAccount1.SelfLookup__c=objAccount.id;
        objAccount1.PersonEmail='test@gmail.com';
        objAccount1.Phone='6768868';
        objAccount1.Click_Community_Setup__c=objcommunity.id; 
        objAccount1.IsMaster__c=false;
        insert objAccount1;
        objScript = WLCommonTrackerClass.createScript('Pre-Login');
        
        objScript.Click_Community_Setup__c = objcommunity.id;
        update objScript;
        
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=objScript.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.click_is_EConsent__c=true;
        queobj1.acfDependent_Object_Name__c='Contact';
        insert queobj1;  
        
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=objQuestion.id;
        insert ansobj;
        
        ClickPreLoginQuestionController obj=new ClickPreLoginQuestionController(new ApexPages.StandardController(objpersonAccount));
        obj.strBubbleText='ashna';
        string abc=obj.strBubbleText;
        obj.selectedCommunity=objcommunity.id;
        ClickPreLoginQuestionController.WrapperQuestions oo=new ClickPreLoginQuestionController.WrapperQuestions();
        oo.strWrapAnswer='test';
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        options.add(new SelectOption('Refinance','Refinance'));
        options.add(new SelectOption('New Purchase','New Purchase')); 
        
        oo.lstSelectOpt=options;
        
        List<Answer__c> lstans=new List<Answer__c>();
        lstans.add(ansobj);
        oo.lstSelectOptions=lstans;
        
        List<string> lst=new  List<string>();
        lst.add('test');
        oo.lstCheckBoxAnswer=lst;
        
        account objAccount2 =new account();
        objAccount2.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount2.lastname='test';
        objAccount2.SelfLookup__c=objAccount.id;
        objAccount2.PersonEmail='test@gmail.com';
        objAccount2.Phone='6768868';
        objAccount2.Click_Community_Setup__c=objcommunity.id; 
        objAccount2.IsMaster__c=false;
        insert objAccount2;
        list<Account> lstAcc = new list<Account>();
        lstAcc.add(objAccount2);
        obj.lstAcc =  lstAcc;   
        obj.saveLead();
        
        acfBank_Detail__c acobj=new acfBank_Detail__c();
        acobj.acfBank_Name__c='test';
        acobj.click_Show_on_Current_Lender_question__c=true;
        insert acobj;
        
        List<SelectOption> bnkobj=obj.getBankNames();
        List<SelectOption> loanobj=obj.getLoanType();
        List<SelectOption> comobj=obj.getCommunity();
        
        obj.selectedLoanType = 'New Purchase';
        obj.saveLead();
}

 static testMethod void validate3()
    {
        LoadData();
        
        objAccount1 =new account();
        objAccount1.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount1.lastname='test';
        objAccount1.SelfLookup__c=objAccount.id;
        objAccount1.PersonEmail='test@gmail.com';
        objAccount1.Phone='6768868';
        objAccount1.Click_Community_Setup__c=objcommunity.id; 
        objAccount1.IsMaster__c=false;
        insert objAccount1;
        objScript = WLCommonTrackerClass.createScript('Pre-Login');
        
        objScript.Click_Community_Setup__c = objcommunity.id;
        update objScript;
        
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=objScript.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.click_is_EConsent__c=true;
        queobj1.acfDependent_Object_Name__c='Contact';
        insert queobj1;  
        
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=objQuestion.id;
        insert ansobj;
        
        ClickPreLoginQuestionController obj=new ClickPreLoginQuestionController(new ApexPages.StandardController(objpersonAccount));
        ClickPreLoginQuestionController.WrapperQuestions oo=new ClickPreLoginQuestionController.WrapperQuestions();
        oo.strWrapAnswer = 'test'; 
        List<ClickPreLoginQuestionController.WrapperQuestions> lstoo=new List<ClickPreLoginQuestionController.WrapperQuestions>();
        lstoo.add(oo);
        obj.lstWrapperQuestion = lstoo;
        obj.strBubbleText='ashna';
        string abc=obj.strBubbleText;
        obj.saveLead();
        obj.selectedCommunity=objcommunity.id;
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        options.add(new SelectOption('Refinance','Refinance'));
        options.add(new SelectOption('New Purchase','New Purchase')); 
        oo.lstSelectOpt=options;
        
        List<Answer__c> lstans=new List<Answer__c>();
        lstans.add(ansobj);
        oo.lstSelectOptions=lstans;
        
        List<string> lst=new  List<string>();
        lst.add('test');
        oo.lstCheckBoxAnswer=lst;
        
        account objAccount2 =new account();
        objAccount2.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount2.lastname='test';
        objAccount2.SelfLookup__c=objAccount.id;
        objAccount2.PersonEmail='test@gmail.com';
        objAccount2.Phone='6768868';
        objAccount2.Click_Community_Setup__c=objcommunity.id; 
        objAccount2.IsMaster__c=false;
        insert objAccount2;
        list<Account> lstAcc = new list<Account>();
        lstAcc.add(objAccount2);
        obj.lstAcc =  lstAcc;   
        
        acfBank_Detail__c acobj=new acfBank_Detail__c();
        acobj.acfBank_Name__c='test';
        acobj.click_Show_on_Current_Lender_question__c=true;
        insert acobj;
        
        List<SelectOption> bnkobj=obj.getBankNames();
        List<SelectOption> loanobj=obj.getLoanType();
        List<SelectOption> comobj=obj.getCommunity();
        obj.selectedLoanType = 'New Purchase';
}

       static testMethod void validate4()
    {
        LoadData();
        
        objAccount1 =new account();
        objAccount1.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount1.lastname='test';
        objAccount1.SelfLookup__c=objAccount.id;
        objAccount1.PersonEmail='test@gmail.com';
        objAccount1.Phone='6768868';
        objAccount1.Click_Community_Setup__c=objcommunity.id; 
        objAccount1.IsMaster__c=false;
        insert objAccount1;
        objScript = WLCommonTrackerClass.createScript('Pre-Login');
        
        objScript.Click_Community_Setup__c = objcommunity.id;
        update objScript;
        
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=objScript.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.click_is_EConsent__c=true;
        queobj1.acfDependent_Object_Name__c='Contact';
        insert queobj1;  
        
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=objQuestion.id;
        insert ansobj;
        
        ClickPreLoginQuestionController obj=new ClickPreLoginQuestionController(new ApexPages.StandardController(objpersonAccount));
        obj.selectedLoanType = 'New Purchase';
        ClickPreLoginQuestionController.WrapperQuestions oo=new ClickPreLoginQuestionController.WrapperQuestions();
        List<ClickPreLoginQuestionController.WrapperQuestions> lstoo=new List<ClickPreLoginQuestionController.WrapperQuestions>();
        lstoo.add(oo);
        obj.lstWrapperQuestion = lstoo;
        obj.strBubbleText='ashna';
        string abc=obj.strBubbleText;
        obj.selectedCommunity=objcommunity.id;
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        options.add(new SelectOption('Refinance','Refinance'));
        options.add(new SelectOption('New Purchase','New Purchase')); 
        oo.lstSelectOpt=options;
        
        List<Answer__c> lstans=new List<Answer__c>();
        lstans.add(ansobj);
        oo.lstSelectOptions=lstans;
        
        List<string> lst=new  List<string>();
        lst.add('test');
        oo.lstCheckBoxAnswer=lst;
        
        account objAccount2 =new account();
        objAccount2.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount2.lastname='test';
        objAccount2.SelfLookup__c=objAccount.id;
        objAccount2.PersonEmail='test@gmail.com';
        objAccount2.Phone='6768868';
        objAccount2.Click_Community_Setup__c=objcommunity.id; 
        objAccount2.IsMaster__c=false;
        insert objAccount2;
        list<Account> lstAcc = new list<Account>();
        lstAcc.add(objAccount2);
        obj.lstAcc =  lstAcc;   
        
        acfBank_Detail__c acobj=new acfBank_Detail__c();
        acobj.acfBank_Name__c='test';
        acobj.click_Show_on_Current_Lender_question__c=true;
        insert acobj;
        
        List<SelectOption> bnkobj=obj.getBankNames();
        List<SelectOption> loanobj=obj.getLoanType();
        List<SelectOption> comobj=obj.getCommunity();
        obj.selectedLoanType = 'New Purchase';
        obj.saveLead();
}


      static testMethod void validate1()
    {
        LoadData();
        ApexPages.currentPage().getParameters().put('Id',objpersonAccount.id);
        ClickPreLoginQuestionController obj=new ClickPreLoginQuestionController(new ApexPages.StandardController(objpersonAccount));
        obj.PreLoginQuestion();
        obj.saveLead();
        obj.getCommunity();
        obj.getBankNames();
    }
    
      static testMethod void validate2()
    {
        LoadData();
        objAccount1 =new account();
        objAccount1.recordtypeid=Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount1.lastname='test';
        objAccount1.SelfLookup__c=objAccount.id;
        objAccount1.PersonEmail='test@gmail.com';
        objAccount1.Phone='6768868';
        objAccount1.Click_Community_Setup__c=objcommunity.id; 
        objAccount1.IsMaster__c=false;
        insert objAccount1;
                      
        Question__c queobj1=new Question__c();
        queobj1.acf_Active__c=true;
        queobj1.Click_Is_Broker_Question__c=false;
        queobj1.acf_Script__c=objScript.id;
        queobj1.acfDependent_Field_Name__c='test';
        queobj1.click_is_EConsent__c=true;
        queobj1.acfDependent_Object_Name__c='Contact';
        objQuestion.acfIs_refinance__c = true;
        insert queobj1;  
        
        Answer__c ansobj=new Answer__c();
        ansobj.acf_Question__c=objQuestion.id;
        insert ansobj;
  
        ClickPreLoginQuestionController obj=new ClickPreLoginQuestionController(new ApexPages.StandardController(objpersonAccount));
        obj.selectedCommunity=objcommunity.id;
        obj.selectedLoanType='Refinance';
        obj.PreLoginQuestion();
        obj.saveLead();
}
    private static void LoadData()
    {    
        createLead12();
        createPersonAccount();
        createAccount();
        createUser();
        createclickCommunitySetup();
        createLead(); 
        createScript();
        createQuestion();
        createContact();
        createOpportunity1();
    }
   
       static void createLead12()
    {
        objLead12 = new Lead();
        objLead12 = WLCommonTrackerClass.createLead(objLead12 );
    }
    
    static void createLead()
    {
       objLead = new Lead();
       
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
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
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Lead','Click Refi');
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
         objUser = WLCommonTrackerClass.CreatePortalUser(objpersonAccount.id);
    }
    
    static void createOpportunity1()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = WLCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    
     static void createPersonAccount()
    {
        objpersonAccount= new Account();
        objpersonAccount=WLCommonTrackerClass.CreatePersonAccount('Fname','LName','strPhone','strLead12Email@gmail.com',objLead12.Id);
    }
   
    static void  createAccount()
     {
         objAccount =new account();
         objAccount=WLCommontrackerClass.createAccount(objAccount);
     }
    
    
     static void createclickCommunitySetup() 
    {
        objcommunity = new Click_Community_Setup__c();
        objcommunity = WLCommontrackerClass.createcommunitysetup();
        lstcommunity = new List<Click_Community_Setup__c>();
        lstcommunity.add(objcommunity );
    }
    
    public static void createScript()
    {
        objScript = WLCommonTrackerClass.createScript('Pre-Login');
        objScript.Click_Community_Setup__c = objcommunity.id;
        update objScript;
    }
    
    public static void createQuestion()
    {
        objQuestion=new Question__c();
        Id ScriptID = objScript.id;
        objQuestion = WLCommontrackerClass.CreatePrePostLoginQuestions('test',1,'Pre-Login',true,true,ScriptID,'test');
    }
}