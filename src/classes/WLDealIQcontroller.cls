public class WLDealIQcontroller {
public String opportunityId{get;set;}
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
     //  getBankList();
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
                                 acfProduct__c,acfStatus__c,acfSystem_Mitigated_Notes__c,acfTrigger_String__c,acfUser__c,acfGlobal_DealIQ_Rule__r.acfRule_Description__c
                                 From acfDealIQ_Condition__c where id=:DealIqConditionIds limit 1];
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
   public Integer Debuglog  {get ;set ;} 
    public void getBankList()
        {
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://lendi-api-prod.herokuapp.com/api/v1/products?transformer=aggregation&aggregation_strategy=group_by%3Dbank%26selection%3DmaxBorrowing&application_id='+ opportunityId );
            req.setMethod('GET');
              req.setTimeout(120000);

            Http http = new Http();
            HTTPResponse res = http.send(req);
          
            Debuglog  = res.getStatusCode();
            if( res.getStatusCode() == 200){
              lstData  = new List<Bankdata >  ();
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) 
            {

                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&

                (parser.getText() == 'aggregation')) 
                {
                    parser.nextToken();
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) 
                    {
                        // debuglog =  String.valueof(parser.getCurrentToken());
                        while (parser.nextToken() != null) 
                        {
                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
                            {

                                Bankdata inv = (Bankdata )parser.readValueAs(Bankdata .class);
                                lstData.add(inv );
                               

                            }
                        }
                    }
                }
            }
            }
            else
            {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error , 'Status-Code==>'+ res.getStatusCode());
            ApexPages.addMessage(myMsg);
            }
            }
            catch (Exception E)
            {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,E.getmessage());
            ApexPages.addMessage(myMsg);
            }
        }
        
    
     
     
public List<Bankdata >     lstData {get ;set ;}
public class Bankdata {  
public  String  service_calculator_uuid {get ;set ;}

public  String  maximum_borrowing {get ;set ;}

public  Bank  Bank  {get ;set ;}


}

public class Bank 
{
public  String bank_sf_id {get ;set ;}
public  String bank_uuid {get ;set ;}
public  String bank_short_name {get ;set ;}
public  String bank_full_name {get ;set ;}


} 

public  String MESS {get ;set ;}
 public void   sendDealIqRequest(   )
    {
    String OpportunityID =opportunityId  ;
         String oppoIdString ='';
         Set<Id> setOli = new set<Id>();
        try
        {
        List<OpportUnity>  listOpportunity = [Select Id , (Select Id from  OpportUnityLineItems )  from  OpportUnity where Id = : OpportunityID] ;
        if(listOpportunity.size() > 0)
        {   String postBody ='';
           
            for( Opportunity opp :  listOpportunity )
            {
                oppoIdString = 'oppoId='+opp.id +'&';
                if( opp.OpportUnityLineItems.size() > 0)
                {
                for( OpportUnityLineItem oli  :  opp.OpportUnityLineItems )
                {
                    postBody =postBody +'oppoProductId='+oli.Id+ '&';
                    setOli.add(oli.ID);
                }
                }
                else
                {
                     postBody =postBody +'oppoProductId=1234567890&';
                }
            }
            if(postBody  != '')
            {
                postBody =postBody.substring(0, postBody.lastIndexOf('&'));
            }
            oppoIdString =  oppoIdString + postBody;
        }       
        
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://lendi-dealiq.herokuapp.com/dealiq');
            req.setMethod('POST');
            req.setBody(oppoIdString);
            HttpResponse res = h.send(req); 
            //return oppoIdString+'---'+res.getBody();
            MESS =  res.getBody();
            List<OpportunityLineItem>  listOli = new  List<OpportunityLineItem>();
            if(setOli.size() > 0)
            {
            for(Id ID : setOli)
                {
                    OpportunityLineItem obj = new OpportunityLineItem();
                    obj.ID =  id;
                    obj.Di_Response__c =res.getBody();
                    listOli.add(obj);
                }
            }
            
            if(listOli.size() > 0)
            {
                update listOli ;
            }
        }
        catch(Exception e)
        {
            //return 'Error';
        }
    }
    
    public pagereference goBack()
    {
        if(string.isNotEmpty(opportunityId))
        {
            return new pagereference('/'+opportunityId);
        }
        return null;
    }
}