global class Saasfocus_Schedule_SyncRecOnedayEvent implements Schedulable{
global void execute(SchedulableContext SC) 
    {
      Saasfocus_SyncSingleEventToSforce batobj=new Saasfocus_SyncSingleEventToSforce();
      database.executebatch(batobj,5);   
   }
}