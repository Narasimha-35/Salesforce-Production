global class CreateVedaClass
{
    webservice static String  createVedaApplicantLink(String applicantId)
    {
        try
        {
            click_Applicant__c insObj  =[Select Address__c ,First_Name__c, Last_Name__c, Gender__c,id,acf_applicant_DOB__c, 
                                        acfRelationship_code__c, clickOpportunity__c,acf_Applicant_Name__c,                                         click_Account__r.acfWhat_is_your_postcode__pc, click_Account__r.Gender__pc,acf_applicant_Employer_Name__c 
                                        from  click_Applicant__c where id  = : applicantId ];
            String errorMessgae = '';
            if(insObj.First_Name__c == null)
            {
                errorMessgae = errorMessgae  + 'Appicant First Name is missing \n';
            }
            if(insObj.Last_Name__c == null)
            {
                errorMessgae = errorMessgae  + 'Appicant Last  Name is missing\n';
            }
            if(insObj.Address__c == null)
            {
                errorMessgae =  errorMessgae + 'Applicant\'s Address is missing\n';
            }
            if(insObj.Gender__c == null){
                errorMessgae =  errorMessgae + 'Applicant\'s gender is missing \n';
            }
            if(insObj.acf_applicant_Employer_Name__c == null){
                errorMessgae =  errorMessgae + 'Applicant\'s Employer name is missing.n';
            }
            if(insObj.acfRelationship_code__c == null )
            {
                errorMessgae =  errorMessgae + 'Applicant\'s Relationship code is missing.';
            }
            
            System.debug(errorMessgae);
            if(errorMessgae  != ''){
                return errorMessgae;
            }
            else
            {
                System.debug(errorMessgae);
                //callVedaApi(insObj);
                
                return callVedaApi(insObj);
            }
        }
        catch( Exception e )
        {
            return e.getmessage();
        }
    }
    public static    String  callVedaApi(click_Applicant__c  applicant)
    {
        list<String> lstName = new List<String>();
        if(applicant.acf_applicant_DOB__c  != null && applicant.Last_name__C != null  && applicant.first_name__C != null   ){
            lstName.add(applicant.acf_applicant_DOB__c+applicant.first_name__C+' '+ applicant.Last_name__C);
        }
        List<acfVedaApplicantLink__c>  vedaList = [Select Name , Veda_Status__c ,Applicant__c ,Record_Creation_date__c ,Veda_Summary__c  from
        acfVedaApplicantLink__c where Name  in :  lstName  and Veda_Status__c = 'Active'];
        
        
        List<acfVedaApplicantLink__c>  vedaList1  = [Select Name , Veda_Status__c ,Applicant__c ,Record_Creation_date__c ,Veda_Summary__c  from
        acfVedaApplicantLink__c where Name  in :  lstName  and Veda_Status__c = 'Active'   and Applicant__c  = : applicant.ID ];
        System.debug('#######as'+vedaList);
        map<String,acfVedaApplicantLink__c > mapVeda = new map<String,acfVedaApplicantLink__c >();
        if(vedaList != null && !vedaList.isEmpty())
        {
            for(acfVedaApplicantLink__c  vObj : vedaList)
            {
                mapVeda.put(vObj.name ,vObj );
            }
        }
        System.debug(mapVeda);
        Boolean checkExpiry  = false;
        List<click_Applicant__c> lstApplicant1 = new List<click_Applicant__c> ();
        List<click_Applicant__c> lstApplicant2 = new List<click_Applicant__c> ();
        if(applicant.acf_applicant_DOB__c  != null && applicant.Last_name__C != null  && applicant.first_name__C  != null  )
        {
            String tempName = applicant.acf_applicant_DOB__c+applicant.first_name__C +' '+applicant.Last_name__C  ;
             System.debug(tempName);
            if(mapVeda.containskey(tempName))
            {
                acfVedaApplicantLink__c vobj =  mapVeda.get(tempName);
                checkExpiry = acfCheckVedaExpiry.checkRercord(vobj);
                System.debug('____________'+checkExpiry);
                if(checkExpiry)
                {
                    lstApplicant2.add(applicant);
                    System.debug('exp');
                }
                else{
                   if(vedaList1.size()  > 0) {
                        return 'There is an Active Record for Veda. Please check related list.';  
                   }
                   else{
                        acfVedaApplicantLink__c vobj1   = vobj.clone(false,false,false,false);   
                        vobj1.Applicant__c  = applicant.ID ;
                        insert vobj1 ;
                        
                   }
                }
            }
            else
            {
            System.debug('____________'+checkExpiry);
            lstApplicant2.add(applicant);
            }
        
            if(lstApplicant2.size() > 0)
            {
                
                System.debug(lstApplicant2);
                List<ID> appId = new List<ID>();
                appId.add(lstApplicant2[0].ID );
                Database.executeBatch(new UpdateVedasummary(appId), 100);
                 return 'Batch is running,Please wait for veda record.';  
            }
            
        }
        return '';
    }
}