/*====================================================
                Click Loans
========================================================*/
trigger acfLeadConvertTrigger on Lead (before insert,before update,after update) 
{

     LeadStatus convertStatus = [select MasterLabel from LeadStatus where IsConverted = true limit 1];
     List<Database.LeadConvert> List_leadConverts = new List<Database.LeadConvert>();
     Set<Id> Set_convertedLeadIds = new Set<Id>();
     Set<Id> setConvertedOppIds = new Set<Id>();
     Map<Id,Id> Map_leadOppIds = new Map<Id,Id>();
     map<Id,Id> map_leadAccIds = new map<Id,Id>();
     List<Required_Document__c> List_reqDocs = new List<Required_Document__c>();
     List<Required_Document__c> List_updatedReqDocs = new List<Required_Document__c>();
     List<acfSuggested_Product__c> List_suggestedProd = new List<acfSuggested_Product__c>();
     List<acfSuggested_Product__c> List_updatedSuggestedProd = new List<acfSuggested_Product__c>();
     List<case> lstCase = new List<case>();
     list<case> lstUpdatedCase = new list<case>();
     
     //List<Lead> lstClickLeads = [select id,Click_Lead_Number__c,ownerId from lead where Isdeleted = false AND (recordtype.Name = 'Click New Loans' OR recordtype.Name = 'Click Refi') order by createddate DESC limit 1];
    // Map<ID,RecordType> maIdTopRecordType = New Map<ID,RecordType>([Select ID, Name From RecordType Where sObjectType = 'Lead']);
     decimal clickLeadNumber = 0; 
     decimal clickLeadNoCheck = 0;
     List<MortgageExpert__c> List_mExpert = MortgageExpert__c.getall().values();
     List<Click_Lead_Information__c> lstLeadInfo = Click_Lead_Information__c.getall().values();
     List<Account> lstToupdateAccOwner = new List<Account>(); 
     map<id,id> mapAccIdToOwnerId = new map<id,id>(); 
     if(lstLeadInfo != null && lstLeadInfo.size()>0)
     {
       if(lstLeadInfo[0].click_Recent_Lead_Number__c != null)
        clickLeadNumber = lstLeadInfo[0].click_Recent_Lead_Number__c;
        clickLeadNoCheck = clickLeadNumber;
     }
     
     Id ClickLeadRefiRecordTypeId = acfCommon.GetRecordTypeId('Lead','Click Refi');
     Id ClickLeadNewLoanRecordTypeId = acfCommon.GetRecordTypeId('Lead','Click New Loans');
     for (Lead leadObj: Trigger.new)
     {
         //round robin assignment
         if(trigger.isbefore&&trigger.isinsert)
         {
           if((leadObj.RecordTypeId == ClickLeadRefiRecordTypeId || leadObj.RecordTypeId == ClickLeadNewLoanRecordTypeId)&&(leadObj.acfIsCreatedViaRequestCall__c == true || leadObj.acfIs_User_Registered__c == true))
           {
            leadObj.Click_Lead_Number__c = clickLeadNumber + 1;
            clickLeadNumber = clickLeadNumber+1;
           }
         }
        
         If(trigger.isBefore && trigger.isUpdate && !leadObj.isConverted && leadObj.acfIs_Bank_Statement_Submitted__c == true && leadObj.acfIs_Post_Login_Ques_Attempted__c == true && leadObj.acfIs_Identity_Document_Submitted__c == true){
          
          String strUserId = leadObj.ownerId;
          If(!List_mExpert.isEmpty() && strUserId.startsWith('00G')){ leadObj.ownerId = List_mExpert[0].User_ID__c;}
         }else{
          if (trigger.isAfter && !leadObj.isConverted && leadObj.acfIs_Bank_Statement_Submitted__c == true && leadObj.acfIs_Post_Login_Ques_Attempted__c == true && leadObj.acfIs_Identity_Document_Submitted__c == true) {

               Database.LeadConvert lc = new Database.LeadConvert();
               String oppName = leadObj.Name;
               lc.setLeadId(leadObj.Id);   
               lc.setAccountId(leadObj.acf_partner_account__c);          
               lc.setOpportunityName(oppName);
               lc.setConvertedStatus(convertStatus.MasterLabel);
               List_leadConverts.add(lc);
          }
        }
     }
     
     if(lstLeadInfo != null && lstLeadInfo.size()>0 && clickLeadNoCheck < clickLeadNumber)
     {
         lstLeadInfo[0].click_Recent_Lead_Number__c = clickLeadNumber;
         update lstLeadInfo;
     }
     
     if(trigger.isAfter)
     {
         if (List_leadConverts != null && !List_leadConverts.isEmpty()) 
         {
              List<Database.LeadConvertResult> lcr = Database.convertLead(List_leadConverts);
         }    
         for(Lead leadObj: Trigger.new) 
         {
             If (leadObj.IsConverted && !trigger.oldmap.get(leadObj.id).IsConverted) 
             {
               Set_convertedLeadIds.add(leadObj.id);  
               Map_leadOppIds.put(leadObj.id,leadObj.ConvertedOpportunityId);
               map_leadAccIds.put(leadObj.id,leadObj.convertedAccountId);
               setConvertedOppIds.add(leadObj.ConvertedOpportunityId);
             }
             //To update account owner
             If(leadObj.acf_partner_account__c != null && trigger.oldMap != null && (leadObj.OwnerId != trigger.oldMap.get(leadObj.id).OwnerId || leadObj.acf_partner_account__c != trigger.oldMap.get(leadObj.id).acf_partner_account__c))
             {
                 mapAccIdToOwnerId.put(leadObj.acf_partner_account__c,leadObj.ownerId);
             }
         }  
         
         if(mapAccIdToOwnerId != null && mapAccIdToOwnerId.size()>0)
         {
             for(id accId : mapAccIdToOwnerId.keyset())
             {
                 Account objAccount = new Account(id = accId);
                 objAccount.ownerId = mapAccIdToOwnerId.get(accId);
                 lstToupdateAccOwner.add(objAccount);
             }
         }
         if(lstToupdateAccOwner != null && lstToupdateAccOwner.size()>0)
         {
             update lstToupdateAccOwner;
         } 
          
          
         List_reqDocs = [select id,Lead__c,acfOpportunity__c,acfStatus__c from Required_Document__c where Lead__c IN : Set_convertedLeadIds];
         List_suggestedProd = [select id,acfLead__c,acfOpportunity__c from acfSuggested_Product__c where acfLead__c IN : Set_convertedLeadIds];
         lstCase = [select id,Lead__c,accountId from case where Lead__c IN : Set_convertedLeadIds];
         system.debug('karthik@@@'+List_suggestedProd);
         If(List_reqDocs != null && !List_reqDocs.isEmpty())
         {
             for(Required_Document__c docObj : List_reqDocs)
             {
                   docObj.acfOpportunity__c = Map_leadOppIds.get(docObj.Lead__c);
                   List_updatedReqDocs.add(docObj);
             }
         }   
         If(List_suggestedProd !=null && !List_suggestedProd.isEmpty())
         {
             for(acfSuggested_Product__c prodObj : List_suggestedProd)
             {
                 prodObj.acfOpportunity__c = Map_leadOppIds.get(prodObj.acfLead__c);
                 List_updatedSuggestedProd.add(prodObj);
             }
         } 
         if(lstCase != null && lstCase.size()>0)
         {
             for(case objCase : lstCase)
             {
                 objCase.accountId = map_leadAccIds.get(objCase.Lead__c);
                 lstUpdatedCase.add(objCase);
             }
         } 
         If(List_updatedReqDocs != null && !List_updatedReqDocs.isEmpty())
         {
             update List_updatedReqDocs;
             if(setConvertedOppIds != null && setConvertedOppIds.size()>0)
             {
                 list<opportunity> lstOpp = [select id,clickJumio_Status__c,acfBankdetailStatus__c from opportunity where id IN:setConvertedOppIds];
                 if(lstOpp != null && lstOpp.size()>0)
                 {
                   acfTriggerOnOpportunityHandler objTrgOppHandler = new acfTriggerOnOpportunityHandler();
                   objTrgOppHandler.updateExistingTaskStatus(lstOpp);
                 }
            }
         }
         If(List_updatedSuggestedProd != null && !List_updatedSuggestedProd.isEmpty())
         {
             update List_updatedSuggestedProd;
         }
         if(lstUpdatedCase != null && lstUpdatedCase.size()>0)
         {
             update lstUpdatedCase;
         }
     }
}