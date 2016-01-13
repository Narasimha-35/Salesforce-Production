public without sharing class PreviewFileController {

    public PreviewFileController(ApexPages.StandardController controller) {
        getAllAttachmentFromOpportunity();
    }

    public static List<AttachmentWithReqInfo> attachInfos {get; set;}
    public static Id oppoId {get; set;}
    
    /* Select Attachement from require documents and also from opportunit itself */
    public static void getAllAttachmentFromOpportunity() {
        Id opportunityId = ApexPages.currentPage().getParameters().get('Id');
        oppoId = opportunityId;
        attachInfos = new List<AttachmentWithReqInfo>();
        List<Required_Document__c> requiredDocs = [select Id, Name, acfStatus__c From Required_Document__c where acfOpportunity__c = :opportunityId];
        if (requiredDocs != null && requiredDocs.size() > 0) {
            Map<String, String> requriedDoceNameAndId = new Map<String, String>();
            for (Required_Document__c requiredDoc : requiredDocs) {
                requriedDoceNameAndId.put(requiredDoc.Id, requiredDoc.Name);
            }
            List<Attachment> attachments = new List<Attachment>();
            List<Attachment> attachmentsOppo = new List<Attachment>();
            attachments = [select id, name, body, BodyLength, ParentId from attachment where ParentId in :requiredDocs];
            if (attachments.size() > 0) {
                for (Integer i = 0 ; i < attachments.size() ; i ++) {
                    if (attachments.get(i).ParentId != null) {
                        AttachmentWithReqInfo attachInfo = new AttachmentWithReqInfo();
                        attachInfo.requiredDocName = requriedDoceNameAndId.get(attachments.get(i).ParentId) != null ? requriedDoceNameAndId.get(attachments.get(i).ParentId) : '';
                        attachInfo.docSize = attachments.get(i).BodyLength != null ? Integer.valueOf(attachments.get(i).BodyLength / 1024) : 0;
                        attachInfo.fileName = attachments.get(i).Name;
                        attachInfo.attchmentId = attachments.get(i).Id;
                        attachInfos.add(attachInfo);
                    }
                }
            }
            attachmentsOppo = [select id, name, body, BodyLength, ParentId from attachment where ParentId = :oppoId ];
            if (attachmentsOppo.size() > 0) {
                for (Integer i = 0 ; i < attachmentsOppo.size() ; i ++) {
                    if (attachmentsOppo.get(i).ParentId != null) {
                        AttachmentWithReqInfo attachInfo = new AttachmentWithReqInfo();
                        attachInfo.requiredDocName = '';
                        attachInfo.docSize = attachmentsOppo.get(i).BodyLength != null ? Integer.valueOf(attachmentsOppo.get(i).BodyLength / 1024) : 0;
                        attachInfo.fileName = attachmentsOppo.get(i).Name;
                        attachInfo.attchmentId = attachmentsOppo.get(i).Id;
                        attachInfos.add(attachInfo);
                    }
                }
            }
        }
    }

    public class AttachmentWithReqInfo {
        public String requiredDocName {get; set;}
        public String  fileName {get; set;}
        public Integer docSize {get; set;}
        public String attchmentId {get; set;}
    }   
}