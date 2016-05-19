public without sharing class sendEmailTemplateOnOppController 
{
    public Id accId {get; set;}
 //   public string accountEmail{get;set;}
    public sendEmailTemplateOnOppController() 
    {  
   //   accountEmail='';      
    }
    
    public List<Required_Document__c> getlstReqDocs() 
    {
       list<Opportunity> lstOpportunity = [select id,name,RecordType.Name,Account.Name,Account.PersonEmail,AccountId,Owner.Name,Owner.Phone,Owner.Email from Opportunity where accountId =:accId AND (RecordType.Name = 'Click Refi' OR RecordType.Name = 'Click New Loans' 
                                            OR RecordType.Name = 'ACF Refi' OR RecordType.Name = 'ACF New Loans')];
   //    if(lstOpportunity[0].Account.PersonEmail <> null && lstOpportunity[0].Account.PersonEmail <> '')
   //    accountEmail = lstOpportunity[0].Account.PersonEmail;
       system.debug('lstOpportunity **********'+lstOpportunity);
       if(lstOpportunity != null && lstOpportunity.size()>0)
       {
           opportunity objOpp = lstOpportunity[0];
           List<Required_Document__c> lstReqDocs = [SELECT Name,acfStatus__c FROM Required_Document__c WHERE acfOpportunity__c = :objOpp.id AND acfStatus__c =: 'Pending'];
           return lstReqDocs;
           system.debug('lstReqDocs**********'+lstReqDocs);
       }
       return null;
    }
    
    public wrapOppInfo getobjWrapOppInfo()
    {
        //list<Opportunity> lstOpportunity = [select id,name,OwnerId,Account.Name,account.OwnerId,Account.firstName,AccountId,Owner.Name,Owner.Phone,Owner.Email from Opportunity where accountId =:accId AND RecordType.Name = 'Click Refi'];
        list<Account> lstAccount = [select id,personEmail,OwnerId,firstName,Partner_User__c,Partner_User__r.name,Partner_User__r.Phone,Partner_User__r.Email,owner.Name,owner.Phone,owner.Email from Account where id=:accId];
        if(lstAccount != null && lstAccount.size()>0)
        {
            //system.debug('@@@karthik'+lstOpportunity[0].OwnerId+'===='+lstOpportunity[0].account.OwnerId);
            //opportunity objOpp = lstOpportunity[0];
            account objAcc = lstAccount[0];
            wrapOppInfo objWrapOppInfo = new wrapOppInfo();
            objWrapOppInfo.strAccName = objAcc.firstName;
            string strAccEmail = objAcc.personEmail;          
            //strAccEmail = strAccEmail.replace('+','%2B');
            if(strAccEmail.contains('+') == true)
            {
                List<String> emailPart = strAccEmail.split('\\+');
                strAccEmail = emailPart[0]+'%2B'+emailPart[1];
            }
            objWrapOppInfo.strAccEmail = strAccEmail;
            //objWrapOppInfo.strAccEmail = objAcc.personEmail;
            
            if(objAcc.Partner_User__c != null)
            {
                objWrapOppInfo.strOwnerName = objAcc.Partner_User__r.name;
                objWrapOppInfo.strOwnerPhone = objAcc.Partner_User__r.Phone;
                objWrapOppInfo.strOwnerEmail = objAcc.Partner_User__r.Email;
                string accOwnerId = objAcc.Partner_User__c;
                //objWrapOppInfo.strOwnerImgUrl = accOwnerPhotoUrl(accOwnerId);
            }else{
                objWrapOppInfo.strOwnerName = objAcc.Owner.Name;
                objWrapOppInfo.strOwnerPhone = objAcc.Owner.Phone;
                objWrapOppInfo.strOwnerEmail = objAcc.Owner.Email;
                string accOwnerId = objAcc.OwnerId;
                //objWrapOppInfo.strOwnerImgUrl = accOwnerPhotoUrl(accOwnerId);                               
            }  
                    
            return objWrapOppInfo;
        }
        return null;
    }
   /* 
    public string accOwnerPhotoUrl(string accownerId)
    {
        ConnectApi.Photo objPhoto = ConnectApi.UserProfiles.getPhoto(null, accOwnerId);
        system.debug('@@@test'+objPhoto.fullEmailPhotoUrl);
        return objPhoto.fullEmailPhotoUrl;
    }
    */
    public class wrapOppInfo
    {
        public string strAccName {get;set;}
        public string strAccEmail {get;set;}
        public string strOwnerName {get;set;}
        public string strOwnerPhone {get;set;}
        public string strOwnerEmail {get;set;}
        public string strOwnerImgUrl {get;set;}
    }
}