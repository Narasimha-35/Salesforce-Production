/*=================================================
				Click Loans
=====================================================*/
public without sharing class clickFooterLinkController
{
    public list<acfContentManagementSystem__c> lstFooterLink {get;set;}
    public string strPagetitle {get;set;}
    public string strDescription {get;set;}
    public clickFooterLinkController()
    {    
        strPagetitle = '';
        strDescription = '';
        string strCMSPageId = apexpages.currentpage().getparameters().get('pid');
        try{
            lstFooterLink = [select acfDescription__c,acfShort_Description__c ,acfIs_Checked__c ,acfHeadingRemoveSpace__c, acfHeading__c, acfImageURL__c, acfMoreDetailURL__c, acfSectionName__c, acfSequence__c,acfDescriptionImageURL__c, Id, Name,acfHeading_Caption__c,acfCMS_Page__c FROM acfContentManagementSystem__c WHERE acfCMS_Page__c =: strCMSPageId AND acfIs_Checked__c = true AND acfSectionName__c != 'Footer Links' AND acfSectionName__c = 'Footer Link Content' ORDER BY acfSequence__c ASC NULLS FIRST]; 
            list<acfCMS_Page__c> lstCSMPage = [select id,name,acfDescription__c,acfHeading__c from acfCMS_Page__c where id =:strCMSPageId limit 1];
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