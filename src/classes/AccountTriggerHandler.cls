public class AccountTriggerHandler extends TriggerHandler{
    public override void afterInsert(){
        List<CoreLogicEnquiryReport__c> enqRepList = new List<CoreLogicEnquiryReport__c>();
        for(Account acc:((List<Account>) trigger.new)){
            // add by chen
            if (acc.Property_Detail_Response__c != null && acc.Property_Detail_Response__c != '') {
                enqRepList = createEnquiryReports(acc);
            }
        }
        
        if(enqRepList !=null && enqRepList.size() > 0){
            
            Database.SaveResult[] srList = Database.insert(enqRepList,false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted enquiry report. Enquiry Report: ' + sr.getId());
                    
                }
                else {              
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //trigger.newMap.get(sr.getId()).addError('Record Not Created As Property Id');
                    }
                }
            }
        }
    }
    
    private List<CoreLogicEnquiryReport__c> createEnquiryReports(Account acc){
        try{
            Matcher myMatcher;
            String propString = '';
            String propDetailResp = '';
            List<CoreLogicEnquiryReport__c> enqRepList = new List<CoreLogicEnquiryReport__c>();
            // change by chen
            Set<String> propIdSet = new Set<String>();
            String relationship = '';
            if(acc != null && acc.Property_Detail_Response__c !=null && acc.Property_Detail_Response__c !='')
                propString = acc.Property_Detail_Response__c;
            if(propString !=null && propString !='' && propString.contains('Property-Detail-ID'))
                propDetailResp = propString.substringBetween('Property-Detail-ID":"', '",');
            system.debug('###'+propDetailResp);
            Pattern myPattern = Pattern.compile('[A-Za-z0-9]{18}');
            myMatcher = myPattern.matcher(propDetailResp);
            system.debug('###1'+myMatcher);
            if(!myMatcher.matches()){
                if(acc != null){
                    acc.addError('Please add a valid Property Detail Id for Account'+acc.id);
                    return null;
                }
            }
            propIdSet.add(propDetailResp);
            system.debug('###'+propString);
            relationship = propString.substringBetween('relationship":"', '"');
            system.debug('###'+relationship);
            CoreLogicEnquiryReport__c enqReport = new CoreLogicEnquiryReport__c();
            if(acc != null){
                //System.debug('account ' + acc.id);
                enqReport.Account__c = acc.id;
                System.debug('propDetailResp ' + propDetailResp);
                // edit by chen
                enqReport.Property_Detail__c = Id.valueOf(propDetailResp);
                enqReport.Property_Detail_Response__c = relationship;
                enqRepList.add(enqReport);
            }
            return enqRepList; 
        }
        
        catch(Exception e){
            //acc.addError('Please correct your JSON Response');
            return null;
        }
        
             
    }
    
    public override void afterUpdate(){
        String PROPDETAILRESP = 'Property_Detail_Response__c';
        String propIDNew = '';
        String propIDOld = '';
        String relationOld = '';
        String relationNew = '';
        string oldString = '';
        Set<id> accChangedSet = new Set<id>();
        Set<String> propIdSet = new Set<String>();
        Set<id> accToBeUpdatedSet = new Set<id>();
        Map<id,string> accRelMap = new Map<Id,string>();
        Map<id,string> accPropIdMap = new Map<Id,string>();
        Map<id,Account> accountMap = new Map<Id,Account>();
         system.debug('##entered');
        for(Account acc:((List<Account>) trigger.new)){
             system.debug('##entered1');
             
            oldString = String.valueOf(trigger.oldMap.get(acc.id).get(PROPDETAILRESP));
            System.debug('@@@oldString' + oldString);
            
            if (acc.Property_Detail_Response__c != null && acc.Property_Detail_Response__c != '' && (oldString == null || oldString == '')) {
                system.debug('##entered');
                if(acc.Property_Detail_Response__c.contains('Property-Detail-ID')){
                    propIDNew = acc.Property_Detail_Response__c.substringBetween('Property-Detail-ID":"', '",');
                }
                accChangedSet.add(acc.id);
                accountMap.put(acc.id,acc);
            }
            
            // add by chen
            else if (acc.Property_Detail_Response__c != null && acc.Property_Detail_Response__c != '' && oldString != null && oldString != '') {
            
                if(acc.Property_Detail_Response__c != trigger.oldMap.get(acc.id).get(PROPDETAILRESP)){
                    if(acc.Property_Detail_Response__c.contains('Property-Detail-ID')){
                        propIDNew = acc.Property_Detail_Response__c.substringBetween('Property-Detail-ID":"', '",');
                        //accPropMapNew.put(acc.id,propIDNew);
                    }
                    if(oldString.contains('Property-Detail-ID')){
                        propIDOld = oldString.substringBetween('Property-Detail-ID":"', '",');
                        //accPropMapOld.put(acc.id,propIDOld);
                    }
                    
                    if(acc.Property_Detail_Response__c.contains('relationship')){
                        relationNew = acc.Property_Detail_Response__c.substringBetween('relationship":"', '"');
                    }
                    if(oldString.contains('relationship')){
                        relationOld = oldString.substringBetween('relationship":"', '"');
                    }
                    System.debug('Compare ' + propIDNew.trim() + ' ' + propIDOld.trim());
                    if(propIDNew!=null && propIDOld!= null && propIDNew.trim() != propIDOld.trim()){
                        accChangedSet.add(acc.id);
                    }
                    else if(relationNew.trim() != relationOld.trim()){
                        accToBeUpdatedSet.add(acc.id);
                        propIdSet.add(propIDNew);
                        accRelMap.put(acc.id,relationNew);
                        accPropIdMap.put(acc.id,propIDNew);
                    }
                    
                    accountMap.put(acc.id,acc);
                }
            }
        }
        system.debug('###rel'+relationNew);
        system.debug('###rel1'+relationOld);
        system.debug('###prop'+propIDNew);
        List<CoreLogicEnquiryReport__c> enqRepListInsert = new List<CoreLogicEnquiryReport__c>();
        if(accChangedSet !=null && accChangedSet.size() > 0){
            for(Id accId:accChangedSet){
                enqRepListInsert = createEnquiryReports(accountMap.get(accId));
            }
        }
        
        if(enqRepListInsert!=null && enqRepListInsert.size() > 0){
           upsert enqRepListInsert;         
        }
        
        if(accToBeUpdatedSet !=null && accToBeUpdatedSet.size() > 0){
            List<CoreLogicEnquiryReport__c> coreList = [Select id,Account__c,Property_Detail_Response__c from CoreLogicEnquiryReport__c where Property_Detail__c=:propIdSet AND Account__c=:accToBeUpdatedSet];
            for(CoreLogicEnquiryReport__c cList:coreList){
                cList.Property_Detail_Response__c = accRelMap.get(cList.Account__c);
            }
            update coreList;
        }
        
    }
}