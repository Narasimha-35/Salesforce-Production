@isTest(SeeAllData = true)
public class WLLoginTracker 
{
    static testMethod void validateacfLogin() 
    {
        WLLoginController objWLLoginController = new WLLoginController();
        objWLLoginController.username = '';
        objWLLoginController.Fusername = '';
        objWLLoginController.UserforgotPassword();
        objWLLoginController.Userlogin();
        objWLLoginController.username = 'sonaltest123@gmail.com';
        objWLLoginController.Fusername = 'sonaltest123@gmail.com';
        objWLLoginController.password = 'sonaltest123@gmail.com';
        objWLLoginController.Userlogin();
        objWLLoginController.UserforgotPassword();
    }
    
    static testMethod void validateacfLogin2() 
    {
        Click_Community_Setup__c objCommunitySetUp = ClickCommon.getCommunitySetup(WLCommonTrackerClass.testNetworkId);
        if(objCommunitySetUp != null)
        {
            list<Account> lstAcc = [select PersonEmail from Account where Click_Community_Setup__c =: objCommunitySetUp.Id limit 1];
            if(lstAcc != null && lstAcc.size() > 0)
            {
                WLLoginController objWLLoginController = new WLLoginController();
                objWLLoginController.username = lstAcc[0].PersonEmail;
                objWLLoginController.Fusername = lstAcc[0].PersonEmail;
                objWLLoginController.password = 'saasforce@123';
                objWLLoginController.Userlogin();
                objWLLoginController.UserforgotPassword();
            }
        }
    }
}