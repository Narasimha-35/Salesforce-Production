public class WLDealIQcontroller {
public String opportunityId;
public List<Opportunity> lstopportunity{get;set;}
public List<acfDealIQ_Condition__c> lstDealIqCondition{get;set;}
public Boolean creditGuide{get;set;}
public Boolean creditProposalDisclosure{get;set;}
public Boolean preliminaryAssesment{get;set;}
public String creditGuideId{get;set;}
public String creditProposalDisclosureId{get;set;}
public String preliminaryAssesmentId{get;set;}
public acfDealIQ_Condition__c objDealIqCondition{get;set;}
    public WLDealIQcontroller () {
       opportunityId = '';
       creditGuide = false;
       creditProposalDisclosure =false;
       preliminaryAssesment = false;
       creditGuideId = '';
       creditProposalDisclosureId = '';
       preliminaryAssesmentId = '';
       lstopportunity = new List<Opportunity>();
       lstDealIqCondition = new List<acfDealIQ_Condition__c>();
       opportunityId = ApexPages.currentPage().getParameters().get('id');
       List<EmailHistory__c> lstEmailHistory = new List<EmailHistory__c>();
       Set<Id> setOfEmailHistoryId= new Set<Id>();
       List<S3Document__c> lstS3Doc = new List<S3Document__c>();
       if(opportunityId != null && opportunityId != '')
       {
           lstopportunity = [SELECT Id, Name ,amount ,(SELECT Id,Name,acfClick_Loans_Bank_Detail__c,acfClick_Loans_Suggested_Product__c,acfComments__c,
                             acfCondition_Closed_DateTime__c,acfOpportunity__c,acfGlobal_DealIQ_Rule__c,acfGlobal_DealIQ_Rule__r.Category__c,acfCategory__c,
                             acfProduct__c,acfStatus__c,acfSystem_Mitigated_Notes__c,acfTrigger_String__c,acfUser__c FROM acf_DealIQ_Conditions__r),(SELECT Id,
                             Description,IsDeleted,ListPrice,Name,OpportunityId,ProductCode,Quantity,ServiceDate,SortOrder,TotalPrice,UnitPrice
                             FROM OpportunityLineItems),(select id,Max_Borrowing_Power__c,Net_Monthly_Surplus__c,Opportunity__c,Services_Funds_Requested__c,
                             Services_Funds_Required__c from Servicing_Calculators__r),(select id,Name,AcfOpportunity__c,subject__c from Email_History__r Order By createddate DESC)
                             FROM Opportunity WHERE Id =:Id.valueof(opportunityId)];
                            
           if(lstopportunity != null && !lstopportunity.Isempty())  
           {
               for(Opportunity objOpp : lstopportunity)
               {
                   if(objOpp.Email_History__r != null && !objOpp.Email_History__r.isEmpty())
                   {
                       for(EmailHistory__c objEmailHistory : objOpp.Email_History__r)
                       {
                           lstEmailHistory.add(objEmailHistory); 
                           setOfEmailHistoryId.add(objEmailHistory.id);    
                       }
                   }
               }
           }   
           
           if(lstEmailHistory != null && !lstEmailHistory.isEmpty()) 
           {
               lstS3Doc = [select id,Name,emailHistory__c from S3Document__c where emailHistory__c =:setOfEmailHistoryId Order By createddate ASC];
               if(lstS3Doc != null && !lstS3Doc.IsEmpty())
               {
                   for(S3Document__c objS3Doc : lstS3Doc)
                   {
                       if(objS3Doc.Name.containsIgnoreCase('CreditGuide'))
                       {
                           creditGuide = true;
                           creditGuideId = '/'+objS3Doc.emailHistory__c;
                       }
                       else if(objS3Doc.Name.containsIgnoreCase('CreditProposal'))
                       {     
                           creditProposalDisclosure = true;
                           creditProposalDisclosureId = '/'+objS3Doc.emailHistory__c;
                       }
                       else if(objS3Doc.Name.containsIgnoreCase('Preliminary'))     
                       {
                           preliminaryAssesment = true;
                           preliminaryAssesmentId = '/'+objS3Doc.emailHistory__c;
                       }       
                   }
               }
           }                                                      
       }
    }
    //========================================================================================================
    // This Method is used to get Deal IQ Record when we click on Mitigate or View Button.
    //========================================================================================================
    public void DealIqRecord()
    {
        string DealIqConditionIds = Apexpages.currentPage().getParameters().get('DealIqIds');
        system.debug('DealIqConditionIds*****************'+DealIqConditionIds);
        if(DealIqConditionIds != null && DealIqConditionIds != '')
        {
           lstDealIqCondition = [SELECT Id,Name,acfClick_Loans_Bank_Detail__c,acfClick_Loans_Suggested_Product__c,acfComments__c,acfCondition_Closed_DateTime__c,
                                 acfOpportunity__c,acfGlobal_DealIQ_Rule__c,acfGlobal_DealIQ_Rule__r.Name,acfGlobal_DealIQ_Rule__r.Category__c,acfCategory__c,
                                 acfProduct__c,acfStatus__c,acfSystem_Mitigated_Notes__c,acfTrigger_String__c,acfUser__c From acfDealIQ_Condition__c
                                 where id=:DealIqConditionIds limit 1];
           system.debug('lstDealIqCondition *****************'+lstDealIqCondition);
        }
    }
    
    //========================================================================================================
    // This Method is used to update Deal IQ Record when we click on Mitigate or View Button.
    //========================================================================================================
    public pagereference updateDealIqRecord()
    {
        if(lstDealIqCondition != null && lstDealIqCondition.size() > 0)
        {
            acfDealIQ_Condition__c objDealIqCondition = new acfDealIQ_Condition__c(id=lstDealIqCondition[0].id);
            objDealIqCondition.acfStatus__c = 'Mitigated';
            objDealIqCondition.acfComments__c = lstDealIqCondition[0].acfComments__c;
            update objDealIqCondition;
            system.debug('objDealIqCondition************'+objDealIqCondition);
            pagereference pg = new pagereference('/apex/AcfDealIQ?id='+opportunityId);  
            pg.setredirect(true); 
            return pg;
        }
        return null;
    }
}