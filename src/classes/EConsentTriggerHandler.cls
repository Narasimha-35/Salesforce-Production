/*
    This class is 
    Name                             Date                                version
    =============================================================================
    Prateek                                          1.0
    =============================================================================
*/
public class EConsentTriggerHandler extends TriggerHandler
{
  
    public override void afterInsert() 
    {
        Set<Id> lstApplicantID = new Set<Id>();
        Set<Id> setAppIdsForReqDocs = new Set<Id>();
         for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){  
         if(eCon.Applicant__c != null  && econ.Consent_Completed__c == true)
              lstApplicantID.add(eCon.Applicant__c );
           if(eCon.Applicant__c != null)
             setAppIdsForReqDocs.add(eCon.Applicant__c);
             
         }
         System.debug(lstApplicantID);
        
         if(lstApplicantID != null && lstApplicantID.size() > 0)
         {
            callVedaApi(lstApplicantID);           
         }
         if(setAppIdsForReqDocs != null && !setAppIdsForReqDocs.isEmpty())
         {
             insertEConsentRequiredDocs(setAppIdsForReqDocs);
         }
         //callVedaApi(lstApplicantID);
    }
    public override void afterUpdate() 
    {
        set<Id> lstApplicantID = new set<Id>();
         for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){  
         if(eCon.Applicant__c != null  && econ.Consent_Completed__c == true)
              lstApplicantID.add(eCon.Applicant__c );
         }
         if(lstApplicantID != null && lstApplicantID.size() > 0)
         {
            callVedaApi(lstApplicantID);
            updateRequiredDocStatus(lstApplicantID);
         }
       
    }
    
    public static void callVedaApi(Set<Id> Id)
    {
        List<click_Applicant__c>  appObj = [Select id,acf_applicant_DOB__c, acfRelationship_code__c, clickOpportunity__c,acf_Applicant_Name__c, 
                                            click_Account__r.acfWhat_is_your_postcode__pc  , 
                                            click_Account__r.Gender__pc   , acf_applicant_Employer_Name__c from  click_Applicant__c  where id  in : id];
        list<String> lstName = new List<String>();

        for(click_Applicant__c applicant : appObj   ){
            if(applicant.acf_applicant_DOB__c  != null && applicant.acf_Applicant_Name__c != null ){
                lstName.add(applicant.acf_applicant_DOB__c+applicant.acf_Applicant_Name__c);
                System.debug('####################'+lstName);
            }   
        }   
        List<acfVedaApplicantLink__c>  vedaList = [Select Name , Veda_Status__c ,Applicant__c ,Record_Creation_date__c ,Veda_Summary__c  from 
                                                acfVedaApplicantLink__c where Name  in :  lstName];
            System.debug('#######as'+vedaList);
        
        map<String,acfVedaApplicantLink__c > mapVeda = new map<String,acfVedaApplicantLink__c >();
        
        for(acfVedaApplicantLink__c  vObj : vedaList){
            mapVeda.put(vObj.name ,vObj );
            
        }
        // This list use  for old Veda records 
        List<click_Applicant__c> lstApplicant1 = new List<click_Applicant__c> ();
        
        
        // This list use  for New  Veda records 
        List<click_Applicant__c> lstApplicant2 = new List<click_Applicant__c> ();
        List<ID> lstApplicantID = new List<ID> ();
            System.debug('____________');
        for(click_Applicant__c appObj1 : appObj ){
            
            if(appObj1.acf_applicant_DOB__c  != null && appObj1.acf_Applicant_Name__c != null ){
            String tempName = appObj1.acf_applicant_DOB__c+''+appObj1.acf_Applicant_Name__c ;
                 if(mapVeda.containskey(tempName)){
                        acfVedaApplicantLink__c vobj =  mapVeda.get(tempName);
                        Boolean checkExpiry = acfCheckVedaExpiry.checkRercord(vobj);
                        System.debug('____________'+checkExpiry);
                        if(checkExpiry){
                            lstApplicant2.add(appObj1);
                            lstApplicantID.add(appObj1.ID);       
                            System.debug('exp');                        
                        }else{
                            lstApplicant1.add(appObj1); 
                        }
                     
                 }else{
                    lstApplicant2.add(appObj1); 
                    lstApplicantID.add(appObj1.ID);
                 }
            }
        }
        
        // Inserting new Veda records 
        
          if(lstApplicant2.size() > 0){
              System.debug('Batch');
            Database.executeBatch(new UpdateVedasummary(lstApplicantID), 100); 
          }
        List<acfVedaApplicantLink__c>  lstVedaConnetor = new List<acfVedaApplicantLink__c>();
        for( click_Applicant__c appObj1 :lstApplicant1){
            if(appObj1.acf_applicant_DOB__c  != null && appObj1.acf_Applicant_Name__c != null ){
            String tempName = appObj1.acf_applicant_DOB__c+''+appObj1.acf_Applicant_Name__c ;
                 if(mapVeda.containskey(tempName)){
                    acfVedaApplicantLink__c obj =  mapVeda.get(tempName);
                    if(obj.Applicant__c == appObj1.ID){
                           
                            obj.Veda_Status__c ='Active';
                            obj.Applicant__c = appObj1.id;
                            obj.Record_Creation_date__c = obj.Record_Creation_date__c;
                            lstVedaConnetor.add(obj);
                    }
                    else{
                     acfVedaApplicantLink__c vobj  = new acfVedaApplicantLink__c();
                     vobj.Name = tempName ;
                     vobj.Veda_Status__c ='Active';
                     vobj.Applicant__c = appObj1.id;
                     vobj.Veda_Summary__c = obj.Veda_Summary__c ;
                    // voj.Veda_Summary__c = obj.id ;
                     vobj.Record_Creation_date__c = obj.Record_Creation_date__c;
                     lstVedaConnetor.add(vobj);
                    }
                 }
            }
        }    
        upsert lstVedaConnetor ;  
    }
    //To insert econsent required documents
    public void insertEConsentRequiredDocs(set<id> setAppIds)
    {
        string econsent = system.Label.acfEConsent; 
        list<Required_Document__c> lstRequiredDocs = new list<Required_Document__c>();
        //Id CommunityId = ClickCommon.getCommunitySetup(Network.getNetWorkId()).id;
        list<Document_Master__c> lstDocumentmaster = [select id,Name,acf_Source__c,acfActive__c from Document_Master__c where acf_Source__c = :econsent And acfActive__c = true];
        system.debug('@@@'+lstDocumentmaster);
        map<id,click_Applicant__c> mapIdToApplicants = new map<id,click_Applicant__c>([select id,click_Applicant_Number__c,clickOpportunity__c,click_Account__c,click_Account__r.acf_Lead__pc,click_Account__r.acf_Lead__pr.isConverted from click_Applicant__c where id IN:setAppIds]);
        if(lstDocumentmaster != null && !lstDocumentmaster.isEmpty())
        {
            Document_Master__c objDocMaster = lstDocumentmaster[0];
            if(setAppIds != null && !setAppIds.isEmpty())
            {
                for(Id appId : setAppIds)
                {
                    Required_Document__c objRequiredDocument  =  new Required_Document__c();
                    objRequiredDocument.Name                  =  objDocMaster.Name;
                    objRequiredDocument.acfDocument_Master__c =  objDocMaster.Id;
                    objRequiredDocument.Click_Applicant__c    =  appId;
                    objRequiredDocument.acfStatus__c          =  'Pending';
                    objRequiredDocument.Click_Is_E_consent__c = true;
                    
                    if(mapIdToApplicants != null && mapIdToApplicants.size()>0)
                    {
                        if(mapIdToApplicants.get(appId) != null && mapIdToApplicants.get(appId).click_Applicant_Number__c != null)
                        {
                            objRequiredDocument.Name  =  objDocMaster.Name+' '+mapIdToApplicants.get(appId).click_Applicant_Number__c;
                        }
                        if(mapIdToApplicants.get(appId) != null && mapIdToApplicants.get(appId).click_Account__c != null && mapIdToApplicants.get(appId).clickOpportunity__c == null)
                        {
                            if(mapIdToApplicants.get(appId).click_Account__r.acf_Lead__pc != null && mapIdToApplicants.get(appId).click_Account__r.acf_Lead__pr.isConverted == false)
                                objRequiredDocument.Lead__c = mapIdToApplicants.get(appId).click_Account__r.acf_Lead__pc;
                        }
                        if(mapIdToApplicants.get(appId) != null && mapIdToApplicants.get(appId).clickOpportunity__c != null)
                        {
                             objRequiredDocument.acfOpportunity__c = mapIdToApplicants.get(appId).clickOpportunity__c;
                        }                    
                    }
                    
                    lstRequiredDocs.add(objRequiredDocument);
                }
                if(lstRequiredDocs != null && lstRequiredDocs.size()>0)
                {
                    insert lstRequiredDocs;
                }
            }
        }
    }
    //update status of required docs
    public void updateRequiredDocStatus(set<id> setAppIds)
    {
       list<Required_Document__c> lstRequiredDoc = [select id,acfStatus__c,Click_Applicant__c from Required_Document__c where Click_Applicant__c IN:setAppIds]; 
       if(lstRequiredDoc != null && !lstRequiredDoc.isEmpty())
       {
           for(Required_Document__c objReqDoc : lstRequiredDoc)
           {
               objReqDoc.acfStatus__c = 'Verified';
           }
           update lstRequiredDoc;
       }
    }
}