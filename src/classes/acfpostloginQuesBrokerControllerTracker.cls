@isTest(SeeAllData = true)
private class acfpostloginQuesBrokerControllerTracker
{

    private static Opportunity objOpportunity;
    private static Account objAccount;
    private static Contact objContact;
    private static Script__c objScript;
    private static  Answer__c objAnswer;
    private static  Answer__c objRelatedQuestionAnswer;
    private static  Answer__c objRelatedQuestionAnswer1;
    private static  Question__c objRelatedQuestion;
    private static  Question__c objRelatedQuestion1;
    private static Lead objLead;
    private static User thisuser;
    public static Question__c objQuestion;
    public static User objUser;
    public static acfBank_Detail__c objBankDetail;
    public static click_Applicant__c objApplicant;
    public static string strapplicantName;
    public static string strAppSeqNo;
    public static string strapplicantEmail;
    public static string strPhone;
    public static integer QuesNo;
    static testMethod void M1(){

        loadData();

        QuesNo = 1;
        Integer intTempQues;
        intTempQues = QuesNo +1;
        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid',objAccount.id);
        acfpostloginQuestionsController_partner obj = new acfpostloginQuestionsController_partner();

        obj.MasterQuesNo = 0;
        obj.RelatedQuestions();
     //   obj.AddingRelatedQuestion();
        obj.checkQuestionStaus();
        obj.redirect();
        obj.MasterQuesNo = 0;
        obj.NextQuestion();
  //      obj.PreviousQuestion();
        obj.AssetLiablity();
        obj.IsValidDate('2015-10-12');
        obj.CreateDateFromString('2015-10-12');
        obj.checkUserResponse();
        obj.app2Email = 'test@gmail.com';
        obj.accountname = 'ttt';
        obj.issApplicant2Check = true;
     
        
      
        obj.sendApplicantConsentMailandSms();
        obj.applicant2consent();

    }

    /*static testMethod void validateClickpostloginQuestionsController()
    {
        CreateData();

        PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid',objAccount.id);

        objScript=new Script__c();
        objScript     = acfCommonTrackerClass.createScript('Post-Login');
        objQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,'acfApplicant2_Name__c','Contact',false,'',false);
        objAnswer     = acfCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');
        //      System.runAs(objuser)
        //      {
        acfpostloginQuestionsController_partner objacfpostloginQuestionsController = new acfpostloginQuestionsController_partner();
        objacfpostloginQuestionsController.UserAccountId=objaccount.id;
        objacfpostloginQuestionsController.QuesNo = 0;
        objacfpostloginQuestionsController.MasterQuesNo = 0;
        acfpostloginQuestionsController_partner.WrapperQuestions lstwrap=new acfpostloginQuestionsController_partner.WrapperQuestions();
        lstwrap.objWrapQuestion=objQuestion;
        lstwrap.strWrapAnswer=objAnswer.id;
        objacfpostloginQuestionsController.lstMasterWrapperQuestion.add(lstwrap);
        objacfpostloginQuestionsController.redirect();
        objacfpostloginQuestionsController.lstMasterWrapperQuestion.add(lstwrap);
        objacfpostloginQuestionsController.RelatedQuestions();
        objacfpostloginQuestionsController.AddingRelatedQuestion();
        objacfpostloginQuestionsController.NextQuestion();
  //      objacfpostloginQuestionsController.PreviousQuestion();
        objacfpostloginQuestionsController.AssetLiablity();
        objacfpostloginQuestionsController.assetaddMethodNRAC();
        objacfpostloginQuestionsController.IsValidDate(string.valueof(system.today()));
        objacfpostloginQuestionsController.CreateDateFromString(string.valueof(system.today()));

        acfpostloginQuestionsController_partner obj = new acfpostloginQuestionsController_partner();



        obj.NextQuestion();
        obj.checkUserResponse();
        obj.app2Email = 'test@gmail.com';
        obj.accountname = 'ttt';
        obj.issApplicant2Check = true;
        obj.sendApplicantConsentMailandSms();

        obj.applicant2consent();
        //        }
    }

    static testMethod void validateClickpostloginQuestionsController0()
    {
        CreateData();
         PageReference pageRef = new PageReference('http://www.google.com');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid',objAccount.id);

        objAccount.acf_Applicant_Name__pc = '2';
        update objAccount;
         Account objAccount2 = new Account();
        //objAccount.recordtype.name='Business Account';
        objAccount2.name='testname';
        insert objAccount2;
        objContact = new Contact();
        objContact.AccountId = objAccount2.id;
        objContact.LastName = 'test';
        objContact.email = 'swati.sharma@saasfocus.com';
        insert objContact;
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        Profile prfile = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
        user objUser2 = new User(
        profileId = prfile.id,
        username = 'newUsertestnew09876545@yahoo.com',
        email = 'pb@f.com',
        emailencodingkey = 'UTF-8',
        localesidkey = 'en_US',
        languagelocalekey = 'en_US',
        timezonesidkey = 'America/Los_Angeles',
        alias='nuser',
        lastname='lastname',
        contactId = objContact.id
        );
        insert objUser2;
        objScript     = acfCommonTrackerClass.createScript('Post-Login');
        objQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Contact',true,'acfApplicant2_Name__c',true);
        objRelatedQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,null,'acfApplicant2_Marital_Status__c','lead',true,'acfApplicant2_Monthly_Salary__c',true);
        objAnswer     = acfCommonTrackerClass.createAnswer(objQuestion.id, null,'2');

        System.runAs(objUser2)
        {
            acfpostloginQuestionsController_partner objacfpostloginQuestionsController = new acfpostloginQuestionsController_partner();
            objacfpostloginQuestionsController.UserAccountId=objaccount.id;
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
            acfpostloginQuestionsController_partner.WrapperQuestions lstwrap=new acfpostloginQuestionsController_partner.WrapperQuestions();
            lstwrap.objWrapQuestion=objQuestion;
            lstwrap.strWrapAnswer=objAnswer.id;
            objacfpostloginQuestionsController.lstMasterWrapperQuestion.add(lstwrap);
            objacfpostloginQuestionsController.redirect();
            objacfpostloginQuestionsController.lstMasterWrapperQuestion.add(lstwrap);
            objacfpostloginQuestionsController.RelatedQuestions();
            objacfpostloginQuestionsController.AddingRelatedQuestion();
            //objacfpostloginQuestionsController.NextQuestion();
     //       objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.InsertRequiredDocuments(objLead.id,objacfpostloginQuestionsController.lstMasterWrapperQuestion);
        }
    }
    public static void CreateData()
    {



        acfpreloginQuesBrokerControllerTracker.ValidateNewLoan();
        objAccount=acfpreloginQuesBrokerControllerTracker.objAccount;
        objLead=acfpreloginQuesBrokerControllerTracker.objLead;
        objUser=acfpreloginQuesBrokerControllerTracker.objUser;
        //system.AssertNotEquals(objUser.id,null);
    }*/
    public static void loadData(){

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'test2222@test.com',
        Alias = 'batman',
        Email='test@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
        );
        insert portalAccountOwner1;

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

        System.runAs ( portalAccountOwner1 ) {
        //Create account
        objAccount = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
        );
        Database.insert(objAccount);
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.acfIs_Post_Login_Ques_Attempted__c = true;
        insert ld;
        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = objAccount.Id,
        acf_lead__c = ld.id,
        Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);

        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' LIMIT 1];
        objUser = new User(
        Username = System.now().millisecond() + 'test12345@test.com',
        ContactId = contact1.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test123',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        Database.insert(objUser);

        objScript = new Script__c();
        Id recorsTypeId  = acfCommon.GetRecordTypeId('Script__c','Post-Login');
        objScript.RecordTypeId = recorsTypeId;
        objScript.acf_Type__c = 'Post-Login';
        objScript.acf_Sequence_no__c = 1;
        objScript.acf_Question_Type__c = 'Applicant Details';
        //objScript.Click_Community_Setup__c = 'a2SO0000001PtV9';
        insert objScript;
        //objQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Contact',true,'acfApplicant2_Name__c',true);
        //objRelatedQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,null,'acfApplicant2_Marital_Status__c','lead',true,'acfApplicant2_Monthly_Salary__c',true);

              strapplicantName = '';
        strAppSeqNo = '';
        strapplicantEmail  ='';
        strPhone ='';
        strapplicantName ='MB test';
        strAppSeqNo = '2';
        strapplicantEmail = 'abc@gmail.com';
         strPhone ='9855421202';
        objApplicant = new click_Applicant__c();
        objApplicant.acf_Applicant_Name__c = strapplicantName;
        objApplicant.Applicant_Email__c = strapplicantEmail;     
        objApplicant.Applicant_Phone__c = strPhone;
        insert objApplicant;

        objQuestion = new Question__c ();
        objQuestion.acf_Question__c = 'Who is your current lender?04xxxxxxx';
        objQuestion.acf_Active__c  = true;
        objQuestion.acfRefinance_Sequence_No__c = 1;
        objQuestion.acf_Type__c                 = 'Button';
        objQuestion.acfNew_Loan_Sequence_No__c  = 1.0;
        objQuestion.acfIs_refinance__c          = true;
        objQuestion.acf_Script__c               = objScript.id;
        objQuestion.acfIs_New_Loan__c           = true;
        objQuestion.acf_ApiName__c              = 'acfApplicant2_Name__c';
        objQuestion.acfDependent_Object_Name__c = 'Lead';
        objQuestion.acfDependent_Field_Name__c  = 'acfApproximately_how_much_is_your_house__c';
        objQuestion.acf_Dependents__c = true;
        objQuestion.acfApplicant_2_Api_Name__c = 'acfApplicant2_email__c';
        objQuestion.acfIs_Applicant_Question__c = false;
        objQuestion.acfReplace_Mobile_No__c = true;
        objQuestion.acfDependent_Value__c = 'test';
        objQuestion.acfEmployment_Type__c = true;
        insert objQuestion;

        objRelatedQuestion = new Question__c ();
        objRelatedQuestion.acf_Question__c = 'Who is your current lender?04xxxxxxx';
        objRelatedQuestion.acf_Active__c  = true;
        objRelatedQuestion.acfReplace_Mobile_No__c = true;
        objRelatedQuestion.acfRefinance_Sequence_No__c = 1;
        objRelatedQuestion.acf_Type__c                 = 'Text';
        objRelatedQuestion.acfNew_Loan_Sequence_No__c  = 1.0;
        objRelatedQuestion.acfIs_refinance__c          = true;
        objRelatedQuestion.acf_Script__c               = objScript.id;
        objRelatedQuestion.acfIs_New_Loan__c           = true;
        objRelatedQuestion.acf_ApiName__c              = 'acfEconsent_App2__c';
        objRelatedQuestion.acfDependent_Object_Name__c = 'Contact';
        objRelatedQuestion.acfDependent_Field_Name__c  = 'acfApproximately_how_much_is_your_house__c';
        objRelatedQuestion.acf_Dependents__c = true;
        objRelatedQuestion.acfApplicant_2_Api_Name__c = 'acfApplicant2_phone__c';
        objRelatedQuestion.acfIs_Applicant_Question__c = false;
        objRelatedQuestion.acfDependent_Value__c = 'test';
        objRelatedQuestion.acfEmployment_Type__c = true;
        insert objRelatedQuestion;

        Question__c objQuestion1 = new Question__c ();
        objQuestion1.acf_Question__c = '04xxxxxxxWho is your current lender?';
        objQuestion1.acf_Active__c  = true;
        objQuestion1.acfRefinance_Sequence_No__c = 1;
        objQuestion1.acf_Type__c                 = 'Button';
        objQuestion1.acfNew_Loan_Sequence_No__c  = 1.0;
        objQuestion1.acfIs_refinance__c          = true;
        //objQuestion1.acf_Script__c               = objScript.id;
        objQuestion1.acfEmployment_Type__c = true;
        objQuestion1.acfIs_New_Loan__c           = true;
        objQuestion1.acf_ApiName__c              = 'acfEconsent__c';
        objQuestion1.acfDependent_Object_Name__c = 'Lead';
        objQuestion1.acfDependent_Field_Name__c  = 'acfApproximately_how_much_is_your_house__c';
        objQuestion1.acf_Dependents__c = true;
        objQuestion1.acfApplicant_2_Api_Name__c = 'affiliate_source__c';
        objQuestion1.acfIs_Applicant_Question__c = false;
        objQuestion1.acfReplace_Mobile_No__c = true;
        objQuestion1.acfDependent_Value__c = 'test';
        insert objQuestion1;

        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'2');
        }
    }
}