/*
    This class is used for Below purpose.
    1. To Connect old Veda records with new applicant.
    2. Create new veda record and connect with applicant.
    3. Check record is expire or not.
    
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Prateek Kumar Gupta              7/12/2016                              1.0
    =============================================================================
*/

public class acfCheckVedaExpiry {

// this is for checking expiry time.
public Static Boolean checkRercord(acfVedaApplicantLink__c  vcObj ){
    

 if(vcObj.Record_Creation_date__c != null ){
     Date RecordCreationDate = Date.valueof(vcObj.Record_Creation_date__c);
     Integer Difference = RecordCreationDate.daysBetween(System.today());
     System.debug('__Difference _'+Difference );
     if(Difference  > 30) 
         return true;
     else
         return false;
     
     
 }
 return false;
    
}
// Map With Existing  veda records.
public Static  void  mapRecords(acfVedaApplicantLink__c  vcObj , click_Applicant__c applicant ){
    
    if(vcObj != null  && applicant != null){
        acfVedaApplicantLink__c  obj = new acfVedaApplicantLink__c();
        obj.Applicant__c = applicant.id ;
        obj.Veda_Summary__c = vcObj.Veda_Summary__c ;
        obj.Record_Creation_date__c = vcObj.Record_Creation_date__c ;
        insert obj;
    }   
 
    
}


/*public acfVedaApplicantLink__c  checkVedaRecords(String   name  ){
    
    List<acfVedaApplicantLink__c>  vedaList = [Select Name form acfVedaApplicantLink__c where Name  : = name  limit 1 ];
    
    if(vedaList.size() > 0){
        return vedaList.get(0);
    }
    else{
        return null;
    }
    
}
*/
}