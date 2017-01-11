@isTest(SeeAllData=true)
private class TestAPICalculateInsurranceAmount {

    static testMethod void myDoPost() {
        APICalculateInsurranceAmount.ResultWithStatus result = new APICalculateInsurranceAmount.ResultWithStatus();
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
    	req.params.put('insuranceType', 'life');
    	req.params.put('ageNextBday', '29');
    	req.params.put('totalAmountInsurance', '150000');
    	req.params.put('gendar', 'male');
    	req.params.put('isSmoker', 'true');
    	req.requestURI = 'https://cs5.salesforce.com/services/apexrest//NobleOak/InsuranceCalculation/';
    	req.httpMethod = 'POST';
    	RestContext.request = req;
    	RestContext.response = res;
    	result = APICalculateInsurranceAmount.doPost();
    	System.debug('1 ' + result);
    	
    	RestRequest req1 = new RestRequest(); 
    	RestResponse res1 = new RestResponse();
    	req1.params.put('ageNextBday', '29');
    	req1.params.put('totalAmountInsurance', '150000');
    	req1.params.put('gendar', 'male');
    	req1.params.put('isSmoker', 'true');
    	req1.requestURI = 'https://cs5.salesforce.com/services/apexrest//NobleOak/InsuranceCalculation/';
    	req1.httpMethod = 'POST';
    	RestContext.request = req1;
    	RestContext.response = res1;
    	result = APICalculateInsurranceAmount.doPost();
    	System.debug('2 ' + result);
    	
    	RestRequest req2 = new RestRequest(); 
    	RestResponse res2 = new RestResponse();
    	req2.params.put('insuranceType', 'xxx');
    	req2.params.put('ageNextBday', '29');
    	req2.params.put('totalAmountInsurance', '150000');
    	req2.params.put('gendar', 'male');
    	req2.params.put('isSmoker', 'true');
    	req2.requestURI = 'https://cs5.salesforce.com/services/apexrest//NobleOak/InsuranceCalculation/';
    	req2.httpMethod = 'POST';
    	RestContext.request = req2;
    	RestContext.response = res2;
    	result = APICalculateInsurranceAmount.doPost();
    	System.debug('3 ' + result);
    	
    	RestRequest req3 = new RestRequest(); 
    	RestResponse res3 = new RestResponse();
    	req3.params.put('insuranceType', 'xxx');
    	req3.params.put('totalAmountInsurance', '150000');
    	req3.params.put('gendar', 'male');
    	req3.params.put('isSmoker', 'true');
    	req3.requestURI = 'https://cs5.salesforce.com/services/apexrest//NobleOak/InsuranceCalculation/';
    	req3.httpMethod = 'POST';
    	RestContext.request = req3;
    	RestContext.response = res3;
    	result = APICalculateInsurranceAmount.doPost();
    	System.debug('3 ' + result);
    }
}