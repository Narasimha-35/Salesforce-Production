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

global class Saasfocus_SyncEventGoogleToSforce implements Database.AllowsCallouts, Database.Batchable<sObject>{

  String Querry;
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
      //  List<Broker__c> blist= [Select Id,Email__c,Next_Sync_Token__c from Broker__c where name != 'Unallocated'and Active_Broker__c = true];
        
        Querry = 'Select Id,Email__c,Next_Sync_Token__c from Broker__c where name != \''+Saasfocus_Global.getUnallocatedBrokerName()+'\'and Active_Broker__c = true' ;
        return Database.getQueryLocator(Querry);
    }
    
    global void execute(Database.BatchableContext BC, List<Broker__c> scope)
    {
        system.debug('This is execute method:');
        
    
      Saasfocus_GoogleSyncEvent ob= new Saasfocus_GoogleSyncEvent();
     ob.InsertEventslist(scope );
    }
    
    global void finish(Database.BatchableContext BC) 
    { 
        
    }
}