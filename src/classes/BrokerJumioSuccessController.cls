public class BrokerJumioSuccessController
{
    Public String retUrlPage {get;set;}
    //Constructor
    public void BrokerJumioSuccessController()
    { 
         
      
    }
    
    public void UpdateSuccessOnLead()
    {
        string AccountIdUser = ApexPages.currentPage().getParameters().get('cid');
        if(AccountIdUser != null && AccountIdUser != '')
        {
            //list<User> lstUser = [select id, ContactId from User where Id =: logedinuserid and IsActive = true];
            list<User>  lstUser = [select Id, ContactId, Contact.acf_Lead__c from User where AccountId =: AccountIdUser and IsActive = true];
            string logedinuserid = lstUser[0].id;
            string loggedInOppId = acfCommon.getCurrentLoggedInOpportunityId(logedinuserid);
            If(loggedInOppId != null && loggedInOppId <> '')
            {
               opportunity objOpp = new opportunity(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Attempted',id= loggedInOppId);
               update objOpp;
               
              /* List<Opportunity> lstOpportunity = [select id,acfIs_Identity_Document_Submitted__c from Opportunity where id =: loggedInOppId];
               If(lstOpportunity != null && lstOpportunity.size()>0)
               {
                   lstOpportunity[0].acfIs_Identity_Document_Submitted__c = true;
                   lstOpportunity[0].clickJumio_Status__c = 'Attempted';
                   Update lstOpportunity[0];
               }*/
            }
            else
            {
                    string strLoggedInleadid = acfcommon.getCurrentLoggedInLeadId(logedinuserid);
                    lead leadObj = new lead(acfIs_Identity_Document_Submitted__c =true,clickJumio_Status__c = 'Attempted', id= strLoggedInleadid);
                    update leadObj;        
            }
            string tempretUrlPage =  acfcommon.sendReturnUrl(logedinuserid,false,'BrokerJumioSuccess');
           
            string strBaseURL = system.label.acf_Broker_Url;
            retUrlPage = strBaseURL+'/apex/Broker'+tempretUrlPage+'?cid='+AccountIdUser;
            
            //Pagereference pageref = new Pagereference('/apex/Broker'+retPgname+'?cid='+AccountIdUser);
        }
    }
}