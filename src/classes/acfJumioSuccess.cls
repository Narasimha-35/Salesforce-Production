/*
  				Click Loans
    This class is used to update the success checkbox on lead
    =========================================================
    Name                     Date                    Version
    =========================================================
    Prashant               11/18/2014                    1.0
    ========================================================= 
*/
public class acfJumioSuccess 
{
    Public String retUrlPage {get;set;}
    //Constructor
    public void acfJumioSuccess(){   
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
        if(strUserId != null && strUserId != '')
        {
            list<User> lstUser = [select id, ContactId from User where Id =: strUserId and IsActive = true];
            String oppId = acfCommon.getCurrentLoggedInOpportunityId(userInfo.getuserId());
            If(oppId != null && oppId <> ''){
               List<Opportunity> lstOpportunity = [select id,acfIs_Identity_Document_Submitted__c from Opportunity where id =: oppId];
               If(lstOpportunity != null && lstOpportunity.size()>0){
                   lstOpportunity[0].acfIs_Identity_Document_Submitted__c = true;
                   lstOpportunity[0].clickJumio_Status__c = 'Attempted';
                   Update lstOpportunity[0];
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
                           retUrlPage =  acfcommon.sendReturnUrl(strUserId,false,'acfJumioSuccess');
                        }
                    } 
            }
        }
    }
}