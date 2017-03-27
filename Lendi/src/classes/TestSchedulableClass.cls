@isTest
private class TestSchedulableClass {


public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   static testmethod void test() {
      Test.startTest();
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new acfScheduledjumioBatch());
      Test.stopTest();
        }
}