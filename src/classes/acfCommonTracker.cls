@isTest(SeeAllData =true)
public class acfCommonTracker {
private static Product2 objProduct2;
static private User objUser1;  
private static Opportunity objOpportunity;
private static Lead objLead;
public static  Account objacc;
public static Pricebook2 pbk1;
public static Product2 prd1;
public static PricebookEntry pbe1;
public static OpportunityLineItem lineItem1;
public static Script__c Objscript; 
public static Question__c ObjQues; 
public static Answer__c ObjAns;
public static Document_Master__c ObjDocument; 
public static Dependent_Document__c objDependentDoc;
public static Id LeadId;
public static acfDependent_Product__c objDependentProd;

 static testMethod void validate()
    {  
        LoadData();
        Contact ObjCon = [select id,acf_Lead__c from Contact where id=:objUser1.ContactID]; 
        ObjCon.acf_Lead__c = objLead.id;
        update ObjCon;
        set<string> setSelectedAnswer = new set<string>();
        setSelectedAnswer.add(String.valueof(ObjAns.Id));
       
        
        set<string> setOfAnswer = new set<string>();
        setOfAnswer.add(String.valueof(ObjAns.Id));
        
        
        List<string> lststr = new List<string>();
        lststr.add('abc@gmail.com');
        lststr.add('abcd@gmail.com');
        
        List<string> lststr1 = new List<string>();
        lststr1.add('abc@gmail.com');
        lststr1.add('abcd@gmail.com');
        
        RecordType objRT1=[select id, name, SObjectType From RecordType Where SObjectType= 'Lead' AND name= 'Click Refi'];
        Lead objLead1 = new Lead();
        objLead1.FirstName = '+619654922845';
        objLead1.LastName = '+619654922845';
        objLead1.Email = 'swati.sharma@saasfocus.com';
        objLead1.MobilePhone = '+619654922845';
        objLead1.Status = 'Open';
        objLead1.RecordTypeId = objRT1.id;
        objLead1.acfOneTimePassword__c = '724715';
        insert objLead1;
        
        acfCommon.sendSMS('Ankit','9876567898','test',true);
        if(lststr !=null && lststr.size() > 0)
        {
            acfCommon.sendTemplatedEmail(Id.valueof(string.valueof(objLead1.Id).trim()),'test dfg wert dfgh','test asdf ghjk jhgf',lststr,lststr.clone());         
        }
        acfCommon.getLeadApiNameToType('Yes');
        acfCommon.getLeadApiNameToAnswerMap('Yes-,-N0-,-None-,-Yes');
        acfCommon.isNullOrEmpty('abctest');
        acfCommon.checkEmail('ankit@gmail.com');
    //    acfCommon.checkEmail('ankit@gmail.com');
        acfCommon.sendReturnUrl(string.valueof(objUser1.Id),true,'acfDashbord');
        acfCommon.getCurrentLoggedInContactId(objUser1.Id);
        acfCommon.getCurrentLoggedInLeadId(objUser1.Id);
        clickCommon.getCurrentLoggedInOpportunityId(objUser1.Id,'');
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            clickCommon.getRequiredDocumentsFromAnswersFromCRM(objLead.Id,setOfAnswer,clickCommon.getCommunitySetup('').Id);
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            clickCommon.getRequiredDocumentsFromAnswersFromCRM(objLead.Id,setOfAnswer,clickCommon.getCommunitySetup('').Id);
        acfCommon.IsValidDecimal(1.20);
        acfCommon.calculateMonthlyPayment(120000.98,150000,'Principal and Interest',12);
        //clickCommon.redirect(objUser1.id,'dashboard','');
        acfCommon.getRequiredDocumentsFromAnswers(objLead.Id,setOfAnswer);
        test.starttest();
        acfCommon.SendSMSUsingFuture('Ankit','9876567898','test',true);
        test.stoptest();
        
        
        List<acfSuggested_Product__c>lstSuggestedDocumentToInsert = new List<acfSuggested_Product__c>();  
           set<string> setSelectedAnswer1 = new set<string>();
        
        objDependentProd = new acfDependent_Product__c();
        
        objDependentProd.acfAnswer__c = ObjAns.Id;
        objDependentProd.acfFilter__c = 'Exclude';
        objDependentProd.acfProduct__c = objProduct2.Id;
       
        insert objDependentProd;
        setSelectedAnswer1.add(objDependentProd.acfAnswer__c);
        
     
        
        acfCommon.redirect(objUser1.Id,'jumiointegration');
        acfCommon.getRequiredDocumentsFromAnswers(objLead.Id,setSelectedAnswer);
        acfCommon.getSuggestedProductsFromAnswers(objLead.Id,setSelectedAnswer);
     //  clickCommon.getSuggestedProductsFromAnswers(objLead.Id,setOfAnswer,string.valueof(clickCommon.getCommunitySetup('').Id));
    
    }
    
    static testMethod void validate1()
    {  
        LoadData();
        Contact ObjCon = [select id,acf_Lead__c from Contact where id=:objUser1.ContactID]; 
        ObjCon.acf_Lead__c = objLead.id;
        update ObjCon;   
        
         set<string> setSelectedAnswer = new set<string>();
        setSelectedAnswer.add(String.valueof(ObjAns.Id));
       
        objLead.acfIs_Identity_Document_Submitted__c = false;
        update objLead;     
        set<string> setOfAnswer = new set<string>();
        setOfAnswer.add(String.valueof(ObjAns.Id));
        
        List<string> lststr = new List<string>();
        lststr.add('abc@gmail.com');
        lststr.add('abcd@gmail.com');
        
        List<string> lststr1 = new List<string>();
        lststr1.add('abc@gmail.com');
        lststr1.add('abcd@gmail.com');
        
        acfCommon.sendSMS('','9876567898','test',true);
        if(lststr !=null && lststr.size() > 0)
        {
            acfCommon.sendTemplatedEmail(Id.valueof(string.valueof(objLead.Id).trim()),'test dfg wert dfgh','test asdf ghjk jhgf',lststr,lststr.clone());         
        }
        acfCommon.getLeadApiNameToType('Yes');
        acfCommon.isNullOrEmpty('');
        acfCommon.checkEmail('ankit@gmail.com');
        acfCommon.sendReturnUrl(string.valueof(objUser1.Id),false,'acfDashbord');
        acfCommon.IsNullOrEmptyString('');
       // acfCommon.sendReturnUrl(string.valueof(objUser1.Id),false,'Dashbord','');
        acfCommon.getCurrentLoggedInContactId(objUser1.Id);
        acfCommon.getCurrentLoggedInLeadId(objUser1.Id);
        //acfCommon.getCurrentLoggedInOpportunityId(objUser1.Id,'');
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            clickCommon.getRequiredDocumentsFromAnswersFromCRM(objLead.Id,setOfAnswer,clickCommon.getCommunitySetup('').Id);
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            clickCommon.getSuggestedProductsFromAnswers(objLead.Id,setOfAnswer,string.valueof(clickCommon.getCommunitySetup('').Id));
        acfCommon.IsValidDecimal(1.20);
        acfCommon.calculateMonthlyPayment(120000.98,150000,'Principal and Interest',12);
        //acfCommon.redirect(objUser1.Id,'dashboard','09');
        acfCommon.getRequiredDocumentsFromAnswers(objLead.Id,setOfAnswer);
        test.starttest();
        acfCommon.SendSMSUsingFuture('','9876567898','test',true);
        test.stoptest();
        
           
        List<acfSuggested_Product__c>lstSuggestedDocumentToInsert = new List<acfSuggested_Product__c>();  
           set<string> setSelectedAnswer1 = new set<string>();
        
        objDependentProd = new acfDependent_Product__c();
        
        objDependentProd.acfAnswer__c = ObjAns.Id;
        objDependentProd.acfFilter__c = 'Exclude';
        objDependentProd.acfProduct__c = objProduct2.Id;
       
        insert objDependentProd;
        setSelectedAnswer1.add(objDependentProd.acfAnswer__c);
        
     
        
        acfCommon.redirect(objUser1.Id,'jumiointegration');
        acfCommon.getRequiredDocumentsFromAnswers(objLead.Id,setSelectedAnswer);
        acfCommon.getSuggestedProductsFromAnswers(objLead.Id,setSelectedAnswer);
    
    }
    
     static testMethod void validate2()
    {  
        LoadData();
        objLead.acfIs_Identity_Document_Submitted__c = false;
        update objLead;
        Contact ObjCon = [select id,acf_Lead__c from Contact where id=:objUser1.ContactID]; 
        ObjCon.acf_Lead__c = objLead.id;
        update ObjCon;
          
        set<string> setOfAnswer = new set<string>();
        setOfAnswer.add(String.valueof(ObjAns.Id));
        
        List<string> lststr = new List<string>();
        lststr.add('abc@gmail.com');
        lststr.add('abcd@gmail.com');
        
        List<string> lststr1 = new List<string>();
        lststr1.add('abc@gmail.com');
        lststr1.add('abcd@gmail.com');
        
        acfCommon.sendSMS('qwe','','test',true);
        if(lststr !=null && lststr.size() > 0)
        {
            acfCommon.sendTemplatedEmail(Id.valueof(string.valueof(objLead.Id).trim()),'test dfg wert dfgh','test asdf ghjk jhgf',lststr,lststr.clone());         
        }
        acfCommon.getLeadApiNameToType('Yes');
        acfCommon.isNullOrEmpty('abctest');
        acfCommon.checkEmail('ankit@gmail.com');
        acfCommon.checkEmail('ankit@gmail.com');
        //acfCommon.sendReturnUrl(string.valueof(objUser1.Id),false,'clickDashbord','');
        acfCommon.getCurrentLoggedInContactId(objUser1.Id);
        acfCommon.getCurrentLoggedInLeadId(objUser1.Id);
       // acfCommon.getCurrentLoggedInOpportunityId(objUser1.Id,'');
        /*if(setOfAnswer !=null && setOfAnswer.size() > 0)
            acfCommon.getRequiredDocumentsFromAnswersFromCRM(objLead.Id,setOfAnswer,acfCommon.getCommunitySetup('').Id);
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            acfCommon.getSuggestedProductsFromAnswers(objLead.Id,setOfAnswer,string.valueof(acfCommon.getCommunitySetup('').Id));*/
        acfCommon.IsValidDecimal(1.20);
        acfCommon.calculateMonthlyPayment(120000.98,150000,'Principal and Interest',12);
        //acfCommon.redirect(objUser1.id,'Clickdashboard','');
        acfCommon.getRequiredDocumentsFromAnswers(objLead.Id,setOfAnswer);
        test.starttest();
        acfCommon.SendSMSUsingFuture('Ankit','','test',true);
        test.stoptest();
    
    }
    
    /* static testMethod void validate3()
    {  
        LoadData();     
        set<string> setOfAnswer = new set<string>();
        setOfAnswer.add(String.valueof(ObjAns.Id));
        
        List<string> lststr = new List<string>();
        lststr.add('abc@gmail.com');
        lststr.add('abcd@gmail.com');
        
        List<string> lststr1 = new List<string>();
        lststr1.add('abc@gmail.com');
        lststr1.add('abcd@gmail.com');
        
        acfCommon.sendSMS('asdf','9876567898','',true);
        if(lststr !=null && lststr.size() > 0)
        {
            acfCommon.sendTemplatedEmail(Id.valueof(string.valueof(objLead.Id).trim()),'test dfg wert dfgh','test asdf ghjk jhgf',lststr,lststr.clone());         
        }
        acfCommon.getLeadApiNameToType('Yes');
        acfCommon.isNullOrEmpty('abctest');
        acfCommon.checkEmail('ankit@gmail.com');
        acfCommon.checkEmail('ankit@gmail.com');
        acfCommon.sendReturnUrl(string.valueof(objUser1.Id),true,'clickDashbord','');
        acfCommon.getCurrentLoggedInContactId(objUser1.Id);
        acfCommon.getCurrentLoggedInLeadId(objUser1.Id);
        acfCommon.getCurrentLoggedInOpportunityId(objUser1.Id,'');
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            acfCommon.getRequiredDocumentsFromAnswersFromCRM(objLead.Id,setOfAnswer,acfCommon.getCommunitySetup('').Id);
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            acfCommon.getSuggestedProductsFromAnswers(objLead.Id,setOfAnswer,string.valueof(acfCommon.getCommunitySetup('').Id));
        acfCommon.IsValidDecimal(1.20);
        acfCommon.calculateMonthlyPayment(120000.98,150000,'Principal and Interest',12);
        acfCommon.redirect(userinfo.getuserId(),'Clickdashboard','');
        acfCommon.getRequiredDocumentsFromAnswers(objLead.Id,setOfAnswer);
        test.starttest();
        acfCommon.SendSMSUsingFuture('Ankit','9876567898','',true);
        test.stoptest();
    
    }
    
     static testMethod void validate4()
    {  
        LoadData();
        Contact ObjCon = [select id,acf_Lead__c from Contact where id=:objUser1.ContactID]; 
        ObjCon.acf_Lead__c = objLead.id;
        update ObjCon; 
        
        objLead.acfIs_Identity_Document_Submitted__c = true;
        update objLead;
        
        Account objAccountnew = new Account ();
        objAccountnew .LastName = 'test';       
        objAccountnew .PersonEmail = 'swati.sharma@saasfocus.com';
        objAccountnew .PersonMobilePhone = '+619654922845';
        objAccountnew .Employment_Status__pc = 'Casual';
        objAccountnew .Marital_Status__pc = 'Single';
        objAccountnew .Housing_Status__pc = 'Renting';
        objAccountnew .Number_of_Children__pc = '1';
        objAccountnew .Annual_Income__pc = 100000;
        objAccountnew .Partner_Annual_Income__pc = 50000;
        objAccountnew .Super_Balance__pc = 20000;
        objAccountnew .Partner_Super_Balance__pc = 2000;
        objAccountnew .acfCurrent_Loan_Amount__pc = 20000;
        objAccountnew .acfApproximately_how_much_is_your_house__pc = 10000;
        objAccountnew .acfCurrent_Rate__pc = 10;
        insert objAccountnew ;
        
        objOpportunity.AccountId = objAccountnew.id;
        update objOpportunity;       
        set<string> setOfAnswer = new set<string>();
        setOfAnswer.add(String.valueof(ObjAns.Id));
        
        List<string> lststr = new List<string>();
        lststr.add('abc@gmail.com');
        lststr.add('abcd@gmail.com');
        
        List<string> lststr1 = new List<string>();
        lststr1.add('abc@gmail.com');
        lststr1.add('abcd@gmail.com');
        
        acfCommon.sendSMS('','9876567898','test',true);
        if(lststr !=null && lststr.size() > 0)
        {
            acfCommon.sendTemplatedEmail(Id.valueof(string.valueof(objLead.Id).trim()),'test dfg wert dfgh','test asdf ghjk jhgf',lststr,lststr.clone());         
        }
        acfCommon.getLeadApiNameToType('Yes');
        acfCommon.isNullOrEmpty('abctest');
        acfCommon.checkEmail('ankit@gmail.com');
        acfCommon.checkEmail('ankit@gmail.com');
        acfCommon.sendReturnUrl(string.valueof(objUser1.Id),false,'clickDashbord','');
        acfCommon.getCurrentLoggedInContactId(objUser1.Id);
        acfCommon.getCurrentLoggedInLeadId(objUser1.Id);
        acfCommon.getCurrentLoggedInOpportunityId(objUser1.Id,'');
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            acfCommon.getRequiredDocumentsFromAnswersFromCRM(objLead.Id,setOfAnswer,acfCommon.getCommunitySetup('').Id);
        if(setOfAnswer !=null && setOfAnswer.size() > 0)
            acfCommon.getSuggestedProductsFromAnswers(objLead.Id,setOfAnswer,string.valueof(acfCommon.getCommunitySetup('').Id));
        acfCommon.IsValidDecimal(1.20);
        acfCommon.calculateMonthlyPayment(120000.98,150000,'Interest Only',12);
        acfCommon.redirect(objUser1.Id,'jumiointegration','');
        acfCommon.getRequiredDocumentsFromAnswers(objLead.Id,setOfAnswer);
        test.starttest();
        acfCommon.SendSMSUsingFuture('Ankit','9876567898','test',true);
        test.stoptest();
    
    }*/
    
        private static void LoadData()
    {
        createScript();
        createQuestion();
        createAnswer();
        createDocumentMaster();
        createLead();
        createProduct();
        createAccount();
        createuser();
        createOpportunity();
   //     createOppLineItem();
    }
    
    static void  createScript()
    {
        Objscript = new Script__c();
        Objscript = WLCommonTrackerClass.createScript('Pre-Login'); 
    }
    
    static void  createQuestion()
    {
        ObjQues = new Question__c();
        ObjQues = WLCommonTrackerClass.createQuestion(ObjQues); 
    }
    
     static void  createAnswer()
    {
        ObjAns = new Answer__c();
        ObjAns.acf_Question__c = ObjQues.Id;
        ObjAns = WLCommonTrackerClass.createAnswer(ObjAns); 
    }
    
      static void createDocumentMaster()
    {
        ObjDocument = new Document_Master__c();
        ObjDocument.Click_Community_Setup__c = clickCommon.getCommunitySetup('').Id;
        ObjDocument = WLCommonTrackerClass.createDocumentMaster(ObjDocument); 
        
        objDependentDoc = new Dependent_Document__c();
        objDependentDoc.Name = 'Test';
        objDependentDoc.acfActive__c = true;
        objDependentDoc.acfAnswer__c = ObjAns.Id;
        objDependentDoc.acfDocument_Master__c = ObjDocument.Id;
        insert objDependentDoc;
    }
        
    static void  createproduct()
    {
        objProduct2= new Product2();
        objProduct2 = WLCommonTrackerClass.createproduct(objProduct2);      
    }
    
    
    static void createLead()
    {
        objLead = new Lead();
        objLead = WLCommontrackerClass.createLeadForPortal();
        system.debug('objLead************'+objLead);
    }
        
    static void createAccount()
    {
       objacc = new account();
       objacc.acfApproximately_how_much_is_your_house__pc = 12.00;
       objacc.acfCurrent_Rate__pc = 10.20;
       objacc.acfCurrent_Loan_Amount__pc = 10.00;
       objacc.acfWhat_is_your_current_payment_type__pc ='Cash'; 
       objacc=WLCommonTrackerClass.createAccount(objacc); 
       system.debug('objacc************'+objacc);
    }
    
    static void createUser()
    {
        objUser1 = new User();
        objUser1 = WLCommonTrackerClass.CreatePortalUser(objacc.id);  
        system.debug('objUser1************'+objUser1);     
    }
    
     static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        system.debug('@@@@@test'+objUser1+'@@@@@@@@@@@'+objUser1.AccountId);
        list<Account> lstAccount = [select id from Account where personContactId =: objUser1.ContactId limit 1];
        objOpportunity.AccountId =lstAccount[0].id;
        objOpportunity.recordtypeid = acfCommon.GetRecordTypeId('Opportunity','Click Refi');
        objOpportunity.acfDate_Conditionally_Approved__c = system.today();
        objOpportunity.Description = 'test';
        objOpportunity.acfApproval_Conditions__c = 'testing';
        objOpportunity.acfDate_Formally_Approved__c = system.today();
        objOpportunity.acfDate_Docs_Generated__c = system.today();
        objOpportunity.acfExpected_Settlement_Date__c = system.today().adddays(+3);
        objOpportunity.acf_Status__c = 'Conditionally Approved';
        objOpportunity.acfTenure__c = 2.5;
        objOpportunity.name = 'test';
        objOpportunity.Stagename = 'Application Taken';
        objOpportunity.CloseDate = System.today();  
        objOpportunity.clickJumio_Status__c = 'Pending';   
        insert objOpportunity;
        system.debug('objOpportunity************'+objOpportunity);
    }  
    
    static void createOppLineItem()
    {
        pbk1= [select id,name from priceBook2 where isActive= true and isStandard = true limit 1];
        prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1');
        insert prd1;
        pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50,isActive=true);
        insert pbe1;
        lineItem1 = new OpportunityLineItem (OpportunityID=objOpportunity.id,PriceBookEntryID=pbe1.id,Quantity=1,TotalPrice=100);
        insert lineItem1;
    }  
}