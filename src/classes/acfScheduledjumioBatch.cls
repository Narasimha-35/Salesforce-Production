// To schedule jumio batch class
//Created by karthik
global class acfScheduledjumioBatch implements Schedulable {
   global void execute(SchedulableContext SC) {
      ID BatchId = Database.executeBatch(new acfJumioBatchClass(), 200);
   }
   Public static void SchedulerMethod() 
   {
        string con_exp= '0 0 * * * ?';
        System.schedule('acfJumioBatchClassTest', con_exp, new acfScheduledjumioBatch());
   }
}