@istest
public class clsCoreLogicServicesHelperTracker
{
    private static Account objAccount;
    private static Asset_And_Liability__c objasset;
    private  static Lead objLead;

        static testMethod void validate()
        {   
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVeda()); 
            LoadData();
            test.starttest();
            Avm_Property__c objavm=new Avm_Property__c();
            objavm.propertyId__c=99999;
            //insert objavm;

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
            
            clsCoreLogicServicesHelper.avmFaresDetail ob=new clsCoreLogicServicesHelper.avmFaresDetail();
            ob.faresReferenceID='test';
            

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Account__c=objAccount.id;
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            //objasset.Address__c='test';
            update objasset;
            test.stoptest();
        }

        static testMethod void validate1()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVeda());
            LoadData();

            test.starttest();
            Avm_Property__c objavm=new Avm_Property__c();
            objavm.propertyId__c=99999;
            //objavm.Expiry_date__c=System.today()-1;
            // insert objavm;

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

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            //objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;

            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            //objfin.Amount__c=1000;
            insert objfin;
            test.stoptest();
        }
         
        
        static testMethod void validate1a()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVeda());
            LoadData();

            
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

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;

            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            //objfin.Amount__c=1000;
            insert objfin;
            List<Asset_And_Liability__c> lstAssetandLiability = new List<Asset_And_Liability__c>();
            lstAssetandLiability.add(objasset);
            test.starttest();
            clsCoreLogicServicesHelper.CreateRpdata(lstAssetandLiability);
            test.stoptest();
        }

        static testMethod void validate3()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVeda());
            LoadData();
            test.starttest();
            Avm_Property__c objavm=new Avm_Property__c();
            objavm.propertyId__c=99999;
            insert objavm;
            
            Avm_Property__c objavms=new Avm_Property__c();
            objavms.propertyId__c=99999;
            insert objavms;

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

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            //objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;

            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            objfin.Amount__c=1000;
            // insert objfin;
            test.stoptest();
        }
        
        static testMethod void validate3a()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVedas());
            LoadData();
            
            Avm_Property__c objavm=new Avm_Property__c();
            objavm.propertyId__c=99999;
            insert objavm;

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

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            //objasset.Street_Number__c='test';
            //.Street_Name__c='test';
            //objasset.Street_Type__c='test';
            //objasset.City__c='test';
            //objasset.State__c='test';
            //objasset.Postcode__c=77;
            //objasset.Country__c='test';
            update objasset;   

            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            objfin.Amount__c=1000;
            // insert objfin;
            List<Asset_And_Liability__c> lstAssetandLiability = new List<Asset_And_Liability__c>();
            lstAssetandLiability.add(objasset);
            test.starttest();
            clsCoreLogicServicesHelper.CreateRpdata(lstAssetandLiability);
            test.stoptest();
        }
        
        static testMethod void validate3b()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorsVedas());
            LoadData();
            
            Avm_Property__c objavm=new Avm_Property__c();
            objavm.propertyId__c=99999;
            insert objavm;

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

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;   

            Financials_Source__c objfin=new Financials_Source__c();
            objfin.Asset_And_Liability__c=objasset.id;
            objfin.Source__c='RPData';
            objfin.Amount__c=1000;
            // insert objfin;
            List<Asset_And_Liability__c> lstAssetandLiability = new List<Asset_And_Liability__c>();
            lstAssetandLiability.add(objasset);
            test.starttest();
            clsCoreLogicServicesHelper.CreateRpdata(lstAssetandLiability);
            test.stoptest();
        }

        // addred bu prateek for status code 100 
        static testMethod void validate5()
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponsForProIdforcode());
            LoadData();
            test.starttest();
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

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            //objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;
            test.stoptest();
        }

        static testMethod void validate6()
        {
           

            test.starttest();
             Test.setMock(HttpCalloutMock.class, new MockHttpResponsForProIdforcode());
            LoadData();
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

            objAccount.acfPostal_Code__pc= null;
            update objAccount; 

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;
            test.stoptest();
        }


        static testMethod void validate7()
        {
           
            test.starttest();
             Test.setMock(HttpCalloutMock.class, new MockHttpResponsForProIdnull());
            LoadData();
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

            objAccount.acfPostal_Code__pc= null;
            update objAccount; 

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;
            test.stoptest();
        }
        
        static testMethod void validate8()
        {
          
            
            test.starttest();
            
              Test.setMock(HttpCalloutMock.class, new MockHttpResponsForProIdnull());
            LoadData();
             Avm_Property__c objavm=new Avm_Property__c();
            // objavm.LastModifiedDate=date.valueof(System.today()-400);
            
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

            objAccount.acfPostal_Code__pc= null;
            update objAccount; 

            objasset.recordtypeid=SObjectType.Asset_And_Liability__c.getRecordTypeInfosByName().get('Asset Real Estate').getRecordTypeId();
            objasset.Street_Number__c='test';
            objasset.Street_Name__c='test';
            objasset.Street_Type__c='test';
            objasset.City__c='test';
            objasset.State__c='test';
            objasset.Postcode__c=77;
            objasset.Country__c='test';
            update objasset;
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
        }
        
        public class MockHttpResponseGeneratorsVedas implements HttpCalloutMock
        {
            public HTTPResponse respond(HTTPRequest req)
            {
                // Create a fake response
                HttpResponse res = new HttpResponse();
                // res.setHeader('Content-Type', 'text/x');
                //res.setBody('{"avmFaresDetail":{"faresCode":"0","faresCondition":"SUCCESS","faresDescription":"SUCCESS","faresFSDScore":"11","faresReferenceID":"VIC:1469096069036-1529423","faresRunDate":"2016-07-21T20:14:29.469+10:00","faresScore":"81","faresValuationDate":"2016-07-21T20:14:29.469+10:00","faresValueEstimate":"670937","faresValueHigh":"746893","faresValueLow":"594981","otmProperties":[9220514,9210721,9213533,9220100,9220914,9213758],"soldProperties":[9220514,9221337,9220386,9221887,9220527,9213765]},"propertyId":null,"systemInfo":{"instanceName":"71:8080","requestDate":"2016-07-21T20:14:29.017+10:00"}}');
                res.setBody('{}');
                res.setStatusCode(200);
                return res;
            }
        }
 }