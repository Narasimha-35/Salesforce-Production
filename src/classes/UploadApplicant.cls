global class UploadApplicant implements Database.Batchable<sObject>{

        global UploadApplicant(){
                   
        }
       
        
        global Database.QueryLocator start(Database.BatchableContext BC){
        String Query ='Select acfApplicant2_How_Long__pc,acfApplicant2_phone__pc,acfApplicant2_email__pc,PersonEmail,PersonMobilePhone,acf_applicant_Residency_status__pc,'+
        +'acf_Applicant_Name__pc ,acf_applicant_DOB__pc , Marital_Status__pc,  acf_Applicant_Dependants__pc , acfDependant1_Age__pc,'+
            +'acfDependant2_Age__pc,     acfDependant3_Age__pc, acfDependant4_Age__pc , acfDependant5_Age__pc , acfAnnual_Salary__pc ,'+ +'acf_applicant_Employer_Name__pc,'+
             +'Current_Role__pc ,     acf_How_Long_have_you_been_employed__pc, acfBusiness_Name_or_ABN_autofill__pc , acf_How_Long__pc ,'+'acfAnnual_profit_income__pc ,' +
        +' acfEconsent__pc , clickApp_1_Monthly_Expenses__pc   ,   acfApplicant2_Name__pc , acfApplicant2_DOB__pc , acfApplicant2_Marital_Status__pc '+
        +' , acfApplicant2_Dependents__pc , acfApplicant2_dependent1_Age__pc,     acfApplicant2_dependent2_Age__pc ,    acfApplicant2_dependent3_Age__pc ,'+
        +'acfApplicant2_dependent4_Age__pc ,     acfApplicant2_dependent5_Age__pc ,   '+ 
        +'acfApplicant2_Annual_Salary__pc ,  clickCurrent_Role_App_2__pc ,'
        
         + 'acfApp2_How_Long_have_you_been_employed__pc   , acfApp2_Business_Name_or_ABN_autofill__pc , acfApplicant2_Annual_profit_income__pc ,' +      'clickApp_2_Monthly_Expenses__pc , acfEconsent_App2__pc , acfApplicant2_Residency_status__pc , acfApplicant2_Monthly_Salary__pc ,'+ 'acfApplicant2_Employer_Name__pc  from Account '  ;
         System.debug(Query);
         return Database.getQueryLocator(Query);
        }
      
      
       global void execute(Database.BatchableContext BC, List<Account> scope){
            
              set<click_Applicant__c> applicantObj = new set<click_Applicant__c>();
           
              set<click_Applicant__c> updatedApplicantObj = new set<click_Applicant__c>();
           map<id , List<click_Applicant__c >>  mapApp = new map<id,List<click_Applicant__c>>();
           List<click_Applicant__c> lstapp = [Select id,click_Account__c , clickApp_1_Monthly_Expenses__c , acf_Applicant_Name__c ,
           acf_applicant_DOB__c ,Applicant_Email__c, Applicant_Phone__c , acf_applicant_Marital_Status__c,acf_applicant_Dependants__c ,
            acfDependant1_Age__c , acfDependant2_Age__c , acfDependant3_Age__c , acfDependant4_Age__c , acfDependant5_Age__c , acf_applicant_Residency_status__c , acf_applicant_Monthlly_Salary__c , acf_applicant_Employer_Name__c , Current_Role__c, acf_How_Long_have_you_been_employed__c ,acfBusiness_Name_or_ABN_autofill__c , acf_How_Long__c , acf_applicant_Annual_profit_income__c , acfEconsent__c  ,click_Applicant_Number__c  from  click_Applicant__c];
            
            for( click_Applicant__c app :lstapp ){
                 if(mapApp.containskey(app.click_Account__c)){
                     mapApp.get(app.click_Account__c).add(app);
                 }
                 else
                 {
                     list<click_Applicant__c> temp = new list<click_Applicant__c>();
                     temp.add(app);
                      mapApp.put(app.click_Account__c, temp);
                 }
                
            }
            
           for( Account obj  : scope){
                if(!mapApp.containskey(obj.id))
                
                {
               
               if(obj.acf_Applicant_Name__pc != null){
                    click_Applicant__c applicant1 = new  click_Applicant__c();
                    
                    applicant1.click_Account__c = obj.id;
                    
                    applicant1.click_Applicant_Number__c =  String.valueof(1);
                    if(obj.clickApp_1_Monthly_Expenses__pc != null)
                    applicant1.clickApp_1_Monthly_Expenses__c = obj.clickApp_1_Monthly_Expenses__pc;
                    
                  
                    applicant1.acf_Applicant_Name__c= obj.acf_Applicant_Name__pc;
                    if(obj.acf_applicant_DOB__pc != null)
                    applicant1.acf_applicant_DOB__c = obj.acf_applicant_DOB__pc;
                     
                     if(obj.PersonEmail != null)
                    applicant1.Applicant_Email__c = obj.PersonEmail;
                    
                    if(obj.PersonMobilePhone != null)
                    applicant1.Applicant_Phone__c = obj.PersonMobilePhone;
                
                  if(obj.Marital_Status__pc != null)
                    applicant1.acf_applicant_Marital_Status__c = obj.Marital_Status__pc;
                    

                    
                    if(obj.acf_Applicant_Dependants__pc != null)
                    applicant1.acf_applicant_Dependants__c = obj.acf_Applicant_Dependants__pc;

                    if(obj.acfDependant1_Age__pc != null)
                    applicant1.acfDependant1_Age__c = obj.acfDependant1_Age__pc;

                    if(obj.acfDependant2_Age__pc != null)
                    applicant1.acfDependant2_Age__c = obj.acfDependant2_Age__pc;
                    if(obj.acfDependant3_Age__pc != null)
                    applicant1.acfDependant3_Age__c = obj.acfDependant3_Age__pc;
                    if(obj.acfDependant4_Age__pc != null)
                    applicant1.acfDependant4_Age__c = obj.acfDependant4_Age__pc;
                    if(obj.acfDependant5_Age__pc != null)
                    applicant1.acfDependant5_Age__c = obj.acfDependant5_Age__pc;

                    if(obj.acf_applicant_Residency_status__pc != null)
                    applicant1.acf_applicant_Residency_status__c = obj.acf_applicant_Residency_status__pc;

                    if(obj.acfAnnual_Salary__pc != null)
                    applicant1.acf_applicant_Monthlly_Salary__c = obj.acfAnnual_Salary__pc;

                    if(obj.acf_applicant_Employer_Name__pc != null)
                    applicant1.acf_applicant_Employer_Name__c = obj.acf_applicant_Employer_Name__pc;

                    if(obj.Current_Role__pc != null)
                    applicant1.Current_Role__c = obj.Current_Role__pc;

                    if(obj.acf_How_Long_have_you_been_employed__pc != null)
                    applicant1.acf_How_Long_have_you_been_employed__c = obj.acf_How_Long_have_you_been_employed__pc;
                    if(obj.acfBusiness_Name_or_ABN_autofill__pc != null)
                    applicant1.acfBusiness_Name_or_ABN_autofill__c = obj.acfBusiness_Name_or_ABN_autofill__pc;   

                    if(obj.acf_How_Long__pc != null)
                    applicant1.acf_How_Long__c = obj.acf_How_Long__pc;   

                    if(obj.acfAnnual_profit_income__pc != null)
                    applicant1.acf_applicant_Annual_profit_income__c = obj.acfAnnual_profit_income__pc;  

                   
                    
                    if(obj.acfEconsent__pc != null)
                    applicant1.acfEconsent__c = obj.acfEconsent__pc;
                    applicantObj.add(applicant1);
               }
                   
                if(obj.acfApplicant2_Name__pc != null){
                    click_Applicant__c applicant2 = new  click_Applicant__c();
                    
                    applicant2.click_Account__c = obj.id;
                    
                    applicant2.click_Applicant_Number__c = String.valueof(2);
                    
                    if(obj.clickApp_2_Monthly_Expenses__pc != null)
                    applicant2.clickApp_1_Monthly_Expenses__c = obj.clickApp_2_Monthly_Expenses__pc;
                    
                    if(obj.acfApplicant2_email__pc != null)
                    applicant2.Applicant_Email__c = obj.acfApplicant2_email__pc;
                    
                    if(obj.acfApplicant2_phone__pc != null)
                    applicant2.Applicant_Phone__c = obj.acfApplicant2_phone__pc;
                
                
                  
                    applicant2.acf_Applicant_Name__c = obj.acfApplicant2_Name__pc;
                    if(obj.acfApplicant2_DOB__pc != null)
                    applicant2.acf_applicant_DOB__c = obj.acfApplicant2_DOB__pc;  
                    
                    if(obj.acfApplicant2_Marital_Status__pc != null)
                    applicant2.acf_applicant_Marital_Status__c = obj.acfApplicant2_Marital_Status__pc;
                    
                    if(obj.acfApplicant2_Dependents__pc != null)
                    applicant2.acf_applicant_Dependants__c = obj.acfApplicant2_Dependents__pc;

                    if(obj.acfApplicant2_dependent1_Age__pc != null)
                    applicant2.acfDependant1_Age__c = obj.acfApplicant2_dependent1_Age__pc;

                    if(obj.acfApplicant2_dependent2_Age__pc != null)
                    applicant2.acfDependant2_Age__c = obj.acfApplicant2_dependent2_Age__pc;
                    if(obj.acfApplicant2_dependent3_Age__pc != null)
                    applicant2.acfDependant3_Age__c = obj.acfApplicant2_dependent3_Age__pc;
                    if(obj.acfApplicant2_dependent4_Age__pc != null)
                    applicant2.acfDependant4_Age__c = obj.acfApplicant2_dependent4_Age__pc;
                    if(obj.acfApplicant2_dependent5_Age__pc != null)
                    applicant2.acfDependant5_Age__c = obj.acfApplicant2_dependent5_Age__pc;

                    if(obj.acfApplicant2_Residency_status__pc != null)
                    applicant2.acf_applicant_Residency_status__c = obj.acfApplicant2_Residency_status__pc;

                    if(obj.acfApplicant2_Monthly_Salary__pc != null)
                    applicant2.acf_applicant_Monthlly_Salary__c = obj.acfApplicant2_Monthly_Salary__pc;

                    if(obj.acfApplicant2_Employer_Name__pc != null)
                    applicant2.acf_applicant_Employer_Name__c = obj.acfApplicant2_Employer_Name__pc;

                    if(obj.clickCurrent_Role_App_2__pc != null)
                    applicant2.Current_Role__c = obj.clickCurrent_Role_App_2__pc;

                    if(obj.acfApp2_How_Long_have_you_been_employed__pc != null)
                    applicant2.acf_How_Long_have_you_been_employed__c = obj.acfApp2_How_Long_have_you_been_employed__pc;
                    if(obj.acfApp2_Business_Name_or_ABN_autofill__pc  != null)
                    applicant2.acfBusiness_Name_or_ABN_autofill__c = obj.acfApp2_Business_Name_or_ABN_autofill__pc   ;   

                    if(obj.acfApplicant2_How_Long__pc != null)
                    applicant2.acf_How_Long__c = obj.acfApplicant2_How_Long__pc; 

                    if(obj.acfApplicant2_Annual_profit_income__pc != null)
                    applicant2.acf_applicant_Annual_profit_income__c = obj.acfApplicant2_Annual_profit_income__pc;   

                    
                    
                    if(obj.acfEconsent_App2__pc != null)
                    applicant2.acfEconsent__c = obj.acfEconsent_App2__pc;
                    applicantObj.add(applicant2);
                }   
                   
               }
                else{
                 List<click_Applicant__c>  tempLst =mapApp.get(obj.id);
                 
                 map<String,click_Applicant__c> tempMap = new  map<String,click_Applicant__c> ();
                 
                         for( click_Applicant__c app :tempLst ){
                        
                             if(app.acf_Applicant_Name__c != null)
                             tempMap.put(app.acf_Applicant_Name__c, app);
                         }
                        
                        
                        
                if(obj.acf_Applicant_Name__pc != null  && tempMap.get(obj.acf_Applicant_Name__pc) != null ){
                    click_Applicant__c applicant1 = tempMap.get(obj.acf_Applicant_Name__pc) ;
                    
                    applicant1.click_Account__c = obj.id;
                    applicant1.Id = applicant1.Id;
                    
                    applicant1.click_Applicant_Number__c = String.valueof(1);
                    if(obj.clickApp_1_Monthly_Expenses__pc != null)
                    applicant1.clickApp_1_Monthly_Expenses__c = obj.clickApp_1_Monthly_Expenses__pc;
                    
                  
                    applicant1.acf_Applicant_Name__c= obj.acf_Applicant_Name__pc;
                    if(obj.acf_applicant_DOB__pc != null)
                    applicant1.acf_applicant_DOB__c = obj.acf_applicant_DOB__pc;
                     
                     if(obj.PersonEmail != null)
                    applicant1.Applicant_Email__c = obj.PersonEmail;
                    
                    if(obj.PersonMobilePhone != null)
                    applicant1.Applicant_Phone__c = obj.PersonMobilePhone;
                
                  if(obj.Marital_Status__pc != null)
                    applicant1.acf_applicant_Marital_Status__c = obj.Marital_Status__pc;
                    

                    
                    if(obj.acf_Applicant_Dependants__pc != null)
                    applicant1.acf_applicant_Dependants__c = obj.acf_Applicant_Dependants__pc;

                    if(obj.acfDependant1_Age__pc != null)
                    applicant1.acfDependant1_Age__c = obj.acfDependant1_Age__pc;

                    if(obj.acfDependant2_Age__pc != null)
                    applicant1.acfDependant2_Age__c = obj.acfDependant2_Age__pc;
                    if(obj.acfDependant3_Age__pc != null)
                    applicant1.acfDependant3_Age__c = obj.acfDependant3_Age__pc;
                    if(obj.acfDependant4_Age__pc != null)
                    applicant1.acfDependant4_Age__c = obj.acfDependant4_Age__pc;
                    if(obj.acfDependant5_Age__pc != null)
                    applicant1.acfDependant5_Age__c = obj.acfDependant5_Age__pc;

                    if(obj.acf_applicant_Residency_status__pc != null)
                    applicant1.acf_applicant_Residency_status__c = obj.acf_applicant_Residency_status__pc;

                    if(obj.acfAnnual_Salary__pc != null)
                    applicant1.acf_applicant_Monthlly_Salary__c = obj.acfAnnual_Salary__pc;

                    if(obj.acf_applicant_Employer_Name__pc != null)
                    applicant1.acf_applicant_Employer_Name__c = obj.acf_applicant_Employer_Name__pc;

                    if(obj.Current_Role__pc != null)
                    applicant1.Current_Role__c = obj.Current_Role__pc;

                    if(obj.acf_How_Long_have_you_been_employed__pc != null)
                    applicant1.acf_How_Long_have_you_been_employed__c = obj.acf_How_Long_have_you_been_employed__pc;
                    if(obj.acfBusiness_Name_or_ABN_autofill__pc != null)
                    applicant1.acfBusiness_Name_or_ABN_autofill__c = obj.acfBusiness_Name_or_ABN_autofill__pc;   

                    if(obj.acf_How_Long__pc != null)
                    applicant1.acf_How_Long__c = obj.acf_How_Long__pc;   

                    if(obj.acfAnnual_profit_income__pc != null)
                    applicant1.acf_applicant_Annual_profit_income__c = obj.acfAnnual_profit_income__pc;  

                   
                    
                    if(obj.acfEconsent__pc != null)
                    applicant1.acfEconsent__c = obj.acfEconsent__pc;
                   updatedApplicantObj.add(applicant1);
                   
               }
                   
                if(obj.acfApplicant2_Name__pc != null   && tempMap.get(obj.acfApplicant2_Name__pc) != null ){
                    click_Applicant__c applicant2 = tempMap.get(obj.acfApplicant2_Name__pc) ;
                    applicant2.Id = applicant2.ID;
                    applicant2.click_Account__c = obj.id;
                    
                    applicant2.click_Applicant_Number__c = String.valueof(2);
                    
                    if(obj.clickApp_2_Monthly_Expenses__pc != null)
                    applicant2.clickApp_1_Monthly_Expenses__c = obj.clickApp_2_Monthly_Expenses__pc;
                    
                    if(obj.acfApplicant2_email__pc != null)
                    applicant2.Applicant_Email__c = obj.acfApplicant2_email__pc;
                    
                    if(obj.acfApplicant2_phone__pc != null)
                    applicant2.Applicant_Phone__c = obj.acfApplicant2_phone__pc;
                
                
                  
                    applicant2.acf_Applicant_Name__c = obj.acfApplicant2_Name__pc;
                    if(obj.acfApplicant2_DOB__pc != null)
                    applicant2.acf_applicant_DOB__c = obj.acfApplicant2_DOB__pc;  
                    
                    if(obj.acfApplicant2_Marital_Status__pc != null)
                    applicant2.acf_applicant_Marital_Status__c = obj.acfApplicant2_Marital_Status__pc;
                    
                    if(obj.acfApplicant2_Dependents__pc != null)
                    applicant2.acf_applicant_Dependants__c = obj.acfApplicant2_Dependents__pc;

                    if(obj.acfApplicant2_dependent1_Age__pc != null)
                    applicant2.acfDependant1_Age__c = obj.acfApplicant2_dependent1_Age__pc;

                    if(obj.acfApplicant2_dependent2_Age__pc != null)
                    applicant2.acfDependant2_Age__c = obj.acfApplicant2_dependent2_Age__pc;
                    if(obj.acfApplicant2_dependent3_Age__pc != null)
                    applicant2.acfDependant3_Age__c = obj.acfApplicant2_dependent3_Age__pc;
                    if(obj.acfApplicant2_dependent4_Age__pc != null)
                    applicant2.acfDependant4_Age__c = obj.acfApplicant2_dependent4_Age__pc;
                    if(obj.acfApplicant2_dependent5_Age__pc != null)
                    applicant2.acfDependant5_Age__c = obj.acfApplicant2_dependent5_Age__pc;

                    if(obj.acfApplicant2_Residency_status__pc != null)
                    applicant2.acf_applicant_Residency_status__c = obj.acfApplicant2_Residency_status__pc;

                    if(obj.acfApplicant2_Monthly_Salary__pc != null)
                    applicant2.acf_applicant_Monthlly_Salary__c = obj.acfApplicant2_Monthly_Salary__pc;

                    if(obj.acfApplicant2_Employer_Name__pc != null)
                    applicant2.acf_applicant_Employer_Name__c = obj.acfApplicant2_Employer_Name__pc;

                    if(obj.clickCurrent_Role_App_2__pc != null)
                    applicant2.Current_Role__c = obj.clickCurrent_Role_App_2__pc;

                    if(obj.acfApp2_How_Long_have_you_been_employed__pc != null)
                    applicant2.acf_How_Long_have_you_been_employed__c = obj.acfApp2_How_Long_have_you_been_employed__pc;
                    if(obj.acfApp2_Business_Name_or_ABN_autofill__pc  != null)
                    applicant2.acfBusiness_Name_or_ABN_autofill__c = obj.acfApp2_Business_Name_or_ABN_autofill__pc   ;   

                    if(obj.acfApplicant2_How_Long__pc != null)
                    applicant2.acf_How_Long__c = obj.acfApplicant2_How_Long__pc; 

                    if(obj.acfApplicant2_Annual_profit_income__pc != null)
                    applicant2.acf_applicant_Annual_profit_income__c = obj.acfApplicant2_Annual_profit_income__pc;   

                    
                    
                    if(obj.acfEconsent_App2__pc != null)
                    applicant2.acfEconsent__c = obj.acfEconsent_App2__pc;
                
                    updatedApplicantObj.add(applicant2);
                   
                }       
                
                
                }
           }
           List<click_Applicant__c> applicantObj1 = new List<click_Applicant__c>(applicantObj);
           
              List<click_Applicant__c> updatedApplicantObj1 = new List<click_Applicant__c>(updatedApplicantObj);
               update updatedApplicantObj1 ;
               insert applicantObj1;
               
               
           }
              
     
       
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
    }