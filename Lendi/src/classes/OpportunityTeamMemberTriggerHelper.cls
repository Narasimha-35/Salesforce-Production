public class OpportunityTeamMemberTriggerHelper extends TriggerHandler
{
    
    
    public override void beforeDelete()
    {
        List<Counter__c>   counterObj = new  List<Counter__c>();
        
         map<Id , Counter__c>  mapuser = new  map<Id , Counter__c>();
         List<Id> listUserIds = new  List<Id>();
                map<Id , Integer>  mapuserCount = new  map<Id , Integer>();
                for( OpportunityTeamMember   team :  (List<OpportunityTeamMember >) trigger.old )
                {
                   
                      listUserIds.add(team.UserID );
                    
                }
                
                List<OpportunityTeamMember>   listTeamMember = [Select  id , UserID   from  OpportunityTeamMember  where userid in : listUserIds] ;
                
                for( OpportunityTeamMember   team :  listTeamMember  )
                {
                   
                    
                        if(mapuserCount.containskey(team.UserID))
                        {
                            mapuserCount.put( team.UserID ,mapuserCount.get(team.UserID)  + 1 );
                        }
                        else
                        {
                            mapuserCount.put( team.UserID , 1 );
                        }
                      
                    
                }
                
                if(mapuserCount.size() > 0){
                
                List<Counter__c>   listCounter = [SELECT Count__c,User__c FROM Counter__c where  
                User__c  in : listUserIds   and  User__c != null ];
                
                for( Counter__c   obj :  listCounter)
                {
                    mapuser.put(obj.User__c,obj);
                }
                
                for( OpportunityTeamMember   team1 :   (List<OpportunityTeamMember >) trigger.old  )
                {
                    if( mapuser.containskey(team1.Userid))
                    {
                        if( mapuserCount.containskey( team1.Userid)  )
                        {
                            Counter__c  count =  mapuser.get(team1.Userid) ;
                            count.Count__c =   mapuserCount.get(team1.Userid) -1;
                            counterObj.add(count);
                        }
                        
                    }
                    else
                    {
                        
                        Counter__c  count =  new  Counter__c() ;
                        count.Count__c =   0;
                        count.User__c =  team1.Userid  ;
                        counterObj.add(count);
                    }
                }
                
                if(counterObj.size() > 0)
                {
                    upsert counterObj ;
                    System.debug(counterObj );
                }
                }
    }
    public override void afterUpdate()
    {
        System.debug(Trigger.isUpdate);
        Boolean userInTeam = false;
        Boolean userInTeam1 = false;
        List<Id> listUserIds = new  List<Id>();
        OpportunityTeamMember  forError ;
        List<OpportunityTeamMember> insertNewOpportunityTeamMember =  new List<OpportunityTeamMember> ();
        List<id> deleteOldOpportunityTeamMember =  new List<id> ();
        List<Id> updateOpportunityTeamMember =  new List<id> ();
        map<Id,OpportunityTeamMember> setIds =  new map<Id,OpportunityTeamMember>();
        map<Id,Opportunity> mapOpportunityIds =  new map<Id,Opportunity>();
        set<id> bankids = new set<id>();
        for(OpportunityTeamMember  teamMember :((List<OpportunityTeamMember >) trigger.new))
        {
            if(teamMember.Reassignment__c == true)
            {
                setIds.put(teamMember.OpportunityID,teamMember );
                
            }
        }
        
        if(setIds.size() > 0)
        {
            
            List<Opportunity> listOpp = [Select id ,Bank_Detail__c  from Opportunity where id in :  setIds.keyset()] ;
            for(Opportunity  opp :listOpp )
            {
                mapOpportunityIds.put( opp.Bank_Detail__c , opp);
                bankids.add(opp.Bank_Detail__c);
            }
            
            
            List<Production_Team__c>   listProduction = [ Select Id  ,Click_Loans_Bank_Detail__c  ,Team__c ,  
            User__c from  Production_Team__c
            where Click_Loans_Bank_Detail__c in :bankids ];
            map<String, List<Production_Team__c>>  mapProductionTeam = new  map<String, List<Production_Team__c>>();
            List<Production_Team__c>  UpdateProdList = new  List<Production_Team__c>();
            List<Id> listCounterUserIds = new List<Id>();
            for(Production_Team__c  prod : listProduction )
            {
                
                              
                if(  prod.Click_Loans_Bank_Detail__c != null
                &&  mapOpportunityIds.get(prod.Click_Loans_Bank_Detail__c) !=null
                &&  mapOpportunityIds.get(prod.Click_Loans_Bank_Detail__c).Bank_Detail__c  ==  prod.Click_Loans_Bank_Detail__c
                &&  setIds.get(mapOpportunityIds.get(prod.Click_Loans_Bank_Detail__c).id)!= null
                &&  setIds.get( mapOpportunityIds.get(prod.Click_Loans_Bank_Detail__c).id).userId == prod.User__c
                &&  setIds.get( mapOpportunityIds.get(prod.Click_Loans_Bank_Detail__c).id).TeamMemberRole == prod.Team__c
                )
                {
                    userInTeam = true ;
                    OpportunityTeamMember  member = setIds.get( mapOpportunityIds.get(prod.Click_Loans_Bank_Detail__c).id) ;
                    updateOpportunityTeamMember.add(member.id);
                }
                else
                {
                    if(setIds.get( mapOpportunityIds.get(prod.Click_Loans_Bank_Detail__c).id).TeamMemberRole == prod.Team__c)
                    {
                        
                        if(mapProductionTeam.containskey(prod.Click_Loans_Bank_Detail__c))
                        {
                            mapProductionTeam.get(prod.Click_Loans_Bank_Detail__c).add(prod);
                        }
                        else
                        {
                            List<Production_Team__c> tempList = new List<Production_Team__c>();
                            tempList.add(prod);
                            mapProductionTeam.put(prod.Click_Loans_Bank_Detail__c,tempList);
                        }
                        userInTeam1 = true;
                        listCounterUserIds.add(prod.User__c);
                    }
                    else
                    {
                        
                    }
                    
                }
            }
            
            List<Counter__c>  listCounterData = [SELECT Broker__c,Count__c,Id,Name,OwnerId,SystemModstamp,User__c 
            FROM Counter__c  where   User__c  in :listCounterUserIds  ] ;
            
            map<Id,Integer> mapUserCounter = new map<Id,Integer>();
            for( Counter__c count : listCounterData )
            {
                if(count.Count__c != null)
                mapUserCounter.put(count.Id ,  Integer.valueof(count.Count__c) );
            }
            
            System.debug(userInTeam1);
            for( String key : mapProductionTeam.keyset())
            {
                
                if(mapProductionTeam.get(key ).size() > 0  &&  mapProductionTeam.get(key ).size() == 1  && userInTeam == false   &&  userInTeam1 ==true )
                {
                    List<Production_Team__c> prodList  = mapProductionTeam.get(key ) ;
                    //prodList[0].counter__c = prodList[0].counter__c + 1;
                   // UpdateProdList.add(prodList[0]);
                    OpportunityTeamMember  team = new  OpportunityTeamMember();
                    team.OpportunityID = mapOpportunityIds.get(prodList[0].Click_Loans_Bank_Detail__c).id ;
                    team.Userid = prodList[0].User__c ;
                    team.TeamMemberRole   = prodList[0].Team__c ;
                    team.OpportunityAccessLevel = setIds.get( mapOpportunityIds.get(prodList[0].Click_Loans_Bank_Detail__c).id).OpportunityAccessLevel ;
                    insertNewOpportunityTeamMember.add(team);
                    deleteOldOpportunityTeamMember.add( setIds.get(mapOpportunityIds.get(prodList[0].Click_Loans_Bank_Detail__c).id).id);
                    
                }
                else if(mapProductionTeam.get(key ).size() > 1    &&  userInTeam1 ==true  ){
                    
                     List<Production_Team__c> tempList =  mapProductionTeam.get(key ) ;
                     Counter__c count  =  getTeamRecord(listCounterData );
                    if( userInTeam == false   && count != null  )
                    {
                        
                        Production_Team__c   tempProd = getProdTeam (  count ,mapProductionTeam.get(key ) );
                      
                        OpportunityTeamMember  team = new  OpportunityTeamMember();
                        team.OpportunityID = mapOpportunityIds.get(tempProd.Click_Loans_Bank_Detail__c).id ;
                        team.Userid = count.User__c ;
                        team.OpportunityAccessLevel = setIds.get( mapOpportunityIds.get(tempProd.Click_Loans_Bank_Detail__c).id).OpportunityAccessLevel ;
                        team.TeamMemberRole   = tempProd.Team__c ;
                        insertNewOpportunityTeamMember.add(team);
                        deleteOldOpportunityTeamMember.add( setIds.get(mapOpportunityIds.get(tempProd.Click_Loans_Bank_Detail__c).id).id);
                        System.debug(setIds.get(mapOpportunityIds.get(tempProd.Click_Loans_Bank_Detail__c).id));
                    }
                    
                }
                else{
                    //
                }
                
            }
            if(userInTeam1 ==false  && updateOpportunityTeamMember.size() == 0    )
            {
                System.debug('err');
                OpportunityTeamMember  team = new  OpportunityTeamMember();
                trigger.new[0].addError('This Team/User doesn\'t exist in Bank Production team.');
            }
            
            if(updateOpportunityTeamMember.size() > 0)
            {
                
                UpdateTeam(updateOpportunityTeamMember);
            }
            
            if(insertNewOpportunityTeamMember.size() > 0)
            {
                insert  insertNewOpportunityTeamMember;
                
            for(OpportunityTeamMember  teamMember : insertNewOpportunityTeamMember )
            {
                
                  listUserIds.add(teamMember.UserID );
                
            }
                
                List<Counter__c>   counterObj = new  List<Counter__c>();
                map<Id , Counter__c>  mapuser = new  map<Id , Counter__c>();
                List<Counter__c>   listCounter = [SELECT Count__c,User__c FROM Counter__c where  User__c  in : listUserIds   and  User__c != null ];
                
                System.debug( 'listCounter'+ listCounter);
                
                for( Counter__c   obj :  listCounter)
                {
                    mapuser.put(obj.User__c,obj);
                }
                List<OpportunityTeamMember>   listTeamMember = [Select  id , UserID   from  OpportunityTeamMember  where userid in : listUserIds] ;
                map<Id , Integer>  mapuserCount = new  map<Id , Integer>();
                for( OpportunityTeamMember   team :  listTeamMember)
                {
                    
                    if(mapuserCount.containskey(team.UserID))
                    {
                        mapuserCount.put( team.UserID ,mapuserCount.get(team.UserID)  + 1 );
                    }
                    else
                    {
                        mapuserCount.put( team.UserID , 1 );
                    }
                }
                
                System.debug(mapuserCount);
                
                for( OpportunityTeamMember   team1 :   insertNewOpportunityTeamMember )
                {
                    if( mapuser.containskey(team1.Userid))
                    {
                        if( mapuserCount.containskey( team1.Userid)  )
                        {
                            Counter__c  count =  mapuser.get(team1.Userid) ;
                            count.Count__c =   mapuserCount.get(team1.Userid);
                            counterObj.add(count);
                        }
                        
                    }
                    else
                    {
                        
                        Counter__c  count =  new  Counter__c() ;
                        count.Count__c =   1;
                        count.User__c =  team1.Userid  ;
                        counterObj.add(count);
                    }
                }
                System.debug(counterObj);
                
                if(counterObj.size() > 0)
                {
                    upsert counterObj ;
                    System.debug(counterObj );
                }
            }
            if(deleteOldOpportunityTeamMember.size() > 0)
            {
                
                deleteOldeTeam( deleteOldOpportunityTeamMember  );
            }
        }
    }
    
    
    
    public  void  UpdateTeam (List<ID>  listData)
    {
        List<OpportunityTeamMember> updateOpportunityTeamMember  = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> Oteam =  [Select Reassignment__c from  OpportunityTeamMember  where id in : listData] ;
        for(  OpportunityTeamMember   team : Oteam ){
            team.Reassignment__c = false;
            
            updateOpportunityTeamMember.add(team);
        }
        
        update updateOpportunityTeamMember ;
    }
    
    public  void  deleteOldeTeam (List<ID>  listData)
    {
        Delete [Select id from  OpportunityTeamMember  where id in : listData] ;
    }
    public Counter__c  getTeamRecord (List<Counter__c>  listData)
    {
        Counter__c   temp ;
        Integer  n = listData.size() ;
        System.debug(n);
        for(Integer i=0; i < n; i++)
        {
            for(Integer j=1; j < (n-i); j++)
            {
                System.debug(listData[j-1].Count__c );
                System.debug(listData[j].Count__c );
                if(listData[j-1].Count__c >= listData[j].Count__c)
                {
                    temp = listData[j-1];
                    listData[j-1] = listData[j];
                    listData[j] = temp;
                }
            }
        }
        return listData[0] ;
    }
    
    public Production_Team__c  getProdTeam (Counter__c  count ,List<Production_Team__c>  listProductionTeam )
    {
        Production_Team__c   temp ;
        
        for(Production_Team__c  obj  :  listProductionTeam)
        {
            if(obj.User__c  == count.user__C  )
            {
                temp =  obj ;
            }
        }
       
        return temp ;
    }
}