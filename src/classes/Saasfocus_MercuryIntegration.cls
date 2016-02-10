public class Saasfocus_MercuryIntegration {
    Public string token;
    Public List<String> BrokeruniqueID;
    public map<String,string> CAmap{get;set;}
    public Saasfocus_MercuryIntegration() {
        GetBrokerCAid();
    }

    public void GetBrokerCAid() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.connective.com.au/api/mercury5/' + MercuryAuth.getInstance().getToken() + '/associate?actionType=getAssociates&companyId=All&page=1&start=0&limit=25');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        List<Object> items = new List<Object>();
        if((res.getBody().contains('associateList'))) {
            Map<String, Object> EventRes = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());

            items = (List<Object>)EventRes.get('associateList');
            BrokeruniqueID = new List<String>();
            CAmap = new Map<String,string>();
            for (Object item : items) {
                Map<String, Object> Event_item = (Map<String, Object>)item;
                //BrokeruniqueID.add((String)Event_item.get('uniqueId'));
                CAmap.put((String)Event_item.get('email'),(String)Event_item.get('uniqueId'));
            }
        }
        List<Broker__c> lstbroker=new List<Broker__c>();
        List<Broker__c> lstupdateborker=new List<broker__c>();
        lstBroker=[select   CAid__c,Email__c from Broker__c];
        for(Broker__c brokerobj: lstBroker) {
            if(CAmap.containsKey(brokerobj.Email__c)){
                brokerobj.CAid__c=CAmap.get(brokerobj.Email__c);
                lstupdateborker.add(brokerobj);

            }
        }

        update lstupdateborker;
        system.debug('===>'+CAmap);
        //return CAmap;
    }
}
