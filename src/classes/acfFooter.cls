/*====================================================
                Click Loans/White Loan
========================================================*/
//Created by karthik
public without sharing class acfFooter 
{
    public acfContentManagementSystem__c cms_obj {get; set;}
    public list<acfContentManagementSystem__c> lstFooterLinks {get;set;}
    public string selectedLinkId {get;set;}
    public Map<string,string> mapCMSpgid {get;set;} 
    public string pge_name {set; get;}
    public string strPagePreFix {get;set;}
    public acfFooter()
    {
        string NetworkId = Network.getNetworkId();
        Click_Community_Setup__c commSetup = new Click_Community_Setup__c();
        commSetup = ClickCommon.getCommunitySetup(NetworkId);
        strPagePreFix = ClickCommon.URLPrefix;
        
        string pge = Apexpages.currentPage().getUrl();
        List<String> parts = pge.split('/'); 
        List<String> parts1 = parts[2].split('\\?');
        pge_name = parts1[0].toLowerCase(); 
        system.debug('cons pge_name --------'+pge_name);
        
        mapCMSpgid = new map<string,string>();
        if(NetworkId != null)
        { 
            cms_obj = [select id,name,acfDescription__c,acfPageName__c,acfSectionName__c,Click_Community_Setup__c from acfContentManagementSystem__c  where acfPageName__c = 'Common' and acfSectionName__c = 'Footer' and Click_Community_Setup__c =:commSetup.id limit 1]; 
            lstFooterLinks = [select id,name,acfDescription__c,acfPageName__c,acfSectionName__c,acfLink_URL__c,acfIs_Checked__c,acfHeading__c,acfSequence__c,acfHeader_Sequance__c,acfCMS_Page__c from acfContentManagementSystem__c  where acfSectionName__c = 'Footer Links' AND acfIs_Checked__c = true and Click_Community_Setup__c =:commSetup.id order by acfSequence__c];
            for(acfContentManagementSystem__c cmsObj : lstFooterLinks)
            {
                If(cmsObj.acfCMS_Page__c != null)
                {   
                 mapCMSpgid.put(cmsObj.id,cmsObj.acfCMS_Page__c); 
                }
            } 
        }
    }
}