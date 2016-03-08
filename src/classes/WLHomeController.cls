/***********************************************
                WHITE LABEL
************************************************/

public without sharing class WLHomeController
{
    public list<acfBank_Detail__c> lstbank {get;set;}   
    public list<acfContentManagementSystem__c> Refinance_loan_lst {get; set;}
    //Added By lokesh on 5-12-14
    public List<WrapperQuestions> lstWrapperQuestion{get;set;}
    public string strErrorMsg{get;set;}    
    public map<integer,integer> mapQuestionNo;  
    //Added by karthik 
    public map<string,clickHomeWrapper> mapSecNameToObjWrapper {get;set;}
    public map<string,list<acfContentManagementSystem__c>> mapsecNameTolstCMS{get;set;}
    public map<string,string> mapIdToImgURL {get;set;}
    public string strRefinanceImgUrl{get;set;}
    public string strBetterRatesImgUrl{get;set;}
    public string strTeamImgUrl {get;set;}
    public string strCMSId {get;set;}
    
    private string strNetworkId;
    private List<Click_Community_Setup__c> lstCommunity;
    
    /*
    *
    * ========== Constructor Method ================
    */
    public WLHomeController() 
    {
         strNetworkId = Network.getNetworkId();
  //     strNetworkId = '0DBN0000000CamK';
         System.debug('Sumit strNetworkId ::: ' + strNetworkId);
         lstCommunity = new List<Click_Community_Setup__c>();
         if(strNetworkId != null && strNetworkId != '')
         {
              lstCommunity = [select id,name,Click_Page_Prefix__c,Click_Network_ID__c,Click_URL__c,Community_User_Name_Prefix__c,Click_IsActive__c,Click_Support_Team_Name__c from Click_Community_Setup__c where Click_Network_ID__c = : strNetworkId AND Click_IsActive__c =: true limit 1];
         }
        
         Cookie Bname = new Cookie('Bname','',null,-1,true); 
         ApexPages.currentPage().setCookies( new Cookie[]{Bname});
         
         Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','',null,-1,true);    
                 ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
                 
         mapQuestionNo = new map<integer,integer>();
         mapIdToImgURL = new map<string,string>();
         lstbank = new list<acfBank_Detail__c>();        
         list<acfBank_Detail__c> lstallBank = new list<acfBank_Detail__c>();
         lstallBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c from acfBank_Detail__c]; 
         //supportObj = acfSupport__c.getValues('AcfSupportTeam');         
         //Added By lokesh on 5-12-14
         LandingQuestion();
         //Added by karthik
         mapSecNameToObjWrapper = new map<string,clickHomeWrapper>();
         mapsecNameTolstCMS = new map<string,list<acfContentManagementSystem__c>>();

         list<acfCMS_Page__c> lstCSMPage = [select id,name,acfDescription__c,acfHeading__c,acfImage_URL__c,
                                             (select id,acfDescription__c,acfShort_Description__c ,acfIs_Checked__c , acfHeading__c,  acfSequence__c, acfImageURL__c, acfMoreDetailURL__c, acfSectionName__c,acfDescriptionImageURL__c,Name FROM Content_Management_System__r where acfIs_Checked__c = true order by  acfSequence__c) 
                                             from acfCMS_Page__c where (name = 'ClickHome BetterRates' OR name like: 'ClickHome%') AND Click_Community_Setup__r.Click_Network_ID__c =: strNetworkId];
         
         system.debug('@@@karthik'+lstCSMPage);
         for(acfCMS_Page__c objCMSPage : lstCSMPage)
         {
            clickHomeWrapper objClickHomeWrapper = new clickHomeWrapper();
            if(objCMSPage.name == 'ClickHome BetterRates')
            {
                objClickHomeWrapper.strHeading = objCMSPage.acfHeading__c;
                objClickHomeWrapper.strDescription = objCMSPage.acfDescription__c;
                objClickHomeWrapper.strImageUrl = objCMSPage.acfImage_URL__c;
                mapSecNameToObjWrapper.put(objCMSPage.name,objClickHomeWrapper);
                if(objCMSPage.Content_Management_System__r != null && objCMSPage.Content_Management_System__r.size()>0)
                 mapsecNameTolstCMS.put(objCMSPage.name,objCMSPage.Content_Management_System__r);
            }
            if(objCMSPage.name == 'ClickHome Features')
            {
                objClickHomeWrapper.strHeading = objCMSPage.acfHeading__c;
                objClickHomeWrapper.strDescription = objCMSPage.acfDescription__c;
                objClickHomeWrapper.strImageUrl = objCMSPage.acfImage_URL__c;  
                mapSecNameToObjWrapper.put(objCMSPage.name,objClickHomeWrapper);
                if(objCMSPage.Content_Management_System__r != null && objCMSPage.Content_Management_System__r.size()>0)    
                    mapsecNameTolstCMS.put(objCMSPage.name,objCMSPage.Content_Management_System__r);        
            }
            if(objCMSPage.name == 'ClickHome Refinance')
            {
                objClickHomeWrapper.strHeading = objCMSPage.acfHeading__c;
                objClickHomeWrapper.strDescription = objCMSPage.acfDescription__c;
                objClickHomeWrapper.strImageUrl = objCMSPage.acfImage_URL__c;  
                mapSecNameToObjWrapper.put(objCMSPage.name,objClickHomeWrapper);
                if(objCMSPage.Content_Management_System__r != null && objCMSPage.Content_Management_System__r.size()>0)
                { 
                 system.debug('@@@@karthik'+objCMSPage.Content_Management_System__r);
                    mapsecNameTolstCMS.put(objCMSPage.name,objCMSPage.Content_Management_System__r);            
                }    
            }
            if(objCMSPage.name == 'ClickHome LoanSteps')
            {
                objClickHomeWrapper.strHeading = objCMSPage.acfHeading__c;
                objClickHomeWrapper.strDescription = objCMSPage.acfDescription__c;
                objClickHomeWrapper.strImageUrl = objCMSPage.acfImage_URL__c;  
                mapSecNameToObjWrapper.put(objCMSPage.name,objClickHomeWrapper);
                if(objCMSPage.Content_Management_System__r != null && objCMSPage.Content_Management_System__r.size()>0)
                {  
                    mapsecNameTolstCMS.put(objCMSPage.name,objCMSPage.Content_Management_System__r);  
                    strCMSId = objCMSPage.Content_Management_System__r[0].id;
                    for(acfContentManagementSystem__c objContentMngmt : objCMSPage.Content_Management_System__r)
                    {
                        mapIdToImgURL.put(objContentMngmt.id,objContentMngmt.acfDescriptionImageURL__c);
                    }
                }            
            }
            if(objCMSPage.name == 'ClickHome Team')
            {
                objClickHomeWrapper.strHeading = objCMSPage.acfHeading__c;
                objClickHomeWrapper.strDescription = objCMSPage.acfDescription__c;
                objClickHomeWrapper.strImageUrl = objCMSPage.acfImage_URL__c;  
                mapSecNameToObjWrapper.put(objCMSPage.name,objClickHomeWrapper);
                if(objCMSPage.Content_Management_System__r != null && objCMSPage.Content_Management_System__r.size()>0)  
                    mapsecNameTolstCMS.put(objCMSPage.name,objCMSPage.Content_Management_System__r);   
                system.debug('@@@@karthik'+mapsecNameTolstCMS);         
            }
            if(objCMSPage.name == 'ClickHomeRateInSeconds')
            {
                objClickHomeWrapper.strHeading = objCMSPage.acfHeading__c;
                objClickHomeWrapper.strDescription = objCMSPage.acfDescription__c;
                objClickHomeWrapper.strImageUrl = objCMSPage.acfImage_URL__c;  
                mapSecNameToObjWrapper.put(objCMSPage.name,objClickHomeWrapper);
                if(objCMSPage.Content_Management_System__r != null && objCMSPage.Content_Management_System__r.size()>0)  
                    mapsecNameTolstCMS.put(objCMSPage.name,objCMSPage.Content_Management_System__r);            
            }
            
         }
         list<document> lstDoc = [select name,body,contentType from document where name like:'%BG_Image'];
         system.debug('@@@@karthik'+lstDoc);
         if(lstDoc != null && lstDoc.size()>0)
         {
             string tempImgUrl = '/servlet/servlet.FileDownload?file=';
             for(document objDoc : lstDoc)
             {
                 if(objDoc.name == 'Refinance BG Image')
                 {                
                     strRefinanceImgUrl = tempImgUrl+objDoc.id;
                     system.debug('@@15'+strRefinanceImgUrl);
                 }
                 if(objDoc.name == 'Better Rates BG Image')
                 {
                     strBetterRatesImgUrl = tempImgUrl+objDoc.id;
                 }
                 if(objDoc.name == 'Team BG Image')
                 {
                     strTeamImgUrl = tempImgUrl+objDoc.id;
                 }
             }
             system.debug('@@12345'+strRefinanceImgUrl);
         }
      }
    //
    public pageReference RedirectLoggedInUser()
    {
        if (UserInfo.getName().tolowercase().contains('guest'))
                return null;
            else
            {
                return new pageReference('/'+lstCommunity[0].Click_Page_Prefix__c+'Dashboard');
            }
        return null;
    }   
    
   //Added by lokesh
    public pagereference getStarted()
    {
        strErrorMsg = '';
        system.debug('@@#$%%'+lstWrapperQuestion); 
        for(WrapperQuestions objWrapperQues:lstWrapperQuestion)
        { 
           if(objWrapperQues.strWrapAnswer <> null && objWrapperQues.strWrapAnswer <> 'NONE' && objWrapperQues.strWrapAnswer <> '' && objWrapperQues.strWrapAnswer <> 'Current Lender')
           {
                Cookie Bname = new Cookie('Bname',objWrapperQues.strWrapAnswer,null,72000, true); 
                ApexPages.currentPage().setCookies( new Cookie[]{Bname});
                Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','',null,-1,true);     
                                ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
                pagereference pageref = new pagereference('/apex/' + lstCommunity[0].Click_Page_Prefix__c+'PreloginQuestions');
                pageref.setredirect(true);
                return pageref;
           }
           else
           {
              strErrorMsg = 'Please fill the answer ';
              system.debug('Test'+strErrorMsg );
              return null;
           }    
        }
        return null;
    }
    
    public pagereference getStartedLast()
    {
        Cookie Bname = new Cookie('Bname','',null,-1,true); 
        ApexPages.currentPage().setCookies( new Cookie[]{Bname});
        Cookie currentUId = ApexPages.currentPage().getCookies().get('Bname');
        Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','false',null,-1,true);     
                ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
        system.debug('@@@@@'+currentUId);
        pagereference pageref = new pagereference('/apex/'+ lstCommunity[0].Click_Page_Prefix__c+ 'PreloginQuestions');
        pageref.setredirect(true);
        return pageref;
    }
    
    public pagereference newHomeLoan()
    {
      Cookie IsNewHomeLoan = new Cookie('IsNewHomeLoan','true',null,72000,true);        
      ApexPages.currentPage().setCookies( new Cookie[]{IsNewHomeLoan});
      pagereference pageref = new pagereference('/apex/'+ lstCommunity[0].Click_Page_Prefix__c+'PreloginQuestions');
      pageref.setredirect(true);
      return pageref;
    }
    
    // Added by lokesh on 5-12-2014 for displaying first question in a page.
    public class WrapperQuestions
    {
      public Question__c objWrapQuestion {get;set;}
      public string strWrapAnswer {get;set;}
      public List<SelectOption>lstSelectOpt {get;set;}
      public List<WrapperQuestions>lstRelatedQuestion {get;set;}
      public List<Answer__c>lstSelectOptions{get;set;}
      public List<string>lstCheckBoxAnswer{get;set;}
      public boolean IsContinueDisplay{get;set;}
    }
    
    public void LandingQuestion()
    {
        List<Script__c>lstScript = [select id,acf_Sequence_no__c,acf_Type__c from Script__c where acf_Type__c=:'Pre-Login' and Click_Community_Setup__r.Click_Network_ID__c =: strNetworkId order by acf_Sequence_no__c limit 1];
        system.debug('Test'+lstScript);
        lstWrapperQuestion = new List<WrapperQuestions>();
        if(lstScript <> null && lstScript.size()>0)
            {
                 for(Question__c objQuestion:[select id,acf_ApiName__c,acf_Description__c,acfWatermark_Text__c, acf_Current_lender__c,acf_Master_Question__c,acfRefinance_Sequence_No__c ,acf_Question__c,acf_Script__c,acf_Type__c,acf_Stage_Name__c,acf_Sequence_No__c, acf_Postal_Code__c,
                                       (select id,acf_Answer__c,acf_Question__c,acf_Related_Question__c from Answer__r) from Question__c
                                       where acf_Script__c =:lstScript[0].id and acf_Active__c = true and acfIs_refinance__c = true and acfRefinance_Sequence_No__c <> null order by acfRefinance_Sequence_No__c limit 1])  
                 {        
                            WrapperQuestions objMasterQuestion = new WrapperQuestions();                              
                            objMasterQuestion.lstSelectOpt = new List<SelectOption>();
                            objMasterQuestion.lstSelectOptions = new List<Answer__c>();
                            objMasterQuestion.objWrapQuestion = objQuestion;
                            objMasterQuestion.lstCheckBoxAnswer = new List<string>();
                            /*if(objQuestion.acf_Current_lender__c == true && objQuestion.acfWatermark_Text__c != null)
                                objMasterQuestion.strWrapAnswer = objQuestion.acfWatermark_Text__c;*/
                            for(Answer__c objAnswer:objQuestion.Answer__r)
                            {   
                                objMasterQuestion.lstSelectOptions.add(objAnswer);
                                objMasterQuestion.lstSelectOpt.add(new SelectOption((objAnswer.id),objAnswer.acf_Answer__c));
                            }
                            lstWrapperQuestion.add(objMasterQuestion); 
                 }
            }
            system.debug('@#$%'+lstWrapperQuestion);
    }
    
    @RemoteAction
    public static List<acfBank_Detail__c> AutoCompleteBanklList(string strFilter)
    {   If(strFilter!=null && strFilter <> ''){
        List<acfBank_Detail__c> lstBank = [select id,acfBank_Name__c,acfImage_URL__c,acfAttachmentId__c from acfBank_Detail__c where acfBank_Name__c like: strFilter+'%' OR acfBank_Short_Name__c like: strFilter+'%'];
        return lstBank;
        }
        else 
           return new List<acfBank_Detail__c>();
    }
    
    public class clickHomeWrapper
    {
        public string strHeading {get;set;}
        public string strDescription {get;set;}
        public string strImageUrl {get;set;}
    }
}