/* This class will called by the trigger TGRCreateAppointMentOnGoogle   
 * Created Date  08 -04 -2015 
 * Created By : Vidhi Srivastava
 *Used for insert event on Gooogle */ 


  
public with sharing class Saasfocus_GoogleCalenderHelper {
   static Event objAppointment = new Event();
   static List< Event> lstApp = new List< Event>();
   static List< Event> lstAppUP = new List< Event>();
   
   static String request; 
 //  @future(callout = true)

   //------------------------------------------------------------------------------------------------------------------------------------------//
   
   // This Method will make callOut Request and create Data On Google
   // This method will id of event as an argument which are related to the Broker.
   
    public static void processEvent(List<String> ids){
        
          lstApp = [SELECT StartDateTime,EndDateTime,Subject,Location,Description,Google_Event_ID__c,Whatid
                            FROM Event  WHERE Id IN :ids and Whatid != null  LIMIT 100];
          
          
     
            Saasfocus_GenerateToken ob= new Saasfocus_GenerateToken();
           
             Google_API_Setting__c  obj= ob.CheckAccessToken();
         // Google_API_Setting__c  obj =  Google_API_Setting__c.getValues('Google_Setting');     // CustomSetting for getting the key Value
          //AuthenticateCred_Saasfocus objAuthenticateCred = new AuthenticateCred_Saasfocus ();  // Call Authenticate method to verify if the Access token is not expired.
                                                                                               // It will again authenticate it if it will expire
         // objAuthenticateCred.Authenticate();
         try{
         for(Event o: lstApp){
         
             if(o.Google_Event_ID__c != null)
             continue;
             
               Broker__c objbroker= [SELECT Email__c,Name  from Broker__c WHERE id=: o.whatId];                    
               
              
               
               JsonDataForGoogle objJsonDataForGoogle = new JsonDataForGoogle(o);    
                
                String strBody = JSON.serialize(objJsonDataForGoogle); 
                strBody = strBody.replace('dateTime1','dateTime');
                strBody = strBody.replace('end1','end'); 
                List<String> tempArray = new list<String>();
                tempArray  = strBody.split('attendees":');
                //{
                String tempAttendee = tempArray.get(1);
                tempAttendee = 'attendees":['+tempAttendee ;
                tempAttendee =  tempAttendee.subString(0,tempAttendee.length()-1);
                tempAttendee = tempAttendee +']}';
                strBody = tempArray.get(0)+tempAttendee ;
                System.debug(':::::::::::::::'+strBody);
                
                string Endpoint = 'https://www.googleapis.com/calendar/v3/calendars/'+objBroker.Email__c+'/events?sendNotifications=true&key='+obj.API_KEY__c;  
                
                if(o.Google_Event_ID__c != null )
                Endpoint = 'https://www.googleapis.com/calendar/v3/calendars/'+objBroker.Email__c+'/events/'+o.Google_Event_ID__c+'?sendNotifications=true&key='+obj.API_KEY__c;  
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Endpoint);     
                req.setHeader('Content-Type','application/json');
                req.setHeader('Accept','application/x-www-form-urlencoded');
                req.setHeader('Content-length', '200');  
                req.setHeader('Authorization','Bearer '+obj.Access_Token__c);
                req.setBody(strBody);
                
                req.setMethod('POST');
                
                if(o.Google_Event_ID__c != null )
                 req.setMethod('PUT');
                
                request = req.getBody();
                Http http = new Http();
                Httpresponse res = http.send(req);
                system.debug('res ::::::'+res.getBody());
                if(res.getStatusCode() == 200){
                     ParseEventInsertResponse objParseEventInsertResponse = new ParseEventInsertResponse();
                     objParseEventInsertResponse = (ParseEventInsertResponse)JSON.deserialize( res.getBody(),ParseEventInsertResponse.Class);
                     system.debug('objParseEventInsertResponse ::::::'+objParseEventInsertResponse);
                    // o.Google_Event_ID__c = objParseEventInsertResponse.id;
                     o.Google_Event_ID__c = Saasfocus_Global.setGoogleId(objParseEventInsertResponse.id,objBroker.Email__c,String.valueof(o.StartDateTime));
                     lstAppUP.add(o);
                     
                
                }
                else
                {
                   
                    string body='';
                    
                    body+='<h3>Request body </h3>:'+req.getMethod()+' '+req.getEndPoint()+ '<br/>'+req.getBody()+'<br/>';
                    body+='<h3>Response: </h3> Code:'+res.getStatusCode()+'<br/>'+'Error Message: '+res.getBody();
                    mailSend(body);
                }
     
                
         }
          update lstAppUP;
          ob.updategooglesettings();
           }
          catch(Exception ex)
          {
                   
                    string body='';
                    body='Exception: '+ex.getMessage()+', '+'Appointment: '+lstApp; 
                    mailSend(body);
              
          }
    }
    
  
    /* Wrapper Clas for Binding data 
      *For adding any new parameter which should go on google calender , intialize it with this wrapper class first(Declare the variable and map it)  */ 
   
    Public class JsonDataForGoogle {
    public End_Z end1;
    public End_Z start;
    public String description;
    public  Attendee attendees;
    public String summary;
    public String location;
    public String timeZone;
    public Boolean guestsCanModify;
    public Boolean guestsCanInviteOthers;
    
    
         public JsonDataForGoogle (Event obj){
             System.debug('obj :::::::::::'+obj);
              end1 = new End_Z(obj.EndDateTime);
              start = new End_Z(obj.StartDateTime);
              description = obj.Description;
             //attendees = new Attendee('Vidhi123srivastava@gmail.com','Vidhi');
           // attendees = new Attendee(mail,bname);
             
              System.debug('obj :::::::::::'+attendees);
              summary = obj.Subject;
              location = obj.location;
              //timeZone = 'Australia/Sydney';
              guestsCanModify  = true;
              guestsCanInviteOthers =true;
         
        }
      
    }
    
    //  Wrapper for making SF date in GMT format
    
    public class End_Z {
        public String dateTime1;
        
        public End_Z(DateTime timeVal){
            
              dateTime1  = timeVal.formatGMT('yyyy-MM-dd HH:mm:ss');
              System.debug('dateTime1  ++'+dateTime1);
              dateTime1 = dateTime1.trim();
              dateTime1 = dateTime1.replace(' ','T');
              dateTime1 = dateTime1+'Z';
        }
  }
  
  
  
    public class Attendee {
       public String email;
       public String displayName;
      
     
      public Attendee(String demail, String name){
            email = demail;
            displayName = name.stripHtmlTags();
      
      }
   }
   
   // Wrapper class to parse to response of event creation
   public class ParseEventInsertResponse{
        public String id;
   }
    
     public static void mailSend(String body)
   {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toaddress=new List<String>();
        String[] tobcc=new List<String>();
        toaddress.add('chen@creditandfinance.com.au');
        tobcc.add('bijay.negi@saasforce.in');
        mail.setToAddresses(toaddress);
        mail.setBccAddresses(tobcc);
        mail.setSubject('Error on Event Insertion');
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
   }
  
  
}