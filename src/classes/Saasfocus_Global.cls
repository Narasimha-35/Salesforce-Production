// ----------------------------------------------------------------------------------
// This Class is used for convert the Google Event id in different Format

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       21 April 2015        Ashutosh Kumar         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// 
// ----------------------------------------------------------------------------------
//
//

Public class Saasfocus_Global
{
public static Boolean GoogleSyncProces=False;

// This method is used for getting the GoogleCalendar Id
    public static String getGoogleId(String Calid)
    {
        String []Idarray=Calid.split('~');
        return(Idarray[0]);
    }
    
// This method is used for set the GoogleCalendar id and Broker Email id (Exa. Id~Emailid)
    public static String setGoogleId( String Calid, String BrokerEmail,string st)
    {
      return(Calid+'~'+BrokerEmail);
    }
    
    Public static string getUnallocatedBrokerName()
    {
        Google_API_Setting__c Gsetting = Google_API_Setting__c.getValues('Google_Setting');
        return Gsetting.Unallocated_Broker_Name__c;
    }

// This method is used for set the GoogleCalendar id and Broker Email id in specific format for delete the event from Salesforce(For Recurring Event Only)
    public static String recurid(String Calid,Datetime dt)
    {
         String newstr; 
         String st;
         TimeZone tz= UserInfo.getTimeZone();
         Integer hh= (tz.getOffset(dt))/(1000*60);
         st= String.ValueOf(dt.addMinutes(-hh));
         String []Idarray=Calid.split('~');
         st= st.replace('-','');
         st=st.replace(':','');
         st=st.replace(' ','T');
         if(Idarray[0].contains('_R'))
         {
             newstr=Idarray[0].substringBefore('_R'); 
         }
         else
         {
          newstr=Idarray[0];
         }
        return(newstr+'_'+st+'Z'+'~'+Idarray[1]);
    }
}