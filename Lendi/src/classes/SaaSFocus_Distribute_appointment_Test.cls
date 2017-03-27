// ----------------------------------------------------------------------------------
// This class is test class of SaaSFocus_Distribute_appointment
// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       14-apr-2015           Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes:  Coverage of this class is
// ----------------------------------------------------------------------------------
@istest(seealldata=false)
public class SaaSFocus_Distribute_appointment_Test{
    @istest static  void myUnitTest(){
   
   Google_API_Setting__c gset = new Google_API_Setting__c();
   gset.name='Google_Setting';
   gset.Access_Token__c = 'abcd';
   gset.Access_Token_Time_Stamp__c = system.now().addhours(1);
   gset.API_KEY__c = 'KEY';
   gset.Client_Email_ID__c = 't@test.com';
   gset.Client_ID__c ='t';
   gset.Google_Calender_ID__c='a@b.scom';
   gset.Secondary_Appointment_Lag__c = 5;
   gset.Unallocated_Broker_Name__c = 'Unallocated Broker';
   
   insert gset;
   
   
    Market__c market_obj=new Market__c ();
        market_obj.Name='australia';
        market_obj.Sydney_Timezone_Offset__c=null;
        insert market_obj;
        
    Broker__c broker_obj=new Broker__c ();
        broker_obj.Compensatory_Appointment__c =12;
        broker_obj.Name='ASC';
        broker_obj.Email__c='bcs@saasfocus.com';
        broker_obj.MobilePhone__c='9719764989';
        broker_obj.Street_Address__c='ABC';
        broker_obj.City__c='dehradun';
        broker_obj.Primary_Market__c=market_obj.id;
        insert broker_obj;
        
    Market_Broker_Association__c Master_object=new Market_Broker_Association__c();
        Master_object.Name='ASC';
        Master_object.Broker__c=broker_obj.id;
        Master_object.Market__c=market_obj.id;
        Master_object.Priority__c='Primary Market';
        insert Master_object;
              
     set<id>emailset=new set<id>();
        emailset.add(broker_obj.id);
        
     List<Market_Broker_Association__c> mar=new list<Market_Broker_Association__c>();
        mar.add(Master_object);
        
     SaaSFocus_Distribute_appointment sobj= new SaaSFocus_Distribute_appointment();
        sobj.Compensatory_appointment(emailset,mar);   
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @istest static  void myUnitTest1(){
    
    Google_API_Setting__c gset = new Google_API_Setting__c();
   gset.name='Google_Setting';
   gset.Access_Token__c = 'abcd';
   gset.Access_Token_Time_Stamp__c = system.now().addhours(1);
   gset.API_KEY__c = 'KEY';
   gset.Client_Email_ID__c = 't@test.com';
   gset.Client_ID__c ='t';
   gset.Google_Calender_ID__c='a@b.scom';
   gset.Secondary_Appointment_Lag__c = 5;
   gset.Unallocated_Broker_Name__c = 'Unallocated Broker';
   
   insert gset;
   
    Market__c market_obj=new Market__c ();
        market_obj.Name='australia';
        market_obj.Sydney_Timezone_Offset__c=10;
        insert market_obj;
        
    Broker__c broker_obj=new Broker__c ();
        broker_obj.Compensatory_Appointment__c =null;
        broker_obj.Name='ASC';
        broker_obj.Email__c='ASDF@saasfocus.com';
        broker_obj.MobilePhone__c='9719764989';
        broker_obj.Street_Address__c='ABC';
        broker_obj.City__c='dehradun';
        broker_obj.Primary_Market__c=market_obj.id;
        insert broker_obj;
        
    Broker__c broker_obj1=new Broker__c ();
        broker_obj1.Compensatory_Appointment__c =null;
        broker_obj1.Name='ASD';
        broker_obj1.Email__c='ASDF@saasfocs.com';
        broker_obj1.MobilePhone__c='9719764989';
        broker_obj1.Street_Address__c='ABC';
        broker_obj1.City__c='dehradun';
        broker_obj1.Primary_Market__c=market_obj.id;
        insert broker_obj1;  
        
    Market_Broker_Association__c Master_object=new Market_Broker_Association__c();
        Master_object.Name='ASD';
        Master_object.Broker__c=broker_obj.id;
        Master_object.Market__c=market_obj.id;
        Master_object.Priority__c='Primary Market';
        insert Master_object;
        
      set<id>IDD=new set<id>();
        IDD.add(broker_obj.id);
      
      List<Market_Broker_Association__c> marr=new list<Market_Broker_Association__c>();
        marr.add(Master_object);        
        
    SaaSFocus_Distribute_appointment sobj= new SaaSFocus_Distribute_appointment();
        sobj.Compensatory_appointment(IDD,marr);
        
    Market_Broker_Association__c Master_object1=new Market_Broker_Association__c();
        Master_object1.Name='VT';
        Master_object1.Broker__c=broker_obj1.id;
        Master_object1.Market__c=market_obj.id;
        Master_object1.Priority__c='Secondary Market';
        insert Master_object1;
        
      set<id>IDD1=new set<id>();
        IDD1.add(broker_obj1.id);
        
      List<Market_Broker_Association__c> marrr=new list<Market_Broker_Association__c>();
        marrr.add(Master_object1); 
        
    SaaSFocus_Distribute_appointment sobj1= new SaaSFocus_Distribute_appointment();
        sobj1.Compensatory_appointment(IDD1,marrr);
        
      IDD1.add(broker_obj.id);
     marrr.add(Master_object);
        
     sobj1.Compensatory_appointment(IDD1,marrr);
        Google_API_Setting__c obj_Lag=new Google_API_Setting__c ();
            
               
    }
     @istest static  void myUnitTest2(){
     
     
     Google_API_Setting__c gset = new Google_API_Setting__c();
   gset.name='Google_Setting';
   gset.Access_Token__c = 'abcd';
   gset.Access_Token_Time_Stamp__c = system.now().addhours(1);
   gset.API_KEY__c = 'KEY';
   gset.Client_Email_ID__c = 't@test.com';
   gset.Client_ID__c ='t';
   gset.Google_Calender_ID__c='a@b.scom';
   gset.Secondary_Appointment_Lag__c = 5;
   gset.Unallocated_Broker_Name__c = 'Unallocated Broker';
   
   insert gset;
     
        Market__c market_obj=new Market__c ();
        market_obj.Name='australia';
        market_obj.Sydney_Timezone_Offset__c=10;
        insert market_obj;
         
         Broker__c broker_obj=new Broker__c ();
        broker_obj.Compensatory_Appointment__c =1;
        broker_obj.Name='ZXC';
        broker_obj.Email__c='ASDF@saasfocus.com';
        broker_obj.MobilePhone__c='9719764989';
        broker_obj.Street_Address__c='ABC';
        broker_obj.City__c='dehradun';
        broker_obj.Primary_Market__c=market_obj.id;
        insert broker_obj;
         
     
         SaaSFocus_Distribute_appointment sobj1= new SaaSFocus_Distribute_appointment();
              sobj1.compensatory_appointment_1(broker_obj.id);        }
}