// ----------------------------------------------------------------------------------
// This Class is used for seprate the working of the Trigger(TGR_CreateEventOnGoogleCalender) and the class(Saasfocus_GoogleSyncEvent)

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
public static String recurid(String Calid,Datetime dt)
    {
     String st;
     TimeZone tz= UserInfo.getTimeZone();
     Integer hh= (tz.getOffset(dt))/(1000*60*60);
     system.debug('TTTTT'+hh);
     if(hh==10){
     st= String.ValueOf(dt.addHours(-hh));
     }
     else
     {
     //hh= hh+1;
     st= String.ValueOf(dt.addHours(-hh));
     }
     system.debug('HHHHHHH'+st);
    String []Idarray=Calid.split('~');
    st= st.replace('-','');
    st=st.replace(':','');
    st=st.replace(' ','T');
    system.debug('IDDDD'+Idarray[0]+'_'+st+'Z'+'~'+Idarray[1]);
    return(Idarray[0]+'_'+st+'Z'+'~'+Idarray[1]);
    }
}