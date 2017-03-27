@isTest 
private class ApplicantButtonTestClass {
    static testMethod void validateBatchclasss1()
    {
      
                click_Applicant__c  obj = new click_Applicant__c();
                    obj.address__C = 'ssaasa';
                    obj.Gender__c = 'Male';
                    obj.acf_applicant_DOB__c = '10/10/2016';
                    obj.acfRelationship_code__c = '2';
                    obj.First_Name__c = 'ssaasa';
                    obj.Last_Name__c = 'ssaasa';                
                 insert obj ;
                 CreateVedaClass.createVedaApplicantLink(obj.ID);
                 CreateVedaClass.callVedaApi(obj);
    }
    
    
     static testMethod void validateBatchclasss2()
    {
      
                click_Applicant__c  obj = new click_Applicant__c();
                    obj.address__C = null;
                    obj.Gender__c = Null;
                    obj.acf_applicant_DOB__c = null;
                    obj.acfRelationship_code__c =  null;
                    obj.First_Name__c =  null;
                    obj.Last_Name__c =  null;               
                 insert obj ;
                 CreateVedaClass.createVedaApplicantLink(obj.ID);
    }
     
}