public class acfIConsentController {

    public string message{get;set;}
    public boolean isSubmited{get;set;}
    public boolean isExpired{get;set;}
    public string UserAccountId{get;set;}
    private string applicantNumber{get;set;}


    
    public acfIConsentController (){
    
       // long sessionTime=long.ValueOf(ApexPages.currentPage().getParameters().get('session')); 
                        
        long currentTime=System.currentTimeMillis();
       // string UserAccountId=  ApexPages.currentPage().getParameters().get('account'); 
        
        
         Blob cryptoKey1 = Blob.valueOf('380db410e8b11fa9');
        // String urldecode=EncodingUtil.urlDecode(urlcode,'UTF-8');         
         Blob EconsentIdBlob =EncodingUtil.base64decode(ApexPages.currentPage().getParameters().get('EconsentId'));

         Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey1, EconsentIdBlob );
         string decryptedString=decryptedData.tostring();                  
         
         
        string[] arrTest = decryptedString.split('-');
         
                 
        long sessionTime=long.ValueOf(arrTest[0]);
        UserAccountId=arrTest[1];
        applicantNumber=arrTest[2];
        
         
        
        
        account useraccount= [select acfEconsent__pc,acfEconsent_App2__pc,id from account where  id=:UserAccountId];
        if((useraccount.acfEconsent__pc=='I Consent' && applicantNumber=='1') || (useraccount.acfEconsent_App2__pc=='I Consent' && applicantNumber=='2')){
            isSubmited=true;
        }       
        EconsentTime__c timeCheck=EconsentTime__c.getValues('timerone');

        if(currentTime-sessionTime >(timeCheck.minutes__c*60000) ){
           isExpired=true;           
         }
         
    }    
    
    public void updateConsentScreen(){
    
    try{    
            
            
            account useraccount= new account(id=UserAccountId);
        	if(applicantNumber=='1')
            useraccount.acfEconsent__pc='I Consent';
        	else            
            useraccount.acfEconsent_App2__pc ='I Consent';
        
            update useraccount;
            isSubmited=true;
        }
        catch(exception ex){
        
            ApexPages.addMessages(ex);  
        
        }
    }
}