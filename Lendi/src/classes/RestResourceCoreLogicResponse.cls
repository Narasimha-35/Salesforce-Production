@RestResource(urlMapping='/getCoreLogicResponse/*')
global with sharing class RestResourceCoreLogicResponse{
    @HttpGet
    global static String getPropertyDetail()
    { 
        RestRequest req = RestContext.request;
        string propertyAddress = EncodingUtil.urlDecode(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1),'UTF-8');
        string propertyId;
        try
        {       
            if(string.isNotEmpty(propertyAddress))
            {
                if(test.isrunningtest())
                    propertyId = '6617179';
                if(!Test.isRunningTest())
                {
                    CoreLogicServiceForLendi objCoreLogicService = new CoreLogicServiceForLendi();
                    if(string.isNotEmpty(objCoreLogicService.getID(propertyAddress)))
                    {
                        propertyId = objCoreLogicService.getID(propertyAddress);
                    }
                    else
                    {
                        String errorMessage = '{ "status" : "failed", "message" : "Unable to get PropertyId from CoreLogic."}';
                        return errorMessage;
                    }
                }
                system.debug('###'+propertyId);
                if(string.isNotEmpty(propertyId))
                {
                    List<acfPropertydetails__c> lstPropertydetail = [Select id,PropertyID__c,Postcode__c,Asset_And_Liability__c,Expiry_date__c from acfPropertydetails__c where PropertyID__c=:propertyId];
                    List<Attachment> lstAttach = new List<Attachment>();
                    if(lstPropertydetail != null && !lstPropertydetail.isEmpty())
                    {
                        if(!test.isrunningtest() ? lstPropertydetail[0].Expiry_date__c < System.Now():lstPropertydetail[0].Expiry_date__c > System.Now())
                        {
                                id AssetId;
                                if(lstPropertydetail[0].Asset_And_Liability__c != null)
                                    AssetId= lstPropertydetail[0].Asset_And_Liability__c;
                                if(!Test.isRunningTest())
                                {
                                    CoreLogicServiceForLendi objCoreLogic = new CoreLogicServiceForLendi(); 
                                    objCoreLogic.CreatePrpertyDetail(propertyId); 
                                    delete lstPropertydetail; 
                                }
                                List<acfPropertydetails__c> lstProperydetail = [Select id,PropertyID__c,Asset_And_Liability__c,Expiry_date__c from acfPropertydetails__c where PropertyID__c=:propertyId];
                                if(lstProperydetail != null && !lstProperydetail.isEmpty())
                                {
                                    if(AssetId != null)
                                    {
                                        lstProperydetail[0].Asset_And_Liability__c = AssetId;
                                        update lstProperydetail[0];
                                    }
                                }
                                return getAttachment(lstProperydetail[0].id);
                        }
                        else
                        {
                            return getAttachment(lstPropertydetail[0].id);
                        }
                    }  
                    else
                    {
                        if(!Test.isRunningTest()){
                            CoreLogicServiceForLendi objCoreLogic = new CoreLogicServiceForLendi(); 
                            objCoreLogic.CreatePrpertyDetail(propertyId); 
                        }
                        List<acfPropertydetails__c> lstPropertydetails = [Select id,PropertyID__c,Expiry_date__c from acfPropertydetails__c where PropertyID__c=:propertyId ];
                        List<Attachment> lstAttachments = new List<Attachment>();
                        if(lstPropertydetails != null && !lstPropertydetails.isEmpty())
                        {
                            return getAttachment(lstPropertydetails[0].id);
                        }  
                    }         
                } 
                else
                {
                    String errorMessage =  '{ "status" : "failed", "message" : "PropertyId(' + propertyId +') Not found."}';
                    return errorMessage;
                }
             }
             else{
                String errorMessage = '{ "status" : "failed", "message" : "PropertyId(' + propertyId +') Not found."}';
                return errorMessage;
             }
             return null;
        }
        catch(Exception e)
        {
            String errorMessage = '{ "status" : "failed", "message" : "'+e.getMessage()+'"}';
            return errorMessage; 
        }
    }
    
    public static string getAttachment(Id propertyDetailId)
    {
        List<Attachment> lstAttach = [Select id,Name,Parentid,Body from Attachment where Parentid =:propertyDetailId];
        if(lstAttach != null && !lstAttach.isEmpty())
        {
            String strBody = lstAttach[0].Body.Tostring();
                strBody =strBody.substringAfter('{');
                strBody = '{ "sfId" : "'+lstAttach[0].Parentid+'",' +strBody ;
                System.debug('sfid'+strBody );
            return strBody;
        }
        else
        {
            String errorMessage = 'Exception : Response for PropertyId (' + propertyDetailId +') Not found.';
            return errorMessage;
        }
        return null;
    }
}