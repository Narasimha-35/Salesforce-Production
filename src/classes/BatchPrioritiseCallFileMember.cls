global class BatchPrioritiseCallFileMember implements Database.batchable<SObject>{
    global String query = null;
    global String priority = null;
    global Boolean isByPostcode = false;
    global List<vhc__Campaign_Member__c> scope = null;

   global BatchPrioritiseCallFileMember(String query, String priority, Boolean isByPostcode) {
       this.query = query;
       this.priority = priority;
       this.isByPostcode = isByPostcode;
   }

   global Database.QueryLocator start(Database.BatchableContext info){
       return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext info, List<vhc__Campaign_Member__c> scope){
       this.scope = scope;
       CallFileMemberService.updatePriority(scope, priority, isByPostcode);
   }
   global void finish(Database.BatchableContext info){
       Boolean flag = false;
       List<vhc__Campaign_Member__c> failList = new List<vhc__Campaign_Member__c>();

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
