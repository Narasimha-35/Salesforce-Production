/*
    Handler class for acfTriggerOnAssets trigger
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla                21/04/2016                               1.0
    =============================================================================
*/ 
public class acfTriggerOnAssetsHandler
{
    public void onAfterInsert(list<Asset_And_Liability__c> triggernew)
    {
        updateHouseWorthOnAccount(triggernew);
    }
    public void onAfterUpdate(list<Asset_And_Liability__c> triggernew,map<id,Asset_And_Liability__c> triggerOldMap)
    {
        updateHouseWorthOnAccount(triggernew);
    }
    public void onAfterDelete(list<Asset_And_Liability__c> triggerOld)
    {
        updateHouseWorthOnAccount(triggerOld);
    }
    //To update asset houseworth on account based on criteria
    public void updateHouseWorthOnAccount(list<Asset_And_Liability__c> triggernew)
    {
        string assetRealestateRecId = ClickCommon.GetRecordTypeId('Asset_And_Liability__c','Asset Real Estate');
        map<id,Decimal> mapAccIdToHouseWorth = new map<Id,Decimal>();
        map<id,Decimal> mapOppIdToHouseWorth = new map<Id,Decimal>();
        set<id> setAccIds = new set<id>();
        list<Account> lstAccountTobeUpdate = new list<Account>();
        list<Opportunity> lstOppTobeUpdate = new list<Opportunity>();
        Decimal tempHousevalue = 0;
        for(Asset_And_Liability__c objAsset : triggernew)
        {
            if(objAsset.recordTypeId == assetRealestateRecId && objAsset.Value__c <> null)
            {
               setAccIds.add(objAsset.Account__c);
            }
        }
        if(setAccIds <> null && setAccIds.size()>0)
        {
            list<Account> lstAccounts = [select id,acfAsset_House_Worth__c,acf_Lead__pr.isConverted,acf_Lead__pr.convertedOpportunityId,(select id,Value__c from Asset_And_Liabilities__r where 
                                        recordtypeId=:assetRealestateRecId AND Used_as_Security__c = true AND Value__c != null) from Account where Id IN:setAccIds];
            
            if(lstAccounts <> null && lstAccounts.size()>0)
            {
                for(Account objAccount : lstAccounts)
                {
                    tempHousevalue = 0;
                    if(objAccount.Asset_And_Liabilities__r != null && objAccount.Asset_And_Liabilities__r.size()>0)
                    {
                        for(Asset_And_Liability__c objAsset : objAccount.Asset_And_Liabilities__r)
                        {
                            if(objAsset.Value__c <> null)
                                tempHousevalue = tempHousevalue+objAsset.Value__c;
                        }
                        mapAccIdToHouseWorth.put(objAccount.id,tempHousevalue);
                        if(objAccount.acf_Lead__pr.isConverted == true && objAccount.acf_Lead__pr.convertedOpportunityId <> null)
                        {
                            mapOppIdToHouseWorth.put(objAccount.acf_Lead__pr.convertedOpportunityId,tempHousevalue);
                        }
                    }            
                }
            }
            //for account
            if(mapAccIdToHouseWorth != null && mapAccIdToHouseWorth.size()>0)
            {
               for(id accountId : mapAccIdToHouseWorth.keyset())
               {
                   Account objAccount = new Account(id=accountId);
                   objAccount.acfAsset_House_Worth__c = mapAccIdToHouseWorth.get(accountId);
                   lstAccountTobeUpdate.add(objAccount);
               } 
            }
            //for opp
            if(mapOppIdToHouseWorth != null && mapOppIdToHouseWorth.size()>0)
            {
               for(id oppId : mapOppIdToHouseWorth.keyset())
               {
                   Opportunity objOpportunity = new Opportunity(id=oppId);
                   objOpportunity.acfAsset_House_Worth__c = mapOppIdToHouseWorth.get(oppId);
                   lstOppTobeUpdate.add(objOpportunity);
               } 
            }
            if(lstAccountTobeUpdate != null && lstAccountTobeUpdate.size()>0)
            {
                update lstAccountTobeUpdate;
            }
            if(lstOppTobeUpdate != null && lstOppTobeUpdate.size()>0)
            {
                update lstOppTobeUpdate;
            }
         }
    }
}