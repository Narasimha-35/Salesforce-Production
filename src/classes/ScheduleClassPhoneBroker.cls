global class ScheduleClassPhoneBroker implements Schedulable{
global void execute(SchedulableContext SC) 
    {
      SaasFocus_CounterACFPhoneBroker obj=new SaasFocus_CounterACFPhoneBroker();
      obj.count(); 
   }
}