global class acfCreateRpDataBatch implements Database.Batchable<sObject> , Database.AllowsCallouts{
    global  List<id> lstId ;
    global acfCreateRpDataBatch(List<id> lstId1) {        
        lstId =lstId1 ;   
    }

    //Quuery method.
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug(lstId);
        return DataBase.getQueryLocator([SELECT recordtypeid, Account__c,Account__r.PersonContact.acfWhat_is_your_postcode__c, Current_Balance__c ,Frequency__c,Limit__c,Name,Opportunity__c,Repayments__c,
                   Repayment_Frequency__c,State__c,Street_Name__c,Street_Number__c,Street_Type__c,Type__c,Value__c,City__c, Postcode__c,
                   Country__c FROM Asset_And_Liability__c where id =: lstId]);
    }
    
    //Execute Method.
     global void execute(Database.BatchableContext BC,List<Asset_And_Liability__c> appObj) {
        clsCoreLogicServicesHelper coreLogicObject = new clsCoreLogicServicesHelper();
        coreLogicObject.CreateRpdata(appObj);        
    }
    
    //Finish method to execute at last.
    global void finish(Database.BatchableContext BC) {    
    }
}