public class CallCoreApi {

    public boolean  showavm { get; set; }
   String pId  ;
    public void getPropertyAVM() {
    
            CoreLogic obj = new CoreLogic();
             pId =propertyval ;
            propertyval  = ' {"propertyId": '+pId +' ,"targetPropertyAvmInput": { "bathrooms": 0, "bedrooms": 0,"carSpaces": 0, "craftsmanshipQuality": "MUCH_BETTER","floorAreaM2": 0,"landAreaM2": 0,'+
            +' "propertyType": "BUSINESS",'+
            + '"saleDate": "",'+
            + '"salePrice": 0,'+
            +'  "valuationDate": "",'+
            + ' "yearBuilt": 0'+
            +'}'+
            +'}';

        if(propertyval != null ){
        List<Avm_Property__c> avmObj = [Select id ,Fares_FSD_Score__c, propertyId__c ,Fares_Score__c ,Fares_ValuationDate__c ,Expiry_date__c,Fares_Value_High__c ,Fares_Value_Low__c,Fares_Value_Estimate__c
        from Avm_Property__c where propertyId__c = : Integer.valueof(pid)] ;
        if(avmObj.size() > 0 ){
        DateTime dt = system.now();
        if(avmObj[0].Expiry_date__c  < dt){
            System.debug(avmObj[0].Expiry_date__c);
        UpdateAVmRecord(propertyval,avmObj[0].id );

        }else{
        avmFaresDetail aObj =new avmFaresDetail();
            System.debug(avmObj[0].Expiry_date__c);
        aObj.faresFSDScore =avmObj[0].Fares_FSD_Score__c ;
        aObj.faresScore  = avmObj[0].Fares_Value_Estimate__c;
        aObj.faresValuationDate = avmObj[0].Fares_ValuationDate__c ;
        aObj.faresValueEstimate = avmObj[0].Fares_Value_Estimate__c;
        aObj.faresValueHigh =avmObj[0].Fares_Value_High__c;
        aObj.faresValueLow = avmObj[0].Fares_Value_Low__c;
        temp = aObj ;
        System.debug(temp);
          showavm = true;

        }

        }
        else
        {
        insertnewAVmRecord(propertyval);
        

        }
        propertyval =  pId ;
        }
    }
    public void insertnewAVmRecord(String propId){
       
      CoreLogic obj = new CoreLogic();
        avmres = obj.getPropertyAVM(propId ) ;
     JSONParser parser = JSON.createParser(avmres );
      Avm av = (Avm)parser.readValueAs(Avm.class);
     showavm = true;
      temp = av.avmFaresDetail ;
      Avm_Property__c aobj = new Avm_Property__c();
      aobj.propertyId__c= Integer.valueof( pId);
      aobj.Fares_FSD_Score__c = temp.faresFSDScore ;
      aobj.Fares_Value_Estimate__c = temp.faresScore ;
      aobj.Fares_ValuationDate__c = temp.faresValuationDate ;
      aobj.Fares_Value_Estimate__c = temp.faresValueEstimate ;
      aobj.Fares_Value_High__c = temp.faresValueHigh ;
      aobj.Fares_Value_Low__c = temp.faresValueLow ;
      insert aobj;
       
    }
    
    
    public void UpdateAVmRecord(String propId ,Id id){
       
      CoreLogic obj = new CoreLogic();
        avmres = obj.getPropertyAVM(propId ) ;
     JSONParser parser = JSON.createParser(avmres );
      Avm av = (Avm)parser.readValueAs(Avm.class);
     showavm = true;
      temp = av.avmFaresDetail ;
      Avm_Property__c aobj = new Avm_Property__c();
      aobj.propertyId__c= Integer.valueof(pId);
      aobj.Fares_FSD_Score__c = temp.faresFSDScore ;
      aobj.Fares_Value_Estimate__c = temp.faresScore ;
      aobj.Fares_ValuationDate__c = temp.faresValuationDate ;
      aobj.Fares_Value_Estimate__c = temp.faresValueEstimate ;
      aobj.Fares_Value_High__c = temp.faresValueHigh ;
      aobj.Fares_Value_Low__c = temp.faresValueLow ;
      aobj.id = id;
      upsert  aobj;
       
    }

    public String propertyval { get; set; }

    public String tempAddress { get; set; }
     public String Propertid { get; set; }
     public String avmres{ get; set; }


   public void getPropertyId(){
   
   CoreLogic obj = new CoreLogic();
   Propertid = obj.SearchProperty(tempAddress ) ;
   }
   
   public class Avm{
   public avmFaresDetail avmFaresDetail {get ;set ;}
   }
   public avmFaresDetail  temp {get ;set;}
   public class avmFaresDetail {
   
    public string faresFSDScore {get ;set;}
    public string  faresReferenceID {get ;set;}
    public string  faresScore {get ;set;}
    public string  faresValuationDate {get ;set;}
    public string  faresValueEstimate {get ;set;}
    public string  faresValueHigh {get ;set;}
    public string  faresValueLow {get ;set;}
   
   }
}