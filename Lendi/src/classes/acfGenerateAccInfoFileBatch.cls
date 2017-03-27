/*
    This Batch class is used to generate CSV file with account information
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla               10/12/2015                               1.0
    =============================================================================
*/
global class acfGenerateAccInfoFileBatch implements Database.batchable<SObject>,Database.AllowsCallouts {    
    global list<list<string>> lstCSVContent;
    global set<string> setMobilePhone = new set<string>();
    global set<string> setEmailIds = new set<string>();

    global acfGenerateAccInfoFileBatch(list<list<string>> lstFileContent,set<string> setMobileVals,set<string> setEmail) 
    {
        this.lstCSVContent = lstFileContent;       
        this.setMobilePhone.addAll(setMobileVals);
        this.setEmailIds.addAll(setEmail);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {      
      system.debug('@@@test'+setMobilePhone+'===='+setEmailIds);
      string strQuery = 'select id,PersonMobilePhone,PersonEmail,acfPerson_Email__c,acfPerson_Mobile__c from account where PersonMobilePhone IN :setMobilePhone OR PersonEmail IN :setEmailIds';
      system.debug('@@@test-Query@@'+strQuery);
      return Database.getQueryLocator(strQuery);
    }
    
    public void execute(Database.BatchableContext bc, list<Account> lstAccounts) 
    {
        map<string,set<Id>> mapPhoneTOaccIds = new map<string,set<Id>>();
        map<string,set<Id>> mapEmailToaccIds = new map<string,set<Id>>();
        String txtToInsert = 'Phone,Email,InSalesforce,AccountId \n';
        system.debug('@@@@karthik099@'+lstAccounts.size()+'==='+lstAccounts);
        for(Account objAccount : lstAccounts)
        {
            if(objAccount.PersonMobilePhone != null)
            {
                if(mapPhoneTOaccIds.get(objAccount.acfPerson_Mobile__c) == null)
                {
                    mapPhoneTOaccIds.put(objAccount.acfPerson_Mobile__c,new set<Id>());
                }
                mapPhoneTOaccIds.get(objAccount.acfPerson_Mobile__c).add(objAccount.id);
            }
            if(objAccount.PersonEmail != null)
            {
                if(mapEmailToaccIds.get(objAccount.acfPerson_Email__c)==null)
                {
                    mapEmailToaccIds.put(objAccount.acfPerson_Email__c,new set<Id>());
                }
                mapEmailToaccIds.get(objAccount.acfPerson_Email__c).add(objAccount.id);
            }
        }
            
        if(lstCSVContent!=null && lstCSVContent.size()>0)
        {
          
            for(list<string> lstCSVRowContent : lstCSVContent)
            {
                
                for(string strColumn : lstCSVRowContent)
                {
                    txtToInsert = txtToInsert+strColumn.trim()+',';
                    system.debug('@@@test124'+strColumn); 
                                       
                }
               system.debug('@@@@map@'+mapEmailToaccIds.size());
               system.debug('@@@@map@'+lstCSVRowContent[0].trim()+'==='+mapPhoneTOaccIds.get(lstCSVRowContent[0].trim())+'==='+lstCSVRowContent[1].trim()+'===='+mapEmailToaccIds.get(lstCSVRowContent[1].trim()));
                string strPhone = lstCSVRowContent[0].trim();
                string strEmailId = lstCSVRowContent[1].trim();
                if(lstCSVRowContent !=null && lstCSVRowContent.size()>0 && (mapPhoneTOaccIds.containsKey(strPhone) == true || mapEmailToaccIds.containsKey(strEmailId) == true))
                {
                    txtToInsert = txtToInsert+'Yes,';
                    set<id> setAllaccIds = new set<id>();
                    if(mapPhoneTOaccIds.get(strPhone) != null)
                        setAllaccIds.addAll(mapPhoneTOaccIds.get(strPhone));
                    if(mapEmailToaccIds.get(strEmailId) != null)
                        setAllaccIds.addAll(mapEmailToaccIds.get(strEmailId));
                 
                    if(setAllaccIds != null && setAllaccIds.size()>0)
                    {
                        for(string strAccountId : setAllaccIds)
                        {
                            txtToInsert = txtToInsert+strAccountId+' | ';                         
                        }
                    }
                    txtToInsert = txtToInsert+' \n';
                }
                else {
                        txtToInsert = txtToInsert+'no';
                        txtToInsert = txtToInsert+' \n';
                    }
                 
                system.debug('@@@test@@'+txtToInsert); 
                txtToInsert = txtToInsert.replaceAll('null', '');                      
            }
            list<Document> lstDocument = [select id,name from Document where name like 'Export Accounts Info%' AND FolderId =:UserInfo.getUserId() limit 1];
            if(lstDocument != null && lstDocument.size()>0)
            {
                Document doc = new Document (id = lstDocument[0].id);
                doc.Name = 'Export Accounts Info ' + '-'+ Datetime.now() + '.csv';
                doc.Body = Blob.valueOf(txtToInsert);
                Update doc;
            }else{
                    Document doc = new Document (Name = 'Export Accounts Info ' + '-'+ Datetime.now() + '.csv');
                    doc.Description = 'Account Information';
                    doc.IsPublic = true;
                    doc.FolderId = UserInfo.getUserId();
                    doc.Body = Blob.valueOf(txtToInsert);
                    insert doc;  
                    system.debug('@@@@doc@'+doc.id);
                }
        }
    }
    
    global void finish(Database.BatchableContext bc) 
    {
        list<Document> lstDocument = [select id,name,body,ContentType from Document where name like 'Export Accounts Info%' AND FolderId =:UserInfo.getUserId() limit 1];
        if(lstDocument != null && lstDocument.size()>0)
        {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('AccountsInfo.csv');
            efa.setBody(lstDocument[0].body);
            efa.setContentType(lstDocument[0].ContentType);
            efa.setInline(false);
            List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();
            lstAttachments.add(efa);
            
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {''+UserInfo.getUserEmail()+''};
            String subject ='Accounts Information';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Hi '+Userinfo.getName());
            email.setFileAttachments(lstAttachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }   
    }
}