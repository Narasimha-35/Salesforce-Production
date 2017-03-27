@isTest

public class acfCreateRpDataBatchTracker
{
private static account objAccount;
private static contact  objContact;
private static user objUser;
private static opportunity objOpportunity;
private static Asset_And_Liability__c objAssetLiab;   

static testMethod void validate()
{
    
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
    
                  objAccount=new account();
          objAccount=WLCommonTrackerClass.createAccount(objAccount);
       
      
          objContact=new contact();
          objContact=WLCommonTrackerClass.createContact(objContact,objAccount);
      
          objUser = new User();
          objuser.ContactId = objContact.id;
          objUser = WLCommonTrackerClass.CreatePortalUser(objAccount.id);
          
          objOpportunity = new Opportunity();
          objOpportunity = WLCommonTrackerClass.createOpportunity(objOpportunity,objUser);
          objOpportunity.acfLegal_Fees__c=88;
          objOpportunity.clickEstablishment_Fee__c=99;
          objOpportunity.clickMortgage_Risk_Fee__c=888;
          update objOpportunity;
                
                objAssetLiab=new Asset_And_Liability__c();
                objAssetLiab.Clearing_From_This_Loan__c=true;
                objAssetLiab.name='Liabilities Mortgage Loan';
                objAssetLiab.Opportunity__c=objOpportunity.id;
                objAssetLiab.recordtypeid= Schema.SObjectType.Asset_And_Liability__c .getRecordTypeInfosByName().get('Liability Mortgage Loan').getRecordTypeId();    
                objAssetLiab.Account__c = objAccount.Id;
                objAssetLiab.Account_Name__c = 'Bhasin Test';
                objAssetLiab.Account_Number__c ='ACN123456';
                objAssetLiab.Type__c ='Asset';
                objAssetLiab.Value__c = 100000;
                objAssetLiab.Primary_Purpose__c ='Owner Occupied';
                objAssetLiab.Repayments__c=09876;
                objAssetLiab.Used_as_Security__c = true;
                objAssetLiab.Current_Balance__c=99;
                objAssetLiab.Limit__c=55;
                objAssetLiab.Repayment_Frequency__c='Weekly';
               // objAssetLiab.Current_Balance__c=99;
                insert objAssetLiab;
                List<Asset_And_Liability__c> lst=new List<Asset_And_Liability__c>();
                lst.add(objAssetLiab);
                list<id> lst1=new list<id>();
                   Database.BatchableContext BC;
                acfCreateRpDataBatch obj=new acfCreateRpDataBatch(lst1);
                  Database.executeBatch(obj);
             obj.execute(BC,lst);
                }
                }