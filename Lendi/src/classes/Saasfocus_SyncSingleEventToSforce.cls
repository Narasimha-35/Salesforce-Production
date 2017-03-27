// ----------------------------------------------------------------------------------
// This Class is a batch Class is used for execute the class(Saasfocus_GoogleSyncEvent)

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       27 April 2015        Ashutosh Kumar         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// 
// ----------------------------------------------------------------------------------
//

global class Saasfocus_SyncSingleEventToSforce implements Database.AllowsCallouts, Database.Batchable<sObject>{

  String Querry;
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
      //  List<Broker__c> blist= [Select Id,Email__c,Next_Sync_Token__c from Broker__c where name != 'Unallocated'and Active_Broker__c = true];
        
        Querry = 'Select Repeats_on__c,id,Description__c, byday__c,Last_Event_Date__c,Count__c,Interval__c,Freq__c,Until__c,Google_Event_Id__c,Start_date__c,End_date__c,Summary__c from Google_Recurring_Events__c where Recurring_Events__c= true AND Broker__r.Active_Broker__c = true';
        return Database.getQueryLocator(Querry);
    }
    
    global void execute(Database.BatchableContext BC, List<Google_Recurring_Events__c> scope)
    {
        system.debug('This is execute method:');
        
    system.debug('HELLLO'+scope);
    system.debug('HELLLO'+scope.size());
      Saasfocus_SyncRecOnedayEvent ob= new Saasfocus_SyncRecOnedayEvent();
     ob.OnedayEvent(scope);
    }
    
    global void finish(Database.BatchableContext BC) 
    { 
        
    }
}