global class ScheduleClassFaceBroker implements Schedulable{
global void execute(SchedulableContext SC) 
    {
      SaasFocus_CounterACFFaceBroker obj=new SaasFocus_CounterACFFaceBroker();
      obj.count(); 
   }
}