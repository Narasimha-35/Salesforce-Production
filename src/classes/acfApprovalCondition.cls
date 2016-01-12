/*====================================================
				Click Loans
========================================================*/
public class acfApprovalCondition 
{
    public List<selectOption> lstDocumentsList{get;set;}
    public List<string>lstRequiredDocList{get;set;}
    public boolean isInEditMode{get;set;}
    public boolean IsShowDocument{get;set;}
    public Opportunity objOpportunity{get;set;}
    Public String strApprovalCondition {get;set;}

    public acfApprovalCondition(ApexPages.StandardController controller) 
    {
        lstDocumentsList = new list<selectOption>(); 
        isInEditMode = false;
        IsShowDocument = false;
        strApprovalCondition = '';
        objOpportunity = (Opportunity)controller.getRecord();
        
        List<Document_Master__c> lstDocMaster = [select id, Name from Document_Master__c];
        
        if(lstDocMaster != null && lstDocMaster.size() > 0)
        {
            for(Document_Master__c objDocMaster : lstDocMaster)
            {
                lstDocumentsList.add(new SelectOption(objDocMaster.Id, objDocMaster.Name));
            }
        }
        if(objOpportunity.acfConditions_of_Approval__c == 'Text and Document')
           IsShowDocument = true;
    }
    
    public void ShowEditable()
    {
        isInEditMode = true;
        if(objOpportunity.acfConditions_of_Approval__c == 'Text and Document')
           IsShowDocument = true;
    }
    
    public void MakeUnEditable()
    {
        isInEditMode = false;
    }
    public void ShowDocumentSection()
    {
       system.debug('@#$%^'+objOpportunity.acfConditions_of_Approval__c);
       if(objOpportunity.acfConditions_of_Approval__c == 'Text and Document')
           IsShowDocument = true;
       else
           IsShowDocument = false;    
       
    }
    
    public void UpdateCondition()
    {
        isInEditMode = false;
        set<string>setDocumentMasterId = new set<string>();
        List<Required_Document__c>lstRequiredDocToUpdate = new List<Required_Document__c>();
        List<Required_Document__c>lstRequiredDocToInsert = new List<Required_Document__c>();
        system.debug('@#$'+lstRequiredDocList+'@#$%^&'+objOpportunity.acfConditions_of_Approval__c);
        if(objOpportunity.acfConditions_of_Approval__c == 'Text and Document')
        {
            if(lstRequiredDocList <> null && lstRequiredDocList.size()>0)
            {
                for(string objDocmasterId : lstRequiredDocList)
                {
                   setDocumentMasterId.add(objDocmasterId);
                }
                if(setDocumentMasterId.size()>0 && objOpportunity.id <> null)
                {
                    for(Required_Document__c objRequiredDoc:[select id,acfStatus__c,acfOpportunity__c,acfDocument_Master__c from Required_Document__c where acfOpportunity__c =:objOpportunity.id])
                    {
                        if(setDocumentMasterId.contains(objRequiredDoc.acfDocument_Master__c))
                        {
                           Required_Document__c objRequiredDocToUpdate = new Required_Document__c(id=objRequiredDoc.id);
                           objRequiredDocToUpdate.acfStatus__c = 'Pending';
                           lstRequiredDocToUpdate.add(objRequiredDocToUpdate);
                           setDocumentMasterId.remove(objRequiredDoc.acfDocument_Master__c);
                        }
                    }
                    for(Document_Master__c objDocMaster:[select id,Name,acfDescription__c,acf_Source__c,acfActive__c from Document_Master__c where acfActive__c = true and id in:setDocumentMasterId])
                    {
                       Required_Document__c objRequiredDoc  = new Required_Document__c();
                       objRequiredDoc.Name                  = objDocMaster.Name; 
                       objRequiredDoc.acfOpportunity__c     = objOpportunity.id;
                       objRequiredDoc.acfDocument_Master__c = objDocMaster.id;
                       objRequiredDoc.acfStatus__c          = 'Pending';
                       lstRequiredDocToInsert.add(objRequiredDoc);
                    }
                }
                if(lstRequiredDocToInsert.size()>0)
                {
                    insert lstRequiredDocToInsert;
                } 
                if(lstRequiredDocToUpdate.size()>0)
                {
                     update lstRequiredDocToUpdate;
                }
                objOpportunity.acfApproval_Conditions__c = strApprovalCondition;
                update objOpportunity;          
            }
            else
            {
                  isInEditMode = true;
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select document to insert'));
            }               
        }
        else if(objOpportunity.acfConditions_of_Approval__c == 'Text')
        {
             
              
             objOpportunity.acfApproval_Conditions__c = strApprovalCondition;
             update objOpportunity;
             string HTML_TAG_PATTERN = '<.*?>';  
             pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
             matcher myMatcher = myPattern.matcher(strApprovalCondition);   
             string strTsksubject = myMatcher.replaceAll('');             
             Task objTask                   = new Task();
             objTask.Description            = objOpportunity.acfApproval_Conditions__c;
             objTask.WhatId                 = objOpportunity.id;    
             objTask.Status                 = 'open';
             objTask.Priority               = 'Normal';
             objTask.ActivityDate           = system.Today();
             objTask.IsVisibleInSelfService = true;
             objTask.subject                = strTsksubject;
             insert objTask;
        }
    }
}