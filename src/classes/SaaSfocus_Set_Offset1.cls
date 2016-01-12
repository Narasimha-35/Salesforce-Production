// ----------------------------------------------------------------------------------
// This class Distributes the appointment 
// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       16-apr-2015      Vinod Tiwari VT         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// Notes: this class takes region id and updates Sydney Timezone Offset. this class returns offset.
// ----------------------------------------------------------------------------------

public class SaaSfocus_Set_Offset1
{

public Decimal Offset;
public Decimal ReturnOffset;
public decimal Hours;
public list<Region__c> Region_List;

/*This method helps to update the offset */
    public Decimal getRegion( id region_id)
    {
    Region_List=[select Sydney_Timezone_Offset__c from Region__c where id =: region_id];
    for(Region__c reg:Region_List){
        TimeZone tz=TimeZone.getTimeZone('Australia/Sydney');
        DateTime dtpre = System.now();
        Offset =tz.getOffset(dtpre);
        Hours=(Offset/1000)/3600;    // This line changes timezone offset to hours.
       
       /*This line checks null condition, and asssigns hours to offset field*/
       
        if(reg.Sydney_Timezone_Offset__c!=null)
            reg.Sydney_Timezone_Offset__c = Hours+ reg.Sydney_Timezone_Offset__c;
        else{
            reg.Sydney_Timezone_Offset__c = Hours;
            }
    ReturnOffset=reg.Sydney_Timezone_Offset__c;
    }
    update Region_List;
    return ReturnOffset;
    }
    
}