/*
    Handler class for acfTriggerOnAssets trigger
    =============================================================================
    Name                             Date                                version
    =============================================================================
    prateek gupta              21/04/2016                               1.0
    =============================================================================
*/ 
public class AssetAndLiabilityTriggerHandler extends TriggerHandler
{
   public override void afterInsert() 
    {
      
       insertFSRecords(trigger.new);
       insertFPRecords(trigger.new);
    }
    public override void afterUpdate() 
    {
       
       
        UpdateFSRecords(trigger.new);
        
    }
    public override void afterDelete()
    {
       
    }
    
   
    
     public void insertFPRecords(list<Asset_And_Liability__c> triggernew){
         Funding_Position__c fPos = new Funding_Position__c();
         Set<Id> oppId = new Set<Id>();
         for(Asset_And_Liability__c assLiab:triggernew){
             fPos.Account__c = assLiab.Account__c;
             if(assLiab.Opportunity__c != null){
                 fPos.opportunity__c = assLiab.opportunity__c;
                 oppId.add(assLiab.opportunity__c);
             }
         }
         
         if(oppId.size() > 0){
             List<OpportunityLineItem> oppLineList = [SELECT acfLegal_Fees__c,clickEstablishment_Fee__c,clickMortgage_Risk_Fee__c FROM OpportunityLineItem where OpportunityId =:oppId ORDER BY CreatedDate ASC LIMIT 1];
             fPos.Lender_Set_Up_Fees__c = Integer.valueOf(oppLineList[0].acfLegal_Fees__c) + Integer.valueOf(oppLineList[0].clickEstablishment_Fee__c) + Integer.valueOf(oppLineList[0].clickMortgage_Risk_Fee__c);
         }
         if(fPos !=null)
             insert fPos;
     } 
    
     public void insertFSRecords(list<Asset_And_Liability__c> triggernew)
    {
        
        list<Financials_Source__c> lstFs = new list<Financials_Source__c>();
        
        
        
        
        list<id> tempUserId = new list<id>();
        for(Asset_And_Liability__c objAsset : triggernew)
        {
        tempUserId.add(objAsset.CreatedById);
        }
        map<String,String> mapUser  =ClickCommon.mapUserInputType(tempUserId);
        for(Asset_And_Liability__c objAsset : triggernew)
        {
        string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(objAsset.recordtypeid).getname();
            if(recordtypename.contains('Liability')    )
            {
              
               if(objAsset.Current_Balance__c != null){
                    Financials_Source__c tempObj1 = new Financials_Source__c();
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
                upsert lstFs;
            }
            catch(Exception e){
            }
        }
    }
    
    public void UpdateFSRecords(list<Asset_And_Liability__c> triggernew)
    {
        
        list<Financials_Source__c> lstFs = new list<Financials_Source__c>();
       
          List<Id> lstId = new list<Id>();
          map<Id , Asset_And_Liability__c>  mapAsset = new map<Id , Asset_And_Liability__c>();
          
          map<id,String> mapUser = new map<id,String>();
            map<id,String> mapProfile = new map<id,String>();
        
        for (Profile proObj :[SELECT Id,Name,UserType FROM Profile ]){
             mapProfile.put(proObj.Id,proObj.Name);
        }
        list<id> userLastModifiedbyId = new list<id>();
        
        for(Asset_And_Liability__c objAsset : triggernew)
        {
            userLastModifiedbyId.add(objAsset.LastModifiedById );
            lstId.add(objAsset.Id);
            mapAsset.put(objAsset.Id , objAsset);
                 
            
        }
        
        List<User> userObj =[SELECT id, profileid FROM User  where id in : userLastModifiedbyId];
        for(User u :userObj){
            if(mapProfile.get(u.profileId) != null ){
                mapUser.put(U.id, mapProfile.get(u.profileId));
            }
        }
        List<Financials_Source__c>  tempFsObj = new List<Financials_Source__c>();
        List<Financials_Source__c>  fsObj = [Select  id , Asset_And_Liability__c , Source__c , Amount__c  from   Financials_Source__c where Asset_And_Liability__c in : lstId] ;
        
        for(Financials_Source__c  obj : fsObj ){
                if( mapAsset.get(obj.Asset_And_Liability__c)!= null){
                Asset_And_Liability__c objAsset = mapAsset.get(obj.Asset_And_Liability__c);
                string recordtypename = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(objAsset.recordtypeid).getname();
                if(!recordtypename.contains('Liability'))
                {
                    obj.Amount__c = objAsset.Value__c;
                }
                
                if(recordtypename.contains('Liability'))
                {
                    if(objAsset.Current_Balance__c != null){
                        obj.Amount__c = objAsset.Current_Balance__c;
                    }
                    
                    if(objAsset.Limit__c != null){
                        obj.Amount__c = objAsset.Limit__c;                   
                       
                    }
                }
                if(mapUser.get(objAsset.LastModifiedById) != null  && (mapUser.get(objAsset.LastModifiedById).Contains('Community')  || mapUser.get(objAsset.LastModifiedById).Contains('Guest')))
                            tempFsObj.add(obj);
            }
        }
        if( tempFsObj.size() > 0)
           update tempFsObj;
        
    }
}