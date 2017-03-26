public class AssetAndLiabilityTriggerHandler extends TriggerHandler
{
   Public List<Funding_Position_Detail__c> fundPosdList; 
   Public List<Funding_Position_Detail__c> fundPosdUpdate;
   List<Funding_Position__c> fPosExistingNew = new List<Funding_Position__c>(); 
   Map<String,Opportunity> oppRecTypeMap = new Map<string,Opportunity>();
   Map<String,Account> accRecTypeMap = new Map<string,Account>();
   Public List<Funding_Position_Detail__c> fundPosdListToBeDeleted;
   
   List<Funding_Position_Detail__c> fpdInsert = new List<Funding_Position_Detail__c>();
   List<Funding_Position_Detail__c> fpdUpdate = new List<Funding_Position_Detail__c>();
   List<Funding_Position_Detail__c> fpdDelete = new List<Funding_Position_Detail__c>();
   public override void afterInsert() 
    {
       System.debug('@@@ afterInsert sf ' );
       insertFSRecords(trigger.new);
      
       createFundingPosition('Insert');
       calcLoanValueMaxAsset('Insert',new Set<Id>());
       
       //createFPD(trigger.new);
       //updateInsertData();
    }
    public override void afterDelete() 
    {
       calcLoanValueMaxAsset('Delete',new Set<Id>());
    }
    
    
    
    
    public override void afterUpdate() 
    {
        System.debug('@@@ afterUpdate sf ' );
        UpdateFSRecords();
        updateIERecords(trigger.new);
        string CLEARINGLOAN = 'Clearing_From_This_Loan__c';
        string TOBEPURCHASED = 'To_Be_Purchased__c';
        string USED_AS_SECURITY = 'Used_as_Security__c';
        string VALUE = 'Value__c';
        set<id> setOfAssetId = new set<id>();
        Set<id> setOfOppId = new Set<id>();
        Set<id> setOfAccId = new Set<id>();
        Map<Id,List<Funding_Position_Detail__c>> mapIdToFundingPositionDetail = new Map<Id,List<Funding_Position_Detail__c>>();
        List<Funding_Position_Detail__c> lstDelFundingPositiondetail = new List<Funding_Position_Detail__c>();
        List<Asset_And_Liability__c> LstAssetandLiability = new List<Asset_And_Liability__c>();
        for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new))
        {
            if(assLiab.Clearing_From_This_Loan__c != trigger.oldMap.get(assLiab.id).get(CLEARINGLOAN) || (assLiab.To_Be_Purchased__c != trigger.oldMap.get(assLiab.id).get(TOBEPURCHASED))||
                (assLiab.Used_as_Security__c != trigger.oldMap.get(assLiab.id).get(USED_AS_SECURITY)))
            {
                setOfAssetId.add(assLiab.id);
               
            }       
            if(assLiab.Opportunity__c !=null){
                setOfOppId.add(assLiab.Opportunity__c);
            }
            if(assLiab.Account__c!=null){
                setOfAccId.add(assLiab.Account__c);
            }
            if(assLiab.Opportunity__c !=null && assLiab.Used_as_Security__c != trigger.oldMap.get(assLiab.id).get(USED_AS_SECURITY) || assLiab.Value__c  != trigger.oldMap.get(assLiab.id).get(VALUE)){
                calcLoanValueMaxAsset('Update',new Set<Id>()); 
            } 
        }
        
       
        
        if(setOfOppId!=null && setOfOppId.size() > 0){
            oppRecTypeMap = new Map<String,Opportunity>([Select id,Recordtype.Name From Opportunity where id=:setOfOppId]);
        }
        if(setOfAccId!=null && setOfAccId.size() > 0){
            accRecTypeMap = new Map<String,Account>([Select id,Recordtype.Name From Account where id=:setOfAccId]);
        }
        if(setOfAssetId != null && setOfAssetId.size() > 0)
        {
            LstAssetandLiability = [Select id,(Select id,Name,Amount__c,Detail_Type__c,Category__c from Funding_Position_Details__r)
                                                        From Asset_And_Liability__c where Id IN:setOfAssetId];
            if(LstAssetandLiability != null && !LstAssetandLiability.isEmpty()) 
            {
                for(Asset_And_Liability__c objAsset : LstAssetandLiability)
                {
                    mapIdToFundingPositionDetail.put(objAsset.Id,objAsset.Funding_Position_Details__r);
                }
            }   
        }
        for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new))
        {
            if(mapIdToFundingPositionDetail != null && !mapIdToFundingPositionDetail.isEmpty() && mapIdToFundingPositionDetail.get(assLiab.Id) != null 
               && mapIdToFundingPositionDetail.get(assLiab.Id).size() > 0)
            {
                for(Funding_Position_Detail__c objFundingPosDetail : mapIdToFundingPositionDetail.get(assLiab.Id))
                {
                    lstDelFundingPositiondetail.add(objFundingPosDetail);
                }
            }
        }
        
        System.debug('@@@ saasfocus sf '+lstDelFundingPositiondetail );
        if(lstDelFundingPositiondetail != null && lstDelFundingPositiondetail.size() > 0)
        {
            System.debug('Insert ' );
            delete lstDelFundingPositiondetail;
            createFundingPosition('Insert');
        }
        else
        {
            System.debug('Update' );
            createFundingPosition('Update');
        }
        
        //updateFPD(trigger.new);
        //updateInsertData();
        
    }
    
    
        
    public override void beforeInsert() 
    {
        checkClearingLoan();
        tagOpportunityafterConversion();
        updateStateFromLead();
        //createFundingPosition();
        
    }
    
    
    public override void beforeDelete(){
       deleteFPD(trigger.old);
    }
    
    public void deleteFPD(List<Asset_And_Liability__c> asetLiabObjList){
    
        Set<Id> fpIDSet = new Set<Id>();             
        for(Asset_And_Liability__c assetlibObj :asetLiabObjList){           
            fpIDSet.add(assetlibObj.ID);        
        }
        System.debug('@@saasfocus sf 1 '+fpIDSet);
        
        if(fpIDSet <> null){
           List<Funding_Position_Detail__c>  fpdObjList  = [Select Id,Asset_And_Liability__c,Amount__c,Category__c,Detail_Type__c,
            Funding_Position__c from Funding_Position_Detail__c where Asset_And_Liability__c IN : fpIDSet AND Category__c = 'Borrower Contribution' AND Detail_Type__c = 'Deposit'] ;
           
           System.debug('@@saasfocus sf 2 '+fpdObjList);
                
           if(fpdObjList  <> null && fpdObjList.size() > 0){
             
              Delete fpdObjList ;
           }    
                
          
         }   
        
    }
    
    /*
    public void createFPD(List<Asset_And_Liability__c> asetLiabObj){
        System.debug('@@@ saasfocus createFPD ');
        
        
        Set<Id> accountID = new Set<Id>();
        for(Asset_And_Liability__c assetlibObj :asetLiabObj){
            if(assetlibObj.Account__c <> null){
                accountID .add(assetlibObj.Account__c);
            }
        }
        System.debug('@@saas sf 6 '+accountID);
        if(accountID <> null){
            
            Map<Id,List<Id>> accountIdToFPIdMap = new Map<Id,List<Id>> ();
            for(Funding_Position__c fpObj : [Select id,Account__c from Funding_Position__c where Account__c In : accountID]){
                
                if(accountIdToFPIdMap.get(fpObj.Account__c) != null && accountIdToFPIdMap.get(fpObj.Account__c).size() > 0){
                    
                    List<Id> fpIdSet = accountIdToFPIdMap.get(fpObj.Account__c);
                    fpIdSet.add(fpObj.id);
                    accountIdToFPIdMap.put(fpObj.Account__c , fpIdSet);
                    
                }else{
                    List<Id> fpIdSet = new List<Id>();
                    fpIdSet.add(fpObj.id);
                    accountIdToFPIdMap.put(fpObj.Account__c , fpIdSet);
                }
            }
            System.debug('@@saas sf 7 '+accountIdToFPIdMap);
            
            for(Asset_And_Liability__c assetlibObj :asetLiabObj){
                System.debug('@@saas sf 8 '+assetlibObj);
                
                if(assetlibObj.Use_As_Borrower_Contributions_To_Loan__c <> null && assetlibObj.Use_As_Borrower_Contributions_To_Loan__c == true && accountIdToFPIdMap <> null && accountIdToFPIdMap.get(assetlibObj.Account__c) <> null && accountIdToFPIdMap.get(assetlibObj.Account__c).get(0) <> null){
                
                    Funding_Position_Detail__c fpdObj = new Funding_Position_Detail__c();
                                     
                    fpdObj.Category__c = 'Borrower Contribution';
                    fpdObj.Detail_Type__c     = 'Deposit';
                    fpdObj.Amount__c     = assetlibObj .Value__c ;
                    fpdObj.Funding_Position__c = accountIdToFPIdMap.get(assetlibObj.Account__c).get(0);
                    fpdObj.Asset_And_Liability__c = assetlibObj .id ;  
                    fpdObj.name =   assetlibObj.name+'-'+'Borrower Contribution';               
                    
                    System.debug('@@saasfocus 9 '+fpdObj);
                    fpdInsert.add(fpdObj);
                }   
            }
        }
             
    }
    */
    
     public void createFPD(Asset_And_Liability__c asetLiabObj , Map<Id,Funding_Position__c > accIdToFPMap){
        System.debug('@@@ saasfocus 1 ');
            
        //if((accIdToFPMap <> null && accIdToFPMap.get(asetLiabObj .Account__c) <> null && accIdToFPMap.get(asetLiabObj .Account__c).id <> null && )){//
            if(OppFPtMap.get(asetLiabObj.Opportunity__c) != null){
                Funding_Position_Detail__c fpdObj = new Funding_Position_Detail__c();
                                 
                fpdObj.Category__c = 'Borrower Contribution';
                fpdObj.Detail_Type__c     = 'Deposit';
                fpdObj.Amount__c     = asetLiabObj .Value__c ;
                
                fpdObj.Funding_Position__c = OppFPtMap.get(asetLiabObj .Opportunity__c).id;
                fpdObj.Asset_And_Liability__c = asetLiabObj .id ;  
                fpdObj.name =   asetLiabObj.name+'-'+'Borrower Contribution';               
                
                System.debug('@@saasfocus 1 '+fundPosdList);
                fundPosdList.add(fpdObj);
            }
        //}  
    }
    
    /*
    public void updateFPD(List<Asset_And_Liability__c> asetLiabObjList){
        System.debug('@@@ saasfocus updateFPD ');
        
        
        
        Set<Id> fpIDSet = new Set<Id>();
        Map<Id,List<Funding_Position_Detail__c>> assLibIdToFPMap = new Map<Id,List<Funding_Position_Detail__c>>();
        
        for(Asset_And_Liability__c assetlibObj :asetLiabObjList){           
            fpIDSet.add(assetlibObj.ID);        
        }
        System.debug('@@saasfocus sf 1 '+fpIDSet);
        
        if(fpIDSet <> null){
            for(Funding_Position_Detail__c  fpdObj : [Select Id,Asset_And_Liability__c,Amount__c,Category__c,Detail_Type__c,Funding_Position__c from Funding_Position_Detail__c where Asset_And_Liability__c IN : fpIDSet]){
                
                if(assLibIdToFPMap.get(fpdObj.Asset_And_Liability__c) != null && assLibIdToFPMap.get(fpdObj.Asset_And_Liability__c).size() > 0){
                    List<Funding_Position_Detail__c> fpdSet = assLibIdToFPMap.get(fpdObj.Asset_And_Liability__c) ;
                    fpdSet.add(fpdObj);
                    assLibIdToFPMap.put(fpdObj.Asset_And_Liability__c , fpdSet);
                }else{
                    
                    List<Funding_Position_Detail__c> fpdSet = new List<Funding_Position_Detail__c> () ;
                    fpdSet.add(fpdObj);
                    assLibIdToFPMap.put(fpdObj.Asset_And_Liability__c , fpdSet);
                }
                
            }
            System.debug('@@saasfocus sf 2 '+assLibIdToFPMap);
            List<Asset_And_Liability__c> assLibObjListToCreate = new List<Asset_And_Liability__c>();
            
            for(Asset_And_Liability__c assLibObj :asetLiabObjList){
                
                
                List<Funding_Position_Detail__c> listFPDetails = assLibIdToFPMap.get(assLibObj.ID);
                System.debug('@@saasfocus sf 3 '+listFPDetails);
                if(assLibObj.Use_As_Borrower_Contributions_To_Loan__c == true){
                    if(listFPDetails <> null && listFPDetails.size() > 0){
                        for(Funding_Position_Detail__c fpdObj : listFPDetails){
                            
                            fpdObj.Category__c = 'Borrower Contribution';
                            fpdObj.Detail_Type__c     = 'Deposit';
                            fpdObj.Amount__c     = assLibObj .Value__c ;
                            //fpdObj.Funding_Position__c = fpdObj.Funding_Position__c;
                            fpdObj.Asset_And_Liability__c = assLibObj .id ;  
                            fpdObj.name =   assLibObj.name+'-'+'Borrower Contribution';         
                            System.debug('@@saasfocus sf 4 '+fpdObj);
                            fpdUpdate.add(fpdObj);
                        }
                    }else{
                        System.debug('@@saasfocus sf 5 ');
                        assLibObjListToCreate.add(assLibObj) ;
                    }  
                }else{
                    if(listFPDetails <> null && listFPDetails.size() > 0){
                       System.debug('@@saasfocus sf 7 '+listFPDetails);
                       fpdDelete.addAll(listFPDetails);
                    }
                }                   
                
            }
            
            if(assLibObjListToCreate <> null && assLibObjListToCreate.size() > 0){
                createFPD(assLibObjListToCreate) ;
                
            }
            
        }   
             
    }
    
    public void updateInsertData(){
        if(fpdInsert <> null && fpdInsert.size() > 0){
            Insert fpdInsert ;
        }  
        if(fpdUpdate <> null && fpdUpdate.size() > 0){
            Update fpdUpdate ;
        }
        if(fpdDelete <> null && fpdDelete.size() > 0){
            Delete fpdDelete ;
        }
        
    }*/
    
    
      /*
            =============================================================================
            Name                             Date                                version
            =============================================================================
            Manish Chandra                  17/05/2016                                1.0
            =============================================================================
            Create funding position & detail & also tag opportunity after funding position insertion.
            =============================================================================
        */ 
    public void updateStateFromLead(){
        
        set<id> accIdSet = new Set<id>();
        Map<id,List<Asset_And_Liability__c>> accAsettMap = new Map<id,List<Asset_And_Liability__c>>();
        Map<String,string> stateMap = new Map<String,String>();
        
        for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            if(assLiab.Account__c !=null){
                accIdSet.add(assLiab.Account__c);
                if(!accAsettMap.containsKey(assLiab.Account__c))
                    accAsettMap.put(assLiab.Account__c,new List<Asset_And_Liability__c>());
                accAsettMap.get(assLiab.Account__c).add(assLiab);
            }
        }
        
        List<Lead> leadList = [Select id,acf_partner_account__c,acfWhat_is_your_postcode__c,ConvertedAccountId,IsConverted from lead where acf_partner_account__c =:accIdSet OR ConvertedAccountId =:accIdSet LIMIT 100];
        
        List<State__c> stateList = [SELECT acfState_Short_Name__c,Name FROM State__c];
        for(State__c st:stateList){
            if(st.Name !=null && st.Name != '')
                stateMap.put(st.Name,st.acfState_Short_Name__c);
        }
        system.debug('###stateMap'+stateMap);
        system.debug('###leadList'+leadList);
        for(Lead lList:leadList){
            for(State__c st:stateList){
                if(lList.acfWhat_is_your_postcode__c !=null && lList.acfWhat_is_your_postcode__c !=''){
                    if(lList.acfWhat_is_your_postcode__c.contains(st.Name)){
                        if(lList.IsConverted == true){
                            for(Asset_And_Liability__c aLiab:accAsettMap.get(lList.ConvertedAccountId)){
                                aLiab.State__c = stateMap.get(st.Name);
                            }
                        }
                        else{
                            for(Asset_And_Liability__c aLiab:accAsettMap.get(lList.acf_partner_account__c)){
                                aLiab.State__c = stateMap.get(st.Name);
                            }
                        }
                    }
                }
            }
        }
    }   
    public void checkClearingLoan(){
         for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new))
         {
            // changes done by Ankit 
            // added GUID functionality.
            if(string.isEmpty(assLiab.Lendi_asset_and_liablity_uuid__c))
            {
                List<string> lstGuid = new List<string>();
                lstGuid = Utilities.NewGuid();
                if(lstGuid != null && !lstGuid.isEmpty())
                    assLiab.Lendi_asset_and_liablity_uuid__c = lstGuid[0];
            }
             if(assLiab.recordtypeid !=null){
                 string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(assLiab.recordtypeid).getname();
                 if(recordtypename == 'Liability Mortgage Loan' && assLiab.Name != null && assLiab.Name.contains('Liabilities Mortgage Loan')){
                    assLiab.Clearing_From_This_Loan__c = true; 
                 }
             }
         }
    }
    public void tagOpportunityafterConversion(){
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        Set<Id> accIdSet = new Set<Id>();
        for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            if(assLiab.Account__c !=null && assLiab.Opportunity__c == null){
                accIdSet.add(assLiab.Account__c);
            }
        }
        List<Lead> leadList = [SELECT id,ConvertedOpportunityId,ConvertedAccountId FROM Lead where ConvertedAccountId = :accIdSet];
        if(leadList != null && !leadList.IsEmpty())
        {
            for(Lead ld:leadList){
                if(ld.ConvertedAccountId  !=null ){
                    leadMap.put(ld.ConvertedAccountId,ld);
                }
            }
        }
        system.debug('##leadMap'+leadMap);
        for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            if(assLiab.Account__c !=null){
                if(leadMap.containsKey(assLiab.Account__c)){
                    assLiab.Opportunity__c = leadMap.get(assLiab.Account__c).ConvertedOpportunityId;
                }
            }
        }
    }
    
    List<Funding_Position__c> fundPosdListforLendi ;
    map<Id,Id> mapOfrecordType  ;
    Map<Id,Funding_Position__c> OppFPtMap ;
    public void createFundingPosition(String event)
    {        
         fundPosdList = new List<Funding_Position_Detail__c>();
         
         fundPosdListforLendi = new List<Funding_Position__c>();
         
         fundPosdUpdate = new List<Funding_Position_Detail__c>();
         List<Funding_Position__c> fPosExistingList = new List<Funding_Position__c>(); 
         
         Set<Id> oppId = new Set<Id>();
         Set<Id> accId = new Set<Id>();
         Map<Id,Funding_Position__c> accountFPCountMap = new Map<Id,Funding_Position__c>();
         Map<Id,Id> accountOpportunityMap = new Map<Id,Id>();
         Map<Id,OpportunityLineItem> oppLineItemMap = new Map<Id,OpportunityLineItem>();
         Map<Id,List<Funding_Position_Detail__c>> assetLiabMap = new Map<Id,List<Funding_Position_Detail__c>>();
         
         List<Id> idObj = new List<Id> ();
         List<Id> idAccObj = new List<Id> ();
        
         for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
             if(assLiab.Opportunity__c != null )
             idObj.add(assLiab.Opportunity__c);
            
            if(assLiab.Account__c != null )
             idAccObj.add(assLiab.Account__c);
         }
         
         System.debug('@@@saasfocus 21 '+idObj); 
         System.debug('@@@saasfocus 22 '+idAccObj); 
         
        
        List<opportunity> oppOobj = [Select Id , recordtypeid,recordtype.name, AccountId from Opportunity  where id in : idObj  and recordtypeid != null ] ;
       
         mapOfrecordType = new  map<Id,Id>();
         
         for(opportunity opp :oppOobj ){
             mapOfrecordType.put(opp.ID ,  opp.recordtypeid);
             oppRecTypeMap.put(opp.ID ,  opp);
        
         }
         
         System.debug('@@@saasfocus 23 '+mapOfrecordType);
         List<Account> Accountobj = [Select Id , recordtypeid,recordtype.name from Account  where id in : idAccObj  and recordtypeid != null ] ;
         
         for(Account  accObj :  Accountobj ){
            mapOfrecordType.put(accObj.ID ,  accObj.recordtypeid);
            accRecTypeMap.put(accObj.ID ,  accObj); 
             
         }
         System.debug('@@@saasfocus 24 '+mapOfrecordType);
         
         Set<Id>  LendiOppId = new Set<Id>();
         for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            /*System.debug('@@@saasfocus 15 '+assLiab.Account__c); 
            System.debug('@@@saasfocus 16 '+mapOfrecordType.get(assLiab.Account__c)); 
            System.debug('@@@saasfocus 17 '+Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname()); 
            System.debug('@@@saasfocus 18 '+assLiab.Opportunity__c); 
            System.debug('@@@saasfocus 19 '+mapOfrecordType.get(assLiab.Opportunity__c)); 
            System.debug('@@@saasfocus 20 '+Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname()); */
        
            
            if(assLiab.Account__c !=null   && mapOfrecordType.get(assLiab.Account__c) != null  &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi'){
                accId.add(assLiab.Account__c);
                if(assLiab.Opportunity__c != null){
                    oppId.add(assLiab.opportunity__c);
                    accountOpportunityMap.put(assLiab.Account__c,assLiab.Opportunity__c);
                }
             }
             
             if(assLiab.Opportunity__c  != null  && assLiab.Opportunity__c != null && mapOfrecordType.get(assLiab.Opportunity__c) != null  &&  Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi' ){
                 LendiOppId.add(assLiab.Opportunity__c);
             }
             
         }
        
         System.debug('@@@saasfocus 10 '+LendiOppId);
         System.debug('@@@saasfocus 14 '+accId);
         
         fundPosdListforLendi = [Select id,Account__c   ,Opportunity__c from  Funding_Position__c where Opportunity__c   in :LendiOppId ];
         fPosExistingList = [Select id,Account__c from Funding_Position__c where Account__c  in :accId];
         
          System.debug('@@@saasfocus 12 '+fundPosdListforLendi);
          System.debug('@@@saasfocus 13 '+fPosExistingList);
          
         if(fPosExistingList.size() > 0){
             for(Funding_Position__c fp:fPosExistingList){
                accountFPCountMap.put(fp.Account__c,fp);
             }
         }
         OppFPtMap = new Map<Id,Funding_Position__c>();
         if(fundPosdListforLendi.size() > 0){
               for(Funding_Position__c fp:fundPosdListforLendi){
                    OppFPtMap.put(fp.Opportunity__C , fp);
               }
         }

         if(oppId.size() > 0){
            List<OpportunityLineItem> oppLineList = [SELECT acfLegal_Fees__c,OpportunityId,
            clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c FROM OpportunityLineItem where OpportunityId =:oppId ORDER BY CreatedDate ASC LIMIT 1];
            if(oppLineList.size() > 0){
                for(OpportunityLineItem oli:oppLineList){
                    if(!oppLineItemMap.containsKey(oli.OpportunityId)){
                        oppLineItemMap.put(oli.OpportunityId,oli);
                    }
                }
            }
         }
         Map<Id,OpportunityLineItem> oppLineItemMapForlendi = new Map<Id,OpportunityLineItem>();
         if(LendiOppId.size() > 0){
              List<OpportunityLineItem> oppLineList = [SELECT acfLegal_Fees__c,OpportunityId,clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c FROM OpportunityLineItem where OpportunityId =:LendiOppId ORDER BY CreatedDate ASC LIMIT 1];
            if(oppLineList.size() > 0){
                for(OpportunityLineItem oli:oppLineList){
                    if(!oppLineItemMapForlendi.containsKey(oli.OpportunityId)){
                        oppLineItemMapForlendi.put(oli.OpportunityId,oli);
                    }
                }
            }
         }
        
         for(Id acc:accId){
            System.debug('@@@team saasfocus 11 '+accountFPCountMap);  
            if(accountFPCountMap !=null && !accountFPCountMap.containsKey(acc)){
                Funding_Position__c fpObject = new Funding_Position__c();
                fpObject.Account__c = acc;
                if(accountOpportunityMap.containsKey(acc)){
                    fpObject.Opportunity__c =  accountOpportunityMap.get(acc);
                    if(oppLineItemMap.containsKey(fpObject.Opportunity__c) && oppLineItemMap.get(fpObject.Opportunity__c).acfLegal_Fees__c !=null && oppLineItemMap.get(fpObject.Opportunity__c).clickEstablishment_Fee__c !=null && oppLineItemMap.get(fpObject.Opportunity__c).clickMortgage_Risk_Fee__c !=null)
                        fpObject.Lender_Set_Up_Fees__c = (Integer)oppLineItemMap.get(fpObject.Opportunity__c).acfLegal_Fees__c + (Integer) oppLineItemMap.get(fpObject.Opportunity__c).clickEstablishment_Fee__c + (Integer) oppLineItemMap.get(fpObject.Opportunity__c).clickMortgage_Risk_Fee__c;
                }
                fPosExistingNew.add(fpObject);
            }

         }
         system.debug('@@@lendiId'+LendiOppId);
         for(Id acc: LendiOppId){
            System.debug('@@@team saasfocus 8 '+OppFPtMap); 
            System.debug('@@@team saasfocus 9 '+OppFPtMap.containsKey(acc));
            if(OppFPtMap !=null && !OppFPtMap.containsKey(acc)){
                system.debug('@@@lendiIdEntered');
                Funding_Position__c fpObject = new Funding_Position__c();
                fpObject.Opportunity__C = acc;
               
                    if(oppLineItemMapForlendi.containsKey(fpObject.Opportunity__c) && oppLineItemMapForlendi.get(fpObject.Opportunity__c).acfLegal_Fees__c !=null && oppLineItemMapForlendi.get(fpObject.Opportunity__c).clickEstablishment_Fee__c !=null && oppLineItemMapForlendi.get(fpObject.Opportunity__c).clickMortgage_Risk_Fee__c !=null)
                        
                        fpObject.Lender_Set_Up_Fees__c = (Integer)oppLineItemMapForlendi.get(fpObject.Opportunity__c).acfLegal_Fees__c + (Integer) oppLineItemMapForlendi.get(fpObject.Opportunity__c).clickEstablishment_Fee__c + (Integer) oppLineItemMapForlendi.get(fpObject.Opportunity__c).clickMortgage_Risk_Fee__c;
                
                fPosExistingNew.add(fpObject);
            }

         }
         system.debug('@@@fundingExist'+fPosExistingNew +' event '+event);
         if(fPosExistingNew.size() > 0 && event == 'Insert'){
             system.debug('@@@funding');
             insert fPosExistingNew;
         }
         set<id> fundingPosSet = new set<id>();
         if(fPosExistingNew.size() > 0){ 
             system.debug('@@@funding1');  
             for(Funding_Position__c fpId:fPosExistingNew){
                 fundingPosSet.add(fpId.id);
             }
         }
           
         if(fundingPosSet.size() > 0){
             for(Funding_Position__c fp:[Select id,Account__c from Funding_Position__c where id IN:fundingPosSet]){
                 accountFPCountMap.put(fp.Account__c,fp);
             }
         }

         List<Asset_And_Liability__c> assLiabList = [Select id,(Select id,Name,Amount__c,Detail_Type__c,Category__c from Funding_Position_Details__r) From Asset_And_Liability__c where Id IN: trigger.newmap.keyset()];
         for(Asset_And_Liability__c assLiab:assLiabList){
            assetLiabMap.put(assLiab.id,assLiab.Funding_Position_Details__r);
         }

         string STATE = 'State__c';
         string VALUE = 'Value__c';
         string PRIMARY_PURPOSE = 'Primary_Purpose__c';
         string LIM = 'Limit__c';
         string CURRENT_BALANCE = 'Current_Balance__c';
         string REPAYMENT = 'Repayments__c';
         string PROPERTYTYPE = 'Property_Status__c';
         string FIRSTHOMEBUYER = 'First_Home_Buyer__c';

         for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            string recordtypename ='';
            string stampresp = '';
            if(assLiab.recordtypeid !=null)
                recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(assLiab.recordtypeid).getname();
            if(recordtypename == 'Liability Mortgage Loan' && assLiab.Clearing_From_This_Loan__c && event == 'Insert'){
                insertFPLiabilityRecords( assLiab, accountFPCountMap);
            }
            
            // added by amar start
            if(assLiab.Use_as_borrower_contributions_to_loan__c <> null && assLiab.Use_as_borrower_contributions_to_loan__c == true  && event == 'Insert'){
                
                createFPD( assLiab, accountFPCountMap);
            }
            
            
            if(assLiab.Use_as_borrower_contributions_to_loan__c <> null && assLiab.Use_as_borrower_contributions_to_loan__c == true  && event == 'Update'){
                if(assetLiabMap.get(assLiab.id).size() == 0){
                        createFPD( assLiab, accountFPCountMap);
                }else{
                    for(Funding_Position_Detail__c fpd:assetLiabMap.get(assLiab.id))
                    {
                        if(fpd.Category__c == 'Borrower Contribution' && fpd.Detail_Type__c == 'Deposit'){
                            fpd.Amount__c     = assLiab .Value__c ; 
                            fpd.name =  assLiab.name+'-'+'Borrower Contribution';                   
                            fundPosdUpdate.add(fpd);    
                            System.debug('@@@saasfocus team '+fundPosdUpdate);
                        }                       
                    }
                    
                }
                
            }
            
            if(assLiab.Use_as_borrower_contributions_to_loan__c <> null && assLiab.Use_as_borrower_contributions_to_loan__c == false  && event == 'Update'){
                fundPosdListToBeDeleted = new List<Funding_Position_Detail__c>() ;
                for(Funding_Position_Detail__c fpd:assetLiabMap.get(assLiab.id)){ 
                    if(fpd.Category__c == 'Borrower Contribution' && fpd.Detail_Type__c     == 'Deposit'){
                        fundPosdListToBeDeleted.add(fpd);    
                        System.debug('@@@saasfocus team '+fundPosdListToBeDeleted);
                    }                   
                }           
            }
            
            if(recordtypename == 'Liability Mortgage Loan' && assLiab.Clearing_From_This_Loan__c && event == 'Update'){
                if(assetLiabMap.get(assLiab.id).size() == 0){
                    insertFPLiabilityRecords(assLiab, accountFPCountMap);
                }
                else
                {
                    for(Funding_Position_Detail__c fpd:assetLiabMap.get(assLiab.id))
                    {
                        if(assLiab.Repayments__c != null && assLiab.Repayments__c != trigger.oldMap.get(assLiab.id).get(REPAYMENT))
                        {
                            if(fpd.Detail_Type__c == 'Potential Accrued Interest')
                            {
                                if(assLiab.Repayments__c != null)
                                {
                                    fpd.Name = assLiab.Name + '-' + assLiab.Repayments__c;
                                    if(assLiab.Repayment_Frequency__c == 'Weekly'  )
                                        fpd.Amount__c = assLiab.Repayments__c * 52/12 *0.5 ;
                                    if(assLiab.Repayment_Frequency__c == 'Monthly'  )
                                        fpd.Amount__c = assLiab.Repayments__c * 1 *0.5 ;  
                                    if(assLiab.Repayment_Frequency__c == 'Anually'  )
                                        fpd.Amount__c = assLiab.Repayments__c * 1/12 * 0.5 ;  
                                    if(assLiab.Repayment_Frequency__c == 'Fortnightly'  )
                                        fpd.Amount__c = assLiab.Repayments__c * 26/12* 0.5 ;
                                    fundPosdUpdate.add(fpd);
                                 }
                                 else
                                 {
                                     fpd.Name = assLiab.Name + '-' + null;
                                     fpd.Amount__c = 0;
                                     fundPosdUpdate.add(fpd);
                                 }
                             }
                             
                        }

                        if(assLiab.Limit__c != trigger.oldMap.get(assLiab.id).get(Lim)){
                            if(fpd.Detail_Type__c == 'Home Loan to Repay'){
                                fpd.Amount__c = assLiab.Limit__c;
                                fpd.Name = assLiab.Name + '-' + assLiab.Limit__c;
                                fundPosdUpdate.add(fpd);
                            }
                            
                        }
                        
                    }
                }
            }

            if(recordtypename.Contains('Liability')  &&  recordtypename != 'Liability Mortgage Loan' &&  assLiab.Clearing_From_This_Loan__c && event == 'Insert')
                insertFPLiabilityOtherRecords(assLiab, accountFPCountMap);

            if(recordtypename.Contains('Liability')  &&  recordtypename != 'Liability Mortgage Loan' &&  assLiab.Clearing_From_This_Loan__c && event == 'Update'){
                if(assetLiabMap.get(assLiab.id).size() == 0)
                {
                    insertFPLiabilityOtherRecords(assLiab, accountFPCountMap);
                }
                else
                {
                    for(Funding_Position_Detail__c fpd:assetLiabMap.get(assLiab.id)){
                        if(assLiab.Current_Balance__c != trigger.oldMap.get(assLiab.id).get(CURRENT_BALANCE)){
                            if(fpd.Detail_Type__c == 'Other Debts to Repay'){
                                fpd.Amount__c = assLiab.Current_Balance__c;
                                fpd.Name = assLiab.Name + '-' + assLiab.Current_Balance__c;
                            }
                            fundPosdUpdate.add(fpd);
                        }
                        
                    }
                }
            }

            if(recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && assLiab.To_Be_Purchased__c && event == 'Insert')
                insertFPAssetEstateRecords(assLiab, accountFPCountMap);

             if(recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && assLiab.To_Be_Purchased__c && event == 'Update'){
                if(assetLiabMap.get(assLiab.id).size() < 3)
                {
                    insertFPAssetEstateRecords(assLiab, accountFPCountMap);
                }
                else
                {
                    for(Funding_Position_Detail__c fpd:assetLiabMap.get(assLiab.id)){
                        system.debug('##entered');
                        system.debug('@@assLiab'+oppRecTypeMap.get(assLiab.Opportunity__c).recordtype.name);
                        if((assLiab.State__c!=null && assLiab.State__c != trigger.oldMap.get(assLiab.id).get(STATE)) || (assLiab.Value__c!=null && assLiab.Value__c != trigger.oldMap.get(assLiab.id).get(VALUE)) || (assLiab.Primary_Purpose__c!=null && assLiab.Primary_Purpose__c != trigger.oldMap.get(assLiab.id).get(PRIMARY_PURPOSE)) || (assLiab.Property_Status__c!=null && assLiab.Property_Status__c!= trigger.oldMap.get(assLiab.id).get(PROPERTYTYPE)) || (assLiab.First_Home_Buyer__c!=null && assLiab.First_Home_Buyer__c != trigger.oldMap.get(assLiab.id).get(FIRSTHOMEBUYER))){
                            if(fpd.Detail_Type__c == 'Purchase Stamp Duty'){
                                if(assLiab.Opportunity__c != null && oppRecTypeMap.get(assLiab.Opportunity__c).Recordtype.name ==  'Lendi'){
                                    ClickCommon.getStampDutyRate(OppFPtMap.get(assLiab.Opportunity__c).id,assLiab.State__c,String.valueOf(assLiab.Value__c),assLiab.Primary_Purpose__c,assLiab.Property_Status__c,assLiab.First_Home_Buyer__c); 
                                }
                                else if(assLiab.Account__c != null && accRecTypeMap.get(assLiab.Account__c).recordtype.name !=  'Lendi'){
                                    ClickCommon.getStampDutyRate(accountFPCountMap.get(assLiab.Account__c).id,assLiab.State__c,String.valueOf(assLiab.Value__c),assLiab.Primary_Purpose__c,assLiab.Property_Status__c,assLiab.First_Home_Buyer__c);
                                }
                            }
                            if(fpd.Detail_Type__c == 'Transfer Fee'){
                                fpd.Amount__c = ClickCommon.calculateTransferFee(String.valueOf(assLiab.State__c),Integer.valueOf(assLiab.Value__c));
                                system.debug('###'+fpd.Amount__c);
                            }
                            fundPosdUpdate.add(fpd);
                        }
                        
                    }
                }
             }

             decimal amount= 0;
             if(recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && assLiab.To_Be_Purchased__c == false && event == 'Insert')
                insertAssetEstateSingleRecords(assLiab, accountFPCountMap,amount);
             if(recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && assLiab.To_Be_Purchased__c == false && event == 'Update')
             {
                if(assLiab !=null && assetLiabMap.get(assLiab.id).size() == 0){
                   insertAssetEstateSingleRecords(assLiab, accountFPCountMap,amount); 
                }
                else{
                    boolean createRegistration = true;
                    boolean stateChanged = false;
                    for(Funding_Position_Detail__c fpd:assetLiabMap.get(assLiab.id))
                    {
                        if((assLiab.State__c!=null && assLiab.State__c != trigger.oldMap.get(assLiab.id).get(STATE)))
                        {
                            if(fpd.Detail_Type__c == 'Registration Fee')
                            { 
                                amount =  ClickCommon.getRegistrationFee(assLiab.State__c);
                                fpd.Amount__c = 2*amount;
                                createRegistration = false;
                                fundPosdUpdate.add(fpd);
                            }
                            system.debug('$$$Entered'+amount);
                            stateChanged = true;
                        }
                    }
                    if(createRegistration && stateChanged)
                        insertAssetEstateSingleRecords( assLiab, accountFPCountMap,amount);
                }
             }
         }
         system.debug('###update'+fundPosdUpdate);
         if(fundPosdList.size() > 0)
            insert fundPosdList;
         if(fundPosdUpdate.size()> 0)
            update fundPosdUpdate;
            
         if(fundPosdListToBeDeleted <> null && fundPosdListToBeDeleted.size() > 0){
             delete fundPosdListToBeDeleted ;
         }   
          
        
        
  }

    public void insertFPLiabilityOtherRecords(Asset_And_Liability__c assLiab, Map<Id,Funding_Position__c> accountFPCountMap){
        Funding_Position_Detail__c  fPosdSecond = new Funding_Position_Detail__c ();
        fPosdSecond.Name = assLiab.Name + '-' + assLiab.Current_Balance__c;
        fPosdSecond.Detail_Type__c = 'Other Debts to Repay';
        fPosdSecond.Category__c = 'Debt';
        
        if(assLiab.Account__c !=null && accountFPCountMap.get(assLiab.Account__c) !=null  && mapOfrecordType != null && !mapOfrecordType.isEmpty() 
           && mapOfrecordType.get(assLiab.Account__c) != null  &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi')
        {
            fPosdSecond.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
            fPosdSecond.Asset_And_Liability__c = assLiab.id;
            fPosdSecond.Amount__c = assLiab.Current_Balance__c;
            if(fundPosdList != null)
                fundPosdList.add(fPosdSecond);
        }
        else
        {
            if(assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.isEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null
               &&  Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi'  
               && OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get( assLiab.Opportunity__c) != null )
            {
                fPosdSecond.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
                fPosdSecond.Asset_And_Liability__c = assLiab.id;
                fPosdSecond.Amount__c = assLiab.Current_Balance__c;
                if(fundPosdList != null)
                    fundPosdList.add(fPosdSecond);
            }  
        }
    }

    Public void insertFPAssetEstateRecords(Asset_And_Liability__c assLiab, Map<Id,Funding_Position__c> accountFPCountMap){
        Funding_Position_Detail__c  fPosdThird = new Funding_Position_Detail__c ();
        system.debug('@@@account'+assLiab.Account__c);
        system.debug('###'+accountFPCountMap.get(assLiab.Account__c));
        if(assLiab.Value__c !=null && assLiab.State__c !=null && assLiab.Primary_Purpose__c != null && assLiab.Property_Status__c!= null && assLiab.First_Home_Buyer__c != null && assLiab.Opportunity__c != null && oppRecTypeMap.get(assLiab.Opportunity__c) != null &&  oppRecTypeMap.get(assLiab.Opportunity__c).recordtype.name ==  'Lendi'){
            ClickCommon.getStampDutyRate(OppFPtMap.get(assLiab.Opportunity__c).id,assLiab.State__c,String.valueOf(assLiab.Value__c),assLiab.Primary_Purpose__c,assLiab.Property_Status__c,assLiab.First_Home_Buyer__c); 
        }
        else if(assLiab.Value__c !=null && assLiab.State__c !=null && assLiab.Primary_Purpose__c != null && assLiab.Property_Status__c!= null && assLiab.First_Home_Buyer__c != null && assLiab.Account__c != null && accRecTypeMap.get(assLiab.Account__c) != null && accRecTypeMap.get(assLiab.Account__c).recordtype.name !=  'Lendi'){
            ClickCommon.getStampDutyRate(accountFPCountMap.get(assLiab.Account__c).id,assLiab.State__c,String.valueOf(assLiab.Value__c),assLiab.Primary_Purpose__c,assLiab.Property_Status__c,assLiab.First_Home_Buyer__c);
            
        }
        
        fPosdThird.Category__c = 'Fee';
        fPosdThird.Detail_Type__c = 'Purchase Stamp Duty';
        fPosdThird.Name = assLiab.Name + '- Purchase Stamp Duty';
     
     if(assLiab.Account__c !=null && accountFPCountMap != null && !accountFPCountMap.isEmpty() && accountFPCountMap.get(assLiab.Account__c) !=null
        && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Account__c) != null  
        &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi')
     {
        fPosdThird.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
        fPosdThird.Asset_And_Liability__c = assLiab.id;
        if(fundPosdList != null)
            fundPosdList.add(fPosdThird);
     }
     else
     {
        if( assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null  
            &&  Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi'  
            && OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get( assLiab.Opportunity__c) != null )
            {
                fPosdThird.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
                fPosdThird.Asset_And_Liability__c = assLiab.id;
               // fPosdSecond.Amount__c = assLiab.Current_Balance__c;
                if(fundPosdList != null)
                    fundPosdList.add(fPosdThird);
            }    
     }
        
        Funding_Position_Detail__c  fPosdFourth = new Funding_Position_Detail__c ();
        if(assLiab.Value__c !=null && assLiab.State__c !=null)
            fPosdFourth.Amount__c = ClickCommon.calculateTransferFee(assLiab.State__c,Integer.valueOf(assLiab.Value__c));
        fPosdFourth.Category__c = 'Fee';
        fPosdFourth.Detail_Type__c = 'Transfer Fee';
        fPosdFourth.Name = assLiab.Name + '- Transfer Fee';
        if(assLiab.Account__c !=null && accountFPCountMap != null && !accountFPCountMap.isEmpty() && accountFPCountMap.get(assLiab.Account__c) !=null
         && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Account__c) != null  &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi'){
            fPosdFourth.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
            fPosdFourth.Asset_And_Liability__c = assLiab.id;
            if(fundPosdList != null)
                fundPosdList.add(fPosdFourth);
        }
        else{
            if(assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null
               &&  Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi'
               && OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get( assLiab.Opportunity__c) != null ){
            fPosdFourth.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
            fPosdFourth.Asset_And_Liability__c = assLiab.id;
            //fPosdSecond.Amount__c = assLiab.Current_Balance__c;
            if(fundPosdList != null)
                fundPosdList.add(fPosdFourth);
            }
            
        }
        
        Funding_Position_Detail__c  fPosdFifth = new Funding_Position_Detail__c ();
        fPosdFifth.Amount__c = integer.valueof(System.Label.FUNDING_DETAIL_AMOUNT);
        fPosdFifth.Category__c = 'Fee';
        fPosdFifth.Detail_Type__c = 'Discharge Costs';
        fPosdFifth.Name = assLiab.Name + '- Discharge Costs';
        if(assLiab.Account__c !=null && accountFPCountMap != null && !accountFPCountMap.isEmpty() && accountFPCountMap.get(assLiab.Account__c) !=null
           && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Account__c) != null  
           && Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi' ){
            fPosdFifth.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
            fPosdFifth.Asset_And_Liability__c = assLiab.id;
            if(fundPosdList != null)
                fundPosdList.add(fPosdFifth);
        }
        else{
            if(assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null
                &&  Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi' 
                &&  OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get( assLiab.Opportunity__c) != null ){
            fPosdFifth.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
            fPosdFifth.Asset_And_Liability__c = assLiab.id;
            //fPosdSecond.Amount__c = assLiab.Current_Balance__c;
            if(fundPosdList != null)
                fundPosdList.add(fPosdFifth);
            }
            
        }
        
        Funding_Position_Detail__c  fPosdSeventh = new Funding_Position_Detail__c ();
        if(assLiab.Value__c !=null)
            fPosdSeventh.Amount__c = assLiab.Value__c;
        fPosdSeventh.Category__c = 'Purchase';
        fPosdSeventh.Detail_Type__c = 'Purchase Price';
        fPosdSeventh.Name = assLiab.Name + '- Purchase Price'; 
         if(assLiab.Account__c !=null && accountFPCountMap != null && !accountFPCountMap.isEmpty() && accountFPCountMap.get(assLiab.Account__c) !=null
            && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Account__c) != null  
            &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi'){
            fPosdSeventh.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
            fPosdSeventh.Asset_And_Liability__c = assLiab.id;
            if(fundPosdList != null)
                fundPosdList.add(fPosdSeventh);
        }
        else{
            if( assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null 
                && Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi'  
                && OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get( assLiab.Opportunity__c) != null )
            {
                fPosdSeventh.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
                fPosdSeventh.Asset_And_Liability__c = assLiab.id;
                if(fundPosdList != null)
                    fundPosdList.add(fPosdSeventh);
            }
            
        }
              
        
    }

    Public void insertFPLiabilityRecords( Asset_And_Liability__c assLiab, Map<Id,Funding_Position__c> accountFPCountMap)
    {
        Funding_Position_Detail__c  fPosd = new Funding_Position_Detail__c ();
        Funding_Position_Detail__c  fPosdFirst = new Funding_Position_Detail__c ();
        fPosd.Name = assLiab.Name + '-' + assLiab.Limit__c;
        fPosd.Detail_Type__c = 'Home Loan to Repay';
        fPosd.Category__c = 'Debt';
        if(assLiab.Account__c !=null && accountFPCountMap != null && !accountFPCountMap.isEmpty() && accountFPCountMap.get(assLiab.Account__c) !=null 
           && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Account__c) != null  
           &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi')
        {
            fPosd.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
            fPosd.Asset_And_Liability__c = assLiab.id;
            fPosd.Amount__c = assLiab.Limit__c;
            if(fundPosdList != null)
                fundPosdList.add(fPosd);
        }
        else{
            if(assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null
                &&  Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi'  
                &&  OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get(assLiab.Opportunity__c) != null ){
            fPosd.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
            fPosd.Asset_And_Liability__c = assLiab.id;
             fPosd.Amount__c = assLiab.Limit__c;
            if(fundPosdList != null)
                fundPosdList.add(fPosd);
            }
            
        }
       system.debug('##Entered here');
       if(assLiab.Repayments__c !=null)
       {
           if(assLiab.Repayment_Frequency__c == 'Weekly'  )
             fPosdFirst.Amount__c = assLiab.Repayments__c * 52/12 *0.5 ;
           if(assLiab.Repayment_Frequency__c == 'Monthly')
               fPosdFirst.Amount__c = assLiab.Repayments__c * 1 *0.5 ;
           if(assLiab.Repayment_Frequency__c == 'Anually')
               fPosdFirst.Amount__c = assLiab.Repayments__c * 1/12 * 0.5 ;
           if(assLiab.Repayment_Frequency__c == 'Fortnightly'  )
               fPosdFirst.Amount__c = assLiab.Repayments__c * 26/12* 0.5 ;
       }
       fPosdFirst.Detail_Type__c = 'Potential Accrued Interest'; 
       fPosdFirst.Category__c    = 'Other';
       if( assLiab.Repayments__c != null )
       fPosdFirst.Name = assLiab.Name + '-' + assLiab.Repayments__c;
            else
         fPosdFirst.Name = assLiab.Name + '-' + '';     
        if(assLiab.Account__c !=null && accountFPCountMap != null && !accountFPCountMap.isEmpty() && accountFPCountMap.get(assLiab.Account__c) !=null
           && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Account__c) != null  
           &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi')
       {
           fPosdFirst.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
           fPosdFirst.Asset_And_Liability__c = assLiab.id; 
           if(fundPosdList != null)      
               fundPosdList.add(fPosdFirst);
       }
       else{
            if( assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null
                &&  Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi'  
                &&  OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get( assLiab.Opportunity__c) != null)
            {
                fPosdFirst.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
                fPosdFirst.Asset_And_Liability__c = assLiab.id;
                if(fundPosdList != null)
                    fundPosdList.add(fPosdFirst);
            }   
        }
    }

    Public void insertAssetEstateSingleRecords(Asset_And_Liability__c assLiab, Map<Id,Funding_Position__c> accountFPCountMap,decimal amount){
        Funding_Position_Detail__c  fPosdSixth = new Funding_Position_Detail__c (); 
        if(assLiab.State__c !=null)
            amount =  ClickCommon.getRegistrationFee(assLiab.State__c);
        fPosdSixth.Amount__c = 2*amount;
        fPosdSixth.Category__c = 'Fee';
        fPosdSixth.Detail_Type__c = 'Registration Fee';
        fPosdSixth.Name = assLiab.Name + '- Registration Fee';
        if(assLiab.Account__c !=null && accountFPCountMap != null && !accountFPCountMap.isEmpty() && accountFPCountMap.get(assLiab.Account__c) !=null
           && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Account__c) != null
           &&  Schema.SObjectType.Account.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Account__c)).getname() != 'Lendi')
        {
            fPosdSixth.Funding_Position__c = accountFPCountMap.get(assLiab.Account__c).id;
            fPosdSixth .Asset_And_Liability__c = assLiab.id;
            if(fundPosdList != null)
                fundPosdList.add(fPosdSixth);
        }
        else{
            if( assLiab.Opportunity__c != null && mapOfrecordType != null && !mapOfrecordType.IsEmpty() && mapOfrecordType.get(assLiab.Opportunity__c) != null
                &&  Schema.SObjectType.opportunity.getRecordTypeInfosById().get(mapOfrecordType.get(assLiab.Opportunity__c)).getname() == 'Lendi'  
                &&  OppFPtMap != null && !OppFPtMap.Isempty() && OppFPtMap.get( assLiab.Opportunity__c) != null )
            {
                fPosdSixth.Funding_Position__c = OppFPtMap.get( assLiab.Opportunity__c).id;
                fPosdSixth.Asset_And_Liability__c = assLiab.id;
                if(fundPosdList != null)
                    fundPosdList.add(fPosdSixth);
            }
            
        }
    }
     
    
    
     public void insertFSRecords(list<Asset_And_Liability__c> triggernew)
     {
        list<Financials_Source__c> lstFs = new list<Financials_Source__c>();
        List<click_Applicant__c>  applicantObj = new List<click_Applicant__c>();
        map<Id,Id> matchAccount = new map<Id,Id> ();
        List<Id> IeId = new list<Id>();
        List<Id> lstid = new List<id>();
        Set<Id> lstaccountid = new Set<id>();
        map<Id,Income_And_Expense__c >  mapIe = new map<Id ,Income_And_Expense__c >();
        map<Id,Asset_And_Liability__c >  mapLiability = new map<Id ,Asset_And_Liability__c >();
        List<Income_And_Expense__c>  lstIE = new List<Income_And_Expense__c>();
        list<Income_And_Expense__c> InsertIe = new list<Income_And_Expense__c>();
        
        for(Asset_And_Liability__c objAsset : triggernew)
        {
            IeId.add(objAsset.id);            
            lstid.add(objAsset.createdById);
            if(objAsset.Account__c != null)
                lstaccountid.add(objAsset.Account__c);
        }
        if(lstaccountid != null && !lstaccountid.IsEmpty())
        {
            applicantObj = [Select Name ,click_Account__c,Id ,click_Applicant_Number__c from click_Applicant__c  where click_Account__c  in  : lstaccountid    ORDER BY Name DESC  ] ;
            if(applicantObj != null && !applicantObj.Isempty())
            {
                for(click_Applicant__c app : applicantObj)
                {
                  if(app.click_Account__c  != null )    
                      matchAccount.put(app.click_Account__c,app.Id);
                }
            }
        }
        
        if(!test.isrunningtest())
            Database.executeBatch(new acfCreateRpDataBatch(IeId), 33);
       
        map<String,String> mapUser  =ClickCommon.mapUserInputType(lstid);
        if(IeId != null && !IeId.IsEmpty())
        {
            lstIE = [Select Asset_And_Liability__c ,Opportunity__c ,Applicant__c, Amount__c ,Frequency__c , acfDetails__c  from Income_And_Expense__c where Asset_And_Liability__c in : IeId];
            if(lstIE != null && !lstIE.IsEmpty())
            {
                for(Income_And_Expense__c ie : lstIE)
                {
                    mapIe.put(ie.Asset_And_Liability__c , ie);
                }
            }
        }
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Income_And_Expense__c' and Name='Expense' Limit 1];
        for(Asset_And_Liability__c objAsset : triggernew)
        {
            if(objAsset.acf_create_from_custom_clone_button__c == false && objAsset.recordtypeid != null)
            {   
                mapLiability.put(objAsset.id,objAsset);
                string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(objAsset.recordtypeid).getname();
                System.debug(recordtypename.contains('Liability')+'_________'+recordtypename);
                if(recordtypename.contains('Liability')) 
                {
                    System.debug(recordtypename.contains('Liability')+'_________'+ mapIe.get(objAsset.id));
                    if(objAsset.Clearing_From_This_Loan__c == false &&  mapIe.get(objAsset.id) == null)
                    {
                        System.debug(recordtypename.contains('Liability')+'_________'+recordtypename);
                        Income_And_Expense__c ieObj= new Income_And_Expense__c();
                        if(rt.id != null)
                            ieObj.recordTypeId=rt.id ;
                        ieObj.Asset_And_Liability__c = objAsset.id;
                        //ieObj.Category__c ='Other Expenses';
                        ieObj.acfDetails__c ='Other Loan Expenses';            
                        ieObj.Income_And_Expense_Detail__c = recordtypename;        
                        if(objAsset.Repayment_Frequency__c != null)
                        {
                            if(objAsset.Repayment_Frequency__c == 'Weekly'  && objAsset.Repayments__c != null)
                            {
                                ieObj.Amount__c = objAsset.Repayments__c * 52;
                                ieObj.Frequency__c = 'Yearly' ;
                            }
                            if(objAsset.Repayment_Frequency__c == 'Fortnightly' && objAsset.Repayments__c != null)
                            {
                                ieObj.Amount__c = objAsset.Repayments__c * 26 ;
                                ieObj.Frequency__c = 'Yearly' ;
                            }
                            if(objAsset.Repayment_Frequency__c == 'Monthly' && objAsset.Repayments__c != null)
                            {
                                ieObj.Amount__c = objAsset.Repayments__c *12 ; 
                                ieObj.Frequency__c = 'Yearly' ;
                            }
                            if(objAsset.Repayment_Frequency__c == 'Anually' && objAsset.Repayments__c != null)
                            {
                                 ieObj.Amount__c = objAsset.Repayments__c; 
                                 ieObj.Frequency__c = 'Yearly' ;
                            } 
                        } 
                        if(objAsset.Opportunity__c != null)
                            ieObj.Opportunity__c = objAsset.Opportunity__c;
                        
                        if(objAsset.Account__c != null && matchAccount.get(objAsset.Account__c)!= null )
                            ieObj.Applicant__c = matchAccount.get(objAsset.Account__c);
                        
                        InsertIe.add(ieObj);     
                    }
                    else
                    {
                        if(objAsset.Current_Balance__c != null)
                        {
                            Financials_Source__c tempObj1 = new Financials_Source__c();
                            tempObj1.Amount__c = objAsset.Current_Balance__c;
                            if(mapUser.get(objAsset.CreatedById) != null)
                            tempObj1.Source__c = mapUser.get(objAsset.CreatedById);
                            tempObj1.Asset_And_Liability__c = objAsset.id;
                            lstFs.add(tempObj1);
                        }   
                        if(objAsset.Limit__c != null)
                        {
                            Financials_Source__c tempObj2 = new Financials_Source__c();
                            tempObj2.Amount__c = objAsset.Limit__c;
                            if(mapUser.get(objAsset.CreatedById) != null)
                                tempObj2.Source__c = mapUser.get(objAsset.CreatedById) ;
                            tempObj2.Asset_And_Liability__c = objAsset.id;
                            lstFs.add(tempObj2);
                        }
                    }   
                }
                if(!recordtypename.contains('Liability'))
                {
                    if(objAsset.Value__c != null)
                    {
                        Financials_Source__c tempObj1 = new Financials_Source__c();
                        tempObj1.Amount__c = objAsset.Value__c;
                        if(mapUser.get(objAsset.CreatedById) != null)
                            tempObj1.Source__c = mapUser.get(objAsset.CreatedById);
                        tempObj1.Asset_And_Liability__c = objAsset.id;
                        lstFs.add(tempObj1);
                    }
                }
            }
        }
        if(lstFs.size() > 0)
        {
            try{
                insert lstFs;
            }
            catch(Exception e){
            }
        }
        List<Financials_Source__c>  lstFs1 = new List<Financials_Source__c>();
        if(InsertIe.size() > 0)
        {
            insert InsertIe ;
            Set<Id>  chkAsset = new Set<Id>();
            for(Income_And_Expense__c  ieObj  :InsertIe )
            {
                if(mapLiability.get(ieObj.Asset_And_Liability__c)!= null  && !chkAsset.contains(ieObj.Asset_And_Liability__c) )
                {
                    Asset_And_Liability__c  objAsset = mapLiability.get(ieObj.Asset_And_Liability__c);
                    if(objAsset.Current_Balance__c != null  )
                    {
                        Financials_Source__c tempObj1 = new Financials_Source__c();
                        tempObj1.Amount__c = objAsset.Current_Balance__c;
                        if(mapUser.get(objAsset.CreatedById) != null)
                            tempObj1.Source__c = mapUser.get(objAsset.CreatedById);
                        tempObj1.Asset_And_Liability__c = objAsset.id;
                        lstFs1.add(tempObj1);
                    }
                    if(objAsset.Limit__c != null)
                    {
                        Financials_Source__c tempObj2 = new Financials_Source__c();
                        tempObj2.Amount__c = objAsset.Limit__c;
                        if(mapUser.get(objAsset.CreatedById) != null)
                            tempObj2.Source__c = mapUser.get(objAsset.CreatedById) ;  
                        tempObj2.Asset_And_Liability__c = objAsset.id;
                        lstFs1.add(tempObj2);
                    }
                    chkAsset.add(ieObj.Asset_And_Liability__c);
                }
            
            }
            if(lstFs1.size() > 0)
                insert lstFs1;   
        }
    }
    
    public void UpdateFSRecords()
    {
        list<Financials_Source__c> lstFs = new list<Financials_Source__c>();
        set<id> setOfLiabilityId = new set<id>();
        List<Id> lstId = new list<Id>();
        map<Id , Asset_And_Liability__c>  mapAsset = new map<Id , Asset_And_Liability__c>();
        map<id,String> mapUser = new map<id,String>();
        map<id,String> mapProfile = new map<id,String>();
        
        for (Profile proObj :[SELECT Id,Name,UserType FROM Profile ])
        {
            mapProfile.put(proObj.Id,proObj.Name);
        }
        list<id> userLastModifiedbyId = new list<id>();
        string repaymentFrequencyApi = 'Repayment_Frequency__c';
        string repaymentApi = 'Repayments__c';
        List<Id> IeId = new list<Id>();
        
      
        for(Asset_And_Liability__c objAsset : (List<Asset_And_Liability__c>)trigger.new)
        {
            userLastModifiedbyId.add(objAsset.LastModifiedById );
            lstId.add(objAsset.Id);
            mapAsset.put(objAsset.Id , objAsset);
            if(objAsset.RpdataApicalled__c != true)
                 IeId.add(objAsset.id);     
              Asset_And_Liability__c  ast =   (Asset_And_Liability__c)Trigger.oldmap.get(objAsset.Id)    ;
            if(string.isNotEmpty(objAsset.Street_Number__c) && string.isNotEmpty(objAsset.Street_Name__c ) && string.isNotEmpty(objAsset.Street_Type__c)
               && string.isNotEmpty(objAsset.City__c) && string.isNotEmpty(objAsset.State__c) && objAsset.Postcode__c != null
               && (ast.Street_Number__c  != objAsset.Street_Number__c  || ast.Street_Name__c != objAsset.Street_Name__c  
               || ast.Street_Type__c != objAsset.Street_Type__c ||  ast.City__c != objAsset.City__c || ast.State__c != 
               objAsset.State__c   ||  ast.Postcode__c != objAsset.Postcode__c )) 
            {          
                 IeId.add(objAsset.id); 
            }
            // Condition Added by Ankit
            if(objAsset.recordtypeid != null  )
            {
                string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(objAsset.recordtypeid).getname();
                if(objAsset.Repayment_Frequency__c != null && objAsset.Repayment_Frequency__c <> '' && objAsset.Repayments__c != null
                    && (Trigger.oldmap.get(objAsset.Id).get(repaymentFrequencyApi) != objAsset.Repayment_Frequency__c 
                    || Trigger.oldmap.get(objAsset.Id).get(repaymentApi) != objAsset.Repayments__c ) && recordtypename.contains('Liability'))
                    {
                        setOfLiabilityId.add(objAsset.id);
                    }
            }
        }
        
        try{
        if(IeId.size() > 0  && !test.isrunningtest())
        {
            if(checkRecursive.runOnce())
                Database.executeBatch(new acfCreateRpDataBatch(IeId), 33);
        }
        }
        catch(Exception e){}
        List<User> userObj =[SELECT id, profileid FROM User  where id in : userLastModifiedbyId limit 100];
        for(User u :userObj)
        {
            if(mapProfile.get(u.profileId) != null )
            {
                mapUser.put(U.id, mapProfile.get(u.profileId));
            }
        }

        List<Financials_Source__c>  tempFsObj = new List<Financials_Source__c>();
        List<Financials_Source__c>  fsObj = [Select  id , Asset_And_Liability__c , Source__c , Amount__c  from   Financials_Source__c where Asset_And_Liability__c in : lstId] ;
        if(fsObj != null && fsObj.size() > 0)
        {
            for(Financials_Source__c  obj : fsObj )
            {
                if( mapAsset.get(obj.Asset_And_Liability__c)!= null)
                {
                    Asset_And_Liability__c objAsset = mapAsset.get(obj.Asset_And_Liability__c);
                    string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(objAsset.recordtypeid).getname();
                    if(!recordtypename.contains('Liability'))
                    {
                        if(objAsset.Value__c != null)
                            obj.Amount__c = objAsset.Value__c;
                    }
                    if(recordtypename.contains('Liability'))
                    {
                        if(objAsset.Current_Balance__c != null)
                        {
                            obj.Amount__c = objAsset.Current_Balance__c;
                        }
                        if(objAsset.Limit__c != null)
                        {
                            obj.Amount__c = objAsset.Limit__c;                     
                        }
                    }
                    if(mapUser.get(objAsset.LastModifiedById) != null  && (mapUser.get(objAsset.LastModifiedById).Contains('Community')  || mapUser.get(objAsset.LastModifiedById).Contains('Guest')))
                        tempFsObj.add(obj);
                }
            }
        }  
            if( tempFsObj.size() > 0)
                update tempFsObj;
    }
    
    public void updateIERecords(list<Asset_And_Liability__c> triggernew){
        set<id> incomeAssetSet = new set<id>();
        Map<id,Asset_And_Liability__c> assetIEMap = new Map<id,Asset_And_Liability__c>();
        List<Income_And_Expense__c> ieList = new List<Income_And_Expense__c>();
        
        for(Asset_And_Liability__c objAsset : triggernew)
        {
            
            String REPAYMENT = 'Repayments__c';
            String REPAYMENTFREQUENCY = 'Repayment_Frequency__c';
            if(((objAsset.Repayments__c != trigger.OldMap.get(objAsset.id).get(REPAYMENT)) || (objAsset.Repayment_Frequency__c != trigger.OldMap.get(objAsset.id).get(REPAYMENTFREQUENCY)))){
                incomeAssetSet.add(objAsset.id);  
                assetIEMap.put(objAsset.id,objAsset);
            }
        }
        
        system.debug('@@@123'+assetIEMap);
        system.debug('@@@1234'+incomeAssetSet);
        List<Income_And_Expense__c> ieListNew = new List<Income_And_Expense__c>();
        if(incomeAssetSet !=null && incomeAssetSet.size()>0)
            ieListNew = [Select id,Amount__c,Account__c,Asset_And_Liability__c,Frequency__c from Income_And_Expense__c where Asset_And_Liability__c =:incomeAssetSet];
        if(ieListNew != null && ieListNew.size() > 0){
            for(Income_And_Expense__c ie:ieListNew){
                if(assetIEMap.containsKey(ie.Asset_And_Liability__c) && assetIEMap.get(ie.Asset_And_Liability__c) != null && assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c != null && assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c == 'Weekly')
                {
                    ie.Amount__c = assetIEMap.get(ie.Asset_And_Liability__c).Repayments__c * 52;
                    ie.Frequency__c = 'Yearly' ;
                    ieList.add(ie);
                }
                if(assetIEMap.containsKey(ie.Asset_And_Liability__c) && assetIEMap.get(ie.Asset_And_Liability__c) != null &&  assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c != null && assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c == 'Fortnightly' && assetIEMap.get(ie.Asset_And_Liability__c).Repayments__c!= null)
                {
                    ie.Amount__c = assetIEMap.get(ie.Asset_And_Liability__c).Repayments__c * 26 ;
                    ie.Frequency__c = 'Yearly' ;
                    ieList.add(ie);
                }
                if(assetIEMap.containsKey(ie.Asset_And_Liability__c) && assetIEMap.get(ie.Asset_And_Liability__c) != null &&  assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c != null && assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c == 'Monthly' && assetIEMap.get(ie.Asset_And_Liability__c).Repayments__c != null)
                {
                    ie.Amount__c = assetIEMap.get(ie.Asset_And_Liability__c).Repayments__c *12 ; 
                    ie.Frequency__c = 'Yearly' ;
                    ieList.add(ie);
                }
                if(assetIEMap.containsKey(ie.Asset_And_Liability__c) && assetIEMap.get(ie.Asset_And_Liability__c) != null && assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c != null && assetIEMap.get(ie.Asset_And_Liability__c).Repayment_Frequency__c == 'Anually' && assetIEMap.get(ie.Asset_And_Liability__c).Repayments__c != null)
                {
                     ie.Amount__c = assetIEMap.get(ie.Asset_And_Liability__c).Repayments__c; 
                     ie.Frequency__c = 'Yearly' ;
                     ieList.add(ie);
                }
                system.debug('@@@ie'+ieList);
                if(ieList !=  null && ieList.size() > 0){
                    update ieList;
                }
            } 
        }
        else if(ieListNew != null && ieListNew.size() == 0){
            insertFSRecords(triggernew);
        }
    }
    
    public void calcLoanValueMaxAsset(String event,Set<id> oppLISet){
        Set<id> oppIdSet = new Set<Id>();
        Map<id,OpportunityLineItem> oppProductMap = new Map<id,OpportunityLineItem>();
        Map<id,id> oppBankMap = new Map<id,id>();
        Set<id> productId = new Set<id>();
        Set<String>  postcodeNumberSet = new Set<String>();
        Map<id,Opportunity> oppMap = new Map<id,Opportunity>();
        Map<id,id> prodBankMap = new Map<id,id>();
        Map<id,Double> oppFinalLoanMap = new Map<id,Double>();
        List<Asset_And_Liability__c> assLiabList = new List<Asset_And_Liability__c>();
        List<Asset_And_Liability__c> assLiabDMLList; 
        if(event == 'Insert' || event == 'Update')
            assLiabDMLList = (List<Asset_And_Liability__c>) trigger.new;
        else if(event == 'Delete')
            assLiabDMLList = (List<Asset_And_Liability__c>) trigger.old;
        else if(event == 'LineItemOperation'){
            assLiabDMLList =  new List<Asset_And_Liability__c>();
            oppIdSet = oppLISet;
        }
            
        if(assLiabDMLList != null && assLiabDMLList.size() > 0){
            for(Asset_And_Liability__c assLi: assLiabDMLList){
                if(assLi.Opportunity__c !=null){
                    oppIdset.add(assLi.Opportunity__c); 
                } 
                //postcodeNumberSet.add(String.valueOf(assLiab.Postcode__c));
            }
        }
        
        List<Opportunity> oppList = [Select id,Amount,(Select Id, PricebookEntryId, Product2Id From OpportunityLineItems ORDER BY CreatedDate ASC LIMIT 1) From Opportunity where id=:oppIdset];
        Map<id,PricebookEntry> priceBookMap = new Map<id,PricebookEntry>([Select id,Product2Id FROM PricebookEntry]);
      //  string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(assLiab.recordtypeid).getname();
        assLiabList = [Select Id,Postcode__c,Used_as_Security__c,RecordType.Name,Value__c,Opportunity__c From Asset_And_Liability__c where Used_as_Security__c = true AND Opportunity__c =:oppIdset AND RecordType.Name = 'Asset Real Estate'];
        if(assLiabList !=null && assLiabList.size() > 0){
            for(Asset_And_Liability__c assLiab:assLiabList){
                postcodeNumberSet.add(String.valueOf(assLiab.Postcode__c));
            }
        }
        for(Opportunity opp:oppList){
            OpportunityLineItem oppObject = new OpportunityLineItem();
            
            oppMap.put(opp.id,opp);
            if(opp.OpportunityLineItems !=null && opp.OpportunityLineItems.size() > 0){
                oppObject = opp.OpportunityLineItems;
                productId.add(priceBookMap.get(oppObject.PricebookEntryId).Product2Id);
                oppProductMap.put(opp.id,oppObject);
            }
        }
        List<Product2> productList = [Select id,Click_Loans_Bank_Detail__c From Product2 where id =:productId];
        for(Product2 pro:productList){
            if(pro.Click_Loans_Bank_Detail__c !=null)
                prodBankMap.put(pro.id,pro.Click_Loans_Bank_Detail__c);
        }
        for(Opportunity opp:oppList){
            if(oppProductMap !=null && oppProductMap.containsKey(opp.id) && oppProductMap.get(opp.id).PricebookEntryId !=null){
                //oppProductMap.get(opp.id).PricebookEntryId;
                if(prodBankMap != null && prodBankMap.containsKey(priceBookMap.get(oppProductMap.get(opp.id).PricebookEntryId).Product2Id))
                    oppBankMap.put(opp.id,prodBankMap.get(priceBookMap.get(oppProductMap.get(opp.id).PricebookEntryId).Product2Id));
            }
        }
        
        List<Postcode_Category__c> posCatList = [SELECT Category__c,Click_Loans_Bank_Detail__c,Id,Postcode__r.name FROM Postcode_Category__c where Postcode__r.name =:postcodeNumberSet];
        Map<String,List<Postcode_Category__c>> posCatMap = new Map<String,List<Postcode_Category__c>>();
        Map<String,List<Postcode_Feature__c>> posFeatureMap = new Map<String,List<Postcode_Feature__c>>();
        List<Postcode_Feature__c> posFeatureList = [Select id,Category__c,Bank__c,Loan_Amount_From__c,Loan_Amount_To__c,Max_LVR__c FROM Postcode_Feature__c];  
        for(Postcode_Category__c pos:posCatList){
            if(pos.Postcode__r.name !=null && !posCatMap.containsKey(pos.Postcode__r.name))
                posCatMap.put(String.valueOf(pos.Postcode__r.name),new List<Postcode_Category__c>());
                
            posCatMap.get(pos.Postcode__r.name).add(pos);
        }
        for(Postcode_Feature__c posFeature:posFeatureList){
            if(!posFeatureMap.containsKey(posFeature.category__c))
                posFeatureMap.put(posFeature.category__c,new List<Postcode_Feature__c>());
            posFeatureMap.get(posFeature.category__c).add(posFeature); 
        }
        
        
        Double finalLoanMaxProduct = 0;
        Double proccesLoanMaxProduct = 0;
     
        for(Asset_And_Liability__c assLiab:assLiabList){
            if(posCatMap !=null && posCatMap.containsKey(string.valueOf(assLiab.Postcode__c))){
                string categoryCode = '';
                for(Postcode_Category__c pCat:posCatMap.get(String.valueOf(assLiab.Postcode__c))){
                    if(pCat.Click_Loans_Bank_Detail__c == oppBankMap.get(assLiab.Opportunity__c)){
                        categoryCode = pCat.Category__c;
                    }
                }
                
                if(posFeatureMap.containsKey(categoryCode)){
                    List<Double> proceLoanMaxList = new List<Double>();
                    for(Postcode_Feature__c posFeature:posFeatureMap.get(categoryCode)){
                        system.debug('@@@Entered');
                        //system.debug('@@@Entered123'+posFeature);
                        //system.debug('@@@assLiab'+assLiab);
                        proccesLoanMaxProduct = posFeature.Max_LVR__c/100 * assLiab.value__c;
                        system.debug('@@@oppBank'+oppBankMap.get(assLiab.Opportunity__c));
                        system.debug('@@@posfeaure'+posFeature.id);
                        system.debug('@@@posfeaure'+posFeature.Category__c);
                        system.debug('@@@posfeaure'+posFeature.Bank__c);
                        system.debug('@@@posLoanAmount'+posFeature.Loan_Amount_To__c);
                        system.debug('@@@loanMaxProduct'+proccesLoanMaxProduct);
                        if(oppBankMap.get(assLiab.Opportunity__c) == posFeature.Bank__c && posFeature.Loan_Amount_To__c > proccesLoanMaxProduct){
                             proceLoanMaxList.add(proccesLoanMaxProduct);
                             //finalLoanMaxProduct = finalLoanMaxProduct + proccesLoanMaxProduct;
                             //oppFinalLoanMap.put(assLiab.Opportunity__c,finalLoanMaxProduct); 
                        }
                    }
                    proceLoanMaxList.sort();
                    
                    if(proceLoanMaxList.size() > 0){
                        System.debug('@@@pro'+proceLoanMaxList.get(proceLoanMaxList.size()-1));
                        finalLoanMaxProduct = finalLoanMaxProduct + proceLoanMaxList.get(proceLoanMaxList.size()-1);
                        oppFinalLoanMap.put(assLiab.Opportunity__c,finalLoanMaxProduct);  
                    }
                }
                
            }
        }
        if(oppIdset !=null & oppIdset.size() > 0){
            List<Funding_Position__c> funPosList = [Select id,Loan_Max_Product__c,Opportunity__c FROM Funding_Position__c where Opportunity__c =:oppIdset];
            for(Funding_Position__c fpos:funPosList){
                if(oppFinalLoanMap.containsKey(fpos.Opportunity__c)){
                    fpos.Loan_Max_Asset__c = oppFinalLoanMap.get(fpos.Opportunity__c);
                }
            }
            if(funPosList != null && funPosList.size() > 0){
                update funPosList;
            }
        }
        
        system.debug('@@@opp'+oppLISet);
        if(oppLISet.size() == 0){
            acfTriggerOnOpportunityLineItemHandler lineitem = new acfTriggerOnOpportunityLineItemHandler();
            //lineitem.populateLoanMaxProduct('Asset Operation',oppIdset); 
        }
    }
  
}