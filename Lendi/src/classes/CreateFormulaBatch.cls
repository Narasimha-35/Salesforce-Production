public with sharing class CreateFormulaBatch implements Database.Batchable<MetadataService.CustomField>,Database.AllowsCallouts
{
    

    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    boolean isUpdateable;
    public CreateFormulaBatch(){
        service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
    }
    public Iterable<MetadataService.CustomField> start(Database.BatchableContext BC)
    {
            isUpdateable = false;
            Map<String,List<String>> oppChildRelationshipMap = new Map<String,List<String>>();
            for(Schema.ChildRelationship cr : Opportunity.SObjectType.getDescribe().getChildRelationships()){
                if(cr.getRelationshipName() != null){
                    if(!oppChildRelationshipMap.containsKey(String.valueOf(cr.getChildSObject()))){
                       oppChildRelationshipMap.put(String.valueOf(cr.getChildSObject()),new List<String>()); 
                    }
                    
                    oppChildRelationshipMap.get(String.valueOf(cr.getChildSObject())).add(String.valueOf(cr.getField()));
                   // oppChildRelationshipMap.put(String.valueOf(cr.getChildSObject()),String.valueOf(cr.getField()));
                    SObjectType objectType = Schema.getGlobalDescribe().get(String.valueOf(cr.getChildSObject()));
    
                    for(Schema.ChildRelationship cr1: objectType.getDescribe().getChildRelationships()){
                        if(cr1.getRelationshipName() != null ){
                            string relateName = String.valueOf(cr1.getField()).replace('__c','__r');
                            if(!oppChildRelationshipMap.containsKey(String.valueOf(cr1.getChildSObject()))){
                                oppChildRelationshipMap.put(String.valueOf(cr1.getChildSObject()),new List<String>()); 
                            }
                            oppChildRelationshipMap.get(String.valueOf(cr1.getChildSObject())).add(relateName+'.'+cr.getField());
                            SObjectType objectType1 = Schema.getGlobalDescribe().get(String.valueOf(cr1.getChildSObject()));
        
                            for(Schema.ChildRelationship cr2:objectType1.getDescribe().getChildRelationships()){
                               if(cr2.getRelationshipName() != null ){
                                   string relateName2 = String.valueOf(cr2.getField()).replace('__c','__r');
                                   relateName2 = relateName2+'.'+relateName;
                                   if(!oppChildRelationshipMap.containsKey(String.valueOf(cr2.getChildSObject()))){
                                        oppChildRelationshipMap.put(String.valueOf(cr2.getChildSObject()),new List<String>()); 
                                   }
                                   oppChildRelationshipMap.get(String.valueOf(cr2.getChildSObject())).add(relateName2+'.'+cr.getField());
                                   //oppChildRelationshipMap.put(String.valueOf(cr2.getChildSObject()),relateName2+'.'+cr.getField());
                               }
                           }
                
                        }
                    }
                }
            }
           
            system.debug('###123'+oppChildRelationshipMap.KeySet());

            Map<String,String> objRelMap = new Map<String,String>();
            List<MetadataService.CustomField> customFieldList = new List<MetadataService.CustomField>();
            List<ObjectRelationships__c> objRelListExisting  = [Select id,Name,RelationshipDetail__c FROM ObjectRelationships__c Limit 999];
            if(objRelListExisting  !=null && objRelListExisting.size() > 0){
              for(ObjectRelationships__c relDetail:objRelListExisting){
                  if(!objRelMap.containsKey(relDetail.Name))
                    objRelMap.put(relDetail.Name,relDetail.RelationshipDetail__c);
              }

            }
            List<ObjectRelationships__c> Objrellist = new List<ObjectRelationships__c>();
            for(String childObj:oppChildRelationshipMap.KeySet()){
              system.debug('###Entered'+childObj);
                 Integer Counter = 1;
                 String relationships = '';
                 String fieldString = '';
                 ObjectRelationships__c objRelObject = new ObjectRelationships__c();
                 for(String childValue:oppChildRelationshipMap.get(childObj)){
                      if(!childValue.contains('Copy_From__r') && !childValue.contains('Rental_Income__r') && !childValue.contains('clickMarried_To__r')){
                          MetadataService.CustomField customField = new MetadataService.CustomField();
                          customField.fullName = childObj+'.commonAPI'+String.valueOf(Counter)+'__c';
                          customField.formula = 'CASESAFEID('+childValue+')';
                          customField.label = 'Common API'+String.valueOf(Counter);
                          customField.type_x = 'Text';
                          if(counter == 1){
                              relationships = childValue;
                              fieldString = 'commonAPI'+String.valueOf(Counter)+'__c';
                          }
                          else{
                                relationships += ','+childValue;
                                fieldString += ','+ 'commonAPI'+String.valueOf(Counter)+'__c'; 
                          }
                            
                         customFieldList.add(customField);
                          counter++;
                      }
                 }
                  if(objRelListExisting !=null && objRelListExisting.size() >0 && objRelMap.containsKey(childObj)){
                      for(ObjectRelationships__c objRel:objRelListExisting){
                          if(objRel.Name == childObj){
                              objRel.RelationshipDetail__c  = relationships;
                              objRel.Field_Name__c = fieldString;
                              isUpdateable = true;
                          }
                              
                      } 
                  } 
                  
                  else if((objRelListExisting !=null && objRelListExisting.size() >0 && !objRelMap.containsKey(childObj)) || (objRelListExisting.size() == 0)){
                    objRelObject.Name = childObj;
                    objRelObject.RelationshipDetail__c = relationships;
                    objRelObject.Field_Name__c = fieldString;
                    Objrellist.add(objRelObject);
                  }
              }
              
                  //customFieldList = new List<MetadataService.Metadata>();
           if(Objrellist !=null && Objrellist.size() > 0)
              insert Objrellist;
           if(isUpdateable)
              update objRelListExisting;
                 
           return customFieldList;
    }
 
    public void execute(Database.BatchableContext info, List<MetadataService.CustomField> fieldList)
    {
         system.debug('###field'+fieldList);
        for(MetadataService.CustomField cField:fieldList){
             List<MetadataService.SaveResult> results =  service.createMetadata(new MetadataService.Metadata[] { cField});
             system.debug('###result'+results[0]);
         }
        // Do something really expensive with the string!
       // String myString = strings[0];
    }
 
    public void finish(Database.BatchableContext info) { }
}