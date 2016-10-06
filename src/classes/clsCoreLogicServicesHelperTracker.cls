@istest
public class clsCoreLogicServicesHelperTracker
{
    private static Account objAccount;
    private static Asset_And_Liability__c objasset;
    private static Asset_And_Liability__c objassetObj;
    private  static Lead objLead;
    private static acfPropertydetails__c objpropertydetail;
    private static acfPropertydetails__c objpropertydetails;
    private static Avm_Detail__c objAvmDetail;
    private static Avm_Detail__c objAvmDetails;
    private static Avm_Property__c objavm1;
    private static Avm_Property__c objavm2;
    private static Financials_Source__c objFinancialSource;
    private static Property_Photo_List__c objPropPhotoList;
        static testMethod void validate1()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVedas());
            LoadData();

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test77';
            objasset.Street_Name__c='test77';
            objasset.Street_Type__c='test77';
            objasset.City__c='test77';
            objasset.State__c='test77';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;
            
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVedas1());
            objassetObj.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objassetObj.Account__c = objAccount.id;
            objassetObj.Street_Number__c='testtest';
            objassetObj.Street_Name__c='testtest';
            objassetObj.Street_Type__c='testtest';
            objassetObj.City__c='testtest';
            objassetObj.State__c='testtest';
            objassetObj.Postcode__c=77;
            objassetObj.Country__c='testtest';
            update objassetObj;
    
            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            insert objfin;
            
            clsPropertyJson objclsjson =  new clsPropertyJson();
            List<Asset_And_Liability__c> lstAssetandLiability = new List<Asset_And_Liability__c>();
            lstAssetandLiability.add(objassetObj);
            lstAssetandLiability.add(objasset);
            test.starttest();
            clsCoreLogicServicesHelper objclass = new clsCoreLogicServicesHelper();
            objclass.CreateRpdata(lstAssetandLiability);
            test.stoptest();
        }
        
        static testMethod void validate1a()
        {
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVedas());
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorPropertyId());
            LoadData1();
            system.debug('TestClassValidate1a**********************************');
            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test12';
            objasset.Street_Name__c='test12';
            objasset.Street_Type__c='test12';
            objasset.City__c='test12';
            objasset.State__c='test12';
            objasset.Postcode__c=771;
            objasset.Country__c='test12';
            update objasset;
            
            
            /*objassetObj.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objassetObj.Account__c = objAccount.id;
            objassetObj.Street_Number__c='test32';
            objassetObj.Street_Name__c='test';
            objassetObj.Street_Type__c='test';
            objassetObj.City__c='test';
            objassetObj.State__c='test';
            objassetObj.Postcode__c=77;
            objassetObj.Country__c='test';
            update objassetObj;*/
    
            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            insert objfin;
            
            clsPropertyJson objclsjson =  new clsPropertyJson();
            List<Asset_And_Liability__c> lstAssetandLiability = new List<Asset_And_Liability__c>();
            lstAssetandLiability.add(objasset);
            //lstAssetandLiability.add(objassetObj);
            test.starttest();
            clsCoreLogicServicesHelper objclass = new clsCoreLogicServicesHelper();
            objclass.CreateRpdata(lstAssetandLiability);
            test.stoptest();
        }
        
        static testMethod void validate1d()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVedas1());
            LoadData();
            system.debug('TestClassValidate1a**********************************');
            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            update objasset;
            
            objassetObj.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objassetObj.Account__c = objAccount.id;
            update objassetObj;
    
            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            insert objfin;
            
            clsPropertyJson objclsjson =  new clsPropertyJson();
            List<Asset_And_Liability__c> lstAssetandLiability = new List<Asset_And_Liability__c>();
            lstAssetandLiability.add(objasset);
            lstAssetandLiability.add(objassetObj);
            test.starttest();
            clsCoreLogicServicesHelper objclass = new clsCoreLogicServicesHelper();
            objclass.CreateRpdata(lstAssetandLiability);
            test.stoptest();
        }
        
        static testMethod void validate1b()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVedas1());
            LoadData();            

            objasset.recordtypeid = SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Account__c = objAccount.id;
            update objasset;
            
            objassetObj.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            update objassetObj;
            
            clsPropertyJson objclsjson =  new clsPropertyJson();
            List<Asset_And_Liability__c> lstAssetandLiability = new List<Asset_And_Liability__c>();
            lstAssetandLiability.add(objasset);
            lstAssetandLiability.add(objassetObj);
            test.starttest();
            clsCoreLogicServicesHelper objclass = new clsCoreLogicServicesHelper();
            objclass.CreateRpdata(lstAssetandLiability);
            test.stoptest();
        }
        
                        
        private static void LoadData()
        {
            ACFSwitch__c acfswitch = new ACFSwitch__c();
            acfswitch.Asset_And_Liability_Switch__c= true;
            insert acfswitch;

            createLead();
            createAccount();
            createAssetandLiablility();
            createAvmProperty();
            createAcfPropertyDetails();
            createAvmDetail();
            createFinancialSource();  

            CoreLogic__c objcore=new CoreLogic__c();
            objcore.name='CoreLogic';
            objcore.UserName__c='test';
            objcore.password__c='AusCred4321';
            objcore.EndPoint__c='https://access-api.corelogic.asia';
            objcore.AvmEndpoint__c='test';
            objcore.ClientID__c='test';
            objcore.ClientSecret__c='test';
            objcore.TokenEndPoint__c='test';
            objcore.SearchApiEndPoint__c='test';
            insert objcore;
        }
        
        private static void LoadData1()
        {
            ACFSwitch__c acfswitch = new ACFSwitch__c();
            acfswitch.Asset_And_Liability_Switch__c= true;
            insert acfswitch;

            createLead();
            createAccount();
            createAssetandLiablility();
            createAvmProperty();
            //createFinancialSource();  

            CoreLogic__c objcore=new CoreLogic__c();
            objcore.name='CoreLogic';
            objcore.UserName__c='test';
            objcore.password__c='AusCred4321';
            objcore.EndPoint__c='https://access-api.corelogic.asia';
            objcore.AvmEndpoint__c='test';
            objcore.ClientID__c='test';
            objcore.ClientSecret__c='test';
            objcore.TokenEndPoint__c='test';
            objcore.SearchApiEndPoint__c='test';
            insert objcore;
        }
        
        static void createLead()
        {
            objLead=new Lead();
            objLead=WLCommonTrackerClass.createLead(objLead);
        }
        
        static void createAccount()
        {
            objAccount = new Account();
            objAccount = WLCommonTrackerClass.CreatePersonAccount('test','test','123456','test@gmail.com',objLead.id);
            objAccount.acfPostal_Code__pc=null;
            update objAccount; 
        }
        static void createAssetandLiablility()
        {
            objasset=new Asset_And_Liability__c ();
            objasset=WLCommonTrackerClass.createAssetandLiablility(objasset,objAccount);
            
            objassetObj = new Asset_And_Liability__c ();
            objassetObj =WLCommonTrackerClass.createAssetandLiablility(objassetObj,objAccount);
        }
        
        static void createAvmProperty()
        {
            objavm1=new Avm_Property__c();
            objavm1.propertyId__c=2028759;
            insert objavm1;
            
            objavm2=new Avm_Property__c();
            objavm2.propertyId__c=null;
            insert objavm2;
        }
               
        static void createAcfPropertyDetails()
        {
           objpropertydetail = new acfPropertydetails__c();
           objpropertydetail.PropertyID__c = String.valueof(objavm1.propertyId__c);
           objpropertydetail.Asset_And_Liability__c = objasset.Id;
           insert objpropertydetail;
           
           objpropertydetails = new acfPropertydetails__c();
           objpropertydetails.PropertyID__c = String.valueof(objavm1.propertyId__c);
           objpropertydetails.Asset_And_Liability__c = objassetObj.Id;
           insert objpropertydetails;
           
        }
        
        static void createAvmDetail()
        {
           objAvmDetail = new Avm_Detail__c();
           objAvmDetail.Estimate__c = '1000';
           objAvmDetail.Property_Name__c = objpropertydetail.Id;
           insert objAvmDetail;
           
           objAvmDetails = new Avm_Detail__c();
           objAvmDetails.Estimate__c = '10000';
           objAvmDetails.Property_Name__c = objpropertydetails.Id;
           insert objAvmDetails;
        }
 
        static void createFinancialSource()
        {
            objFinancialSource = new Financials_Source__c();
            objFinancialSource.Amount__c = 2121;
            objFinancialSource.Asset_And_Liability__c = objasset.Id;
            objFinancialSource.Source__c ='RPData';
            insert objFinancialSource;
        }
        
         
        static void createPropertyPhoto()
        {
            objPropPhotoList = new Property_Photo_List__c();
            objPropPhotoList.Property_Name__c = objpropertydetail.Id;
            insert objPropPhotoList;
        }
        
        public class MockHttpResponseGeneratorsVedas implements HttpCalloutMock
        {
            public HTTPResponse respond(HTTPRequest req)
            {
                // Create a fake response
                HttpResponse res = new HttpResponse();
                //res.setBody('{"avmFaresDetail":{"faresCode":"0","faresCondition":"SUCCESS","faresDescription":"SUCCESS","faresFSDScore":"11","faresReferenceID":"VIC:1469096069036-1529423","faresRunDate":"2016-07-21T20:14:29.469+10:00","faresScore":"81","faresValuationDate":"2016-07-21T20:14:29.469+10:00","faresValueEstimate":"670937","faresValueHigh":"746893","faresValueLow":"594981","otmProperties":[9220514,9210721,9213533,9220100,9220914,9213758],"soldProperties":[9220514,9221337,9220386,9221887,9220527,9213765]},"propertyId":9220490,"systemInfo":{"instanceName":"71:8080","requestDate":"2016-07-21T20:14:29.017+10:00"}}');
                res.setBody('{"matchDetails":{"matchRule":"002","matchType":"E","propertyId":2028759,"updateDetail":"00000000","updateIndicator":"O"}}');
                res.setStatusCode(200);
                return res;
            }
        }
        
        public class MockHttpResponseGeneratorsVedas1 implements HttpCalloutMock
        {
            public HTTPResponse respond(HTTPRequest req)
            {
                // Create a fake response
                HttpResponse res = new HttpResponse();               
                res.setBody('{"matchDetails":{"matchRule":"002","matchType":"E","propertyId":null,"updateDetail":"00000000","updateIndicator":"O"}}');
                res.setStatusCode(200);
                return res;
            }
        }   
    }