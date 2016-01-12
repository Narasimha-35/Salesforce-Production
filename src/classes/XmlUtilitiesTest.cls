@isTest(SeeAllData=true)
private class XmlUtilitiesTest {

    static testMethod void getAPIKeyFromPardotTest() {
        // Create the request envelope
        DOM.Document doc1 = null;
        DOM.Document doc2 = new DOM.Document();
        
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        String serviceNS = 'http://www.myservice.com/services/MyService/';
        
        dom.Xmlnode rsp = doc2.createRootElement('rsp', soapNS, 'rsp');
     	rsp.setNamespace('xsi', xsi);
     	rsp.setAttributeNs('stat', 'ok', 'ok', 'ok');
     	
     	dom.XmlNode apiKey = rsp.addChildElement('api_key', 'test', 'test');
     	
     	String apikeyResult = XmlUtilities.getAPIKeyFromPardot(doc2);
     	String apikeyResult2 = XmlUtilities.getAPIKeyFromPardot(doc1);
     	System.assert(apikeyResult != null);
     	System.assert(apikeyResult2 == null);
    }
    
    static testMethod void getAccountBalanceFromDNCTest() {
    	String xmlToParse = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:GetAccountBalanceResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem"><GetAccountBalanceReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap"><AccountBalance ErrorCode="0" TelemarketerId="17897" WashOnlyUserId="">14950</AccountBalance></GetAccountBalanceReturn></ns1:GetAccountBalanceResponse></soapenv:Body></soapenv:Envelope>';
    	DOM.Document doc = new DOM.Document();
   		String abc;
   		try {
   			doc.load(xmlToParse);
   			abc = XmlUtilities.getAccountBalanceFromDNC(doc);
   		} catch (System.XMLException e) {
   			System.debug(e.getMessage());
   		}
   		System.assert(abc != null);
   		System.assertEquals(abc, '14950');
    }
}