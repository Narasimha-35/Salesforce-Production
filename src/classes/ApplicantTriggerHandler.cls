/*
    This class is used handle Applicant Trigger logic
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla               04/05/2016                               1.0
    =============================================================================
*/
public class ApplicantTriggerHandler extends TriggerHandler
{
    string strIncomeSelfEmployedAPI = system.label.acfIncome_SelfEmployed_API;
    string strIncomePAYGAPI = system.label.acfIncome_PAYG_API;
    string strExpenseAPI = system.label.acfExpense_API;
    // changes done by Ankit 
    // added GUID functionality.
    public override void BeforeInsert() 
    {
        for(click_Applicant__c objApplicant : (List<click_Applicant__c>) Trigger.new) 
        {
            if(string.isEmpty(objApplicant.Lendi_User_uuid__c))
            {
                List<string> lstGuid = new List<string>();
                lstGuid = Utilities.NewGuid();
                if(lstGuid != null && !lstGuid.isEmpty())
                    objApplicant.Lendi_User_uuid__c= lstGuid[0];
            }
        }
    }
    public override void afterInsert() 
    {
        insertIncomeExpenses();
        createEconsentRecord();
    }
    public override void afterUpdate()
    {
        insertIncomeExpenses();
        updateFinancialSources(); 
        updateEconsentStatus();    
    }
    //create income and expense records
    public void insertIncomeExpenses()
    {
    system.debug('strIncomeSelfEmployedAPI-----'+strIncomePAYGAPI +'strExpenseAPI------' +strExpenseAPI);
    
        list<Income_And_Expense__c> lstIncomeExpense = new list<Income_And_Expense__c>();
        list<Financials_Source__c> lstFinanceSource = new list<Financials_Source__c>();
        Id IncomeRecTypeId = ClickCommon.GetRecordTypeId('Income_And_Expense__c','Income');
        Id ExpenseRecTypeId = ClickCommon.GetRecordTypeId('Income_And_Expense__c','Expense');
        for(click_Applicant__c objApplicant : (List<click_Applicant__c>) Trigger.new) 
        {
            if(objApplicant.acf_create_from_custom_clone_button__C == false){
            if((trigger.isInsert && objApplicant.get(strIncomeSelfEmployedAPI) != null) || (trigger.isUpdate && Trigger.oldmap.get(objApplicant.id).get(strIncomeSelfEmployedAPI) == null 
                && objApplicant.get(strIncomeSelfEmployedAPI) != Trigger.oldmap.get(objApplicant.id).get(strIncomeSelfEmployedAPI)))
            {
                Income_And_Expense__c objIncome = new Income_And_Expense__c();
                objIncome.Amount__c = double.valueof(objApplicant.get(strIncomeSelfEmployedAPI));
                objIncome.Account__c = objApplicant.click_Account__c;
                objIncome.Applicant__c = objApplicant.id;
                objIncome.Category__c = objApplicant.acfEmployment_Type__c;
                objIncome.acfDetails__c = 'Business Income';
                if(IncomeRecTypeId <> null)
                    objIncome.recordTypeId = IncomeRecTypeId;
                lstIncomeExpense.add(objIncome);
               
            }
           // system.debug('objIncomenamout---'+objIncome.Amount__c);
            system.debug('lstIncomeExpense------'+lstIncomeExpense);
            if((trigger.isInsert && objApplicant.get(strIncomePAYGAPI) != null ) || (trigger.isUpdate && Trigger.oldmap.get(objApplicant.id).get(strIncomePAYGAPI) == null && 
                objApplicant.get(strIncomePAYGAPI) != Trigger.oldmap.get(objApplicant.id).get(strIncomePAYGAPI)))
            {
                Income_And_Expense__c objIncome = new Income_And_Expense__c();
                objIncome.Amount__c = double.valueof(objApplicant.get(strIncomePAYGAPI));
                objIncome.Account__c = objApplicant.click_Account__c;
                objIncome.Applicant__c = objApplicant.id;
                objIncome.Category__c = objApplicant.acfEmployment_Type__c;
                objIncome.acfDetails__c = 'Base Salary';
                if(IncomeRecTypeId <> null)
                    objIncome.recordTypeId = IncomeRecTypeId;
                lstIncomeExpense.add(objIncome);
            }            
            system.debug('stringvalue12may'+objApplicant.get(strIncomePAYGAPI));
            
            if((trigger.isInsert && objApplicant.get(strExpenseAPI) != null)|| (trigger.isUpdate && Trigger.oldmap.get(objApplicant.id).get(strExpenseAPI) == null && 
                objApplicant.get(strExpenseAPI) != Trigger.oldmap.get(objApplicant.id).get(strExpenseAPI)))
            {
                Income_And_Expense__c objIncome = new Income_And_Expense__c();
                objIncome.Amount__c = double.valueof(objApplicant.get(strExpenseAPI));
                objIncome.Account__c = objApplicant.click_Account__c;
                objIncome.Applicant__c = objApplicant.id;
                objIncome.Category__c = 'Basic Living Expense';
                objIncome.acfDetails__c = 'Living Expenses';
                if(ExpenseRecTypeId <> null)
                    objIncome.recordTypeId = ExpenseRecTypeId;
                lstIncomeExpense.add(objIncome);
            }
           system.debug('ExpenseAPI-------'+objApplicant.get(strExpenseAPI));
            }
        }
        system.debug('!!@#$test'+lstIncomeExpense);
        if(lstIncomeExpense != null && lstIncomeExpense.size()>0)
        {
            insert lstIncomeExpense; 
            //================ changes done by Ankit =================================
            // for changing "1 to many" to "many to many" relationship between 
            // applicant and Income and expense.
            //========================================================================
            // for Ticket no. ACFQ-245
            //========================================================================  
            /*List<ApplicantAndI_ELink__c> lstApplicantAndIELink = new List<ApplicantAndI_ELink__c>();
            for(Income_And_Expense__c objIncomeandExpense : lstIncomeExpense)  
            {
                ApplicantAndI_ELink__c objApplicantandIELink = new ApplicantAndI_ELink__c();
                if(objIncomeandExpense.Applicant__c != null)
                    objApplicantandIELink.Applicant__c = objIncomeandExpense.Applicant__c;
                objApplicantandIELink.Income_And_Expense__c = objIncomeandExpense.Id;
                lstApplicantAndIELink.add(objApplicantandIELink);
            } 
            if(lstApplicantAndIELink != null && !lstApplicantAndIELink.IsEmpty()) 
                insert lstApplicantAndIELink;        */   
        }
    }
    //update financial source records
    public void updateFinancialSources()
    {
        list<Financials_Source__c> lstFSrcTobeUpdate = new list<Financials_Source__c>();
        list<Financials_Source__c> lstFSrcTobeInsert = new list<Financials_Source__c>();
        set<Id> setApplicantIds = new set<Id>();
        map<id,list<Financials_Source__c>> mapAppIdToFSrc = new map<id,list<Financials_Source__c>>();
        
        
        List<Id> lstid = new List<id>();
        
        map<string,boolean> mapIsFSCustomerInputExist = new map<string,boolean>();
        for(click_Applicant__c objApplicant : (List<click_Applicant__c>) Trigger.new) 
        {
            
            //for self employed type income 
            if((objApplicant.get(strIncomeSelfEmployedAPI) != Trigger.oldmap.get(objApplicant.id).get(strIncomeSelfEmployedAPI)) || (objApplicant.get(strIncomePAYGAPI) != Trigger.oldmap.get(objApplicant.id).get(strIncomePAYGAPI)) ||
            objApplicant.get(strExpenseAPI) != Trigger.oldmap.get(objApplicant.id).get(strExpenseAPI))
            {
                setApplicantIds.add(objApplicant.id);
                lstid.add(objApplicant.lastmodifiedbyid);
            }
            
        }
        system.debug('setApplicantIds-----'+setApplicantIds.size());
        system.debug('setApplicantIds-----'+setApplicantIds.size());
        set<string> setIncomeCategories = new set<string>();
        setIncomeCategories.add('Full Time - PAYG');
        setIncomeCategories.add('Self Employed');
        setIncomeCategories.add('Basic Living Expense');
        map<string,string> mapUsrIdToUsrInputType = new map<string,string>();
      
        system.debug('setIncomeCategories'+setIncomeCategories);
        list<Financials_Source__c> lstFinanceSources = [select id,Amount__c,Income_And_Expense__r.Applicant__c,createdbyId,Income_And_Expense__r.Category__c,Source__c from Financials_Source__c 
                                                        where Income_And_Expense__c != null AND Income_And_Expense__r.Applicant__c IN:setApplicantIds AND Income_And_Expense__r.Category__c IN:setIncomeCategories];
        
        system.debug('lstFinanceSources----'+lstFinanceSources.size());
        if(lstFinanceSources != null && lstFinanceSources.size()>0)
        {
            for(Financials_Source__c objFinance : lstFinanceSources)
            {
                lstid.add(objFinance.createdbyid);
            }
            mapUsrIdToUsrInputType = ClickCommon.mapUserInputType(lstid);
            for(Financials_Source__c objFinance : lstFinanceSources)
            {
                if(mapAppIdToFSrc.get(objFinance.Income_And_Expense__r.Applicant__c) == null)
                {
                    mapAppIdToFSrc.put(objFinance.Income_And_Expense__r.Applicant__c,new list<Financials_Source__c>());
                }
                if(mapAppIdToFSrc.get(objFinance.Income_And_Expense__r.Applicant__c) != null)
                {
                    mapAppIdToFSrc.get(objFinance.Income_And_Expense__r.Applicant__c).add(objFinance);
                }
                if(mapIsFSCustomerInputExist.get(objFinance.Income_And_Expense__c) == null || mapIsFSCustomerInputExist.get(objFinance.Income_And_Expense__c) != true)
                    mapIsFSCustomerInputExist.put(objFinance.Income_And_Expense__c,false);
                if(mapIsFSCustomerInputExist.get(objFinance.Income_And_Expense__c) == false)
                {
                    if(objFinance.Source__c == 'Customer Input')
                    {
                        mapIsFSCustomerInputExist.put(objFinance.Income_And_Expense__c,true);
                    }
                }
            }           
        }
        
        for(click_Applicant__c objApplicant : (List<click_Applicant__c>) Trigger.new)
        {
            if(mapAppIdToFSrc != null && mapAppIdToFSrc.size()>0 && mapAppIdToFSrc.containsKey(objApplicant.id) == true)
            {
                if(mapAppIdToFSrc.get(objApplicant.id) != null && mapAppIdToFSrc.get(objApplicant.id).size()>0)
                {
                    list<Financials_Source__c> lstFinance = mapAppIdToFSrc.get(objApplicant.id);
                    //system.debug('!@#$%^test'+mapUsrIdToUsrInputType.get(lstFinance[0].createdById));
                    if(lstFinance != null && lstFinance.size()>0)
                    {
                        for(Financials_Source__c objFinance : lstFinance)
                        {
                            if(mapUsrIdToUsrInputType != null && mapUsrIdToUsrInputType.size()>0 && mapUsrIdToUsrInputType.get(objFinance.createdById) == 'Customer Input' && mapUsrIdToUsrInputType.get(objApplicant.lastmodifiedById) == 'Customer Input')
                            {
                                if(objFinance.Income_And_Expense__r.Category__c == 'Full Time - PAYG' && objApplicant.get(strIncomePAYGAPI) <> null)
                                {
                                    objFinance.Amount__c = double.valueof(objApplicant.get(strIncomePAYGAPI));
                                }
                                if(objFinance.Income_And_Expense__r.Category__c == 'Self Employed' && objApplicant.get(strIncomeSelfEmployedAPI) <> null)
                                {
                                    objFinance.Amount__c = double.valueof(objApplicant.get(strIncomeSelfEmployedAPI));
                                }
                                system.debug('!@#$test'+objFinance.Income_And_Expense__r.Category__c);
                                if(objFinance.Income_And_Expense__r.Category__c == 'Basic Living Expense' && objApplicant.get(strExpenseAPI) <> null)
                                {
                                    objFinance.Amount__c = double.valueof(objApplicant.get(strExpenseAPI));
                                }
                                lstFSrcTobeUpdate.add(objFinance);
                            }else if(mapUsrIdToUsrInputType != null && mapUsrIdToUsrInputType.size()>0 && mapUsrIdToUsrInputType.get(objFinance.createdById) != 'Customer Input' 
                                    && mapUsrIdToUsrInputType.get(objApplicant.lastmodifiedById) == 'Customer Input')
                                {
                                    Financials_Source__c objFinanceToInsert = new Financials_Source__c();
                                    if(objFinance.Income_And_Expense__r.Category__c == 'Full Time - PAYG' && objApplicant.get(strIncomePAYGAPI) <> null)
                                    {
                                        objFinanceToInsert.Amount__c = double.valueof(objApplicant.get(strIncomePAYGAPI));
                                        objFinanceToInsert.Source__c = 'Customer Input';
                                        objFinanceToInsert.Income_And_Expense__c = objFinance.Income_And_Expense__c;
                                    }
                                    if(objFinance.Income_And_Expense__r.Category__c == 'Self Employed' && objApplicant.get(strIncomeSelfEmployedAPI) <> null)
                                    {
                                        objFinanceToInsert.Amount__c = double.valueof(objApplicant.get(strIncomeSelfEmployedAPI));
                                        objFinanceToInsert.Source__c = 'Customer Input';
                                        objFinanceToInsert.Income_And_Expense__c = objFinance.Income_And_Expense__c;
                                    }
                                    system.debug('!@#$test'+objFinance.Income_And_Expense__r.Category__c);
                                    if(objFinance.Income_And_Expense__r.Category__c == 'Basic Living Expense' && objApplicant.get(strExpenseAPI) <> null)
                                    {
                                        objFinanceToInsert.Amount__c = double.valueof(objApplicant.get(strExpenseAPI));
                                        objFinanceToInsert.Source__c = 'Customer Input';
                                        objFinanceToInsert.Income_And_Expense__c = objFinance.Income_And_Expense__c;
                                    }  
                                    if(mapIsFSCustomerInputExist != null && mapIsFSCustomerInputExist.size()>0 && mapIsFSCustomerInputExist.get(objFinance.Income_And_Expense__c) == false)                                 
                                        lstFSrcTobeInsert.add(objFinanceToInsert);
                                }
                        }
                    }
                    
                }
            }
        }
        if(lstFSrcTobeUpdate != null && lstFSrcTobeUpdate.size()>0)
        {
            update lstFSrcTobeUpdate;
        }
        if(lstFSrcTobeInsert != null && lstFSrcTobeInsert.size()>0)
        {
            insert lstFSrcTobeInsert;
        }
    }
    //To create econsent record added by karthik on 03/06/2016
    public void createEconsentRecord()
    {
        List<E_Consent__c> lstEconsentTobeInsert = new List<E_Consent__c>();
        for(click_Applicant__c objApplicant : (List<click_Applicant__c>) Trigger.new) 
        {
            E_Consent__c objEconsent = new E_Consent__c();
            objEconsent.Applicant__c = objApplicant.id;
            lstEconsentTobeInsert.add(objEconsent);
        }       
        if(lstEconsentTobeInsert != null && !lstEconsentTobeInsert.isEmpty())
            insert lstEconsentTobeInsert;  
    }
    //To update econsent record
    public void updateEconsentStatus()
    {
        List<E_Consent__c> lstEconsentTobeUpdate = new List<E_Consent__c>();
        Set<id> setAppIds = new Set<id>();
        Set<id> setOppIds = new Set<id>();
        for(click_Applicant__c objApplicant : (List<click_Applicant__c>) Trigger.new) 
        {
            if(objApplicant.acfEconsent__c != trigger.oldMap.get(objApplicant.id).get('acfEconsent__c') && objApplicant.acfEconsent__c == 'I Consent')  
            {
                setAppIds.add(objApplicant.id);
                setOppIds.add(objApplicant.clickOpportunity__c);
                System.debug('12345set12345'+setAppIds);
            }
        } 
        //Econsent record      
        lstEconsentTobeUpdate = [select id,Consent_Completed__c,Applicant__c,Consent_Time_and_Date__c from E_Consent__c where Applicant__c IN:setAppIds];
        if(lstEconsentTobeUpdate != null && !lstEconsentTobeUpdate.isEmpty())
        {
            for(E_Consent__c objEconsent : lstEconsentTobeUpdate)
            {
                objEconsent.Consent_Completed__c = true;
                objEconsent.Consent_Time_and_Date__c = System.now();
            }
            update lstEconsentTobeUpdate;
        }
        //Required doc & task status     
        System.debug('@#setAppIds$%'+setAppIds);  
        list<Required_Document__c> lstRequiredDocsTobeUpdate = [select id,acfStatus__c,name,(select id,status from tasks__r limit 1)
                                                                from Required_Document__c where Click_Applicant__c IN:setAppIds];
         System.debug('12345set12345'+setAppIds);
         System.debug('1234'+lstRequiredDocsTobeUpdate);
        list<Task> lstTaskTobeupdate = new list<Task>();
        if(lstRequiredDocsTobeUpdate != null && !lstRequiredDocsTobeUpdate.isEmpty())
        {
            for(Required_Document__c objRequiredDoc : lstRequiredDocsTobeUpdate)
            {
                objRequiredDoc.acfStatus__c = 'Verified';
                if(objRequiredDoc.tasks__r!= null && objRequiredDoc.tasks__r.size()>0)
                {
                   task objTask = new Task(id= objRequiredDoc.tasks__r[0].id);
                   objTask.status = 'Completed';
                   lstTaskTobeupdate.add(objTask);
                }
            }
            update lstRequiredDocsTobeUpdate;
            if(lstTaskTobeupdate != null && lstTaskTobeupdate.size()>0)
            {
                update lstTaskTobeupdate;
            }
        }
    } 
 }