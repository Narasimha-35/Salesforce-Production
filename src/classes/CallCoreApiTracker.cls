@isTest(seealldata = true)
private class CallCoreApiTracker {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorPropertyId());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
      
        CallCoreApi obj = new CallCoreApi();
        obj.tempAddress= 'dsdssd';
      
         obj.getPropertyId();
           obj.propertyval = obj.Propertid;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAVm());
        obj.getPropertyAVM();
      

       
    }
    
    @isTest static void testCalloeeut() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorPropertyId());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
      
        CallCoreApi obj = new CallCoreApi();
        obj.tempAddress= 'dsdssd';
      
        obj.pid ='123212';
        
         
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAVm());
        obj.propertyval ='12321';
        obj.insertnewAVmRecord(obj.propertyval);

       
    }
    
    
    
}