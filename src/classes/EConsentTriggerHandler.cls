/*
This class is
Name                             Date                                version
=============================================================================
Prateek                                          1.0
=============================================================================
*/
public class EConsentTriggerHandler extends TriggerHandler
{
    public override void beforeInsert() {
        /*
        Set<String> lstId = new Set<String>();
        for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){
            if(eCon.Econsent_Type__c =='Product Specific Econsent'){
            }
            if(eCon.Related_Bank_Id__c != null){
                lstId.add(eCon.Related_Bank_Id__c);
            }
        }
        List<acfBank_Detail__c>   lstBank  = [Select acfBank_Name__c ,ID from acfBank_Detail__c  where id in : lstId  ] ;
        map<Id, acfBank_Detail__c>   mapBank = new map<Id, acfBank_Detail__c> ();
        for(acfBank_Detail__c  acfBank : lstBank )
        {
            mapBank.put(acfBank.Id,acfBank );
        }
        for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){
            if(eCon.Econsent_Type__c =='Product Specific Econsent'  &&  eCon.Related_Bank_Id__c  != null  && mapBank.get( eCon.Related_Bank_Id__c) != null
            && mapBank.get( eCon.Related_Bank_Id__c).acfBank_Name__c != null ){
                eCon.Name =      mapBank.get( eCon.Related_Bank_Id__c).acfBank_Name__c + '-'+'EConsent';
            }
        }
        */
    }
    public override void afterInsert()
    {
        Set<Id> lstApplicantID = new Set<Id>();
        map<Id,List<String>>  mapEconsent = new  map<Id,List<String>>();
        Set<Id> setAppIdsForReqDocs = new Set<Id>();
        List<E_Consent__c > lstEconSent = new List<E_Consent__c >();
        for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){
            if(eCon.Applicant__c != null  && econ.Consent_Completed__c == true)
            lstApplicantID.add(eCon.Applicant__c );
            if(eCon.Applicant__c != null)
            {
                lstEconSent.add(eCon);
            }
        }
        if(lstApplicantID != null && lstApplicantID.size() > 0)
        {
            callVedaApi(lstApplicantID);
        }
        if(lstEconSent != null && !lstEconSent.isEmpty())
        {
            insertEConsentRequiredDocs(lstEconSent);
        }
    }
    
    public override void beforeUpdate()
    {
        
        
        set<Id> setBankID = new set<Id>();
        for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){
            if(eCon.Related_Bank_Id__c   != null  && econ.Consent_Completed__c == true){
               
                setBankID.add(eCon.Related_Bank_Id__c);
            }
        }
          map<Id,acf_Bank_Template__c> mapBankTemplate = new  map<Id,acf_Bank_Template__c>();
                 if(setBankID.size() > 0   )
                 {
                   List<acf_Bank_Template__c> listBankTempLate =  [Select  Body__c,   Template_Version__c ,  Click_Loans_Bank_Detail__c   from acf_Bank_Template__c where Click_Loans_Bank_Detail__c in :setBankID];
                  
                    if(listBankTempLate.size() > 0)
                    {
                    for( acf_Bank_Template__c  obj : listBankTempLate )
                    {
                    if(obj.Template_Version__c  != null  &&   obj.Click_Loans_Bank_Detail__c != null){
                    mapBankTemplate.put( obj.Click_Loans_Bank_Detail__c,obj);
                    }
                    }
                    }
                 }
                 
             for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){
            if(eCon.Related_Bank_Id__c   != null  && econ.Consent_Completed__c == true  &&   mapBankTemplate.get(eCon.Related_Bank_Id__c ) != null
             &&   mapBankTemplate.get(eCon.Related_Bank_Id__c ).Template_Version__c  != null &&  mapBankTemplate.get(econ.Related_Bank_Id__c ).Body__c
             != null  ){
                eCon.Version__c = mapBankTemplate.get(eCon.Related_Bank_Id__c ).Template_Version__c;
                econ.Template_Body__C = mapBankTemplate.get(econ.Related_Bank_Id__c ).Body__c ;
                
               }
        }    
    }
    public override void afterUpdate()
    {
        set<Id> lstApplicantID = new set<Id>();
        set<Id> setEconscentID = new set<Id>();
        for(E_Consent__c eCon : (List<E_Consent__c >) Trigger.new){
            if(eCon.Applicant__c != null  && econ.Consent_Completed__c == true){
                lstApplicantID.add(eCon.Applicant__c );
                setEconscentID.add(eCon.id);
            }
        }
        if(lstApplicantID != null && setEconscentID != null && setEconscentID.size() > 0 && lstApplicantID.size() > 0)
        {
            callVedaApi(lstApplicantID);
            updateRequiredDocStatus(lstApplicantID,setEconscentID);
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
        if(vedaList != null && !vedaList.isEmpty())
        {
            for(acfVedaApplicantLink__c  vObj : vedaList)
            {
                mapVeda.put(vObj.name ,vObj );
            }
        }
        // This list use  for old Veda records
        List<click_Applicant__c> lstApplicant1 = new List<click_Applicant__c> ();
        // This list use  for New  Veda records
        List<click_Applicant__c> lstApplicant2 = new List<click_Applicant__c> ();
        List<ID> lstApplicantID = new List<ID> ();
        System.debug('____________');
        if(appObj != null && !appObj.isempty())
        {
            for(click_Applicant__c appObj1 : appObj )
            {
                if(appObj1.acf_applicant_DOB__c  != null && appObj1.acf_Applicant_Name__c != null )
                {
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
        }
        // Inserting new Veda records
        if(lstApplicant2.size() > 0)
        {
            System.debug('Batch');
            ACFSwitch__c acfSwitch = ACFSwitch__c.getOrgDefaults();
            if (acfSwitch != null && acfSwitch.get('veda_Switch__c') != null && (Boolean) acfSwitch.get('veda_Switch__c')) 
            {
                    Database.executeBatch(new UpdateVedasummary(lstApplicantID), 100);
            }
        }
        List<acfVedaApplicantLink__c>  lstVedaConnetor = new List<acfVedaApplicantLink__c>();
        if(lstApplicant1 != null && !lstApplicant1.isEmpty())
        {
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
        }
        if(lstVedaConnetor != null && !lstVedaConnetor.isempty())
            upsert lstVedaConnetor ;
    }
    //To insert econsent required documents
    public void insertEConsentRequiredDocs(   List<E_Consent__c > mapEconsent1)
    {
        string econsent = system.Label.acfEConsent;
        set<id> setAppIds  = new   set<id> ();
        Set<Id>   lstId = new Set<Id>();
        map<ID , E_Consent__c>  mapEconsent = new map<ID , E_Consent__c>();
        for( E_Consent__c    ObjEcon :  mapEconsent1 )
        {
            if( ObjEcon.Related_Bank_Id__c  != null )
            {
                lstId.add(ID.valueof(ObjEcon.Related_Bank_Id__c) );
            }
            if(ObjEcon.Applicant__c  != null ){
                setAppIds.add(ObjEcon.Applicant__c );
            }
        }
        List<acfBank_Detail__c>   lstBank  = [Select acfBank_Name__c ,ID from acfBank_Detail__c  where id in : lstId  ] ;
        map<Id, acfBank_Detail__c>   mapBank = new map<Id, acfBank_Detail__c> ();
        for(acfBank_Detail__c  acfBank : lstBank )
        {
            mapBank.put(acfBank.Id,acfBank );
        }
        list<Required_Document__c> lstRequiredDocs = new list<Required_Document__c>();
        //Id CommunityId = ClickCommon.getCommunitySetup(Network.getNetWorkId()).id;
        list<Document_Master__c> lstDocumentmaster = [select id,Name,acf_Source__c,acfActive__c from Document_Master__c where acf_Source__c = :econsent And acfActive__c = true];
        system.debug('@@@'+lstDocumentmaster);
        map<id,click_Applicant__c> mapIdToApplicants = new map<id,click_Applicant__c>([select id,click_Applicant_Number__c,clickOpportunity__c,
        click_Account__c,click_Account__r.acf_Lead__pc,click_Account__r.acf_Lead__pr.isConverted from click_Applicant__c where id IN:setAppIds]);
        System.debug(mapIdToApplicants);
        if(lstDocumentmaster != null && !lstDocumentmaster.isEmpty())
        {
            Document_Master__c objDocMaster = lstDocumentmaster[0];
            if(mapEconsent1 != null && !mapEconsent1.isEmpty())
            {
                for(E_Consent__c appId : mapEconsent1)
                {
                    Required_Document__c objRequiredDocument  =  new Required_Document__c();
                    objRequiredDocument.Name                  =  objDocMaster.Name;
                    objRequiredDocument.acfDocument_Master__c =  objDocMaster.Id;
                    if( appId.Applicant__c != null)
                    objRequiredDocument.Click_Applicant__c    =  appId.Applicant__c ;
                    objRequiredDocument.acfStatus__c          =  'Pending';
                    objRequiredDocument.Click_Is_E_consent__c = true;
                    String Type ='';
                    if(  appId.Econsent_Type__c   != null  &&  appId.Econsent_Type__c    =='Product Specific Econsent')
                    {
                        objRequiredDocument.Type__C = 'Product Specific';
                    }
                    if(appId.Econsent_Type__c   != null  &&  appId.Econsent_Type__c    == 'General Econsent')
                    {
                        objRequiredDocument.Type__C =   'General' ;
                    }
                    if(appId.Related_Bank_Id__c   != null   )
                    objRequiredDocument.Bankid__C = appId.Related_Bank_Id__c;
                    objRequiredDocument.EconsentID__C = appId.ID ;
                    
                    if(objRequiredDocument.Bankid__C != null && mapBank != null && !mapBank.isEmpty() && mapBank.get(objRequiredDocument.Bankid__C) != null
                        && mapBank.get(objRequiredDocument.Bankid__C).acfBank_Name__c != null)
                    {
                        objRequiredDocument.Name =   mapBank.get(objRequiredDocument.Bankid__C).acfBank_Name__c + '-'+'EConsent ';
                        if(mapIdToApplicants != null && !mapIdToApplicants.isEmpty() && mapIdToApplicants.get(appId.Applicant__c) != null 
                            && mapIdToApplicants.get(appId.Applicant__c).click_Applicant_Number__c != null)
                            objRequiredDocument.Name += mapIdToApplicants.get(appId.Applicant__c).click_Applicant_Number__c;    
                    }
                    
                    if(mapIdToApplicants != null && mapIdToApplicants.size()>0)
                    {
                        if(mapIdToApplicants.get(appId.Applicant__c) != null && mapIdToApplicants.get(appId.Applicant__c).click_Applicant_Number__c != null  &&  objRequiredDocument.Type__C != 'Product Specific')
                        {
                            objRequiredDocument.Name  =  objDocMaster.Name+' '+mapIdToApplicants.get(appId.Applicant__c).click_Applicant_Number__c;
                        }
                        if(mapIdToApplicants.get(appId.Applicant__c) != null && mapIdToApplicants.get(appId.Applicant__c).click_Account__c != null && mapIdToApplicants.get(appId.Applicant__c).clickOpportunity__c == null)
                        {
                            if(mapIdToApplicants.get(appId.Applicant__c).click_Account__r.acf_Lead__pc != null && mapIdToApplicants.get(appId.Applicant__c).click_Account__r.acf_Lead__pr.isConverted == false)
                            objRequiredDocument.Lead__c = mapIdToApplicants.get(appId.Applicant__c).click_Account__r.acf_Lead__pc;
                        }
                        if(mapIdToApplicants.get(appId.Applicant__c) != null && mapIdToApplicants.get(appId.Applicant__c).clickOpportunity__c != null)
                        {
                            objRequiredDocument.acfOpportunity__c = mapIdToApplicants.get(appId.Applicant__c).clickOpportunity__c;
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
    public void updateRequiredDocStatus(set<id> setAppIds,Set<ID> consentID)
    {
        list<Required_Document__c> lstRequiredDoc = [select id,acfStatus__c,Click_Applicant__c from Required_Document__c where Click_Applicant__c IN:setAppIds and EconsentID__c IN:consentID];
        if(lstRequiredDoc != null && !lstRequiredDoc.isEmpty())
        {
            for(Required_Document__c objReqDoc : lstRequiredDoc)
            {
                objReqDoc.acfStatus__c = 'Verified';
            }
            update lstRequiredDoc;
        }
    }
    public override void afterDelete(){
        Set<id> appIdSet = new Set<id>();
        Set<String> bankIdSet = new Set<String>();
        List<Required_Document__c> reqListToDelete = new List<Required_Document__c>();
        for(E_Consent__c econ:(List<E_Consent__c >) Trigger.old){
            if(econ.Applicant__c !=null){
                appIdSet.add(econ.Applicant__c);
            }
            if(String.isNotEmpty(econ.Related_Bank_Id__c)){
                bankIdSet.add(econ.Related_Bank_Id__c);
            }
        }
        if(appIdSet.size() > 0){
            List<click_Applicant__c> appList = [Select id, (Select id,BankID__c FROM Required_Documents__r) FROM click_Applicant__c where id=:appIdSet];
            if(appList !=null && appList.size() > 0){
                for(click_Applicant__c app:appList ){
                    for(Required_Document__c req:app.Required_Documents__r){
                        if(bankIdSet.contains(req.BankID__c)){
                            reqListToDelete.add(req);
                        }
                    }
                }
            }
            if(reqListToDelete.size() > 0){
                delete reqListToDelete;
            }
        }
    }
}