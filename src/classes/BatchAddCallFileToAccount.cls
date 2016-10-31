global without sharing class BatchAddCallFileToAccount implements Database.Batchable<sObject> {
    global BatchAddCallFileToAccount() {
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Accountant_Name__pc,Accountant_Phone__pc,AnnualRevenue,Account_Email__c,Account_Owner_Name__c,ACf1_Current_employer_Start_Date__pc,ACf2_Current_employer_Start_Date__pc,acfAdequate_Insurance__pc,acfAnnual_profit_income__pc,acfAnnual_Salary__pc,acfAny_Debt_to_Consolidate__pc,acfApp2_Business_Name_or_ABN_autofill__pc,acfApp2_How_Long_have_you_been_employed__pc,acfApplicant2_After_Tax_Salary__pc,acfApplicant2_Annual_profit_income__pc,acfApplicant2_Annual_Salary__pc,acfApplicant2_Before_Tax_Salary__pc,acfApplicant2_Citizenship_Status__pc,acfApplicant2_dependent1_Age__pc,acfApplicant2_dependent2_Age__pc,acfApplicant2_dependent3_Age__pc,acfApplicant2_dependent4_Age__pc,acfApplicant2_dependent5_Age__pc,acfApplicant2_Dependents__pc,acfApplicant2_DOB__pc,acfApplicant2_email__pc,acfApplicant2_Employer_Name__pc,acfApplicant2_Employment_Type__pc,acfApplicant2_How_Long__pc,acfApplicant2_Marital_Status__pc,acfApplicant2_Monthly_Salary__pc,acfApplicant2_Name__pc,acfApplicant2_phone__pc,acfApplicant2_Residency_status__pc,acfApproximately_how_much_is_your_house__pc,acfAssetsAndLiablities__pc,acfAsset_House_Worth__c,acfBefore_Tax_Salary__pc,acfBusiness_Name_or_ABN_autofill__pc,acfConcerned_about_interest_rates__pc,acfCurrent_Loan_Amount__pc,acfCurrent_Rate__pc,acfDependant1_Age__pc,acfDependant2_Age__pc,acfDependant3_Age__pc,acfDependant4_Age__pc,acfDependant5_Age__pc,acfDetails_of_change__pc,acfDo_u_know_your_current_interest_rate__pc,acfEconsent_App2__pc,acfEconsent__pc,acfForeseable_changes_circumstances__pc,acfHome_Phone__pc,acfHow_Much_Cash_Out__pc,acfHow_Much__pc,acfInsurance_Referral__pc,acfIsIdentityDocumentRejected__pc,acfIsLoginAttemptCompleted__pc,acfIsMobileVerified__c,acfIsMobileVerified__pc,acfJob_Security__pc,acfKnowaboutus__pc,acfLoan_Amount__pc,acfNumber_Of_Applicants__pc,acfPassword__c,acfPassword__pc,acfPerson_Email__c,acfPerson_Mobile__c,acfPostal_Code__pc,acfType__pc,acfUse__pc,acfWe_ve_already_got_your_mobile__pc,acfWhat_is_your_current_payment_type__pc,acfWhat_is_your_postcode__pc,acfWhat_Year_Tax_Return_do_you_Have_App2__pc,acfWhat_Year_Tax_Return_do_you_Have__pc,acfWhy_are_you_refinancing__pc,acf_3yrs_of_address_history__pc,acf_applicant_Citizenship_Status__pc,acf_Applicant_Dependants__pc,acf_applicant_DOB__pc,acf_applicant_Employer_Name__pc,acf_Applicant_Employment_Type__pc,acf_applicant_Marital_Status__pc,acf_applicant_Monthlly_Salary__pc,acf_Applicant_Name__pc,acf_applicant_Residency_status__pc,acf_Approx_Property_Valuation__pc,Acf_Are_there_any_more_properties__pc,acf_Asset_Type__pc,ACF_BankName__pc,acf_Current_Credit_Rating__pc,acf_Current_employer_Address__pc,acf_Current_employer_Phone__pc,acf_Current_Monthly_Payment__pc,acf_Driver_Licence_state__pc,acf_Driver_Licence__pc,acf_How_Long_have_you_been_employed__pc,acf_How_Long__pc,acf_How_much_Debt_Consolidate__pc,acf_Last_3yrs_empl_History__pc,acf_Lead__pc,acf_Why_are_you_refinancing_pl__pc,acf_Work_Phone__pc,Add_To_Call_File_Date__c,Affiliate_campaign__pc,affiliate_source__pc,After_Tax_Salary__pc,Annual_Income__pc,Applied_Before__pc,BillingAddress,BillingCity,BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,Birthday__pc,bizible__AdWords_Campaign__pc,bizible__Ad_Group__pc,bizible__City__pc,bizible__Country__pc,bizible__Device__pc,bizible__Keyword__pc,bizible__LandingPage__pc,bizible__Medium__pc,bizible__ReferrerPage__pc,bizible__Region__pc,bizible__Search_Phrase__pc,bizible__Text_Ad__pc,bizible__WebSource__pc,c21_agent__pc,c21_buyer__pc,c21_contactID__pc,c21_contactsource__pc,c21_datecreated__pc,c21_established_client__pc,c21_landlord__pc,c21_name__pc,c21_officeid__pc,c21_officestate__pc,c21_office_postcode__pc,c21_office_suburb__pc,c21_potential_landlord__pc,c21_potential_seller__pc,c21_potential_tenant__pc,c21_seller__pc,c21_tenant__pc,c21_trantype__pc,Call_File_Is_Updated__c,Chatter_Message__c,clickApp_1_Monthly_Expenses__pc,clickApp_2_Monthly_Expenses__pc,clickCurrent_Role_App_2__pc,clickLead_Status__pc,clickNo_Of_Pending_Docs__c,Click_Community_Setup__c,Click_Is_community_user_created__c,Click_Is_Phone_Broker_customer__c,click_Is_Required_Document_Sent__c,click_Is_this_loan_for_an_investment_p__pc,Click_Loan_Close_Lost_Reason__c,Click_Loan_Stage__c,Contact_Attempted__c,CreatedById,CreatedDate,Credit_Guide_Quote_Privacy__pc,Credit_History__pc,Current_Appointment_Status__c,Current_Role__pc,Dashboard_Reached_Date__c,Description,Discharged_from_Part_9_or_Bankruptcy__pc,DNCR_Washing_Transaction_ID__pc,DNCR_Wash_Date__pc,DNCR_Wash_Expiry__pc,Drivers_Lic_Exp__pc,Drivers_Lic_No__pc,Employer_Address__pc,Employer_Name__pc,Employer_Phone__pc,Employment_Start_Date__pc,Employment_Status__pc,Feed_Comment_check__c,FirstName,Future_Contact_Date__c,Gender__pc,Housing_Status__pc,HPI_LE_Dependants__pc,HPI_Living_Expenses__pc,Id,Industry,IsCustomerPortal,IsDeleted,IsMaster__c,IsPartner,IsPersonAccount,Is_Partner_Broker_Customer__c,Is_Phone_Broker_customer__c,JigsawCompanyId,Job_Title__pc,Landlord_Mortgage_Details__pc,LastActivityDate,LastModifiedById,LastModifiedDate,LastName,LastReferencedDate,LastViewedDate,Last_Pardot_Form_Handler_Change_Date__pc,Last_Pardot_Form_Handler__pc,LeadToCallFileRule__c,Lead_Converted_Status__pc,Lead_Groups__c,Lead_Last_Disposition_Detail__pc,Lead_Last_Disposition__pc,Lead_Type__pc,lendi_user_uuid__c,Lendi_User_uuid__pc,Length_of_Employment_Months__pc,Length_of_Residence_Months__pc,Marital_Status__pc,MasterRecordId,MC4SF__MC_Subscriber__pc,Mercury_People_ID__c,merc_current_status__c,merc_settlement_date__c,Name,Nearest_Relative_Not_Living_With_You__pc,Nearest_Relitive_Address__pc,Nearest_Relitive_Phone__pc,Nearest_Relitive_Relationship__pc,Net_Other_Weekly_Income__pc,Net_Total_Monthly_Income__pc,Net_Total_Weekly_Income__pc,Net_Weekly_Income__pc,No_Credit_History_del__pc,No_Show_Campaign_Account__c,No_Show_Campaign_Status__c,No_Show_Phone__c,NumberOfEmployees,Number_of_Children__pc,Offset_Account__pc,Other_Living_Expenses__pc,OwnerId,Ownership_Change_Date__c,Owner_Role__c,Paid_or_Unpaid_Defaults__pc,ParentId,Partner_Annual_Income__pc,Partner_Super_Balance__pc,Personal_Reference_Address__pc,Personal_Reference_Name__pc,Personal_Reference_Phone__pc,Personal_Reference_Relationship__pc,PersonContactId,PersonDepartment,PersonDoNotCall,PersonEmail,PersonEmailBouncedDate,PersonEmailBouncedReason,PersonHasOptedOutOfEmail,PersonLastCURequestDate,PersonLastCUUpdateDate,PersonLeadSource,PersonMailingAddress,PersonMailingCity,PersonMailingCountry,PersonMailingCountryCode,PersonMailingGeocodeAccuracy,PersonMailingLatitude,PersonMailingLongitude,PersonMailingPostalCode,PersonMailingState,PersonMailingStateCode,PersonMailingStreet,PersonMobilePhone,PersonTitle,Phone,PhotoUrl,Previous_Address__pc,Previous_Employer_Name__pc,Previous_Employment_Status__pc,Previous_Job_Title__pc,Previous_Landlord_Mortgage_Details__pc,Previous_Length_of_Employment_Months__pc,Previous_Length_of_Residence_Months__pc,Previous_Net_Weekly_Income__pc,RecordTypeId,rh2__Currency_Test__pc,rh2__Describe__pc,rh2__Formula_Test__pc,rh2__Integer_Test__pc,Salutation,SelfLookup__c,ShippingAddress,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,smagicinteract__SMSOptOut__pc,Source__pc,Submitter_IP__pc,Super_Balance__pc,Sync_With_Mercury_Success__pc,Sync_With_Mercury__pc,SystemModstamp,Too_Many_Credit_Enquiries__pc,Total_Expenses__pc,Type,Unbounce_Page_ID__pc,Unbounce_Page_Variant__pc,Unbounce_Submission_Date__pc,Unbounce_Submission_Time__pc,User_pwdreset__c,utm_campaign__pc,utm_content__pc,utm_medium__pc,utm_source__pc,utm_term__pc,vhc__CallFile__c,vhc__CallFile__pc,vhc__TimeZone__c,vhc__TimeZone__pc,Website,Zendesk__createdUpdatedFlag__c,Zendesk__Domain_Mapping__c,Zendesk__isCreatedUpdatedFlag__pc,Zendesk__Last_Sync_Date__c,Zendesk__Last_Sync_Date__pc,Zendesk__Last_Sync_Status__c,Zendesk__Last_Sync_Status__pc,Zendesk__Notes__c,Zendesk__notes__pc,Zendesk__Result__c,Zendesk__Result__pc,Zendesk__Tags__c,Zendesk__Tags__pc,Zendesk__zendesk_id__pc,Zendesk__Zendesk_oldTags__c,Zendesk__Zendesk_oldTags__pc,Zendesk__Zendesk_Organization_Id__c,Zendesk__Zendesk_Organization__c,Zendesk__Zendesk_OutofSync__c,Zendesk__Zendesk_OutofSync__pc FROM Account where Call_File_Is_Updated__c != true and Add_To_Call_File_Date__c = today limit 10000';
        System.debug('1');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> oppos) {
      System.debug('2');
        if (oppos != null && oppos.size() > 0) {
            List<Account> opposNew = new List<Account>();
            for (Account oppo : oppos) {
                if (oppo.LeadToCallFileRule__C!= null) {
                    //select the rule
                    LeadToCallFileRule__c rule = LeadToCallFileDAO.getLeadToCallFileRuleById(oppo.LeadToCallFileRule__C);
                    boolean isFittedRule = AccountToCallFileUtilities.checkIfaccFitTheRule(oppo, rule);
                    System.debug('isFittedRule ' + isFittedRule);
                    if (isFittedRule) {

                        oppo.vhc__CallFile__c = rule.Call_File__c;
                        oppo.Call_File_Is_Updated__c = true;
                       // oppo.Add_To_Call_File_Due_Day_Check__c = true;
                        opposNew.add(oppo);
                        
                    }
                }
            }
            update opposNew;
            System.debug(opposNew.size());
        }
    }

    global void finish(Database.BatchableContext BC) {
        BatchAddCallFileToLead b = new BatchAddCallFileToLead();
        Database.executebatch(b);
    }
}