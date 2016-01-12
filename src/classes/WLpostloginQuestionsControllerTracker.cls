@isTest(SeeAllData = true)
private without sharing class WLpostloginQuestionsControllerTracker 
{
    private static User objuser;
    private static Opportunity objOpportunity;
    private static Account objAccount;
    private static Contact objContact;
    private static Script__c objScript;
    private static Answer__c objAnswer;
    private static Answer__c objRelatedQuestionAnswer;
    private static Answer__c objRelatedQuestionAnswer1;
    private static Question__c objQuestion;
    private static Question__c objRelatedQuestion;
    private static Question__c objRelatedQuestion1;
    private static Lead objLead;
    private static User thisuser;
    //Constructor
    static testMethod void validateWLpostloginQuestionsController() 
    { 
        objLead       = WLCommonTrackerClass.createLeadForPortal();
        objAccount    = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser       = WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
        objScript     = WLCommonTrackerClass.createScript('Post-Login');
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,'acfApplicant2_Name__c','Contact',false,'',false);
        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'Westpac Bank');   
        System.runAs(objuser) 
        {
            WLpostloginQuestionsController objacfpostloginQuestionsController = new WLpostloginQuestionsController();
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
  //          objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            objacfpostloginQuestionsController.redirect();
 //           objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
      //      objacfpostloginQuestionsController.RelatedQuestions();
            objacfpostloginQuestionsController.AddingRelatedQuestion();
      //      objacfpostloginQuestionsController.NextQuestion();
            objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.IsValidDate(string.valueof(system.today()));
            objacfpostloginQuestionsController.CreateDateFromString(string.valueof(system.today()));
        }
    } 
    //Constructor
    static testMethod void validateWLpostloginQuestionsController0() 
    { 
        objLead = WLCommonTrackerClass.createLeadForPortal();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objAccount.acf_Applicant_Name__pc = '2';
        update objAccount;
        objuser    =  WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
        objScript     = WLCommonTrackerClass.createScript('Post-Login');
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Contact',true,'acfApplicant2_Name__c',true);
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,null,'acfApplicant2_Marital_Status__c','lead',true,'acfApplicant2_Monthly_Salary__c',true);
        
        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'2');  
//        System.runAs(objuser) 
//        {
            WLpostloginQuestionsController objacfpostloginQuestionsController = new WLpostloginQuestionsController();
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
  //          objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            objacfpostloginQuestionsController.redirect();
  //          objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            objacfpostloginQuestionsController.RelatedQuestions();
            objacfpostloginQuestionsController.AddingRelatedQuestion();
            objacfpostloginQuestionsController.NextQuestion();
            objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.InsertRequiredDocuments(objLead.id,objacfpostloginQuestionsController.lstMasterWrapperQuestion);
//        }
    } 
    //Constructor
    static testMethod void validateWLpostloginQuestionsController4() 
    { 
        objLead = WLCommonTrackerClass.createLeadForPortal();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objAccount.acf_Applicant_Name__pc = 'PAYG';
        update objAccount;
        objuser    =  WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
        objScript     = WLCommonTrackerClass.createScript('Post-Login');
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Contact',true,'acfApplicant2_Name__c',false);
        objQuestion.acfAppEmployment_Type__c = 'PAYG';
        objQuestion.acfEmployment_Type__c = true;
        objQuestion.acf_Dependents__c = false;
        update objQuestion;
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,null,'acfApplicant2_Marital_Status__c','lead',true,'acfApplicant2_Monthly_Salary__c',true);
        objRelatedQuestion.acfEmployment_Type__c = true;
        objRelatedQuestion.acfAppEmployment_Type__c = 'PAYG';
        objRelatedQuestion.acfDependent_Object_Name__c = null;
        objRelatedQuestion.acfDependent_Field_Name__c = null;
        objRelatedQuestion.acf_Dependents__c = false;
        update objRelatedQuestion;
        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, null,'PAYG');  
        objRelatedQuestionAnswer     = WLCommonTrackerClass.createAnswer(objRelatedQuestion.id, null,'PAYG');
//        System.runAs(objuser) 
//        {
            WLpostloginQuestionsController objacfpostloginQuestionsController = new WLpostloginQuestionsController();
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
     //       objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            objacfpostloginQuestionsController.redirect();
   //         objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            objacfpostloginQuestionsController.RelatedQuestions();
            
            objacfpostloginQuestionsController.AddingRelatedQuestion();
            objacfpostloginQuestionsController.NextQuestion();
            objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.InsertRequiredDocuments(objLead.id,objacfpostloginQuestionsController.lstMasterWrapperQuestion);
//        }
    }
      
    //For Adding Related Method
    static testMethod void validateWLpostloginQuestionsController1() 
    { 
        objLead = WLCommonTrackerClass.createLeadForPortal();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser    =  WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
        objScript     = WLCommonTrackerClass.createScript('Post-Login');
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
       // objQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,'acfApplicant2_Name__c','Contact');
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,null,'acfApplicant2_Marital_Status__c','lead',true,'acfApplicant2_Monthly_Salary__c',true);
        objRelatedQuestion.acfDependent_Object_Name__c = null;
        objRelatedQuestion.acfDependent_Field_Name__c = null;
        objRelatedQuestion.acf_Dependents__c = false;
        update objRelatedQuestion;   
        objRelatedQuestion1   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);

        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, objRelatedQuestion.id,'test'); 
        objRelatedQuestionAnswer = WLCommonTrackerClass.createAnswer(objRelatedQuestion.id, objRelatedQuestion1.id ,'test');
        objRelatedQuestionAnswer1 = WLCommonTrackerClass.createAnswer(objRelatedQuestion1.id, null ,'test');       
          
//        System.runAs(objuser) 
//        {
            WLpostloginQuestionsController objacfpostloginQuestionsController = new WLpostloginQuestionsController();
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
 //           objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            objacfpostloginQuestionsController.redirect();
 //           objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            
            objacfpostloginQuestionsController.RelatedQuestions();
           // objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].lstRelatedQuestion[0].strWrapAnswer = objRelatedQuestionAnswer.id;
            objacfpostloginQuestionsController.AddingRelatedQuestion();
            //objacfpostloginQuestionsController.QuesNo = 0;
            //objacfpostloginQuestionsController.MasterQuesNo = 0;
            objacfpostloginQuestionsController.NextQuestion();
            objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.InsertRequiredDocuments(objLead.id,objacfpostloginQuestionsController.lstMasterWrapperQuestion);
//        }
    }
    
    //For Adding Related Method
    static testMethod void ValidateAddingRelatedMethod() 
    { 
        objLead = WLCommonTrackerClass.createLeadForPortal();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser    =  wlCommonTrackerClass.CreatePortalUser(objAccount.id); 
        objScript     = WLCommonTrackerClass.createScript('Post-Login');
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Checkbox',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,'acfApplicant2_Name__c','Contact',false,'',false);
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);
        objRelatedQuestion1   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);

        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, objRelatedQuestion.id,'test'); 
        objRelatedQuestionAnswer = WLCommonTrackerClass.createAnswer(objRelatedQuestion.id, objRelatedQuestion1.id ,'test');
        objRelatedQuestionAnswer1 = WLCommonTrackerClass.createAnswer(objRelatedQuestion1.id, null ,'test');       
//        System.runAs(objuser) 
//        {
            WLpostloginQuestionsController objacfpostloginQuestionsController = new WLpostloginQuestionsController();
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
            if(objacfpostloginQuestionsController.lstMasterWrapperQuestion != null &&   objacfpostloginQuestionsController.lstMasterWrapperQuestion.size()>0)
            {
                objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;  
                objacfpostloginQuestionsController.redirect();
                objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id; 
            }  
       //     objacfpostloginQuestionsController.RelatedQuestions();
            //objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].lstRelatedQuestion[0].strWrapAnswer = objRelatedQuestionAnswer1.id;
            objacfpostloginQuestionsController.AddingRelatedQuestion();
      //      objacfpostloginQuestionsController.NextQuestion();
            objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.InsertRequiredDocuments(objLead.id,objacfpostloginQuestionsController.lstMasterWrapperQuestion);
       }
//    }
    
     //For Adding Related Method
    static testMethod void ValidateAddingRelatedMethod1() 
    { 
        objLead = WLCommonTrackerClass.createLeadForPortal();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser    =  WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
        objScript     = WLCommonTrackerClass.createScript('Post-Login');
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Checkbox',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
        objQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,'acfApplicant2_Name__c','Contact',false,'',false);
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);
        objRelatedQuestion1   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);

        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, objRelatedQuestion.id,'test'); 
        objRelatedQuestionAnswer = WLCommonTrackerClass.createAnswer(objRelatedQuestion.id, objRelatedQuestion1.id ,'test');
        objRelatedQuestionAnswer1 = WLCommonTrackerClass.createAnswer(objRelatedQuestion1.id, null ,'test');       
//        System.runAs(objuser) 
//       {
            WLpostloginQuestionsController objacfpostloginQuestionsController = new WLpostloginQuestionsController();
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
            if(objacfpostloginQuestionsController.lstMasterWrapperQuestion != null && objacfpostloginQuestionsController.lstMasterWrapperQuestion.size()>0)
            {
            objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            objacfpostloginQuestionsController.redirect();
            objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            }
      //      objacfpostloginQuestionsController.RelatedQuestions();
             //objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].lstRelatedQuestion[0].strWrapAnswer = objRelatedQuestionAnswer1.id;
            objacfpostloginQuestionsController.AddingRelatedQuestion();
    //        objacfpostloginQuestionsController.NextQuestion();
            objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.InsertRequiredDocuments(objLead.id,objacfpostloginQuestionsController.lstMasterWrapperQuestion);
//        }
    }
    
    //For Assets and Liabilities
    static testMethod void validateWLpostloginQuestionsController11() 
    { 
        objLead = WLCommonTrackerClass.createLeadForPortal();
        objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser    =  WLCommonTrackerClass.CreatePortalUser(objAccount.id); 
        objScript     = WLCommonTrackerClass.createScript('Post-Login');
        objQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,objScript.id,'acf_Applicant_Name__c','Lead',false,'',false);
       // objQuestion   = acfCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,objScript.id,'acfApplicant2_Name__c','Contact');
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);
        objRelatedQuestion   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Button',false,true,null,'acfApplicant2_Marital_Status__c','lead',true,'acfApplicant2_Monthly_Salary__c',true);
        objRelatedQuestion.acfDependent_Object_Name__c = null;
        objRelatedQuestion.acfDependent_Field_Name__c = null;
        objRelatedQuestion.acf_Dependents__c = false;
        update objRelatedQuestion;   
        objRelatedQuestion1   = WLCommonTrackerClass.CreatePostLoginQuestions('Who is your current lender?',1,'Text',true,false,null,null,null,false,'',false);

        objAnswer     = WLCommonTrackerClass.createAnswer(objQuestion.id, objRelatedQuestion.id,'test'); 
        objRelatedQuestionAnswer = WLCommonTrackerClass.createAnswer(objRelatedQuestion.id, objRelatedQuestion1.id ,'test');
        objRelatedQuestionAnswer1 = WLCommonTrackerClass.createAnswer(objRelatedQuestion1.id, null ,'test');       
          
//        System.runAs(objuser) 
//        {
            WLpostloginQuestionsController objacfpostloginQuestionsController = new WLpostloginQuestionsController();
            objacfpostloginQuestionsController.QuesNo = 0;
            objacfpostloginQuestionsController.MasterQuesNo = 0;
            if(objacfpostloginQuestionsController.lstMasterWrapperQuestion != null && objacfpostloginQuestionsController.lstMasterWrapperQuestion.size()>0)
            {
                objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
                objacfpostloginQuestionsController.redirect();
                objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].strWrapAnswer = objAnswer.id;
            }
            objacfpostloginQuestionsController.RelatedQuestions();
            //objacfpostloginQuestionsController.lstMasterWrapperQuestion[0].lstRelatedQuestion[0].strWrapAnswer = objRelatedQuestionAnswer.id;
            objacfpostloginQuestionsController.AddingRelatedQuestion();
            //objacfpostloginQuestionsController.QuesNo = 0;
            //objacfpostloginQuestionsController.MasterQuesNo = 0;
 //           objacfpostloginQuestionsController.NextQuestion();
            //objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.MasterQuesNo = 1;
      //      objacfpostloginQuestionsController.AssetLiablity();
            objacfpostloginQuestionsController.PreviousQuestion();
            objacfpostloginQuestionsController.assetaddMethodNRAC();
            objacfpostloginQuestionsController.InsertRequiredDocuments(objLead.id,objacfpostloginQuestionsController.lstMasterWrapperQuestion);
//        }
    }
    
}