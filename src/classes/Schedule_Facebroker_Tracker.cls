// ----------------------------------------------------------------------------------
// This class covers the Schedule class for ACFfacebroker and ACFphonebroker in Salesforce

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0           28/04/2015    Amit kumar Sharma         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes: 
// ----------------------------------------------------------------------------------
//  
//
@isTest
public class Schedule_Facebroker_Tracker
{
//This method covers the schedule class for facebroker
@isTest 
    static void TestSchedule_Facebroker() 
    {
    ScheduleClassFaceBroker obj = new ScheduleClassFaceBroker();
     SchedulableContext at;
     obj.execute(at); 
    }
    //This method covers the schedule class for phonebroker
    @isTest 
    static void TestSchedule_phonebroker() 
    {
     ScheduleClassPhoneBroker obj = new ScheduleClassPhoneBroker();
     SchedulableContext at;
     obj.execute(at);
    }
    }