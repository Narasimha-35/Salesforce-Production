/*
    Handler class for Financials Source trigger.THis class is use for setting 
    Source value.
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Prateek Kumar gupta             12-8-2016                                       1.0
    =============================================================================
*/ 


Public class FinancialSourcecTriggerHandler extends TriggerHandler
{

public override void AfterInsert()
{
    updateSourcecType(Trigger.New);
}


public override void AfterUpdate()
{
    //updateSourcecType(Trigger.New);
}


public void updateSourcecType(List<Financials_Source__c>  records)
{
    List<Id>   UserIds = new  List<Id>();
   System.debug(''+records);
    for(Financials_Source__c record :  records ){
        UserIds.add(record.createdById);
          System.debug('');
    }
    map<String,String> mapUser  = mapUserInputType(UserIds);                        
        System.debug(mapUser  );
        List<Financials_Source__c > fsObj = new List<Financials_Source__c >();
    for(Financials_Source__c record :  records ){
    Financials_Source__c  obj = new Financials_Source__c  ();
        if(mapUser.get(record.CreatedById) != null)
        obj.Source__c = mapUser.get(record.CreatedById);
        
        obj.Id = record.Id ;
        fsObj.add(Obj);
       }
    UPsert fsObj ;
}

  public static map<string,string> mapUserInputType(List<id> createdbyId )
      {
           map<id,user> mapUserIdToUser = new map<id,user>([select Alias,id, email, profileid,profile.name from user where isActive = true and ID in :createdbyId ]);
           map<string,string> mapusrIdToUsrInputType = new map<string,string>();
           string strUsrInputType = '';
           if(mapUserIdToUser != null && mapUserIdToUser.size()>0)
           {
               for(string userId : mapUserIdToUser.keyset())
               {
            
                   if(  mapUserIdToUser.get(userId).Email.contains('tech@'))
                   {
                        
                        mapusrIdToUsrInputType.put(userId,'Customer Input');
                 
                   }
              }

           }
           return mapusrIdToUsrInputType;
      }
}