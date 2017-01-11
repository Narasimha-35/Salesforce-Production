public class WLWelcomeDashboard
{
    public string pge_name {set; get;}
    Public List<Task> List_Task;
    Public Integer CountTasks {get;set;} 
    Public Boolean isApplication {get;set;}
    Public Boolean isApproval {get;set;}
    Public Boolean isLoanDocs {get;set;}
    Public Boolean isSettlement {get;set;} 
    Public Boolean isDocumentRejected {get;set;}
    Public Boolean isshow {get;set;}
    public String strHeaderName {get;set;}
    public String strDescriptionName {get;set;}
    private Click_Community_Setup__c objCommSetup;
    public String MyOpportunityIds;
//  public boolean InputHidden { get; set; }
    public string setMyOpportunityIds(String testId)
    {
        MyOpportunityIds = testId; 
        Dashboard();
        return null; 
    } 
    
    public String getMyOpportunityIds()
    {
       return MyOpportunityIds; 
    }

    public WLWelcomeDashboard()
    { 
        isApplication = false;
        isApproval = false;
        isLoanDocs = false;
        isSettlement = false;  
    }
        
    public void Dashboard()
    {
         Id loggedInLeadId = ClickCommon.getCurrentLoggedInLeadId(userinfo.getUserId());
         Id loggedInOpportunityId;
         if(MyOpportunityIds != null)
             loggedInOpportunityId = Id.valueOf(MyOpportunityIds);  
         objCommSetup = ClickCommon.getCommunitySetup(Network.getNetworkId());
         string pge = Apexpages.currentPage().getUrl(); 
         List<String> parts = pge.split('/'); 
         List<String> parts1 = parts[2].split('\\?');
         pge_name = parts1[0]; 
         system.debug('cons pge_name -------- '+pge_name); 
            isshow =true; 
         if(pge_name == objCommSetup.Click_Page_Prefix__c + 'EditProfile'){
            isshow = false;
         }    
         system.debug('loggedInOpportunityId============'+loggedInOpportunityId);
              
            if(loggedInOpportunityId != null)
            {  
                   Opportunity oppObj = [select id,acf_Status__c,OwnerId,acfIs_Identity_Document_Rejected__c,StageName from opportunity where Id=:loggedInOpportunityId];
                    If(oppObj!=null)
                    {
                        isDocumentRejected = oppObj.acfIs_Identity_Document_Rejected__c;
                        If(oppObj.StageName == 'Application Taken')
                        {
                            isApplication = true;
                        }
                        else If(oppObj.StageName == 'Approval')
                        {
                            isApproval = true;
                        }
                        else If(oppObj.StageName == 'Loan Document')
                        {
                            isLoanDocs = true;
                        } 
                        else If(oppObj.StageName == 'Settlement' || oppObj.StageName == 'Settled')
                        {
                           isSettlement = true;
                        }
                    }
                    List_Task = new List<Task>();
                    List_Task = [SELECT ActivityDate, Id, Status,IsVisibleInSelfService, Subject, WhatId, WhoId, who.name FROM Task WHERE WhatId =: oppObj.Id AND Status != 'Completed'];
                    If(List_Task!=null && !List_Task.isEmpty())
                    {
                        CountTasks = List_Task.size();
                    }
                    else
                    {
                        CountTasks = 0;
                    }
                }else If(loggedInLeadId != null){
                    Lead objLead = [select id,acfIs_Identity_Document_Rejected__c from lead where id=:loggedInLeadId];
                    If(objLead != null){
                        isDocumentRejected = objLead.acfIs_Identity_Document_Rejected__c;
                    }
                }
                
            List<User> lstUser = new List<User>();
            String strDashBoardName = '';
            String strPagename = parts1[0]; 
            strHeaderName = '';
            strDescriptionName = '';
            system.debug('current strPagename -------- '+strPagename);
            string strUserId = UserInfo.getuserId();
            If(strUserId != null && strUserId <> '')
            {
             lstUser = [select id,Name from user where id=:strUserId];
            }
            List<acfContentManagementSystem__c> lstDashboardSec = [SELECT Id,acfDescription__c,acfHeading__c, acfSectionName__c FROM acfContentManagementSystem__c where acfSectionName__c = 'Dashboard' and Click_Community_Setup__c =: objCommSetup.id limit 1];
            If(lstDashboardSec != null && lstDashboardSec.size()>0)
            {
                acfContentManagementSystem__c ObjCms = lstDashboardSec[0];
                if(lstUser != null && lstUser.size()>0)
                {
                    strHeaderName = ObjCms.acfHeading__c.replace('<User Name>',lstUser[0].Name);
                }
               
                strDescriptionName = ObjCms.acfDescription__c;         
            }
     }
}