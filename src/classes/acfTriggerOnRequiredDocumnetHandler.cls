/*====================================================
                Click Loans
========================================================*/
public  class acfTriggerOnRequiredDocumnetHandler 
{
    public set<id> setoppIds;
    
    public void onAfterUpdate(List<Required_Document__c>triggerNew,Map<Id,Required_Document__c> triggerOld)
    {
        InsertTaskOfRequiredDocumentForSelectedOpportunity(triggerNew,triggerOld);
        setOppIds = new set<id>();
        for(Required_Document__c ObjReqDoc : triggerNew)
        {
          if(ObjReqDoc.acfOpportunity__c != triggerOld.get(ObjReqDoc.id).acfOpportunity__c || ObjReqDoc.acfStatus__c != triggerOld.get(ObjReqDoc.id).acfStatus__c) 
           setoppIds.add(ObjReqDoc.acfOpportunity__c);
        }
        updateCountOfDocsOnOpp(setoppIds);
    }
    public void OnAfterInsert(List<Required_Document__c>triggerNew,Map<Id,Required_Document__c> triggerOld)
    {
        InsertTaskOfRequiredDocumentForSelectedOpportunity(triggerNew,triggerOld);
    }
    public void OnAfterDelete(List<Required_Document__c> triggerOld)
    {
        setoppIds = new set<id>();
        for(Required_Document__c ObjReqDoc : triggerOld)
        {
          if(ObjReqDoc.acfStatus__c != 'Uploaded' && ObjReqDoc.acfStatus__c != 'Verified')
          {
              setoppIds.add(ObjReqDoc.acfOpportunity__c);    
          }         
        }
        updateCountOfDocsOnOpp(setoppIds);
    }
    
    //Create Task For Selected Opportunity
    public void InsertTaskOfRequiredDocumentForSelectedOpportunity(List<Required_Document__c>triggerNew,Map<Id,Required_Document__c> triggerOld)
    {
        List<Task>lstTaskToInsert = new List<Task>();
        set<Id>setOpportunityId = new set<Id>();
        set<string>setTaskName = new set<string>();
        
        for(Required_Document__c objRequiredDoc:triggerNew)
        {
            //system.debug('***triggerOld.get(objRequiredDoc.id).acfOpportunity__c'+triggerOld.get(objRequiredDoc.id).acfOpportunity__c);
            if((objRequiredDoc.acfOpportunity__c <> null && triggerOld <> null && triggerOld.get(objRequiredDoc.id) <> null && triggerOld.get(objRequiredDoc.id).acfOpportunity__c == null)||
                (objRequiredDoc.acfOpportunity__c <> null && triggerOld == null))
            {   
                Task objTask                    =   new Task();
                objTask.Description             =   'Upload '+objRequiredDoc.Name;
                objTask.WhatId                  =   objRequiredDoc.acfOpportunity__c;
                system.debug('@@@@karthik@@'+objRequiredDoc.acfOpportunity__r.acfBankdetailStatus__c+'==='+objRequiredDoc.acfOpportunity__r.clickJumio_Status__c );
                objTask.Status                  =   'open';
                objTask.Priority                =   'Normal';
                objTask.ActivityDate            =   system.Today();
                objTask.IsVisibleInSelfService  =   true;
                objTask.subject                 =   'Upload '+objRequiredDoc.Name;
                objTask.acf_Is_Upload_Identity_Verification__c = false;
                objTask.acf_Is_Upload_Bank_Stmt__c   = false;
                if(objRequiredDoc.acf_Is_Identity_Verification_Doc__c)
                  objTask.acf_Is_Upload_Identity_Verification__c = true;
                else if(objRequiredDoc.acf_Bank_Statement_Doc__c)
                  objTask.acf_Is_Upload_Bank_Stmt__c   = true;
                lstTaskToInsert.add(objTask);
            }
            else if(objRequiredDoc.acfOpportunity__c <> null && triggerOld <> null && triggerOld.get(objRequiredDoc.id) <> null && triggerOld.get(objRequiredDoc.id).acfOpportunity__c <> objRequiredDoc.acfOpportunity__c)
            {
                setOpportunityId.add(triggerOld.get(objRequiredDoc.id).acfOpportunity__c);
                setTaskName.add('Upload '+triggerOld.get(objRequiredDoc.id).Name);
                Task objTask                    =   new Task();
                objTask.Description             =   'Upload '+objRequiredDoc.Name;
                objTask.WhatId                  =   objRequiredDoc.acfOpportunity__c;     
                objTask.Status                  =   'open';
                objTask.Priority                =   'Normal';
                objTask.ActivityDate            =   system.Today();
                objTask.IsVisibleInSelfService  =   true;
                objTask.subject                 =   'Upload '+objRequiredDoc.Name;
                objTask.acf_Is_Upload_Identity_Verification__c = false;
                objTask.acf_Is_Upload_Bank_Stmt__c   = false;
                if(objRequiredDoc.acf_Is_Identity_Verification_Doc__c)
                  objTask.acf_Is_Upload_Identity_Verification__c = true;
                else if(objRequiredDoc.acf_Bank_Statement_Doc__c)
                  objTask.acf_Is_Upload_Bank_Stmt__c   = true;
                lstTaskToInsert.add(objTask);
            }
            else if(triggerOld <> null &&  triggerOld.get(objRequiredDoc.id) <> null && triggerOld.get(objRequiredDoc.id).acfOpportunity__c <> null && objRequiredDoc.acfOpportunity__c == null)
            {
                setOpportunityId.add(triggerOld.get(objRequiredDoc.id).acfOpportunity__c);
                setTaskName.add('Upload '+triggerOld.get(objRequiredDoc.id).Name);
            }
        }
        system.debug('@#$%'+setOpportunityId+'!@#$%^'+setTaskName);
        if(setOpportunityId <> null && setOpportunityId.size()>0 && setTaskName <> null && setTaskName.size()>0)
        {
            List<Task>lstTaskToDelete = [select id from task where WhatId in:setOpportunityId and subject in:setTaskName];
            if(lstTaskToDelete <> null && lstTaskToDelete.size()>0)
            {
                delete lstTaskToDelete;
            }
        }
        if(lstTaskToInsert <> null && lstTaskToInsert.size()>0)
        {
            insert lstTaskToInsert;
        }
    }
    
    //Added on 05-11-2015 regarding CLS-73 pointer  
    public void updateCountOfDocsOnOpp(set<id> setOppId)
    {
        if(setOppId != null && setOppId.size()>0)
        { 
             list<Opportunity> lstOpp = [select id,recordtype.name,(select id,acfOpportunity__c,acfStatus__c from Required_Documents__r 
                                         where acfStatus__c != 'Uploaded' AND acfStatus__c != 'Verified') from Opportunity where id IN: setOppId 
                                         AND recordtype.name = 'Click Refi'];
             if(lstOpp != null && lstOpp.size()>0)
             {
                 for(Opportunity objOpp : lstOpp)
                 {
                     if(objOpp.Required_Documents__r == null)
                     {
                       objOpp.Click_No_Of_Pending_Docs__c = 0;
                     }
                     else if(objOpp.Required_Documents__r != null && objOpp.Required_Documents__r.size()>0)
                     {
                       objOpp.Click_No_Of_Pending_Docs__c = objOpp.Required_Documents__r.size();          
                     }
                 }
                 Update lstOpp;
              }
         }
      }
}