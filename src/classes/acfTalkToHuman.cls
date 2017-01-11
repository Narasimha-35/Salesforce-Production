/*====================================================
                Click Loans
========================================================*/
public class acfTalkToHuman
{
    public string strReqName{get;set;}
    public string strReqEmail{get;set;}
    public string strReqPhone{get;set;}
    public string strReqErrorMsg {get;set;}  
    Public boolean isEmailVerified {get;set;}
    Public string success{get;set;}
    
    Public List<Lead> lstLead;  
    Public List<Account> lstPersonAcc;
    Public Click_Community_Setup__c lstCommunity = new Click_Community_Setup__c();
    
    public acftalktohuman(){
        isEmailVerified = false;
        success = 'false';
       
        List<User> lstUsrObj = [select id,accountId from user where id=:userInfo.getuserId()];
        If(lstUsrObj != null && lstUsrObj.size()>0){
          lstPersonAcc = [select id,PersonMobilePhone,PersonEmail,lastname,name from account where id=:lstUsrObj[0].accountId];
        }
        If(lstPersonAcc != null && lstPersonAcc.size()>0){
           strReqName = lstPersonAcc[0].name;
           strReqEmail = lstPersonAcc[0].PersonEmail;
           If(lstPersonAcc[0].PersonMobilePhone <> null)
           strReqPhone = lstPersonAcc[0].PersonMobilePhone.replace('+61','');
        }
    }
    public pagereference RequestACall()
    {
        if(strReqEmail != null && strReqEmail <> '' && strReqName <> null && strReqName <> '' && strReqPhone <> null && strReqPhone <> '')
        {
            string strNetworkId=  Network.getNetworkId();
            if(strNetworkId != null)
            {
                  system.debug('=======Network ID======'+strNetworkId);
                  lstCommunity = ClickCommon.getCommunitySetup(strNetworkId);
            }
            lstLead = [select id, name,Lastname,mobilePhone from lead where Email =: strReqEmail.trim() AND Community__c =: lstCommunity.id AND IsConverted = false];
            Lead objReqLead = new Lead(); 
            String currentLoggedInOppID;
            if(strNetworkId != null)
            {
                currentLoggedInOppID = ClickCommon.getCurrentLoggedInOpportunityId(UserInfo.getuserId(),(ClickCommon.getCommunitySetup(strNetworkId)).Click_Page_Prefix__c);
            }
             MortgageExpert__c List_mExpert;
             if(lstCommunity.Click_Page_Prefix__c != null)
             {
                 List_mExpert = MortgageExpert__c.getvalues(lstCommunity.Click_Page_Prefix__c+'_David Hyman');
             } 
             Task objTask = new Task();
             objTask.subject = 'Request for a call'; 
             objTask.IsVisibleInSelfService = false;
             If(List_mExpert != null){
                objTask.ownerId = List_mExpert.User_ID__c;
             }

            If(currentLoggedInOppID != null && currentLoggedInOppID <> ''){
              If(lstPersonAcc != null && lstPersonAcc.size()>0){
                  objTask.WhatId = lstPersonAcc[0].Id;
              }
            }else{
                if(lstLead != null && lstLead.size()>0)
                {
                    objReqLead = lstLead[0];
                }
                else
                {    
                    Schema.DescribeSObjectResult leadRT = Schema.SObjectType.Lead;
                    Map<String,Schema.RecordTypeInfo> rtCick_Refi = leadRT.getRecordTypeInfosByName();
                    if(lstCommunity.Click_Page_Prefix__c != null)
                    {
                        Schema.RecordTypeInfo rt_Lead =  rtCick_Refi.get(lstCommunity.Click_Page_Prefix__c+' Refi'); 
                        objReqLead.RecordTypeId = rt_Lead.getRecordTypeId();  
                    }               
                    objReqLead.LastName = strReqName;
                    objReqLead.Email = strReqEmail.trim();
                    if(strReqPhone.substring(0,1) == '0')
                    {
                            objReqLead.MobilePhone = '+61'+strReqPhone.substring(1,strReqPhone.length());
                    }else{
                            objReqLead.MobilePhone = '+61'+strReqPhone;
                    }
                    objReqLead.acfIsCreatedViaRequestCall__c = true;
                    
                    objReqLead.Status = 'Open';
                    AssignmentRule AR = new AssignmentRule();
                    insert objReqLead;
                    
                    AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
                    if(AR <> null)
                    {
                        Database.DMLOptions dmlOpts = new Database.DMLOptions();
                        dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
                        objReqLead.setOptions(dmlOpts);
                    }
                    update objReqLead;
                    
                    
                } 
               objTask.WhoId = objReqLead.id;           
            } 

            system.debug('####'+UserInfo.getUserType());
            if(UserInfo.getUserType() == 'Guest'){
                case objCase = new case();
                objCase.Description = 'Request For Call';
                if(objReqLead != null){
                    objCase.Lead__c = objReqLead.id;
                }

                Schema.DescribeSObjectResult caseRT = Schema.SObjectType.Case;
                Map<String,Schema.RecordTypeInfo> rtCick_Refi = caseRT.getRecordTypeInfosByName();
                Schema.RecordTypeInfo rt_Case =  rtCick_Refi.get('Click Refi');   
                if(rt_Case != null && rt_Case.getRecordTypeId() <> null)
                {
                    objCase.RecordTypeId = rt_Case.getRecordTypeId(); 
                }
                system.debug('###Manish'+objCase);
                AssignmentRule AR = new AssignmentRule();
                insert objCase;
                
                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                if(AR <> null)
                {
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
                    objCase.setOptions(dmlOpts);
                }
                update objCase;
            }

            If(objTask != null)   insert objTask;
            strReqErrorMsg = 'Request submitted successfully. We will contact you soon';
            success = 'true';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Request submitted successfully.'));       
            return null;
        }        
        else
        {
            strReqErrorMsg = 'Please fill all required fields.';
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please fill all required fields.'));
        } 
        return null;
    }
    
    public void VerifyEmail(){
        isEmailVerified = false;
        strReqErrorMsg = '';
        if(strReqEmail != null && strReqEmail != ''){
            if(!acfCommon.isNullOrEmpty(strReqEmail.trim()))    {                
                if(strReqEmail.contains('@') && strReqEmail.contains('.')){
                    if(IsUserAlreadyExist() == false){                        
                            if(acfCommon.checkEmail(strReqEmail.trim()))
                                isEmailVerified = true;
                            else
                                strReqErrorMsg = 'Invalid email id, please use valid email id.';                                
                    }else{
                        strReqErrorMsg = 'This email ID is already registered.';
                    }        
                }else{
                     strReqErrorMsg = 'Please enter mail id in correct format.';
                }
            }else{
                strReqErrorMsg = 'Please fill in your Email ID.';
            }
        }else{
            strReqErrorMsg = 'Please fill in your Email ID.';
        }
    }
    /*
    **  this method responsible for checks whether user already exist or not    
    */
    public boolean IsUserAlreadyExist() 
    { 
            string strNetworkId=  Network.getNetworkId();
            if(strNetworkId != null)
            {
                  system.debug('=======Network ID======'+strNetworkId);
                  lstCommunity = ClickCommon.getCommunitySetup(strNetworkId);
            }
            
            List<User> lstUser;
            
            if(lstCommunity.Community_User_Name_Prefix__c != null)
            {
                lstUser = [select id,Username,Email from User where Username =: lstCommunity.Community_User_Name_Prefix__c+ strReqEmail.trim()];
            }
            else
            {
                lstUser = [select id,Username,Email from User where Username =: strReqEmail.trim()];
            }
               
            if(lstCommunity.id != null)
            {
               lstLead = [select id,Email from Lead where Email =: strReqEmail.trim() AND Community__c =: lstCommunity.id];
                system.debug('lstuser'+lstuser);
                if((lstUser != null && lstUser.size()>0) || (lstLead != null && lstLead.size()>0))
                {
                   return true;
                }
            }
            
            return false; 
    } 
    
    Public pagereference resetPopUp()
    {
        strReqErrorMsg = '';
        If(lstPersonAcc == null){
           strReqName = '';
           strReqEmail = '';
           strReqPhone = '';
        }
        isEmailVerified = false;
        return null;
    }
    
}