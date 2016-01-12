// ----------------------------------------------------------------------------------
// This class tests business logic for SaaSfoucs_Set_Offset1
// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       17-apr-2015     Vinod Tiwari VT         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes: 
// ----------------------------------------------------------------------------------
// Test coverage for SaaSfoucs_Set_Offset1: 100%
//
@istest
private class SaaSfocus_Set_Offset1_Test{
    static testMethod void myUnitTest(){
    
    State__c state=new State__c ();
    state.Name='aus';
    insert state;
    
    Region__c region = new Region__c();
    region.Name='Aus';
    region.State__c=state.id;
    region.Sydney_Timezone_Offset__c=10.0;
    insert region;
    
    Region__c region1 = new Region__c();
    region1.Name='Aus';
    region1.State__c=state.id;
    region1.Sydney_Timezone_Offset__c=null;
    insert region1;
    
    SaaSfocus_Set_Offset1 set_offset =new SaaSfocus_Set_Offset1();
    set_offset.getRegion(region.id);
    
    SaaSfocus_Set_Offset1 set_offset1 =new SaaSfocus_Set_Offset1();
    set_offset1.getRegion(region1.id);
     }
}