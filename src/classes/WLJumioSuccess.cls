/*
                WHITE LABEL
    This class is used to update the success checkbox on lead
    =========================================================
    Name                     Date                    Version
    =========================================================
    Himansu               09/30/2015                    1.0
    ========================================================= 
*/
public class WLJumioSuccess 
{
    Public String retUrlPage {get;set;}
    public string siteURL{get;set;}
    //Constructor
    public void WLJumioSuccess(){   
    }
    
    /*
        This method is used to update the success checkbox on lead
        =========================================================
        Name                     Date                    Version
        =========================================================
        Prashant               11/18/2014                    1.0
        ========================================================= 
    */
    public void UpdateSuccessOnLead()
    {
        string strUserId = UserInfo.getUserId();
        string strNetworkId = Network.getNetworkId();
        Click_Community_Setup__c objCommunitySetUp = new Click_Community_Setup__c(); 
        if(ClickCommon.getCommunitySetup(Network.getNetworkId()).Id != null)
        {
            objCommunitySetUp = ClickCommon.getCommunitySetup(Network.getNetworkId());
            siteURL = objCommunitySetUp.Click_URL__c;
        }
        if(strUserId != null && strUserId != '')
        {
            list<User> lstUser = [select id, ContactId from User where Id =: strUserId and IsActive = true];
            //String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId());
            String oppId = '';
            if(objCommunitySetUp.Click_Page_Prefix__c != null)
            {
                String OppIds = Apexpages.currentpage().getparameters().get('id');
                if(OppIds != null && OppIds != '')
                {
                    oppId = OppIds;               
                }
                else
                {
                    oppId = ClickCommon.getCurrentLoggedInOpportunityId(UserInfo.getuserId(),objCommunitySetUp.Click_Page_Prefix__c);
                }
            }
            
            If(oppId != null && oppId <> '')
            {
               String ReqdocId = Apexpages.currentpage().getparameters().get('Docid');
               system.debug('karthik@@@'+ReqdocId+'===='+ApexPages.currentPage().getUrl());
               String strTaskSubject = '';
               List<Task> lstTask = new List<Task>();
               List<Opportunity> lstOpportunity = new List<Opportunity>();
               if(ReqdocId <> null && ReqdocId <> '')
               {
                   system.debug('%%%%%%%!@#'+oppId);
                   lstOpportunity = [select id,acfIs_Identity_Document_Submitted__c,(select id,Name,acfStatus__c from Required_Documents__r where acf_Is_Identity_Verification_Doc__c = true And id=:ReqdocId) from Opportunity where id =: oppId];
                   system.debug('%%%%%%%!@#23456'+oppId);
               }
               else
               {
                   lstOpportunity = [select id,acfIs_Identity_Document_Submitted__c,(select id,Name,acfStatus__c from Required_Documents__r where acf_Is_Identity_Verification_Doc__c = true limit 1) from Opportunity where id =: oppId];

               }
               If(lstOpportunity != null && lstOpportunity.size()>0){
                   lstOpportunity[0].acfIs_Identity_Document_Submitted__c = true;
                   lstOpportunity[0].clickJumio_Status__c = 'Attempted';
                   Update lstOpportunity[0];
                   if(lstOpportunity[0].Required_Documents__r != null && lstOpportunity[0].Required_Documents__r.size()>0)
                   {
                      lstOpportunity[0].Required_Documents__r[0].acfStatus__c = 'Awaited'; 
                      update lstOpportunity[0].Required_Documents__r;
                      strTaskSubject = 'Upload '+ lstOpportunity[0].Required_Documents__r[0].Name;
                   }
                   if(strTaskSubject != null && strTaskSubject <> '')
                       lstTask = [select id,Subject,WhatId from task where WhatId =:lstOpportunity[0].id AND Subject =:strTaskSubject];
                   if(lstTask != null && lstTask.size() > 0)
                   {
                       Task objTask = new Task(Id=lstTask[0].Id);
                       objTask.status = 'Completed';
                       update objTask;
                   }
               }
               
            }
            else
            {
                if(lstUser != null && lstUser.size() > 0 && lstUser[0].ContactId != null)
                {
                    list<Lead> lstLead = [select id , acf_Contact__c,acfIs_Identity_Document_Submitted__c,(select id,acfStatus__c from Required_Documents__r where acf_Is_Identity_Verification_Doc__c = true limit 1) from Lead where acf_Contact__c =: lstUser[0].ContactId];
                    
                    if(lstLead != null && lstLead.size() > 0)
                    {
                       lstLead[0].acfIs_Identity_Document_Submitted__c = true;
                       lstLead[0].clickJumio_Status__c = 'Attempted';
                       Update lstLead[0];
                       if(lstLead[0].Required_Documents__r != null && lstLead[0].Required_Documents__r.size()>0)
                       {
                          lstLead[0].Required_Documents__r[0].acfStatus__c = 'Awaited'; 
                          update lstLead[0].Required_Documents__r;
                       }
                    }
                } 
            }
            If(oppId != null && oppId <> '')
            {
                if(strNetworkId != null && strNetworkId != '') 
                    retUrlPage = '/'+ClickCommon.getCommunitySetup(strNetworkId).Click_Page_Prefix__c+'Dashboard?id='+oppId;            
            }
            else
            {
                retUrlPage =  ClickCommon.sendReturnUrl(strUserId,false,objCommunitySetUp.Click_Page_Prefix__c+'JumioSuccess', strNetworkId);
            }
            system.debug('@@@test'+retUrlPage);
        }
    }
}