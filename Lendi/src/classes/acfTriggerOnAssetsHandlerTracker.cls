@isTest

private class acfTriggerOnAssetsHandlerTracker{

private static Asset_And_Liability__c objAssetandLiablility;
private static Account objAccount;



    static testMethod void createAssnLiab()
    {
    
    objAccount = new account();
    objAccount = WLCommonTrackerClass.createAccount(objAccount);
    objAssetandLiablility = new Asset_And_Liability__c();
    objAssetandLiablility= WLCommonTrackerClass.createAssetandLiablility(objAssetandLiablility,objAccount);
    
    objAssetandLiablility.Account_Name__c = 'Bhasin Testingggg';
    update objAssetandLiablility;
    
        List<Asset_And_Liability__c> lstAssetLiab = new List<Asset_And_Liability__c>();
        Asset_And_Liability__c objAssetliab = new Asset_And_Liability__c();
        objAssetliab.Account__c = objAccount.Id;
        objAssetliab.Account_Name__c = 'Bhasin Test';
        objAssetliab.Account_Number__c ='432534';
        lstAssetLiab.add(objAssetliab);
        insert lstAssetLiab;
        
        lstAssetLiab[0].Account_Name__c = 'Manish Bhasin Test';
        update lstAssetLiab;
      //  delete lstAssetLiab;
        
        acfTriggerOnAssetsHandler triggOnAssetLiab =  new acfTriggerOnAssetsHandler();
        map<id,Asset_And_Liability__c> mapAssetandliab = new map<id,Asset_And_Liability__c>();
        triggOnAssetLiab.onAfterUpdate(lstAssetLiab,mapAssetandliab);
        triggOnAssetLiab.onAfterDelete(lstAssetLiab);
        delete lstAssetLiab;
    }
        
    

}