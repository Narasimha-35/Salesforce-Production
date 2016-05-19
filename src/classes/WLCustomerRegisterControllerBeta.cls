/*====================================================
                WHITE LABEL -- UAT SB
  An apex class that creates community user 
========================================================*/

public without sharing class WLCustomerRegisterControllerBeta 
{
    public String username {get; set;}
    public string mobile {get; set;}
    public String mobile_otp {get; set;}
    public string mobile_num {get; set;}
    public String password {get; set { password = value == null ? value : value.trim(); }}
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public Boolean mob_verify {get; set;}
    public Boolean mob_email_verify {get; set;}
    public Boolean showMsgPopup {get; set;}
    public Boolean showformVar {get;set;}
    Public Account objAccount;
    public Lead objLead;
    Public User usrObj;
    public string strMsg{get;set;}  
    public boolean isEmailVeriried{get;set;}
    Public String CurrentUserId;
    public user objUser{get;set;}
    public list<product2> pList {get;set;}
    public Map<id,List<decimal>> rateMap {get;set;}
    public List<WrapperProducts>lstWrapperProduct{get;set;}
    public string strProductLVRId{get;set;}
    public string strproductmsg{get;set;}
    public Id CurrentLeadId;
    Public boolean istermsConditionsConfirmed {get;set;}
    Public boolean showResendfrm {get;set;}
    public acfBank_Information__c  objbankinfo {get;set;}
    public string strTimezoneId {get;set;}
    public acfContentManagementSystem__c objRegHeaderCMS {get;set;}
    public map<string,acfContentManagementSystem__c> mapSectionToCMS;
    public string selectedProductId {get;set;}
    //Added by Lokesh
    public string userId;
    public String OTP_PIN;
    public set<string>setSelectedAnswerId;
    public string tempMobile;
    Public Click_Community_Setup__c lstCommunity;
    public map<string,string> maptst;
    public WLCustomerRegisterControllerBeta () 
    {
        lstCommunity = new Click_Community_Setup__c();
        Cookie Bname = new Cookie('Bname',null,null,72000, false); 
         setSelectedAnswerId = new set<string>();
         ApexPages.currentPage().setCookies( new Cookie[]{Bname});
         Cookie LeadId  = ApexPages.currentPage().getCookies().get('LeadId');
         Cookie strUserId = ApexPages.currentPage().getCookies().get('strUserId');
         strMsg ='';
         strproductmsg = '';
         CurrentUserId = '';
         strTimezoneId = '';
         tempMobile = '';
         showformVar = true;  
         isEmailVeriried = false; 
         mob_email_verify = true;        // true;
         mob_verify = false;             // false;
         showMsgPopup =  false;          // false;
         showResendfrm = false;
         istermsConditionsConfirmed = false;
         username = ''; 
         mobile = '';
         mobile_otp = '';
         rateMap  = new Map<id,List<decimal>>();
         mapSectionToCMS = new map<string,acfContentManagementSystem__c>();
         objRegHeaderCMS = new acfContentManagementSystem__c();
         usrObj = [select id,Email,username,contactId from User where id =: UserInfo.getUserId()];
         maptst = new map<string,string>();
         objUser = new User();
         
         string CommID =  Network.getNetworkId();
         if(CommID != null)
         {
              system.debug('=======Network ID======'+CommID);
              lstCommunity = ClickCommon.getCommunitySetup(CommID);
         }
        If(LeadId <> null && string.valueof(LeadId.getvalue()) != null && string.valueof(LeadId.getvalue()) <> '')
         {
             system.debug('lead id@@@'+LeadId.getvalue());
             List<Lead> List_lead = [select id,FirstName,LastName,acfIsMobileVerified__c,MobilePhone,acfOneTimePassword__c,Email,acf_partner_account__c 
                                     from lead 
                                     where id=: String.valueof(LeadId.getvalue())];
             system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+List_lead );                     
             If(List_lead !=null && List_lead.size()>0)
             {
                CurrentLeadId = List_lead[0].id;
                objLead = new Lead();
                objLead = List_lead[0];
                
                username = objLead.Email;
                
                          
                password = objLead.acfOneTimePassword__c; 
                system.debug('password'+password);
                
                objAccount = new Account(id=objLead.acf_partner_account__c);
                If(strUserId != null && string.valueof(strUserId.getvalue()) != null && string.valueof(strUserId.getvalue()) <> '')
                {
                      CurrentUserId = string.valueof(strUserId.getvalue()); 
                      system.debug('Created User Id'+ CurrentUserId);
                }
                 If(objLead.acfIsMobileVerified__c)
                 {
                   showformVar = false; 
                 }
                 else
                 {
                     objAccount = [select id, acfIsMobileVerified__c 
                                     from account 
                                     where id=:objLead.acf_partner_account__c];
                     
                     if(objLead.MobilePhone <>  null && objLead.MobilePhone != '')
                         mobile_num = objLead.MobilePhone.replace('+61','');
                     
                     showformVar = true;
                     mob_verify = true;           
                     mob_email_verify = false;
                  }
             }
              DisplayTop3Products(LeadId.getvalue(),lstCommunity.id);
         }
         //objbankinfo = acfBank_Information__c.getvalues('Top Products');
         List<acfContentManagementSystem__c> lstRegistrationHeader = new List<acfContentManagementSystem__c>();
         lstRegistrationHeader = [SELECT Id,acfDescription__c,acfHeading__c,acfSectionName__c,acfShort_Description__c,acfHeading_Caption__c FROM acfContentManagementSystem__c where (acfSectionName__c = 'Registration Popup' OR acfSectionName__c = 'OTP Popup' OR acfSectionName__c = 'Resend OTP Popup' OR acfSectionName__c = 'Preliminary Quote') AND Click_Community_Setup__c =: lstCommunity.id ];  
         if(lstRegistrationHeader.isEmpty() == false)
         {
             for(acfContentManagementSystem__c objCMS : lstRegistrationHeader)
             {
                    mapSectionToCMS.put(objCMS.acfSectionName__c,objCMS);
             }
         }
         objRegHeaderCMS = mapSectionToCMS.get('Registration Popup');
         if(mob_verify == true)
         {
                objRegHeaderCMS = mapSectionToCMS.get('OTP Popup');
                system.debug('@@@test'+objRegHeaderCMS);
         }
         if(showformVar == false)
         {
              objRegHeaderCMS = mapSectionToCMS.get('Preliminary Quote');
              system.debug('@@@test'+objRegHeaderCMS);
         }
    }
    /*
    *
    *  ======================= ShowResendOTP ================= // added by karthik on 29-01-2015
    */
     Public pagereference showResendOTPfrm(){
         strmsg = '';
         mobile_num = '';
         mob_verify = false;
         showResendfrm = true;
         objRegHeaderCMS = mapSectionToCMS.get('Resend OTP Popup');
         system.debug('@@@karthik'+objRegHeaderCMS+'===='+showResendfrm);
         return null;
     }
    /*
    *
    *  ======================= Login ================= 
    */
    public Pagereference Login() 
    {
      strproductmsg = '';
      system.debug('username'+username);
      system.debug('password'+password); 
          If(username != null && password != null)
          {
                  List<User>lstuser = [select id,profile.Name from user where id=:userinfo.getUserID() limit 1];
                  username = lstCommunity.Community_User_Name_Prefix__c == null ? username.trim() : lstCommunity.Community_User_Name_Prefix__c + username.trim();
                  if(lstuser <> null && lstuser.size()>0)
                  {
                      If(CurrentUserId != null && !lstuser[0].profile.Name.Contains('Community User'))
                      { 
                          string retPgName = ClickCommon.sendReturnUrl(CurrentUserId,false,'',Network.getNetworkId());
                          if(strTimezoneId != null && strTimezoneId <> '')
                          {
                            User objUser = new User(id=CurrentUserId);
                            objUser.TimeZoneSidKey = strTimezoneId;
                            update objUser;
                          }
                          system.debug('Username:::::'+username+'===='+password+'===='+retPgName+'===='+CurrentUserId); //acfID_Verification acfJumioIntegration
                          return Site.login(username,password,retPgName); 
                      }
                      else if(lstuser[0].profile.Name.Contains('Community User'))
                      {
                            string strUsrId = userinfo.getuserId();
                            string retPgName = ClickCommon.sendReturnUrl(strUsrId,false,'',Network.getNetworkId());
                            return new pagereference(retPgName);
                      }
                      
                  }        
          }
      return null;   
    }
    /*
    * =========== This method responsible for verify email id ==========
    *
    */    
    public void VerifyEmail(){
        isEmailVeriried = false;
        strmsg = '';
        if(username != '')    {
            if(!ClickCommon.isNullOrEmpty(username.trim()))    {                
                if(username.contains('@') && username.contains('.')){
                    if(IsUserAlreadyExist() == false){                        
                            if(ClickCommon.checkEmail(username.trim()))
                                isEmailVeriried = true;
                            else
                                strmsg = 'ACF_EmailValidationMsg';                                
                    }else{
                        strmsg = 'acfMailIdAlreadyRegister';
                    }        
                }else{
                     strmsg = 'acfMailCorrectFormat';
                }
            }else{
                strmsg = 'acfMailIDNotProvided';
            }
        }else{
            strmsg = 'acfMailIDNotProvided';
        }
    } 
    /*
    * This method responsible for creating community user
    */
    public pageReference Registration()
    {
        if(objUser.id == null)
        {
           // List<MortgageExpert__c> List_mExpert = MortgageExpert__c.getall().values(); 
           MortgageExpert__c List_mExpert;
           if(lstCommunity.Click_Page_Prefix__c != null)
               {
                   system.debug('====Page Prifix Value==='+lstCommunity.Click_Page_Prefix__c);
                   List_mExpert = MortgageExpert__c.getValues(lstCommunity.Click_Page_Prefix__c+'_David Hyman');
                   System.debug('mortgage Expert'+List_mExpert);
               }
           set<string>setSelectedAnswers = new set<string>();
            //set<string>setSelectedAnswerId = new set<string>();
            string leadRecordTypeId = ''; 
           
            Cookie IsNewHomeLoan = ApexPages.currentPage().getCookies().get('IsNewHomeLoan');
            Schema.DescribeSObjectResult leadRT = Schema.SObjectType.Lead;
            Map<String,Schema.RecordTypeInfo> rtCick_Refi = leadRT.getRecordTypeInfosByName();
            if(IsNewHomeLoan <> null && IsNewHomeLoan.getvalue() == 'true')
            {
                if(lstCommunity.Click_Page_Prefix__c != null)
                    {
                        Schema.RecordTypeInfo rtLead =  rtCick_Refi.get(lstCommunity.Click_Page_Prefix__c+' New Loans');
                        system.debug('@@@click refi lead record type@@ =========== '+rtLead); 
                        leadRecordTypeId = rtLead.getRecordTypeId();
                    }
            }
            else
            {
                    if(lstCommunity.Click_Page_Prefix__c != null)
                        {
                            Schema.RecordTypeInfo rt_Lead =  rtCick_Refi.get(lstCommunity.Click_Page_Prefix__c+' Refi');
                            system.debug('@@@click refi lead record type@@ =========== '+rt_Lead); 
                            leadRecordTypeId = rt_Lead.getRecordTypeId();
                        }
            }
            try{
                if((!ClickCommon.isNullOrEmpty(username.trim()))&&(!ClickCommon.isNullOrEmpty(mobile))){
                    if(IsUserAlreadyExist() == false){
                        if(isEmailVeriried){
                            if(mobile.contains('+61')==false && mobile != null && mobile <> '' && mobile != 'Mobile Number'){
                                tempMobile = mobile;
                                if(mobile.substring(0,1) == '0'){
                                    tempMobile = '+61'+mobile.substring(1,mobile.length());
                                }else{
                                    tempMobile = '+61'+mobile;
                                }
                                //For Lead Api To Answers.
                                Cookie currentUId = ApexPages.currentPage().getCookies().get('ACFAnswers');
                                system.debug('currentUId'+currentUId);
                                maptst = ClickCommon.getLeadApiNameToAnswerMap(currentUId.getvalue());
                                //For Lead Api To Data Type
                                Cookie currentLeadApiNames = ApexPages.currentPage().getCookies().get('ACFLeadApiNames');
                                system.debug('currentUId'+currentLeadApiNames);
                                map<string,string> maptLeadApiToType = ClickCommon.getLeadApiNameToType(currentLeadApiNames.getvalue());
                                system.debug('Map_karthik'+maptLeadApiToType);
                                objLead = new Lead();
                                objLead.FirstName = tempMobile.trim();//username.substring(0,5);
                                objLead.LastName = tempMobile.trim();//username.substring(0,5);
                                objLead.Email = username.trim(); 
                                objLead.MobilePhone = tempMobile;
                                List<Lead> lstLead;
                                    objLead.Community__c = lstCommunity.id;
                                    lstLead = [select id,firstname,lastname,acfIsCreatedViaRequestCall__c,acfIs_User_Registered__c from lead where Email =:username.trim() AND Community__c =: lstCommunity.id ];
                                
                                If(lstLead != null && lstLead.size()>0){ 
                                    If(lstLead[0].acfIs_User_Registered__c == false){
                                        objLead = new Lead(id=lstLead[0].id,lastname=lstLead[0].lastname,firstname=lstLead[0].firstname);
                                    }
                                }
                                
                                if(maptst <> null && maptLeadApiToType <> null)
                                { 
                                    for(string qvar : maptst.keyset())
                                    {
                                        if(maptst.get(qvar) <> null && maptLeadApiToType.get(qvar)<> null) 
                                        {
                                            system.debug('dsfghj'+maptLeadApiToType.get(qvar)+'erdgfh'+qvar);
                                            if(maptLeadApiToType.get(qvar)=='Number' || maptLeadApiToType.get(qvar)=='Currency' || maptLeadApiToType.get(qvar)=='Percent')
                                              objLead.put(qvar,decimal.valueof(maptst.get(qvar))); 
                                            else
                                              objLead.put(qvar,maptst.get(qvar));  
                                        }  
                                    }
                                    system.debug('objLead***'+objLead);
                                    if(leadRecordTypeId != null && leadRecordTypeId <> '')
                                        objLead.RecordTypeId = leadRecordTypeId;
                                    objLead.Status = 'Open';
                                    objLead.acfBankdetailStatus__c = 'Pending';
                                    objLead.clickJumio_Status__c = 'Pending';
                                    objLead.acfIs_User_Registered__c = true;
                                    
                                                               //assign utm cookies value to lead fields - vipin
                                    Cookie utmSource = ApexPages.currentPage().getCookies().get('utm_source');
                                    if(utmSource != null)
                                    {
                                        String strUtmSource=utmSource.getvalue();
                                        objLead.utm_source__c=strUtmSource;
                                    }
                                    
                                    Cookie utmMedium = ApexPages.currentPage().getCookies().get('utm_medium');
                                    if(utmMedium != null)
                                    {
                                        String strUtmMedium=utmMedium.getvalue();
                                        objLead.utm_medium__c=strUtmMedium;
                                    }
                                    
                 
                                    Cookie utmTerm = ApexPages.currentPage().getCookies().get('utm_term');
                                    if(utmTerm != null)
                                    {
                                        String strUtmTerm=utmTerm.getvalue();
                                        objLead.utm_term__c=strUtmTerm;
                                    }
                                    
                                    Cookie utmContent = ApexPages.currentPage().getCookies().get('utm_content');
                                    if(utmContent != null)
                                    {
                                        String strUtmContent=utmContent.getvalue();
                                        objLead.utm_content__c=strUtmContent;
                                    }
                                    Cookie utmCampaign = ApexPages.currentPage().getCookies().get('utm_campaign');
                                    if(utmCampaign != null)
                                    {
                                        String strUtmCampaign=utmCampaign.getvalue();
                                        objLead.utm_campaign__c=strUtmCampaign;
                                    } 
                                    
                                    //If(!List_mExpert.isEmpty()){ objLead.ownerId = List_mExpert[0].User_ID__c;} //'005900000035uLJ'; 
                                    AssignmentRule AR = new AssignmentRule();
                                    AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
                                    if(AR <> null)
                                    {
                                        Database.DMLOptions dmlOpts = new Database.DMLOptions();
                                        dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
                                        objLead.setOptions(dmlOpts);
                                    }  
                                    If(lstLead != null && lstLead.size()>0){
                                        If(lstLead[0].acfIs_User_Registered__c == false && objLead != null){
                                            Update objLead;
                                        }
                                    }else If(objLead != null) insert objLead; 
                                    //For Generating Required Docs For Jumio and Bank Stmt.
                                     generateReqDocs(objLead.Id,lstCommunity);  
                                }        
                                System.debug('objLead================'+objLead);
                                system.debug('List_mExpert***'+List_mExpert);
                                    
                               // If(!List_mExpert.isEmpty())
                               // {
                                string CommunityProfileName = 'Community User';
                                if(lstCommunity.Community_User_Name_Prefix__c != null)
                                {
                                    CommunityProfileName = 'Community User '+lstCommunity.Click_Page_Prefix__c;  
                                }                                    
                                        List<Profile> lstCommUserProfile = [select id,name from profile where name=: CommunityProfileName limit 1];
                                        system.debug('lstCommUserProfile' +lstCommUserProfile);
                                        if(lstCommUserProfile.isEmpty() == false)
                                        {
                                            objUser = new User();
                                            objUser.FirstName = objLead.firstName;
                                            objUser.LastName = objLead.LastName;
                                            objUser.MobilePhone = tempMobile;
                                            
                                            objUser.Username = lstCommunity.Community_User_Name_Prefix__c == null ? username.trim() : lstCommunity.Community_User_Name_Prefix__c + username.trim();
                                            objUser.Email = username.trim();
                                            objUser.ProfileId = lstCommUserProfile[0].id;
                                            objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
                                            objUser.TimeZoneSidKey = 'Australia/Brisbane';  
                                            OTP_PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
                                            password = OTP_PIN;
                                            String OwnerId = List_mExpert.User_ID__c;  //'005900000035uLJ'; 
                                            userId = Site.createPersonAccountPortalUser(objUser,OwnerId,OTP_PIN);
                                            system.debug('objUser =============== '+objUser);
                                            system.debug('OwnerId =============== '+OwnerId);
                                            system.debug('OTP_PIN =============== '+OTP_PIN);
                                            system.debug('userID =============== '+userId);
                                          }
                                     
                                    /*if (userId != null ) 
                                    {
                                       CurrentUserId = userId;
                                       system.debug('ONE TIME Password ===================== '+OTP_PIN);
                                       
                                       // ===================== call SendSMS for sending msg ==================================
                                      // string response = ClickCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, '+'+objLead.MobilePhone, 'Dear user, Your OTP is: '+OTP_PIN+' Thanks, Team ACF', true) ;//This will also be your first time password to log into ACF portal
                                       String strOTPmsg = System.Label.acfOTP_Text;
                                       strOTPmsg = strOTPmsg.replace('<OTP>',OTP_PIN);
                                       system.debug('@@@otp test message'+strOTPmsg);
                                       ClickCommon.SendSMSUsingFuture(objLead.FirstName +' '+objLead.lastName, objLead.MobilePhone, strOTPmsg, true) ;//This will also be your first time password to log into ACF portal
                                       string response = 'success';  
                                       
                                       system.debug('respone ======================= '+response);
                                       if(response <> null && response <> '' && response.contains('success'))
                                       {
                                           system.debug('respone in ======================= '+response);
                                           User usrObj = [select id,accountId,contactId from user where id=:userId];
                                           Id currentAccountRecordTypeId = ClickCommon.GetRecordTypeId('Account','Click Refi');
                                           objAccount = new Account(id = usrObj.accountId);
                                          // objAccount = [select id,  from account where id=:usrObj.accountId];
                                           objLead.acf_Contact__c = [select id from contact where accountId =: ObjAccount.id].id;
                                           objLead.acf_partner_account__c = objAccount.Id;
                                           objLead.acfOneTimePassword__c = OTP_PIN;
                                           ObjAccount.PersonMobilePhone = mobile;
                                           ObjAccount.acfPassword__c = OTP_PIN;
                                           objAccount.acf_Lead__pc = objLead.id;
                                           objAccount.RecordTypeId = currentAccountRecordTypeId;
                                           update ObjAccount; 
                                           update objLead;
                                           PageReference chngpass = Site.changePassword(OTP_PIN,OTP_PIN,password);
                                           system.debug('chngpass ======================= '+chngpass);
                                           if(objLead.MobilePhone <>  null){
                                               mobile_num = objLead.MobilePhone.replace('+61','');
                                           }
                                           
                                           mob_verify = true;           // open popup box for taking otp
                                           mob_email_verify = false;    // close popup box for email and mobile    
                                           objRegHeaderCMS = mapSectionToCMS.get('OTP Popup');                                                     
                                       }else{
                                           strmsg = response;
                                           objRegHeaderCMS = mapSectionToCMS.get('OTP Popup');
                                           mob_verify = true;
                                           mob_email_verify = false;
                                       }
                                       //Added by Lokesh on 6-12-2014 to
                                       //Add Required Documents based on Answers
                                       Cookie requiredDocumentAnswers = ApexPages.currentPage().getCookies().get('ACFRA');
                                       system.debug('::::LOKESH:::::'+requiredDocumentAnswers.getValue());
                                       if(requiredDocumentAnswers <> null && requiredDocumentAnswers.getValue() <> '')
                                       {
                                           for(string strAnswers:requiredDocumentAnswers.getValue().split('--,--'))
                                           {
                                               setSelectedAnswerId.add(strAnswers);
                                           }
                                       }
                                       system.debug('::::LOKESH:::::'+setSelectedAnswerId);
                                       if(setSelectedAnswerId.size()>0)
                                       {
                                          // Method used to get Required Document Based on Answers.
                                          ClickCommon.getRequiredDocumentsFromAnswers(objLead.id,setSelectedAnswerId);
                                          //Method used to getSuggestedProducts Based on Answers.
                                          ClickCommon.getSuggestedProductsFromAnswers(objLead.id,setSelectedAnswerId);
                                       } 
                                       
                                        if(IsNewHomeLoan <> null && IsNewHomeLoan.getvalue() == 'true')
                                        {
                                        system.debug('@@isNew Home loan');
                                        }else
                                           {
                                            Asset_Liability_Statement__c objAssetsLiab = new Asset_Liability_Statement__c();
                                            if(objLead.acfApproximately_how_much_is_your_house__c != null)
                                                objAssetsLiab.Home_Value_Amount__c = objLead.acfApproximately_how_much_is_your_house__c;
                                            if(objLead.acfLoan_Amount__c != null)
                                                objAssetsLiab.Mortgage_on_Home_Amount__c = objLead.acfLoan_Amount__c;
                                            objAssetsLiab.acfIsCreatedByPortalUser__c = true;
                                            objAssetsLiab.AL_Statement_Owner__c = ObjAccount.Id;
                                            insert objAssetsLiab;
                                            system.debug('karthik@@@'+objAssetsLiab);
                                           }  
                                       
                                       Cookie LeadId = new Cookie('leadId',objLead.Id,null,72000,false);
                                       ApexPages.currentPage().setCookies(new Cookie[]{LeadId});
                                       Cookie strUserId = new Cookie('strUserId',userId,null,72000,false);
                                       ApexPages.currentPage().setCookies(new Cookie[]{strUserId});
                                    } 
                                    else{
                                       system.debug('userID false  ================ '+userID);
                                        //strmsg = 'Click_Exception_Message';
                                      // delete objAccount;
                                       delete objLead;
                                    }*/
                              /* } else{
                                   strmsg = 'OwnerId should not be null';
                                  }  */
                            
                        }else{
                            strmsg = 'ACF_MobileNoValidation';
                        }                    
                      }else {
                             strmsg = 'ACF_EmailValidationMsg';
                           } 
                   }else {
                            strmsg = 'ACF_Existing_User_Validation'; 
                         }
                 }else {
                            strmsg = 'ACF_MobileNo_EmailID_ShouldNot_Null'; 
                       }
                }catch(Exception Ex) {
                   system.debug('Exception==========='+Ex.getmessage());
               }               
        }  
        else
        {
           String OTP_PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
           system.debug('ONE TIME Password ===================== '+OTP_PIN);
           // ===================== call SendSMS for sending msg ==================================
           
           String strOTPtxt;
           if(lstCommunity.Click_Page_Prefix__c != null)
            {
                   string OTPLabelName = lstCommunity.Click_Page_Prefix__c +'OTP_Text' ;
                   Component.Apex.OutputText output = new Component.Apex.OutputText();
                   output.expressions.value = '{!$Label.' + OTPLabelName + '}';
                   strOTPtxt = String.valueOf(output.value);
                   system.debug('======strOTPtxt =========='+strOTPtxt); 
                   
            }
           strOTPtxt = strOTPtxt.replace('<OTP>',OTP_PIN);
           system.debug('@@@otp test message'+strOTPtxt);
           string response = ClickCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, objLead.MobilePhone, strOTPtxt, true) ;
           system.debug('respone ======================= '+response);
           if(response <> null && response <> '' && response.contains('success'))
           {
               system.debug('respone in ======================= '+response);
               objLead.acf_Contact__c =  [select id from contact where accountId =: ObjAccount.id].id;
               objLead.acfOneTimePassword__c = OTP_PIN;
               ObjAccount.acfPassword__c = OTP_PIN;
               update ObjAccount; 
               update objLead;
               //PageReference chngpass = Site.changePassword(OTP_PIN,OTP_PIN,password);
               //system.debug('chngpass ======================= '+chngpass);
               if(objLead.MobilePhone <>  null && objLead.MobilePhone != ''){
                    mobile_num = objLead.MobilePhone.replace('+61','');
               }
               
               mob_verify = true;           // open popup box for taking otp
               mob_email_verify = false;    // close popup box for email and mobile  
                                                                      
           }
         
        }      
        return null;
    }
    
    /*
    **  this method responsible for verify OTP
    */    
    public PageReference verifyOTP()
    {
        
        strmsg = '';    
        system.debug('mobile_otp'+mobile_otp);    
        system.debug('objLead.acfOneTimePassword__c'+objLead.acfOneTimePassword__c);
        if(mobile_otp != null && objLead.acfOneTimePassword__c == mobile_otp){
          If(istermsConditionsConfirmed == true){        
            objLead.acfIsMobileVerified__c = true;            
             ObjAccount.acfIsMobileVerified__c = true;
             update ObjAccount;
             update objLead;
             DisplayTop3Products(objLead.id,lstCommunity.id);
             showformVar = false;    // close the popup box
             objRegHeaderCMS = mapSectionToCMS.get('Preliminary Quote');
           }else{
               strmsg = 'acftermsConditionsValidation';
           }  
                         
        }else{
            strmsg = 'acfOTPNotMatch';
        }
        return null;
    }
    
    /*
    **  This method responsible for resend OTP
    **
    */
    public PageReference resendOTP(){
        strmsg = '';
        
        //mobile_otp = 'OTP';
        If(mobile_num.contains('+61') == false && mobile_num != null && mobile_num <> '' && mobile_num != 'Mobile No.'){
                String OTP_PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
                //PageReference chngpass = Site.changePassword(OTP_PIN,OTP_PIN,objLead.acfOneTimePassword__c)
                if(mobile_num.substring(0,1) == '0')
                {
                    objLead.MobilePhone = '+61'+mobile_num.substring(1,mobile_num.length());
                }else{
                    objLead.MobilePhone = '+61'+mobile_num;
                }
               
                objLead.acfOneTimePassword__c = OTP_PIN;
                  ObjAccount.acfPassword__c = OTP_PIN;
                  ObjAccount.PersonMobilePhone = objLead.MobilePhone;
                // ===================== call SendSMS for sending msg ==================================
                String strOTPtxt = System.Label.acfOTP_Text;
                strOTPtxt = strOTPtxt.replace('<OTP>',OTP_PIN);
                system.debug('@@@otp test message'+strOTPtxt);
                string response = ClickCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, objLead.MobilePhone, strOTPtxt, true) ;
                // For Testing
                //string response = ClickCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, objLead.MobilePhone, strOTPtxt, false) ;
                if(response <> null && response <> '' && response.contains('success'))
                {
                  // PageReference chngpass = Site.changePassword(OTP_PIN,OTP_PIN,password);
                  // system.debug('chngpass ======================= '+chngpass);
                   system.setpassword(currentuserid,OTP_PIN); //added by karthik on 29-01-2015
                   password = OTP_PIN;
                    update ObjAccount;
                    update objLead;
                    showMsgPopup =  true;
                   // mob_verify = false; 
                    showResendfrm = false;               
                }else{
                    strmsg = response;
                }
        }else{
           strmsg = 'ACF_MobileNoValidation';
         }
        return null;
    }
    
    /*
    **  This method responsible for closing msg popup
    **
    */
    public PageReference OK()
    {
        showMsgPopup =  false;
        mob_verify = true;
        objRegHeaderCMS = mapSectionToCMS.get('OTP Popup');
        strmsg = '';        
        return null;
    } 
    /*
    ** This method responsible for generating required documents on Lead
    */
    Public static void generateReqDocs(String WLLeadId,Click_Community_Setup__c CommSetup)
    {
        List<Document_Master__c> List_DocMaster = [select id,Name,acfActive__c,acfDescription__c,acf_Source__c,Click_Community_Setup__c from Document_Master__c where acfActive__c=true AND Click_Community_Setup__c =: CommSetup.id ];
        List<Required_Document__c> List_reqDocs = new List<Required_Document__c>();
        If(!List_DocMaster.isEmpty())
        {
            for(Document_Master__c objDoc : List_DocMaster)
            {
                If(objDoc.acf_Source__c == 'Jumio' || (objDoc.acf_Source__c == 'Bank Statement'))
                {
                    Required_Document__c objReqDoc = new Required_Document__c();
                    objReqDoc.Name = objDoc.Name;
                    objReqDoc.Lead__c = WLLeadId;
                    objReqDoc.acfDocument_Master__c = objDoc.id;
                    if(objDoc.acf_Source__c == 'Jumio')
                      objReqDoc.acf_Is_Identity_Verification_Doc__c = true;
                    else if(objDoc.acf_Source__c == 'Bank Statement')
                       objReqDoc.acf_Bank_Statement_Doc__c = true;  
                    List_reqDocs.add(objReqDoc);
                }
            }
        }
        If(!List_reqDocs.isEmpty())
        {
            insert List_reqDocs;
        }
    }
    /*
    **  This method responsible for Redirect To Landing Page
    **
    */
    Public PageReference RedirectToLandingPage() 
    {
        return null;
           //PageReference p = page.ClickHome;
           //p.setredirect(true);
           //return p;
           return Network.communitiesLanding();
    }
    
    Public PageReference redirect() 
    {      
        Cookie currentUId = ApexPages.currentPage().getCookies().get('ACFAnswers');
        If(currentUId != null){
            return null;
        } else{
              // PageReference p = page.ClickHome;
              // p.setredirect(true);
              // return p;
            string strHomePageURL = lstCommunity.click_Home_Page_URL__c;
            if(strHomePageURL != null && strHomePageURL <> '')
            {
                pagereference pageRef = new pagereference(strHomePageURL);
                return pageRef;
            }
        }
        return null;
    }
    
    /*
    **  this method responsible for checks whether user already exist or not    
    */
    public boolean IsUserAlreadyExist() 
    { 
             List<User> lstUser;
             if(lstCommunity.Community_User_Name_Prefix__c != null)
             {
                 lstUser = [select id,Username,Email from User where Username =: lstCommunity.Community_User_Name_Prefix__c+username.trim()];
             }
             else
             {
                 lstUser = [select id,Username,Email from User where Username =: username.trim()];
             }
             
             if(lstCommunity.id != null)
             {
                 List<Lead> lstLead = [select id,Email,acfIs_User_Registered__c,Community__c from Lead where Email =: username.trim() AND Community__c =: lstCommunity.id ];
                 system.debug('lstuser'+lstuser);
                 if((lstUser != null && lstUser.size()>0) || (lstLead != null && lstLead.size()>0 && lstLead[0].acfIs_User_Registered__c == true))
                 {
                   return true;
                 }
             }
        return false;
    }
    
    //Added by lokesh on 17-12-14 to display Top 3 Products.
    public pageReference DisplayTop3Products(Id WLLeadId,Id CommunityID)
    {
        List<LVR_Rate__c> lstProductIdToLVR = new list<LVR_Rate__c>();
        lstWrapperProduct = new List<WrapperProducts>();
        Cookie currentLeadId  = ApexPages.currentPage().getCookies().get('LeadId'); 
        if(currentLeadId != null)
        {
            List<Lead> lstLead = [select id,acfLoan_Amount__c,acfCurrentRate__c,acfWhat_is_your_current_payment_type__c,acfApproximately_how_much_is_your_house__c, Recordtype.Name 
                                  from lead 
                                  where id=: currentLeadId.getValue()];                
            if(lstLead != null && lstLead.size()>0)
            {
                Lead objLead = lstLead[0];
                double usrLVR = 0;
                map<string,LVR_Rate__c>mapProductIdToLVR = new map<string,LVR_Rate__c>();
                set<string>setProductIdToExclude = new set<string>();
                
                for(acfSuggested_Product__c objSuggestedProduct:[select id,acfFilter__c,acfProduct__c,acfProduct_Family__c,acfLead__c from acfSuggested_Product__c where acfLead__c=:WLLeadId])
                {
                    if(objSuggestedProduct.acfFilter__c <> null && objSuggestedProduct.acfProduct__c <> null && objSuggestedProduct.acfFilter__c == 'Exclude')
                    {
                        setProductIdToExclude.add(objSuggestedProduct.acfProduct__c);
                    } 
                }
        
                if(objLead.acfLoan_Amount__c != null && objLead.acfApproximately_how_much_is_your_house__c != null)
                    usrLVR = (objLead.acfLoan_Amount__c/objLead.acfApproximately_how_much_is_your_house__c)*100;
                    
                decimal decVariableRate = 0;
                decimal decFixedRate = 0;
                list<LVR_Rate__c> lstFixedLoans = new list<LVR_Rate__c>();
                list<LVR_Rate__c> lstBasicVariableLoans = new list<LVR_Rate__c>();
                list<LVR_Rate__c> lstOffsetVariableLoans = new list<LVR_Rate__c>();
                
                boolean isFixed1YrCompleted = false;
                boolean isFixed2YrCompleted = false;
                boolean isFixed3yrCompleted = false;
                boolean isFixed4yrCompleted = false;
                boolean isFixed5yrCompleted = false;
                
                set<id> setOfBankDetailId = new set<id>();
                List<Click_Loans_Bank__c> lstbank = new List<Click_Loans_Bank__c>();
                if(CommunityID <> null)
                {
                    lstbank = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:CommunityID];
                }
                system.debug('@@testbank'+lstbank+'@@@'+CommunityID);
                if(lstbank.size() > 0 && lstbank != null)
                {
                    for(Click_Loans_Bank__c objbank : lstbank)
                    {
                            setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
                            system.debug('@@test'+objbank.Click_Loans_Bank_Detail__c);
                    }
                }
                
                if(setOfBankDetailId != null)
                {
                    for(LVR_Rate__c objLVR:[select id,acfLVR__c,acfRate__c,acfProduct__r.acfType__c,acfProduct__r.IsActive,acfProduct__r.Recordtype.Name,acfProduct__c,acfLoan_Size__c,ACF_Comparison_Rate__c,
                                            clickFixed_Interest_Rate__c,clickLoan_Size_From__c,clickLVR_From__c,acfProduct__r.acfTenure_in_Years__c,acfApplication_Fee__c,
                                            acfProduct__r.acfvarTenure_In_Years__c,acfProduct__r.name,acfTerm_in_Years__c,acfProduct__r.acfOffset_Account__c,acfProduct__r.Click_Loans_Bank_Detail__r.acfImage_URL__c 
                                            from LVR_Rate__c 
                                            where clickLoan_Size_From__c <: objLead.acfLoan_Amount__c 
                                            and acfLoan_Size__c >=:objLead.acfLoan_Amount__c 
                                            and clickLVR_From__c <: usrLVR 
                                            and acfLVR__c>=:usrLVR  
                                            and acfProduct__r.Click_Loans_Bank_Detail__c IN: setOfBankDetailId 
                                            and acfProduct__r.IsActive = true                                          
                                            order by acfTerm_in_Years__c,acfRate__c,clickFixed_Interest_Rate__c asc])
                                            
                    {
                            system.debug('DisplayTop3Products ::: objLVR '+ objLVR);
                            //for exclude and include filters
                            if(setProductIdToExclude <> null && setProductIdToExclude.size()>0 && setProductIdToExclude.contains(objLVR.acfProduct__c))
                            {
                                continue;
                            } 
                                      
                            If(objLVR.acfProduct__r.Recordtype.Name == 'Variable' && objLVR.acfProduct__r.acfOffset_Account__c == false)
                            {
                               lstBasicVariableLoans.add(objLVR); 
                            }
                            if(objLVR.acfProduct__r.Recordtype.Name == 'Variable' && objLVR.acfProduct__r.acfOffset_Account__c == true)                      
                            {
                                lstOffsetVariableLoans.add(objLVR);
                            }         
                            if(objLVR.acfProduct__r.Recordtype.Name == 'Fixed')
                            {
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '1' && isFixed1YrCompleted == false)
                               {
                                lstFixedLoans.add(objLVR);
                                isFixed1YrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '2' && isFixed2YrCompleted == false)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed2YrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '3' && isFixed3yrCompleted == false)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed3yrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '4' && isFixed4yrCompleted == false && lstFixedLoans.size()<3)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed4yrCompleted = true;
                               }
                               if(objLVR.acfProduct__r.acfTenure_in_Years__c == '5' && isFixed5yrCompleted == false && lstFixedLoans.size()<3)
                               {
                                   lstFixedLoans.add(objLVR);
                                   isFixed5yrCompleted = true;
                               }
                            }
                           
                           // lstProductIdToLVR.add(objLVR);           
                     } 
                }
                 if(lstBasicVariableLoans != null && lstBasicVariableLoans.size()>0)
                 {
                     lstProductIdToLVR.add(lstBasicVariableLoans[0]);
                 }
                 if(lstOffsetVariableLoans != null && lstOffsetVariableLoans.size()>0)
                 {
                     lstProductIdToLVR.add(lstOffsetVariableLoans[0]);
                 }
                 if(lstFixedLoans != null && lstFixedLoans.size()>0)
                 {
                     lstProductIdToLVR.addall(lstFixedLoans);
                 }
               
                 system.debug('@@@test1223'+lstProductIdToLVR);
                if(lstProductIdToLVR <> null && lstProductIdToLVR.size()>0)
                {
                    Integer IndexCount = 0;
                    for(LVR_Rate__c objLVRRate: lstProductIdToLVR)
                    {
                               
                        WrapperProducts objWrapVariableProduct = new WrapperProducts();
                        objWrapVariableProduct.decRate = objLVRRate.acfRate__c;
                        objWrapVariableProduct.decComparisionRate = objLVRRate.ACF_Comparison_Rate__c;
                        objWrapVariableProduct.decApplicationFee = objLVRRate.acfApplication_Fee__c;
                        objWrapVariableProduct.strcomparisionType = '';
                        objWrapVariableProduct.ProductId   =  objLVRRate.acfProduct__c;      
                        objWrapVariableProduct.ProdLVRID   =  objLVRRate.id; 
                        objWrapVariableProduct.strProdName =  objLVRRate.acfProduct__r.name;                                 
                        objWrapVariableProduct.decMonthlyPayment   = 0;
                        objWrapVariableProduct.strBnkImgURL = system.label.site_URL+objLVRRate.acfProduct__r.Click_Loans_Bank_Detail__r.acfImage_URL__c;
                         acfLoanDashboardController objLoanDashboardController = new acfLoanDashboardController();
                             //objWrapVariableProduct.EstimatedMonthlySaving = objLoanDashboardController.DisplayEstimatedSaving(lstLead[0].acfCurrentRate__c,objLVRRate.acfRate__c,lstLead[0].acfLoan_Amount__c,lstLead[0].acfWhat_is_your_current_payment_type__c,objLVRRate.acfProduct__r.acfvarTenure_In_Years__c);
                              Integer intTenureMonths = 0;
                              decimal decMonthlySavings = 0;
                              acfLoanDashboardController objLoanDashboard = new acfLoanDashboardController();
                              If(objLVRRate.acfProduct__r.Recordtype.Name == 'Fixed')
                              {
                                  objWrapVariableProduct.decRate = objLVRRate.clickFixed_Interest_Rate__c;
                                  objWrapVariableProduct.strRateType = 'Fixed '+objLVRRate.acfProduct__r.acfTenure_in_Years__c+' Yr';
                                  //system.debug('monthly payment calc@@@@'+objLead.acfLoan_Amount__c+'@@@'+objLVRRate.acfRate__c+'@@@'+objLead.acfWhat_is_your_current_payment_type__c+'@@@'+objLVRRate.acfProduct__r.acfTenure_in_Years__c);
                                 if(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null)
                                  objWrapVariableProduct.intTenureYrs = integer.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c);
                                 
                                    if(objLVRRate.clickFixed_Interest_Rate__c != null && objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null && objLead.acfLoan_Amount__c != null && objLead.acfWhat_is_your_current_payment_type__c != null )
                                    {
                                      objWrapVariableProduct.decMonthlyPayment = integer.valueof(ClickCommon.calculateMonthlyPayment(objLead.acfLoan_Amount__c,double.valueof(objLVRRate.clickFixed_Interest_Rate__c),objLead.acfWhat_is_your_current_payment_type__c,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)));
                                     if(objLead.acfCurrentRate__c != null)
                                      decMonthlySavings = DisplayEstimatedSaving(objLead.acfCurrentRate__c,double.valueof(objLVRRate.clickFixed_Interest_Rate__c),objLead.acfLoan_Amount__c,objLead.acfWhat_is_your_current_payment_type__c,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c));
                                    }
                                    
                                  system.debug('monthly payment result@@@'+objWrapVariableProduct.decMonthlyPayment); 
                                  if(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null)
                                   intTenureMonths  = integer.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c) * 12;
                              } else{
                                        if(objLVRRate.acfProduct__r.acfOffset_Account__c == true)
                                        {
                                            objWrapVariableProduct.strRateType = 'Offset';
                                        }else{
                                                objWrapVariableProduct.strRateType = 'Basic';
                                                }

                                           if(objLVRRate.acfRate__c != null && objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null && objLead.acfLoan_Amount__c != null && objLead.acfWhat_is_your_current_payment_type__c != null)
                                           {
                                            objWrapVariableProduct.decMonthlyPayment = integer.valueof(ClickCommon.calculateMonthlyPayment(objLead.acfLoan_Amount__c,double.valueof(objLVRRate.acfRate__c),objLead.acfWhat_is_your_current_payment_type__c,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)));
                                            if(objLead.acfCurrentRate__c != null)
                                                decMonthlySavings = DisplayEstimatedSaving(objLead.acfCurrentRate__c,double.valueof(objLVRRate.acfRate__c),objLead.acfLoan_Amount__c,objLead.acfWhat_is_your_current_payment_type__c,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c));
                                           }
                                                                        
                                        system.debug('monthly payment calc var@@@@'+objLead.acfLoan_Amount__c+'@@@'+objLVRRate.acfRate__c+'@@@'+objLead.acfWhat_is_your_current_payment_type__c+'@@@'+objLVRRate.acfProduct__r.acfvarTenure_In_Years__c+'==result=='+objWrapVariableProduct.decMonthlyPayment);                                
                                        intTenureMonths  = integer.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c) * 12;
                                    }   
                                  //added by karthik on 04-05-2015                 
                                  
                                  objWrapVariableProduct.EstimatedMonthlySaving = decMonthlySavings * intTenureMonths;                                             
                                  system.debug('@@@karthik'+objWrapVariableProduct.EstimatedMonthlySaving);
                        lstWrapperProduct.add(objWrapVariableProduct);
                        IndexCount++;
                    }
                    IndexCount = lstWrapperProduct.size();
                    system.debug('!@#$%'+IndexCount);
                }
            }
        }
        system.debug('!@#$%^'+lstWrapperProduct.size()); 
        if(lstWrapperProduct != null && lstWrapperProduct.size()>0)  
            strProductLVRId = lstWrapperProduct[0].ProdLVRID;                        
        return null;
    }   
    public List<SelectOption> getProductIdslist() 
    {
        List<SelectOption> options = new List<SelectOption>();
        if(lstWrapperProduct != null && lstWrapperProduct.size()>0)
        {
            for(WrapperProducts objWrapperProducts : lstWrapperProduct)
            {
                options.add(new SelectOption(objWrapperProducts.ProdLVRID,objWrapperProducts.strRateType));
            }
        }
        return options;
    }
    
    public decimal DisplayEstimatedSaving(decimal CurrentRate,decimal ACFRate,decimal CurrentLoan,string PaymentType,decimal TenureInYears)
    {
       system.debug('test@@'+CurrentRate+'tenure'+TenureInYears+'rate'+ACFRate+'  CurrentLoan '+CurrentLoan+' PaymentType '+PaymentType);
      
       if(CurrentRate <> null && ACFRate <> null && CurrentLoan <> null && PaymentType <> null && TenureInYears <> null)
       {
           Decimal CurrentEMI = ClickCommon.calculateMonthlyPayment(CurrentLoan,double.valueof(CurrentRate),PaymentType,double.valueof(TenureInYears));
           Decimal ACFEMI = ClickCommon.calculateMonthlyPayment(CurrentLoan,double.valueof(ACFRate),PaymentType,double.valueof(TenureInYears));
           Decimal Saving;
           system.debug('testing'+CurrentEMI+'==='+ACFEMI);
           if(CurrentEMI >= ACFEMI)     
            Saving = CurrentEMI-ACFEMI;
           else
            Saving = 0;     
           system.debug('!#___---Saving_---'+Saving);
           return Saving;
       }
       return null;    
    }
    public void SendSmsAfterRegistration()
    {
        Cookie IsNewHomeLoan = ApexPages.currentPage().getCookies().get('IsNewHomeLoan');
        system.debug('!@#$%^');
        if (userId != null) 
        {
           CurrentUserId = userId;
           //OTP_PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
          // system.debug('ONE TIME Password ===================== '+OTP_PIN);
           // ===================== call SendSMS for sending msg ==================================
           //string response = ClickCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, '+'+objLead.MobilePhone, 'Dear user, Your OTP is: '+OTP_PIN+' Thanks, Team ACF', true) ;//This will also be your first time password to log into ACF portal
           String strOTPmsg;
           if(lstCommunity.Click_Page_Prefix__c != null)
           {
                   string OTPLabelName = lstCommunity.Click_Page_Prefix__c +'OTP_Text' ;
                   Component.Apex.OutputText output = new Component.Apex.OutputText();
                   output.expressions.value = '{!$Label.' + OTPLabelName + '}';
                   strOTPmsg = String.valueOf(output.value);
                   system.debug('======strOTPtxt =========='+strOTPmsg); 
                   
           }
           strOTPmsg = strOTPmsg.replace('<OTP>',password);
           system.debug('@@@otp test message'+strOTPmsg);
          // string response = ClickCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, '+'+objLead.MobilePhone, strOTPmsg, true) ;//This will also be your first time password to log into ACF portal
           
           string response = ClickCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, '+'+objLead.MobilePhone, strOTPmsg, true) ;//This will also be your first time password to log into ACF portal
           
           //ClickCommon.SendSMSUsingFuture(objLead.FirstName +' '+objLead.lastName, objLead.MobilePhone, strOTPmsg, true) ;//This will also be your first time password to log into ACF portal
           response = 'success';  
           system.debug('respone ======================= '+response);
           if(response <> null && response <> '' && response.contains('success'))
           {
               system.debug('respone in ======================= '+response);
               User usrObj = [select id,accountId,contactId from user where id=:userId];
               system.debug('usrObj  ======================= '+usrObj );
               Id currentAccountRecordTypeId;
               if(IsNewHomeLoan <> null && IsNewHomeLoan.getvalue() == 'true')
               {
                   if(lstCommunity.Click_Page_Prefix__c != null )
                   {
                       currentAccountRecordTypeId = ClickCommon.GetRecordTypeId('Account',lstCommunity.Click_Page_Prefix__c+' New Loans');
                       system.debug('currentAccountRecordTypeId ======================= '+currentAccountRecordTypeId );
                   }
               }
               else
               {
                   if(lstCommunity.Click_Page_Prefix__c != null )
                   {
                       currentAccountRecordTypeId = ClickCommon.GetRecordTypeId('Account',lstCommunity.Click_Page_Prefix__c+' Refi');
                       system.debug('currentAccountRecordTypeId 88888======================= '+currentAccountRecordTypeId );
                   }
               }

               objAccount = new Account(id = usrObj.accountId);
              // objAccount = [select id,  from account where id=:usrObj.accountId];
               objLead.acf_Contact__c = usrObj.ContactId;
               objLead.acf_partner_account__c = objAccount.Id;
               objLead.acfOneTimePassword__c = password;
               ObjAccount.PersonMobilePhone = tempMobile;
               objLead.MobilePhone = tempMobile;
               system.debug('mobile@@##'+mobile);
               ObjAccount.acfPassword__c = password;
               objAccount.acf_Lead__pc = objLead.id;
               objAccount.RecordTypeId = currentAccountRecordTypeId;
               objAccount.Click_Community_Setup__c = lstCommunity.id;                                       
               update ObjAccount; 
               update objLead;
               system.debug('ObjAccount88888======================= '+ObjAccount);
                system.debug('objLead=22====================== '+objLead);
               
              // PageReference chngpass = Site.changePassword(OTP_PIN,OTP_PIN,password);
              
               //system.debug('chngpass ======================= '+chngpass);
               if(objLead.MobilePhone <>  null && objLead.MobilePhone != ''){
                   mobile_num = objLead.MobilePhone.replace('+61','');
               }
               
               mob_verify = true;           // open popup box for taking otp
               mob_email_verify = false;    // close popup box for email and mobile    
               objRegHeaderCMS = mapSectionToCMS.get('OTP Popup');                                                     
            }
            else
            {
               strmsg = response;
               objRegHeaderCMS = mapSectionToCMS.get('OTP Popup');
               mob_verify = true;
               mob_email_verify = false;
            }
            //Added by Lokesh on 6-12-2014 to
            //Add Required Documents based on Answers
            Cookie requiredDocumentAnswers = ApexPages.currentPage().getCookies().get('ACFRA');
            system.debug('::::LOKESH:::::'+requiredDocumentAnswers.getValue());
            if(requiredDocumentAnswers <> null && requiredDocumentAnswers.getValue() <> '')
            {
               for(string strAnswers:requiredDocumentAnswers.getValue().split('--,--'))
               {
                   setSelectedAnswerId.add(strAnswers);
               }
            }
            system.debug('::::LOKESH:::::'+setSelectedAnswerId);
            if(setSelectedAnswerId.size()>0)
            {
              // Method used to get Required Document Based on Answers.
              ClickCommon.getRequiredDocumentsFromAnswers(objLead.id,setSelectedAnswerId);
              //Method used to getSuggestedProducts Based on Answers.
              ClickCommon.getSuggestedProductsFromAnswers(objLead.id, setSelectedAnswerId, lstCommunity.Id);
            } 
            if(IsNewHomeLoan <> null && IsNewHomeLoan.getvalue() == 'true')
            {
                 system.debug('@@isNew Home loan');
            }
            else if(ObjAccount != null && objLead != null)
            {
                Asset_Liability_Statement__c objAssetsLiab = new Asset_Liability_Statement__c();
                if(objLead.acfApproximately_how_much_is_your_house__c != null)
                    objAssetsLiab.Home_Value_Amount__c = objLead.acfApproximately_how_much_is_your_house__c;
                if(objLead.acfLoan_Amount__c != null)
                    objAssetsLiab.Mortgage_on_Home_Amount__c = objLead.acfLoan_Amount__c;
                objAssetsLiab.acfIsCreatedByPortalUser__c = true;
                objAssetsLiab.AL_Statement_Owner__c = ObjAccount.Id;
                insert objAssetsLiab;

                Asset_And_Liability__c objAssetsLiabAsset = new Asset_And_Liability__c();
                Asset_And_Liability__c objAssetsLiabAssetLiab = new Asset_And_Liability__c();
                List<Asset_And_Liability__c> assetLiabList = new List<Asset_And_Liability__c>();
                System.debug('###objLead'+objLead);
                if(objLead.acfApproximately_how_much_is_your_house__c != null)
                    objAssetsLiabAsset.Value__c = objLead.acfApproximately_how_much_is_your_house__c;
                    objAssetsLiabAsset.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
                    objAssetsLiabAsset.Account__c = ObjAccount.Id;
                    objAssetsLiabAsset.Primary_Purpose__c = 'Owner Occupied';
                    objAssetsLiabAsset.Name = 'Asset Home';
                    objAssetsLiabAsset.Type__c = 'Asset'; 
                    assetLiabList.add(objAssetsLiabAsset);
                if(objLead.acfLoan_Amount__c != null){
                    objAssetsLiabAssetLiab.Current_Balance__c = objLead.acfLoan_Amount__c;
                    objAssetsLiabAssetLiab.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();
                    objAssetsLiabAssetLiab.Account__c = ObjAccount.Id;
                    objAssetsLiabAssetLiab.Primary_Purpose__c = 'Owner Occupied';
                    objAssetsLiabAssetLiab.Name = 'Liabilities Mortgage Loan';
                    objAssetsLiabAssetLiab.Type__c = 'Liability'; 
                    assetLiabList.add(objAssetsLiabAssetLiab);
                }
                system.debug('###assetLiabList'+assetLiabList);
                //objAssetsLiab.acfIsCreatedByPortalUser__c = true;
                insert assetLiabList;
                
                Asset_and_Liability_Link__c aLink = new Asset_and_Liability_Link__c();
                aLink.Asset__c = assetLiabList[0].id;
                aLink.Liabilities__c = assetLiabList[1].id;
                aLink.Name = [SELECT Name From Account where id =:assetLiabList[0].Account__c].Name+'-'+assetLiabList[0].Name+'-'+assetLiabList[1].Name;
                insert aLink;
                
            }  
           if(objLead != null)
           {
            Cookie LeadId = new Cookie('leadId',objLead.Id,null,72000,false);
            ApexPages.currentPage().setCookies(new Cookie[]{LeadId});
            Cookie strUserId = new Cookie('strUserId',userId,null,72000,false);
            ApexPages.currentPage().setCookies(new Cookie[]{strUserId});
           }
           
       /* click_Applicant__c objFirstApplicant = new click_Applicant__c();
        objFirstApplicant.put('acfEmployment_Type__c',maptst.get('acfEmployment_Type__c'));
        objFirstApplicant.put('acfLast_2_years_Tax_Return_or_ATO_NOA__c',maptst.get('acfLast_2_years_Tax_Return_or_ATO_NOA__c'));
        objFirstApplicant.acf_Applicant_Name__c = ObjAccount.Name;
        objFirstApplicant.click_Account__c = ObjAccount.id;
        objFirstApplicant.click_Applicant_Number__c = '1';
        insert objFirstApplicant;*/
        
        } 
        else
        {
           system.debug('userID false  ================ '+userID);
           delete objLead;
        }
    }
    public class WrapperProducts
    { 
        public decimal decRate{get;set;}
        public string strRateType{get;set;}
        public decimal decComparisionRate{get;set;}
        public double decApplicationFee{get;set;}
        public string strcomparisionType{get;set;}
        public integer decMonthlyPayment{get;set;}
        public integer intTenureYrs{get;set;}   
        public string strRating{get;set;} 
        public Id ProductId{get;set;}
        public Id ProdLVRID{get;set;}
        public Integer IndexNo{get;set;}
        public List<Integer>lstProductRating{get;set;} 
        public boolean IsDisplayHalfStar{get;set;}   
        public decimal EstimatedMonthlySaving {get;set;}
        public string strProdName {get;set;}
        public string strBnkImgURL {get;set;}
    }
}