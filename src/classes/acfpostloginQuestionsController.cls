/*====================================================
                Click Loans
========================================================*/
public class acfpostloginQuestionsController
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
    Public List<user> lstuserMobile;
    public Integer NoOfPrePostdependent{get;set;}
    public acfpostloginQuestionsController()
    {
        try
        {
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
            strCurrentLoggedInAccount = '';
            IsSkipDependent = '';
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
            lstuserMobile = [select id,MobilePhone,accountId,firstname,lastname from user where id=:UserInfo.getUserId()];
            If(lstuserMobile != null && lstuserMobile .size()>0){
                strCurrentLoggedInAccount = lstuserMobile[0].accountId;
            }
            if(lstuserMobile <> null && lstuserMobile.size()>0)
            {
                  strMobileNumber = lstuserMobile[0].MobilePhone;
            }
            LoggedInContact = acfCommon.getCurrentLoggedInContactId(UserInfo.getUserId());
            LoggedInLeadId  = acfCommon.getCurrentLoggedInLeadId(UserInfo.getUserId());  
            system.debug('____@@@@____'+LoggedInContact);
            //LoggedInContact = '003O000000WWVHC';
            for(Script__c objScript : [select id,acf_Sequence_no__c,acf_Type__c,acf_Stage_Name__c,acf_Question_Type__c  from Script__c where acf_Type__c=:'Post-Login' order by acf_Sequence_no__c asc])
            {
                setScriptId.add(objScript.id);
                lstScript.add(objScript);
            }
            system.debug('@@@'+setScriptId);
            if(setScriptId.size()>0)
            {
                lstScriptQuestionsLadder  = [select id,acf_Sequence_no__c,acf_Type__c,acf_Stage_Name__c from Script__c where acf_Type__c=:'Post-Login' order by acf_Sequence_no__c desc];
                //intTotalQuestions = lstScriptQuestionsLadder.size();
                intTotalQuestions = 0;
                for(Question__c objQuestion:[select id,acf_ApiName__c,acfDependent_Field_Name__c,acfDependent_Object_Name__c,acfDependent_Value__c,acf_Description__c,acfReplace_Mobile_No__c,Date__c,acfApplicant_2_Api_Name__c,acf_Master_Question__c,acfAppEmployment_Type__c,acfIs_Applicant_Question__c,acf_Question__c,acf_Script__c,acfEmployment_Type__c,acf_Dependents__c,acf_Postal_Code__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfBubble_Text__c,acfWatermark_Text__c,
                                            acfComponent_Type__c,(select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                           where ((acf_Master_Question__r.acf_Script__c in: setScriptId or acf_Script__c in:setScriptId) and acf_Active__c = true) order by acf_Sequence_No__c asc ])  
                {                                      
                    mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                    if(objQuestion.acf_ApiName__c <> null)
                      lstContactAPINames.add(objQuestion.acf_ApiName__c);
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
                If(strleadQues != null && strleadQues <> '' && LoggedInLeadId != null)
                {                      
                    String strQueryOnDependentObj = 'select '+strleadQues+'id from Lead where id = \'' + LoggedInLeadId + '\'';
                    SObject[] lstDependentObj = Database.query(strQueryOnDependentObj); 
                    If(lstDependentObj != null && lstDependentObj.size()>0)
                    {
                        for(SObject objDependentObj  : lstDependentObj)
                        {
                           // system.debug('@@@@@karthik'+setQuesAccountAPInames);
                            for(String strApiName : setQuesLeadAPInames)
                            {
                                If(strApiName <> '' && objDependentObj.get(strApiName) <> null)
                                {  
                                    mapDependentQuestoValue.put(strApiName,string.valueof(objDependentObj.get(strApiName))); 
                                }
                            }   
                        }
                    }
                }
                If(strAccQues != null && strAccQues <> '' && LoggedInContact != null)
                {
                    String strQueryOnDependentObj = 'select '+strAccQues+'id from Contact where id = \'' + LoggedInContact + '\'';
                    system.debug('!@#$%^&*'+strQueryOnDependentObj+'========'+strAccQues);
                    SObject[] lstDependentObj = Database.query(strQueryOnDependentObj);
                    system.debug('@@@@@karthik'+lstDependentObj);
                    If(lstDependentObj != null && lstDependentObj.size()>0)
                    {
                        for(SObject objDependentObj  : lstDependentObj)
                        {
                            system.debug('@@@@@karthik'+setQuesAccountAPInames);
                            for(String strApiName : setQuesAccountAPInames)
                            {
                                If(strApiName <> '' && objDependentObj.get(strApiName) <> null)
                                {  
                                    mapDependentQuestoValue.put(strApiName,string.valueof(objDependentObj.get(strApiName))); 
                                }
                            }   
                        }
                    }
                } 
                system.debug('@@@@@karthik_map'+mapDependentQuestoValue);
                system.debug('Map:::_____----'+mapScriptIdToListOfQuestions);
                if(mapScriptIdToListOfQuestions.size()>0)
                {
                    Integer IndexCount = 0;
                    for(Script__c objScript:lstScript)
                    {
                        WrapperScript objWrapScript = new WrapperScript();
                        objWrapScript.objScript = objScript;
                        objWrapScript.NoOfQuesSkipped = 0;
                        objWrapScript.IsSkipApp2 = false;
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
                                if(objWrapScript.objScript.acf_Question_Type__c == 'Applicant Details' && objQuestion.acfIs_Applicant_Question__c <> true)
                                {
                                    objMasterQuestion.strApplicantNo = 'First Applicant';
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
                            }
                            // For Applicant Detail script.
                            if(objWrapScript.objScript.acf_Question_Type__c == 'Applicant Details')
                            {
                                for(Question__c objQuestion: mapScriptIdToListOfQuestions.get(objScript.id))
                                {
                                    if(objQuestion.acfIs_Applicant_Question__c <> true)
                                    {
                                        WrapperQuestions objMasterQuestion   = new WrapperQuestions();
                                        objMasterQuestion.objWrapQuestion    = objQuestion;
                                        objMasterQuestion.ScriptSequence     = IndexCount;
                                        objMasterQuestion.lstSelectOpt       = new List<SelectOption>();
                                        objMasterQuestion.strApplicantNo     = 'Second Applicant';
                                        objMasterQuestion.IsApplicant2Question = true;
                                        objMasterQuestion.lstSelectOptions   = new List<Answer__c>();
                                        objMasterQuestion.lstCheckBoxAnswer  = new List<string>();
                                        objMasterQuestion.lstRelatedQuestion    = new List<WrapperQuestions>();
                                        //List To be added Applicant 2 Api Field
                                        if(objQuestion.acfApplicant_2_Api_Name__c <> null)
                                            lstContactAPINames.add(objQuestion.acfApplicant_2_Api_Name__c);
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
                for(Question__c objQuestion:[select id,acf_ApiName__c,acfApplicant_2_Api_Name__c,acf_Master_Question__c,acf_Dependents__c,acfEmployment_Type__c,acf_Script__c,acfBubble_Text__c,acfWatermark_Text__c,acfDependent_Field_Name__c,acfDependent_Object_Name__c,acfDependent_Value__c,
                                            acfAppEmployment_Type__c,acfIs_Applicant_Question__c,acf_Question__c from  Question__c where 
                                            acf_Script__c = null and (acfEmployment_Type__c = true or acf_Dependents__c = true) and acf_Active__c = true])
                {
                    if(objQuestion.acfApplicant_2_Api_Name__c <> null)
                        lstContactAPINames.add(objQuestion.acfApplicant_2_Api_Name__c);
                    if(objQuestion.acf_ApiName__c <> null) 
                        lstContactAPINames.add(objQuestion.acf_ApiName__c);
                
                }
                //For Reloading(Refreshing) all Filled Questions
                system.debug('!@#$%^&'+lstContactAPINames);
                if(LoggedInContact <> null && lstContactAPINames <> null && lstContactAPINames.size()>0)
                {
                    Id RelatedQuesId ;
                    String strAnswers = '';
                    string strAnswer = '';
                    string selectedAnswerId = '';
                    TotalNoQuestionSlide = 0;
                    MasterQuesNo = 0;
                    mapContactAPINameToSelectedAnswer = getContactApiToAnswer(lstContactAPINames);
                    system.debug('@#$#$###'+mapContactAPINameToSelectedAnswer.size());
                    boolean IsExitfromLoop = false;
                    system.debug('!@#$%%'+lstMasterWrapperQuestion.size());
                    intTotalQuestions = lstMasterWrapperQuestion.size();
                    for(WrapperQuestions objQuestions : lstMasterWrapperQuestion)
                    {
                        system.debug('@#$Lokesh::__'+objQuestions.ScriptSequence);
                        system.debug('@@@'+MasterQuesNo);
                        system.debug('@@@'+TotalNoQuestionSlide);
                        system.debug('@@@'+ScriptIndexNo);
                        system.debug('@@@'+ScriptQuestionNo);
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
                                   /*TotalNoQuestionSlide++;
                                   MasterQuesNo++;
                                   ScriptQuestionNo++;*/
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
                                   /* if(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion <> null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c != null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c != null && mapDependentQuestoValue.get(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c){
                                            //IsSkipDependent = 'true';
                                            ++MasterQuesNo; 
                                            ScriptQuestionNo++; 
                                            TotalNoQuestionSlide++;   
                                    }*/
                                }
                                   
                                   
                                }
                                //If Assets and liabilities not filled and question type is component.
                                if(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)==null || ((mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)=='false') && (objQuestions.objWrapQuestion.acf_Type__c == 'Component')))
                                {
                                   IsExitfromLoop = true;
                                   break;
                                }
                                else if(objQuestions.IsApplicant2Question && mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c)==null)
                                {
                                   IsExitfromLoop = true;
                                   break;
                                }
                                if(objQuestions.IsApplicant2Question)
                                {
                                    if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c)) <> null)
                                        objQuestions.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c));
                                    else
                                        objQuestions.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c);                            
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
                                    
                                    string strNoOfApp = '';
                                    strNoOfApp = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);
                                    system.debug('@@@@'+strNoOfApp);
                                    objQuestions.strWrapAnswer = strNoOfApp;
                                    if(strNoOfApp <> '2')
                                    {
                                        objPrepopulatingScript.IsSkipQuestions = true;
                                        objPrepopulatingScript.NoOfQuesSkipped = ((objPrepopulatingScript.lstScriptMasterQuestions.size())/2);
                                    }
                                    else
                                    {
                                        objPrepopulatingScript.IsSkipQuestions = false;
                                        objPrepopulatingScript.NoOfQuesSkipped = 0; 
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
                                                if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c)) <> null)
                                                    objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c));
                                                else
                                                    objRelatedQuestion.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c);                            
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
                                else if(RelatedQuesId == null && objPrepopulatingScript.objScript.acf_Question_Type__c == 'Applicant Details'  && objQuestions.objWrapQuestion.acf_Dependents__c && (mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)<>null || mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c) <>null))
                                {
                                    system.debug('____LOkesh_____');
                                    Integer NoOFDependent;
                                    if(objQuestions.IsApplicant2Question)                       
                                        NoOFDependent = Integer.valueof(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c));
                                    else
                                        NoOFDependent = Integer.valueof(mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c));   
                                    for(Question__c objDependentQuestion : [select id,acf_ApiName__c,acf_Description__c,acf_Master_Question__c,acfApplicant_2_Api_Name__c,acfIs_Applicant_Question__c,acf_Question__c,acf_Script__c,acf_Dependents__c,date__c,acf_Postal_Code__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfBubble_Text__c,acfWatermark_Text__c,acfDependent_Field_Name__c,acfDependent_Object_Name__c,acfDependent_Value__c,
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
                                            if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c)) <> null)
                                                objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c));
                                            else
                                                objRelatedQuestion.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c);                            
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
                                else if(RelatedQuesId == null && objPrepopulatingScript.objScript.acf_Question_Type__c == 'Applicant Details'  && objQuestions.objWrapQuestion.acfEmployment_Type__c && (mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c)<>null || mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c) <>null))
                                {
                                    system.debug('____LOkesh_____');
                                    string strType;
                                    if(objQuestions.IsApplicant2Question)                       
                                        strType = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acfApplicant_2_Api_Name__c);
                                    else
                                        strType = mapContactAPINameToSelectedAnswer.get(objQuestions.objWrapQuestion.acf_ApiName__c);   
                                    for(Question__c objDependentQuestion : [select id,acf_ApiName__c,acf_Description__c,acfApplicant_2_Api_Name__c,acf_Master_Question__c,acfIs_Applicant_Question__c,acfAppEmployment_Type__c,acf_Question__c,acf_Script__c,acf_Dependents__c,date__c,acf_Postal_Code__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfWatermark_Text__c,
                                                                             (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                                               where acfIs_Applicant_Question__c = true and acf_Active__c = true and acfEmployment_Type__c = true and acfAppEmployment_Type__c =:strType and acf_Script__c = null order by acf_Sequence_No__c  ])
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
                                            if(mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c)) <> null)
                                                objRelatedQuestion.strWrapAnswer  = mapAnswerNameToAnswerId.get(mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c));
                                            else
                                                objRelatedQuestion.strWrapAnswer  = mapContactAPINameToSelectedAnswer.get(objRelatedQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c);                            
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
                                   /* if(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion <> null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c != null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c != null && mapDependentQuestoValue.get(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c){
                                            //IsSkipDependent = 'true';
                                            ++MasterQuesNo; 
                                            ScriptQuestionNo++; 
                                            TotalNoQuestionSlide++;   
                                    }*/
                                }
                                
                            }
                        }
                                            
                    }        
                }
            } 
            //intQuoteWidth = (MasterQuesNo+1*100)/intTotalQuestions;
            //ClickQuoteDetail.intWidth = (MasterQuesNo+1*100)/intTotalQuestions;
            ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');
        }
        catch(Exception ex)
        {
            system.debug('NRAC::ERROR::'+ex.getMessage());
        }  
    }
    
    Public pagereference redirect(){
      string returnURL = acfcommon.redirect(userinfo.getuserId(),'clickpostloginquestionnaires');
      if(returnURL != null && returnURL <> '' && returnURL != 'false')
      {
           return new Pagereference('/'+returnURL);
      }else{
              return null;
          }
        //String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId()); 
      /* If(LoggedInLeadId != null){
        List<Lead> lstLead = [select id,acfIs_Post_Login_Ques_Attempted__c,isConverted from Lead where id=:LoggedInLeadId];
        If(lstLead != null && lstLead.size()>0){
           If(lstLead[0].isConverted == true) {
               return new Pagereference('/ClickDashboard');
           }else If(lstLead[0].acfIs_Post_Login_Ques_Attempted__c == true){
                    string retPgName = acfCommon.sendReturnUrl(Userinfo.getuserID(),false,'acfpostloginQuestions'); 
                    return new pageReference('/'+retPgName);
                 }
        }
       }
       /* If(oppId != null && oppId <> ''){
           return new Pagereference('/acfLoanDashboard');
        }else {
                return null;
             }
      return null;*/
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
                  /*  If(RelatedQuesId <> null && mapQuestionIdToQuestion.get(RelatedQuesId) <> null && mapQuestionIdToQuestion.get(RelatedQuesId).acfDependent_Field_Name__c != null && mapQuestionIdToQuestion.get(RelatedQuesId).acfDependent_Object_Name__c != null && mapQuestionIdToQuestion.get(RelatedQuesId).acfDependent_Object_Name__c == 'Account'){
                        String strApiName = mapQuestionIdToQuestion.get(RelatedQuesId).acfDependent_Field_Name__c;
                            String strQueryOnDependentObj = 'select '+strApiName+',id from Account where id = \'' + strCurrentLoggedInAccount + '\'';
                            SObject[] lstDependentObj = Database.query(strQueryOnDependentObj); 
                            If(lstDependentObj!= null && lstDependentObj.size()>0){
                                mapDependentQuestoValue.put(strApiName,string.valueof(lstDependentObj[0].get(strApiName)));
                            }
                            system.debug('karthik==Related'+mapDependentQuestoValue);
                    }*/
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
                            for(Question__c objDependentQuestion : [select id,acf_ApiName__c,acf_Description__c,acf_Master_Question__c,acfApplicant_2_Api_Name__c,acfIs_Applicant_Question__c,acf_Question__c,acf_Script__c,acf_Dependents__c,date__c,acf_Postal_Code__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfWatermark_Text__c,
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
                               /* If(isZeroDependent == true){
                                     objQuestion.IsContinueDisplay = true;
                                     IsSlide = 'true';  
                                     break; 
                                }*/
                            }
                        }   
                    }
                    else if(RelatedQuesId == null && objScript.objScript.acf_Question_Type__c == 'Applicant Details'  && objQuestion.objWrapQuestion.acfEmployment_Type__c  && strAnswers <> null && strAnswers <> '')
                    {
                        for(Question__c objDependentQuestion : [select id,acf_ApiName__c,acf_Description__c,acfApplicant_2_Api_Name__c,acf_Master_Question__c,acfIs_Applicant_Question__c,acfAppEmployment_Type__c,acf_Question__c,acf_Script__c,acf_Dependents__c,date__c,acf_Postal_Code__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c ,acfBubble_Text__c,acfWatermark_Text__c,
                                                                (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) from Question__c
                                                                where acfIs_Applicant_Question__c = true and acf_Active__c = true and acfEmployment_Type__c = true and acfAppEmployment_Type__c =:strAnswers and acf_Script__c = null order by acf_Sequence_No__c  ])
                        {
                            system.debug('::::Applicant::::::::'+objDependentQuestion );
                            objQuestion.IsContinueDisplay = false;
                            WrapperQuestions objRelatedQuestion = new WrapperQuestions();
                            objRelatedQuestion.objWrapQuestion = objDependentQuestion ;
                            objRelatedQuestion.lstSelectOpt = new List<SelectOption>();
                            objRelatedQuestion.lstSelectOptions = new List<Answer__c>();
                            objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                            if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Phone' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Number' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' ||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Currency'||objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Percent')
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
                if((objQuestion.objWrapQuestion.acf_Dependents__c || objQuestion.objWrapQuestion.acfEmployment_Type__c))
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
    // Call on the click of Continue button
    public pageReference NextQuestion()
    {
        IsSlide = 'false';
        NoOfPrePostdependent = 0;
        IsSkipDependent = 'false';
        strmsg  = '';
        NoOfLeftSlide = 0;
        NoOfRightSlide = 0;
        system.debug('@@@@@test'+lstMasterWrapperQuestion);
        map<string,string>mapAnswerIdToAnswer = new map<string,string>();
        map<Question__c,string>mapQuesToSelectedAnswer = new map<Question__c,string>();
        //LoggedInContact = '003O000000WP6Qd';
        Contact objPortalContact = new Contact(id = LoggedInContact);
        system.debug('@@#$%%'+MasterQuesNo +'@#$%'+lstMasterWrapperQuestion);
        if(MasterQuesNo < lstMasterWrapperQuestion.size())
        {
            WrapperQuestions objQuestion =  lstMasterWrapperQuestion[MasterQuesNo];
           // if(MasterQuesNo+1 < lstMasterWrapperQuestion.size()){strBubbleText = lstMasterWrapperQuestion[MasterQuesNo+1].objWrapQuestion.acfBubble_Text__c;} 
            system.debug('@#@##$#%%^'+objQuestion);
            if(objQuestion <> null && objQuestion.ScriptSequence <> null)
            {
                WrapperScript objWrapScript = lstWrapperScript[objQuestion.ScriptSequence];
                ScriptIndexNo = objQuestion.ScriptSequence;
                if((objWrapScript <> null))
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
                                   objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));
                                else  
                                   objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));
                            }  
                            else
                            {
                                if(objQuestion.IsApplicant2Question)
                                    objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer));
                                else
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer));
                            }  
                        }
                        else
                        {
                            if(objQuestion.objWrapQuestion.acf_Type__c == 'Number' || objQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                            {
                                if(objQuestion.IsApplicant2Question) 
                                    objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,decimal.valueof(objQuestion.strWrapAnswer)); 
                                else
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(objQuestion.strWrapAnswer));                                    
                            }    
                            else
                            {
                                if(objQuestion.IsApplicant2Question)                                    
                                     objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,objQuestion.strWrapAnswer);
                                else     
                                     objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer);
                            }   
                        }
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
                                ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');
                                return null;
                            }
                            else if(objRelatedQues.objWrapQuestion.acf_Type__c == 'Checkbox' && objRelatedQues.lstCheckBoxAnswer.size()>0)
                            {    
                                for(string strAns:objRelatedQues.lstCheckBoxAnswer)
                                {
                                    if(mapAnswerIdToAnswer <> null && mapAnswerIdToAnswer.get(strAns)<> null)
                                    {
                                        if(objQuestion.IsApplicant2Question)
                                           objPortalContact.put(objRelatedQues.objWrapQuestion.acfApplicant_2_Api_Name__c,mapAnswerIdToAnswer.get(strAns));
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
                                         objPortalContact.put(objRelatedQues.objWrapQuestion.acfApplicant_2_Api_Name__c,decimal.valueof(mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer)));
                                    else
                                         objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer)));                                                                                    
                                }
                                else
                                {
                                    if(objQuestion.IsApplicant2Question)
                                        objPortalContact.put(objRelatedQues.objWrapQuestion.acfApplicant_2_Api_Name__c,mapAnswerIdToAnswer.get(objRelatedQues.strWrapAnswer));                                     
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
                                         objPortalContact.put(objRelatedQues.objWrapQuestion.acfApplicant_2_Api_Name__c,decimal.valueof(objRelatedQues.strWrapAnswer));
                                     else
                                         objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,decimal.valueof(objRelatedQues.strWrapAnswer));                                      
                                }  
                                else
                                {
                                    if(objQuestion.IsApplicant2Question)
                                        objPortalContact.put(objRelatedQues.objWrapQuestion.acfApplicant_2_Api_Name__c,objRelatedQues.strWrapAnswer);
                                    else
                                        objPortalContact.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,objRelatedQues.strWrapAnswer);                                       
                                }    
                            }
                            //mapQuestionIdToSelectedAnswers.put(objRelatedQues.objWrapQuestion.id,objRelatedQues.strWrapAnswer);
                        }
                    }
                    else
                    {
                        system.debug('$$$$'+objQuestion.strWrapAnswer);
                        if((objQuestion.strWrapAnswer == null || objQuestion.strWrapAnswer == '' || objQuestion.strWrapAnswer == 'NONE') && objQuestion.lstCheckBoxAnswer <> null && objQuestion.lstCheckBoxAnswer.size()==0)
                        {
                          IsSlide = 'false';
                          system.debug('@##@##@');
                          strmsg = 'Please fill the answer';
                          strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill the answer.'));
                          system.debug(strmsg);
                          ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');
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
                                    ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');
                                    return null;
                                }
                            }
                            else
                            {
                                 strmsg = 'Please Enter valid date';
                                 strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c;
                                 ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');
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
                                        objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,mapAnswerIdToAnswer.get(strAns));
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
                                     objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));
                              else
                                     objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer)));                            
                            } 
                            else
                            {
                                if(objQuestion.IsApplicant2Question)
                                     objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer));
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
                                    objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,decimal.valueof(objQuestion.strWrapAnswer));
                                else
                                    objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,decimal.valueof(objQuestion.strWrapAnswer));                    
                            }   
                            else
                            {
                                if(objQuestion.IsApplicant2Question)
                                    objPortalContact.put(objQuestion.objWrapQuestion.acfApplicant_2_Api_Name__c,objQuestion.strWrapAnswer); 
                                else    
                                     objPortalContact.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer); 
                            }   
                        }
                    }
                    // For Applicant Question Script
                    if(objWrapScript.objScript.acf_Question_Type__c == 'Applicant Details' && objQuestion.objWrapQuestion.acfIs_Applicant_Question__c)
                    {
                        string strNoOfApp = '';
                        strNoOfApp = mapAnswerIdToAnswer.get(objQuestion.strWrapAnswer);
                        system.debug('@@@@APPPP'+strNoOfApp);
                        if(strNoOfApp <> '2')
                        {
                            objWrapScript.IsSkipQuestions = true;
                            objWrapScript.NoOfQuesSkipped = ((objWrapScript.lstScriptMasterQuestions.size())/2);
                        }
                        else
                        {
                            objWrapScript.IsSkipQuestions = false;
                            objWrapScript.NoOfQuesSkipped = 0; 
                        }
                    }
                    if(objPortalContact <> null)
                    {
                      update objPortalContact;
                      If(objPortalContact.acf_Applicant_Name__c != null){
                         if(lstuserMobile <> null && lstuserMobile.size()>0)
                          {
                              User objUser = lstuserMobile[0];
                              if(objUser.accountId != null)
                              {
                                List<String> lstName = objPortalContact.acf_Applicant_Name__c.split(' ');
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
                            objLead.acfIs_Post_Login_Ques_Attempted__c = true;
                            update objLead;
                        } 
                        string retPgName = acfCommon.sendReturnUrl(Userinfo.getuserID(),false,'acfpostloginQuestions'); 
                        return new pageReference('/'+retPgName);
                    } 
                    system.debug('karthik test@@@123'+ScriptQuestionNo+'===='+objWrapScript.NoOfQuesSkipped+'==='+MasterQuesNo+'==='+ScriptIndexNo+'===='+lstScriptQuestionsLadder.size());
                    if((ScriptQuestionNo == objWrapScript.lstScriptMasterQuestions.size()-1)||(objWrapScript.IsSkipQuestions == true && ScriptQuestionNo == (objWrapScript.NoOfQuesSkipped)))
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
                         ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');
                         return null;
                    }
                    else
                    {
                        ++MasterQuesNo; 
                        ScriptQuestionNo++;
                        IsSlide = 'true';
                        system.debug('karthik==Continue'+mapDependentQuestoValue);
                        If(strAccQues != null && strAccQues <> ''&& LoggedInContact != null){
                            String strQueryOnDependentObj = 'select '+strAccQues+'id from Contact where id = \'' + LoggedInContact + '\'';
                            SObject[] lstDependentObj = Database.query(strQueryOnDependentObj);
                            If(lstDependentObj != null && lstDependentObj.size()>0){
                              for(SObject objDependentObj  : lstDependentObj){
                               system.debug('@@@@@karthik'+setQuesAccountAPInames);
                               for(String strApiName : setQuesAccountAPInames){
                                   If(strApiName <> '' && objDependentObj.get(strApiName) <> null){  
                                      mapDependentQuestoValue.put(strApiName,string.valueof(objDependentObj.get(strApiName))); 
                                   }
                               }   
                              }
                            }
                        } 
                        system.debug('karthik_map@@@@'+mapDependentQuestoValue+'====='+lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c);
                        if(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion <> null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c != null && lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c != null && mapDependentQuestoValue.get(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c)
                        {
                            while((mapDependentQuestoValue.get(lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Field_Name__c) != lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfDependent_Value__c) && (MasterQuesNo < lstMasterWrapperQuestion.size()))
                            {
                                IsSkipDependent = 'true';
                                NoOfPrePostdependent++; 
                                ++MasterQuesNo; 
                                ScriptQuestionNo++;
                                
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
            ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');
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
            if(objQuestion <> null && objQuestion.ScriptSequence <> null)
            {
                ScriptIndexNo = objQuestion.ScriptSequence;
                WrapperScript objScript = lstWrapperScript[objQuestion.ScriptSequence];
                if((objScript <> null))
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
                        strBubbleText = lstMasterWrapperQuestion[MasterQuesNo].objWrapQuestion.acfBubble_Text__c; 
                        IsSlide = 'true';
                    }
                }   
            } 
            system.debug('Quote@@'+MasterQuesNo);
            ClickQuoteDetail.setProgressBarWidth(MasterQuesNo,intTotalQuestions,'ClickPostloginQuestionnaires');          
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
                          string retPgName = acfCommon.sendReturnUrl(Userinfo.getuserID(),false,'acfpostloginQuestions'); 
                          return new pageReference('/'+retPgName);
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
    //Script Wrapper
    public class WrapperScript
    {
         public Script__c objScript{get;set;}
         public Integer ScriptNumber{get;set;}
         public boolean IsSkipQuestions{get;set;}
         public Integer NoOfQuesSkipped{get;set;}
         public boolean IsSkipApp2{get;set;}
         public List<WrapperQuestions>lstScriptMasterQuestions{get;set;}
    }
    //Master Question Wrapper
    public class WrapperQuestions
    {
          public Question__c objWrapQuestion {get;set;}
          public string strApplicantNo{get;set;}
          public string strWrapAnswer {get;set;}
          public List<SelectOption>lstSelectOpt {get;set;}
          public List<WrapperQuestions>lstRelatedQuestion {get;set;}
          public List<Answer__c>lstSelectOptions{get;set;}
          public List<string>lstCheckBoxAnswer{get;set;}
          public boolean IsContinueDisplay{get;set;}
          public boolean IsApplicant2Question{get;set;}
          public Integer ScriptSequence{get;set;}
    }
}