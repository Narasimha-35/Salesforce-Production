public without sharing class sendEmailTemplateOnOppController 
{
    public Id accId {get; set;}
    public string strLender {get;set;}
    public sendEmailTemplateOnOppController() 
    {  
        // Constructor
    }   
    public List<Required_Document__c> getlstReqDocs() 
    {
       list<Opportunity> lstOpportunity = [select id,acfCurrent_Lender__c,name,RecordType.Name,Account.Name,Account.PersonEmail,AccountId,Owner.Name,Owner.Phone,Owner.Email from Opportunity where accountId =:accId AND (RecordType.Name = 'Click Refi' OR RecordType.Name = 'Click New Loans' 
                                            OR RecordType.Name = 'ACF Refi' OR RecordType.Name = 'ACF New Loans')];
       system.debug('lstOpportunity **********'+lstOpportunity);
        system.debug('accId---'+accId);
       strLender ='';
       if(lstOpportunity != null && lstOpportunity.size()>0)
       {
           opportunity objOpp = lstOpportunity[0];
           if(objOpp.acfCurrent_Lender__c != null)
           {
           strLender = objOpp.acfCurrent_Lender__c;
           }
           List<Required_Document__c> lstReqDocs = [SELECT Name,acfStatus__c FROM Required_Document__c WHERE acfOpportunity__c = :objOpp.id AND acfStatus__c =: 'Pending'];
           return lstReqDocs;
           system.debug('lstReqDocs**********'+lstReqDocs);
       }
       return null;
    }
    
    public wrapOppInfo getobjWrapOppInfo()
    {
      system.debug('Method **********' );
        system.debug('accountid----'+accId);
        list<Account> lstAccount = [select id,personEmail,OwnerId,Owner.Title,firstName,Partner_User__r.Title,Partner_User__c,
                                    Partner_User__r.name,Partner_User__r.Phone,Partner_User__r.Email,owner.Name,owner.Phone,
                                    owner.Email from Account where id=:accId];
                                    system.debug('lstAccount **********'+lstAccount );
        if(lstAccount != null && lstAccount.size()>0)
        {
            account objAcc = lstAccount[0];
            wrapOppInfo objWrapOppInfo = new wrapOppInfo();
            objWrapOppInfo.strAccName = objAcc.firstName;
            string strAccEmail = objAcc.personEmail;          
            if(strAccEmail.contains('+') == true)
            {
                List<String> emailPart = strAccEmail.split('\\+');
                strAccEmail = emailPart[0]+'%2B'+emailPart[1];
            }
            objWrapOppInfo.strAccEmail = strAccEmail;
            if(objAcc.Partner_User__c != null)
            {
                objWrapOppInfo.strOwnerName = objAcc.Partner_User__r.name;
                objWrapOppInfo.strOwnerPhone = objAcc.Partner_User__r.Phone;
                objWrapOppInfo.strOwnerEmail = objAcc.Partner_User__r.Email;
                objWrapOppInfo.strOwnerTitle = objAcc.Partner_User__r.Title;
                string accOwnerId = objAcc.Partner_User__c;
            }else{
                objWrapOppInfo.strOwnerName = objAcc.Owner.Name;
                objWrapOppInfo.strOwnerPhone = objAcc.Owner.Phone;
                objWrapOppInfo.strOwnerEmail = objAcc.Owner.Email;
                objWrapOppInfo.strOwnerTitle = objAcc.Owner.Title;
                string accOwnerId = objAcc.OwnerId;                           
            }  
                    
            return objWrapOppInfo;
        }
        return null;
    }
    public class wrapOppInfo
    {
        public string strAccName {get;set;}
        public string strAccEmail {get;set;}
        public string strOwnerName {get;set;}
        //---------- Added by Bhasin on 23-06-16-------- //    
        public string strOwnerTitle {get;set;}
        public string strOwnerPhone {get;set;}
        public string strOwnerEmail {get;set;}
        public string strOwnerImgUrl {get;set;}
    }
}