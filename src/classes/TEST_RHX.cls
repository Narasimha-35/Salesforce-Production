@isTest(SeeAllData=true)
public class TEST_RHX {
    
    static testMethod void vhc_Call() {
        
        List<sObject> sourceList = [SELECT Id
                                    FROM vhc__Call__c
                                    LIMIT 1];

        if(sourceList.size() == 0) {
            sourceList.add(
                    new vhc__Call__c()
                );
        }
    Database.upsert(sourceList);        
    }

}