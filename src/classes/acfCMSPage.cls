/*====================================================
				Click Loans
========================================================*/
public class acfCMSPage {

    public acfContentManagementSystem__c cms_obj {get; set;}
    public id CMSId;
    public string err_msg {get; set;}
    
    transient Attachment attach_obj;
    transient Attachment attach_obj1;
    
    public  Attachment getattach_obj(){ 
       if(attach_obj == null)
           attach_obj = new Attachment();
       return attach_obj;
    }
    
    public  Attachment getattach_obj1() 
    { 
       if(attach_obj1 == null)
           attach_obj1 = new Attachment();
       return attach_obj1;
    }
    Public pagereference changeEvent()
    {
     return null;
    }
    
    /*public  Attachment attach_obj {
        get {
            if (attach_obj == null)
                attach_obj = new Attachment();
            return attach_obj;
        }
        set; 
    }*/
    
    /*public Attachment attach_obj1 {
        get {
            if (attach_obj1 == null)
                attach_obj1 = new Attachment();
            return attach_obj1;
        }
        set; 
    }*/
    
    public acfCMSPage(ApexPages.StandardController controller) {
        CMSId= apexpages.currentpage().getparameters().get('id');
        err_msg = '';
        if(CMSId != null){
            cms_obj = [select id,name,acfHeading__c,acfPageName__c,acfSectionName__c,acfSequence__c,acfDescription__c,acfIs_Checked__c,acfLink_URL__c,acfHeader_Sequance__c,acfCMS_Page__c,acfShort_Description__c,acfHeading_Caption__c from acfContentManagementSystem__c where id =: CMSId];
        }else{
            cms_obj = new acfContentManagementSystem__c();
        }        
    }
    
    public pagereference mySave()
    {
        PageReference Page_Ref;
        err_msg = '';
        system.debug('@@@@@@karthik'+attach_obj+'========='+attach_obj1+'====='+CMSId);
        if(CMSId != null){
            if(attach_obj != null && attach_obj.body != null)
            {
                attach_obj.parentid = CMSId;
                attach_obj.name = 'Heading.jpg';
                system.debug('attach_obj.body != null------------');
                if(attach_obj.BodyLength <= 10485760){
                    system.debug('attach_obj.BodyLength------------'+attach_obj.BodyLength);
                    insert attach_obj;
                    cms_obj.acfAttachmentId__c = attach_obj.id;
                }else{
                    err_msg = 'acfImageLessthen10MB';
                }
            }
            if(attach_obj1 != null && attach_obj1.body != null){
                attach_obj1.parentid = CMSId;
                attach_obj1.name = 'Description.jpg';
                if(attach_obj1.BodyLength <= 10485760){
                    insert attach_obj1;
                    cms_obj.acfDescriptionAttachmentID__c = attach_obj1.id;
                }else{
                    err_msg = 'acfImageLessthen10MB';
                }
            }
           
            system.debug('cms_obj ----------- '+cms_obj);
            system.debug('err_msg ----------- '+err_msg);
            if(err_msg != ''){
                return null;                                    
            }else{
                update cms_obj;
                Page_Ref = new ApexPages.StandardController(cms_obj).view();
                Page_Ref.setRedirect(true);
                return Page_Ref;
            }                   
            
        }else{
            insert cms_obj;
            If(attach_obj != null && attach_obj.body != null)
            {
                system.debug('attach_obj.name----------------'+attach_obj.name);
                attach_obj.parentid = cms_obj.id;
                attach_obj.name = 'Heading.jpg';  
                if(attach_obj.BodyLength <= 10485760){
                    insert attach_obj;
                    cms_obj.acfAttachmentId__c = attach_obj.id;
                    update cms_obj;
                }else{
                    err_msg = 'acfImageLessthen10MB';
                }
            }
            if(attach_obj1 != null && attach_obj1.body != null)
            {
                attach_obj1.name = 'Description.jpg';
                attach_obj1.parentid = cms_obj.id;
                if(attach_obj1.BodyLength <= 10485760)
                {
                    insert attach_obj1;
                    cms_obj.acfDescriptionAttachmentID__c = attach_obj1.id;
                    update cms_obj;
                }else{
                    err_msg = 'acfImageLessthen10MB';
                }  
            }
           }
            if(err_msg != '')
            {
                return null;                                    
            }else{
                system.debug('swati error msg' +err_msg);
                update cms_obj;
                Page_Ref = new ApexPages.StandardController(cms_obj).view();
                Page_Ref.setRedirect(true);
                return Page_Ref;
            }
        }  
        //return Page_Ref;
    }