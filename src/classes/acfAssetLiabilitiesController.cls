//Created by karthik
//To add assets & Liabilities to current logged in user
public class acfAssetLiabilitiesController 
{
    public wrapperAssetLiabilities objwrapperAssetLiabilities {get;set;}
    public string strSelectedParentType {get;set;}
    public string strSelectedChildType {get;set;} 
    public map<string,boolean> mapIsTypeValuesExist{get;set;}
    public list<Asset_Liability_Statement__c> lstAssetsLiab;
    public List<Lead> lstLead;
    public String accountId;
    public Id LoggedInContact;
    public Id LoggedInLead;
    public string strErrMsg {get;set;} 
    public boolean showErrMsg {get;set;}
    public list<wrapTypeNameToExist> lstwrapTypeNameToExist {get;set;}
    public acfAssetLiabilitiesController()
    {  
    }
    public acfAssetLiabilitiesController(acfpostloginQuestionsController controller) 
    { 
        LoadAssetAndLiabilities();  // added changes by karthik on 29-03-2015
    } 
    
    public void LoadAssetAndLiabilities()
    {
       strErrMsg = '';
       showErrMsg = false;
       objwrapperAssetLiabilities = new wrapperAssetLiabilities();
       mapIsTypeValuesExist = new map<string,boolean>();
       lstwrapTypeNameToExist = new list<wrapTypeNameToExist>();
       LoggedInContact = acfCommon.getCurrentLoggedInContactId(UserInfo.getUserId());
       LoggedInLead = acfCommon.getCurrentLoggedInLeadId(UserInfo.getUserId());
       List<Contact >lstContact = [select AccountId from Contact where id=:LoggedInContact  limit 1];
       lstLead = [select id,acfApproximately_how_much_is_your_house__c,acfLoan_Amount__c,recordtype.name from lead where id =: LoggedInLead];
       if(lstContact.size()>0)
       {
         accountId = lstContact[0].AccountId;   
         Schema.DescribeFieldResult assetFieldResult = Asset_Liability_Statement__c.acfAsset_Type__c.getDescribe(); 
         Schema.DescribeFieldResult liabFieldResult = Asset_Liability_Statement__c.acfLiability_Type__c.getDescribe(); 
         List<Schema.PicklistEntry> lstAssetPicklstValues = assetFieldResult.getPicklistValues();
         List<Schema.PicklistEntry> lstLiabPicklstValues = liabFieldResult.getPicklistValues(); 
         system.debug('@@@@karthik'+lstAssetPicklstValues+'===='+lstLiabPicklstValues);
         for(Schema.PicklistEntry objPV : lstAssetPicklstValues)
         {
               mapIsTypeValuesExist.put(objPV.getValue(),false);
               
         }
         for(Schema.PicklistEntry objPV : lstLiabPicklstValues)
         {
               mapIsTypeValuesExist.put(objPV.getValue(),false);
         }
         
         lstAssetsLiab = [select id,Home_Value_Amount__c,Home_Location__c,Location_Property_1__c,Property_1_Amount__c,Banking_Institution_Cash_Amount__c,Super_Amount__c,Other_Investments_1__c,Other_Investments_1_Amount__c,
                                                                acfOther_Asset_Value_Amount__c,Mortgage_on_Home_Amount__c,Location_Mortgage_on_Home__c,Location_Mortgage_1__c,Mortgage_1_Amount__c,Lender_Name_Loans_1__c,Loans_1_Amount__c,Other_Liabilities_1__c,
                                                                Other_Liabilities_1_Amount__c,Credit_Cards_Combined_Limit__c,Credit_Cards_Combined_Balance__c,Credit_Cards_Combined__c,acfIsCreatedByPortalUser__c,AL_Statement_Owner__c,Banking_Institution__c,  
                                                                acfCash_Description__c,acfSuperDescription__c,acfOther_Asset_Description__c,acfMortgage_on_Home_Limit__c,acfLoans_1_limit__c,acfOther_Liabilities_1_limit__c,acfProperty_1_limit__c,
                                                                clickLoans_2_Limit__c,clickLoans_3_limit__c,clickLocation_Mortgage_3__c,clickProperty_2_limit__c,clickMortgage_3_Amount__c,clickProperty_3_limit__c,clickOther_Liabilities_2_Limit__c,Property_2_Amount__c,
                                                                clickOther_Liabilities_3_limit__c,Property_3_Amount__c,Other_Investments_2_Amount__c,Other_Liabilities_3__c,Mortgage_2_Amount__c,Loans_2_Amount__c,Loans_3_Amount__c,Other_Liabilities_2_Amount__c,Lender_name_Loans_2__c,
                                                                Location_Mortgage_2__c,Other_Investments_2__c,Location_Property_3__c,Location_Property_2__c,Lender_Name_Loans_3__c,Other_Liabilities_3_Amount__c,Other_Liabilities_2__c from Asset_Liability_Statement__c  where AL_Statement_Owner__c=:accountId AND acfIsCreatedByPortalUser__c = true limit 1];
                                                               
         If(lstAssetsLiab != null && lstAssetsLiab.size()>0)
         {
            Asset_Liability_Statement__c objAssetLiab = lstAssetsLiab[0];
            if(objAssetLiab.Home_Value_Amount__c != null && objAssetLiab.Home_Value_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Home',true);
            }
            if(objAssetLiab.Property_1_Amount__c != null && objAssetLiab.Property_1_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Investment Property1',true);
            }
            if(objAssetLiab.Property_2_Amount__c != null && objAssetLiab.Property_2_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Investment Property2',true);
            }
            if(objAssetLiab.Property_3_Amount__c != null && objAssetLiab.Property_3_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Investment Property3',true);
            }
            if(objAssetLiab.Banking_Institution_Cash_Amount__c != null && objAssetLiab.Banking_Institution_Cash_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Cash',true);
            }
            if(objAssetLiab.Super_Amount__c != null && objAssetLiab.Super_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Super',true);
            }
            if(objAssetLiab.Other_Investments_1_Amount__c != null && objAssetLiab.Other_Investments_1_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Investment1',true);
            }
            if(objAssetLiab.Other_Investments_2_Amount__c != null && objAssetLiab.Other_Investments_2_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Investment2',true);
            }
            if(objAssetLiab.acfOther_Asset_Value_Amount__c != null && objAssetLiab.acfOther_Asset_Value_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Other',true);
            }
            if(objAssetLiab.Mortgage_on_Home_Amount__c != null && objAssetLiab.Mortgage_on_Home_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Home Mortgage',true);
            }
            if(objAssetLiab.Mortgage_1_Amount__c != null && objAssetLiab.Mortgage_1_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('IP Mortgage1',true);
            }
            if(objAssetLiab.Mortgage_2_Amount__c != null && objAssetLiab.Mortgage_2_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('IP Mortgage2',true);
            }
            if(objAssetLiab.clickMortgage_3_Amount__c != null && objAssetLiab.clickMortgage_3_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('IP Mortgage3',true);
            }
            if(objAssetLiab.Loans_1_Amount__c != null && objAssetLiab.Loans_1_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Personal Loan1',true);
            }
            if(objAssetLiab.Loans_2_Amount__c != null && objAssetLiab.Loans_2_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Personal Loan2',true);
            } 
            if(objAssetLiab.Loans_3_Amount__c != null && objAssetLiab.Loans_3_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Personal Loan3',true);
            }
            if(objAssetLiab.Other_Liabilities_1_Amount__c != null && objAssetLiab.Other_Liabilities_1_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Others1',true);
            } 
            if(objAssetLiab.Other_Liabilities_2_Amount__c != null && objAssetLiab.Other_Liabilities_2_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Others2',true);
            }
            if(objAssetLiab.Other_Liabilities_3_Amount__c != null && objAssetLiab.Other_Liabilities_3_Amount__c <> 0)
            {
                mapIsTypeValuesExist.put('Others3',true);
            }
            if(objAssetLiab.Credit_Cards_Combined_Balance__c != null && objAssetLiab.Credit_Cards_Combined_Balance__c <> 0)
            {
                mapIsTypeValuesExist.put('Credit Card',true);
            }
            if(lstLead != null && lstLead.size()>0)
            {
                if(objAssetLiab.Home_Value_Amount__c == null && lstLead[0].acfApproximately_how_much_is_your_house__c != null)
                {
                    mapIsTypeValuesExist.put('Home',true);
                }
                if(objAssetLiab.Mortgage_on_Home_Amount__c == null && lstLead[0].acfLoan_Amount__c != null)
                {
                    mapIsTypeValuesExist.put('Home Mortgage',true);
                }
            }
         }else{
               If(lstLead != null && lstLead.size()>0)
                {
                    if(lstLead[0].acfApproximately_how_much_is_your_house__c != null)
                       mapIsTypeValuesExist.put('Home',true);     
                    if(lstLead[0].acfLoan_Amount__c != null)
                           mapIsTypeValuesExist.put('Home Mortgage',true);
                }
              }
         } 
         
      /*   for(string strTypename : mapIsTypeValuesExist.keyset())
         {
                wrapTypeNameToExist objwrapTypeNameToExist = new wrapTypeNameToExist();
                objwrapTypeNameToExist.typeValueName = strTypename;
                objwrapTypeNameToExist.isTypeValueExist = mapIsTypeValuesExist.get(strTypename);
                if(strTypename == 'Home')
                {
                        objwrapTypeNameToExist.typeImageClass = 'home'; 
                        objwrapTypeNameToExist.isAssetType = true;
                }
                if(strTypename == 'Investment Property1' || strTypename == 'Investment Property2' || strTypename == 'Investment Property3')
                {
                        objwrapTypeNameToExist.typeImageClass = 'invstment';
                        objwrapTypeNameToExist.isAssetType = true;
                }
                if(strTypename == 'Cash')
                {
                        objwrapTypeNameToExist.typeImageClass = 'cash';
                        objwrapTypeNameToExist.isAssetType = true;
                }
                if(strTypename == 'Super')
                {
                        objwrapTypeNameToExist.typeImageClass = 'super';
                        objwrapTypeNameToExist.isAssetType = true;
                }
                if(strTypename == 'Investment1' || strTypename == 'Investment2')
                {
                        objwrapTypeNameToExist.typeImageClass = 'invstmnt_2';
                        objwrapTypeNameToExist.isAssetType = true;
                }
                if(strTypename == 'Other')
                {
                        objwrapTypeNameToExist.typeImageClass = 'other';
                        objwrapTypeNameToExist.isAssetType = true;
                }
                if(strTypename == 'Home Mortgage')
                {
                        objwrapTypeNameToExist.typeImageClass = 'home_mortage';
                        objwrapTypeNameToExist.isAssetType = false;
                }
                if(strTypename == 'IP Mortgage1' || strTypename == 'IP Mortgage2' || strTypename == 'IP Mortgage3')
                {
                        objwrapTypeNameToExist.typeImageClass = 'ip_mortage';
                        objwrapTypeNameToExist.isAssetType = false;
                }
                if(strTypename == 'Personal Loan1' || strTypename == 'Personal Loan2' || strTypename == 'Personal Loan3')
                {
                        objwrapTypeNameToExist.typeImageClass = 'pers_loan';
                        objwrapTypeNameToExist.isAssetType = false;
                }
                if(strTypename == 'Credit Card')
                {
                        objwrapTypeNameToExist.typeImageClass = 'crdt_card';
                        objwrapTypeNameToExist.isAssetType = false;
                }
                if(strTypename == 'liab_other')
                {
                        objwrapTypeNameToExist.typeImageClass = 'liab_other';
                        objwrapTypeNameToExist.isAssetType = false;
                }
                lstwrapTypeNameToExist.add(objwrapTypeNameToExist);
         }*/
         
       system.debug('@@@@@@@karthik'+mapIsTypeValuesExist); 
   } 
   public Pagereference assetaddMethod()
   {     
      Asset_Liability_Statement__c objUpdateAssetsLiab = new Asset_Liability_Statement__c();
      if(objwrapperAssetLiabilities.strAmount != null || (objwrapperAssetLiabilities.strBalance != null && objwrapperAssetLiabilities.strLimit != null))
      {   
            if(strSelectedChildType == 'Home')
            {
                
                objUpdateAssetsLiab.Home_Value_Amount__c = objwrapperAssetLiabilities.strAmount;
                objUpdateAssetsLiab.Home_Location__c = objwrapperAssetLiabilities.strDescription;
            }
            if(strSelectedChildType == 'Investment Property1')
            {
                objUpdateAssetsLiab.Property_1_Amount__c = objwrapperAssetLiabilities.strAmount;
                objUpdateAssetsLiab.Location_Property_1__c = objwrapperAssetLiabilities.strDescription;
            }
            if(strSelectedChildType == 'Investment Property2')
            {
                objUpdateAssetsLiab.Property_2_Amount__c = objwrapperAssetLiabilities.strAmount;
                objUpdateAssetsLiab.Location_Property_2__c = objwrapperAssetLiabilities.strDescription;
            }
            if(strSelectedChildType == 'Investment Property3')
            {
                objUpdateAssetsLiab.Property_3_Amount__c = objwrapperAssetLiabilities.strAmount;
                objUpdateAssetsLiab.Location_Property_3__c = objwrapperAssetLiabilities.strDescription;
            }            
            if(strSelectedChildType == 'Cash')
            {
                objUpdateAssetsLiab.Banking_Institution_Cash_Amount__c = objwrapperAssetLiabilities.strAmount;
                ObjUpdateAssetsLiab.acfCash_Description__c = objwrapperAssetLiabilities.strDescription;
              
            }
            if(strSelectedChildType == 'Super')
            {
                objUpdateAssetsLiab.Super_Amount__c = objwrapperAssetLiabilities.strAmount; 
                objUpdateAssetsLiab.acfSuperDescription__c = objwrapperAssetLiabilities.strDescription;
            }
            if(strSelectedChildType == 'Investment1')
            {
                objUpdateAssetsLiab.Other_Investments_1_Amount__c = objwrapperAssetLiabilities.strAmount;
                objUpdateAssetsLiab.Other_Investments_1__c = objwrapperAssetLiabilities.strDescription;
            }
            if(strSelectedChildType == 'Investment2')
            {
                objUpdateAssetsLiab.Other_Investments_2_Amount__c = objwrapperAssetLiabilities.strAmount;
                objUpdateAssetsLiab.Other_Investments_2__c = objwrapperAssetLiabilities.strDescription;
            }
            if(strSelectedChildType == 'Other')
            {
                 objUpdateAssetsLiab.acfOther_Asset_Value_Amount__c = objwrapperAssetLiabilities.strAmount;
                 objUpdateAssetsLiab.acfOther_Asset_Description__c = objwrapperAssetLiabilities.strDescription;
            }
            if(strSelectedChildType == 'Home Mortgage')
            {
                objUpdateAssetsLiab.Mortgage_on_Home_Amount__c = objwrapperAssetLiabilities.strBalance ;
                objUpdateAssetsLiab.acfMortgage_on_Home_Limit__c = objwrapperAssetLiabilities.strLimit;
                objUpdateAssetsLiab.Location_Mortgage_on_Home__c = objwrapperAssetLiabilities.strOFI;
            }
            if(strSelectedChildType == 'IP Mortgage1')
            {
                objUpdateAssetsLiab.Mortgage_1_Amount__c = objwrapperAssetLiabilities.strBalance ;
                objUpdateAssetsLiab.Location_Mortgage_1__c = objwrapperAssetLiabilities.strOFI;
                objUpdateAssetsLiab.acfProperty_1_limit__c = objwrapperAssetLiabilities.strLimit;
            }
           if(strSelectedChildType == 'IP Mortgage2')
            {
                objUpdateAssetsLiab.Mortgage_2_Amount__c = objwrapperAssetLiabilities.strBalance ;
                objUpdateAssetsLiab.Location_Mortgage_2__c = objwrapperAssetLiabilities.strOFI;
                objUpdateAssetsLiab.clickProperty_2_limit__c = objwrapperAssetLiabilities.strLimit;
            }
           if(strSelectedChildType == 'IP Mortgage3')
            {
                objUpdateAssetsLiab.clickMortgage_3_Amount__c = objwrapperAssetLiabilities.strBalance ;
                objUpdateAssetsLiab.clickLocation_Mortgage_3__c = objwrapperAssetLiabilities.strOFI;
                objUpdateAssetsLiab.clickProperty_3_limit__c = objwrapperAssetLiabilities.strLimit;
            }
         
            if(strSelectedChildType == 'Personal Loan1')
            {
                objUpdateAssetsLiab.Loans_1_Amount__c = objwrapperAssetLiabilities.strBalance;
                objUpdateAssetsLiab.Lender_Name_Loans_1__c = objwrapperAssetLiabilities.strOFI; 
                objUpdateAssetsLiab.acfLoans_1_limit__c = objwrapperAssetLiabilities.strLimit;
            }
             if(strSelectedChildType == 'Personal Loan2')
            {
                objUpdateAssetsLiab.Loans_2_Amount__c = objwrapperAssetLiabilities.strBalance;
                objUpdateAssetsLiab.Lender_name_Loans_2__c = objwrapperAssetLiabilities.strOFI; 
                objUpdateAssetsLiab.clickLoans_2_Limit__c = objwrapperAssetLiabilities.strLimit;
            }
            if(strSelectedChildType == 'Personal Loan3')
            {
                objUpdateAssetsLiab.Loans_3_Amount__c = objwrapperAssetLiabilities.strBalance;
                objUpdateAssetsLiab.Lender_Name_Loans_3__c = objwrapperAssetLiabilities.strOFI; 
                objUpdateAssetsLiab.clickLoans_3_limit__c = objwrapperAssetLiabilities.strLimit;
            }           
            if(strSelectedChildType == 'Others1')
            {
               objUpdateAssetsLiab.Other_Liabilities_1_Amount__c = objwrapperAssetLiabilities.strBalance;
               objUpdateAssetsLiab.Other_Liabilities_1__c = objwrapperAssetLiabilities.strOFI;
               objUpdateAssetsLiab.acfOther_Liabilities_1_limit__c = objwrapperAssetLiabilities.strLimit;
            } 
            if(strSelectedChildType == 'Others2')
            {
               objUpdateAssetsLiab.Other_Liabilities_2_Amount__c = objwrapperAssetLiabilities.strBalance;
               objUpdateAssetsLiab.Other_Liabilities_2__c = objwrapperAssetLiabilities.strOFI;
               objUpdateAssetsLiab.clickOther_Liabilities_2_Limit__c = objwrapperAssetLiabilities.strLimit;
            }  
            if(strSelectedChildType == 'Others3')
            {
               objUpdateAssetsLiab.Other_Liabilities_3_Amount__c = objwrapperAssetLiabilities.strBalance;
               objUpdateAssetsLiab.Other_Liabilities_3__c = objwrapperAssetLiabilities.strOFI;
               objUpdateAssetsLiab.clickOther_Liabilities_3_limit__c = objwrapperAssetLiabilities.strLimit;
            }   
            if(strSelectedChildType == 'Credit Card')
            {
               objUpdateAssetsLiab.Credit_Cards_Combined_Balance__c = objwrapperAssetLiabilities.strBalance;
               objUpdateAssetsLiab.Credit_Cards_Combined__c = objwrapperAssetLiabilities.strOFI;
               objUpdateAssetsLiab.Credit_Cards_Combined_Limit__c = objwrapperAssetLiabilities.strLimit;
            } 
            if(lstAssetsLiab != null && lstAssetsLiab.size()>0)
            {
                objUpdateAssetsLiab.id = lstAssetsLiab[0].id;
                update objUpdateAssetsLiab;
            }else if(objUpdateAssetsLiab != null){
                    objUpdateAssetsLiab.acfIsCreatedByPortalUser__c = true;
                    objUpdateAssetsLiab.AL_Statement_Owner__c = accountId;
                    insert objUpdateAssetsLiab;
                }
         LoadAssetAndLiabilities(); 
      }else{
            strErrMsg = 'Please fill all required fields.';
            showErrMsg = true;
         }
         return null;   
    }    
    public pagereference resetPopupMethod ()
    {
        system.debug('@@@@'+strSelectedChildType + '====' +lstAssetsLiab);
        objwrapperAssetLiabilities = new wrapperAssetLiabilities();
        objwrapperAssetLiabilities.strSelectedAsset = strSelectedChildType;
         If(lstAssetsLiab != null && lstAssetsLiab.size()>0)
         {
            Asset_Liability_Statement__c objAssetLiab = lstAssetsLiab[0];
            if(strSelectedChildType == 'Home' && objAssetLiab.Home_Value_Amount__c != null)
            {
              
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Home_Value_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.Home_Location__c;
            }
            if(strSelectedChildType == 'Investment Property1' && objAssetLiab.Property_1_Amount__c != null)
            {
               
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Property_1_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.Location_Property_1__c;
            }
            if(strSelectedChildType == 'Investment Property2' && objAssetLiab.Property_2_Amount__c != null)
            {
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Property_2_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.Location_Property_2__c;
            }
            if(strSelectedChildType == 'Investment Property3' && objAssetLiab.Property_3_Amount__c != null)
            {
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Property_3_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.Location_Property_3__c;
            }
            if(strSelectedChildType == 'Cash' && objAssetLiab.Banking_Institution_Cash_Amount__c != null)
            {
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Banking_Institution_Cash_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.acfCash_Description__c;
            }
            if(strSelectedChildType == 'Super' && objAssetLiab.Super_Amount__c != null)
            {
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Super_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.acfSuperDescription__c;
            }
            if(strSelectedChildType == 'Investment1' && objAssetLiab.Other_Investments_1_Amount__c != null)
            {
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Other_Investments_1_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.Other_Investments_1__c;
            }
            if(strSelectedChildType == 'Investment2' && objAssetLiab.Other_Investments_2_Amount__c != null)
            {
                objwrapperAssetLiabilities.strAmount = objAssetLiab.Other_Investments_2_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.Other_Investments_2__c;
            }
            if(strSelectedChildType == 'Other' && objAssetLiab.acfOther_Asset_Value_Amount__c != null)
            {
                objwrapperAssetLiabilities.strAmount = objAssetLiab.acfOther_Asset_Value_Amount__c;
                objwrapperAssetLiabilities.strDescription = objAssetLiab.acfOther_Asset_Description__c;
            }
            if(strSelectedChildType == 'Home Mortgage' && objAssetLiab.Mortgage_on_Home_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.Mortgage_on_Home_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Location_Mortgage_on_Home__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.acfMortgage_on_Home_Limit__c;
            }
            if(strSelectedChildType == 'IP Mortgage1' && objAssetLiab.Mortgage_1_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.Mortgage_1_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Location_Mortgage_1__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.acfProperty_1_limit__c;
            }
            if(strSelectedChildType == 'IP Mortgage2' && objAssetLiab.Mortgage_2_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.Mortgage_2_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Location_Mortgage_2__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.clickProperty_2_limit__c;
            }
            
            if(strSelectedChildType == 'IP Mortgage3' && objAssetLiab.clickMortgage_3_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.clickMortgage_3_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.clickLocation_Mortgage_3__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.clickProperty_3_limit__c;
            }
            
            if(strSelectedChildType == 'Personal Loan1' && objAssetLiab.Loans_1_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance =  objAssetLiab.Loans_1_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Lender_Name_Loans_1__c; 
                objwrapperAssetLiabilities.strLimit = objAssetLiab.acfLoans_1_limit__c;   
            }

            if(strSelectedChildType == 'Personal Loan2' && objAssetLiab.Loans_2_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance =  objAssetLiab.Loans_2_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Lender_Name_Loans_2__c; 
                objwrapperAssetLiabilities.strLimit = objAssetLiab.clickLoans_2_limit__c;   
            }
            
            if(strSelectedChildType == 'Personal Loan3' && objAssetLiab.Loans_3_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance =  objAssetLiab.Loans_3_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Lender_Name_Loans_3__c; 
                objwrapperAssetLiabilities.strLimit = objAssetLiab.clickLoans_3_limit__c;   
            }            
            if(strSelectedChildType == 'Others1' && objAssetLiab.Other_Liabilities_1_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.Other_Liabilities_1_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Other_Liabilities_1__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.acfOther_Liabilities_1_limit__c;
            }
            
            if(strSelectedChildType == 'Others2' && objAssetLiab.Other_Liabilities_2_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.Other_Liabilities_2_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Other_Liabilities_2__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.clickOther_Liabilities_2_limit__c;
            }
            
            if(strSelectedChildType == 'Others3' && objAssetLiab.Other_Liabilities_3_Amount__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.Other_Liabilities_3_Amount__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Other_Liabilities_3__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.clickOther_Liabilities_3_limit__c;
            }
             
            if(strSelectedChildType == 'Credit Card' && objAssetLiab.Credit_Cards_Combined_Balance__c != null)
            {
                objwrapperAssetLiabilities.strBalance = objAssetLiab.Credit_Cards_Combined_Balance__c;
                objwrapperAssetLiabilities.strOFI = objAssetLiab.Credit_Cards_Combined__c;
                objwrapperAssetLiabilities.strLimit = objAssetLiab.Credit_Cards_Combined_Limit__c;
            }
            if(lstLead != null && lstLead.size()>0)
            {
                if(objAssetLiab.Home_Value_Amount__c == null && strSelectedChildType == 'Home' && lstLead[0].acfApproximately_how_much_is_your_house__c != null)
                {
                    objwrapperAssetLiabilities.strAmount = Integer.valueof(lstLead[0].acfApproximately_how_much_is_your_house__c); 
                }
                if(objAssetLiab.Mortgage_on_Home_Amount__c == null &&strSelectedChildType == 'Home Mortgage' && lstLead[0].acfLoan_Amount__c != null)
                {
                    objwrapperAssetLiabilities.strBalance = Integer.valueof(lstLead[0].acfLoan_Amount__c); 
                }
             }
          }else{
                   If(lstLead != null && lstLead.size()>0)
                   {
                    if(strSelectedChildType == 'Home' && lstLead[0].acfApproximately_how_much_is_your_house__c != null)
                       objwrapperAssetLiabilities.strAmount = Integer.valueof(lstLead[0].acfApproximately_how_much_is_your_house__c);       
                    if(strSelectedChildType == 'Home Mortgage' && lstLead[0].acfLoan_Amount__c != null)
                           objwrapperAssetLiabilities.strBalance = Integer.valueof(lstLead[0].acfLoan_Amount__c); 
                   }
              } 
        return null;
    }
    public class wrapTypeNameToExist
    {
        public boolean isTypeValueExist{get;set;}
        public string typeValueName {get;set;}
        public string typeImageClass {get;set;}
        public boolean isAssetType {get;set;}
        public integer intSequanceNo {get;set;}
    }
    public class wrapperAssetLiabilities
    {
       public string strAssetType{get;set;}
       public string strDescription{get;set;}
       Public string strSelectedAsset{get;set;}
       public decimal strAmount{get;set;}
       public string strLiabilityType {get;set;}
       public string strOFI {get;set;}
       public decimal strLimit {get;set;}
       public decimal strBalance {get;set;}
       public integer strMonthlyPayment {get;set;}
       public string StrAssetLiID{get;set;}
       public List<SelectOption>getAssetType()
       {
           List<SelectOption> option = new List<Selectoption>();  
           option.add(new selectOption('Home','Home'));
           option.add(new selectOption('Investment Property1','Investment Property'));
           option.add(new selectOption('Investment Property2','Investment Property'));
           option.add(new selectOption('Investment Property3','Investment Property'));
           option.add(new selectOption('Cash','Cash'));
           option.add(new selectOption('Super','Super'));
           option.add(new selectOption('Investment1','Investment'));
           option.add(new selectOption('Investment2','Investment'));
           option.add(new selectOption('Other','Other'));
           return option ;
       }
       public List<SelectOption> getLiabilityType()
       {
           List<SelectOption> option = new List<Selectoption>();
           option.add(new selectOption('Home Mortgage','Home Mortgage'));
           option.add(new selectOption('IP Mortgage1','IP Mortgage'));
           option.add(new selectOption('IP Mortgage2','IP Mortgage'));
           option.add(new selectOption('IP Mortgage3','IP Mortgage'));
           option.add(new selectOption('Credit Card','Credit Card'));
           option.add(new selectOption('Personal Loan1','Personal Loan'));
           option.add(new selectOption('Personal Loan2','Personal Loan'));
           option.add(new selectOption('Personal Loan3','Personal Loan'));
           option.add(new selectOption('Investment','Investment'));
           option.add(new selectOption('Others1','Other'));
           option.add(new selectOption('Others2','Other'));
           option.add(new selectOption('Others3','Other'));
           return option;
       }
     }
}