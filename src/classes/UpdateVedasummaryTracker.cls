@isTest(SeeAllData=true)

private class UpdateVedasummaryTracker {
 static testmethod void test() {
   Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVeda());    
    List<Id> query = new List<Id>();
    List<click_Applicant__c>  lst = [Select Middle_Name__c,acf_applicant_DOB__c, acfRelationship_code__c,Gender__c,clickOpportunity__c,acf_Applicant_Name__c, click_Account__r.acfWhat_is_your_postcode__pc  , 
                                       click_Account__r.Gender__pc   , acf_applicant_Employer_Name__c from  click_Applicant__c  where acf_applicant_DOB__c != null 
                                       and acf_Applicant_Name__c != null   and acfRelationship_code__c != null  and Gender__c  != null and 
                                       click_Account__r.acfWhat_is_your_postcode__pc != null ] ;
                                      
   for(click_Applicant__c app : lst){
       query.add(app.id);
   }
       Test.startTest();
       Database.BatchableContext BC;
       UpdateVedasummary c = new UpdateVedasummary(query);
       Database.executeBatch(c);
      
       Test.stopTest();
 }
 }