// ----------------------------------------------------------------------------------
// This class Distributes the appointment 
// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       14-apr-2015      Vinod Tiwari VT         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes: This class distributes appointment to the brokers.
// ----------------------------------------------------------------------------------

public class SaaSFocus_Distribute_appointment 
{  
public List<Broker__c>Broker_special_lst;
public list<AggregateResult> counter_list;
public list<AggregateResult> counter_list1;
public list<Counter__c> clist;
    

/*Method which takes broker list through parameter and distributes appointment to 
desire brokers and increase/decrease counters*/

    public ID Compensatory_appointment(set<ID> Broker_ID , List<Market_Broker_Association__c> LstBrokerMarket)
    {
        
        //list which sorts parametrs list order by compensatory Appointment
        Broker_special_lst=[select id, Compensatory_Appointment__c from Broker__c where id in:Broker_ID order by Compensatory_Appointment__c desc ];
        
        ID Allocatedbrokerid ;
        
        if(Broker_special_lst[0].Compensatory_Appointment__c>0)  /*Here we are checking the compensatory appointement  greater than zero*/
                                                                    
            {
                Allocatedbrokerid  = Broker_special_lst[0].id;
                Broker_special_lst[0].Compensatory_Appointment__c--;
                //update Broker_special_lst[0];
            }
        else       //if compenstory appointment have null value it assigns zero 
            {   
                if(Broker_special_lst[0].Compensatory_Appointment__c==null)
                Broker_special_lst[0].Compensatory_Appointment__c=0;
                            
                //here we are getting Market broker assoiciation with region
                list<Market_Broker_Association__c> masterbrkerlist=[select id, Priority__c, Broker__r.id from Market_Broker_Association__c where Broker__c in :Broker_ID and id in: LstBrokerMarket];
               
                System.debug('Broker__c======'+masterbrkerlist[0].Broker__r.id);
                System.debug('Priority__c======'+masterbrkerlist[0].Priority__c);
                
                //this is the map for priority with id's.
                
                Map<String, set<id>> map_Broker = new Map<String, set<id>>();
                  
                for(Market_Broker_Association__c mba:masterbrkerlist)  //here is the map where map key has priority__c and value have set of id's.
                {                  
                    if(map_Broker.get(mba.Priority__c) == null)    // if map's Priority__c comes null than map put method works.
                    map_Broker.put(mba.Priority__c,new set<id>());
                    map_Broker.get(mba.Priority__c).add(mba.Broker__r.id );
                }
                  
                system.debug('PM***'+map_Broker.get('Primary Market'));
                system.debug('SM***'+map_Broker.get('Secondary Market'));

                 //here we are checking if map have Priority__c. 
            
                if(map_Broker.get('Primary Market')==null) 
                {
                    system.debug('Primary Market==='+map_Broker.get('Primary Market'));
                    clist=[select Count__c,Broker__c  from Counter__c where Broker__c in:map_Broker.get('Secondary Market') order by Count__c asc];
                }
                else if(map_Broker.get('Secondary Market')==null)
                {
                system.debug('Primary Market1==='+map_Broker.get('Primary Market'));
                    clist=  [select Count__c,Broker__c from Counter__c where Broker__c in:map_Broker.get('Primary Market') order by Count__c asc];
                }
                else
                {
                /*Here we are execuitng aggregate query for counter object*/
                
                    counter_list=[select min(Count__c)cnt from Counter__c where Broker__c in :map_Broker.get('Primary Market')];
                    System.debug('CounterlistPrimary Market'+counter_list);                          
                    counter_list1=[select min(Count__c)cnt1 from Counter__c where Broker__c in :map_Broker.get('Secondary Market')];
                    System.debug('CounterlistPrimary Market'+counter_list1);  
                    Decimal intdata = 0;
                    Decimal intdata1 = 0;
                    Decimal num = 0;
                    intdata =(Decimal)counter_list[0].get('cnt');
                    intdata1 =(Decimal)counter_list1[0].get('cnt1');
                     System.debug('intdata1 '+intdata1);  
                    System.debug('intdata'+intdata);  
                   //This is the custom setting where secondary appointment lag field set default as a constant
                    
                    Google_API_Setting__c obj_Lag= Google_API_Setting__c.getValues('Google_Setting'); // [select Secondary_Appointment_Lag__c from Google_API_Setting__c ];
               
                    num = intdata - intdata1 ;
                    System.debug('num '+num); 
                    if(num>=obj_Lag.Secondary_Appointment_Lag__c)
                    {
                        System.debug('reach here chen if');
                        clist=[select Count__c,Broker__c  from Counter__c where Broker__c  in:map_Broker.get('Secondary Market') order by Count__c asc];  
                    
                    }
                    else
                    {
                        System.debug('reach there chen else');
                        clist=[select Count__c ,Broker__c from Counter__c where Broker__c in:map_Broker.get('Primary Market') order by Count__c asc];
                    }
                } 
                  
                Allocatedbrokerid  = clist[0].broker__c;
                System.debug('clist[0].broker__c'+Allocatedbrokerid);
                clist[0].count__c ++;
               // update clist[0];
                
                System.debug('at last COmpen VT Bingo;;;;;'+Broker_special_lst[0].Compensatory_Appointment__c);
               // update Broker_special_lst[0];
            }
        System.debug('return all_id'+Allocatedbrokerid);
        return Allocatedbrokerid ;
    }
    ///////////////////////////////////////////////////////////
   
    public void compensatory_appointment_1(id Allocatedbrkrid){
        List<Broker__c>Broker_lst1;
        list<Counter__c> counterlist;
        ID compeid;
        System.debug('compensatory_appointment_1id Allocatedbrkrid'+Allocatedbrkrid);
        Broker_lst1=[select id, Compensatory_Appointment__c from Broker__c where id=:Allocatedbrkrid order by Compensatory_Appointment__c desc];
            
            compeid  = Broker_lst1[0].id;
        System.debug('compeid'+compeid);
            if( Broker_lst1[0].Compensatory_Appointment__c >0)
            {
                System.debug('if Broker_lst1[0].Compensatory_Appointment__c'+Broker_lst1[0].Compensatory_Appointment__c);
            Broker_lst1[0].Compensatory_Appointment__c--;
            
            update Broker_lst1[0];
            }
            counterlist=[select Count__c ,Broker__c from Counter__c where Broker__c=:Allocatedbrkrid order by Count__c asc ];
            System.debug('COunterlist'+counterlist);
            compeid  = counterlist[0].broker__c;
            counterlist[0].count__c ++;
            update counterlist[0];
            //update Broker_lst1[0];
           }
    
}