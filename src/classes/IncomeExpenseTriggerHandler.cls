/*
    This class is used handle Income&Expense Trigger logic
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla               05/05/2016                               1.0
    =============================================================================
*/
public class IncomeExpenseTriggerHandler extends TriggerHandler
{
    public override void afterInsert() 
    {
        list<Financials_Source__c> lstFinancialSource = new list<Financials_Source__c>();
        list<id> tempUserId = new list<id>();
        for(Income_And_Expense__c  objIncome : (list<Income_And_Expense__c>)trigger.new)
        {
            tempUserId.add(objIncome.CreatedById);
        }
        map<String,String> mapUser  =ClickCommon.mapUserInputType(tempUserId);
        map<string,string> mapUsrIdToUsrInputType = ClickCommon.mapUserInputType();
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