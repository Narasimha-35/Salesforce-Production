public class GlobalDealIQRulecontrollerExtn {
 public String selectedVal {get;set;}
 public String selectBank {get;set;}
 public String sendCategory {get;set;}
 public String nameObject {get;set;}
 public String nameField {get;set;}
 public String operatorName {get;set;}
 public String doc {get;set;}
 public boolean reqdoc {get;set;}
 public boolean isActive{get;set;}
 public List < Integer > counterId {get;set;}
 public string name {get;set;}
 public string expressionValue{get;set;}
 public string description {get;set;}
 public String title{get;set;}
 public List < Integer > counterId1 { get;set;}
 //Public List<WrapperObject> lstWrapOuter {get;set;}
 public List <wrapperAddRow> lstwrap {get;set;}
// Public Map<Integer,WrapperObject> outerWrapMap{get;set;}
 public list<Outerwrapper> OuterwrapperList{get;set;}
 public Integer counter{get;set;}
 private Map<String,List<Global_DealIQ_Condition_Detail__c>> globalCondMap;
 private map<String,integer> objectOrderMap;
 Public List<BankWrapper> bankWrapperList{get;set;}
 public List<BankWrapper> lstSetController{get;set;}
 Public List<ProductBankWrapper> productBankWrapperList{get;set;}
 Public List<ProductBankWrapper> productBankWrapperListforPagination{get;set;}
 Public boolean isSaved{get;set;}
 Public boolean showBank{get;set;}
 string dealId;
 CustomIterable obj;
 CustomIterableforProduct productObj;
 private Global_DealIQ_Condition__c globalConObject;
 
    public GlobalDealIQRulecontrollerExtn ()
    {
        counter = 0;
        isActive = false;
        isSaved = false;
        OuterwrapperList = new list<Outerwrapper>();
        lstwrap  = new list<wrapperAddRow>();
        globalCondMap = new Map<String,List<Global_DealIQ_Condition_Detail__c>>();
        objectOrderMap = new map<String,integer>();
        showBank = false;
     
        List < SelectOption > optns = new List < Selectoption > ();
        List <SelectOption> options = new List < SelectOption > ();
       // outerWrapMap = new Map<Integer,WrapperObject>();
        dealId = apexpages.currentpage().getparameters().get('dealId');
        system.debug('###d'+dealId);
        lstSetController = new List<BankWrapper>();
        bankWrapperList = new List<BankWrapper>();
        for (acfBank_Detail__c obj: [select id,acfBank_Name__c from acfBank_Detail__c order by acfBank_Name__c ASC]){
            bankWrapperList.add(new BankWrapper(false,(String)obj.acfBank_Name__c,(String)obj.id));
        }
        
            obj = new CustomIterable (bankWrapperList); 
            obj.setPageSize = 10;
            next();   
        if(productBankWrapperList == null){
            productBankWrapperList = new List<ProductBankWrapper>();
            productBankWrapperListforPagination = new List<ProductBankWrapper>();
        }
        for(Product2 pro:[select id,name, Click_Loans_Bank_Detail__c,Click_Loans_Bank_Detail__r.acfBank_Name__c from product2 order by name ASC]){
            productBankWrapperList.add(new ProductBankWrapper(false,(String)pro.Click_Loans_Bank_Detail__r.acfBank_Name__c,(String)pro.name,(String)pro.id));
        }
        
        productObj =  new CustomIterableforProduct(productBankWrapperList);
         productObj.setPageSize = 10;
            nextProduct(); 
        System.debug('hhhjnjnnnnnnnnnn'+dealId);
        
        if(String.isNotEmpty(dealId))
        {
           List<Global_DealIQ_Condition__c> globalDetailList = [select id,name,Document_Master__c,Active__c,
                                                               acfRule_Description__c,Category__c,Object_Rule_Works_On__c,RecordRuleWorksOn__c,Req_Doc_Created__c FROM Global_DealIQ_Condition__c where Id=: dealId];
                                                               
           List<Global_DealIQ_Condition_Detail__c> globalConditionDetailList = [SELECT id,Order_Number__c,Global_Order_Number__c,acfField__c,acfGlobal_DealIQ_Rulea__c,
                                                                                   Object__c,acfOperator__c,acfValue__c 
                                                                                   FROM Global_DealIQ_Condition_Detail__c where acfGlobal_DealIQ_Rulea__c=:dealId];
                                                                                   
           for(Global_DealIQ_Condition_Detail__c gObject:globalConditionDetailList ){
               if(!globalCondMap.containsKey(gObject.Object__c)){
                    globalCondMap.put(gObject.Object__c,new List<Global_DealIQ_Condition_Detail__c>());
               }
               globalCondMap.get(gObject.Object__c).add(gObject);
               objectOrderMap.put(gObject.Object__c,(Integer)gObject.Global_Order_Number__c);
              
           }
           
          
           system.debug('##deatil'+globalCondMap);
           Set<String> selectedBankProductSet = new Set<String>();
           for(Global_DealIQ_Condition__c dObject:globalDetailList)
           {
               name = dObject.Name;
               isActive = dObject.Active__c;
               description = dObject.acfRule_Description__c;
               selectedVal = dObject.Object_Rule_Works_On__c;
               String[] selectedBankProductArray =  dObject.RecordRuleWorksOn__c.split(',');
               selectedBankProductSet.addAll(selectedBankProductArray);
               for(BankWrapper bw:bankWrapperList){
                   if(selectedBankProductSet.contains(bw.bankId)){
                       bw.selected = true;
                   }
               }
               
               for(ProductBankWrapper pbw:productBankWrapperList){
                   if(selectedBankProductSet.contains(pbw.productId)){
                       pbw.selected = true;
                   }
               }
               
               sendCategory= dObject.Category__c;
               reqdoc = dObject.Req_Doc_Created__c;
               doc = dObject.Document_Master__c;
           } 
        }
        
        //getobjectNames();
        //this.lstwrap =new List <wrapperAddRow>();
        //this.lstWrapOuter = new List<WrapperObject>();
        
        if(globalCondMap.values().size() == 0){
            wrapperAddRow objwraparow= new wrapperAddRow();
            objwraparow.nameField='--Field Name--';
            objwraparow.expressionValue= '';
            objwraparow.orderNo = 0;
            lstwrap.add(objwraparow);
            
            Outerwrapper wrapOuter = new Outerwrapper();
            wrapOuter.SObjectName = '--Object--';
            wrapOuter.counterWrap = 0;
            wrapOuter.objectNames = listObjectNames();
            wrapOuter.wrapObjectList = lstwrap;
            OuterwrapperList.add(wrapOuter);
        }
        
      
        
        //Global DealIq Detail View And Update
         if(globalCondMap !=null){
               for(String objectName:globalCondMap.KeySet()){
                  List<SelectOption> optnList = new List<SelectOption>();
                  Outerwrapper wrapOuterUpdate = new Outerwrapper();
                  lstwrap = new List<wrapperAddRow>(); 
                  system.debug('###obj'+objectName);
                  wrapOuterUpdate.objectNames = listObjectNames();
                  wrapOuterUpdate.SObjectName = objectName;
                  wrapOuterUpdate.counterWrap = objectOrderMap.get(objectName);
                  SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
                  Map < String, Schema.SObjectField > objFieldMap = objectType.getDescribe().fields.getMap();
                  for (Schema.SObjectField entry: objFieldMap.values()) {
                    optnList.add(new SelectOption(entry.getDescribe().getName(), entry.getDescribe().getLabel()));
                  }
                  for(Global_DealIQ_Condition_Detail__c detailObj:globalCondMap.get(objectName)){
                      //if(detailObj.Object__c)
                      wrapperAddRow wrapInnerObj = new wrapperAddRow();
                      wrapInnerObj.objectfield = optnList;
                      //system.debug('###objectValues'+getFieldLabel(objectName.trim(),detailObj.acfField__c.trim()));
                     // wrapInnerObj.nameField = getFieldLabel(objectName.trim(),detailObj.acfField__c.trim());
                      wrapInnerObj.nameField = detailObj.acfField__c;
                      wrapInnerObj.operatorname = detailObj.acfOperator__c;
                      wrapInnerObj.expressionValue = detailObj.acfValue__c;
                      wrapInnerObj.orderNo = (Integer)detailObj.Order_Number__c;
                      lstwrap.add(wrapInnerObj);
                  }
                  wrapOuterUpdate.wrapObjectList = lstwrap;
                  OuterwrapperList.add(wrapOuterUpdate);
                  //lstwrap.clear();
               }
           }
           String saved = Apexpages.currentPage().getParameters().get('isSaved');
           if(saved == 'true')
               isSaved = true;
           
           system.debug('###'+OuterwrapperList);
           
        
    }
    
    public void addFilter()
    {
        string recOrder = Apexpages.currentPage().getParameters().get('recName');
        integer orderNo = integer.valueOf(recOrder);
        system.debug('orderNo *********************'+orderNo);
        //system.debug('OuterwrapperList[orderNo]*********************'+OuterwrapperList[orderNo-1]+'#######'+OuterwrapperList[orderNo-1].wrapObjectList);
        WrapperAddRow wrapObj = new WrapperAddRow();
        if(OuterwrapperList[orderNo].wrapObjectList != null)
        {
            if(OuterwrapperList[orderNo].wrapObjectList.size() == 0){
               wrapObj.orderNo = 0; 
            }
            for(WrapperAddRow wrapInner: OuterwrapperList[orderNo].wrapObjectList)
            {
              
                wrapObj.orderNo = wrapInner.orderNo + 1;
            }
           // outerWrapMap.get(orderNo).wrapObjectList.add(wrapObj);
           // outerWrapMap.put(orderNo,outerWrapMap.get(orderNo));
            OuterwrapperList[orderNo].wrapObjectList.add(wrapObj);
          //  OuterwrapperList[orderNo].add(wrapObj);
        }
        addObjectFieldByParam(orderNo);
    }
    
    
    //=================================================================
    // This method Is used to add filter Object.
    //=================================================================
    public void addFilterObject()
    {
        if(OuterwrapperList.size() > 0){
            for(Outerwrapper outWrap:OuterwrapperList){
                counter = outWrap.counterWrap;
            }
        }
        Outerwrapper OutWrap = new Outerwrapper(); 
        counter++;
        OutWrap.counterWrap = counter; 
        WrapperAddRow wrapAddObj = new WrapperAddRow();
        wrapAddObj.orderNo = 0;
        OutWrap.objectNames = listObjectNames();
        OutWrap.wrapObjectList = new List<WrapperAddRow>();
        OutWrap.wrapObjectList.add(wrapAddObj);
        OuterwrapperList.add(OutWrap);
        
        //system.debug('###outerMap'+outerWrapMap);
     }
     @testVisible
     private Schema.displayType getFieldType(String objectName,String fieldName){
         Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
         Schema.SObjectType objectSchema = schemaMap.get(objectName);
         Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
         Schema.displayType type = fieldMap.get(fieldName).getDescribe().getType();
         return type;
     }
     
     
    
    //=================================================================
    // This method Is used to Save deaLIQ Condition Rule object .
    //=================================================================
 
    public pagereference saveConditionRules()
    {
        Set<String> dupliacteObjectNameSet; 
        if(globalConObject == null && dealId != null && dealId != '')
            globalConObject = new Global_DealIQ_Condition__c(id = dealId);
            
        else if(globalConObject == null){
             globalConObject = new Global_DealIQ_Condition__c();
        }
        system.debug('###select'+selectbank);
        if(String.isNotEmpty(name))
            globalConObject.Name  = name;
        if(isActive != null)
            globalConObject.Active__c = isActive;
        if(String.isNotEmpty(description))
            globalConObject.acfRule_Description__c = description;
        if(String.isNotEmpty(sendCategory))
            globalConObject.Category__c = sendCategory;
        if(String.isNotEmpty(selectedVal)){
            globalConObject.object_Rule_Works_On__c = selectedVal;
            if(selectedVal == 'Bank'){
                integer count = 0;
                for(BankWrapper bwRec:bankWrapperList){
                    if(count == 0 && bwRec.selected && bwRec.bankId !=null)
                        globalConObject.RecordRuleWorksOn__c = bwRec.bankId;
                    else if(count > 0 && bwRec.selected && bwRec.bankId !=null)
                        globalConObject.RecordRuleWorksOn__c += ','+bwRec.bankId;
                    count++;
                }
            }
            else if(selectedVal == 'Product'){
                integer count = 0;
                for(ProductBankWrapper proBankRec:productBankWrapperList){
                    if(count == 0 && proBankRec.selected && proBankRec.productId !=null)
                        globalConObject.RecordRuleWorksOn__c = proBankRec.productId;
                    else if(count > 0 && proBankRec.selected && proBankRec.productId !=null)
                        globalConObject.RecordRuleWorksOn__c += ','+proBankRec.productId;
                    count++;
                }
            }
        }
       
        if(reqdoc !=null)
        {
            globalConObject.Req_Doc_Created__c = reqdoc;
        }
        if(String.isNotEmpty(doc))
            globalConObject.Document_Master__c = doc;
            
        if(globalConObject != null){
            try{
                upsert globalConObject;
            }
            catch(Exception e){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select proper values and save');
                 ApexPages.addMessage(myMsg);
                 return null;
            }
        }
        
           
        list<Global_DealIQ_Condition_Detail__c> globalDetailList;
        if(String.isNotEmpty(dealId)){
            globalDetailList = [Select id,acfGlobal_DealIQ_Rulea__c from Global_DealIQ_Condition_Detail__c where acfGlobal_DealIQ_Rulea__c =:dealId];
            if(globalDetailList.size() > 0){
                delete globalDetailList;
            }
            globalDetailList = new list<Global_DealIQ_Condition_Detail__c>();
        }
        
        if(globalDetailList == null)
         globalDetailList = new list<Global_DealIQ_Condition_Detail__c>();
          dupliacteObjectNameSet = new Set<String>();
        for(Outerwrapper wrap:OuterwrapperList)
        {
            for(WrapperAddRow wList:wrap.wrapObjectList){
                system.debug('###wList'+ wList);
                system.debug('###set'+dupliacteObjectNameSet);
                Global_DealIQ_Condition_Detail__c globalDetail = new Global_DealIQ_Condition_Detail__c();
                if(String.isNotEmpty(wrap.SObjectName)){
                    //dupliacteObjectNameSet.add(wrap.SObjectName);
                    if(dupliacteObjectNameSet.contains(wrap.SObjectName)){
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'The Object Name '+wrap.SObjectName+' has been found in two sections. Please add expression in one section for one object' );
                         ApexPages.addMessage(myMsg);
                         //dupliacteObjectNameSet.remove()
                         return null;
                    }
                    globalDetail.Object__c = wrap.SObjectName;
                    globalDetail.Global_Order_Number__c = wrap.counterWrap;
                    globalDetail.Order_Number__c = wList.orderNo;
                    globalDetail.acfField__c = wList.nameField;
                    globalDetail.acfOperator__c = wList.operatorname;
                    globalDetail.acfValue__c = wList.expressionValue; 
                    globalDetail.FieldType__c = String.valueOf(getFieldType(wrap.SObjectName,wList.nameField));
                    if(globalConObject !=null)
                        globalDetail.acfGlobal_DealIQ_Rulea__c = globalConObject.id;
                    globalDetailList.add(globalDetail);
                }  
                 
            }
            if(wrap.wrapObjectList.size() == 0){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please add atleast one condition to '+wrap.SobjectName+' Section');
                 ApexPages.addMessage(myMsg);
                         //dupliacteObjectNameSet.remove()
                 return null;
            }
            dupliacteObjectNameSet.add(wrap.SObjectName);
           
        }
        
        system.debug('###123'+globalDetailList);
        if(globalDetailList!=null && globalDetailList.size() >0){
            try{
                insert globalDetailList;
            }
            catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select proper values and save to make an expresion');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        
        isSaved = true;
      
        
        PageReference acctPage = new PageReference('/apex/ClickGlobalConditionsRuleSet?dealId='+globalConObject.id+'&isSaved='+isSaved);
        acctPage.setRedirect(true);
        return acctPage;
        //return null;
        //return new pagereference('/apex/ClickGlobalConditionsRuleSet?dealId='+globalConObject.id);
    }
    
    //=================================================================
    // This method Is used to Remove Contact.
    //=================================================================
    public void removeFilter()
    {
        string globalOrder = ApexPages.currentPage().getparameters().get('orderName');
        string[] orderList = globalOrder.split('-');
        OuterwrapperList[integer.valueOf(orderList[0])].wrapObjectList.remove(Integer.valueOf(orderList[1]));
        for(Outerwrapper outerWrap:OuterwrapperList){
            integer resetCount = 0;
            for(wrapperAddRow innerWrap:outerWrap.wrapObjectList){
                innerWrap.orderNo = resetCount;
                resetCount++;
            }
        }
        system.debug('###order'+globalOrder);
    }
    
    public void removeGlobalFilter(){
        string globalOrder = ApexPages.currentPage().getparameters().get('orderNameGlobal');
        OuterwrapperList.remove(Integer.valueOf(globalOrder));
        integer count = 0;
        for(Outerwrapper outerWrap:OuterwrapperList){
            outerWrap.counterWrap = count;
            count++;
        }
        counter = count;
        counter--;
       
    }    
    

   
    
    public List < SelectOption > getbankname()
    {
        List < SelectOption > optns = new List < Selectoption > ();
        optns.add(new selectOption('--select--', '--select--'));
        optns.add(new selectOption('Bank', 'Bank'));
        optns.add(new selectOption('Product', 'Product'));
        return optns;
    }
    

    //=================================================================
    // This method Is used to get category.
    //=================================================================
    public List < SelectOption > getcategoryqwe()
    {
        List < SelectOption > options = new List < SelectOption > ();
        Schema.DescribeFieldResult fieldResult =
        Global_DealIQ_Condition__c.Category__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        options.add(new selectOption('--None--', '--None--'));
        for (Schema.PicklistEntry f: ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        return options;
    }

    //=================================================================
    // This method Is used to Add row.
    //=================================================================
    
 
    //=================================================================
    // This method Is used to get Object Name.
    //=================================================================
    public List < SelectOption > listObjectNames() 
    {
        List < Schema.SObjectType > gd = Schema.getGlobalDescribe().Values();
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new selectOption('', '--Object--'));
        for (Schema.SObjectType f: gd)
        {
            options.add(new SelectOption(f.getDescribe().getName(), f.getDescribe().getLabel()));
        }
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        return options;
    }
    
    //=================================================================
    // This method Is used to get Object field.
    //=================================================================
  
    public void addObjectField()
    {
        List < SelectOption > options;
        for(Outerwrapper wrapOut:OuterwrapperList){
             options = new List < SelectOption > ();
             if (!String.isEmpty(wrapOut.SObjectName) && wrapOut.SObjectName!= '--select--'){
                SObjectType accountType = Schema.getGlobalDescribe().get(wrapOut.SObjectName);
                Map < String, Schema.SObjectField > mfield = accountType.getDescribe().fields.getMap();
                //mfield.values().sort();
                for (Schema.SObjectField entry: mfield.values()) {
                    options.add(new SelectOption(entry.getDescribe().getName(), entry.getDescribe().getLabel()+'('+entry.getDescribe().getType()+')'));
                    SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
                }
                if(wrapOut.wrapObjectList !=null && wrapOut.wrapObjectList.size()> 0){
                    for(WrapperAddRow wrapIn:wrapOut.wrapObjectList){
                       wrapIn.objectfield = options;
                    }
                }
            }
        }
       // String objectName = Apexpages.currentPage().getParameters().get('objectName');
        //system.debug('###objectName'+objectName);
        
    }
    
    public void addObjectFieldByParam(integer order){
          try{
            List < SelectOption > options = new List < SelectOption > ();
            if(OuterwrapperList[order].SObjectName == null && OuterwrapperList[order].SObjectName == ''){
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an object first in order to add row');
                  ApexPages.addMessage(myMsg);
                  return;
            }
            SObjectType accountType = Schema.getGlobalDescribe().get(OuterwrapperList[order].SObjectName);
            Map < String, Schema.SObjectField > mfield = accountType.getDescribe().fields.getMap();
            for (Schema.SObjectField entry: mfield.values()) {
                options.add(new SelectOption(entry.getDescribe().getName(), entry.getDescribe().getLabel()+'('+entry.getDescribe().getType()+')'));
            }
            SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
            for(WrapperAddRow wrapIn:OuterwrapperList[order].wrapObjectList){
               wrapIn.objectfield = options; 
            }
        }
        catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select proper values and save');
             ApexPages.addMessage(myMsg);
             return;
        }
    }
    
  
    
    
    //=================================================================
    // This method Is used to get Operator.
    //=================================================================
    
    public List < SelectOption > getoperator() 
    {
        List < SelectOption > optns = new List < Selectoption > (); 
        optns.add(new selectOption('is equal to', 'is equal to'));
        optns.add(new selectOption('is not equal to', 'is not equal to'));
        optns.add(new selectOption('contains with', 'contains with'));
        optns.add(new selectOption('is greater than', 'is greater than'));
        optns.add(new selectOption('is less than', 'is less than'));
        return optns;
    }
    
    //=================================================================
    // This method Is used to get Document Master.
    //=================================================================
    
    public List < SelectOption > getdocumentmaster() 
    {
        List < SelectOption > optns = new List < Selectoption > ();
        if (reqdoc == true)
        {
            List < Document_Master__c > lstdoc = new List < Document_Master__c > ();
            lstdoc = [select id,name from Document_Master__c];
            for (Document_Master__c doc: lstdoc) 
            {
                optns.add(new selectOption(doc.id, doc.name));
            }
            return optns;
        }
        else
        return null;
    }
    
    public class Outerwrapper
    {
        Public integer counterWrap{get;set;}
        Public String SObjectName{get;set;}
        Public List<wrapperAddRow> wrapObjectList{get;set;}
        Public List<SelectOption> objectNames{get;set;}
    }
 
  
    Public class ProductBankWrapper{
        public boolean selected{get;set;}
        public  string productName{get;set;}
        public string bankName{get;set;}
        public string productId{get;set;}
        
        public ProductBankWrapper(boolean selected,string bankName,string productName,string productId){
            this.selected = selected;
            this.bankName = bankName;
            this.productName = productName;  
            this.productId = productId;
        }
    }
    
    
    Public class BankWrapper{
        public boolean selected{get;set;}
        public string bankName{get;set;}
        public string bankId{get;set;}
        
        public BankWrapper(boolean selected,string bankName, string bankId){
            this.selected = selected;
            this.bankName = bankName; 
            this.bankId = bankId; 
        }
    }
    
    public class WrapperAddRow
    {
        public integer orderNo{get;set;}
        public String nameField{get;set;}
        Public String operatorname{get;set;}
        Public String expressionValue{get;set;}
        Public List<SelectOption> objectfield{get;set;}
        Public List<SelectOption> operator{get;set;}
    }
    public Boolean hasNext {
            get 
            {
                return obj.hasNext();
            }
            set;
        }
        
        public Boolean hasPrevious {
            get 
            {
                return obj.hasPrevious();
            }
            set;
        }
        
        public void next() 
        {
            lstSetController = obj.next();
        }
         public void nextProduct() 
        {
            productBankWrapperListforPagination = productObj.next();
        }
        
        public void previous() 
        {
            lstSetController = obj.previous();
        }
        
        
        public Boolean hasNextProduct {
            get 
            {
                return productObj.hasNext();
            }
            set;
        }
        
        public Boolean hasPreviousproduct {
            get 
            {
                return productObj.hasPrevious();
            }
            set;
        }
        
       
        
        
        public void previousProduct() 
        {
            productBankWrapperListforPagination = productObj.previous();
        }
}