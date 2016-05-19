//class is used to update econsent on applicant object  modified by karthik on 22-03-2016
public class acfIConsentController 
{
    public string message{get;set;}
    public boolean isSubmited{get;set;}
    public boolean isExpired{get;set;}
    public string UserAccountId{get;set;}
    private string applicantNumber{get;set;} 
    public click_Applicant__c objAppToUpdate;
    //constructor
    public acfIConsentController ()
    {              
        long currentTime=System.currentTimeMillis();
        Blob cryptoKey1 = Blob.valueOf('380db410e8b11fa9');        
        Blob EconsentIdBlob =EncodingUtil.base64decode(ApexPages.currentPage().getParameters().get('EconsentId'));
        Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey1, EconsentIdBlob );
        string decryptedString=decryptedData.tostring();                  
        string[] arrTest = decryptedString.split('-');      
        long sessionTime=long.ValueOf(arrTest[0]);
        UserAccountId=arrTest[1];
        applicantNumber=arrTest[2];
        objAppToUpdate = new click_Applicant__c();   
        list<Account> lstAccts = acfpostloginQuestionsController_partner.getlstusrAccounts(Id.valueof(UserAccountId));
        if(lstAccts != null && lstAccts.size()>0)
        {
            for(click_Applicant__c objApplicant : lstAccts[0].Applicants__r)
            { 
                if(objApplicant.click_Applicant_Number__c == applicantNumber)
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
                objAppToUpdate.acfEconsent__c = 'I Consent';
                update objAppToUpdate;
                isSubmited=true;
            } 
        }
        catch(exception ex)
        {
            ApexPages.addMessages(ex);  
        }
    }
}