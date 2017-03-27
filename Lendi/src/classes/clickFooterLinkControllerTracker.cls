@isTest
private class clickFooterLinkControllerTracker
{

    
    static testMethod void validate() 
    {
        
        
        acfContentManagementSystem__c   objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem.acfHeading__c = 'POPULAR SEARCHES';
        objContentManagementSystem.acfPageName__c = 'acfLogin';
        objContentManagementSystem.acfSectionName__c = 'Footer Link Content';
        objContentManagementSystem.acfSequence__c = 5;
        objContentManagementSystem.acfDescription__c = 'Online loans';
        objContentManagementSystem.acfIs_Checked__c = true;
        objContentManagementSystem.acfHeader_Sequance__c = 4;
        insert objContentManagementSystem;
        
        acfCMS_Page__c obj = new acfCMS_Page__c ();
        obj.Name ='acfcontactus';
        obj.acfDescription__c = 'Ankit Singh';
        obj.acfHeading__c = 'abcd';
        insert obj;
        
        PageReference pgRef = Page.clickFooterLink; 
        Test.setCurrentPage(pgRef); 
        ApexPages.currentPage().getParameters().put('pid', obj.id);
        
        
    //    string strCMSPageId = apexpages.currentpage().getparameters().get(obj.id);
        clickFooterLinkController objFooter = new clickFooterLinkController();
    

    }
    }