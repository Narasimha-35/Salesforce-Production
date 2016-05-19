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
        addDocumentSchema(triggerNew,triggerOld);
    }
    
    public void OnBeforeInsert(List<Required_Document__c>triggerNew)
    {
        updateDownloadLinkonRequiredDocument(triggerNew);
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

    //Added By Manish for adding Document Schema under Document Master
    public void addDocumentSchema(List<Required_Document__c>triggerNew,Map<Id,Required_Document__c> triggerOld){
        Set<id> docMasterId = new Set<id>();
        for(Required_Document__c objReqDoc:triggerNew){
            if(!docMasterId.contains(objReqDoc.acfDocument_Master__c)){
                docMasterId.add(objReqDoc.acfDocument_Master__c);
            }
        }
        

        Map<Id,List<Document_Schema__c>> docSchemaMasterMap = new Map<Id,List<Document_Schema__c>>();
        
        List<Document_Schema__c> docSchemaList = new List<Document_Schema__c>();
        
        
        docSchemaList = [Select id,Click_Loans_Document_Master__c,Name,
                                Click_Loans_Required_Document__c,Field_Display_Name__c,Field_Value__c 
                                FROM Document_Schema__c where Click_Loans_Document_Master__c IN:docMasterId];
        system.debug('###docSchema'+docSchemaList);
                                
        for(Document_Schema__c dSchema:docSchemaList){
            if(!docSchemaMasterMap.containsKey(dSchema.Click_Loans_Document_Master__c)){
                docSchemaMasterMap.put(dSchema.Click_Loans_Document_Master__c,new List<Document_Schema__c>());
            }
            docSchemaMasterMap.get(dSchema.Click_Loans_Document_Master__c).add(dSchema);
        }
        
        docSchemaList.clear();
        
        for(Required_Document__c objReqDoc:triggerNew)
        {
            if(objReqDoc.acfDocument_Master__c <> null && docSchemaMasterMap <> null && docSchemaMasterMap.size() > 0
            && docSchemaMasterMap.get(objReqDoc.acfDocument_Master__c) <> null
               && docSchemaMasterMap.get(objReqDoc.acfDocument_Master__c).size() > 0 
               )
              {
                    for(Document_Schema__c docMap:docSchemaMasterMap.get(objReqDoc.acfDocument_Master__c))
                    {
                        Document_Schema__c dSchemaObj = new Document_Schema__c();
                        dSchemaObj.Name = docMap.Name;
                        dSchemaObj.Click_Loans_Required_Document__c = objReqDoc.id;
                        dSchemaObj.Field_Display_Name__c = docMap.Field_Display_Name__c;
                        dSchemaObj.Field_Value__c =  docMap.Field_Value__c;
                        docSchemaList.add(dSchemaObj);
                    }
              }
        }
        
        if(docSchemaList.size() > 0)
            insert docSchemaList;
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
             list<Opportunity> lstOpp = [select id,recordtype.name,account.click_Is_Required_Document_Sent__c,(select id,acfOpportunity__c,acfStatus__c from Required_Documents__r 
                                         where acfStatus__c != 'Uploaded' AND acfStatus__c != 'Verified') from Opportunity where id IN: setOppId 
                                         AND account.click_Is_Required_Document_Sent__c = false];
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
      
      public void updateDownloadLinkonRequiredDocument(List<Required_Document__c> triggerNew)
      {
          map<id,string> mapIdToSource = new map<id,string>();
          set<id> setOfDocId = new set<id>();
          for(Required_Document__c objRequiredDocs : triggerNew)
          {
              if(objRequiredDocs.acfDocument_Master__c <> null)
              {
                  setOfDocId.add(objRequiredDocs.acfDocument_Master__c);
              }
          }
          
          List<Document_Master__c> lstDocumentMaster = [select id,acf_Source__c from Document_Master__c where id in:setOfDocId];
          
          if(lstDocumentMaster <> null && lstDocumentMaster.size() > 0)
          {
              for(Document_Master__c objDocMas : lstDocumentMaster )
              {
                  mapIdToSource.put(objDocMas.id,objDocMas.acf_Source__c );
              }
          }
          
          for(Required_Document__c objRD : triggernew)
          {
              if(objRD.acfDocument_Master__c<> null && mapIdToSource.containskey(objRD.acfDocument_Master__c))
              {
                  if(mapIdToSource.get(objRD.acfDocument_Master__c) == 'Note')
                  {
                      objRD.Click_Is_Note_Type__c = true;  
                  }
                  else if(mapIdToSource.get(objRD.acfDocument_Master__c) == 'Download Link')
                  {
                      objRD.Is_Download_Doc__c = true;  
                  }
                  
              }
          }
      }
}