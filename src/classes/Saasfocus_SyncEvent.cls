// ----------------------------------------------------------------------------------
// This Class is used for Schedule the  Saasfocus_SyncEventGoogleToSforce

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       27 April 2015        Ashutosh Kumar         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// 
// ----------------------------------------------------------------------------------
//
global class Saasfocus_SyncEvent implements Schedulable{
global void execute(SchedulableContext SC) 
    {
     
      Saasfocus_SyncEventGoogleToSforce batobj= new Saasfocus_SyncEventGoogleToSforce();  
      database.executebatch(batobj,10);                                                    // Call the Batch class Saasfocus_SyncEventGoogleToSforce
     
      
   }
}