Public Class AttachmentTriggerHandler{
    public void updateFileURL(List<Attachment> attList){
        system.debug('###att'+attList);
         Set<id> parentIdSet = new Set<Id>();
        List<String> attachmentIdList = new List<String>();
        for(Attachment att:attList){
           
            parentIdSet.add(att.ParentId);
            attachmentIdList.add(att.id);
        }
        
        List<Document_Master__c> docMasterList = [Select id,File_Address__c From Document_Master__c where id=:parentIdSet];
        
        if(docMasterList.size() > 0){
           docMasterList[0].File_Address__c  = 'https://'+URL.getSalesforceBaseURL().getHost()+'/servlet/servlet.FileDownload?file=' + attachmentIdList[0];
           update docMasterList;
        }

    }
}