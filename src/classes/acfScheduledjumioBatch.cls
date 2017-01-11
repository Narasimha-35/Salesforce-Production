// To schedule jumio batch class
//Created by karthik
global class acfScheduledjumioBatch implements Schedulable {
   global void execute(SchedulableContext SC) {
      ID BatchId = Database.executeBatch(new acfJumioBatchClass(), 15);
   }
  }