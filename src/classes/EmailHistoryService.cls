public with sharing class EmailHistoryService {

    public static void saveEmailHistory(List<String> recipants, List<String> ccRecipants, String emailSubject, String htmlBody, List<S3DocumentModel.UploadRequest> uploadRequests) {
        //update doc to s3
        List<S3Document__c> s3Docs;
        try{
            s3Docs = S3DocumentService.uploadDocument(uploadRequests);
        } catch (CalloutException e) { //TODO: remove this Exception handle
            // for demo use.
            s3Docs = new List<S3Document__c>();

            for(S3DocumentModel.UploadRequest req : uploadRequests) {
                S3Document__c doc = new S3Document__c();
                doc.name = req.name;
                doc.objectKey__c = 'demo object key';
                doc.version__c = 'demo object version';
                doc.contentType__c = S3StaticValue.PDF_MINE_TYPE;
                s3Docs.add(doc);
            }
        }

        //register to SF as doc Reference email history
        EmailHistory__c eh = new EmailHistory__c();
        eh.emailContent__c = htmlBody;
        eh.subject__c = emailSubject;
        eh.recipants__c = JSON.serialize(recipants);
        eh.ccRecipants__c = JSON.serialize(ccRecipants);
        insert eh;
        System.debug(LoggingLevel.INFO, 'Create Email History success...');

        for(S3Document__c doc : s3Docs) {
            doc.EmailHistory__c = eh.id;
        }

        insert s3Docs;
        insert S3DocumentService.constructFailureAsAttachment(s3Docs, uploadRequests);
        System.debug(LoggingLevel.INFO, 'Create S3 docs success...');
    }
    //========================================================================
    //      Created for Saving Email History Under Opportunity.
    //========================================================================
    public static void saveEmailHistoryUnderOpportunity(List<String> recipants, List<String> ccRecipants, String emailSubject, String htmlBody, List<S3DocumentModel.UploadRequest> uploadRequests,Id OppId)
    {
        //update doc to s3
        system.debug('test********************************');
        List<S3Document__c> s3Docs;
        if(uploadRequests != null && !uploadRequests.isEmpty())
        {
            try
              {
                s3Docs = S3DocumentService.uploadDocument(uploadRequests);
              }
              catch (CalloutException e)
              { //TODO: remove this Exception handle
                // for demo use.
                    s3Docs = new List<S3Document__c>();
                    for(S3DocumentModel.UploadRequest req : uploadRequests) 
                    {
                        S3Document__c doc = new S3Document__c();
                        doc.name = req.name;
                        doc.objectKey__c = 'demo object key';
                        doc.version__c = 'demo object version';
                        doc.contentType__c = S3StaticValue.PDF_MINE_TYPE;
                        s3Docs.add(doc);
                    }
              }
         }

        //register to SF as doc Reference email history
        try
        {
            system.debug('test1********************************');
              if(recipants != null && OppId != null)
              {
                  EmailHistory__c eh = new EmailHistory__c();
                  if(htmlBody != null && htmlBody != '')
                      eh.emailContent__c = htmlBody;
                  if(emailSubject != null && emailSubject != '')
                      eh.subject__c = emailSubject; 
                  eh.recipants__c = JSON.serialize(recipants);
                  if(ccRecipants != null && !ccRecipants.IsEmpty())
                      eh.ccRecipants__c = JSON.serialize(ccRecipants);
                  eh.AcfOpportunity__c = OppId;
                  insert eh;
                  
                  System.debug(LoggingLevel.INFO, 'Create Email History success...');
                  
                  if(s3Docs != null && !s3Docs.IsEmpty())
                  {
                      for(S3Document__c doc : s3Docs)
                      {
                        doc.EmailHistory__c = eh.id;
                      }
                      insert s3Docs;
                  }
              } 
              system.debug('s3Docs********************************'+s3Docs);
              if(s3Docs != null && !s3Docs.IsEmpty() && uploadRequests != null && !uploadRequests.IsEmpty())
                  insert S3DocumentService.constructFailureAsAttachment(s3Docs, uploadRequests);
              System.debug(LoggingLevel.INFO, 'Create S3 docs success...');
         }
         catch (CalloutException e)
         {
             system.debug('CalloutException******************************'+e);
         }             
    }

}