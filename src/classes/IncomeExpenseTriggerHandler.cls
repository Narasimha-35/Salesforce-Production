/*
    This class is used handle Income&Expense Trigger logic
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla               05/05/2016                            1.0
    =============================================================================
*/
public class IncomeExpenseTriggerHandler extends TriggerHandler
{
    public override void afterInsert() 
    {
        list<Financials_Source__c> lstFinancialSource = new list<Financials_Source__c>();
        list<string> lstUserIds = new list<string>();
        for(Income_And_Expense__c objIncome : (List<Income_And_Expense__c>) trigger.new)
        {
            lstUserIds.add(objIncome.createdbyid);
        }
        map<string,string> mapUsrIdToUsrInputType = ClickCommon.mapUserInputType(lstUserIds);
        string strUserType = '';
        //create financial records
        for(Income_And_Expense__c objIncome : (List<Income_And_Expense__c>) trigger.new)
        {
            Financials_Source__c objFinance = new Financials_Source__c();
            objFinance.Amount__c = objIncome.Amount__c;
            objFinance.Income_And_Expense__c = objIncome.id;
            if(mapUsrIdToUsrInputType != null && mapUsrIdToUsrInputType.size()>0)
            {
                strUserType = mapUsrIdToUsrInputType.get(objIncome.createdById);
                if(strUserType <> null && strUserType <> '')
                {
                    objFinance.Source__c = strUserType;
                }
            }
            lstFinancialSource.add(objFinance);
        }
        if(lstFinancialSource != null && lstFinancialSource.size()>0)
        {
            insert lstFinancialSource;
        }
    }
}