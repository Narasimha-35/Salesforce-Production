@istest
public class SaasFocusCounterACFPhoneBroker_Tracker {
  Public Static testmethod void testmymethod()
    {
        Market__c market_obj=new Market__c ();
        market_obj.Name='australia';
        market_obj.Sydney_Timezone_Offset__c=10;
        insert market_obj;
        
    Broker__c broker_obj=new Broker__c ();
        broker_obj.Compensatory_Appointment__c =null;
        broker_obj.Name='VT';
        broker_obj.Email__c='vinod.tiw@fb.com';
        broker_obj.MobilePhone__c='9719764989';//
        broker_obj.Street_Address__c='ABC';
        broker_obj.City__c='dehradun';
        broker_obj.Channel__c='Phone Broker';
        broker_obj.Primary_Market__c=market_obj.id;
        insert broker_obj;
        
        SaasFocus_CounterACFPhoneBroker obj= new SaasFocus_CounterACFPhoneBroker();
        obj.count();
    }
}