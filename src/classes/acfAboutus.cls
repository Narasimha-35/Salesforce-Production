/*=============================================
			Click Loans
================================================*/
//Created by karthik on 14-04-2015
public without sharing class acfAboutus 
{
    public list<acfContentManagementSystem__c> lstAboutUs {get;set;}
    public string strPagetitle {get;set;}
    public string strDescription {get;set;}
    public acfAboutUs()
    {     
        strPagetitle = '';
        strDescription = '';
        try{
            lstAboutUs = [select acfDescription__c,acfShort_Description__c ,acfIs_Checked__c ,acfHeadingRemoveSpace__c, acfHeading__c, acfImageURL__c, acfMoreDetailURL__c, acfSectionName__c, acfSequence__c,acfDescriptionImageURL__c, Id, Name,acfHeading_Caption__c FROM acfContentManagementSystem__c WHERE acfSectionName__c = 'About Us' AND acfIs_Checked__c = true ORDER BY acfSequence__c ASC NULLS FIRST]; 
            list<acfCMS_Page__c> lstCSMPage = [select id,name,acfDescription__c,acfHeading__c from acfCMS_Page__c where name = 'clickaboutus' limit 1];
            if(lstCSMPage != null && lstCSMPage.size()>0)
            {
                strPagetitle = lstCSMPage[0].acfHeading__c;
                strDescription = lstCSMPage[0].acfDescription__c;
            }
        }catch(Exception Ex){
            system.debug('@@@@@@@@@'+ex);
        }
    }
}