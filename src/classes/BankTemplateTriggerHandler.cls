public class BankTemplateTriggerHandler extends TriggerHandler
{

    public override void beforeInsert()
    {   
        for( acf_Bank_Template__c   obj :((List<acf_Bank_Template__c>) trigger.new))
        {
            obj.Template_Version__c  =  'Version-0' ;
        }
    }
    
    public override  void afterinsert()
    {
        for( acf_Bank_Template__c   obj :((List<acf_Bank_Template__c>) trigger.new))
        {
        
        }
    }
    
    public override void beforeUpdate()
    {
    list<Id>   obkList = new list<id>();
    map<ID, String> mapBank = new map<ID, String>();
        for( acf_Bank_Template__c   obj :((List<acf_Bank_Template__c>) trigger.new))
        {
            if(obj.Template_Version__c != null  )
            {
                String tempVersion =  obj.Template_Version__c ;
                
                if(tempVersion.contains('-'))
                {
                    List<String> tempList =  tempVersion.split('-');
                    
                    if(tempList != null  &&  tempList.size() > 1   )
                    {
                      Integer versionCounter = Integer.valueof( tempList[1] );
                      versionCounter ++ ;
                      obj.Template_Version__c =  'Version-'+  versionCounter  ;
                      System.debug(obj.Template_Version__c  );
                        if(obj.Click_Loans_Bank_Detail__c    != null)
                        {
                        obkList.add(obj.Click_Loans_Bank_Detail__c);
                        mapBank.put(obj.Click_Loans_Bank_Detail__c,obj.Template_Version__c );
                        }
                     
                    }
                }
            }
            
           
            
        }
        
        if(obkList.size() > 0)
        {
           List<E_Consent__c>  listEconsent = [Select id , Version__c , Related_Bank_Id__c from E_Consent__c where Related_Bank_Id__c  in :obkList  ];
           List<E_Consent__c>   listToUpadte = new List<E_Consent__c>();
           for(E_Consent__c  econ :   listEconsent )
           {
               if(econ.Related_Bank_Id__c != null &&  mapBank.get(econ.Related_Bank_Id__c) != null)
               {
                    econ.Version__c =  mapBank.get(econ.Related_Bank_Id__c) ;  
                    listToUpadte.add(econ);               
               }
           }
           if(listToUpadte.size() > 0)
           {
               
               update listToUpadte ;
           }
        }
    }

}