/*====================================================
				Click Loans
========================================================*/
public  class acfTriggerOnOpportunityHandler 
{
    public acfTriggerOnOpportunityHandler()
    {
    }
    //Method to call on opportunity after Update.
    public void OnAfterInsert(List<opportunity>lstTriggerNew)
    {
       //Create Task from TaskMaster    
       CreateTaskFromTaskMaster(lstTriggerNew); 
       CreateOpportunityLineItems(lstTriggerNew);
    }
    //Create task after opportunity created. 
    public void CreateTaskFromTaskMaster(List<opportunity>lstTriggerNew)
    {
        List<Task>lstTaskToInsert = new List<Task>();
        List<acfTask_Master__c>lstTask = [select id,acfDescription__c,acfIsActive__c,acfStage__c,acfSubject__c 
                                                 from acfTask_Master__c where acfIsActive__c=true and acfStage__c='Opportunity Creation'];
                                         
        for(Opportunity objOpp:lstTriggerNew)
        {
            for(acfTask_Master__c objTMTask:lstTask)
            {
                Task objTask             = new Task();
                objTask.Description      = objTMTask.acfDescription__c;
                objTask.WhatId           = objOpp.id;    
                objTask.Status           = 'open';
                objTask.Priority         = 'Normal';
                objTask.ActivityDate     = system.Today();
                objTask.IsVisibleInSelfService  = true;
                objTask.subject          = objTMTask.acfSubject__c;
                lstTaskToInsert.add(objTask);
            }
        }
        if(lstTaskToInsert <> null && lstTaskToInsert.size()>0)
          insert lstTaskToInsert;                                                                
    }
    
    public void updateExistingTaskStatus(List<opportunity>lstTriggerNew)
    {
        set<Id> setOpportunityBankIds = new set<Id>();
        set<Id> setOpportunityIdentityIds = new set<Id>();
        if(lstTriggerNew != null && lstTriggerNew.size()>0)
        {
            for(opportunity objOpportunity : lstTriggerNew)
            {
            system.debug('@@@karthik@'+objOpportunity.clickJumio_Status__c+'===='+objOpportunity.acfBankdetailStatus__c);
                if(objOpportunity.acfBankdetailStatus__c == 'Completed')
                {
                    setOpportunityBankIds.add(objOpportunity.id);
                }
                if(objOpportunity.clickJumio_Status__c == 'Attempted')
                {
                    setOpportunityIdentityIds.add(objOpportunity.id);
                }
            }
        }
        if(setOpportunityBankIds != null && setOpportunityIdentityIds != null)
        {
            list<Task> lstTaskToUpdate = [select id,Status,WhatId,acf_Is_Upload_Bank_Stmt__c,acf_Is_Upload_Identity_Verification__c,subject from Task where (WhatId IN:setOpportunityBankIds AND acf_Is_Upload_Bank_Stmt__c = true) OR (WhatId IN:setOpportunityIdentityIds AND acf_Is_Upload_Identity_Verification__c = true)];
            list<Task> lstUpdatedTasks = new list<Task>();
            for(Task objTask : lstTaskToUpdate)
            {
                objTask.Status = 'Completed';
                lstUpdatedTasks.add(objTask);
            }
            if(lstUpdatedTasks != null && lstUpdatedTasks.size()>0)
            {
                update lstUpdatedTasks;
            }
        }
    }
    
    public void CreateOpportunityLineItems(List<opportunity>lstTriggerNew)
    {
        set<Id>setLVRID = new set<Id>();
        set<Id>setProductIDs = new set<Id>();
        map<Id,LVR_Rate__c>mapLVRProdIdToLVR = new map<Id,LVR_Rate__c>();
        map<id,pricebookentry>mapPricebookentries = new map<id,pricebookentry>();
        List<OpportunityLineItem>lstOpportunityLIToInsert = new List<OpportunityLineItem>();
        for(Opportunity objOpp:lstTriggerNew)
        {
            if(objOpp.acfProduct_LVR__c <> null)
            {
              setLVRID.add(objOpp.acfProduct_LVR__c);   
            }
            
        }
        system.debug('!@#$%^'+setLVRID);
        if(setLVRID.size()>0)
        {
            for(LVR_Rate__c objLVR:[select id,acfLVR__c,acfProduct__c,acfRate__c,acfProduct__r.acfTotal_Fee__c,acfProduct__r.acfTenure_in_Years__c,acfProduct__r.acfvarTenure_In_Years__c,acfProduct__r.RecordType.Name,acfProduct__r.ACF_Comparison_Rate__c,acfTotal_Fee__c,ACF_Comparison_Rate__c from LVR_Rate__c where id In:setLVRID])
            {
                setProductIDs.add(objLVR.acfProduct__c);
                mapLVRProdIdToLVR.put(objLVR.id,objLVR);
            }
            if(setProductIDs.size()>0)
            {
                  for(pricebookentry pbe:[select id, unitprice, product2id 
                                          from pricebookentry 
                                          where pricebook2.isstandard = true 
                                            and product2id in :setProductIDs]) {
                  mapPricebookentries.put(pbe.product2id, pbe);
                  }
                  system.debug('@@@@@Lokesh'+mapPricebookentries);
            }
            system.debug('!@#$%^'+mapLVRProdIdToLVR);
            if(mapLVRProdIdToLVR <> null)
            {
                for(Opportunity objOpp:lstTriggerNew)
                {
                    if(objOpp.acfProduct_LVR__c <> null && mapLVRProdIdToLVR.get(objOpp.acfProduct_LVR__c)<> null && mapPricebookentries <> null && mapPricebookentries.get(mapLVRProdIdToLVR.get(objOpp.acfProduct_LVR__c).acfProduct__c)<>null)
                    {
                        
                        LVR_Rate__c objLVR = mapLVRProdIdToLVR.get(objOpp.acfProduct_LVR__c);
                        system.debug('@@@testing'+objLVR);
                        if(objOpp.acfCurrentLoanAmount__c <> null && objLVR.acfRate__c <> null && objOpp.acfPayment_Type__c <> null && (objLVR.acfProduct__r.acfTenure_in_Years__c <> null || objLVR.acfProduct__r.acfvarTenure_In_Years__c <> null))
                        {
                            OpportunityLineItem objOppLI   = new OpportunityLineItem();
                            objOppLI.OpportunityId         = objOpp.id;
                            If(objLVR.acfProduct__r.RecordType.Name == 'Fixed'){
                                objOppLI.Quantity = Integer.valueof(objLVR.acfProduct__r.acfTenure_in_Years__c);
                            }
                            If(objLVR.acfProduct__r.RecordType.Name == 'Variable') {
                                objOppLI.Quantity = objLVR.acfProduct__r.acfvarTenure_In_Years__c;
                            }
                            system.debug('!@#$%^'+objOpp.acfCurrentLoanAmount__c);
                            If(objLVR.acfProduct__r.RecordType.Name == 'Fixed'){
                                if(acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfTenure_in_Years__c))<> null)
                                    objOppLI.UnitPrice  = acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfTenure_in_Years__c));
                                else
                                   objOppLI.UnitPrice = 0.00;
                            }else If(objLVR.acfProduct__r.RecordType.Name == 'Variable'){
                                if(acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfvarTenure_In_Years__c))<> null)
                                    objOppLI.UnitPrice  = acfCommon.calculateMonthlyPayment(objOpp.acfCurrentLoanAmount__c,double.valueof(objLVR.acfRate__c),objOpp.acfPayment_Type__c,double.valueof(objLVR.acfProduct__r.acfvarTenure_In_Years__c));
                                else
                                   objOppLI.UnitPrice = 0.00;
                                }
                            system.debug('@@@#$%'+objOppLI.UnitPrice);
                            objOppLI.PricebookEntryId      = mapPricebookentries.get(objLVR.acfProduct__c).id;
                            objOppLI.acfRate__c            = objLVR.acfRate__c; 
                            objOppLI.acfLoan_Fees__c       = objLVR.acfTotal_Fee__c;
                            objOppLI.acfComparison_Rate__c = objLVR.ACF_Comparison_Rate__c;                          
                            lstOpportunityLIToInsert.add(objOppLI);
                        }    
                    }   
                }
                if(lstOpportunityLIToInsert <> null && lstOpportunityLIToInsert.size()>0)
                {
                    system.debug('testing@@@'+lstOpportunityLIToInsert);
                    insert lstOpportunityLIToInsert;
                }
            }
        }
    }
    
}