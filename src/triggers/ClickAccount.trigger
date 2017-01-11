trigger ClickAccount on Account (before insert) 
{
    if(trigger.new != null)
    {
        set<string> setEmailId = new set<string>();
        for(Account objAcc : trigger.new)
        {
            if(objAcc.PersonEmail != null) 
                setEmailId.add(objAcc.PersonEmail);
        }    
        
        list<Account> lstDupAcc = [select id, PersonEmail  from Account where PersonEmail in: setEmailId and IsMaster__c = true and PersonEmail !=null];
        if(lstDupAcc != null && lstDupAcc.size() > 0)
        {
            map<string,Id> mapAccIdEmail = new map<string,Id>();
            for(Account objAcc : lstDupAcc )
                mapAccIdEmail.put(objAcc.PersonEmail, objAcc.Id);
                
            for(Account objAcc : trigger.new)
            {
                if(objAcc.PersonEmail != null && mapAccIdEmail.ContainsKey(objAcc.PersonEmail))
                    objAcc.SelfLookup__c = mapAccIdEmail.get(objAcc.PersonEmail);
                else
                    objAcc.IsMaster__c = true;
            }
        }
        else
        {
            for(Account objAcc : trigger.new)
                objAcc.IsMaster__c = true;
        }
        
    }
}