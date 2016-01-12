/*====================================================
    WHITE LABEL -- UAT SB
========================================================*/
public class WLpreloginQuestionController
{
    //public variables declaration
    public map<decimal,Id>mapQuestionSequenceNo;
    public map<id,Question__c>mapQuestionIdToQuestion;
    public integer indexNo{get;set;}
    public integer QuesNo{get;set;}
    public List<WrapperQuestions>lstMasterWrapperQuestion;
    public List<WrapperQuestions>lstWrapperQuestion{get;set;}
    Public List<Integer> TotalQlist = new List<Integer>();
    public string strmsg{get;set;}
    public string IsSlide{get;set;}
    public boolean IsSlideToNextQues{get;set;}
    public List<Question__c>lstScriptQuestion{get;set;}
    public list<acfBank_Detail__c> lstbank {get;set;}
    public map<string,string>MapLeadQuesApiToAnswers = new map<string,string>();
    public map<string,string>mapQuestionIdToSelectedAnswers;
    public List<string>lstSelectedAnswers{get;set;}
    Public Integer intTotalQuestions {get;set;}
    Public acfSupport__c supportObj {get;set;}
    public boolean IsRedirect{get;set;}
    Public boolean isNavigated {get;set;}
   
    Public String strBubbleText 
    {
        get
        {
            if(lstWrapperQuestion != null && indexNo != null && indexNo >= 0 && lstWrapperQuestion.size() > indexNo)
            {
                if(lstWrapperQuestion[indexNo] != null)
                {
                    if(lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c != null)
                    return lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c;
                }
            }
            return '';
        }
        set;
    }
    Public Boolean isCookiesexist {get;set;}
    // this map is mainly used to bind checkbox answers.
    public map<string,string>mapAnswerNameToAnswerId;
    
    public string strMessages {get;set;}
    
    private Click_Community_Setup__c objCommSetup {get;set;}
    
    //Constructor 
    public WLpreloginQuestionController()
    {
        initializeCookies();
        IsRedirect = false;
        isCookiesexist = false;
        mapQuestionSequenceNo          = new map<decimal,Id>();
        mapQuestionIdToSelectedAnswers = new map<string,string>();
        lstMasterWrapperQuestion = new List<WrapperQuestions>();
        lstWrapperQuestion       = new List<WrapperQuestions>();
        mapQuestionIdToQuestion  = new map<id,Question__c>();
        lstSelectedAnswers = new List<string>();
        mapAnswerNameToAnswerId = new map<string,string>();
        lstbank  = new List<acfBank_Detail__c>();
        IsSlideToNextQues = false;
        strmsg = '';
        //strBubbleText = 'Who is your <span class="upd-bold">current lender?</span>';
        IsSlide = 'false';
        Id ScriptId;
        indexNo = 0;
        lstScriptQuestion = new List<Question__c>();
        
        string CommID =  Network.getNetworkId();
        if(CommID != null && CommID != '')
                objCommSetup = ClickCommon.getCommunitySetup(CommID);
                
        if(objCommSetup != null)
        {
            if(objCommSetup.Click_Support_Team_Name__c != null)
                supportObj = acfSupport__c.getValues(objCommSetup.Click_Support_Team_Name__c);
                
            List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c,Click_Community_Setup__c from Script__c where acf_Type__c=:'Pre-Login' AND Click_Community_Setup__c =: objCommSetup.id  order by acf_Sequence_no__c limit 1];
            system.debug('!#$%'+lstScript);
            if(lstScript <> null && lstScript.size()>0)
                ScriptId = lstScript[0].id;
        }
        if(ScriptId <> null)
        {
            Cookie IsNewHomeLoan = ApexPages.currentPage().getCookies().get('IsNewHomeLoan');
            
            lstScriptQuestion = [select id,acf_Stage_Name__c,acf_Sequence_No__c,acfBubble_Text__c,acfWatermark_Text__c from Question__c where acf_Script__c =:ScriptId and acf_Active__c = true order by acf_Sequence_No__c desc];
            //intTotalQuestions = lstScriptQuestion.size();
            if(IsNewHomeLoan <> null && IsNewHomeLoan.getvalue() == 'true')
            {
                for(Question__c objQuestion:
                    [select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,
                    acf_Sequence_No__c, acf_Postal_Code__c, acfBubble_Text__c,acfWatermark_Text__c,acfIs_New_Loan__c,acfNew_Loan_Sequence_No__c,                                                            
                    (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) 
                    from Question__c
                    where ((acf_Master_Question__r.acf_Script__c =: ScriptId or acf_Script__c =:ScriptId) 
                    and acf_Active__c = true and acfIs_New_Loan__c = true) AND Click_Is_Broker_Question__c = false 
                    order by acfNew_Loan_Sequence_No__c])
                {                                      
                    mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                    WrapperQuestions objWarpperQues = new WrapperQuestions();
                    objWarpperQues.objWrapQuestion = objQuestion;
                    if(objQuestion.acf_Script__c <> null)
                    {
                        lstMasterWrapperQuestion.add(objWarpperQues);   
                    }
                }     
                
                }
                else
                {
                    for(Question__c objQuestion:
                        [select id,acf_ApiName__c,acf_Description__c,acf_Current_lender__c,acf_Master_Question__c,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, 
                        acf_Postal_Code__c,acfBubble_Text__c,acfWatermark_Text__c,acfIs_refinance__c,acfRefinance_Sequence_No__c,                                                          
                        (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c,acfSequence_No__c from Answer__r order by acfSequence_No__c) 
                        from Question__c
                        where ((acf_Master_Question__r.acf_Script__c =: ScriptId or acf_Script__c =:ScriptId) 
                        and acf_Active__c = true and acfIs_refinance__c = true) AND Click_Is_Broker_Question__c = false  
                        order by acfRefinance_Sequence_No__c])  
                        {                                      
                            mapQuestionIdToQuestion.put(objQuestion.id,objQuestion);
                            WrapperQuestions objWarpperQues = new WrapperQuestions();
                            objWarpperQues.objWrapQuestion = objQuestion;
                            if(objQuestion.acf_Script__c <> null)
                                lstMasterWrapperQuestion.add(objWarpperQues);  
                        }              
            }
            intTotalQuestions = lstMasterWrapperQuestion.size();   
            //for adding wrapperlist in a page for all master questions.  
            if(lstMasterWrapperQuestion != null && lstMasterWrapperQuestion.size()>0)
            {
                for(WrapperQuestions objMasterQuestion:lstMasterWrapperQuestion)
                {
                    objMasterQuestion.lstSelectOpt = new List<SelectOption>();
                    objMasterQuestion.lstSelectOptions = new List<Answer__c>();
                    objMasterQuestion.lstCheckBoxAnswer = new List<string>();
                    
                    if(objMasterQuestion.objWrapQuestion.acf_Type__c == 'Text' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Checkbox'|| objMasterQuestion.objWrapQuestion.acf_Type__c == 'Number' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                        objMasterQuestion.IsContinueDisplay = true;
                        
                    for(Answer__c objAnswer: objMasterQuestion.objWrapQuestion.Answer__r)
                    {   
                        objMasterQuestion.lstSelectOptions.add(objAnswer);
                        objMasterQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                    }
                    
                    lstWrapperQuestion.add(objMasterQuestion); 
                }
            }
            
            // This cookie is used to get bank name from landing page.
            Cookie bankName = ApexPages.currentPage().getCookies().get('Bname');
            system.debug('###'+bankName);
            map<string,string>mapCookiesQues = new map<string,string>();
            //This cookie is used to get qustions that the used has filled.
            Cookie WLACFQuestions = ApexPages.currentPage().getCookies().get(objCommSetup.Click_Page_Prefix__c+'ACFQues');
            system.debug('@@@@@'+objCommSetup.Click_Page_Prefix__c+'ACFQues');
            if(bankName <> null && bankName.getvalue() <> '' && (WLACFQuestions == null || WLACFQuestions.getvalue() == null || WLACFQuestions.getvalue()== ''))
            {
                lstWrapperQuestion[indexNo].strWrapAnswer = bankName.getvalue();
                indexNo = 1;
                // IsSlideToNextQues  = true;
                lstSelectedAnswers.add(bankName.getvalue());
                MapLeadQuesApiToAnswers.put(lstWrapperQuestion[0].objWrapQuestion.acf_ApiName__c,bankName.getValue());
                mapQuestionIdToSelectedAnswers.put(lstWrapperQuestion[0].objWrapQuestion.id,bankName.getValue());
                strBubbleText = lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c;
                system.debug('@@@@@@'+MapLeadQuesApiToAnswers);
                // mapCookiesQues.put(lstWrapperQuestion[0].objWrapQuestion.id,bankName.getValue());  
            }
            else if(WLACFQuestions <> null && WLACFQuestions.getvalue() <> null && WLACFQuestions.getvalue() <> '')
            {
                isCookiesexist = true; 
                IsRedirect = true;  
                //This method is used to get map from cookies data.
                mapCookiesQues  = getMapQuesIDToSelectedAnswer(WLACFQuestions.getvalue());
            }    
            if(mapCookiesQues <> null && mapCookiesQues.size()>0)
            {
                id relatedQues = null;
                //lstWrapperQuestion = new List<WrapperQuestions>();
                system.debug('@#%%$'+lstMasterWrapperQuestion);
                for(WrapperQuestions objMasterQuestion:lstMasterWrapperQuestion)
                {
                    if(mapCookiesQues.get(objMasterQuestion.objWrapQuestion.id) <> null)
                    {
                        WrapperQuestions objCookiesQuestion = new WrapperQuestions();
                        string strAnswer = '';
                        objCookiesQuestion.objWrapQuestion  = objMasterQuestion.objWrapQuestion;
                        objCookiesQuestion.lstCheckBoxAnswer = new List<string>();
                        objCookiesQuestion.strWrapAnswer    = mapCookiesQues.get(objMasterQuestion.objWrapQuestion.id);
                        objCookiesQuestion.lstSelectOptions = new List<Answer__c>();
                        objCookiesQuestion.lstCheckBoxAnswer = new List<string>();
                        objCookiesQuestion.lstSelectOpt = new List<SelectOption>();
                        objCookiesQuestion.IsContinueDisplay = true;
                        lstSelectedAnswers.add(objCookiesQuestion.strWrapAnswer);
                        //strBubbleText = objCookiesQuestion.objWrapQuestion.acfBubble_Text__c;
                        mapQuestionIdToSelectedAnswers.put(objCookiesQuestion.objWrapQuestion.id,objCookiesQuestion.strWrapAnswer);
                        MapLeadQuesApiToAnswers.put(objCookiesQuestion.objWrapQuestion.acf_ApiName__c,objCookiesQuestion.strWrapAnswer);
                        if(objCookiesQuestion.objWrapQuestion.acf_Type__c == 'Text' || objCookiesQuestion.objWrapQuestion.acf_Type__c == 'Number' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                        {
                            objCookiesQuestion.IsContinueDisplay = true;
                        }
                        for(Answer__c objAnswer:objCookiesQuestion.objWrapQuestion.Answer__r)
                        {
                            mapAnswerNameToAnswerId.put(objAnswer.acf_Answer__c,objAnswer.id); 
                            if(objCookiesQuestion.objWrapQuestion.acf_Type__c <> 'Checkbox' && objCookiesQuestion.strWrapAnswer <> '' && objCookiesQuestion.strWrapAnswer <> 'NONE')
                            {
                                if(IsValidId(objCookiesQuestion.strWrapAnswer) && objAnswer.id == objCookiesQuestion.strWrapAnswer)
                                {
                                    strAnswer = objAnswer.acf_Answer__c;
                                    if(objAnswer.acf_Related_Question__c <> null)
                                    {
                                        relatedQues = objAnswer.acf_Related_Question__c;
                                        system.debug('@@@'+relatedQues);
                                    }
                                    else
                                    {
                                        relatedQues = null;
                                    }
                                }   
                            }
                            else
                            {
                                strAnswer = objAnswer.acf_Answer__c;
                            }
                            objCookiesQuestion.lstSelectOptions.add(objAnswer);
                            objCookiesQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                        }
                        if(objCookiesQuestion.objWrapQuestion.acf_Type__c == 'Checkbox')
                        {
                            objCookiesQuestion.IsContinueDisplay = true;
                            if(objCookiesQuestion.strWrapAnswer <> '')
                            {
                                for(string objChkboxAns:objCookiesQuestion.strWrapAnswer.split(','))
                                {
                                    objCookiesQuestion.lstCheckBoxAnswer.add(mapAnswerNameToAnswerId.get(objChkboxAns));
                                }
                                objCookiesQuestion.strWrapAnswer = '';
                            }    
                        }
                        if(strAnswer <> '')
                        {
                            MapLeadQuesApiToAnswers.put(objCookiesQuestion.objWrapQuestion.acf_ApiName__c,strAnswer);
                        }
                        if(relatedQues <> null)
                        {
                            system.debug('@@@'+relatedQues);
                            while(relatedQues <> null)
                            {
                                system.debug('@#$#');
                                strAnswer = '';
                                if(mapQuestionIdToQuestion.get(relatedQues)<> null)
                                {
                                    WrapperQuestions objCookiesRelatedQuestion = new WrapperQuestions();
                                    objCookiesRelatedQuestion.objWrapQuestion  = mapQuestionIdToQuestion.get(relatedQues);
                                    objCookiesRelatedQuestion.strWrapAnswer    = mapCookiesQues.get(relatedQues);
                                    objCookiesRelatedQuestion.lstSelectOpt     = new List<SelectOption>();
                                    objCookiesRelatedQuestion.lstSelectOptions  = new List<Answer__c>();
                                    objCookiesRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                                    objCookiesQuestion.lstRelatedQuestion = new List<WrapperQuestions >();
                                    lstSelectedAnswers.add(objCookiesRelatedQuestion.strWrapAnswer);
                                    mapQuestionIdToSelectedAnswers.put(objCookiesRelatedQuestion.objWrapQuestion.id,objCookiesRelatedQuestion.strWrapAnswer);
                                    MapLeadQuesApiToAnswers.put(objCookiesRelatedQuestion.objWrapQuestion.acf_ApiName__c,objCookiesRelatedQuestion.strWrapAnswer);
                                    if(objCookiesRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objCookiesRelatedQuestion.objWrapQuestion.acf_Type__c == 'Number' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objMasterQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                                    {
                                        objCookiesRelatedQuestion.IsContinueDisplay = true;
                                    }
                                    relatedQues = null;
                                    for(Answer__c objAnswer:objCookiesRelatedQuestion.objWrapQuestion.Answer__r)
                                    {
                                        mapAnswerNameToAnswerId.put(objAnswer.acf_Answer__c,objAnswer.id);
                                        if(IsValidId(objCookiesRelatedQuestion.strWrapAnswer) && objAnswer.id == objCookiesRelatedQuestion.strWrapAnswer)
                                        {
                                            strAnswer = objAnswer.acf_Answer__c;
                                            if(objAnswer.acf_Related_Question__c <> null)
                                            {
                                                relatedQues = objAnswer.acf_Related_Question__c;
                                            }
                                            else
                                            {
                                                relatedQues = null;
                                            }
                                        }
                                        objCookiesRelatedQuestion.lstSelectOptions.add(objAnswer);
                                        objCookiesRelatedQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));       
                                    }
                                    if(objCookiesRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox')
                                    {
                                        objCookiesRelatedQuestion.IsContinueDisplay = true;
                                        if(objCookiesRelatedQuestion.strWrapAnswer <> '')
                                        {
                                            for(string objChkboxAns:objCookiesRelatedQuestion.strWrapAnswer.split(','))
                                            {
                                                objCookiesRelatedQuestion.lstCheckBoxAnswer.add(mapAnswerNameToAnswerId.get(objChkboxAns));
                                            }
                                        }    
                                    }
                                    if(strAnswer <> '')
                                    MapLeadQuesApiToAnswers.put(objCookiesRelatedQuestion.objWrapQuestion.acf_ApiName__c,strAnswer); 
                                    objCookiesQuestion.lstRelatedQuestion.add(objCookiesRelatedQuestion);  
                                }
                                else{
                                    relatedQues = null;
                                }  
                            }   
                        }
                        
                        lstWrapperQuestion.set(indexNo,objCookiesQuestion); 
                        indexNo++;
                        
                        If(indexNo < lstWrapperQuestion.size() && lstWrapperQuestion[indexNo].objWrapQuestion != null)
                        strBubbleText = lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c;//added by karthik 22-01-2015
                    }    
                }
            } 
            system.debug('%$%$%'+lstWrapperQuestion);       
        }                            
    }
    
    public class WrapperQuestions
    {
        public Question__c objWrapQuestion {get;set;}
        public string strWrapAnswer {get;set;}
        public List<SelectOption> lstSelectOpt {get;set;}
        public List<WrapperQuestions> lstRelatedQuestion {get;set;}
        public List<Answer__c> lstSelectOptions{get;set;}
        public List<string> lstCheckBoxAnswer{get;set;}
        public boolean IsContinueDisplay{get;set;}
    }
    //Call on master question onChange.
    public pageReference RelatedQuestions()
    {
        // try
        // {
        Id RelatedQuesId ;
        String strAnswers = '';
        IsSlide = 'false';
        if(lstWrapperQuestion.size()>indexNo)
        {   
            WrapperQuestions objQuestion = lstWrapperQuestion[indexNo];
            objQuestion.lstRelatedQuestion = new List<WrapperQuestions>();
            lstSelectedAnswers.add(objQuestion.strWrapAnswer);
            for(Answer__c objAnswer:objQuestion.objWrapQuestion.Answer__r)
            {
                if(objQuestion.strWrapAnswer <> null && objQuestion.strWrapAnswer <> 'NONE')
                {  
                    if(objQuestion.objWrapQuestion.acf_Sequence_No__c <> 1)
                    {
                        if(IsValidId(objQuestion.strWrapAnswer) && objAnswer.id==objQuestion.strWrapAnswer)
                        {
                            strAnswers = objAnswer.acf_Answer__c;
                            if(objAnswer.acf_Related_Question__c <> null)
                            {
                                RelatedQuesId = objAnswer.acf_Related_Question__c;
                                break;
                            }
                        }   
                    }
                    else
                    {
                        strAnswers = objAnswer.acf_Answer__c;
                    }
                }            
            }
            if(strAnswers <> '')
            {
                MapLeadQuesApiToAnswers.put(objQuestion.objWrapQuestion.acf_ApiName__c,strAnswers);
            }
            else
            {
                MapLeadQuesApiToAnswers.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer);
            }
            if(RelatedQuesId <> null && mapQuestionIdToQuestion.get(RelatedQuesId) <> null)
            {
                objQuestion.IsContinueDisplay = false;
                WrapperQuestions objRelatedQuestion = new WrapperQuestions();
                objRelatedQuestion.objWrapQuestion = mapQuestionIdToQuestion.get(RelatedQuesId);
                objRelatedQuestion.lstSelectOpt = new List<SelectOption>();
                objRelatedQuestion.lstSelectOptions = new List<Answer__c>();
                objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                if(objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Number' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objRelatedQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                {
                    objQuestion.IsContinueDisplay = true;
                }
                for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                {
                    objRelatedQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                    objRelatedQuestion.lstSelectOptions.add(objAnswer);
                }
                objQuestion.lstRelatedQuestion.add(objRelatedQuestion);
            }
            else
            {
                objQuestion.IsContinueDisplay = true;
                IsSlide = 'true';
                NextQuestion();
            }            
        }
        //  }
        // catch(Exception Ex)
        // {
        //    system.debug('@@@'+Ex.getMessage());
        //  }
        return null;  
    }
    //Call on Related Questions Onchange.
    public pageReference AddingRelatedQuestion()
    {
        // try
        // {
        system.debug('@@@@@LOkesh'+QuesNo);
        Id RelatedQuesId;
        String strAnswers = '';
        IsSlide = 'false';
        set<Integer>setIndexToRemove = new set<Integer>();
        if(lstWrapperQuestion.size()>indexNo)
        {   
            WrapperQuestions objQuestion = lstWrapperQuestion[indexNo];
            
            if(objQuestion <> null && objQuestion.lstRelatedQuestion <> null && objQuestion.lstRelatedQuestion.size()>0)
            {
                //If any answer is changed then remove all child nodes from the list related to that answer.
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
                    lstSelectedAnswers.add(objRelatedQuestion.strWrapAnswer);
                    for(Answer__c objAnswer:objRelatedQuestion.objWrapQuestion.Answer__r)
                    {
                        if(objRelatedQuestion.strWrapAnswer <> null && objRelatedQuestion.strWrapAnswer <> 'NONE')
                        {  
                            if(IsValidId(objRelatedQuestion.strWrapAnswer) && objAnswer.id==objRelatedQuestion.strWrapAnswer)
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
                    if(strAnswers <> '')
                    {
                        MapLeadQuesApiToAnswers.put(objRelatedQuestion.objWrapQuestion.acf_ApiName__c,strAnswers);
                    }
                    else
                    {
                        MapLeadQuesApiToAnswers.put(objRelatedQuestion.objWrapQuestion.acf_ApiName__c,objRelatedQuestion.strWrapAnswer);
                    } 
                    if(RelatedQuesId <> null && mapQuestionIdToQuestion.get(RelatedQuesId) <> null)
                    {
                        objQuestion.IsContinueDisplay = false;
                        WrapperQuestions objRelatedQuestions = new WrapperQuestions();
                        objRelatedQuestions.objWrapQuestion = mapQuestionIdToQuestion.get(RelatedQuesId);
                        objRelatedQuestions.lstSelectOpt = new List<SelectOption>();
                        objRelatedQuestions.lstSelectOptions = new List<Answer__c>();
                        objRelatedQuestion.lstCheckBoxAnswer = new List<string>();
                        if(objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Text' || objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Checkbox' || objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Number' || objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Currency' || objRelatedQuestions.objWrapQuestion.acf_Type__c == 'Percent')
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
                        IsSlide = 'true';
                        NextQuestion();
                    } 
                }
            }
        }  
        return null; 
    }
    
    
    //Call on Continue Button.
    public pageReference NextQuestion()
    {
        IsRedirect   = true;
        strmsg = '';
        IsSlide = 'false';
        system.debug('Index'+indexNo);
        
        map<string,string>mapAnswerIdToAnswer = new map<string,string>();
        if(lstWrapperQuestion.size()>indexNo)
        {
            WrapperQuestions objQuestion = lstWrapperQuestion[indexNo];
            If(lstWrapperQuestion.size()>indexNo+1){strBubbleText = lstWrapperQuestion[indexNo+1].objWrapQuestion.acfBubble_Text__c;}   
            if(objQuestion <> null)
            {
                if(objQuestion.objWrapQuestion.Answer__r.size()>0)
                {
                    for(Answer__c objAnswer:objQuestion.objWrapQuestion.Answer__r)
                    {
                        mapAnswerIdToAnswer.put(objAnswer.id,objAnswer.acf_Answer__c);
                    }
                } 
                
                lstSelectedAnswers.add(objQuestion.strWrapAnswer);
                mapQuestionIdToSelectedAnswers.put(objQuestion.objWrapQuestion.id,objQuestion.strWrapAnswer);
                if(objQuestion.lstRelatedQuestion <> null && objQuestion.lstRelatedQuestion.size()>0)
                {
                    for(WrapperQuestions objRelatedQues:objQuestion.lstRelatedQuestion)
                    {
                        if(objRelatedQues.objWrapQuestion.Answer__r.size()>0)
                        {
                            for(Answer__c objAnswer:objRelatedQues.objWrapQuestion.Answer__r)
                            {
                                mapAnswerIdToAnswer.put(objAnswer.id,objAnswer.acf_Answer__c);
                            }
                        }  
                        if((objRelatedQues.strWrapAnswer == null || objRelatedQues.strWrapAnswer == '' || objRelatedQues.strWrapAnswer == 'NONE') && objRelatedQues.lstCheckBoxAnswer.size()==0) 
                        {
                            IsSlide = 'false';
                            strmsg = 'Please fill the answer';
                            strBubbleText = lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c;
                            return null;
                        }
                        else if (objRelatedQues.objWrapQuestion.acf_Type__c == 'Checkbox' && objRelatedQues.lstCheckBoxAnswer.size()>0)
                        {
                            string strAnswer = '';
                            system.debug('##$#$'+objRelatedQues.lstCheckBoxAnswer);
                            for(string strAns:objRelatedQues.lstCheckBoxAnswer)
                            {
                                strAnswer += mapAnswerIdToAnswer.get(strAns)+',';
                            }
                            strAnswer = strAnswer.removeEnd(',');
                            MapLeadQuesApiToAnswers.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,strAnswer);
                            mapQuestionIdToSelectedAnswers.put(objRelatedQues.objWrapQuestion.id,strAnswer);
                            //strBubbleText = objRelatedQues.objWrapQuestion.acfBubble_Text__c;
                        }
                        else if(objRelatedQues.objWrapQuestion.acf_Type__c == 'Text'|| objRelatedQues.objWrapQuestion.acf_Type__c == 'Number' || objRelatedQues.objWrapQuestion.acf_Type__c == 'Currency' || objRelatedQues.objWrapQuestion.acf_Type__c == 'Percent')
                        {
                            MapLeadQuesApiToAnswers.put(objRelatedQues.objWrapQuestion.acf_ApiName__c,objRelatedQues.strWrapAnswer);
                        }
                        // strBubbleText = objRelatedQues.objWrapQuestion.acfBubble_Text__c;
                        mapQuestionIdToSelectedAnswers.put(objRelatedQues.objWrapQuestion.id,objRelatedQues.strWrapAnswer);
                    }
                }
                else
                {
                    if((objQuestion.strWrapAnswer == null || objQuestion.strWrapAnswer == '' || objQuestion.strWrapAnswer == 'NONE') && objQuestion.lstCheckBoxAnswer.size()==0)
                    {
                        IsSlide = 'false';
                        strmsg = 'Please fill the answer';
                        strBubbleText = lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill the answer.'));
                        return null;
                    }
                    else if (objQuestion.objWrapQuestion.acf_Type__c == 'Checkbox' && objQuestion.lstCheckBoxAnswer.size()>0)
                    {
                        string strAnswer = '';
                        string strCookiesAnswer = '';
                        for(string strAns:objQuestion.lstCheckBoxAnswer)
                        {
                            strAnswer += mapAnswerIdToAnswer.get(strAns)+',';
                        }
                        strAnswer = strAnswer.removeEnd(',');
                        //strBubbleText = objQuestion.objWrapQuestion.acfBubble_Text__c; // added by karthik 22-01-2012
                        MapLeadQuesApiToAnswers.put(objQuestion.objWrapQuestion.acf_ApiName__c,strAnswer);
                        mapQuestionIdToSelectedAnswers.put(objQuestion.objWrapQuestion.id,strAnswer);
                    }
                    else if(objQuestion.objWrapQuestion.acf_Type__c == 'Text' || objQuestion.objWrapQuestion.acf_Type__c == 'Number' || objQuestion.objWrapQuestion.acf_Type__c == 'Currency' || objQuestion.objWrapQuestion.acf_Type__c == 'Percent')
                    {
                        MapLeadQuesApiToAnswers.put(objQuestion.objWrapQuestion.acf_ApiName__c,objQuestion.strWrapAnswer);
                    }
                }
                if(lstWrapperQuestion.size()== (indexNo+1))
                {
                    system.debug('#####'+MapLeadQuesApiToAnswers);
                    string strLeadApiNameToAnswer = '';
                    string strLeadApiName = '';
                    if(MapLeadQuesApiToAnswers.size()>0)
                    {
                        for(string objLeadApiName:MapLeadQuesApiToAnswers.keyset())
                        {
                            strLeadApiName +=  objLeadApiName + '-:-';
                            strLeadApiNameToAnswer += objLeadApiName+'-:-'+MapLeadQuesApiToAnswers.get(objLeadApiName)+'-,-'; 
                        }
                    }
                    //For Required Documents
                    system.debug(':::::ests::::'+lstSelectedAnswers);
                    if(lstSelectedAnswers <> null && lstSelectedAnswers.size()>0)
                    {
                        String strSelectedAnswers = '';
                        for(string strAnswer:lstSelectedAnswers)
                        {
                            strSelectedAnswers += strAnswer +'--,--';
                        }
                        strSelectedAnswers = strSelectedAnswers.removeEnd('--,--');
                        Cookie ACFRequiredDocumentsAnswers = new Cookie('ACFRA',strSelectedAnswers,null,72000, false); 
                        ApexPages.currentPage().setCookies( new Cookie[]{ACFRequiredDocumentsAnswers});
                    }
                    Cookie ACFLeadApiNames = new Cookie('ACFLeadApiNames',strLeadApiName,null,72000, false); 
                    ApexPages.currentPage().setCookies(new Cookie[]{ACFLeadApiNames});
                    Cookie ACFAnswers = new Cookie('ACFAnswers',strLeadApiNameToAnswer,null,72000, false); 
                    ApexPages.currentPage().setCookies( new Cookie[]{ACFAnswers});
                    Cookie currentUId = ApexPages.currentPage().getCookies().get('ACFAnswers');
                    system.debug('@@@@@'+currentUId);
                    map<string,string>maptst = getLeadApiNameToAnswerMap(currentUId.getvalue());
                    system.debug('###Lokesh'+maptst);
                    IsRedirect  = true;
                    
                    if(objCommSetup != null)
                    {
                        if(objCommSetup.Click_Page_Prefix__c != null)
                        {
                            return new pageReference('/apex/'+objCommSetup.Click_Page_Prefix__c+'PreliminaryQuote');
                        }
                    }
                    else
                    return null;      
                }
                else
                {
                    IsSlide = 'true';
                    ++indexNo;
                }
                //For Cookies
                if(mapQuestionIdToSelectedAnswers <> null && mapQuestionIdToSelectedAnswers.size()>0)
                {
                    string strQuesIdToSelAnswers = '';
                    for(string objQuesId:mapQuestionIdToSelectedAnswers.keyset())
                    {
                        strQuesIdToSelAnswers += objQuesId + '-:-' + mapQuestionIdToSelectedAnswers.get(objQuesId)+'-,-';
                    }
                    Cookie WLACFQues = new Cookie(objCommSetup.Click_Page_Prefix__c+'ACFQues',strQuesIdToSelAnswers,null,72000, false); 
                    ApexPages.currentPage().setCookies( new Cookie[]{WLACFQues});
                    Cookie WLACFQuestions = ApexPages.currentPage().getCookies().get(objCommSetup.Click_Page_Prefix__c+'ACFQues');
                    system.debug('@@@@@'+WLACFQuestions);
                    system.debug('objCommSetup.Click_Page_Prefix__c@@@@@'+objCommSetup.Click_Page_Prefix__c+'ACFQues');
                    map<string,string>mapQues = getMapQuesIDToSelectedAnswer(WLACFQuestions.getvalue());
                    system.debug('###Lokesh'+mapQues);
                }
                
            }
        }
        return null;   
    }
    
    public pageReference previousQuestion()
    {
        IsSlide = 'false';
        strmsg = '';
        if(lstWrapperQuestion.size()>1)
        { 
            if(indexNo > 0 && indexNo < lstWrapperQuestion.size())
            {
                --indexNo;
                lstWrapperQuestion[indexNo].IsContinueDisplay = true;
                strBubbleText = lstWrapperQuestion[indexNo].objWrapQuestion.acfBubble_Text__c;
                IsSlide = 'true';
            }
        }
        return null;
    }
    
    public map<string,string>getLeadApiNameToAnswerMap(string strAnswers)
    {
        map<string,string>mapLeadApiToAnswer = new map<string,string>();
        if(strAnswers <> null && strAnswers <> '')
        {
            for(string objLeadAnswers:strAnswers.split('-,-'))
            {
                List<string>lstLeadApiToAnswer = objLeadAnswers.split('-:-');
                if(lstLeadApiToAnswer.size()>=2) 
                mapLeadApiToAnswer.put(lstLeadApiToAnswer[0],lstLeadApiToAnswer[1]); 
            }
            return mapLeadApiToAnswer;
        }
        return null;    
    }
    
    public map<string,string>getMapQuesIDToSelectedAnswer(string strQues)
    {
        map<string,string>mapQuesIdToSelectedAnswer = new map<string,string>();
        if(strQues <> null && strQues <> '')
        {
            for(string objQues:strQues.split('-,-'))
            {
                List<string>lstQuesIdToSelectedAnswer = objQues.split('-:-');
                if(lstQuesIdToSelectedAnswer.size()>=2) 
                mapQuesIdToSelectedAnswer.put(lstQuesIdToSelectedAnswer [0],lstQuesIdToSelectedAnswer [1]); 
            }
            return mapQuesIdToSelectedAnswer;
        }
        return null;    
    }
    @RemoteAction
    public static List<acfBank_Detail__c> AutoCompleteBanklList(string strFilter)
    {   
        List<acfBank_Detail__c> lstBank = new List<acfBank_Detail__c>();
        If(strFilter!=null && strFilter <> '')
        {
            List<acfBank_Detail__c> lstBanktemp = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c,click_Show_on_Current_Lender_question__c from acfBank_Detail__c where click_Show_on_Current_Lender_question__c = true AND acfBank_Name__c like: strFilter+'%'];
            if(lstBanktemp != null && lstBanktemp.size() > 0)
                lstBank = lstBanktemp;
        }
        return lstBank;
    }
    
    public boolean IsValidId(string strId)
    {
        try
        {
            Id ValidId =  strId;
            return true;
        }
        catch(Exception Ex)
        {
            return false;
        }       
        return false;
    }
    Public pagereference resumePreviousSession()
    {
        isCookiesexist = false;
        if(lstWrapperQuestion.size()== (indexNo+1))
        {
            if(objCommSetup != null)
            {
                if(objCommSetup.Click_Page_Prefix__c != null)
                {
                    return new pageReference('/apex/'+objCommSetup.Click_Page_Prefix__c+'PreliminaryQuote');
                }
            }
        }
        return null;
    }
    Public pagereference clearCookies(){
        IsRedirect = true;
        if(objCommSetup != null)
        {
            Cookie ACFQues = new Cookie(objCommSetup.Click_Page_Prefix__c+'ACFQues',null,null,-1, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{ACFQues});
            
            Cookie LeadId = new Cookie('leadId',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{LeadId});
            
            isCookiesexist = false;
            string strHomePageURL = objCommSetup.click_Home_Page_URL__c;
            pagereference pageRef = new pagereference(strHomePageURL);
            return pageRef;
        }
        return null;
        // PageReference p = page.ClickHome;
        // p.setredirect(true);
        /*Cookie ACFQues1 = ApexPages.currentPage().getCookies().get('ACFQues');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
        
        system.debug('@@@@'+ACFQues1.getvalue());
        return Network.communitiesLanding();*/
        //return p;
    }
    
    public void initializeCookies()
    {
        string strType = Apexpages.CurrentPage().getParameters().get('type');
        if(strType != null)
        {
            boolean IsNewLoan = true;
            if(strType.ToLowerCase() == 'refi')
            IsNewLoan = false;
            
            if(!IsNewLoan)
            {
                Cookie Bname = new Cookie('Bname','',null,-1,true); 
                ApexPages.currentPage().setCookies( new Cookie[]{Bname});
                Cookie currentUId = ApexPages.currentPage().getCookies().get('Bname');
                Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','',null,-1,true);     
                ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
            }
            else
            {
                Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','true',null,72000,true);        
                ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
            }
        }
    }
}