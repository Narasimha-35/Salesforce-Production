//class is used to update econsent on applicant object  modified by karthik on 22-03-2016
public class acfIConsentController 
{
    public string message{get;set;}
    public boolean isSubmited{get;set;}
    public boolean isExpired{get;set;}
    public string UserAccountId{get;set;}
    private string applicantNumber{get;set;} 
    public click_Applicant__c objAppToUpdate;
    public string applicantId;
    public boolean acfCommunity{get;set;}
    //constructor
    public acfIConsentController ()
    {
        acfCommunity = false;
        Click_Community_Setup__c objCommunity = ClickCommon.getCommunitySetup(Network.getNetWorkId());
        if(objCommunity.Click_Page_Prefix__c == 'ACF'){
            acfCommunity = true;
        }
        long currentTime=System.currentTimeMillis();
        Blob cryptoKey1 = Blob.valueOf('380db410e8b11fa9');        
        Blob EconsentIdBlob =EncodingUtil.base64decode(ApexPages.currentPage().getParameters().get('EconsentId'));
        Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey1, EconsentIdBlob );
        string decryptedString=decryptedData.tostring();                  
        string[] arrTest = decryptedString.split('-');      
        long sessionTime=long.ValueOf(arrTest[0]);
        UserAccountId=arrTest[1];
        applicantNumber=arrTest[2];
        system.debug('###values'+UserAccountId);
        system.debug('###values'+applicantNumber);
        objAppToUpdate = new click_Applicant__c();   
        list<Account> lstAccts = WLpostloginQuestionsController.getlstusrAccounts(Id.valueof(UserAccountId));
        system.debug('###lst'+lstAccts);
        applicantId = '';
       
        if(lstAccts != null && lstAccts.size()>0)
        {
            for(click_Applicant__c objApplicant : [select id,acfEconsent__c from click_Applicant__c where id=:applicantNumber])
            { 
                if(objApplicant.id == applicantNumber)
                {
                    objAppToUpdate = objApplicant;
                    if(objApplicant.acfEconsent__c == 'I Consent')
                        isSubmited=true; 
                }
            }
        }     
        EconsentTime__c timeCheck=EconsentTime__c.getValues('timerone');
        if(currentTime-sessionTime >(timeCheck.minutes__c*60000) )
        {
           isExpired=true;           
        }      
    }    
    //to update econsent on object
    public void updateConsentScreen()
    {   
        try
        {    
            if(objAppToUpdate <> null)
            {
                String ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                objAppToUpdate.acfEconsent__c = 'I Consent';
                applicantId = objAppToUpdate.id; 
                update objAppToUpdate;
                isSubmited=true;
                
                List<E_Consent__c> eConsentList = [Select id,Consent_IP__c,Consent_Method__c,Applicant__c FROM E_Consent__c where Applicant__c=:applicantId];  
                system.debug('##econs'+eConsentList);
                if(eConsentList.size() > 0){
                    eConsentList[0].Consent_IP__c = ipAddress;
                    eConsentList[0].Consent_Method__c = 'Verify from SMS/Email';
                    update eConsentList;
                }
            } 
            
            
        }
        catch(exception ex)
        {
            ApexPages.addMessages(ex);  
        }
    }
}