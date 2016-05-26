/*
    Handler class for acfTriggerOnAssets trigger
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Prateek Kumar gupta                                            1.0
    =============================================================================
*/ 
public class AssetAndLiabilityTriggerHandler extends TriggerHandler
{
   public override void afterInsert() 
    {
      
       insertFSRecords(trigger.new);
      
       createFundingPosition('Insert');
    }
    public override void afterUpdate() 
    {
        UpdateFSRecords();
        createFundingPosition('Update');
        
    }
     public override void beforeInsert() 
    {
        checkClearingLoan();
        tagOpportunityafterConversion();
        updateStateFromLead();
        //createFundingPosition();
        
    }
    
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
            accIdSet.add(assLiab.Account__c);
            if(!accAsettMap.containsKey(assLiab.Account__c))
                accAsettMap.put(assLiab.Account__c,new List<Asset_And_Liability__c>());
            accAsettMap.get(assLiab.Account__c).add(assLiab);
        }
        
        List<Lead> leadList = [Select id,acf_partner_account__c,acfWhat_is_your_postcode__c from lead where acf_partner_account__c =:accIdSet];
        
        List<State__c> stateList = [SELECT acfState_Short_Name__c,Name FROM State__c];
        for(State__c st:stateList){
            stateMap.put(st.Name,st.acfState_Short_Name__c);
        }
        system.debug('###stateMap'+stateMap);
        system.debug('###leadList'+leadList);
        for(Lead lList:leadList){
            for(State__c st:stateList){
                if(lList.acfWhat_is_your_postcode__c.contains(st.Name)){
                    for(Asset_And_Liability__c aLiab:accAsettMap.get(lList.acf_partner_account__c)){
                        aLiab.State__c = stateMap.get(st.Name);
                    }
                }
            }
        }
    }   
    public void checkClearingLoan(){
         for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
             string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(assLiab.recordtypeid).getname();
             if(recordtypename == 'Liability Mortgage Loan' && assLiab.Name.contains('Liabilities Mortgage Loan')){
                assLiab.Clearing_From_This_Loan__c = true; 
             }
         }
    }
    public void tagOpportunityafterConversion(){
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        Set<Id> accIdSet = new Set<Id>();
        for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            accIdSet.add(assLiab.Account__c);
        }
        List<Lead> leadList = [SELECT id,ConvertedOpportunityId,ConvertedAccountId FROM Lead where ConvertedAccountId = :accIdSet];
        
        for(Lead ld:leadList){
            if(ld.ConvertedAccountId  !=null ){
                leadMap.put(ld.ConvertedAccountId,ld);
            }
        }
        system.debug('##leadMap'+leadMap);
        for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            if(leadMap.containsKey(assLiab.Account__c)){
                assLiab.Opportunity__c = leadMap.get(assLiab.Account__c).ConvertedOpportunityId;
            }
        //    system.debug('leadMap123'+leadMap.get(assLiab.Account__c).ConvertedOpportunityId);
        //    system.debug('##assLiab'+assLiab.Opportunity__c);
        }
        
        
    }
    
   
    public void createFundingPosition(String event){
         Funding_Position__c   fPos = new Funding_Position__c();
         List<Funding_Position__c> fPosExisting; 
         Set<Id> oppId = new Set<Id>();
         String accId;
         for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            accId = assLiab.Account__c;
           
            fPos.Account__c = assLiab.Account__c;
            if(assLiab.Opportunity__c != null){
                fPos.opportunity__c = assLiab.opportunity__c;
                oppId.add(assLiab.opportunity__c);
             }
         }
         
         fPosExisting = [Select id from Funding_Position__c where Account__c =:accId];
         if(fPosExisting.size() == 0){
             if(oppId.size() > 0){
                 List<OpportunityLineItem> oppLineList = [SELECT acfLegal_Fees__c,clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c FROM OpportunityLineItem where OpportunityId =:oppId ORDER BY CreatedDate ASC LIMIT 1];
                 if(oppLineList.size() > 0){
                     system.debug('##oppLi'+oppLineList);
                     if(oppLineList[0].acfLegal_Fees__c !=null && oppLineList[0].clickEstablishment_Fee__c!=null && oppLineList[0].clickMortgage_Risk_Fee__c!=null){
                         fPos.Lender_Set_Up_Fees__c = Integer.valueOf(oppLineList[0].acfLegal_Fees__c) + Integer.valueOf(oppLineList[0].clickEstablishment_Fee__c) + Integer.valueOf(oppLineList[0].clickMortgage_Risk_Fee__c);
                     }
                 }
             }
             if(fPos !=null)
                 insert fPos;
         }
         system.debug('##fpos'+fPos);  
         string CLEARING_FROM_LOAN = 'Clearing_From_This_Loan__c';
         string USED_AS_SECURITY = 'Used_as_Security__c';
         string TO_BE_PURCHASED = 'To_Be_Purchased__c';
         List<Funding_Position_Detail__c> fundPosdList = new List<Funding_Position_Detail__c>();
         for(Asset_And_Liability__c assLiab:((List<Asset_And_Liability__c>) trigger.new)){
            system.debug('##rec'+assLiab.RecordTypeId);
            string recTypeId = ClickCommon.GetRecordTypeId('Asset_And_Liability__c','Liability Mortgage Loan');
            system.debug('##rec1'+recTypeId);

            if((assLiab.RecordtypeId == recTypeId && assLiab.Clearing_From_This_Loan__c && event == 'Update' && assLiab.Clearing_From_This_Loan__c != trigger.oldMap.get(assLiab.id).get(CLEARING_FROM_LOAN)) 
                || (assLiab.RecordtypeId == recTypeId && assLiab.Clearing_From_This_Loan__c && event == 'Insert')){
                Funding_Position_Detail__c  fPosd = new Funding_Position_Detail__c ();
                Funding_Position_Detail__c  fPosdFirst = new Funding_Position_Detail__c ();
                
                fPosd.Name = assLiab.Name + '-' + assLiab.Limit__c;
                fPosd.Detail_Type__c = 'Home Loan to Repay';
               
                fPosd.Category__c = 'Debt';
                if(fPosExisting.size() > 0)
                    fPosd.Funding_Position__c = fPosExisting[0].id;
                else
                    fPosd.Funding_Position__c = fPos.id;
                fPosd.Asset_And_Liability__c = assLiab.id;
                fPosd.Amount__c = assLiab.Limit__c;

               system.debug('##Entered here');
               if(assLiab.Repayments__c !=null){
                   if(assLiab.Repayment_Frequency__c == 'Weekly'  ){
                     fPosdFirst.Amount__c = assLiab.Repayments__c * 52/12 ;
                        
                   }
                    if(assLiab.Repayment_Frequency__c == 'Monthly'  ){
                     fPosdFirst.Amount__c = assLiab.Repayments__c * 1 ;
                        
                   }
                    if(assLiab.Repayment_Frequency__c == 'Anually'  ){
                     fPosdFirst.Amount__c = assLiab.Repayments__c * 1/12 ;
                        
                   }
                    if(assLiab.Repayment_Frequency__c == 'Fortnightly'  ){
                     fPosdFirst.Amount__c = assLiab.Repayments__c * 26/12 ;
                        
                   }
               }
               fPosdFirst.Detail_Type__c = 'Potential Accrued Interest'; 
               fPosdFirst.Category__c    = 'Other';
               fPosdFirst.Name = assLiab.Name + '-' + assLiab.Limit__C;
               if(fPosExisting.size() > 0)
                    fPosdFirst.Funding_Position__c = fPosExisting[0].id;
               else
                    fPosdFirst.Funding_Position__c = fPos.id;
               fPosdFirst.Asset_And_Liability__c = assLiab.id;
               
               fundPosdList.add(fPosd);
               fundPosdList.add(fPosdFirst);
        }
                       
        string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(assLiab.recordtypeid).getname();
        system.debug('###recType'+recordtypename);
        if((recordtypename.Contains('Liability')  &&  recordtypename != 'Liability Mortgage Loan' &&  assLiab.Clearing_From_This_Loan__c && event == 'Insert') ||
            (recordtypename.Contains('Liability')  &&  recordtypename != 'Liability Mortgage Loan' &&  assLiab.Clearing_From_This_Loan__c && event == 'Update' && assLiab.Clearing_From_This_Loan__c != trigger.oldMap.get(assLiab.id).get(CLEARING_FROM_LOAN))){
            Funding_Position_Detail__c  fPosdSecond = new Funding_Position_Detail__c ();
            fPosdSecond.Name = assLiab.Name + '-' + assLiab.Current_Balance__c;
            fPosdSecond .Detail_Type__c = 'Other Debts to Repay';
            fPosdSecond .Category__c = 'Debt';
            if(fPosExisting.size() > 0)
                fPosdSecond.Funding_Position__c = fPosExisting[0].id;
            else
                fPosdSecond.Funding_Position__c = fPos.id;
            fPosdSecond.Asset_And_Liability__c = assLiab.id;
            fPosdSecond.Amount__c = assLiab.Current_Balance__c;
            fundPosdList.add(fPosdSecond);
        }
       
        if((recordtypename.Contains('Asset')  &&  recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && assLiab.To_Be_Purchased__c && event =='Insert') ||
            (recordtypename.Contains('Asset')  &&  recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && assLiab.To_Be_Purchased__c && event =='Update'
             && assLiab.Used_as_Security__c != trigger.oldMap.get(assLiab.id).get(USED_AS_SECURITY) && assLiab.To_Be_Purchased__c != trigger.oldMap.get(assLiab.id).get(TO_BE_PURCHASED))){
            
            Funding_Position_Detail__c  fPosdThird = new Funding_Position_Detail__c ();
            fPosdThird.Amount__c = ClickCommon.getStampDutyRate(assLiab.State__c,Integer.valueOf(assLiab.Value__c),assLiab.Primary_Purpose__c);
            fPosdThird.Category__c = 'Fee';
            fPosdThird.Detail_Type__c = 'Purchase Stamp Duty';
            fPosdThird.Name = assLiab.Name + '- Purchase Stamp Duty';
            if(fPosExisting.size() > 0)
                fPosdThird.Funding_Position__c = fPosExisting[0].id;
            else
                fPosdThird.Funding_Position__c = fPos.id;
            fPosdThird.Asset_And_Liability__c = assLiab.id;
            
            Funding_Position_Detail__c  fPosdFourth = new Funding_Position_Detail__c ();
            fPosdFourth.Amount__c = ClickCommon.calculateTransferFee(assLiab.State__c,Integer.valueOf(assLiab.Value__c));
            fPosdFourth.Category__c = 'Fee';
            fPosdFourth.Detail_Type__c = 'Transfer Fee';
            fPosdFourth.Name = assLiab.Name + '- Transfer Fee';
            if(fPosExisting.size() > 0)
                fPosdFourth.Funding_Position__c = fPosExisting[0].id;
            else
                fPosdFourth.Funding_Position__c = fPos.id;
            fPosdFourth.Asset_And_Liability__c = assLiab.id;
            
            Funding_Position_Detail__c  fPosdFifth = new Funding_Position_Detail__c ();
            fPosdFifth.Amount__c = integer.valueof(System.Label.FUNDING_DETAIL_AMOUNT);
            fPosdFifth.Category__c = 'Fee';
            fPosdFifth.Detail_Type__c = 'Discharge Costs';
            fPosdFifth.Name = assLiab.Name + '- Discharge Costs';
            if(fPosExisting.size() > 0)
                fPosdFifth.Funding_Position__c = fPosExisting[0].id;
            else
                fPosdFifth.Funding_Position__c = fPos.id;
            fPosdFifth.Asset_And_Liability__c = assLiab.id;
            fundPosdList.add(fPosdThird);
            fundPosdList.add(fPosdFourth);
            fundPosdList.add(fPosdFifth); 
            
        }
        
        if((recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && Event == 'Insert') ||
            (recordtypename == 'Asset Real Estate' &&  assLiab.Used_as_Security__c == true && Event == 'Update' && assLiab.Used_as_Security__c != trigger.oldMap.get(assLiab.id).get(USED_AS_SECURITY))){
            Funding_Position_Detail__c  fPosdSixth = new Funding_Position_Detail__c ();
            decimal amount =  ClickCommon.getRegistrationFee(assLiab.State__c);
            fPosdSixth.Amount__c = 2*amount;
            fPosdSixth.Category__c = 'Fee';
            fPosdSixth.Detail_Type__c = 'Registration Fee';
            fPosdSixth.Name = assLiab.Name + '- Registration Fee';
            if(fPosExisting.size() > 0)
                fPosdSixth .Funding_Position__c = fPosExisting[0].id;
            else
                fPosdSixth .Funding_Position__c = fPos.id;
            fPosdSixth .Asset_And_Liability__c = assLiab.id;
            fundPosdList.add(fPosdSixth);
        }
                
                    
    }
        
        if(fundPosdList.size() > 0)
            insert fundPosdList;
  }
     
    
    
     public void insertFSRecords(list<Asset_And_Liability__c> triggernew)
    {
        
        list<Financials_Source__c> lstFs = new list<Financials_Source__c>();
        
        set<Id> IeId = new Set<Id>();
      
        map<String,String> mapUser  =ClickCommon.mapUserInputType();
        for(Asset_And_Liability__c objAsset : triggernew)
        {
            IeId.add(objAsset.id);
            CreateRpdata(objAsset.id);
        }
        List<Income_And_Expense__c>  lstIE = 
        [Select Asset_And_Liability__c , Amount__c ,Frequency__c , acfDetails__c  from Income_And_Expense__c where Asset_And_Liability__c in : IeId];
        
        map<Id ,Income_And_Expense__c >  mapIe = new map<Id ,Income_And_Expense__c >();
        map<Id ,Asset_And_Liability__c >  mapLiability = new map<Id ,Asset_And_Liability__c >();
        
        for(Income_And_Expense__c ie : lstIE){
            
            mapIe.put(ie.Asset_And_Liability__c , ie);
        }
        list<Income_And_Expense__c> InsertIe = new list<Income_And_Expense__c>();
        RecordType rt = [select id,Name from RecordType where SobjectType='Income_And_Expense__c' and Name='Expense' Limit 1];
        for(Asset_And_Liability__c objAsset : triggernew)
        {
            mapLiability.put(objAsset.id,objAsset);
        string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(objAsset.recordtypeid).getname();
        System.debug(recordtypename.contains('Liability')+'_________'+recordtypename);
            if(recordtypename.contains('Liability')    ) 
            {
                    System.debug(recordtypename.contains('Liability')+'_________'+ mapIe.get(objAsset.id));
                   if(objAsset.Clearing_From_This_Loan__c == false &&  mapIe.get(objAsset.id) == null   ){
                            System.debug(recordtypename.contains('Liability')+'_________'+recordtypename);
                         Income_And_Expense__c ieObj= new Income_And_Expense__c();
                        if(rt.id != null)
                            ieObj.recordTypeId=rt.id ;
                        ieObj.Asset_And_Liability__c = objAsset.id;
                        ieObj.Category__c ='Other Expenses';
                                ieObj.acfDetails__c ='Other Loan Expenses';
                       if(objAsset.Repayment_Frequency__c != null){
                           if(objAsset.Repayment_Frequency__c == 'Weekly'  && objAsset.Repayments__c != null){
                                ieObj.Amount__c = objAsset.Repayments__c * 52;
                                ieObj.Frequency__c = 'Weekly' ;
                                
                                 
                                
                           }
                           if(objAsset.Repayment_Frequency__c == 'Fortnightly' && objAsset.Repayments__c != null){
                                ieObj.Amount__c = objAsset.Repayments__c * 26 ;
                                ieObj.Frequency__c = 'Fortnightly' ;
                           }
                           if(objAsset.Repayment_Frequency__c == 'Monthly' && objAsset.Repayments__c != null){
                               ieObj.Amount__c = objAsset.Repayments__c *12 ; 
                               ieObj.Frequency__c = 'Monthly' ;
                           }
                           if(objAsset.Repayment_Frequency__c == 'Anually' && objAsset.Repayments__c != null){
                                ieObj.Amount__c = objAsset.Repayments__c; 
                                ieObj.Frequency__c = 'Yearly' ;
                           }
                         
                        System.debug(recordtypename.contains('Liability')+'_________'+recordtypename);
                           
                          } 
                           InsertIe.add(ieObj); 
                            
                       
                   }
                    else{
                        System.debug('__else_');
                        if(objAsset.Current_Balance__c != null){
                              
                                Financials_Source__c tempObj1 = new Financials_Source__c();
                                //tempObj1.Income_And_Expense__c = 
                                tempObj1.Amount__c = objAsset.Current_Balance__c;
                                if(mapUser.get(objAsset.CreatedById) != null)
                                tempObj1.Source__c = mapUser.get(objAsset.CreatedById);
                                tempObj1.Asset_And_Liability__c = objAsset.id;
                                lstFs.add(tempObj1);
                           }
                            
                            if(objAsset.Limit__c != null){
                               Financials_Source__c tempObj2 = new Financials_Source__c();
                               tempObj2.Amount__c = objAsset.Limit__c;
                                if(mapUser.get(objAsset.CreatedById) != null){
                                  
                                    tempObj2.Source__c = mapUser.get(objAsset.CreatedById) ;
                                   
                                }
                                tempObj2.Asset_And_Liability__c = objAsset.id;
                                lstFs.add(tempObj2);
                           }
                    }
              
               
               
            }
            if(!recordtypename.contains('Liability'))
            {
              
               if(objAsset.Value__c != null){
                    Financials_Source__c tempObj1 = new Financials_Source__c();
                    tempObj1.Amount__c = objAsset.Value__c;
                    if(mapUser.get(objAsset.CreatedById) != null){
                       
                            tempObj1.Source__c = mapUser.get(objAsset.CreatedById);
                        }
                    
                    tempObj1.Asset_And_Liability__c = objAsset.id;
                    lstFs.add(tempObj1);
                 }
            }
        }
        if(lstFs.size() > 0){
            try{
                insert lstFs;
            }
            catch(Exception e){
            }
        }
        List<Financials_Source__c>  lstFs1 = new List<Financials_Source__c>();
        if(InsertIe.size() > 0){
        insert InsertIe ;
        Set<Id>  chkAsset = new Set<Id>();
        for(Income_And_Expense__c  ieObj  :InsertIe ){
            if(mapLiability.get(ieObj.Asset_And_Liability__c)!= null  && !chkAsset.contains(ieObj.Asset_And_Liability__c) ) {
                
                Asset_And_Liability__c  objAsset = mapLiability.get(ieObj.Asset_And_Liability__c);
                
                if(objAsset.Current_Balance__c != null  ){
                              
                                Financials_Source__c tempObj1 = new Financials_Source__c();
                              //tempObj1.Income_And_Expense__c = ieObj.id;
                                tempObj1.Amount__c = objAsset.Current_Balance__c;
                                if(mapUser.get(objAsset.CreatedById) != null)
                                tempObj1.Source__c = mapUser.get(objAsset.CreatedById);
                                tempObj1.Asset_And_Liability__c = objAsset.id;
                                lstFs1.add(tempObj1);
                           }
                            
                            if(objAsset.Limit__c != null){
                               Financials_Source__c tempObj2 = new Financials_Source__c();
                               tempObj2.Amount__c = objAsset.Limit__c;
                             //tempObj2.Income_And_Expense__c = ieObj.id;
                                if(mapUser.get(objAsset.CreatedById) != null){
                                  
                                tempObj2.Source__c = mapUser.get(objAsset.CreatedById) ;
                                   
                                }
                                tempObj2.Asset_And_Liability__c = objAsset.id;
                                lstFs1.add(tempObj2);
                           }
                chkAsset.add(ieObj.Asset_And_Liability__c);
            }
            
        }
         if(lstFs1.size() > 0){
             insert lstFs1;
             
         }
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
        for(Asset_And_Liability__c objAsset : (List<Asset_And_Liability__c>)trigger.new)
        {
            userLastModifiedbyId.add(objAsset.LastModifiedById );
            lstId.add(objAsset.Id);
            mapAsset.put(objAsset.Id , objAsset);
            // Condition Added by Ankit
            string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(objAsset.recordtypeid).getname();
            if(objAsset.Repayment_Frequency__c != null && objAsset.Repayment_Frequency__c <> '' && objAsset.Repayments__c != null
                && (Trigger.oldmap.get(objAsset.Id).get(repaymentFrequencyApi) != objAsset.Repayment_Frequency__c 
                || Trigger.oldmap.get(objAsset.Id).get(repaymentApi) != objAsset.Repayments__c ) && recordtypename.contains('Liability'))
                {
                    setOfLiabilityId.add(objAsset.id);
                }
        }
        
        List<User> userObj =[SELECT id, profileid FROM User  where id in : userLastModifiedbyId];
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
        /*
            =============================================================================
            Name                             Date                                version
            =============================================================================
            Ankit Singh                   17/05/2016                                1.0
            =============================================================================
            update Financial Source when Repayment and Repayment Frequency changes.
            =============================================================================
        */ 
        
            List<Income_And_Expense__c>  lstIncomeAndExp = [Select Asset_And_Liability__c ,Asset_And_Liability__r.Repayment_Frequency__c,
                                                                Amount__c ,Frequency__c , acfDetails__c,Asset_And_Liability__r.Repayments__c,
                                                                (select id,Amount__c from Financials_Sources__r)
                                                                from Income_And_Expense__c where Asset_And_Liability__c in : setOfLiabilityId];
            List<Income_And_Expense__c> lstupdatedIncomeAndExp = new List<Income_And_Expense__c>();
            if(lstId != null && lstId.size() > 0)
            {
                
                if(lstIncomeAndExp != null && lstIncomeAndExp.size() > 0)
                {
                    for(Income_And_Expense__c objIncomeAndExp : lstIncomeAndExp)
                    {
                        
                    /*  if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Weekly'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                        {
                            objIncomeAndExp.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c * 52;
                            objIncomeAndExp.Frequency__c = 'Weekly' ;
                        }
                        if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Monthly'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                        {
                            objIncomeAndExp.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c * 12;
                            objIncomeAndExp.Frequency__c = 'Monthly' ;
                        }
                        if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Anually'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                        {
                            objIncomeAndExp.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c;
                            objIncomeAndExp.Frequency__c = 'Anually' ;
                        }
                        if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Fortnightly'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                        {
                            objIncomeAndExp.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c * 26;
                            objIncomeAndExp.Frequency__c = 'Fortnightly' ;
                        }
                        lstupdatedIncomeAndExp.add(objIncomeAndExp);     */
                        if(objIncomeAndExp.Financials_Sources__r != null && objIncomeAndExp.Financials_Sources__r.size() > 0)
                        {
                            for(Financials_Source__c objFinancialSource : objIncomeAndExp.Financials_Sources__r)
                            {
                                if( mapAsset.get(objIncomeAndExp.Asset_And_Liability__c)!= null)
                                {
                                    Asset_And_Liability__c objAsset = mapAsset.get(objIncomeAndExp.Asset_And_Liability__c);
                                    if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Weekly'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                                    {
                                        objFinancialSource.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c * 52;
                                    }
                                    if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Monthly'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                                    {
                                        objFinancialSource.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c * 12;
                                    }
                                    if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Anually'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                                    {
                                        objFinancialSource.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c;
                                    }
                                    if(objIncomeAndExp.Asset_And_Liability__r.Repayment_Frequency__c == 'Fortnightly'  && objIncomeAndExp.Asset_And_Liability__r.Repayments__c != null)
                                    {
                                        objFinancialSource.Amount__c = objIncomeAndExp.Asset_And_Liability__r.Repayments__c * 26;
                                    }
                                    if(mapUser.get(objAsset.LastModifiedById) != null  && (mapUser.get(objAsset.LastModifiedById).Contains('Community')  || mapUser.get(objAsset.LastModifiedById).Contains('Guest')))
                                        tempFsObj.add(objFinancialSource) ;
                                }
                            }
                        }
                    }
                }   
            }   
        /*  if(lstupdatedIncomeAndExp != null && lstupdatedIncomeAndExp.size() > 0)
            {
                update lstupdatedIncomeAndExp;
            }    */     
            if( tempFsObj.size() > 0)
                update tempFsObj;
    }
    @future (callout=true)
      public static void CreateRpdata( ID id) {
         
            
        List<Asset_And_Liability__c> lstobj = [SELECT recordtypeid, Address__c, Current_Balance__c ,Frequency__c,Limit__c,Name,Opportunity__c,Repayments__c,Repayment_Frequency__c,State__c,
        Street_Name__c,Street_Number__c,Street_Type__c,Type__c,Value__c FROM Asset_And_Liability__c where id = : id];
     //   System.debug('___________'+Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(lstobj[0].recordtypeid).getname());
                
         String Propertid ;
            if(lstobj != null && lstobj.size()>0 && lstobj[0].Address__c != null 
            && Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(lstobj[0].recordtypeid).getname() =='Asset Real Estate' ){
            CoreLogicServices obj1 = new CoreLogicServices();
            HttpResponse res = obj1.SearchProperty(lstobj[0].Address__c );
           if(res.getStatusCode() == 200 ){
               JSONParser parser = JSON.createParser(res.getBody());
            
               while (parser.nextToken() != null) {

                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                                (parser.getText() == 'propertyId')) {

                                // Get the value.

                                parser.nextToken();
                                // Compute the grand total price for all invoices.
                                Propertid = parser.gettext();

                            }
                        }

            if(Propertid == null){
             Avm_Property__c avmObj = new   Avm_Property__c();
               avmObj.Status__c = 'Unable to get propertyid from CoreLogicServices.';
               avmObj.Asset_And_Liability__c = id;
               insert avmObj ; 
            }
           }
           else{
               Avm_Property__c avmObj = new   Avm_Property__c();
               avmObj.Status__c = res.getStatusCode()+ '----'+ res.getbody()  ;
               avmObj.Asset_And_Liability__c = id;
               insert avmObj ; 
            }
       
            
             if(Propertid != null){
             
             String  propertyval = obj1.avmJson(Propertid,'0','0','0','MUCH_BETTER','0','0','BUSINESS','','0','','0');
            
        if(propertyval != null )
                    {   
                    List<Avm_Property__c> avmObj = [Select  Asset_And_Liability__c,Status__c,id ,Fares_FSD_Score__c, propertyId__c ,Fares_Score__c ,Fares_ValuationDate__c ,Expiry_date__c,Fares_Value_High__c ,Fares_Value_Low__c,Fares_Value_Estimate__c
                    from Avm_Property__c where propertyId__c = : Integer.valueof(Propertid)] ;
                    if(avmObj.size() > 0 ){
                    DateTime dt = system.now();
                    if(avmObj[0].Expiry_date__c  < dt){
                            System.debug(avmObj[0].Expiry_date__c);
                            HttpResponse avmres = obj1.getPropertyAVM(propertyval ) ;
                            JSONParser parser = JSON.createParser(avmres.getbody());
                            Avm av = (Avm)parser.readValueAs(Avm.class);

                            avmFaresDetail temp = av.avmFaresDetail ;
                            if(temp != null){
                            Avm_Property__c aobj = new Avm_Property__c();
                            aobj.propertyId__c= Integer.valueof(Propertid);
                            aobj.Fares_FSD_Score__c = temp.faresFSDScore ;
                            aobj.Fares_Value_Estimate__c = temp.faresScore ;
                            aobj.Fares_ValuationDate__c = temp.faresValuationDate ;
                            aobj.Fares_Value_Estimate__c = temp.faresValueEstimate ;
                            aobj.Fares_Value_High__c = temp.faresValueHigh ;
                            aobj.Fares_Value_Low__c = temp.faresValueLow ;
                            aobj.id = avmObj[0].id;
                            aobj.Asset_And_Liability__c = id;
                            upsert  aobj;
                             
                            Financials_Source__c tempObj1 = [Select id, Asset_And_Liability__c , Amount__c  from Financials_Source__c  where  Asset_And_Liability__c  = : id ];
                                    if(tempObj1 != null){
                                    tempObj1.Amount__c = Decimal.valueof( temp.faresValueEstimate);
                                    tempObj1.Source__c = 'RPData';
                                    tempObj1.Asset_And_Liability__c = id;
                                    update tempObj1;
                                    }
                                    else{
                                        
                                        Financials_Source__c tempObj2 = new Financials_Source__c();
                                if(Decimal.valueof(temp.faresValueEstimate) != null)
                                tempObj2.Amount__c = Decimal.valueof(temp.faresValueEstimate);

                                tempObj2.Source__c = 'RPData';
                                tempObj2.Asset_And_Liability__c = id;
                                insert tempObj2 ;
                                    }
                            }
                            else{
                                 
                                Financials_Source__c tempObj1 = new Financials_Source__c();
                                if(temp.faresValueEstimate != null)
                                tempObj1.Amount__c = Decimal.valueof(temp.faresValueEstimate);

                                tempObj1.Source__c = 'RPData';
                                tempObj1.Asset_And_Liability__c = id;
                                insert tempObj1 ;
                                
                            }

                    }else{
                                                
                                Financials_Source__c tempObj1 = new Financials_Source__c();
                                 
                                 if(avmObj[0].Fares_Value_Estimate__c != null)
                                tempObj1.Amount__c = Decimal.valueof(avmObj[0].Fares_Value_Estimate__c);
                                
                                 
                                 tempObj1.Source__c = 'RPData';
                                 tempObj1.Asset_And_Liability__c = id;
                                 insert tempObj1;
                        
                    
                        }

                    }
                    else{
                
                                HttpResponse avmres = obj1.getPropertyAVM(propertyval ) ;
                                JSONParser parser = JSON.createParser(avmres.getbody() );
                                Avm av = (Avm)parser.readValueAs(Avm.class);
                                avmFaresDetail temp = av.avmFaresDetail ;
                                if(temp != null){
                                Avm_Property__c aobj = new Avm_Property__c();
                                aobj.propertyId__c= Integer.valueof( Propertid);
                                aobj.Fares_FSD_Score__c = temp.faresFSDScore ;
                                aobj.Fares_Value_Estimate__c = temp.faresScore ;
                                aobj.Fares_ValuationDate__c = temp.faresValuationDate ;
                                aobj.Fares_Value_Estimate__c = temp.faresValueEstimate ;
                                aobj.Fares_Value_High__c = temp.faresValueHigh ;
                                aobj.Fares_Value_Low__c = temp.faresValueLow ;
                                aobj.Fares_Value_Low__c = temp.faresValueLow ;
                                aobj.Asset_And_Liability__c = id;
                                insert aobj;
                                Financials_Source__c tempObj1 = new Financials_Source__c();

                                tempObj1.Amount__c = Decimal.valueof(temp.faresValueEstimate);

                                tempObj1.Source__c = 'RPData';
                                tempObj1.Asset_And_Liability__c = id;
                                insert tempObj1 ;
                                }
                                else{
                                Avm_Property__c aobj = new Avm_Property__c();
                                aobj.propertyId__c= Integer.valueof( Propertid);


                                aobj.Asset_And_Liability__c = id;
                                aobj.Status__c = 'Unable to get Avm Details from core logic. ';

                                insert aobj;
                                }
                        }    
                    }
            }
        }
      }
      
    
    public class Avm{
    public avmFaresDetail avmFaresDetail {get ;set ;}
   }
    public avmFaresDetail  temp {get ;set;}
    public class avmFaresDetail {
   
    public string faresFSDScore {get ;set;}
    public string  faresReferenceID {get ;set;}
    public string  faresScore {get ;set;}
    public string  faresValuationDate {get ;set;}
    public string  faresValueEstimate {get ;set;}
    public string  faresValueHigh {get ;set;}
    public string  faresValueLow {get ;set;}
   
   }
  
    
    
}