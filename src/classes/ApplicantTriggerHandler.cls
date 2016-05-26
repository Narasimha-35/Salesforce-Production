/*
    This class is used handle Applicant Trigger logic
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla               04/05/2016                              1.0
    =============================================================================
*/
public class ApplicantTriggerHandler extends TriggerHandler
{
    string strIncomeSelfEmployedAPI = system.label.acfIncome_SelfEmployed_API;
    string strIncomePAYGAPI = system.label.acfIncome_PAYG_API;
    string strExpenseAPI = system.label.acfExpense_API;
    public override void afterInsert() 
    {
        insertIncomeExpenses();
    }
    public override void afterUpdate()
    {
        insertIncomeExpenses();
        updateFinancialSources();
    }
    //create income and expense records
    public void insertIncomeExpenses()
    {
    system.debug('strIncomeSelfEmployedAPI-----'+strIncomeSelfEmployedAPI +'strExpenseAPI------' +strExpenseAPI);
    
        list<Income_And_Expense__c> lstIncomeExpense = new list<Income_And_Expense__c>();
        list<Financials_Source__c> lstFinanceSource = new list<Financials_Source__c>();
        Id IncomeRecTypeId = ClickCommon.GetRecordTypeId('Income_And_Expense__c','Income');
        Id ExpenseRecTypeId = ClickCommon.GetRecordTypeId('Income_And_Expense__c','Expense');
        for(click_Applicant__c objApplicant : (List<click_Applicant__c>) Trigger.new) 
        {
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
        system.debug('!!@#$test'+lstIncomeExpense);
        if(lstIncomeExpense != null && lstIncomeExpense.size()>0)
        {
            insert lstIncomeExpense;                       
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
        
        set<string> setIncomeCategories = new set<string>();
        setIncomeCategories.add('Full Time - PAYG');
        setIncomeCategories.add('Self Employed');
        setIncomeCategories.add('Basic Living Expense');
        map<string,string> mapUsrIdToUsrInputType = new map<string,string>();
        system.debug('Income_And_Expense__c ' + Financials_Source__c.Income_And_Expense__c + ' ' + setApplicantIds +' '+ setIncomeCategories);        
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
}