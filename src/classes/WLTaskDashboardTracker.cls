@isTest(seeAlldata=true)
private class WLTaskDashboardTracker {
    private static user objUser;
    private static acfTask_Master__c objTask;
    private static Opportunity objOpportunity;
    private static Lead objLead;
    private static Account objAccount;

    static testMethod void validateWLTaskDashboard() 
    {
        LoadData();
        
        System.runAs(objuser){
        List<Task> tasks = new List<Task>();
        Task objtsk = new Task();
        objtsk.ActivityDate = Date.today().addDays(1);
        objtsk.Subject='Sample Task';
        objtsk.WhatId = UserInfo.getUserId();
   //     objtsk.OwnerId = UserInfo.getUserId();
        objtsk.Status='In Progress';
        tasks.add(objtsk);


        WLTaskDashboard objacfTaskDashboard = new WLTaskDashboard();
        objacfTaskDashboard.tsk_obj = tasks;
        objacfTaskDashboard.user_id =UserInfo.getUserId();
        objacfTaskDashboard.strTasksub = 'test';
        objacfTaskDashboard.redirect();
        objacfTaskDashboard.toOpenTaskdetails();
        }      
    }
    
    private static void LoadData()
    {   
        
        createUser();
        createOpportunity();
        createTask();
        
    }
    
    

    
    static void createuser()
    {
        objLead=acfCommonTrackerClass.createLeadForPortal();
        objuser = new User();
      //  objuser = [select Id,Name,IsActive,Email,MobilePhone,ContactId,AccountId from user where id=:userInfo.getUserId() limit 1];
        objAccount=acfCommonTrackerClass.CreatePersonAccount('test','test','+619540505050','test@fakeemail.com',objLead.id);
        objuser=acfCommonTrackerClass.CreatePortalUser(objAccount.id);
        system.debug(objuser.AccountId+'------------------------------------');
   

    }
    
    static void createOpportunity()
    {
        objOpportunity = new Opportunity();
        //objOpportunity.AccountId =objAccount.Id;
        objOpportunity = acfCommonTrackerClass.createOpportunity(objOpportunity,objuser);
        system.debug(objOpportunity+'------------------------------------');
    }
    
    static void createTask()
    {
        objTask = new acfTask_Master__c();
        objTask = acfCommonTrackerClass.createTask(objtask);
    }
}