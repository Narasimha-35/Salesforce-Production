/*====================================================
Click Loans
========================================================*/
public without sharing class acfpostloginQuestionsController_partner
{
    
    public String strNRAC { get; set; }
    public integer intQuoteWidth {get;set;}
    public PageReference assetaddMethodNRAC() {
        strNRAC = 'Hi NRAC';
        return null;
    }
 
    public string strmsg{get;set;}
    public String IsSlideToNextQues { get; set; }
    public map<id,Question__c>mapQuestionIdToQuestion;
    public integer ScriptIndexNo{get;set;}
    public integer ScriptQuestionNo{get;set;}
    public integer RelatedQuesNo{get;set;}
    public List<WrapperQuestions>lstMasterWrapperQuestion{get;set;}
    public List<WrapperScript>lstWrapperScript{get;set;}
    public map<string,List<Question__c>>mapScriptIdToListOfQuestions{get;set;}
    public List<Script__c>lstScriptQuestionsLadder{get;set;}
    public string IsSlide{get;set;}
    public integer QuesNo{get;set;}
    Public Integer NoOfRightSlide{get;set;}
    public Integer NoOfLeftSlide{get;set;}
    public Id LoggedInContact;
    public Id LoggedInLeadId;
    public map<string,string>mapContactAPINameToSelectedAnswer;
    List<string>lstContactAPINames = new List<string>();
    public map<string,string>mapAnswerNameToAnswerId;
    public integer TotalNoQuestionSlide{get;set;}
    public Integer MasterQuesNo{get;set;}
    Public Integer intTotalQuestions {get;set;}
    public string strMobileNumber{get;set;}
    Public String strBubbleText {get;set;}
    Public String IsSkipDependent {get;set;}
    Public Map<String,String> mapDependentQuestoValue;
    Public String strleadQues;
    Public String strAccQues; 
    Public String strCurrentLoggedInAccount;
    Public Set<String> setQuesAccountAPInames; 
    Public Set<String> setQuesLeadAPInames;
    Public boolean isRelatedQuesDisplay;
    Public List<user> lstuserMobile{get;set;}
    public Integer NoOfPrePostdependent{get;set;}
    public Id userId{get;set;}
    public string UserAccountId{get;set;}
    public string IsConcentQuestion{get;set;}
    public integer Waitingcount{get;set;}
    public integer consentSequence{get;set;}
    public string accountEmail{get;set;}
    public string accountname{get;set;}
    public string accountPhone{get;set;}
    public string app2Email{get;set;}
    public string app2Phone{get;set;}
    public boolean issApplicant2Check{get;set;} 
    //multiple applicants added on 14-03-2016 by karthik
    Public string strApplicaneQues;
    public map<string,string> mapAppNoToAppId;
    public set<string> lstApplicantAPIName = new set<string>();
    public map<string,string>mapApplicantAPINameToSelectedAnswer;
    public Decimal intNoOfApplicants{get;set;}
    public list<integer> lstMultipleAppScriptIndex;
    public set<string> setQuesApplicantAPInames;
    public map<integer,string> mapDecTostring;
    public list<account> accountObj;
    public string strAppSeqNo {get;set;}
    public map<string,boolean> mapAppNoToisEmailExist{get;set;}
    public map<string,click_Applicant__c> mapAppNoToApplicantObj;
    public boolean isAppDetailDone{get;set;}
    public ApplicantDetailsWrapper appWrapObj{get;set;}
    public  List<ApplicantDetailsWrapper> appDetailsWrapListNew;
    public integer intConsentIndex;
    Public string strNoOfApp{get;set;}
    Public boolean isConsentDone{get;set;}
    Public boolean isAllConsentDone{get;set;}

    public acfpostloginQuestionsController_partner()
    {
        
        try
        {   
            app2Phone='+61';
            Waitingcount=0;
            IsSlide = 'false';
            isRelatedQuesDisplay = false;
            strMobileNumber = '';
            NoOfLeftSlide = 0;
            NoOfPrePostdependent = 0;
            MasterQuesNo = 0;
            NoOfRightSlide = 0;
            TotalNoQuestionSlide =0;
            strleadQues = '';
            strAccQues = '';
            strApplicaneQues = '';
            strCurrentLoggedInAccount = '';
            IsSkipDependent = '';
            strAppSeqNo = '0';
            intConsentIndex = 0;
            setQuesAccountAPInames = new set<string>();
            setQuesLeadAPInames = new set<string>();
            mapAnswerNameToAnswerId = new map<string,string>();
            mapDependentQuestoValue = new Map<string,string>();
            strmsg  = '';
            mapQuestionIdToQuestion = new map<id,Question__c>();
            lstScriptQuestionsLadder = new List<Script__c>();
            set<Id>setScriptId = new set<Id>();
            lstWrapperScript = new List<WrapperScript>();
            lstMasterWrapperQuestion = new List<WrapperQuestions>();
            List<Question__c>lstMasterQuestion = new List<Question__c>();
            List<Script__c>lstScript = new List<Script__c>();
            mapScriptIdToListOfQuestions = new map<string,List<Question__c>>();
            ScriptIndexNo = 0;
            ScriptQuestionNo = 0;
            strNoOfApp = '0';
            app2Email = '';
            isAppDetailDone = false;
            //multiple applicants
            mapAppNoToAppId = new map<string,string>();
            mapApplicantAPINameToSelectedAnswer = new map<string,string>();
            intNoOfApplicants = integer.valueof(system.label.clickNumber_Of_Applicants);
            lstMultipleAppScriptIndex = new list<integer>();
            setQuesApplicantAPInames = new set<string>();
            appDetailsWrapListNew = new List<ApplicantDetailsWrapper>();
            UserAccountId=  ApexPages.currentPage().getParameters().get('cid'); 
            accountObj = new list<Account>();
            if(UserAccountId==null || UserAccountId=='' ){                          
            }else{
                    list<click_Applicant__c> lstApplicant = [select id,click_Account__c,click_Account__r.personContactId,acfEmployment_Type__c,click_Applicant_Number__c 
                                                            from click_Applicant__c where click_Account__c =: UserAccountId];
                    if(lstApplicant != null && lstApplicant.size()>0)
                    {
                        for(click_Applicant__c objApp : lstApplicant)
                        {
                            mapAppNoToAppId.put(objApp.click_Applicant_Number__c,objApp.id);                    
                            //mapAppNoToEmpTypeValue.put(objApp.click_Applicant_Number__c,objApp.acfEmployment_Type__c);
                        }                
                    }
                lstuserMobile = [select id,MobilePhone,account.acfEconsent__pc,account.acfEconsent_App2__pc,account.acfNumber_Of_Applicants__pc,
                                 account.acfApplicant2_Name__pc,
                                 accountId,firstname,lastname,account.Account_Email__c,
                                 account.name,account.Phone,account.acfApplicant2_email__pc,account.acfApplicant2_phone__pc,account.acf_Lead__pc from 
                                 user where AccountId=:UserAccountId limit 1
                                ];                              
                userId=lstuserMobile[0].Id;
                If(lstuserMobile != null && lstuserMobile .size()>0){
                    strCurrentLoggedInAccount = lstuserMobile[0].accountId;
                }
                if(lstuserMobile <> null && lstuserMobile.size()>0)
                {
                    strMobileNumber = lstuserMobile[0].MobilePhone;
                }
                LoggedInContact = acfCommon.getCurrentLoggedInContactId(userId);
                LoggedInLeadId  = acfCommon.getCurrentLoggedInLeadId(userId); 
                
                system.debug('____@@@@____'+LoggedInContact);
                //LoggedInContact = '003O000000lOBRfIAO';
                list<Click_Community_Setup__c> commSetupObj=new list<Click_Community_Setup__c>();
                commSetupObj=[Select id from Click_Community_Setup__c where name ='ClickLoans' limit 1];
                string setupID='';
                if(commSetupObj.size()>0){
                    setupID =commSetupObj[0].id;                   
                }else{
                    setupID ='a2SO0000001PtV9';  
                }
                
                for(Script__c objScript : [select id,acf_Sequence_no__c,clickAsk_for_every_applicant__c,acf_Type__c,acf_Stage_Name__c,acf_Question_Type__c  from Script__c where acf_Type__c=:'Post-Login' AND Click_Community_Setup__c =:setupID   order by acf_Sequence_no__c asc])
                {
                    setScriptId.add(objScript.id);
                    lstScript.add(objScript);
                }                
                system.debug('@@@'+setScriptId);                
                if(setScriptId.size()>0)
                {
                    lstScriptQuestionsLadder  = [select id,acf_Sequence_no__c,acf_Type__c,acf_Stage_Name__c from Script__c where acf_Type__c=:'Post-Login' AND Click_Community_Setup__c =:setupID   order by acf_Sequence_no__c desc];
                    //intTotalQuestions = lstScriptQuestionsLadder.size();
                    
                    intTotalQuestions = 0;
                    for(Question__c objQuestion:[select id,acf_ApiName__c,click_is_EConsent__c,acfDependent_Field_Name__c,acfDependent_Object_Name__c,acfDependent_Value__c,acf_Description__c,acfReplace_Mobile_No__c,Date__c,acfApplicant_2_Api_Name__c,acf_Master_Question__c,acfAppEmployment_Type__c,acfIs_Applicant_Question__c,acf_Question__c,acf_Script__c,acfEmployment_Type__c,acf_Dependents__c,acf_Postal_Code__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfBubble_Text__c,acfWatermark_Text__c,
                                                 acfComponent_Type__c,(select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                 where ((acf_Master_Question__r.acf_Script__c in: setScriptId or acf_Script__c in:setScriptId) and acf_Active__c = true) and Click_Is_Broker_Question__c=false order by acf_Sequence_No__c asc ])  
                    {                
                        
                        mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                        
                        if(objQuestion.acf_Script__c <> null)
                        {
                            if(mapScriptIdToListOfQuestions.get(objQuestion.acf_Script__c) == null)
                                mapScriptIdToListOfQuestions.put(objQuestion.acf_Script__c,new List<Question__c>());
                            mapScriptIdToListOfQuestions.get(objQuestion.acf_Script__c).add(objQuestion);   
                            If(objQuestion.acfDependent_Field_Name__c <> null && objQuestion.acfDependent_Object_Name__c <> null)
                            {
                                If(objQuestion.acfDependent_Object_Name__c == 'Contact')
                                {
                                    setQuesAccountAPInames.add(objQuestion.acfDependent_Field_Name__c);
                                    //strAccQues = strAccQues+objQuestion.acfDependent_Field_Name__c+',';
                                } 
                                if(objQuestion.acfDependent_Object_Name__c == 'Lead')
                                {
                                    setQuesLeadAPInames.add(objQuestion.acfDependent_Field_Name__c);
                                    //strleadQues = strleadQues+objQuestion.acfDependent_Field_Name__c+',';
                                }
                                //Applicant dependent
                                if(objQuestion.acfDependent_Object_Name__c == 'Applicant')
                                {
                                    setQuesApplicantAPInames.add(objQuestion.acfDependent_Field_Name__c);
                                }
                            }
                        }
                        intTotalQuestions++;
                    }
                    If(setQuesLeadAPInames != null && setQuesLeadAPInames.size()>0)
                    {
                        for(String strApiname : setQuesLeadAPInames )
                        {
                            strleadQues = strleadQues+strApiname+',';
                        }
                    }
                    system.debug('@@@@@@@Test'+setQuesAccountAPInames);
                    If(setQuesAccountAPInames != null && setQuesAccountAPInames.size()>0)
                    {
                        for(String strApiname : setQuesAccountAPInames)
                        {
                            strAccQues = strAccQues+strApiname+',';
                        }
                    }
                    //Applicant answer dependent  
                    if(setQuesApplicantAPInames != null && setQuesApplicantAPInames.size()>0)
                    {
                        for(String strApiname : setQuesApplicantAPInames)
                        {
                            strApplicaneQues = strApplicaneQues+strApiname+',';
                        }
                    }  
                    mapDependentQuestoValue.putAll(getDependentApiNameToValue(strleadQues,setQuesLeadAPInames,'Lead'));
                    mapDependentQuestoValue.putAll(getDependentApiNameToValue(strAccQues,setQuesAccountAPInames,'Contact'));
                    mapDependentQuestoValue.putAll(getDependentApiNameToValue(strApplicaneQues,setQuesApplicantAPInames,'click_Applicant__c'));
                    mapDecTostring = new map<integer,string>();
                    mapDecTostring.put(1,'First');
                    mapDecTostring.put(2,'Second');
                    mapDecTostring.put(3,'Third');
                    mapDecTostring.put(4,'Fourth');
                    mapDecTostring.put(5,'Fifth');
                    mapDecTostring.put(6,'Sixth');
                    mapDecTostring.put(7,'Seventh');

                    system.debug('@@@@@karthik_map'+mapDependentQuestoValue);
                    system.debug('Map:::_____----'+mapScriptIdToListOfQuestions);
                    boolean isEconsented = false;
                    if(mapScriptIdToListOfQuestions.size()>0)
                    {
                        Integer IndexCount = 0;
                        for(Script__c objScript:lstScript)
                        {
                            WrapperScript objWrapScript = new WrapperScript();
                            objWrapScript.objScript = objScript;
                            objWrapScript.NoOfQuesSkipped = 0;
                            objWrapScript.SkipFromAppNo = 0;
                            objWrapScript.IsSkipApp2 = false;
                            objWrapScript.IsSkipQuestions = false;
                            objWrapScript.isEmploymentTypeExist = false;
                            objWrapScript.isEconsentExist = false;
                            objWrapScript.lstScriptMasterQuestions = new List<WrapperQuestions>();
                            if(mapScriptIdToListOfQuestions.get(objScript.id) <> null)
                            {
                                for(Question__c objQuestion: mapScriptIdToListOfQuestions.get(objScript.id))
                                {
                                    WrapperQuestions objMasterQuestion   = new WrapperQuestions();
                                    objMasterQuestion.objWrapQuestion    = objQuestion;
                                    objMasterQuestion.ScriptSequence     = IndexCount;
                                    objMasterQuestion.lstSelectOpt       = new List<SelectOption>();
                                    objMasterQuestion.lstSelectOptions   = new List<Answer__c>();
                                    objMasterQuestion.lstCheckBoxAnswer  = new List<string>();
                                    objMasterQuestion.IsApplicant2Question = false;
                                    objMasterQuestion.lstRelatedQuestion    = new List<WrapperQuestions>();
                                    objMasterQuestion.customQuestions='false';
                                    objMasterQuestion.isConcent = false;
                                    //multiple applicants
                                    
                                    if(objWrapScript.objScript.clickAsk_for_every_applicant__c == true)
                                    {
                                        if(objQuestion.click_is_EConsent__c == true)
                                        {
                                             objMasterQuestion.isConcent=true;
                                             objWrapScript.isEconsentExist = true;
                                             isEconsented = true;
                                              appDetailsWrapListNew = new List<ApplicantDetailsWrapper>();
                                               for(integer i = 2; i<= intNoOfApplicants;i++)
                                               {
                                                    system.debug('#Entered');
                                                    appWrapObj = new ApplicantDetailsWrapper();
                                                    appWrapObj.appEmail = '';
                                                    appWrapObj.appMobile ='';
                                                    appWrapObj.applicantRecNo = i;
                                                    appWrapObj.applicantNo = mapDecTostring.get(i);
                                                    appDetailsWrapListNew.add(appWrapObj);
                                                    system.debug('###man1'+appDetailsWrapListNew);
                                               }
                                              objMasterQuestion.appDetailsWrapList = appDetailsWrapListNew; 
                                                 system.debug('###man1'+ objMasterQuestion.appDetailsWrapList);
                                        }
                                        if(objQuestion.acfEmployment_Type__c == true)
                                        {
                                            objWrapScript.isEmploymentTypeExist = true;
                                            continue;
                                        }
                                        objMasterQuestion.strApplicantNo = 'First Applicant';
                                        objMasterQuestion.strApplicantRecNo = '1';
                                        objMasterQuestion.IsApplicant2Question = true;
                                        lstMultipleAppScriptIndex.add(IndexCount);
                                        if(objQuestion.acf_ApiName__c <> null)
                                        {
                                          lstApplicantAPIName.add(objQuestion.acf_ApiName__c);
                                        }                                        
                                    }else{
                                        if(objQuestion.acf_ApiName__c <> null)
                                            lstContactAPINames.add(objQuestion.acf_ApiName__c);
                                    }
                                    if(objMasterQuestion.objWrapQuestion.acf_Type__c == 'Text' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Number'|| objMasterQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                                    {
                                        objMasterQuestion.IsContinueDisplay = true;
                                    }
                                    if(objMasterQuestion.objWrapQuestion.acfReplace_Mobile_No__c == true)
                                    {
                                        if(objMasterQuestion.objWrapQuestion.acf_Question__c.contains('04xxxxxxx') && strMobileNumber <> null && strMobileNumber <> '')
                                        {
                                            objMasterQuestion.objWrapQuestion.acf_Question__c = objMasterQuestion.objWrapQuestion.acf_Question__c.replace('04xxxxxxx',strMobileNumber);  
                                            objMasterQuestion.objWrapQuestion.acf_Description__c  = objMasterQuestion.objWrapQuestion.acf_Description__c.replace('04xxxxxxx',strMobileNumber); 
                                            
                                        }
                                    }
                                    if(objQuestion.Answer__r.size()>0)
                                    {
                                        for(Answer__c objAnswer:objMasterQuestion.objWrapQuestion.Answer__r)
                                        {
                                            mapAnswerNameToAnswerId.put(objAnswer.acf_Answer__c,objAnswer.id);
                                            objMasterQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                            objMasterQuestion.lstSelectOptions.add(objAnswer);
                                        }
                                    }
                                    lstMasterWrapperQuestion.add(objMasterQuestion);                            
                                    objWrapScript.lstScriptMasterQuestions.add(objMasterQuestion);
                                    if(isEconsented == false)
                                    {
                                        intConsentIndex++;
                                    }
                                }


                                // For Applicant Detail script.
                                if(objWrapScript.objScript.clickAsk_for_every_applicant__c == true && intNoOfApplicants <> null)
                                {
                                  for(integer i=2;i<=intNoOfApplicants;i++)  
                                  {
                                    for(Question__c objQuestion: mapScriptIdToListOfQuestions.get(objScript.id))
                                    {
                                            WrapperQuestions objMasterQuestion   = new WrapperQuestions();
                                            objMasterQuestion.objWrapQuestion    = objQuestion;
                                            objMasterQuestion.ScriptSequence     = IndexCount;
                                            objMasterQuestion.lstSelectOpt       = new List<SelectOption>();
                                            objMasterQuestion.strApplicantNo     = mapDecTostring.get(i)+' Applicant';
                                            objMasterQuestion.strApplicantRecNo = string.valueof(i);
                                            objMasterQuestion.IsApplicant2Question = true;
                                            objMasterQuestion.lstSelectOptions   = new List<Answer__c>();
                                            objMasterQuestion.lstCheckBoxAnswer  = new List<string>();
                                            objMasterQuestion.lstRelatedQuestion    = new List<WrapperQuestions>();
                                            objMasterQuestion.isConcent=false;
                                            //List To be added Applicant 2 Api Field
                                            if(objQuestion.acf_ApiName__c <> null)
                                             lstApplicantAPIName.add(objQuestion.acf_ApiName__c);
    
                                               // lstContactAPINames.add(objQuestion.acf_ApiName__c);
                                            
                                            if(objQuestion.click_is_EConsent__c == true)
                                            {
                                                 objMasterQuestion.isConcent=true;
                                                 isEconsented = true;
                                            }
                                            if(isEconsented == false)
                                            {
                                                intConsentIndex++;
                                            }
                                            if(objMasterQuestion.objWrapQuestion.acf_Type__c == 'Text' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Number'|| objMasterQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                                            {
                                                  objMasterQuestion.IsContinueDisplay = true;
                                            }    
                                            if(objQuestion.Answer__r.size()>0)
                                            {
                                                for(Answer__c objAnswer:objMasterQuestion.objWrapQuestion.Answer__r)
                                                {
                                                    mapAnswerNameToAnswerId.put(objAnswer.acf_Answer__c,objAnswer.id);
                                                    objMasterQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                                    objMasterQuestion.lstSelectOptions.add(objAnswer);
                                                }
                                            }
                                            lstMasterWrapperQuestion.add(objMasterQuestion);      
                                            objWrapScript.lstScriptMasterQuestions.add(objMasterQuestion);  
                                    }
                                  }
                                }
                            }    
                            lstWrapperScript.add(objWrapScript);
                            IndexCount++;
                        }
                    }
                    //For Prepopulating Values from Contact
                    // For Dependent and Employment type question in application Detail
                    for(Question__c objQuestion:[select id,acf_ApiName__c,acfApplicant_2_Api_Name__c,acf_Master_Question__c,
                                                 acf_Dependents__c,acfEmployment_Type__c,acf_Script__c,acfBubble_Text__c,
                                                 acfWatermark_Text__c,acfDependent_Field_Name__c,acfDependent_Object_Name__c,acfDependent_Value__c,
                                                 acfAppEmployment_Type__c,acfIs_Applicant_Question__c,acf_Question__c,Date__c                                                
                                                 from  Question__c where 
                                                 acf_Script__c = null and acf_Dependents__c = true and acf_Active__c = true])
                    {
                      if(objQuestion.acf_ApiName__c <> null) 
                        lstApplicantAPIName.add(objQuestion.acf_ApiName__c);  
                    }
                    //For Reloading(Refreshing) all Filled Questions      
                    system.debug('###111'+lstContactAPINames);
                    if(LoggedInContact <> null && lstContactAPINames <> null && lstContactAPINames.size()>0)
                    {
                        Id RelatedQuesId ;
                        String strAnswers = '';
                        string strAnswer = '';
                        string selectedAnswerId = '';
                        TotalNoQuestionSlide = 0;
                        MasterQuesNo = 0;
                        intTotalQuestions = lstMasterWrapperQuestion.size();
                        mapContactAPINameToSelectedAnswer = getContactApiToAnswer(lstContactAPINames);
                        mapApplicantAPINameToSelectedAnswer = getApplicantApiAnswer(lstApplicantAPIName);
                        system.debug('@#$#$###'+mapContactAPINameToSelectedAnswer.size());
                        boolean IsExitfromLoop = false;
                        system.debug('!@#$%%'+lstMasterWrapperQuestion.size());
                        for(WrapperQuestions objQuestions : lstMasterWrapperQuestion)
                        {
                            if(objQuestions.IsApplicant2Question)
                            {                              
                                if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)) <> null)
                                    objQuestions.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c));
                                else
                                    objQuestions.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);                                                                        
                                
                            }       
                            else
                            {
                                if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)) <> null)
                                    objQuestions.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c));
                                else
                                    objQuestions.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);                           
                            }
                        }
                        
                        for(WrapperQuestions objQuestions : lstMasterWrapperQuestion)
                        {
                            system.debug('@#$Lokesh::__'+objQuestions.ScriptSequence);
                            system.debug('@@@1'+MasterQuesNo);
                            system.debug('@@@2'+TotalNoQuestionSlide);
                            system.debug('@@@3'+ScriptIndexNo);
                            system.debug('@@@4'+ScriptQuestionNo);
                            system.debug('@@@@5'+objQuestions);   
                            system.debug('====___'+objQuestions.objWrapQuestion);
                            if(objQuestions.ScriptSequence <> null)
                            {
                                ScriptIndexNo = objQuestions.ScriptSequence;
                                strBubbleText = objQuestions.objWrapQuestion.acfBubble_Text__c;
                                WrapperScript objPrepopulatingScript = lstWrapperScript[objQuestions.ScriptSequence];
                                system.debug('@##$$$#'+objPrepopulatingScript);
                                if(objPrepopulatingScript <> null)
                                {
                                    system.debug('@@@##$'+objPrepopulatingScript.IsSkipApp2); 
                                    if(objPrepopulatingScript.IsSkipApp2)
                                    {
                                        system.debug('-----APP2SKIP-------');
                                        continue;
                                    }
                       
                                 system.debug('___###LOkesh___###'+objQuestions.objWrapQuestion.acfDependent_Value__c+'@#$%^%'+mapDependentQuestoValue.get(objQuestions.objWrapQuestion.acfDependent_Field_Name__c));
                                    //For Skipping dependent questions from lead or contact on page load if any 
                                    if(objQuestions.objWrapQuestion.acfDependent_Value__c <> null && objQuestions.objWrapQuestion.acfDependent_Field_Name__c <> null && (objQuestions.objWrapQuestion.acfDependent_Value__c <> mapDependentQuestoValue.get(objQuestions.objWrapQuestion.acfDependent_Field_Name__c)))
                                    {
                                        if((ScriptQuestionNo == objPrepopulatingScript.lstScriptMasterQuestions.size()-1)||(objPrepopulatingScript.IsSkipQuestions == true && ScriptQuestionNo == (objPrepopulatingScript.NoOfQuesSkipped)))
                                        {
                                            if(objPrepopulatingScript.IsSkipQuestions == true && ScriptQuestionNo == (objPrepopulatingScript.NoOfQuesSkipped))
                                            {
                                                TotalNoQuestionSlide += objPrepopulatingScript.NoOfQuesSkipped;
                                                MasterQuesNo += objPrepopulatingScript.NoOfQuesSkipped; 
                                                TotalNoQuestionSlide++;
                                                MasterQuesNo++;
                                                ScriptIndexNo++;
                                                objPrepopulatingScript.IsSkipApp2 = true;
                                                ScriptQuestionNo = 0;
                                                continue;
                                            }
                                            else
                                            {                               
                                                ScriptQuestionNo = 0;
                                                MasterQuesNo++;
                                                TotalNoQuestionSlide++;
                                                ScriptIndexNo++;
                                                continue;
                                            }   
                                        }
                                        else
                                        {
                                            ScriptQuestionNo++;
                                            MasterQuesNo++;
                                            TotalNoQuestionSlide++;
                                            continue;
                                        }                                        
                                    }
                                    //If Assets and liabilities not filled and question type is component.
                                    if(objQuestions.IsApplicant2Question == false && mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)==null || ((mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)=='false') && (objQuestions.objWrapQuestion.acf_Type__c == 'Component')))
                                    {
                                        IsExitfromLoop = true;
                                        break;
                                    }
                                    else if(objQuestions.IsApplicant2Question && mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c)==null)
                                    {
                                        IsExitfromLoop = true;
                                        break;
                                    }
                                    if(objQuestions.IsApplicant2Question)
                                    {
                                        
                                        if(mapAnswerNameToAnswerId.get(mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c)) <> null)
                                            objQuestions.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c));
                                        else
                                            objQuestions.strWrapAnswer  = mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c);                                                                        
                                        
                                    }       
                                    else
                                    {
                                        if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)) <> null)
                                            objQuestions.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c));
                                        else
                                            objQuestions.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);                           
                                    }
                                    system.debug('@@#$LOkesh:::'+objQuestions.strWrapAnswer);
                                    for(Answer__c objAnswer:objQuestions.objWrapQuestion.Answer__r)
                                    {
                                        if(objQuestions.objWrapQuestion.acf_Type__c <> 'Checkbox' && objQuestions.strWrapAnswer <> null && objQuestions.strWrapAnswer <> 'NONE')
                                        {
                                            system.debug('@#$%'+mapAnswerNameToAnswerId.get(objQuestions.objWrapQuestion.acf_ApiName__c)+'#$%^'+objQuestions.strWrapAnswer);
                                            if(objQuestions.strWrapAnswer <> null && objQuestions.strWrapAnswer <> '' && objQuestions.strWrapAnswer <> 'NONE')
                                            {
                                                if(objAnswer.id == objQuestions.strWrapAnswer)
                                                {
                                                    if(objAnswer.acf_Related_Question__c <> null)
                                                    {
                                                        RelatedQuesId = objAnswer.acf_Related_Question__c;
                                                    }
                                                    else
                                                    { 
                                                        RelatedQuesId = null;
                                                    }
                                                }
                                            }   
                                        }                    
                                    }
                                    // For Applicant Question Script
                                    if(objPrepopulatingScript.objScript.acf_Question_Type__c == 'Applicant Details' && objQuestions.objWrapQuestion.acfIs_Applicant_Question__c)
                                    {
                                        
                                        
                                        strNoOfApp = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);
                                        system.debug('@@@@'+strNoOfApp);
                                        objQuestions.strWrapAnswer = strNoOfApp;
                                        for(integer intIndexNo : lstMultipleAppScriptIndex)
                                        {
                                            WrapperScript objPrepopulatingMultipleScript = lstWrapperScript[intIndexNo];
                                            system.debug('@@karthik@'+objPrepopulatingMultipleScript.objScript);
                                            if(objPrepopulatingMultipleScript != null)
                                            {
                                                if(strNoOfApp <> string.valueof(intNoOfApplicants))
                                                {
                                                    objPrepopulatingMultipleScript.IsSkipQuestions = true; 
                                                    if(objPrepopulatingMultipleScript.isEmploymentTypeExist == true)
                                                    {
                                                        objPrepopulatingMultipleScript.SkipFromAppNo =  (Integer.valueof(integer.valueof(strNoOfApp)*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size()+1)/intNoOfApplicants)))-1;                            
                                                        objPrepopulatingMultipleScript.NoOfQuesSkipped = Integer.valueof((intNoOfApplicants-integer.valueof(strNoOfApp))*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size()+1)/intNoOfApplicants));
                                                    }else{
                                                        objPrepopulatingMultipleScript.SkipFromAppNo =  Integer.valueof(integer.valueof(strNoOfApp)*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size())/intNoOfApplicants));                            
                                                        objPrepopulatingMultipleScript.NoOfQuesSkipped = Integer.valueof((intNoOfApplicants-integer.valueof(strNoOfApp))*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size())/intNoOfApplicants));
                                                    }
                                                    
                                                    system.debug('@@karthik'+objPrepopulatingMultipleScript.NoOfQuesSkipped+'@@@'+objPrepopulatingMultipleScript.lstScriptMasterQuestions.size());
                                                
                                                } else
                                                    {
                                                        objPrepopulatingMultipleScript.IsSkipQuestions = false;
                                                        objPrepopulatingMultipleScript.NoOfQuesSkipped = 0; 
                                                    }
                                            }
                                         }                                       
                              }
                                   
                                    system.debug('@#$%'+objPrepopulatingScript.IsSkipQuestions+'@#$%%^'+objPrepopulatingScript.NoOfQuesSkipped);
                                    //For Check box type questions
                                    if(objQuestions.objWrapQuestion.acf_Type__c == 'Checkbox')
                                    {
                                        objQuestions.IsContinueDisplay = true;
                                        if(objQuestions.strWrapAnswer <> '')
                                        {
                                            for(string objChkboxAns:objQuestions.strWrapAnswer.split(','))
                                            {
                                                objQuestions.lstCheckBoxAnswer.add(mapAnswerNameToAnswerId.get(objChkboxAns));
                                            }
                                            objQuestions.strWrapAnswer = '';
                                        }    
                                    }
                                    // for related question
                                    if(RelatedQuesId <> null)
                                    {
                                        system.debug('@@@'+RelatedQuesId );
                                        while(RelatedQuesId <> null)
                                        {
                                            system.debug('@#$#');
                                            strAnswer = '';
                                            if(mapQuestionIdToQuestion.get(RelatedQuesId)<> null)
                                            {
                                                WrapperQuestions objRelatedQuestion = new WrapperQuestions();
                                                objRelatedQuestion.objWrapQuestion  = mapQuestionIdToQuestion.get(RelatedQuesId);
                                                objRelatedQuestion.lstSelectOpt     = new List<SelectOption>();
                                                objRelatedQuestion.lstSelectOptions  = new List<Answer__c>();
                                                objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                                                //objQuestions.lstRelatedQuestion = new List<WrapperQuestions >();
                                                if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Number'|| objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Currency' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                                                {
                                                    objRelatedQuestion.IsContinueDisplay = true;
                                                }
                                                relatedQuesId = null;
                                                for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                                                {
                                                    mapAnswerNameToAnswerId.put(objAnswer.acf_Answer__c,objAnswer.id);
                                                    if(mapAnswerNameToAnswerId.get(objRelatedQuestion.strWrapAnswer)<>null)
                                                    {
                                                        if(objAnswer.id == mapAnswerNameToAnswerId.get(objRelatedQuestion.strWrapAnswer))
                                                        {
                                                            strAnswer = objAnswer.acf_Answer__c;
                                                            if(objAnswer.acf_Related_Question__c <> null)
                                                            {
                                                                RelatedQuesId = objAnswer.acf_Related_Question__c;
                                                            }
                                                            else
                                                            {
                                                                RelatedQuesId = null;
                                                            }
                                                        }
                                                    }   
                                                    objRelatedQuestion.lstSelectOptions.add(objAnswer);
                                                    objRelatedQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));       
                                                }
                                                if(objQuestions.IsApplicant2Question)
                                                {
                                                    if(mapAnswerNameToAnswerId.get(mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c)) <> null)
                                                        objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objRelatedQuestion.objWrapQuestion.acf_ApiName__c));
                                                    else
                                                        objRelatedQuestion.strWrapAnswer  = mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objRelatedQuestion.objWrapQuestion.acf_ApiName__c);                                                   
                                                }       
                                                else
                                                {
                                                    if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c)) <> null)
                                                        objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c));
                                                    else
                                                        objRelatedQuestion.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c);                           
                                                }
                                                if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox')
                                                {
                                                    objRelatedQuestion.IsContinueDisplay = true;
                                                    if(objRelatedQuestion.strWrapAnswer <> '')
                                                    {
                                                        for(string objChkboxAns:objRelatedQuestion.strWrapAnswer.split(','))
                                                        {
                                                            objRelatedQuestion.lstCheckBoxAnswer.add(mapAnswerNameToAnswerId.get(objChkboxAns));
                                                        }
                                                    }    
                                                }
                                                objQuestions.lstRelatedQuestion.add(objRelatedQuestion);  
                                            }
                                            else{
                                                RelatedQuesId = null;
                                            }  
                                        }   
                                    }
                                    else if(RelatedQuesId == null && objPrepopulatingScript.objScript.acf_Question_Type__c == 'Applicant Details'  && objQuestions.objWrapQuestion.acf_Dependents__c && (mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)<>null || mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c) <>null))
                                    {
                                        system.debug('____LOkesh_____');
                                        Integer NoOFDependent;
                                        if(objQuestions.IsApplicant2Question && mapApplicantAPINameToSelectedAnswer <> null && mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c) <> null )                       
                                            NoOFDependent = Integer.valueof(mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objQuestions.objWrapQuestion.acf_ApiName__c));
                                        else
                                            NoOFDependent = Integer.valueof(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c));   
                                        for(Question__c objDependentQuestion : [select id,acf_ApiName__c,acf_Description__c,acf_Master_Question__c,
                                                                                acfApplicant_2_Api_Name__c,acfIs_Applicant_Question__c,acf_Question__c,
                                                                                acf_Script__c,acf_Dependents__c, acf_Postal_Code__c,acf_Type__c,
                                                                                acf_Stage_Name__c,acf_Sequence_No__c ,acfBubble_Text__c,acfWatermark_Text__c,
                                                                                acfDependent_Field_Name__c,acfDependent_Object_Name__c,acfDependent_Value__c,Date__c,
                                                                                
                                                                                (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                                                where  acfIs_Applicant_Question__c = true and acf_Active__c = true and acf_Dependents__c = true and acf_Script__c = null order by acf_Sequence_No__c limit:NoOFDependent])
                                        {                   
                                            objQuestions.IsContinueDisplay = false;
                                            WrapperQuestions objRelatedQuestion = new WrapperQuestions();
                                            objRelatedQuestion.objWrapQuestion = objDependentQuestion ;
                                            objRelatedQuestion.lstSelectOpt = new List<SelectOption>();
                                            objRelatedQuestion.lstSelectOptions = new List<Answer__c>();
                                            objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                                            if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Number'|| objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Currency' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                                            {
                                                objQuestions.IsContinueDisplay = true;
                                            }
                                            for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                                            {
                                                mapAnswerNameToAnswerId.put(objAnswer.acf_Answer__c,objAnswer.id);
                                                objRelatedQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                                objRelatedQuestion.lstSelectOptions.add(objAnswer);
                                            }
                                            if(objQuestions.IsApplicant2Question)
                                            {
                                                
                                                if(mapAnswerNameToAnswerId.get(mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objRelatedQuestion.objWrapQuestion.acf_ApiName__c)) <> null)
                                                    objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objRelatedQuestion.objWrapQuestion.acf_ApiName__c));
                                                else
                                                    objRelatedQuestion.strWrapAnswer  = mapApplicantAPINameToSelectedAnswer.get(objQuestions.strApplicantRecNo+objRelatedQuestion.objWrapQuestion.acf_ApiName__c);                            
                                            }       
                                            else
                                            {
                                                if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c)) <> null)
                                                    objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c));
                                                else
                                                    objRelatedQuestion.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c);                           
                                            }
                                            if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox')
                                            {
                                                objRelatedQuestion.IsContinueDisplay = true;
                                                if(objRelatedQuestion.strWrapAnswer <> '')
                                                {
                                                    for(string objChkboxAns:objRelatedQuestion.strWrapAnswer.split(','))
                                                    {
                                                        objRelatedQuestion.lstCheckBoxAnswer.add(mapAnswerNameToAnswerId.get(objChkboxAns));
                                                    }
                                                }    
                                            }             
                                            objQuestions.lstRelatedQuestion.add(objRelatedQuestion);
                                            IsSlide = 'false';     
                                        }                           
                                    }
                                    else if(RelatedQuesId == null && objPrepopulatingScript.objScript.acf_Question_Type__c == 'Applicant Details'  && (mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)<>null || mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c) <>null))
                                    {
                                        system.debug('____LOkesh_____');
                                        string strType;
                                        if(objQuestions.IsApplicant2Question)                       
                                            strType = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);
                                        else
                                            strType = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);   
                                        for(Question__c objDependentQuestion : [select id,acf_ApiName__c,acf_Description__c,acfApplicant_2_Api_Name__c,acf_Master_Question__c,
                                                                                acfIs_Applicant_Question__c,acfAppEmployment_Type__c,acf_Question__c,acf_Script__c,
                                                                                acf_Dependents__c,acf_Postal_Code__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfWatermark_Text__c,Date__c,
                                                                                (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                                                where acfIs_Applicant_Question__c = true and acf_Active__c = true and acfAppEmployment_Type__c =:strType and acf_Script__c = null order by acf_Sequence_No__c  ])
                                        {                   
                                            objQuestions.IsContinueDisplay = false;
                                            WrapperQuestions objRelatedQuestion = new WrapperQuestions();
                                            objRelatedQuestion.objWrapQuestion = objDependentQuestion ;
                                            objRelatedQuestion.lstSelectOpt = new List<SelectOption>();
                                            objRelatedQuestion.lstSelectOptions = new List<Answer__c>();
                                            objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                                            if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Number'|| objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Currency' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                                            {
                                                objQuestions.IsContinueDisplay = true;
                                            }
                                            for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                                            {
                                                mapAnswerNameToAnswerId.put(objAnswer.acf_Answer__c,objAnswer.id);
                                                objRelatedQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                                objRelatedQuestion.lstSelectOptions.add(objAnswer);
                                            }
                                            if(objQuestions.IsApplicant2Question)
                                            {
                                                if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c)) <> null)
                                                    objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c));
                                                else
                                                    objRelatedQuestion.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c);                            
                                            }    
                                            else
                                            {
                                                if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c)) <> null)
                                                    objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c));
                                                else
                                                    objRelatedQuestion.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acf_ApiName__c);                           
                                            }
                                            if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox')
                                            {
                                                objRelatedQuestion.IsContinueDisplay = true;
                                                if(objRelatedQuestion.strWrapAnswer <> '')
                                                {
                                                    for(string objChkboxAns:objRelatedQuestion.strWrapAnswer.split(','))
                                                    {
                                                        objRelatedQuestion.lstCheckBoxAnswer.add(mapAnswerNameToAnswerId.get(objChkboxAns));
                                                    }
                                                }    
                                            }
                                            objQuestions.lstRelatedQuestion.add(objRelatedQuestion);
                                            IsSlide = 'false';     
                                        }                           
                                    }
                                    system.debug('@#$$ScriptQuestionNo--'+ScriptQuestionNo);
                                    //lstMasterWrapperQuestion.set(MasterQuesNo,objQuestions);
                                    //system.debug('@#$$ScriptQuestionNo--'+objPrepopulatingScript.lstScriptMasterQuestions[ScriptQuestionNo]);
                                    if((ScriptQuestionNo == objPrepopulatingScript.lstScriptMasterQuestions.size()-1)||(objPrepopulatingScript.IsSkipQuestions == true && ScriptQuestionNo == (objPrepopulatingScript.SkipFromAppNo - 1)))
                                    {
                                        if(objPrepopulatingScript.IsSkipQuestions == true && ScriptQuestionNo == (objPrepopulatingScript.SkipFromAppNo - 1))
                                        {
                                            TotalNoQuestionSlide += objPrepopulatingScript.NoOfQuesSkipped;
                                            MasterQuesNo += objPrepopulatingScript.NoOfQuesSkipped; 
                                            TotalNoQuestionSlide++;
                                            MasterQuesNo++;
                                            ScriptIndexNo++;
                                            objPrepopulatingScript.IsSkipApp2 = true;
                                            ScriptQuestionNo = 0;
                                            continue;
                                        }
                                        else
                                        {                               
                                            ScriptQuestionNo = 0;
                                            MasterQuesNo++;
                                            TotalNoQuestionSlide++;
                                            ScriptIndexNo++;
                                            continue;
                                        }   
                                    }
                                    else
                                    {
                                        ScriptQuestionNo++;
                                        MasterQuesNo++;
                                        TotalNoQuestionSlide++;
                                    }
                                    
                                }
                            }
                            
                        }        
                    }
                } 
                //intQuoteWidth = (MasterQuesNo+1*100)/intTotalQuestions;
                //ClickQuoteDetail.intWidth = (MasterQuesNo+1*100)/intTotalQuestions;
                system.debug('@@@progressbar=>'+MasterQuesNo+' totalquestion=>'+intTotalQuestions);
                ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');
            }
            integer counterCheck=0;
            system.debug('questionlist@@@=>'+lstMasterWrapperQuestion);

         /*   appDetailsWrapList = new List<ApplicantDetailsWrapper>();
           
           for(integer i = 2; i<=4;i++){
                appWrapObj = new ApplicantDetailsWrapper();
                appWrapObj.appEmail = '';
                appWrapObj.appMobile ='';
                appWrapObj.applicantRecNo = i;
                appWrapObj.applicantNo = mapDecTostring.get(i);
                appDetailsWrapList.add(appWrapObj);
                lstMasterWrapperQuestion.add(appDetailsWrapList);
            }*/
            
        }
        catch(Exception ex)
        {
            system.debug('NRAC::ERROR::'+ex.getMessage());
        }
    }
    Public pagereference redirect()
    {
        string returnURL = acfcommon.redirect(userId,'clickpostloginquestionnaires');
        if(returnURL != null && returnURL <> '' && returnURL != 'false')
        {     system.debug('Ashutosh@@returnur3=>'+returnURL );
         Pagereference pageref = new Pagereference('/apex/Broker'+returnURL+'?cid='+UserAccountId);
         pageref.setredirect(true);
         return pageref;
         
        }else{
            return null;
        }
    }
    
    public map<string,string> getContactApiToAnswer(List<string>lstContactAPIFields)
    {
        map<string,string>mapApiNameToAnswer = new map<string,string>();
        List<Contact>lstContacts = new List<Contact>();
        string Query = ' select id,';
        for(string objContactFields:lstContactAPIFields)
        { 
            Query += objContactFields+',';
        }
        Query = Query.removeEnd(',');
        Query +=' from Contact where id= \''+ LoggedInContact + '\' limit 1';
        system.debug('@#$%test'+Query);
        lstContacts = Database.query(Query);
        for(Sobject objContact:lstContacts)
        {
            for(string objContactFields:lstContactAPIFields)
            {
                mapApiNameToAnswer.put(objContactFields,string.valueof(objContact.get(objContactFields)));
            } 
        }
        if(mapApiNameToAnswer <> null)
        {
            return mapApiNameToAnswer;
        }   
        return null;
    }
 //mulitple applicants
    public map<string,string> getApplicantApiAnswer(Set<string>lstApplicantAPIFields)
    {
 
         map<string,string>mapApiNameToAnswer = new map<string,string>();
         List<click_Applicant__c>lstApplicants = new List<click_Applicant__c>();
         string Query = ' select id,';
         for(string objApplicantFields:lstApplicantAPIFields)
         { 
            Query += objApplicantFields+',';
         }
         //Query = Query.removeEnd(',');
         Query +='click_Applicant_Number__c from click_Applicant__c where click_Account__r.personContactId = \''+ LoggedInContact+'\'';
         system.debug('@#$%test'+Query);
         lstApplicants = Database.query(Query);
         for(Sobject objApplicant:lstApplicants)
         {
            for(string objApplicantFields:lstApplicantAPIFields)
            {
                mapApiNameToAnswer.put(string.valueof(objApplicant.get('click_Applicant_Number__c')+objApplicantFields),string.valueof(objApplicant.get(objApplicantFields)));
            } 
         }
         if(mapApiNameToAnswer <> null)
         {
            return mapApiNameToAnswer;
         }   
         return null;
    }
    
    public PageReference RelatedQuestions() 
    {
        Id RelatedQuesId ;
        isRelatedQuesDisplay = false;
        String strAnswers = '';
        IsSlide = 'false';
        strmsg  = '';
        NoOfLeftSlide = 0;
        NoOfRightSlide = 0;
        system.debug('@#@##$#%%^'+ScriptIndexNo);
        
        if(MasterQuesNo<lstMasterWrapperQuestion.size())
        {
            WrapperQuestions objQuestion =  lstMasterWrapperQuestion[MasterQuesNo];
            system.debug('@#@##$#%%^'+objQuestion);
            if(objQuestion <> null && objQuestion.ScriptSequence <> null)
            {
                WrapperScript objScript = lstWrapperScript[objQuestion.ScriptSequence];
                if((objScript <> null))
                {
                    objQuestion.lstRelatedQuestion = new List<WrapperQuestions>();
                    for(Answer__c objAnswer:objQuestion.objWrapQuestion.Answer__r)
                    {
                        if(objQuestion.strWrapAnswer <> null && objQuestion.strWrapAnswer <> 'NONE')
                        {
                            if(objAnswer.id==objQuestion.strWrapAnswer)
                            {
                                strAnswers = objAnswer.acf_Answer__c;
                                if(objAnswer.acf_Related_Question__c <> null)
                                {
                                    RelatedQuesId = objAnswer.acf_Related_Question__c;
                                    break;
                                }
                            } 
                        }            
                    }
                    system.debug('@@@@'+RelatedQuesId+'@#$%'+objScript.objScript.acf_Question_Type__c+'@#$%'+objQuestion.objWrapQuestion.acf_Dependents__c+'#$@@@'+strAnswers);
                    //if(RelatedQuesId <> null)
                    //system.debug('@@@@karthik__'+mapDependentQuestoValue.get(mapQuestionIdToQuestion.get(RelatedQuesId).acfDependent_Field_Name__c));
                    
                    if(RelatedQuesId <> null && mapQuestionIdToQuestion.get(RelatedQuesId) <> null && mapQuestionIdToQuestion.get(RelatedQuesId).acfDependent_Field_Name__c == null && mapQuestionIdToQuestion.get(RelatedQuesId).acfDependent_Object_Name__c == null)
                    {
                        objQuestion.IsContinueDisplay = false;
                        WrapperQuestions objRelatedQuestion = new WrapperQuestions();
                        objRelatedQuestion.objWrapQuestion = mapQuestionIdToQuestion.get(RelatedQuesId);
                        objRelatedQuestion.lstSelectOpt = new List<SelectOption>();
                        objRelatedQuestion.lstSelectOptions = new List<Answer__c>();
                        objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                        if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Number'|| objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Currency' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                        {
                            objQuestion.IsContinueDisplay = true;
                        }
                        for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                        {
                            objRelatedQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                            objRelatedQuestion.lstSelectOptions.add(objAnswer);
                        }
                        objQuestion.lstRelatedQuestion.add(objRelatedQuestion);
                        isRelatedQuesDisplay = true;
                    }
                    else if(RelatedQuesId == null && objScript.objScript.acf_Question_Type__c == 'Applicant Details'  && objQuestion.objWrapQuestion.acf_Dependents__c && strAnswers <> null && strAnswers <> '')
                    {
                        Integer NoOFDependent = Integer.valueof(strAnswers);
                        system.debug('!@#$%^test'+NoOFDependent);
                        if(NoOFDependent == 0)
                        { 
                            system.debug('!@#$%^test1'+NoOFDependent);
                            objQuestion.IsContinueDisplay = true;                           
                            IsSlide = 'true';
                            NextQuestion();
                        }
                        else
                        {
                            for(Question__c objDependentQuestion : [select id,acf_ApiName__c,acf_Description__c,acf_Master_Question__c,acfApplicant_2_Api_Name__c,
                                                                    acfIs_Applicant_Question__c,acf_Question__c,acf_Script__c,acf_Dependents__c,acf_Postal_Code__c,
                                                                    acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfWatermark_Text__c,Date__c,
                                                                    (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                                    where  acfIs_Applicant_Question__c = true and acf_Active__c = true and acf_Dependents__c = true and acf_Script__c = null order by acf_Sequence_No__c limit:NoOFDependent])
                            {
                                system.debug('::::Dependent::::::::'+objDependentQuestion );
                                objQuestion.IsContinueDisplay = true;
                                WrapperQuestions objRelatedQuestion = new WrapperQuestions();
                                objRelatedQuestion.objWrapQuestion = objDependentQuestion ;
                                objRelatedQuestion.lstSelectOpt = new List<SelectOption>();
                                objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                                objRelatedQuestion.lstSelectOptions = new List<Answer__c>();
                                if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox')
                                {
                                    objQuestion.IsContinueDisplay = true;
                                }
                                for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                                {
                                    objRelatedQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                    objRelatedQuestion.lstSelectOptions.add(objAnswer);
                                }
                                objQuestion.lstRelatedQuestion.add(objRelatedQuestion);
                                IsSlide = 'false';

                            }
                        }   
                    }
                    else
                    {
                        objQuestion.IsContinueDisplay = true;
                        IsSlide = 'true';
                        NextQuestion();
                    }  
                    system.debug('@@#$%^'+objQuestion);
                }
            }
        } 
        return null;
    }
    public PageReference AddingRelatedQuestion() 
    {
        strmsg  = '';
        system.debug('@@@@@LOkesh'+QuesNo);
        Id RelatedQuesId;
        String strAnswers = '';
        IsSlide = 'false';
        NoOfLeftSlide = 0;
        NoOfRightSlide = 0;
        set<Integer>setIndexToRemove = new set<Integer>();
        if(MasterQuesNo<lstMasterWrapperQuestion.size())
        {
            WrapperQuestions objQuestion =  lstMasterWrapperQuestion[MasterQuesNo];
            system.debug('@#@##$#%%^'+objQuestion);
            if(objQuestion <> null && objQuestion.ScriptSequence <> null)
            {
                // if Dependent Question and Employment Type question then return from method.
                if(objQuestion.objWrapQuestion.acf_Dependents__c)
                {
                    return null;
                }
                WrapperScript objScript = lstWrapperScript[objQuestion.ScriptSequence];
                //ScriptIndexNo = objQuestion.ScriptSequence;
                if((objScript <> null))
                {
                    Integer tempQuesNo = QuesNo+1;
                    Integer RelatedQustionWrapperSize = objQuestion.lstRelatedQuestion.size();          
                    while(tempQuesno < RelatedQustionWrapperSize)
                    {
                        setIndexToRemove.add(tempQuesno); 
                        tempQuesno++;
                    }
                    system.debug('@@@@::'+setIndexToRemove);
                    if(setIndexToRemove.size()>0)
                    {
                        boolean IsFirstIndex = true;
                        for(Integer index:setIndexToRemove)
                        {
                            system.debug('@@@@@:::'+index);
                            if(IsFirstIndex == false)
                            {
                                --index;
                            }
                            if(objQuestion.lstRelatedQuestion.size()>index)
                                objQuestion.lstRelatedQuestion.remove(index);
                            IsFirstIndex = false; 
                        }
                    }               
                    if(objQuestion.lstRelatedQuestion.size()>QuesNo && objQuestion.lstRelatedQuestion[QuesNo] <> null)
                    {
                        WrapperQuestions objRelatedQuestion = objQuestion.lstRelatedQuestion[QuesNo];
                        system.debug('::::@@@###'+objRelatedQuestion);
                        for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                        {
                            if(objRelatedQuestion.strWrapAnswer <> null && objRelatedQuestion.strWrapAnswer <> 'NONE')
                            {  
                                if(objAnswer.id==objRelatedQuestion.strWrapAnswer)
                                {
                                    strAnswers = objAnswer.acf_Answer__c;
                                    if(objAnswer.acf_Related_Question__c <> null)
                                    {
                                        RelatedQuesId = objAnswer.acf_Related_Question__c;
                                        break;
                                    }
                                }
                            }           
                        }
                        if(RelatedQuesId <> null && mapQuestionIdToQuestion.get(RelatedQuesId) <> null)
                        {
                            objQuestion.IsContinueDisplay = false;
                            WrapperQuestions objRelatedQuestions = new WrapperQuestions();
                            IsSlide = 'false';
                            objRelatedQuestions.objWrapQuestion = mapQuestionIdToQuestion.get(RelatedQuesId);
                            objRelatedQuestions.lstSelectOpt = new List<SelectOption>();
                            objRelatedQuestions.lstSelectOptions = new List<Answer__c>();
                            objRelatedQuestions.lstCheckBoxAnswer = new List<string>();
                            if(objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Number' ||objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Checkbox' ||objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Currency' ||objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Percent')
                            {
                                objQuestion.IsContinueDisplay = true;
                            }
                            for(Answer__c objAnswer:objRelatedQuestions .objWrapQuestion.Answer__r)
                            {
                                objRelatedQuestions.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                                objRelatedQuestions.lstSelectOptions.add(objAnswer);
                            }
                            objQuestion.lstRelatedQuestion.add(objRelatedQuestions);
                        }
                        else
                        {
                            objQuestion.IsContinueDisplay = true;
                            //IsSlide = 'true';
                            NextQuestion();
                        } 
                    }
                }
            }
        }          
        return null;
    }
    //onload 
    public pagereference checkQuestionStaus()
    {
        list<Account> lstAccts = getlstusrAccounts(UserAccountId); //modified by karthik on 22-03-2016
        mapAppNoToApplicantObj = new map<string,click_Applicant__c>();
        mapAppNoToisEmailExist = new map<string,boolean>();
        for(integer i=1;i<=intNoOfApplicants;i++)
        {
            mapAppNoToisEmailExist.put(string.valueOf(i),false);
        }
        if(lstAccts != null && lstAccts.size()>0)
        {
            integer intAppCount = 1;
            isConsentDone = false;
            isAllConsentDone = false;
            integer consentCount = 0;
            integer appEmail = 0;
            
            isAppDetailDone = false;
            system.debug('###Entered3');
            for(click_Applicant__c objApplicant : lstAccts[0].Applicants__r)
            {
                system.debug('###Entered2');
                system.debug('###'+objApplicant);
                system.debug('###Entered2'+lstAccts[0].acfNumber_Of_Applicants__pc);
                system.debug('###Entered2'+intAppCount );
                if(objApplicant.Applicant_Email__c == '' || objApplicant.Applicant_Email__c == null)
                {
                    mapAppNoToisEmailExist.put(string.valueOf(objApplicant.click_Applicant_Number__c),false);
                }else{
                    mapAppNoToisEmailExist.put(string.valueOf(objApplicant.click_Applicant_Number__c),true);
                }
                if(lstAccts[0].acfNumber_Of_Applicants__pc <> null && intAppCount <= integer.valueOf(lstAccts[0].acfNumber_Of_Applicants__pc))
                {
                    if(objApplicant.acfEconsent__c != null && objApplicant.acfEconsent__c != '' && objApplicant.acfEconsent__c == 'I Consent')
                    {
                        isConsentDone = true;
                        consentCount++;
                    }
                    system.debug('###Entered');
                    if(string.IsNotEmpty(objApplicant.Applicant_Email__c)  && String.IsNotEmpty(string.valueOf(objApplicant.Applicant_Phone__c)))
                    {
                      system.debug('###Entered1');
                      appEmail++;
                      
                    }
                    
                    
                }else if(lstAccts[0].acfNumber_Of_Applicants__pc == null)
                    {
                        isConsentDone = false;
                        
                    }
                    if(objApplicant.click_Applicant_Number__c <> null)
                        mapAppNoToApplicantObj.put(string.valueOf(objApplicant.click_Applicant_Number__c),objApplicant);
                    intAppCount++;
            }
            if(lstAccts[0].acfNumber_Of_Applicants__pc!=null && appEmail > 0 && appEmail == Integer.valueOf(lstAccts[0].acfNumber_Of_Applicants__pc)){
                isAppDetailDone = true;
            }
           /* if(istempAppdone == true)
            {
             isAppDetailDone = true;
             system.debug('isAppDetailDone =>'+isAppDetailDone);
               
            }
            if(istempAppdone == false){
                isAppDetailDone = false;
            }*/
            if(lstAccts[0].acfNumber_Of_Applicants__pc!=null && consentCount == Integer.valueOf(lstAccts[0].acfNumber_Of_Applicants__pc))
            {
                isAllConsentDone = true;
                lead leadobj=new lead(id=LoggedInLeadId);
                leadobj.acfIs_Post_Login_Ques_Attempted__c=true;                
                update leadobj;
                system.debug('calling mercury');
                MercuryApiUtilities.updateAccountF(UserAccountId, LoggedInLeadId);
            }
        }
        list<lead> leadDetails=new list<lead>();         
        leadDetails=[select acfIs_Post_Login_Ques_Attempted__c from lead where  id=:LoggedInLeadId];
        if(leadDetails != null && leadDetails.size()>0)
        {
            if(leadDetails[0].acfIs_Post_Login_Ques_Attempted__c==true){
                string returnURL = acfcommon.redirect(userId,'clickpostloginquestionnaires');
                if(returnURL != null && returnURL <> '' && returnURL != 'false')
                {       system.debug('Ashutosh@@returnur3=>'+returnURL );
                 Pagereference pageref = new Pagereference('/apex/Broker'+returnURL+'?cid='+UserAccountId);
                 pageref.setredirect(true);
                 return pageref;
                 
                }
            }
        }
        return null;
    }
    //to check applicant email existance ***no need for now***
    public void checkFlag()
    {
        list<Account> lstAccts = getlstusrAccounts(UserAccountId); //modified by karthik on 22-03-2016
        if(lstAccts != null && lstAccts.size()>0)
        {
            for(click_Applicant__c objApplicant : lstAccts[0].Applicants__r)
            {
                if(objApplicant.Applicant_Email__c == '' || objApplicant.Applicant_Email__c == null)
                {
                    mapAppNoToisEmailExist.put(string.valueOf(objApplicant.click_Applicant_Number__c),false);
                }else{
                    mapAppNoToisEmailExist.put(string.valueOf(objApplicant.click_Applicant_Number__c),true);
                }
            }           
        }   
    }
    //common method added by karthik on 22-03-2016
    public static list<Account> getlstusrAccounts(id accid)
    {
        list<Account> lstAccounts = [select id,acfNumber_Of_Applicants__pc,name,(select id,click_Account__c,acfEmployment_Type__c,Applicant_Phone__c,acf_Applicant_Name__c,Applicant_Email__c,acfEconsent__c,click_Applicant_Number__c from Applicants__r) from account where id=:accid];
        return lstAccounts;
    }
    //check e-consent button
    public pagereference checkUserResponse(){        
        PageReference pg = new PageReference('/apex/BrokerClickPostloginQuestionnaires?cid='+UserAccountId);
        pg.setRedirect(true);
        return pg;        
    }

   public pagereference sendEmailAndSMS2()
   {    
        string encodedDate=string.valueOf(System.currentTimeMillis());
        List<click_Applicant__c> lstApp = new List<click_Applicant__c>(); 
        string econsentId='';
        strmsg = '';
        system.debug('Karthik@@@'+strAppSeqNo+'==='+app2Email+'==='+app2Phone);
        boolean isValidFields=true;
        EmailTemplate templateId =new EmailTemplate();                
        templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'EConsent' AND isActive=true];
        List<Messaging.SingleEmailMessage> lstMail = new List<Messaging.SingleEmailMessage>(); 
        if(MasterQuesNo < lstMasterWrapperQuestion.size())
        {
            system.debug('MasterQuesNo -->>>'+MasterQuesNo);
            WrapperQuestions objQuestion =  lstMasterWrapperQuestion[MasterQuesNo];
            for(ApplicantDetailsWrapper aWrapper:objQuestion.appDetailsWrapList)
            {
                 system.debug('@@manish'+aWrapper);
                if(aWrapper.applicantRecNo > 1 && String.isNotEmpty(aWrapper.appEmail) && String.isNotEmpty(aWrapper.appMobile)){
                    system.debug('@@manish'+aWrapper);
                    isValidFields=true;
                    Pattern p = Pattern.compile( '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
           
                    system.debug('###second applicant mail');
                    system.debug('@@email'+aWrapper.appEmail);
                    Matcher m = p.matcher(aWrapper.appEmail);
                    if(!m.matches()){
                        system.debug('###second applicant mail1');
                        //isValidFields=false;
                        //strmsg='Please enter valid email';
                        //isAppDetailDone= false;
                    }else if(aWrapper.appMobile=='+61'){
                        isValidFields=false;
                        strmsg='Please enter valid phone';
                        isAppDetailDone= false;
                    }else if(aWrapper.appMobile.length()>13){
                        isValidFields=false;
                        strmsg='Please enter valid phone';
                        isAppDetailDone = false;
                    }
                    else{
                        system.debug('###second applicant mail2');
                        strmsg='';
                        mapAppNoToApplicantObj.get(string.valueof(aWrapper.applicantRecNo)).Applicant_Email__c = aWrapper.appEmail;
                        mapAppNoToApplicantObj.get(string.valueof(aWrapper.applicantRecNo)).Applicant_Phone__c = '+61'+aWrapper.appMobile;
                        lstApp.add(mapAppNoToApplicantObj.get(string.valueof(aWrapper.applicantRecNo)));
                       // update mapAppNoToApplicantObj.get(aWrapper.applicantRecNo);
                        mapAppNoToisEmailExist.put(string.valueof(aWrapper.applicantRecNo),true);
                   } 
          
          
                    econsentId=encodedDate+'-'+UserAccountId+'-'+string.valueof(aWrapper.applicantRecNo);
                    if(isValidFields)
                    {
                       
                        Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');                    
                        Blob data1 = Blob.valueOf(econsentId);
                        Blob encryptedValue  =Crypto.encryptWithManagedIV('AES128', cryptoKey, data1);
                        string Encryptdata=EncodingUtil.base64encode(encryptedValue );
                        string finalData= EncodingUtil.urlEncode(Encryptdata, 'UTF-8');
                        string body='';
                                       
                        body=templateId.HtmlValue;
                        body=body.replace('{!econsentid}',finalData);                                        
                        body=body.replace('{!Account.Name}',mapAppNoToApplicantObj.get(string.valueof(aWrapper.applicantRecNo)).acf_Applicant_Name__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toaddress=new List<String>();
                        toaddress.add(aWrapper.appEmail); 
                        system.debug('###'+toaddress);                   
                        mail.setToAddresses(toaddress);
                        mail.setSubject(templateId.Subject);
                        mail.setHtmlBody(body);
                        
                        lstMail.add(mail);
                        string mobileMessage=Label.Applicant_E_consent_message;
                        mobileMessage=mobileMessage.replace('{!econsentid}',finalData);
                        mobileMessage=mobileMessage.replace('{!Account.Name}',mapAppNoToApplicantObj.get(string.valueof(aWrapper.applicantRecNo)).acf_Applicant_Name__c);
                        acfCommon.SendSMSUsingFuture(mapAppNoToApplicantObj.get(string.valueof(aWrapper.applicantRecNo)).acf_Applicant_Name__c,aWrapper.appMobile,mobileMessage,true);
                        system.debug('mail Sent');
                        isAppDetailDone = true;
                    }
                }
            }  
            Messaging.sendEmail(lstMail);
            update lstApp;  
        }
        
        return null;
    }
    public void sendApplicantConsentMailandSmsResend(){
        string applicantName='';
        string applicantEmail='';
        string applicantPhone='';
        string encodedDate=string.valueOf(System.currentTimeMillis()); 
        string econsentId='';
        applicantName=mapAppNoToApplicantObj.get(strAppSeqNo).acf_Applicant_Name__c;
        applicantEmail=mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Email__c;
        applicantPhone=mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Phone__c;
        econsentId=encodedDate+'-'+UserAccountId+'-'+strAppSeqNo;
        system.debug('###appName'+applicantName);
        system.debug('###appEmail'+applicantEmail);
        system.debug('###appPhone'+applicantPhone);
     
        system.debug('applicantEmail=>'+applicantEmail);
        Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');                    
        Blob data1 = Blob.valueOf(econsentId);
        Blob encryptedValue  =Crypto.encryptWithManagedIV('AES128', cryptoKey, data1);
        string Encryptdata=EncodingUtil.base64encode(encryptedValue );
        string finalData= EncodingUtil.urlEncode(Encryptdata, 'UTF-8');
        string body='';
        
        EmailTemplate templateId =new EmailTemplate();                
        templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'EConsent' AND isActive=true];               
        body=templateId.HtmlValue;
        body=body.replace('{!econsentid}',finalData);                                        
        body=body.replace('{!Account.Name}',applicantName);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toaddress=new List<String>();
        toaddress.add(applicantEmail);                    
        mail.setToAddresses(toaddress);
        mail.setSubject(templateId.Subject);
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        string mobileMessage=Label.Applicant_E_consent_message;
        mobileMessage=mobileMessage.replace('{!econsentid}',finalData);
        mobileMessage=mobileMessage.replace('{!Account.Name}',applicantName);
        acfCommon.SendSMSUsingFuture(applicantName,applicantPhone,mobileMessage,true);
        system.debug('mail Sent');
    }
    //send email and message to applicant
    public void sendApplicantConsentMailandSms()
    {
        string applicantName='';
        string applicantEmail='';
        string applicantPhone='';
        string encodedDate=string.valueOf(System.currentTimeMillis()); 
        string econsentId='';
        system.debug('Karthik@@@'+strAppSeqNo+'==='+app2Email+'==='+app2Phone);
        boolean isValidFields=true;
        Pattern p = Pattern.compile( '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
        if(strAppSeqNo <> '1')
        {
            system.debug('###second applicant mail');
            Matcher m = p.matcher(app2Email);
            if(!m.matches()){
                isValidFields=false;
                strmsg='Please enter valid email';
            }else if(app2Phone=='+61'){
                isValidFields=false;
                strmsg='Please enter valid phone';
                
            }else if(app2Phone.length()>13){
                isValidFields=false;
                strmsg='Please enter valid phone';
            }
            else{
                strmsg='';
                mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Email__c = app2Email;
                mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Phone__c = app2Phone;
                update mapAppNoToApplicantObj.get(strAppSeqNo);
                mapAppNoToisEmailExist.put(strAppSeqNo,true);
               } 
        }
        if(mapAppNoToApplicantObj != null && mapAppNoToApplicantObj.size() > 0 && mapAppNoToApplicantObj.get(strAppSeqNo) != null 
             && mapAppNoToApplicantObj.get(strAppSeqNo).acf_Applicant_Name__c != null && mapAppNoToApplicantObj.get(strAppSeqNo).acf_Applicant_Name__c != '' )
        applicantName=mapAppNoToApplicantObj.get(strAppSeqNo).acf_Applicant_Name__c;
        if(mapAppNoToApplicantObj != null && mapAppNoToApplicantObj.size() > 0 && mapAppNoToApplicantObj.get(strAppSeqNo) != null
             && mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Email__c != null && mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Email__c != '' )
        applicantEmail=mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Email__c;
        if(mapAppNoToApplicantObj != null && mapAppNoToApplicantObj.size() > 0 && mapAppNoToApplicantObj.get(strAppSeqNo) != null
             && mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Phone__c != null && mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Phone__c != '' )
        applicantPhone=mapAppNoToApplicantObj.get(strAppSeqNo).Applicant_Phone__c;
        econsentId=encodedDate+'-'+UserAccountId+'-'+strAppSeqNo;
        system.debug('###appName'+applicantName);
        system.debug('###appEmail'+applicantEmail);
        system.debug('###appPhone'+applicantPhone);
        if(isValidFields)
        {
            system.debug('applicantEmail=>'+applicantEmail);
            Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');                    
            Blob data1 = Blob.valueOf(econsentId);
            Blob encryptedValue  =Crypto.encryptWithManagedIV('AES128', cryptoKey, data1);
            string Encryptdata=EncodingUtil.base64encode(encryptedValue );
            string finalData= EncodingUtil.urlEncode(Encryptdata, 'UTF-8');
            string body='';
            
            EmailTemplate templateId =new EmailTemplate();                
            templateId = [select id,subject,body, name,HtmlValue from EmailTemplate where DeveloperName = 'EConsent' AND isActive=true];               
            body=templateId.HtmlValue;
            body=body.replace('{!econsentid}',finalData);                                        
            body=body.replace('{!Account.Name}',applicantName);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toaddress=new List<String>();
            toaddress.add(applicantEmail);                    
            mail.setToAddresses(toaddress);
            mail.setSubject(templateId.Subject);
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            string mobileMessage=Label.Applicant_E_consent_message;
            mobileMessage=mobileMessage.replace('{!econsentid}',finalData);
            mobileMessage=mobileMessage.replace('{!Account.Name}',applicantName);
            acfCommon.SendSMSUsingFuture(applicantName,applicantPhone,mobileMessage,true);
            system.debug('mail Sent');
        }  
    }
    //resend e-consent button
    public PageReference resendEconsent()
    {
        list<Account> lstAccts = getlstusrAccounts(UserAccountId); //modified by karthik on 22-03-2016
        if(lstAccts != null && lstAccts.size()>0)
        {
            integer intAppcount = 1;
            for(click_Applicant__c objApplicant : lstAccts[0].Applicants__r)
            {
                if(intAppcount < = integer.valueof(lstAccts[0].acfNumber_Of_Applicants__pc))
                {
                    strAppSeqNo = string.valueof(intAppcount);
                    sendApplicantConsentMailandSmsResend();
                }
                intAppcount++;
            }
            
        }

        PageReference pg = new PageReference('/apex/BrokerClickPostloginQuestionnaires?cid='+UserAccountId);
        pg.setRedirect(true);
        return pg;
    }
    //continue button on econsent screen modified by karthik on 22-03-2016
    public PageReference  applicant2consent()
    {   
        if(mapAppNoToAppId <> null && mapAppNoToAppId.size() > 0 && mapAppNoToAppId.get(strAppSeqNo) != null 
         && mapAppNoToAppId.get(strAppSeqNo) != '') 
         {
            system.debug('kathiktest@@'+strAppSeqNo);
            click_Applicant__c objApplicant = new click_Applicant__c(id=mapAppNoToAppId.get(strAppSeqNo));
            objApplicant.acfEconsent__c = 'I Consent';
            update objApplicant;
            PageReference pg = new PageReference('/apex/BrokerClickPostloginQuestionnaires?cid='+UserAccountId);
            pg.setRedirect(true);
            return pg;
         }
         return null;
    }
    // Call on the click of Continue button
    public pageReference NextQuestion()
    {
        system.debug('!@#$%^&*'+MasterQuesNo);
        IsSlide = 'false';
        isAppDetailDone = false;
        checkQuestionStaus();
        NoOfPrePostdependent = 0;
        IsSkipDependent = 'false';
        strmsg  = '';
        NoOfLeftSlide = 0;
        NoOfRightSlide = 0;
        system.debug('@@@@@test'+lstMasterWrapperQuestion);
        map<string,string>mapAnswerIdToAnswer = new map<string,string>();
        map<Question__c,string>mapQuesToSelectedAnswer = new map<Question__c,string>();
        list<Account> lstAcctsNew = getlstusrAccounts(UserAccountId);
        string x = lstAcctsNew[0].acfNumber_Of_Applicants__pc;
        system.debug('##number'+lstAcctsNew[0].acfNumber_Of_Applicants__pc);
       
       
        
        Contact objPortalContact = new Contact(id = LoggedInContact);
        click_Applicant__c objApplicant = new click_Applicant__c();
        System.debug('***objPortalContact ***' +objPortalContact);
        system.debug('###isApp'+isAppDetailDone);
        if(MasterQuesNo + 1<lstMasterWrapperQuestion.size())
        {
            if(lstMasterWrapperQuestion[MasterQuesNo+1].isConcent==true && lstMasterWrapperQuestion[MasterQuesNo+1].strApplicantRecNo == '1') 
            {
                strAppSeqNo = '1';
                sendApplicantConsentMailandSms();  
            }                
        }
        if(MasterQuesNo < lstMasterWrapperQuestion.size())
        {
           
            system.debug('MasterQuesNo -->>>'+MasterQuesNo);
            system.debug('MasterQuesNo -->>>'+lstMasterWrapperQuestion[MasterQuesNo]);
            system.debug('+1MasterQuesNo -->>>'+lstMasterWrapperQuestion[MasterQuesNo+1]);
            WrapperQuestions objQuestion =  lstMasterWrapperQuestion[MasterQuesNo];
            // if(MasterQuesNo+1 < lstMasterWrapperQuestion.size()){strBubbleText = lstMasterWrapperQuestion[MasterQuesNo+1].objWrapQuestion.acfBubble_Text__c;} 
            system.debug('@#@##$#%%^'+objQuestion);
            system.debug('objQuestion.ScriptSequence-->'+objQuestion.ScriptSequence);
            if(objQuestion <> null && objQuestion.ScriptSequence <> null)
            {
                WrapperScript objWrapScript = lstWrapperScript[objQuestion.ScriptSequence];
                if(mapAppNoToAppId != null && mapAppNoToAppId.get(objQuestion.strApplicantRecNo) != null)
                {
                   system.debug('@@@karthik@'+mapAppNoToAppId+'@@@'+mapAppNoToAppId.get(objQuestion.strApplicantRecNo));
                    objApplicant.id = mapAppNoToAppId.get(objQuestion.strApplicantRecNo);
                }
                 else if(objQuestion.IsApplicant2Question){
                        objApplicant.click_Applicant_Number__c = objQuestion.strApplicantRecNo;
                    }
                ScriptIndexNo = objQuestion.ScriptSequence;
                system.debug('objWrapScript-->'+objWrapScript);
                if(objWrapScript <> null)
                {
                        for(Answer__c objAnswer:objQuestion.objWrapQuestion.Answer__r)
                    {
                      mapAnswerIdToAnswer.put(objAnswer.id,objAnswer.acf_Answer__c);
                    }
                    if(objQuestion.lstRelatedQuestion <> null && objQuestion.lstRelatedQuestion.size()>0)
                    {
                        if(mapAnswerIdToAnswer <> null && mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)<>null)
                        {
                            if(objQuestion.objWrapQuestion.acf_Type__c == 'Number' || objQuestion.objWrapQuestion.acf_Type__c == 'Currency'|| objQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                            {
                                if(objQuestion.IsApplicant2Question)
                                {
                                objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));
                                }
                                else  
                                   objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));
                            }  
                            else
                            {
                                if(objQuestion.IsApplicant2Question)
                                {
                                   objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer));
                                }
                                else
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer));
                            }  
                        }
                        else
                        {
                            if(objQuestion.objWrapQuestion.acf_Type__c == 'Number' || objQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                            {
                                if(objQuestion.IsApplicant2Question)
                                {
                                   objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(objQuestion.strWrapAnswer));
                                } 
                                else
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(objQuestion.strWrapAnswer));                                    
                            }    
                            else
                            {
                                if(objQuestion.IsApplicant2Question)
                                {
                                   objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer);
                                }
                                else     
                                     objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer);
                            }   
                        }
                       
                        system.debug('objPortalContact-->'+objPortalContact);
                        system.debug('$$$$');
                         for(WrapperQuestions objRelatedQues:objQuestion.lstRelatedQuestion)
                        {
                            system.debug('$$$$'+objRelatedQues.strWrapAnswer);
                            for(Answer__c objAnswer:objRelatedQues.objWrapQuestion.Answer__r)
                            {
                              mapAnswerIdToAnswer.put(objAnswer.id,objAnswer.acf_Answer__c);
                            }
                            if((objRelatedQues.strWrapAnswer == null || objRelatedQues.strWrapAnswer == '' || objRelatedQues.strWrapAnswer == 'NONE') && objRelatedQues.lstCheckBoxAnswer.size()==0) 
                            {
                                IsSlide = 'false';
                                strmsg = 'Please fill the answer';
                                strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                                ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');
                                return null;
                            }
                            else if(objRelatedQues.objWrapQuestion.acf_Type__c == 'Checkbox' && objRelatedQues.lstCheckBoxAnswer.size()>0)
                            {    
                                for(string strAns:objRelatedQues.lstCheckBoxAnswer)
                                {
                                    if(mapAnswerIdToAnswer <> null && mapAnswerIdToAnswer.get(strAns)<> null)
                                    {
                                        if(objQuestion.IsApplicant2Question)
                                        {
                                           objApplicant.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer)));
                                        }
                                         else
                                            objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(strAns));
                                    }    
                                }   
                            }
                            if(mapAnswerIdToAnswer <> null && mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer)<>null)
                            {
                                 //mapQuesToSelectedAnswer.put(objRelatedQues.objWrapQuestion,mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer)); 
                                if(objRelatedQues.objWrapQuestion.acf_Type__c == 'Number' || objRelatedQues.objWrapQuestion.acf_Type__c == 'Currency' || objRelatedQues.objWrapQuestion.acf_Type__c == 'Percent')
                                {
                                    if(objQuestion.IsApplicant2Question)
                                    {
                                       objApplicant.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer)));
                                    }
                                    else
                                         objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer)));                                                                                    
                                }
                                else
                                {
                                    if(objQuestion.IsApplicant2Question)
                                    {
                                       objApplicant.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer));
                                    }                                    
                                    else
                                        objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer));                                                                               
                                }  
                            }
                            else
                            {
                                 //mapQuesToSelectedAnswer.put(objRelatedQues.objWrapQuestion,objRelatedQues.strWrapAnswer);
                                if(objRelatedQues.objWrapQuestion.acf_Type__c == 'Number' || objRelatedQues.objWrapQuestion.acf_Type__c == 'Currency' || objRelatedQues.objWrapQuestion.acf_Type__c == 'Percent')
                                {
                                    if(objQuestion.IsApplicant2Question)
                                    {
                                       objApplicant.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,decimal.valueof(objRelatedQues.strWrapAnswer));
                                    }
                                    else
                                         objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,decimal.valueof(objRelatedQues.strWrapAnswer));                                      
                                }  
                                else
                                {
                                    if(objQuestion.IsApplicant2Question)
                                    {
                                       objApplicant.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,objRelatedQues.strWrapAnswer);
                                    }
                                    else
                                        objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,objRelatedQues.strWrapAnswer);                                       
                                }    
                            }
                            //mapQuestionIdToSelectedAnswers.put(objRelatedQues.objWrapQuestion.id,objRelatedQues.strWrapAnswer);
                        }
                    }
                    else
                    {
                        system.debug('$$$$---->>'+objQuestion.strWrapAnswer);
                        if((objQuestion.strWrapAnswer == null || objQuestion.strWrapAnswer == '' || objQuestion.strWrapAnswer == 'NONE') && objQuestion.lstCheckBoxAnswer <> null && objQuestion.lstCheckBoxAnswer.size()==0)
                        {
                            IsSlide = 'false';
                            system.debug('@##@##@');
                            strmsg = 'Please fill the answer';
                            strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill the answer.'));
                            system.debug(strmsg);
                            ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');
                            return null;
                        }
                        else if(objQuestion.objWrapQuestion.acf_Type__c == 'Text' && objQuestion.objWrapQuestion.Date__c  == true)
                        {
                            if( CreateDateFromString(objQuestion.strWrapAnswer) <> null) 
                            {
                                Date DOB = CreateDateFromString(objQuestion.strWrapAnswer);
                                if(DOB > system.today())
                                {
                                    strmsg = 'DOB can not be future';
                                    strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                                    ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');
                                    return null;
                                }
                            }
                            else
                            {
                                strmsg = 'Please Enter valid date';
                                strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                                ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');
                                return null;
                            }
                        }
                        else if(objQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' && objQuestion.lstCheckBoxAnswer.size()>0)
                        {    
                            for(string strAns:objQuestion.lstCheckBoxAnswer)
                            {
                                if(mapAnswerIdToAnswer <> null && mapAnswerIdToAnswer.get(strAns)<> null)
                                {
                                    //mapQuesToSelectedAnswer.put(objQuestion.objWrapQuestion,mapAnswerIdToAnswer.get(strAns));
                                    if(objQuestion.IsApplicant2Question)
                                        objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(strAns));
                                    else
                                        objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(strAns));
                                }   
                            }   
                        }
                        if(mapAnswerIdToAnswer <> null && mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)<>null)
                        {
                            //mapQuesToSelectedAnswer.put(objQuestion.objWrapQuestion,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)); 
                            if(objQuestion.objWrapQuestion.acf_Type__c == 'Number' || objQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                            {
                                if(objQuestion.IsApplicant2Question)
                                    objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));
                                else
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));                            
                            } 
                            else
                            {
                                if(objQuestion.IsApplicant2Question){
                                    
                                    system.debug('ashu!!!=>'+objQuestion.objWrapQuestion.acf_ApiName__c+'=>'+objQuestion.strWrapAnswer+'=>');
                                    //ashu
                                    
                                    if(!objQuestion.isConcent){
                                        objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer));
                                    }
                                    
                                }   
                                else 
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer));                               
                                
                            }  
                        }
                        else
                        {
                            //mapQuesToSelectedAnswer.put(objQuestion.objWrapQuestion,objQuestion.strWrapAnswer);
                            if(objQuestion.objWrapQuestion.acf_Type__c == 'Number' || objQuestion.objWrapQuestion.acf_Type__c == 'Currency'|| objQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                            {
                                if(objQuestion.IsApplicant2Question)
                                    objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(objQuestion.strWrapAnswer));
                                else
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(objQuestion.strWrapAnswer));                    
                            }   
                            else
                            {
                                if(objQuestion.IsApplicant2Question)
                                    objApplicant.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer); 
                                else    
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer); 
                            }   
                        }
                    }
                    // For Applicant Question Script
                    if(objWrapScript.objScript.acf_Question_Type__c == 'Applicant Details' && objQuestion.objWrapQuestion.acfIs_Applicant_Question__c)
                    {
                        
                        strNoOfApp = mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer);
                        system.debug('@@@@APPPP'+strNoOfApp);
                        boolean isapplicantsAdded = false;
                        for(integer intIndexNo : lstMultipleAppScriptIndex)
                        {
                            WrapperScript objPrepopulatingMultipleScript = lstWrapperScript[intIndexNo];
                            system.debug('@@karthik@'+objPrepopulatingMultipleScript.objScript);
                            if(objPrepopulatingMultipleScript != null)
                            {
                                if(strNoOfApp <> string.valueof(intNoOfApplicants))
                                {
                                    objPrepopulatingMultipleScript.IsSkipQuestions = true; 
                                    if(objPrepopulatingMultipleScript.isEmploymentTypeExist == true)
                                    {
                                        objPrepopulatingMultipleScript.SkipFromAppNo =  (Integer.valueof(integer.valueof(strNoOfApp)*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size()+1)/intNoOfApplicants)))-1;                            
                                        objPrepopulatingMultipleScript.NoOfQuesSkipped = Integer.valueof((intNoOfApplicants-integer.valueof(strNoOfApp))*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size()+1)/intNoOfApplicants));
                                    }else{
                                        objPrepopulatingMultipleScript.SkipFromAppNo =  Integer.valueof(integer.valueof(strNoOfApp)*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size()/intNoOfApplicants)));                            
                                        objPrepopulatingMultipleScript.NoOfQuesSkipped = Integer.valueof((intNoOfApplicants-integer.valueof(strNoOfApp))*((objPrepopulatingMultipleScript.lstScriptMasterQuestions.size())/intNoOfApplicants));
                                    }
                                    
                                    system.debug('@@karthik'+objPrepopulatingMultipleScript.NoOfQuesSkipped+'@@@'+objPrepopulatingMultipleScript.lstScriptMasterQuestions.size());
                                } else
                                    {
                                        objPrepopulatingMultipleScript.IsSkipQuestions = false;
                                        objPrepopulatingMultipleScript.NoOfQuesSkipped = 0; 
                                    }

   
                                }    
                            }
                    }
                    if(objPortalContact <> null)
                    {
                        update objPortalContact;
                        if(objApplicant <> null && objQuestion.IsApplicant2Question)
                       {                                                                            
                         if(lstuserMobile <> null && lstuserMobile.size()>0)
                         {
                              User objUser = lstuserMobile[0];
                              if(objUser.accountId != null)
                              {
                                  if(objApplicant.click_Account__c == null)
                                  {
                                     objApplicant.click_Account__c = objUser.accountId; 
                                  }
                                  If(objApplicant.acf_Applicant_Name__c != null && objQuestion.strApplicantRecNo == '1')
                                  {
                                      List<String> lstName = objApplicant.acf_Applicant_Name__c.split(' ');
                                      objUser.firstname = '';
                                      Account objAccount = new Account(id=objUser.accountId);
                                      objAccount.firstname = '';
                                      If(lstName != null && lstName.size()>1)
                                      {
                                        objUser.firstname = lstName[0];
                                        objAccount.firstname = lstName[0];
                                        objUser.lastname = lstName[1];
                                        objAccount.lastname =lstName[1];
                                      }else if(lstName != null && lstName.size() == 1){
                                             objUser.lastname = lstName[0];
                                             objAccount.lastname =lstName[0];
                                            }
                                     Update objUser;
                                     Update objAccount;                                
                                   }
                               }
                          }
                      upsert objApplicant;
                      mapAppNoToAppId.put(objApplicant.click_Applicant_Number__c,objApplicant.id);
                    }
                    }
                    System.debug('test'+objWrapScript.IsSkipQuestions+'#$$%#'+objWrapScript.NoOfQuesSkipped);
                    
                    //if last question
                    if(ScriptIndexNo == lstWrapperScript.size()-1 && ScriptQuestionNo == objWrapScript.lstScriptMasterQuestions.size()-1)
                    {
                        
                        //List<lead>lstLeadToUpdate = [select id,acfIs_Post_Login_Ques_Attempted__c from lead where acf_Contact__c =:objPortalContact.id limit 1];
                        if(LoggedInLeadId <> null)
                        {
                            Lead objLead = new Lead(id = LoggedInLeadId);
                            InsertRequiredDocuments(LoggedInLeadId,lstMasterWrapperQuestion);
                            // MercuryApiUtilities.updateAccountF(UserAccountId, LoggedInLeadId);
                            
                            
                            system.debug('@@111=>');
                            objLead.acfIs_Post_Login_Ques_Attempted__c = true;
                            update objLead;
                        } 
                        string retPgName = acfCommon.sendReturnUrl(userId,false,'acfpostloginQuestions'); 
                        
                        retPgName=retPgName+'?cid='+UserAccountId;
                        system.debug('Ashutosh@@returnurl13=>'+retPgName );
                        
                        Pagereference pageref = new pageReference('/apex/Broker'+retPgName+'?cid='+UserAccountId);
                        pageref.setredirect(true);
                        return pageref;
                        
                        
                    } 
                    system.debug('karthik test@@@123'+ScriptQuestionNo+'===='+objWrapScript.NoOfQuesSkipped+'==='+MasterQuesNo+'==='+ScriptIndexNo+'===='+lstScriptQuestionsLadder.size());
                    system.debug('!@#$%^&*'+MasterQuesNo);
                    if((ScriptQuestionNo == objWrapScript.lstScriptMasterQuestions.size()-1)||(objWrapScript.IsSkipQuestions == true && ScriptQuestionNo == (objWrapScript.SkipFromAppNo - 1)))
                    {
                        System.debug('test');
                        ScriptIndexNo++; 
                        IsSlide = 'true';
                        NoOfRightSlide = objWrapScript.NoOfQuesSkipped;
                        MasterQuesNo += NoOfRightSlide;
                        ++MasterQuesNo;
                        system.debug('@#$$'+ScriptQuestionNo);
                        system.debug('!@#$$%%'+objWrapScript.NoOfQuesSkipped);
                        ScriptQuestionNo = 0;
                        if(MasterQuesNo < lstMasterWrapperQuestion.size())
                            strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                        if(ScriptIndexNo == lstScriptQuestionsLadder.size())
                            IsSlide = 'false';
                        else
                            IsSlide = 'true';  
                        system.debug('@@@@2kar'+lstMasterWrapperQuestion[MasterQuesNo]);   
                        system.debug('karthik test@@@123'+ScriptQuestionNo+'===='+objWrapScript.NoOfQuesSkipped+'==='+MasterQuesNo+'==='+ScriptIndexNo+'===='+lstScriptQuestionsLadder.size());                   
                        ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');
                        return null;
                    }
                    else
                    {
                        ++MasterQuesNo; 
                        ScriptQuestionNo++;
                        IsSlide = 'true';
                        system.debug('karthik==Continue'+mapDependentQuestoValue);                     mapDependentQuestoValue.putAll(getDependentApiNameToValue(strAccQues,setQuesAccountAPInames,'Contact'));
                        system.debug('@@@@test@#'+getDependentApiNameToValue(strApplicaneQues,setQuesApplicantAPInames,'click_Applicant__c'));
                        mapDependentQuestoValue.putAll(getDependentApiNameToValue(strApplicaneQues,setQuesApplicantAPInames,'click_Applicant__c'));
                
                        system.debug('karthik_map@@@@'+mapDependentQuestoValue+'====='+lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c);
                        if(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion <> null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c != null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c != null) 
                        {
                            string strDependentQuesValue = '';
                            if(lstMasterWrapperQuestion[MasterQuesNo].IsApplicant2Question == false)
                            {
                                strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                            }else{
                                strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].strApplicantRecNo+lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                            }
                            if(mapDependentQuestoValue.get(strDependentQuesValue) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c)
                            {
                                while((MasterQuesNo < lstMasterWrapperQuestion.size())&&(mapDependentQuestoValue.get(strDependentQuesValue) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c))
                                {
                                    IsSkipDependent = 'true';
                                    NoOfPrePostdependent++; 
                                    ++MasterQuesNo; 
                                    ScriptQuestionNo++;
                                    if(lstMasterWrapperQuestion[MasterQuesNo].IsApplicant2Question == false)
                                    {
                                        strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                                    }else{
                                        strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].strApplicantRecNo+lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                                    }
                                }
                            }                     
                        } 
                        system.debug('test karthik@@@'+ScriptQuestionNo + '==='+objWrapScript.lstScriptMasterQuestions.size());
                       if(ScriptQuestionNo == objWrapScript.lstScriptMasterQuestions.size())
                        {
                         ScriptQuestionNo = 0;
                        }
                    }
                    
                    if(MasterQuesNo < lstMasterWrapperQuestion.size())
                    {
                        strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                        system.debug('!@#$%^&*@@'+strBubbleText+'======'+lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion);
                    } 
                }                       
            }
            system.debug('!@#$%^&*'+MasterQuesNo);          ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');
            system.debug('!@#$%^&*'+MasterQuesNo);
        }   
        return null;
    }
    //Inserting Required Documents and Suggested Documents
    public void InsertRequiredDocuments(Id LeadID,List<WrapperQuestions>lstWrapperQuestion)
    {
        set<string>setSelectedAnswer = new set<string>();
        //Inserting Required Documents based on Answer selected.
        for(WrapperQuestions objQuestions:lstWrapperQuestion)
        {
            if(objQuestions.strWrapAnswer <> null && objQuestions.strWrapAnswer <> '')
            {
                setSelectedAnswer.add(objQuestions.strWrapAnswer);
            }
            if(objQuestions.lstRelatedQuestion <> null && objQuestions.lstRelatedQuestion.size()>0)
            {
                for(WrapperQuestions objRelatedQuestion:objQuestions.lstRelatedQuestion)
                {
                    setSelectedAnswer.add(objRelatedQuestion.strWrapAnswer);
                }
            }
        }
        system.debug('!@#$$$$'+setSelectedAnswer);
        if(setSelectedAnswer.size()>0)
        {
            acfCommon.getRequiredDocumentsFromAnswers(LeadID,setSelectedAnswer);
            //Method used to getSuggestedProducts Based on Answers.
            acfCommon.getSuggestedProductsFromAnswers(LeadID,setSelectedAnswer);
        } 
    }
    
    public pageReference PreviousQuestion()
    {
        IsSlide = 'false';
        IsSkipDependent = 'false';
        NoOfLeftSlide = 0;
        NoOfRightSlide = 0;
        strmsg = '';
        NoOfPrePostdependent = 0;
        if(MasterQuesNo>0 && MasterQuesNo<lstMasterWrapperQuestion.size())
        {
            WrapperQuestions objQuestion =  lstMasterWrapperQuestion[MasterQuesNo];
            system.debug('@#@##$#%%^'+objQuestion);
            system.debug('objQuestion.ScriptSequence--'+objQuestion.ScriptSequence);
            if(objQuestion != null && objQuestion.ScriptSequence != null)
            {
                ScriptIndexNo = objQuestion.ScriptSequence;
                WrapperScript objScript = lstWrapperScript[objQuestion.ScriptSequence];
                system.debug('objScript--'+objScript);
                if(objScript <> null)
                {
                    system.debug('!@#$%^%LOKESH'+ScriptIndexNo);
                    if(ScriptQuestionNo == 0 && ScriptIndexNo>0)
                    {
                        system.debug('!@#$%^%LOKESH'+ScriptIndexNo);
                        --ScriptIndexNo;
                        --MasterQuesNo;
                        system.debug('@@@@@karthik1'+lstWrapperScript);
                        WrapperScript objPreviousWrapScript = lstWrapperScript[ScriptIndexNo];
                        system.debug('@@@@@karthik'+objPreviousWrapScript);
                        if(objPreviousWrapScript <> null)
                        {
                            if(objPreviousWrapScript.objScript.acf_Question_Type__c == 'Applicant Details' && objPreviousWrapScript.IsSkipQuestions)
                            {
                                NoOfLeftSlide = objPreviousWrapScript.NoOfQuesSkipped;
                                MasterQuesNo  -= NoOfLeftSlide;
                                ScriptQuestionNo = ((objPreviousWrapScript.lstScriptMasterQuestions.size()-1 ) - NoOfLeftSlide );
                                IsSlide = 'true';
                            }
                            else
                            {
                                NoOfLeftSlide = 0;
                                ScriptQuestionNo = objPreviousWrapScript.lstScriptMasterQuestions.size()-1;
                                if(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion <> null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c != null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c != null && mapDependentQuestoValue.get(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c)
                                {
                                    while(MasterQuesNo>0 && MasterQuesNo<lstMasterWrapperQuestion.size() && (mapDependentQuestoValue.get(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c) && (MasterQuesNo < lstMasterWrapperQuestion.size()))
                                    {
                                        IsSkipDependent = 'true';
                                        --ScriptQuestionNo;
                                        --MasterQuesNo;
                                        NoOfPrePostdependent++;
                                    }
                                    
                                }  
                                IsSlide = 'true';
                            }
                        }
                        strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                    }
                    else
                    {
                        --ScriptQuestionNo;
                        --MasterQuesNo;
                        
     
                        if(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion <> null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c != null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c != null)
                        {
                            string strDependentQuesValue = '';
                            if(lstMasterWrapperQuestion[MasterQuesNo].IsApplicant2Question == false)
                            {
                                strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                            }else{
                                strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].strApplicantRecNo+lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                            }
                            if(mapDependentQuestoValue.get(strDependentQuesValue) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c)
                            {
                                while(MasterQuesNo>0 && MasterQuesNo<lstMasterWrapperQuestion.size() && (mapDependentQuestoValue.get(strDependentQuesValue) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c) && (MasterQuesNo < lstMasterWrapperQuestion.size()))
                                {
                                    IsSkipDependent = 'true';
                                    --ScriptQuestionNo;
                                    --MasterQuesNo;
                                    NoOfPrePostdependent++;
                                    if(lstMasterWrapperQuestion[MasterQuesNo].IsApplicant2Question == false)
                                    {
                                        strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                                    }else{
                                        strDependentQuesValue = lstMasterWrapperQuestion[MasterQuesNo].strApplicantRecNo+lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c;
                                    }
                                }
                            }
                        }   
                        strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c; 
                        IsSlide = 'true';
                    }
                }   
            } 
            
            system.debug('Quote@@'+MasterQuesNo);
            ClickQuoteDetail_partner.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'BrokerClickPostloginQuestionnaires');          
        }
        return null;
    }
    //For Asset And Liablity Component.
    public pageReference AssetLiablity()
    {        
        system.debug('@@@@@Lokesh'+MasterQuesNo+'-----ScriptQuestionNo______'+ScriptQuestionNo);
        //ScriptQuestionNo = 0;
        if(MasterQuesNo>0 && MasterQuesNo<lstMasterWrapperQuestion.size())
        {
            WrapperQuestions objQuestion =  lstMasterWrapperQuestion[MasterQuesNo];
            system.debug('@#@##$#%%^'+objQuestion);
            
            Contact objContact = new Contact(id=LoggedInContact);
            objContact.acfAssetsAndLiablities__c = true;
            update objContact;
            if(objQuestion <> null && objQuestion.ScriptSequence <> null)
            {
                ScriptIndexNo = objQuestion.ScriptSequence;
                WrapperScript objScript = lstWrapperScript[objQuestion.ScriptSequence];
                if((objScript <> null) && LoggedInContact <> null)
                {
                    system.debug('@@@kart'+ScriptIndexNo+'===='+lstWrapperScript.size()+'==='+ScriptQuestionNo+'===='+objScript.lstScriptMasterQuestions.size()); 
                    List<Contact>lstContact = [select id,acfAssetsAndLiablities__c from Contact where id =:LoggedInContact and acfAssetsAndLiablities__c = true];
                    if(lstContact <> null && lstContact.size()>0)
                    {
                        if(ScriptQuestionNo == (objScript.lstScriptMasterQuestions.size()-1) && ScriptIndexNo != lstWrapperScript.size()-1)
                        {
                            ScriptIndexNo++;
                            MasterQuesNo++;
                            ScriptQuestionNo = 0;
                            IsSlide = 'slide';
                        }else if(ScriptIndexNo == lstWrapperScript.size()-1 && ScriptQuestionNo == objScript.lstScriptMasterQuestions.size()-1)
                        {
                            
                            //List<lead>lstLeadToUpdate = [select id,acfIs_Post_Login_Ques_Attempted__c from lead where acf_Contact__c =:objPortalContact.id limit 1];
                            if(LoggedInLeadId <> null)
                            {      
                                
                                Lead objLead = new Lead(id = LoggedInLeadId);
                                InsertRequiredDocuments(LoggedInLeadId,lstMasterWrapperQuestion);
                                objLead.acfIs_Post_Login_Ques_Attempted__c = true;
                                update objLead;
                            } 
                            list<Opportunity> oppList=[select id from Opportunity where Recordtype.name!='Click Refi' and accountId=:UserAccountId limit 1];
                            system.debug('opplist@@@=>'+oppList);
                            if(oppList.size()>0){                                
                                //system.debug('calling mercury');
                                //MercuryApiUtilities.updateAccountF(UserAccountId, oppList[0].id);
                                
                            }
                            
                            string retPgName = acfCommon.sendReturnUrl(userId,false,'acfpostloginQuestions'); 
                            system.debug('Ashutosh@@returnurl12=>'+retPgName ); 
                            string oppoid= acfCommon.getCurrentLoggedInOpportunityId(userId);
                            
                            
                            Pagereference pageref =new pageReference('/apex/Broker'+retPgName+'?cid='+UserAccountId);
                            pageref.setredirect(true);
                            return pageref;
                            
                        }      
                        else
                        {
                            MasterQuesNo++;
                            ScriptQuestionNo++;
                            IsSlide = 'slide';
                        }
                        if(MasterQuesNo < lstMasterWrapperQuestion.size())
                        {
                            strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                        } 
                    }
                    else
                    {
                        IsSlide = 'Stop';
                    } 
                    // system.debug('@@@kart'+ScriptIndexNo+'===='+lstWrapperScript.size()+'==='+ScriptQuestionNo+'===='+objScript.lstScriptMasterQuestions.size());  
                }
            }
        }
        return null;
    }
    public boolean IsValidDate(string strDate)
    {
        date DtDate;
        try
        {
            DtDate = Date.valueof(strDate);
            return true;
        }
        catch(Exception Ex)
        {
            return false;
        }
    }
    public Date CreateDateFromString(string strDate)
    {
        if(strDate <> null && strDate <> '')
        {
            List<string>lstDate = strDate.split('/');
            if(lstDate <> null && lstDate.size()==3)
            {
                return (date.newInstance(Integer.valueof(lstDate[2]),Integer.valueof(lstDate[1]),Integer.valueof(lstDate[0])));
            }
        }
        return null;
    }
    
    //to get dependent values
    public map<string,string> getDependentApiNameToValue(String strQues,set<string> setQuesAPInames,string strObjName)
    {
        map<string,string> maptempDependentQuestoValue = new map<string,string>();
        If(strQues != null && strQues <> '' && LoggedInContact != null)
        {
            String strQueryOnDependentObj = 'select '+strQues+'id';
            system.debug('!@#$%^&*'+strQueryOnDependentObj+'========'+strQues+'====='+strObjName);
            if(strObjName == 'Lead')
            {
                strQueryOnDependentObj = strQueryOnDependentObj+' from Lead where id = \'' + LoggedInLeadId + '\'';
            }
            if(strObjName == 'Contact')
            {
                strQueryOnDependentObj = strQueryOnDependentObj+' from Contact where id = \'' + LoggedInContact + '\'';
            }
            if(strObjName == 'click_Applicant__c')
                {
                    strQueryOnDependentObj = strQueryOnDependentObj+',click_Applicant_Number__c from click_Applicant__c where click_Account__r.personContactId = \''+ LoggedInContact+'\'';
                }
              system.debug('@@@@@karthik'+strQueryOnDependentObj);    
            SObject[] lstDependentObj = Database.query(strQueryOnDependentObj);
            system.debug('!@#$%^&test'+lstDependentObj);
            If(lstDependentObj != null && lstDependentObj.size()>0)
            {
                for(SObject objDependentObj  : lstDependentObj)
                {
                    system.debug('@@@@@karthik'+setQuesAPInames);
                    for(String strApiName : setQuesAPInames)
                    {
                        If(strApiName <> '' && objDependentObj.get(strApiName) <> null)
                        {  
                            if(strObjName == 'click_Applicant__c')
                            {
                                maptempDependentQuestoValue.put(string.valueof(objDependentObj.get('click_Applicant_Number__c'))+strApiName,string.valueof(objDependentObj.get(strApiName))); 
                            }else{
                                maptempDependentQuestoValue.put(strApiName,string.valueof(objDependentObj.get(strApiName)));
                            }                           
                        }
                    }   
                }
            }
        } 
        return maptempDependentQuestoValue;
    }
    
    //Script Wrapper
    public class WrapperScript
    {
        public Script__c objScript{get;set;}
        public Integer ScriptNumber{get;set;}
        public boolean IsSkipQuestions{get;set;}
        public Integer NoOfQuesSkipped{get;set;}
        public boolean IsSkipApp2{get;set;}
        public Integer SkipFromAppNo{get;set;}
        public boolean isEmploymentTypeExist{get;set;}
        public boolean isEconsentExist{get;set;}
        public List<WrapperQuestions>lstScriptMasterQuestions{get;set;}
    }
    //Master Question Wrapper
    public class WrapperQuestions 
    {
        public Question__c objWrapQuestion {get;set;}
        public string strApplicantNo{get;set;}
        public string strApplicantRecNo{get;set;}
        public string strWrapAnswer {get;set;}
        public List<SelectOption>lstSelectOpt {get;set;}
        public List<WrapperQuestions>lstRelatedQuestion {get;set;}
        public List<Answer__c>lstSelectOptions{get;set;}
        public List<string>lstCheckBoxAnswer{get;set;}
        public boolean IsContinueDisplay{get;set;}
        public boolean IsApplicant2Question{get;set;}
        public Integer ScriptSequence{get;set;}
        public boolean isConcent{get;set;}
        public string customQuestions{get;set;}
        public string strAppEmail{get;set;}
        public string strAppMobile{get;set;}
        public List<ApplicantDetailsWrapper> appDetailsWrapList{get;set;}
        
    }
    //Applicant Wrapper

     public class ApplicantDetailsWrapper 
    {
        public string applicantNo{get;set;}
        public integer applicantRecNo{get;set;}
        public string appEmail{get;set;}
        public string appMobile{get;set;}
    }

}