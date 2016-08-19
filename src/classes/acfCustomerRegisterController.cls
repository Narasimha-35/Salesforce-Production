/*====================================================
                Click Loans
  An apex class that creates community user 
========================================================*/
//prod
public without sharing class acfCustomerRegisterController 
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
    public acfCustomerRegisterController () 
    {
         Cookie Bname = new Cookie('Bname',null,null,72000, false); 
         setSelectedAnswerId = new set<string>();
         ApexPages.currentPage().setCookies( new Cookie[]{Bname});
         Cookie ClickLeadId  = ApexPages.currentPage().getCookies().get('LeadId');
         Cookie strUserId = ApexPages.currentPage().getCookies().get('strUserId');
         strMsg ='';
         strproductmsg = '';
         CurrentUserId = '';
         strTimezoneId = '';
         system.debug('userId@@@@'+userInfo.getuserId());
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
         objUser = new User();
         If(ClickLeadId <> null && string.valueof(ClickLeadId.getvalue()) != null && string.valueof(ClickLeadId.getvalue()) <> '')
         {
             system.debug('lead id@@@'+ClickLeadId.getvalue());
             List<Lead> List_lead = [select id,FirstName,LastName,acfIsMobileVerified__c,MobilePhone,acfOneTimePassword__c,Email,acf_partner_account__c from lead where id=: String.valueof(ClickLeadId.getvalue())];
             If(List_lead !=null && List_lead.size()>0){
                CurrentLeadId = List_lead[0].id;
                objLead = new Lead();
                objLead = List_lead[0];
                username = objLead.Email;
                password = objLead.acfOneTimePassword__c; 
                system.debug('username'+username);
                system.debug('password'+password);
                objAccount = new Account(id=objLead.acf_partner_account__c);
                If(strUserId != null && string.valueof(strUserId.getvalue()) != null && string.valueof(strUserId.getvalue()) <> '')
                {
                      CurrentUserId = string.valueof(strUserId.getvalue()); 
                      system.debug('@@@@User Id'+CurrentUserId);
                }
                 If(objLead.acfIsMobileVerified__c)
                 {
                   showformVar = false; 
                 }else{
                         objAccount = [select id,acfIsMobileVerified__c from account where id=:objLead.acf_partner_account__c];
                         if(objLead.MobilePhone <>  null){
                             mobile_num = objLead.MobilePhone.replace('+61','');
                         }
                         showformVar = true;
                         mob_verify = true;           
                         mob_email_verify = false;
                      }
             }
             DisplayTop3Products(ClickLeadId.getvalue());
         }
         objbankinfo = acfBank_Information__c.getvalues('Top Products');
         List<acfContentManagementSystem__c> lstRegistrationHeader = [SELECT Id,acfDescription__c,acfHeading__c,acfSectionName__c,acfShort_Description__c,acfHeading_Caption__c FROM acfContentManagementSystem__c where acfSectionName__c = 'Registration Popup' OR acfSectionName__c = 'OTP Popup' OR acfSectionName__c = 'Resend OTP Popup' OR acfSectionName__c = 'Preliminary Quote'];  
         for(acfContentManagementSystem__c objCMS : lstRegistrationHeader)
         {
                mapSectionToCMS.put(objCMS.acfSectionName__c,objCMS);
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
         //DisplayTop3Products('00QO0000002Qeol');
         //displayProducts();
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
                  if(lstuser <> null && lstuser.size()>0)
                  {
                      If(CurrentUserId != null && lstuser[0].profile.Name <> 'Community User')
                      { 
                          string retPgName = acfCommon.sendReturnUrl(CurrentUserId,false,'');
                          if(strTimezoneId != null && strTimezoneId <> '')
                          {
                            User objUser = new User(id=CurrentUserId);
                            objUser.TimeZoneSidKey = strTimezoneId;
                            update objUser;
                          }
                          system.debug('Username:::::'+username+'===='+password+'===='+retPgName+'===='+CurrentUserId); //acfID_Verification acfJumioIntegration
                          return Site.login(username,password,'/'+retPgName); 
                      }
                      else if(lstuser[0].profile.Name == 'Community User')
                      {
                                string strUsrId = userinfo.getuserId();
                                string retPgName = acfCommon.sendReturnUrl(strUsrId,false,'');
                                return new pagereference('/'+retPgName);
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
            if(!acfCommon.isNullOrEmpty(username.trim()))    {                
                if(username.contains('@') && username.contains('.')){
                    if(IsUserAlreadyExist() == false){                        
                            if(acfCommon.checkEmail(username.trim()))
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
            List<MortgageExpert__c> List_mExpert = MortgageExpert__c.getall().values();
            set<string>setSelectedAnswers = new set<string>();
            //set<string>setSelectedAnswerId = new set<string>();
            string leadRecordTypeId = ''; 
            System.debug('mortgage Expert'+List_mExpert);
            Cookie IsNewHomeLoan = ApexPages.currentPage().getCookies().get('IsNewHomeLoan');
            Schema.DescribeSObjectResult leadRT = Schema.SObjectType.Lead;
            Map<String,Schema.RecordTypeInfo> rtCick_Refi = leadRT.getRecordTypeInfosByName();
            if(IsNewHomeLoan <> null && IsNewHomeLoan.getvalue() == 'true')
            {
                Schema.RecordTypeInfo rtLead =  rtCick_Refi.get('Click New Loans');
                system.debug('@@@click refi lead record type@@ =========== '+rtLead); 
                leadRecordTypeId = rtLead.getRecordTypeId();
            }
            else
            {
                    Schema.RecordTypeInfo rt_Lead =  rtCick_Refi.get('Click Refi');
                    system.debug('@@@click refi lead record type@@ =========== '+rt_Lead); 
                    leadRecordTypeId = rt_Lead.getRecordTypeId();
            }
            try{
                if((!acfCommon.isNullOrEmpty(username.trim()))&&(!acfCommon.isNullOrEmpty(mobile))){
                    if(IsUserAlreadyExist() == false){
                        if(isEmailVeriried){
                            if(mobile != null && mobile <> '' && mobile != 'Mobile Number'){
                                if(mobile.substring(0,1) == '0'){
                                    mobile = '+61'+mobile.substring(1,mobile.length());
                                }else{
                                    mobile = '+61'+mobile;
                                }
                                //For Lead Api To Answers.
                                Cookie currentUId = ApexPages.currentPage().getCookies().get('ACFAnswers');
                                system.debug('currentUId'+currentUId);
                                map<string,string> maptst = acfcommon.getLeadApiNameToAnswerMap(currentUId.getvalue());
                                //For Lead Api To Data Type
                                Cookie currentLeadApiNames = ApexPages.currentPage().getCookies().get('ACFLeadApiNames');
                                system.debug('currentUId'+currentLeadApiNames);
                                map<string,string> maptLeadApiToType = acfcommon.getLeadApiNameToType(currentLeadApiNames.getvalue());
                                system.debug('Map_karthik'+maptLeadApiToType);
                                objLead = new Lead();
                                objLead.FirstName = mobile;//username.substring(0,5);
                                objLead.LastName = mobile;//username.substring(0,5);
                                objLead.Email = username.trim(); 
                                objLead.MobilePhone = mobile;
                                List<Lead> lstLead = [select id,firstname,lastname,acfIsCreatedViaRequestCall__c,acfIs_User_Registered__c from lead where Email =:username.trim()];
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
                                    generateReqDocs(objLead.Id);  
                                    
                                }        
                                System.debug('objLead================'+objLead);
                                system.debug('List_mExpert***'+List_mExpert);
                                If(!List_mExpert.isEmpty())
                                {
                                    List<Profile> lstCommUserProfile = [select id,name from profile where name='Community User' limit 1];
                                    system.debug('lstCommUserProfile' +lstCommUserProfile);
                                    objUser = new User();
                                    objUser.FirstName = objLead.firstName;
                                    objUser.LastName = objLead.LastName;
                                    objUser.MobilePhone = mobile;
                                    objUser.Username = username.trim();
                                    objUser.Email = username.trim();
                                    objUser.ProfileId = lstCommUserProfile[0].id;
                                    objUser.CommunityNickname = String.valueof(Math.random()+DateTime.now().year()+DateTime.now().month()+DateTime.now().day()+DateTime.now().hour()+DateTime.now().minute()+DateTime.now().second());
                                    objUser.TimeZoneSidKey = 'Australia/Brisbane';  
                                    OTP_PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
                                    password = OTP_PIN;
                                    String OwnerId = List_mExpert[0].User_ID__c;  //'005900000035uLJ'; 
                                    userId = Site.createPersonAccountPortalUser(objUser,OwnerId,OTP_PIN);
                                    system.debug('objUser =============== '+objUser);
                                    system.debug('OwnerId =============== '+OwnerId);
                                    system.debug('OTP_PIN =============== '+OTP_PIN);
                                    system.debug('userID =============== '+userId);
                                    /*if (userId != null ) 
                                    {
                                       CurrentUserId = userId;
                                       system.debug('ONE TIME Password ===================== '+OTP_PIN);
                                       
                                       // ===================== call SendSMS for sending msg ==================================
                                      // string response = acfCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, '+'+mobile, 'Dear user, Your OTP is: '+OTP_PIN+' Thanks, Team ACF', true) ;//This will also be your first time password to log into ACF portal
                                       String strOTPmsg = System.Label.acfOTP_Text;
                                       strOTPmsg = strOTPmsg.replace('<OTP>',OTP_PIN);
                                       system.debug('@@@otp test message'+strOTPmsg);
                                       acfCommon.SendSMSUsingFuture(objLead.FirstName +' '+objLead.lastName, mobile, strOTPmsg, true) ;//This will also be your first time password to log into ACF portal
                                       string response = 'success';  
                                       
                                       system.debug('respone ======================= '+response);
                                       if(response <> null && response <> '' && response.contains('success'))
                                       {
                                           system.debug('respone in ======================= '+response);
                                           User usrObj = [select id,accountId,contactId from user where id=:userId];
                                           Id currentAccountRecordTypeId = acfcommon.GetRecordTypeId('Account','Click Refi');
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
                                          acfCommon.getRequiredDocumentsFromAnswers(objLead.id,setSelectedAnswerId);
                                          //Method used to getSuggestedProducts Based on Answers.
                                          acfCommon.getSuggestedProductsFromAnswers(objLead.id,setSelectedAnswerId);
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
                                       
                                       Cookie ClickLeadId = new Cookie('leadId',objLead.Id,null,72000,false);
                                       ApexPages.currentPage().setCookies(new Cookie[]{ClickLeadId});
                                       Cookie ClickstrUserId = new Cookie('strUserId',userId,null,72000,false);
                                       ApexPages.currentPage().setCookies(new Cookie[]{ClickstrUserId});
                                    } 
                                    else{
                                       system.debug('userID false  ================ '+userID);
                                        //strmsg = 'Click_Exception_Message';
                                      // delete objAccount;
                                       delete objLead;
                                    }*/
                               } else{
                                   strmsg = 'OwnerId should not be null';
                                  }
                            
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
           String strOTPtxt = System.Label.acfOTP_Text;
           strOTPtxt = strOTPtxt.replace('<OTP>',OTP_PIN);
           system.debug('@@@otp test message'+strOTPtxt);
           string response = acfCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, mobile, strOTPtxt, true) ;
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
               if(objLead.MobilePhone <>  null){
                    mobile_num = objLead.MobilePhone.replace('+61','');
               }
               
               mob_verify = true;           // open popup box for taking otp
               mob_email_verify = false;    // close popup box for email and mobile  
                                                                      
           }
         
        }
        Cookie utmSource = new Cookie('utm_source',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{utmSource});
        
        Cookie utmMedium = new Cookie('utm_medium',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{utmMedium});
        
        Cookie utmTerm = new Cookie('utm_term',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{utmTerm});
        
        Cookie utmContent = new Cookie('utm_content',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{utmContent});
        
        Cookie utmCampaign = new Cookie('utm_campaign',null,null,-1, false); 
        ApexPages.currentPage().setCookies(new Cookie[]{utmCampaign});
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
             DisplayTop3Products(objLead.id);              
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
        If(mobile_num != null && mobile_num <> '' && mobile_num != 'Mobile No.'){
                String OTP_PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
                //PageReference chngpass = Site.changePassword(OTP_PIN,OTP_PIN,objLead.acfOneTimePassword__c);
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
                string response = acfCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, mobile, strOTPtxt, true) ;
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
    Public static void generateReqDocs(String LeadId)
    {
        List<Document_Master__c> List_DocMaster = [select id,Name,acfActive__c,acfDescription__c,acf_Source__c from Document_Master__c where acfActive__c=true];
        List<Required_Document__c> List_reqDocs = new List<Required_Document__c>();
        If(!List_DocMaster.isEmpty())
        {
            for(Document_Master__c objDoc : List_DocMaster)
            {
                If(objDoc.acf_Source__c == 'Jumio' || (objDoc.acf_Source__c == 'Bank Statement'))
                {
                    Required_Document__c objReqDoc = new Required_Document__c();
                    objReqDoc.Name = objDoc.Name;
                    objReqDoc.Lead__c = LeadId;
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
           PageReference p = page.ClickHome;
           p.setredirect(true);
           return p;
    }
    
    Public PageReference redirect() 
    {
        Cookie currentUId = ApexPages.currentPage().getCookies().get('ACFAnswers');
        If(currentUId != null){
            return null;
        } else{
               PageReference p = page.ClickHome;
               p.setredirect(true);
               return p;
               }
    }
    
    /*
    **  this method responsible for checks whether user already exist or not    
    */
    public boolean IsUserAlreadyExist() 
    { 
        List<User> lstUser = [select id,Username,Email from User where Username =: username.trim()];
        List<Lead> lstLead = [select id,Email,acfIs_User_Registered__c from Lead where Email =: username.trim()];
        system.debug('lstuser'+lstuser);
        if((lstUser != null && lstUser.size()>0) || (lstLead != null && lstLead.size()>0 && lstLead[0].acfIs_User_Registered__c == true))
        {
           return true;
        } else{
           return false;
        }     
    }
    
    //Added by lokesh on 17-12-14 to display Top 3 Products.
    public pageReference DisplayTop3Products(Id LeadId)
    {
        List<LVR_Rate__c> lstProductIdToLVR = new list<LVR_Rate__c>();
        lstWrapperProduct = new List<WrapperProducts>();
        Cookie currentLeadId  = ApexPages.currentPage().getCookies().get('LeadId'); 
        if(currentLeadId != null)
        {
            List<Lead> lstLead = [select id,acfLoan_Amount__c,acfCurrentRate__c,acfWhat_is_your_current_payment_type__c,acfApproximately_how_much_is_your_house__c,Recordtype.Name from lead where id=: currentLeadId.getValue()];                
            if(lstLead != null && lstLead.size()>0)
            {
                Lead objLead = lstLead[0];
        double usrLVR = 0;
        map<string,LVR_Rate__c>mapProductIdToLVR = new map<string,LVR_Rate__c>();
        set<string>setProductIdToExclude = new set<string>();
        
        for(acfSuggested_Product__c objSuggestedProduct:[select id,acfFilter__c,acfProduct__c,acfProduct_Family__c,acfLead__c from acfSuggested_Product__c where acfLead__c=:LeadId])
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
                system.debug('usrLVr@@'+usrLVR +'===='+objLead.acfLoan_Amount__c+'===='+objLead.acfApproximately_how_much_is_your_house__c);
                boolean isFixed1YrCompleted = false;
                boolean isFixed2YrCompleted = false;
                boolean isFixed3yrCompleted = false;
                boolean isFixed4yrCompleted = false;
                boolean isFixed5yrCompleted = false;
                for(LVR_Rate__c objLVR:[select id,acfLVR__c,acfRate__c,acfProduct__r.acfType__c,acfProduct__r.Recordtype.Name,acfProduct__c,acfLoan_Size__c,ACF_Comparison_Rate__c,
                                        clickFixed_Interest_Rate__c,clickLoan_Size_From__c,clickLVR_From__c,acfProduct__r.acfTenure_in_Years__c,acfApplication_Fee__c,
                                        acfProduct__r.acfvarTenure_In_Years__c,acfProduct__r.name,acfProduct__r.isActive,acfTerm_in_Years__c,acfProduct__r.acfOffset_Account__c from LVR_Rate__c where clickLoan_Size_From__c <: objLead.acfLoan_Amount__c and acfLoan_Size__c >=:objLead.acfLoan_Amount__c 
                                        and clickLVR_From__c <: usrLVR and acfLVR__c>=:usrLVR AND acfProduct__r.isActive = true order by acfTerm_in_Years__c,acfRate__c,clickFixed_Interest_Rate__c asc])
                {
                    system.debug('karthik@@@'+objLVR);
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
                    for(LVR_Rate__c objLVRRate:lstProductIdToLVR)
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
                //      acfLoanDashboardController objLoanDashboardController = new acfLoanDashboardController();
                             //objWrapVariableProduct.EstimatedMonthlySaving = objLoanDashboardController.DisplayEstimatedSaving(lstLead[0].acfCurrentRate__c,objLVRRate.acfRate__c,lstLead[0].acfLoan_Amount__c,lstLead[0].acfWhat_is_your_current_payment_type__c,objLVRRate.acfProduct__r.acfvarTenure_In_Years__c);
                              Integer intTenureMonths = 0;
                              decimal decMonthlySavings = 0;
               //             acfLoanDashboardController objLoanDashboard = new acfLoanDashboardController();
                              If(objLVRRate.acfProduct__r.Recordtype.Name == 'Fixed')
                              {
                                  objWrapVariableProduct.decRate = objLVRRate.clickFixed_Interest_Rate__c;
                                  objWrapVariableProduct.strRateType = 'Fixed '+objLVRRate.acfProduct__r.acfTenure_in_Years__c+' Yr';
                                  //system.debug('monthly payment calc@@@@'+objLead.acfLoan_Amount__c+'@@@'+objLVRRate.acfRate__c+'@@@'+objLead.acfWhat_is_your_current_payment_type__c+'@@@'+objLVRRate.acfProduct__r.acfTenure_in_Years__c);
                                 if(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null)
                                  objWrapVariableProduct.intTenureYrs = integer.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c);
                                 
                                    if(objLVRRate.clickFixed_Interest_Rate__c != null && objLVRRate.acfProduct__r.acfvarTenure_In_Years__c != null && objLead.acfLoan_Amount__c != null && objLead.acfWhat_is_your_current_payment_type__c != null )
                                    {
                                      objWrapVariableProduct.decMonthlyPayment = integer.valueof(acfCommon.calculateMonthlyPayment(objLead.acfLoan_Amount__c,double.valueof(objLVRRate.clickFixed_Interest_Rate__c),objLead.acfWhat_is_your_current_payment_type__c,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)));
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
                                            objWrapVariableProduct.decMonthlyPayment = integer.valueof(acfCommon.calculateMonthlyPayment(objLead.acfLoan_Amount__c,double.valueof(objLVRRate.acfRate__c),objLead.acfWhat_is_your_current_payment_type__c,double.valueof(objLVRRate.acfProduct__r.acfvarTenure_In_Years__c)));
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
           Decimal CurrentEMI = acfCommon.calculateMonthlyPayment(CurrentLoan,double.valueof(CurrentRate),PaymentType,double.valueof(TenureInYears));
           Decimal ACFEMI = acfCommon.calculateMonthlyPayment(CurrentLoan,double.valueof(ACFRate),PaymentType,double.valueof(TenureInYears));
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
        try
        {
        if (userId != null) 
        {
           CurrentUserId = userId;
           //OTP_PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
          // system.debug('ONE TIME Password ===================== '+OTP_PIN);
           // ===================== call SendSMS for sending msg ==================================
           //string response = acfCommon.sendSMS(objLead.FirstName +' '+objLead.lastName, '+'+mobile, 'Dear user, Your OTP is: '+OTP_PIN+' Thanks, Team ACF', true) ;//This will also be your first time password to log into ACF portal
       

           String strOTPmsg = System.Label.acfOTP_Text;
           strOTPmsg = strOTPmsg.replace('<OTP>',password);
           system.debug('@@@otp test message'+strOTPmsg);
           //string response = 'success';
           system.debug('mobile@@##'+mobile);
           string response = acfCommon.sendSMS(objLead.FirstName +' '+objLead.lastName,mobile, strOTPmsg, true) ;//This will also be your first time password to log into ACF portal
           //acfCommon.SendSMSUsingFuture(objLead.FirstName +' '+objLead.lastName, mobile, strOTPmsg, true) ;//This will also be your first time password to log into ACF portal
           //response = 'success';  
           system.debug('respone ======================= '+response);
           
           if(response <> null && response <> '' && response.contains('success'))
           {
               system.debug('respone in ======================= '+response);
               User usrObj = [select id,accountId,contactId from user where id=:userId];
               Id currentAccountRecordTypeId = acfcommon.GetRecordTypeId('Account','Click Refi');
               objAccount = new Account(id = usrObj.accountId);
              // objAccount = [select id,  from account where id=:usrObj.accountId];
               objLead.acf_Contact__c = usrObj.ContactId;
               objLead.acf_partner_account__c = objAccount.Id;
               objLead.acfOneTimePassword__c = password;
               objLead.MobilePhone = mobile;
               system.debug('mobile@@##'+mobile);
               ObjAccount.PersonMobilePhone = mobile;
               ObjAccount.acfPassword__c = password;
               objAccount.acf_Lead__pc = objLead.id;
               objAccount.RecordTypeId = currentAccountRecordTypeId;                                        
               update ObjAccount; 
               update objLead;
               
              // PageReference chngpass = Site.changePassword(OTP_PIN,OTP_PIN,password);
              
               //system.debug('chngpass ======================= '+chngpass);
               if(objLead.MobilePhone <>  null){
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
              acfCommon.getRequiredDocumentsFromAnswers(objLead.id,setSelectedAnswerId);
              //Method used to getSuggestedProducts Based on Answers.
              acfCommon.getSuggestedProductsFromAnswers(objLead.id,setSelectedAnswerId);
            } 
            if(IsNewHomeLoan <> null && IsNewHomeLoan.getvalue() == 'true')
            {
                 system.debug('@@isNew Home loan');
            }
            else if(objLead != null && ObjAccount != null)
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
            Cookie ClickLeadId = new Cookie('leadId',objLead.Id,null,72000,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClickLeadId});
            Cookie ClickstrUserId = new Cookie('strUserId',userId,null,72000,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClickstrUserId});
        } 
        else
        {
           system.debug('userID false  ================ '+userID);
            //strmsg = 'Click_Exception_Message';
          // delete objAccount;
           delete objLead;
        }
        }catch(Exception Ex)
        {
            system.debug('@@@Exception'+Ex);
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
    }
}