@isTest
private class BrokerFooterTracker 
{

    static testMethod void validate() 
    { 

        
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj .Name ='acfcontactus';
        obj .acfDescription__c = 'Ankit Singh';
        obj .acfHeading__c = 'abcd';
        insert obj ;
        
        acfContentManagementSystem__c   objCMS = new acfContentManagementSystem__c();
        objCMS.acfHeading__c = 'POPULAR SEARCHES';
        objCMS.acfPageName__c = 'common';
        objCMS.acfSectionName__c = 'Footer';
        objCMS.acfSequence__c = 5;
        objCMS.acfDescription__c = 'Online loans';
        objCMS.acfIs_Checked__c = true;
        objCMS.acfHeader_Sequance__c = 4;
        insert objCMS;

        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'ClickHome';
        objContentManagementSystem.acfSectionName__c = 'Footer Links';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfCMS_Page__c = obj.id;
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        insert objContentManagementSystem;
        
       PageReference pageRef = new PageReference('http://www.google.com');
       Test.setCurrentPage(pageRef);
        Click_Community_Setup__c objccs=new Click_Community_Setup__c();
        objccs.Name='ClickLoans';
        objccs.Click_Page_Prefix__c = 'Click';
        objccs.Click_Network_ID__c='0DB900000008Ptg';
        insert objccs;
        
        BrokerfooterController objabout = new BrokerfooterController();
        objabout.selectedLinkId = 'test';
        

    }
  
}