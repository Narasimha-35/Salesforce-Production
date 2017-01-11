//class is used to update econsent on applicant object  modified by karthik on 22-03-2016
public class ProductConsentController 
{
    public string message{get;set;}
    public boolean isSubmited{get;set;}
    public boolean isExpired{get;set;}
    public string applicantId{get;set;}
    public string Bankid {get;set;} 
    public string reqDocID {get;set;} 
     public string EconID {get;set;} 
    public click_Applicant__c objAppToUpdate;
    public String BankText {get ;set ;} 
    public boolean acfCommunity{get;set;}
    //constructor
    public ProductConsentController ()
    {
        acfCommunity = false;
        Click_Community_Setup__c objCommunity = ClickCommon.getCommunitySetup(Network.getNetWorkId());
        if(objCommunity.Click_Page_Prefix__c == 'ACF'){
            acfCommunity = true;
        }
        long currentTime=System.currentTimeMillis();
        Blob cryptoKey1 = Blob.valueOf('380db410e8b11fa9');
        Blob EconsentIdBlob;
        string decryptedString = '';
        if(!Test.isRunningTest()){        
            EconsentIdBlob = EncodingUtil.base64decode(ApexPages.currentPage().getParameters().get('EconsentId'));
            Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey1, EconsentIdBlob );
            decryptedString=decryptedData.tostring(); 
        }
        else{
            decryptedString = ApexPages.currentPage().getParameters().get('EconsentId');
        }
               long sessionTime ;         
        string[] arrTest = decryptedString.split('-');      
        if( arrTest != null  &&  arrTest.size() > 0)
         sessionTime =long.ValueOf(arrTest[0]);
        
        if(arrTest != null  && arrTest.size() > 1)
        applicantId=arrTest[1];
        if(arrTest != null  && arrTest.size() > 2)
          Bankid=arrTest[2];
        if(arrTest != null  && arrTest.size() > 3)
          reqDocID = arrTest[3];
        if(arrTest != null  && arrTest.size() > 4)
          EconID = arrTest[4];
        system.debug('###values'+applicantId);
        system.debug('###values'+Bankid);
        objAppToUpdate = new click_Applicant__c();   
       
        if(Bankid != null)
        {
            List<acf_Bank_Template__c>  lstBank = [Select Id ,Body__c from acf_Bank_Template__c where Id = :Bankid ] ;
            if(lstBank != null && lstBank.size( ) > 0 && lstBank[0].Body__c != null)
            {
                BankText =  lstBank[0].Body__c ;
            }
        }
        List<click_Applicant__c>  lstapplicant = [Select Id , acfEconsent__c   from  click_Applicant__c where id = : applicantId] ;
        if(lstapplicant != null && lstapplicant.size()>0)
        {
            for(click_Applicant__c objApplicant : lstapplicant)
            { 
                if(objApplicant.id == applicantId)
                {
                    objAppToUpdate = objApplicant;
                    List<E_Consent__c> eConsentList = [Select id,Consent_IP__c,Consent_Method__c,Applicant__c FROM E_Consent__c where id =:EconID];  
                    system.debug('##econs'+eConsentList);
                    if(eConsentList.size() > 0 && eConsentList[0].Consent_Method__c == 'Dashboard' )    
                    {
                        isSubmited=true; 
                    }   
                }
            }
        }     
        EconsentTime__c timeCheck=EconsentTime__c.getValues('timerone');
        if(sessionTime != null  && currentTime != null &&    currentTime-sessionTime >(timeCheck.minutes__c*60000)   )
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
                
                 List<Required_Document__c> lstReqDoc = [Select Bankid__c ,Id,Click_Applicant__c,acfStatus__c From Required_Document__c where id=:reqDocId];
                 
                 if(lstReqDoc.size() > 0)
                 {
                   lstReqDoc[0].acfStatus__c = 'Verified';
                   update lstReqDoc[0];
                 }
                
                List<E_Consent__c> eConsentList = [Select Consent_Time_and_Date__c ,Consent_Method__c,id,Consent_IP__c,Applicant__c FROM E_Consent__c where ID =:EconID ];    
                system.debug('##econs'+eConsentList);
                if(eConsentList.size() > 0){
                    eConsentList[0].Consent_IP__c = ipAddress;
                    eConsentList[0].Consent_Method__c = 'Dashboard';
                    eConsentList[0].Consent_Completed__c = true;
                    eConsentList[0].Consent_Time_and_Date__c =  System.now();
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