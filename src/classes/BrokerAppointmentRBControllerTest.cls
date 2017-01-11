@isTest(SeeAllData=true)
private class BrokerAppointmentRBControllerTest {

    static testMethod void myControllerTest() {
        /*Id currentUserId = UserInfo.getUserId();
        User user = [Select Id, Email, ManagerId From User where Id =:currentUserId and IsActive = true];
        List<User> adminUsers = [Select Id From User where Email = 'appointments@creditandfinance.com.au'];
        if (adminUsers.size() == 0) {
            adminUsers = [Select Id From User where Email = 'cche5425@gmail.com'];
        }
        if (user != null) {
            user.ManagerId = adminUsers.get(0).Id;
        }
        Market__c market = [select Id From Market__c limit 1];
        Broker__c broker = new Broker__c();
        broker.Active_Broker__c = true;
        broker.Channel__c = 'Employee';
        broker.Name = 'Chen Chen';
        broker.MobilePhone__c = '098765543';
        broker.Email__c = user.Email;
        broker.Primary_Market__c = market.Id;
        broker.Street_Address__c = '22 chekolr rod';
        broker.City__c = 'sydney';
        insert broker;
        
        Appointment__c appointment = [Select Id, Opportunity__r.StageName, Opportunity__r.Description, Opportunity__r.Closed_Lost_Reason__c From Appointment__c Where Appointment_Status__c = 'Allocated' and Opportunity__c != null limit 1];
        appointment.Broker__c = broker.Id;
        update appointment;
        
        BrokerAppointmentReportBrokerController testController = new BrokerAppointmentReportBrokerController();
        testController.presalesAction = true;
        testController.needHelp = true;
        testController.currentAppointmentId = appointment.Id;
        testController.getAppStatusItems();
        testController.getOppoStatusItems();
        testController.getClosedLostReasons();
        appointment.Opportunity__r.StageName = 'Closed Lost';
        appointment.Opportunity__r.Closed_Lost_Reason__c = '[too much money, too old]';
        test.startTest();
        testController.saveAndProcess();
        test.stopTest();
        System.assertEquals(appointment.Opportunity__r.StageName, 'Closed Lost');*/
        
    }
}