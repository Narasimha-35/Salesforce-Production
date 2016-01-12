/*
    This trigger is used to update bankdetails when attachment is created
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla                04/02/2015                                1.0
    =============================================================================
*/

trigger autoUpdateBankdetails on Attachment (after insert) {

    public list<acfBank_Detail__c> lstBankdetails = new list<acfBank_Detail__c>();
    Map<String,String> objectMap = new Map<String,String>(); 
    public string bnkObjPrefix = '';
    List<Schema.SObjectType> lstSObject = Schema.getGlobalDescribe().Values();
    Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType sObjType = sobjectSchemaMap.get('acfBank_Detail__c');
    bnkObjPrefix = sObjType.getDescribe().getKeyPrefix(); 
    /*for(Schema.SObjectType sObjType : lstSObject){
       if(sObjType.getDescribe().getName() == 'acfBank_Detail__c')
       {
           bnkObjPrefix = sObjType.getDescribe().getKeyPrefix();
       }
        //objectMap.put(sObjType.getDescribe().getName(),sObjType.getDescribe().getKeyPrefix());
    }*/
    for(Attachment attchObj : Trigger.New)
    {
       If(attchObj != null && attchObj.ParentId != null && bnkObjPrefix != null && bnkObjPrefix <> ''){ 
        string strTempId = attchObj.ParentId;
        String prefix =  strTempId.substring(0,3);
        //string objectAPIName = objectMap.get(prefix);
        //System.debug('objectAPIName ----------- '+objectAPIName);
        If(prefix == bnkObjPrefix){
           acfBank_Detail__c objBankdetails = new acfBank_Detail__c(id = attchObj.ParentId,acfAttachmentId__c = attchObj.Id); 
           lstBankdetails.add(objBankdetails);
        }
      }
    }
    If(lstBankdetails != null && lstBankdetails.size()>0){
         Update lstBankdetails;
    }
}