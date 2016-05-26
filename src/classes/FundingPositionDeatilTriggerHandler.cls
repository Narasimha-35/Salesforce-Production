public with sharing class FundingPositionDeatilTriggerHandler extends TriggerHandler{
    public override void beforeUpdate() { 
        allowListedUsers('Update');
    }
    
    public override void beforeInsert() { 
        allowListedUsers('Insert');
    }
    
    public void allowListedUsers(String Event){
        Set<String> profileSet = new Set<String>();
        string NAME = 'Name';
        string AMOUNT = 'Amount__c';
        string ASSETLIABILITY = 'Asset_And_Liability__c';
        string CATEGORY = 'Category__c';
        string DETAILTYPE = 'Detail_Type__c';
        string FUNDINGPOSITION = 'Funding_Position__c';
        
        List<ProfilesToOverwrite__c> profilesList = ProfilesToOverwrite__c.getall().values(); 
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String currUserProfile = PROFILE[0].Name;
        system.debug('##curr'+profilesList );
        system.debug('##currUser'+currUserProfile);
       
        if(profilesList.size() > 0){
            for(ProfilesToOverwrite__c pList:profilesList){
                system.debug('###pList'+pList);
                profileSet.add(pList.Name);
            }
            Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Funding_Position_Detail__c .fields.getMap();
            if(!profileSet.contains(currUserProfile)){
                 for(Funding_Position_Detail__c fDetTrig:(List<Funding_Position_Detail__c >)trigger.new){ 
                      if(Event == 'Update'){
                          fDetTrig.Name = (String)trigger.oldMap.get(fDetTrig.id).get(Name);
                          fDetTrig.Amount__c = (Decimal)trigger.oldMap.get(fDetTrig.id).get(AMOUNT);
                          fDetTrig.Asset_And_Liability__c = (Id)trigger.oldMap.get(fDetTrig.id).get(ASSETLIABILITY);
                          fDetTrig.Category__c = (String)trigger.oldMap.get(fDetTrig.id).get(CATEGORY);
                          fDetTrig.Detail_Type__c = (String)trigger.oldMap.get(fDetTrig.id).get(DETAILTYPE);
                          //fDetTrig.Funding_Position__c = (Id)trigger.oldMap.get(fDetTrig.id).get(FUNDINGPOSITION);
                      }
                 }
            }
        }
    }
}