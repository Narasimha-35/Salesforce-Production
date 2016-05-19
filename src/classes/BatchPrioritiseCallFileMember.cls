global without sharing class BatchPrioritiseCallFileMember implements Database.batchable<SObject>, Database.Stateful{ 
    global String query = null;
    global String priority = null;
    global Boolean isByPostcode = false;
    global Integer numOfSuccess = 0;
    
   global BatchPrioritiseCallFileMember(String query, String priority, Boolean isByPostcode) {
       this.query = query;
       this.priority = priority;
       this.isByPostcode = isByPostcode;
   }
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.BatchableContext info, List<vhc__Campaign_Member__c> scope){
       CallFileMemberService.updatePriority(scope, priority, isByPostcode);
       numOfSuccess += scope.size();
   }     
   global void finish(Database.BatchableContext info){
       //send success email
       String uEmail = UserInfo.getUserEmail();
       Document doc = [select id, body from Document where name = 'BatchSuccessEmailTemplate' limit 1];
       String successEmailTemplate = doc.body.toString();
       Utilities.sendEmail(new List<String>{uEmail}, 'Batch Job', successEmailTemplate.replace('%%numberOfSuccessRecord%%', String.valueOf(numOfSuccess)));
       
       //send error email
       Boolean flag = false;
       List<vhc__Campaign_Member__c> failList = new List<vhc__Campaign_Member__c>();
       List<vhc__Campaign_Member__c> scope = Database.query(query);
       System.debug(LoggingLevel.INFO, query);
       for(vhc__Campaign_Member__c cfm : scope) {
           if(cfm.vhc__Priority__c != priority && cfm.vhc__Priority__c != priority) {
               failList.add(cfm);
               flag = true;
           }
       }
       ACFSwitch__c acfswh = ACFSwitch__c.getOrgDefaults();
	    Boolean emailSwh = (Boolean) acfswh.get('Prioritization_CFM_Email_Switch__c');
		ACFEmailList__c emaiSetting = ACFEmailList__c.getOrgDefaults();
       
       if(flag && emailSwh) Utilities.sendEmail(((String) emaiSetting.get('Prioritization_CFM_Email_Receiver__c')).split(','), 'Salesforce Debug', 'BatchPrioritiseCallFileMember fail records: ' + failList);
   } 
}