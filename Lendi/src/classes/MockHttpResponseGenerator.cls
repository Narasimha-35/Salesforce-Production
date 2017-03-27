@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/endpoint', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
  
       // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
         string responsebody;
         if(req.getEndpoint().contains('events'))
        responsebody='{ "kind": "calendar#events", "etag": "1429547954097000", "summary": "kripa@getmaxx.in", "updated": "2015-04-20T16:39:14.097Z", "timeZone": "Asia/Calcutta", "accessRole": "owner", "defaultReminders": [  {   "method": "popup",   "minutes": 10  } ], "nextSyncToken": "COiW-Y-phcUCEOiW-Y-phcUCGAU=", "items": [  {   "kind": "calendar#event",   "etag": "2859065505118000",   "id": "rkgah99df4f5ng5cp3ecqtqlt4",   "status": "confirmed",   "htmlLink": "https://www.google.com/calendar/event?eid=cmtnYWg5OWRmNGY1bmc1Y3AzZWNxdHFsdDQga3JpcGFAZ2V0bWF4eC5pbg",   "created": "2015-04-20T12:25:52.000Z",   "updated": "2015-04-20T12:25:52.559Z",   "summary": "KRIPA EVENT",   "creator": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "organizer": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "start": {    "dateTime": "2015-04-22T10:30:00+05:30"   },   "end": {    "dateTime": "2015-04-22T11:30:00+05:30"   },   "iCalUID": "rkgah99df4f5ng5cp3ecqtqlt4@google.com",   "sequence": 0,   "hangoutLink": "https://plus.google.com/hangouts/_/getmaxx.in/kripa?hceid=a3JpcGFAZ2V0bWF4eC5pbg.rkgah99df4f5ng5cp3ecqtqlt4",   "reminders": {    "useDefault": true   }  }     ]}';
         
         if(req.getEndpoint().contains('oauth2'))
           responsebody='{ "access_token": "ya29.XAGyzviCK6ip_L8CYVrJJaNBqZAyxHc0W2c4oyLlvsxfP00UGqRJ9KT95Ga6BNxOBN6CkCu0QbALMWL0q1Zm6mbZ6zXUuIBSitB8_Wd3NjmhOnpO--vsyZTkoy11v6DuTtyWrLQYU93-UA", "token_type": "Bearer", "expires_in": 3600 }';
        
        if(req.getEndpoint().contains('syncToken'))
        responsebody='{ "kind": "calendar#events", "etag": "1429547954097000", "summary": "kripa@getmaxx.in", "updated": "2015-04-20T16:39:14.097Z", "timeZone": "Asia/Calcutta", "accessRole": "owner", "defaultReminders": [  {   "method": "popup",   "minutes": 10  } ],   "nextPageToken": "CigKGm44ZnUxbGJxdGY3MWpzbnNjczdjZml1cDU0GAEggIDA1Ybz1OYUGg0IABIAGID8x5j3jsUC", "items": [  {   "kind": "calendar#event",   "etag": "2859065505118000",   "id": "b9k03792j5oaj8fpk0gh50p54c",   "status": "confirmed",   "htmlLink": "https://www.google.com/calendar/event?eid=cmtnYWg5OWRmNGY1bmc1Y3AzZWNxdHFsdDQga3JpcGFAZ2V0bWF4eC5pbg",   "created": "2015-04-20T12:25:52.000Z",   "updated": "2015-04-20T12:25:52.559Z",   "summary": "KRIPA EVENT",   "creator": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "organizer": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "start": {    "dateTime": "2015-04-22T10:30:00+05:30"   },   "end": {    "dateTime": "2015-04-22T11:30:00+05:30"   },   "iCalUID": "rkgah99df4f5ng5cp3ecqtqlt4@google.com",   "sequence": 0,   "hangoutLink": "https://plus.google.com/hangouts/_/getmaxx.in/kripa?hceid=a3JpcGFAZ2V0bWF4eC5pbg.rkgah99df4f5ng5cp3ecqtqlt4",   "reminders": {    "useDefault": true   }  }     ]}';
        
        
        if(req.getEndpoint().contains('pageToken'))
        responsebody='{ "kind": "calendar#events", "etag": "1429547954097000", "summary": "kripa@getmaxx.in", "updated": "2015-04-20T16:39:14.097Z", "timeZone": "Asia/Calcutta", "accessRole": "owner", "defaultReminders": [  {   "method": "popup",   "minutes": 10  } ], "nextSyncToken": "COiW-Y-phcUCEOiW-Y-phcUCGAU=",   "items": [  {   "kind": "calendar#event",   "etag": "2859065505118000",   "id": "rkgah99df4f5ng5cp3ecqtqlt4",   "status": "confirmed",   "htmlLink": "https://www.google.com/calendar/event?eid=cmtnYWg5OWRmNGY1bmc1Y3AzZWNxdHFsdDQga3JpcGFAZ2V0bWF4eC5pbg",   "created": "2015-04-20T12:25:52.000Z",   "updated": "2015-04-20T12:25:52.559Z",   "summary": "KRIPA EVENT",   "creator": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "organizer": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "start": {    "dateTime": "2015-04-22T10:30:00+05:30"   },   "end": {    "dateTime": "2015-04-22T11:30:00+05:30"   },   "iCalUID": "rkgah99df4f5ng5cp3ecqtqlt4@google.com",   "sequence": 0,   "hangoutLink": "https://plus.google.com/hangouts/_/getmaxx.in/kripa?hceid=a3JpcGFAZ2V0bWF4eC5pbg.rkgah99df4f5ng5cp3ecqtqlt4",   "reminders": {    "useDefault": true   }  }     ]}';
 
        
        //responsebody='{ "kind": "calendar#events", "etag": "1429547954097000", "summary": "kripa@getmaxx.in", "updated": "2015-04-20T16:39:14.097Z", "timeZone": "Asia/Calcutta", "accessRole": "owner", "defaultReminders": [  {   "method": "popup",   "minutes": 10  } ],  "nextPageToken": "CigKGm44ZnUxbGJxdGY3MWpzbnNjczdjZml1cDU0GAEggIDA1Ybz1OYUGg0IABIAGID8x5j3jsUC", "items": [  {   "kind": "calendar#event",   "etag": "2859065505118000",   "id": "rkgah99df4f5ng5cp3ecqtqlt4",   "status": "confirmed",   "htmlLink": "https://www.google.com/calendar/event?eid=cmtnYWg5OWRmNGY1bmc1Y3AzZWNxdHFsdDQga3JpcGFAZ2V0bWF4eC5pbg",   "created": "2015-04-20T12:25:52.000Z",   "updated": "2015-04-20T12:25:52.559Z",   "summary": "KRIPA EVENT",   "creator": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "organizer": {    "email": "kripa@getmaxx.in",    "displayName": "Kripa Sindhu Singh",    "self": true   },   "start": {    "dateTime": "2015-04-22T10:30:00+05:30"   },   "end": {    "dateTime": "2015-04-22T11:30:00+05:30"   },   "iCalUID": "rkgah99df4f5ng5cp3ecqtqlt4@google.com",   "sequence": 0,   "hangoutLink": "https://plus.google.com/hangouts/_/getmaxx.in/kripa?hceid=a3JpcGFAZ2V0bWF4eC5pbg.rkgah99df4f5ng5cp3ecqtqlt4",   "reminders": {    "useDefault": true   }  }     ]}';
 
        res.setBody(responsebody);
        res.setStatusCode(200);
        return res;
    }
}