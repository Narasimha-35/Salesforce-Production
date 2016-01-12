@isTest(SeeAllData = false)
private class acfCMSPageTracker {
    private static acfContentManagementSystem__c objContentManagementSystem;
    private static Attachment objAttachment;
    private static Attachment objAttachment2;

    static testMethod void validateacfCMSPage()
     {
        
        LoadData();
        ApexPages.StandardController sc = new ApexPages.standardController(objContentManagementSystem);
        apexpages.currentpage().getparameters().put('id',objContentManagementSystem.id);
        acfCMSPage objacfCMSPage = new acfCMSPage(sc);      
        
  //      system.debug('swati'+objacfCMSPage.id);
        objacfCMSPage.getattach_obj();
        Blob b = Blob.valueOf('test');      
        objacfCMSPage.getattach_obj().body = b;
        objacfCMSPage.getattach_obj1();
        objacfCMSPage.getattach_obj1().body = b;
        objacfCMSPage.mySave();
        objacfCMSPage.changeEvent();
                
    }
    
    static testMethod void validateacfCMSPage1()
     {
        
        LoadData();
        ApexPages.StandardController sc = new ApexPages.standardController(objContentManagementSystem);
        //apexpages.currentpage().getparameters().put('id',objContentManagementSystem.id);
        acfCMSPage objacfCMSPage = new acfCMSPage(sc);      
        
 //       system.debug('swati'+objacfCMSPage.id);
        
        objacfCMSPage.getattach_obj();
        Blob b = Blob.valueOf('test');      
        objacfCMSPage.getattach_obj().body = b;
        objacfCMSPage.getattach_obj().name = 'Heading.jpg';
        //objacfCMSPage.getattach_obj().BodyLength = 123456;
        
        objacfCMSPage.getattach_obj1();
        objacfCMSPage.getattach_obj1().body = b;
        objacfCMSPage.getattach_obj().name = 'Description.jpg';
        
        objacfCMSPage.mySave();             
        objacfCMSPage.err_msg = '';
    }
    
    static testMethod void validateacfCMSPage2()
     {
        
        LoadData();
        ApexPages.StandardController sc = new ApexPages.standardController(objContentManagementSystem);
        //apexpages.currentpage().getparameters().put('id',objContentManagementSystem.id);
        acfCMSPage objacfCMSPage = new acfCMSPage(sc);      
        
//        system.debug('swati'+objacfCMSPage.id);
        
        objacfCMSPage.getattach_obj();      
        objacfCMSPage.getattach_obj().name = 'Heading.jpg';
        //objacfCMSPage.getattach_obj().BodyLength = 123456;
        
        objacfCMSPage.getattach_obj1();
        objacfCMSPage.getattach_obj().name = 'Description.jpg';
        
        objacfCMSPage.mySave();             
        objacfCMSPage.err_msg = '';
    }
    
    private static void LoadData()
    {
        CreateContentManagementSystem();
        //CreateAttachment();
        //CreateAttachment2();
    }
    
    static void CreateContentManagementSystem()
    {
        objContentManagementSystem = new acfContentManagementSystem__c();
        objContentManagementSystem = acfCommonTrackerClass.CreateContentManagementSystem(objContentManagementSystem);
    }
    
    /*static void CreateAttachment()
    {
        objAttachment = new Attachment();
        objAttachment.Name='Heading.jpg';
        objAttachment.ParentId =objContentManagementSystem.id;
        blob b= blob.valueOf('Test Data');        
        objAttachment.Body = b;
        //objAttachment.BodyLength = 2763037;
        insert objAttachment;
    }
    
    static void CreateAttachment2()
    {
        objAttachment2 = new Attachment();
        objAttachment2.Name='Description.jpg';
        objAttachment2.ParentId =objContentManagementSystem.id;
        blob b= blob.valueOf('Test Data');
        
        objAttachment2.Body = b;
        //objAttachment2.BodyLength = 2763037;
        insert objAttachment2;
        
    }*/
}