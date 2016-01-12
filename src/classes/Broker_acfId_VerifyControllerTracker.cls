@isTest
private class Broker_acfId_VerifyControllerTracker{
     private static Lead objLead;
    private static User objUser;
    private static Contact objContact;
    private static Account objAccount;
    private static Opportunity objOpportunity;
    
    private static void LoadData()
    {
        createLead();
        createAccount();
        createContact();
        createUser();
        createOpportunity();

    }
    
     static void createLead()
    {
        objLead = new Lead();
        objLead = acfCommonTrackerClass.createLeadForPortal();
    }
    
    static void createAccount()
    {
        objAccount = new Account();
        //objAccount.recordtype.name='Business Account';
        objAccount.name='testname';
        insert objAccount;
        //objAccount = acfCommontrackerClass.createAccount(objaccount);
    }
    
    static void createContact()
    {
        
        objContact = new Contact();
        //objContact.AccountId = objAccount.id;
        //objContact.acf_lead__c = objLead.id;
        objContact = acfCommontrackerClass.createPartnerContact(objContact,objAccount);
        
        
        
    }
    
    static void createuser()
    {
        objUser = new User();
        objUser.MobilePhone='+611234567890';
        
        objUser.contactId=objContact.Id;
         List<Profile> lstCommUserProfile = [select id,name from profile where name='Customize Partner User' limit 1];
            //List<Account>lstPersonContact = [select id,PersonContactId from Account where id=:ContactId];
            //User objUser = new User();
            objUser.FirstName = 'test';
            objUser.LastName = 'test';
            objUser.Alias  = ('test'+String.valueof(Math.random())).substring(0,5);
            objUser.LocaleSidKey = 'en_AU';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.MobilePhone = '+6145678904';
            objUser.Username = 'test@fakeEmail.com'+objUser.Alias;
            objUser.Email = 'test@fakeEmail.com';
            objUser.ProfileId = lstCommUserProfile[0].id;
            //objUser.ContactId = lstPersonContact[0].PersonContactId;
            objuser.EmailEncodingKey = 'UTF-8';
            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
            objUser.TimeZoneSidKey = 'Australia/Brisbane';
            objUser.acfIs_Password_Reset__c = true;
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            objUser.setOptions(dlo);
            insert(objUser);
            //return objUser;
        
        
        
        //objUser = acfCommonTrackerClass.CreatePartnerPortalUser(objContact.id); 
    }
    
    static void createOpportunity()
    {
      objOpportunity = new Opportunity();
      objOpportunity.acfBankdetailStatus__c = 'Skipped';
      objOpportunity = acfCommontrackerClass.createOpportunity(objOpportunity,objUser);
    }
    

    static testMethod void myUnitTest() {
      
      LoadData();
      PageReference pageRef = new PageReference('http://www.google.com');
      Test.setCurrentPage(pageRef);
      ApexPages.currentPage().getParameters().put('cid',objAccount.id);  
      
      Broker_acfId_VerifyController obj = new Broker_acfId_VerifyController();
      obj.Test1();
      obj.Test2();
      obj.Test3();
      obj.Test4();
      obj.Test5();
      obj.Test6();
      obj.Test7();
      obj.Test8();
      obj.Test9();
      obj.Test10();
      obj.Test11();
      obj.Test12();
      obj.Test13();
      obj.Test14();
      obj.Test15();
      obj.Test16();
      obj.Test17();
      obj.Test18();
      obj.Test19();
      obj.Test20();
      obj.Test21();
      obj.Test22();
      obj.Test23();
      obj.Test24();
      obj.Test25();
      obj.Test26();
      obj.Test27();
      obj.Test28();
      obj.Test29();
      obj.Test30();
      obj.Test31();
      obj.Test32();
      obj.Test33();
      obj.Test34();
      obj.Test35();
      obj.Test36();
      obj.Test37();
      obj.Test38();
      obj.Test39();
      obj.Test40();
      obj.Test41();
      obj.Test42();
      obj.Test43();
      obj.Test44();
      obj.Test45();
      obj.Test46();
      obj.Test47();
      obj.Test48();
      obj.Test49();
      obj.Test50();
      obj.Test51();
      obj.Test52();
      obj.Test53();
      obj.Test54();
      obj.Test55();
      obj.Test56();
      obj.Test57();
      obj.Test58();
      obj.Test59();
      obj.Test60();
      obj.Test61();
      obj.Test62();
      obj.Test63();
      obj.Test64();
      obj.Test65();
      obj.Test66();
      obj.Test67();
      obj.Test68();
      obj.Test69();
      obj.Test70();
      obj.Test71();
      obj.Test72();
      obj.Test73();
      obj.Test74();
       obj.Test75();
      obj.Test76();
      obj.Test77();
      obj.Test78();
      obj.Test79();
       obj.Test80();
      obj.Test81();
      obj.Test82();
      obj.Test83();
      obj.Test84();
       obj.Test85();
      obj.Test86();
      obj.Test87();
      obj.Test88();
      obj.Test89();
       obj.Test90();
      obj.Test91();
      obj.Test92();
      obj.Test93();
      obj.Test94();
       obj.Test95();
      obj.Test96();
      obj.Test97();
      obj.Test98();
      obj.Test99();
       obj.Test100();
     

                obj.Test101();
                obj.Test102();
                obj.Test103();
                obj.Test104();
                obj.Test105();
                obj.Test106();
                obj.Test107();
                obj.Test108();
                obj.Test109();
                obj.Test110();
                obj.Test111();
                obj.Test112();
                obj.Test113();
                obj.Test114();
                obj.Test115();
                obj.Test116();
                obj.Test117();
                obj.Test118();
                obj.Test119();
                obj.Test120();
                obj.Test121();
                obj.Test122();
                obj.Test123();
                obj.Test124();
                obj.Test125();
                obj.Test126();
                obj.Test127();
                obj.Test128();
                obj.Test129();
                obj.Test130();
                obj.Test131();
                obj.Test132();
                obj.Test132();
                obj.Test133();
                obj.Test134();
                obj.Test135();
                obj.Test136();
                obj.Test137();
                obj.Test138();
                obj.Test139();
                obj.Test140();
                obj.Test141();
                obj.Test142();
                obj.Test143();
                obj.Test144();
                obj.Test145();
                obj.Test146();
                obj.Test147();
                obj.Test148();
                obj.Test149();
                obj.Test150();
                obj.Test151();
                obj.Test151();
obj.Test152();
obj.Test153();
obj.Test154();
obj.Test155();
obj.Test156();
obj.Test157();
obj.Test158();
obj.Test159();
obj.Test160();
obj.Test161();
obj.Test162();
obj.Test163();
obj.Test164();
obj.Test165();
obj.Test166();
obj.Test167();
obj.Test168();
obj.Test169();
obj.Test170();
obj.Test171();
obj.Test172();
obj.Test173();
obj.Test174();
obj.Test175();
obj.Test176();
obj.Test177();
obj.Test178();
obj.Test179();
obj.Test180();
obj.Test181();
obj.Test182();
obj.Test183();
obj.Test184();
obj.Test185();
obj.Test186();
obj.Test187();
obj.Test188();
obj.Test189();
obj.Test190();
obj.Test191();
obj.Test192();
obj.Test193();
obj.Test194();
obj.Test195();
obj.Test196();
obj.Test197();
obj.Test198();
obj.Test199();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test200();
obj.Test201();
obj.Test202();
obj.Test203();
obj.Test204();
obj.Test205();
obj.Test206();
obj.Test207();
obj.Test208();
obj.Test209();
obj.Test210();
obj.Test211();
obj.Test212();
obj.Test213();
obj.Test214();
obj.Test215();
obj.Test216();
obj.Test217();
obj.Test218();
obj.Test219();
obj.Test220();
obj.Test221();
obj.Test222();
obj.Test223();
obj.Test224();
obj.Test225();
obj.Test226();
obj.Test227();
obj.Test228();
obj.Test229();
obj.Test230();
obj.Test231();
obj.Test232();
obj.Test233();
obj.Test234();
obj.Test235();
obj.Test236();
obj.Test237();
obj.Test238();
obj.Test239();
obj.Test240();
obj.Test241();
obj.Test242();
obj.Test243();
obj.Test244();
obj.Test245();
obj.Test246();
obj.Test247();
obj.Test248();
obj.Test249();
obj.Test250();
obj.Test251();
obj.Test252();
obj.Test253();
obj.Test254();
obj.Test255();
obj.Test256();
obj.Test257();
obj.Test258();
obj.Test259();
obj.Test260();
obj.Test261();
obj.Test262();
obj.Test263();
obj.Test264();
}
}