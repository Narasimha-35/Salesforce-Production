//Created by Himansu
//To add assets & Liabilities to current logged in user
public class WLAssetLiabilitiesControllerExtn {

    public WLAssetLiabilitiesControllerExtn(WLpostloginQuestionsControllerBeta controller) {

    }


    /*public WLAssetLiabilitiesControllerExtn(WLpostloginQuestionsControllerClone controller) {

    }


    public WLAssetLiabilitiesControllerExtn(WLpostloginQuestionsControllerBeta controller) {

    }*/

    
    public wrapperAssetLiabilities objwrapperAssetLiabilities {
        get;
        set;
    }
    
    Public string rowNumInvestment{get;set;}
    public string strSelectedParentType {
        get;
        set;
    }
    public string strSelectedChildType {
        get;
        set;
    }
    public map < string, boolean > mapIsTypeValuesExist {
        get;
        set;
    }
    public list < Asset_Liability_Statement__c > lstAssetsLiab;
    public List < Lead > lstLead;
    public String accountId;
    public Id LoggedInContact;
    public Id LoggedInLead;
    public string strErrMsg {
        get;
        set;
    }
    public boolean showErrMsg {
        get;
        set;
    }

    public Map < String, boolean > isMultipleMap {
        get;
        set;
    }
    public Map < String, List < Asset_And_Liability__c >> assLiabRecMap {
        get;
        set;
    }
    Public Map < String, integer > assRecNumMap {
        get;
        set;
    }
    Public Asset_And_Liability__c assetsObj;
    Public List < Asset_And_Liability__c > assliabList;
    
    
   
    public WLAssetLiabilitiesControllerExtn(WLpostloginQuestionsController controller) {
        assetsObj = new Asset_And_Liability__c();
        LoadAssetAndLiabilities();
        isMultipleMap = new Map < String, boolean > ();
        List < isMultipleAssetsLib__c > multipleList = isMultipleAssetsLib__c.getAll().values();
        for (isMultipleAssetsLib__c m: multipleList) {
            isMultipleMap.put(m.Name, m.isMultiple__c);
        }
        
        
    }
    public void LoadAssetAndLiabilities() {
        
        assliabList = new List < Asset_And_Liability__c > ();
        assRecNumMap = new Map < String, integer > ();
        assLiabRecMap = new Map < String, List < Asset_And_Liability__c >> ();
        strErrMsg = '';
        showErrMsg = false;
        objwrapperAssetLiabilities = new wrapperAssetLiabilities();
        mapIsTypeValuesExist = new map < string, boolean > ();
        LoggedInContact = ClickCommon.getCurrentLoggedInContactId(UserInfo.getUserId());
        LoggedInLead = ClickCommon.getCurrentLoggedInLeadId(UserInfo.getUserId());
        List < Contact > lstContact = [select Account.id from Contact where id = : LoggedInContact limit 1];
        system.debug('@@@@Ankit *****' + lstContact.size());
        lstLead = [select id, acfApproximately_how_much_is_your_house__c, acfLoan_Amount__c, recordtype.name from lead where id = : LoggedInLead];
        if (lstContact.size() > 0) {
            accountId = lstContact[0].AccountId;
            Schema.DescribeFieldResult assetFieldResult = Asset_Liability_Statement__c.acfAsset_Type__c.getDescribe();
            Schema.DescribeFieldResult liabFieldResult = Asset_Liability_Statement__c.acfLiability_Type__c.getDescribe();
            List < Schema.PicklistEntry > lstAssetPicklstValues = assetFieldResult.getPicklistValues();
            List < Schema.PicklistEntry > lstLiabPicklstValues = liabFieldResult.getPicklistValues();
            system.debug('@@@@karthik 47' + lstAssetPicklstValues + '====' + lstLiabPicklstValues);
            for (Schema.PicklistEntry objPV: lstAssetPicklstValues) {
                mapIsTypeValuesExist.put(objPV.getValue(), false);
                
            }
            for (Schema.PicklistEntry objPV: lstLiabPicklstValues) {
                mapIsTypeValuesExist.put(objPV.getValue(), false);
            }
            
            assliabList = [Select id, Value__c, RecordType.Name, Current_Balance__c, Limit__c,
                                        Desciption__c,Name, Primary_Purpose__c, Account__c 
                                        FROM Asset_And_Liability__c where Account__c = : accountId ORDER BY Order__c ASC];
            system.debug('####asss' + assliabList);
            
            assLiabRecMap.put('Asset Real Estate', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Asset Savings Account', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Asset Superannuation', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Asset Investment Savings', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Asset Other', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Liability Mortgage Loan', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Liability Credit Card', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Liability Personal Loan', new List < Asset_And_Liability__c > ());
            assLiabRecMap.put('Liability Other', new List < Asset_And_Liability__c > ());
            
            assRecNumMap.put('Asset Real Estate', 0);
            assRecNumMap.put('Asset Savings Account', 0);
            assRecNumMap.put('Asset Superannuation', 0);
            assRecNumMap.put('Asset Investment Savings', 0);
            assRecNumMap.put('Asset Other', 0);
            assRecNumMap.put('Liability Mortgage Loan', 0);
            assRecNumMap.put('Liability Credit Card', 0);
            assRecNumMap.put('Liability Personal Loan', 0);
            assRecNumMap.put('Liability Other', 0);

            if(assliabList.size() == 0){
                Asset_And_Liability__c aLiab = new Asset_And_Liability__c();
                aLiab.Primary_Purpose__c = 'Owner Occupied';
                assLiabRecMap.get('Asset Real Estate').add(aLiab);
                assLiabRecMap.get('Liability Mortgage Loan').add(aLiab);
            }
            
            
            for (Asset_And_Liability__c al: assliabList) {
                if (!assLiabRecMap.containsKey(al.RecordType.Name)) {
                    assLiabRecMap.put(al.RecordType.Name, new List < Asset_And_Liability__c > ());
                }
                string recName = al.RecordType.Name;
                if (!assRecNumMap.containsKey(recName)) {
                    assRecNumMap.put(recName, 0);
                }
                if (assRecNumMap.containsKey(recName) == true) {
                    if (al.Primary_Purpose__c != 'Owner Occupied')
                        assRecNumMap.put(recName, assRecNumMap.get(recName) + 1);
                }
                assLiabRecMap.get(recName).add(al);
            }
        }
    }
    
    public void updatedRecordValues() {

        system.debug('##hello'+assliabList);
        if(assliabList.size() > 0){
            String id = Apexpages.currentPage().getParameters().get('recName');
            objwrapperAssetLiabilities = new wrapperAssetLiabilities();
            objwrapperAssetLiabilities.strSelectedAsset = strSelectedChildType;
            assetsObj = [Select id, Value__c, RecordType.Name, Current_Balance__c, Limit__c,
                            Desciption__c,Name, Primary_Purpose__c, Institution__c, Account__c
                            FROM Asset_And_Liability__c where id = : id];
            
            if (assetsObj != null) {
                if (strSelectedChildType == 'Home' || strSelectedChildType == 'Investment Property' || strSelectedChildType == 'Cash' ||
                strSelectedChildType == 'Super' || strSelectedChildType == 'Investment' || strSelectedChildType == 'Other') {
                    objwrapperAssetLiabilities.strAmount = assetsObj.Value__c;
                    objwrapperAssetLiabilities.strDescription = assetsObj.Desciption__c;
                }
                if (strSelectedChildType == 'Home Mortgage' || strSelectedChildType == 'IP Mortgage' || strSelectedChildType == 'Personal Loan' ||
                strSelectedChildType == 'Credit Card' || strSelectedChildType == 'Others') {
                    objwrapperAssetLiabilities.strBalance = assetsObj.Current_Balance__c;
                    objwrapperAssetLiabilities.strLimit = assetsObj.Limit__c;
                    objwrapperAssetLiabilities.strOFI = assetsObj.Institution__c;
                }
            }
        }
        else{
            if(lstLead != null && lstLead.size()>0){
                objwrapperAssetLiabilities.strBalance = lstLead[0].acfLoan_Amount__c;
                objwrapperAssetLiabilities.strAmount = lstLead[0].acfApproximately_how_much_is_your_house__c;
               /* if (strSelectedChildType == 'Home'){
                    objwrapperAssetLiabilities.strAmount = lstLead[0].acfApproximately_how_much_is_your_house__c;
                }

                if (strSelectedChildType == 'Home Mortgage'){
                    objwrapperAssetLiabilities.strBalance = lstLead[0].acfLoan_Amount__c;
                }*/
            }
        }
    }
    
    public Pagereference assetaddMethod() {
        if (assetsObj == null) {
            assetsObj = new Asset_And_Liability__c();
            objwrapperAssetLiabilities = new wrapperAssetLiabilities();
        }

        Asset_And_Liability__c objAssetsLiabAsset = new Asset_And_Liability__c();
        Asset_And_Liability__c objAssetsLiabAssetLiab = new Asset_And_Liability__c();
        List<Asset_And_Liability__c> assetLiabListNew = new List<Asset_And_Liability__c>();
       // System.debug('###objLead'+lstLead[0]);
        if(assliabList.size() == 0 && lstLead != null && lstLead.size()>0 ){
            if(lstLead[0].acfApproximately_how_much_is_your_house__c != null)
                objAssetsLiabAsset.Value__c = objwrapperAssetLiabilities.strAmount;
                objAssetsLiabAsset.Desciption__c = objwrapperAssetLiabilities.strDescription;
                objAssetsLiabAsset.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
                objAssetsLiabAsset.Account__c = accountId;
                objAssetsLiabAsset.Primary_Purpose__c = 'Owner Occupied';
                objAssetsLiabAsset.Name = 'Asset Home';
                objAssetsLiabAsset.Type__c = 'Asset'; 
                assetLiabListNew.add(objAssetsLiabAsset);
            if(lstLead[0].acfLoan_Amount__c != null){
                objAssetsLiabAssetLiab.Current_Balance__c = objwrapperAssetLiabilities.strBalance;
                objAssetsLiabAssetLiab.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();
                objAssetsLiabAssetLiab.Account__c = accountId;
                objAssetsLiabAssetLiab.Limit__c = objwrapperAssetLiabilities.strLimit;
                objAssetsLiabAssetLiab.Primary_Purpose__c = 'Owner Occupied';
                objAssetsLiabAssetLiab.Name = 'Liabilities Mortgage Loan';
                objAssetsLiabAssetLiab.Type__c = 'Liability'; 
                assetLiabListNew.add(objAssetsLiabAssetLiab);
            }
        }

        if(assetLiabListNew.size() > 0)
            insert assetLiabListNew;

        if((assliabList.size() == 0 && strSelectedChildType != 'Home' && strSelectedChildType != 'Home Mortgage') || (assliabList.size() > 0)){
            if (objwrapperAssetLiabilities.strAmount > 0 || (objwrapperAssetLiabilities.strBalance > 0 && objwrapperAssetLiabilities.strLimit > 0)) {
                
                if (strSelectedChildType == 'Home') {
                    
                    assetsObj.Value__c = objwrapperAssetLiabilities.strAmount;
                    assetsObj.Desciption__c = objwrapperAssetLiabilities.strDescription;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
                    assetsObj.Primary_Purpose__c = 'Owner Occupied';
                    assetsObj.Account__c = accountId;
                    assetsObj.Name = 'Asset Home';
                    assetsObj.Type__c = 'Asset';
                }
                
                if (strSelectedChildType == 'Investment Property') {
                    assetsObj.Value__c = objwrapperAssetLiabilities.strAmount;
                    assetsObj.Desciption__c = objwrapperAssetLiabilities.strDescription;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
                    assetsObj.Primary_Purpose__c = 'Investment';
                    assetsObj.Account__c = accountId;
                    assetsObj.Type__c = 'Asset';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Asset Investment Property'+ String.valueOf(assRecNumMap.get('Asset Real Estate')+1);
                    }
                }
                
                if (strSelectedChildType == 'Cash') {
                    assetsObj.Value__c = objwrapperAssetLiabilities.strAmount;
                    assetsObj.Desciption__c = objwrapperAssetLiabilities.strDescription;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Savings Account').getRecordTypeId();
                    assetsObj.Account__c = accountId;
                    assetsObj.Type__c = 'Asset';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Asset Cash'+ String.valueOf(assRecNumMap.get('Asset Savings Account')+1);
                    }
                }
                
                if (strSelectedChildType == 'Super') {
                    assetsObj.Value__c = objwrapperAssetLiabilities.strAmount;
                    assetsObj.Desciption__c = objwrapperAssetLiabilities.strDescription;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Superannuation').getRecordTypeId();
                    assetsObj.Account__c = accountId;
                    assetsObj.Type__c = 'Asset';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Asset Super'+ String.valueOf(assRecNumMap.get('Asset Superannuation')+1);
                    }
                }
                
                if (strSelectedChildType == 'Investment') {
                    assetsObj.Value__c = objwrapperAssetLiabilities.strAmount;
                    assetsObj.Desciption__c = objwrapperAssetLiabilities.strDescription;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Investment Savings').getRecordTypeId();
                    assetsObj.Account__c = accountId;
                    assetsObj.Type__c = 'Asset';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Asset Investment'+ String.valueOf(assRecNumMap.get('Asset Investment Savings')+1);
                    }
                }
                
                if (strSelectedChildType == 'Other') {
                    assetsObj.Value__c = objwrapperAssetLiabilities.strAmount;
                    assetsObj.Desciption__c = objwrapperAssetLiabilities.strDescription;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Other').getRecordTypeId();
                    assetsObj.Account__c = accountId;
                    assetsObj.Type__c = 'Asset';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Asset Other'+ String.valueOf(assRecNumMap.get('Asset Other')+1);
                    }
                }
                
                if (strSelectedChildType == 'Home Mortgage') {
                    assetsObj.Current_Balance__c = objwrapperAssetLiabilities.strBalance;
                    assetsObj.Limit__c = objwrapperAssetLiabilities.strLimit;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();
                    assetsObj.Primary_Purpose__c = 'Owner Occupied';
                    assetsObj.Account__c = accountId;
                    assetsObj.Institution__c = objwrapperAssetLiabilities.strOFI;
                    assetsObj.Type__c = 'Liability';
                    assetsObj.Name = 'Liability Home Mortgage';
                }
                
                if (strSelectedChildType == 'IP Mortgage') {
                    assetsObj.Current_Balance__c = objwrapperAssetLiabilities.strBalance;
                    assetsObj.Limit__c = objwrapperAssetLiabilities.strLimit;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();
                    assetsObj.Primary_Purpose__c = 'Investment';
                    assetsObj.Institution__c = objwrapperAssetLiabilities.strOFI;
                    assetsObj.Account__c = accountId;
                    assetsObj.Type__c = 'Liability';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Liability IP Mortgage'+ String.valueOf(assRecNumMap.get('Liability Mortgage Loan')+1);
                    }
                }
                
                if (strSelectedChildType == 'Personal Loan') {
                    assetsObj.Current_Balance__c = objwrapperAssetLiabilities.strBalance;
                    assetsObj.Limit__c = objwrapperAssetLiabilities.strLimit;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Personal Loan').getRecordTypeId();
                    assetsObj.Account__c = accountId;
                    assetsObj.Institution__c = objwrapperAssetLiabilities.strOFI;
                    assetsObj.Type__c = 'Liability';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Liability Personal Loan'+ String.valueOf(assRecNumMap.get('Liability Personal Loan')+1);
                    }
                }
                if (strSelectedChildType == 'Credit Card') {
                    assetsObj.Current_Balance__c = objwrapperAssetLiabilities.strBalance;
                    assetsObj.Limit__c = objwrapperAssetLiabilities.strLimit;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Credit Card').getRecordTypeId();
                    assetsObj.Account__c = accountId;
                    assetsObj.Institution__c = objwrapperAssetLiabilities.strOFI;
                    assetsObj.Type__c = 'Liability';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Liability Credit Card'+ String.valueOf(assRecNumMap.get('Liability Credit Card')+1);
                    }
                }
                
                if (strSelectedChildType == 'Others') {
                    assetsObj.Current_Balance__c = objwrapperAssetLiabilities.strBalance;
                    assetsObj.Limit__c = objwrapperAssetLiabilities.strLimit;
                    assetsObj.RecordTypeId = Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Other').getRecordTypeId();
                    assetsObj.Account__c = accountId;
                    assetsObj.Institution__c = objwrapperAssetLiabilities.strOFI;
                    assetsObj.Type__c = 'Liability';
                    if (assetsObj.id == null){
                        assetsObj.Name = 'Liability Other'+ String.valueOf(assRecNumMap.get('Liability Other')+1);
                    }
                } 
            }

            else {
                strErrMsg = 'Please fill all required fields.';
                showErrMsg = true;
            }

            if (assetsObj.id == null) {
                insert assetsObj;
            } else if (assetsObj.id != null ) {
                update assetsObj;
            }

           /*else if(strSelectedChildType == 'Home' && assetLiabListNew[0].id !=null){
                assetsObj =  assetLiabListNew[0];
                update assetsObj;
            }

            else if(strSelectedChildType == 'Home Mortgage' && assetLiabListNew[1].id !=null){
                assetsObj =  assetLiabListNew[1];
                update assetsObj;
            }*/

            if (assetsObj.id != null && assetsObj.RecordTypeId == Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId() && assetsObj.Primary_Purpose__c == 'Investment') {
                if(assLiabRecMap.get('Asset Real Estate').size() > 1){
                    Asset_and_Liability_Link__c aLink = new Asset_and_Liability_Link__c();
                    aLink.Asset__c = assLiabRecMap.get('Asset Real Estate')[1].id;
                    aLink.Liabilities__c = assetsObj.id;
                    aLink.Name = [SELECT Name From Account where id =:accountId].Name +'-'+assLiabRecMap.get('Asset Real Estate')[1].Name+'-'+assetsObj.Name;
                    insert aLink;
                }
            }
        }

        if (assetLiabListNew.size() > 0 && assetLiabListNew[1].RecordTypeId == Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId() && assetLiabListNew[1].Primary_Purpose__c == 'Owner Occupied') {
            Asset_and_Liability_Link__c aLink = new Asset_and_Liability_Link__c();
            aLink.Asset__c = assetLiabListNew[0].id;
            aLink.Liabilities__c = assetLiabListNew[1].id;
            aLink.Name = [SELECT Name From Account where id =:accountId].Name +'-'+assetLiabListNew[0].Name+'-'+assetLiabListNew[1].Name;
            insert aLink;
        }

        LoadAssetAndLiabilities();
        return null;
    }
    public pagereference resetPopupMethod() {
        system.debug('@@@@' + strSelectedChildType + '====' + lstAssetsLiab);
        objwrapperAssetLiabilities = new wrapperAssetLiabilities();
        objwrapperAssetLiabilities.strSelectedAsset = strSelectedChildType;
        assetsObj = new Asset_And_Liability__c();

        return null;
    }

    public class WrapTypeAssetLiab{
        public decimal strValueAsset {
            get;
            set;
        }

        public decimal strBalanceLiab {
            get;
            set;
        }
    }
   
    public class wrapperAssetLiabilities {
        public string strAssetType {
            get;
            set;
        }
        public string strDescription {
            get;
            set;
        }
        Public string strSelectedAsset {
            get;
            set;
        }
        public decimal strAmount {
            get;
            set;
        }
        public string strLiabilityType {
            get;
            set;
        }
        public string strOFI {
            get;
            set;
        }
        public decimal strLimit {
            get;
            set;
        }
        public decimal strBalance {
            get;
            set;
        }
        public integer strMonthlyPayment {
            get;
            set;
        }
        public string StrAssetLiID {
            get;
            set;
        }
        public List < SelectOption > getAssetType() {
            List < SelectOption > option = new List < Selectoption > ();
            option.add(new selectOption('Home', 'Home'));
            option.add(new selectOption('Investment Property', 'Investment Property'));
            option.add(new selectOption('Cash', 'Cash'));
            option.add(new selectOption('Super', 'Super'));
            option.add(new selectOption('Investment', 'Investment'));
            option.add(new selectOption('Other', 'Other'));
            return option;
        }
        public List < SelectOption > getLiabilityType() {
            List < SelectOption > option = new List < Selectoption > ();
            option.add(new selectOption('Home Mortgage', 'Home Mortgage'));
            option.add(new selectOption('IP Mortgage', 'IP Mortgage'));
            option.add(new selectOption('Credit Card', 'Credit Card'));
            option.add(new selectOption('Personal Loan', 'Personal Loan'));
            option.add(new selectOption('Investment', 'Investment'));
            option.add(new selectOption('Others', 'Other'));
            return option;
        }
    }
}