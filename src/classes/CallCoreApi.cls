public class CallCoreApi {

    public boolean  showavm { get; set; }
    public Double Range { get; set; }
   String pId  ;
   map<String, String> mapdata = new map<String,String>();
    public CallCoreApi(){
    String Queensland  ='Queensland Data \n';
    Queensland  = Queensland + 'Based on or contains data provided by the State of Queensland (Department of Natural Resources and Mines) 2016. In consideration of the State permitting  \n' ;
    Queensland  = Queensland+'use of this data you acknowledge and agree that the State gives no warranty in relation to the data (including accuracy, reliability, completeness, \n';
    Queensland  = Queensland+'currency or suitability) and accepts no liability (including without limitation, liability in negligence) for any loss, damage or costs (including  \n';
    Queensland  = Queensland+' consequential damage) relating to any use of the data. Data must not be used for direct marketing or be used in breach of the privacy laws.';
    mapdata.put('Queensland',Queensland);
    
    String SouthAustralian = 'South Australian Data \n';
    SouthAustralian  =SouthAustralian +'© 2016 Copyright in this information belongs to the South Australian Government and the South Australian Government does \n ';
    SouthAustralian = SouthAustralian +'not accept any responsibility for the accuracy or completeness of the information or its suitability for purpose.';
    mapdata.put('SouthAustralian',SouthAustralian);
    
    String NewSouthWales ='New South Wales Data \n';
    NewSouthWales = NewSouthWales +'contains property sales information provided under licence from the Land and Property Information (“LPI”). RP Data Pty Ltd  \n';
    NewSouthWales = NewSouthWales +'trading as CoreLogic is authorised as a Property Sales Information provider by the LPI.';
    mapdata.put('NewSouthWales',NewSouthWales);
    String Victorian  = 'Victorian Data \n';
    Victorian =Victorian +'The State of Victoria owns the copyright in the Property Sales Data and reproduction of that data in any way without the \n';
    Victorian = Victorian +'consent of the State of Victoria will constitute a breach of the Copyright Act 1968 (Cth). The State of Victoria does not warrant \n ';
    Victorian = Victorian +'the accuracy or completeness of the Property Sales Data and any person using or relying upon such information does so on \n';
        Victorian = Victorian +'the basis that the State of Victoria accepts no responsibility or liability whatsoever for any errors, faults, defects or omissions in \n';
        
    Victorian = Victorian +'the information supplied.';

    mapdata.put('Victorian',Victorian);
    String WesternAustralian ='Western Australian Data \n';
    WesternAustralian  =WesternAustralian +'Based on information provided by and with the permission of the Western Australian Land Information Authority (2016) trading as Landgate. \n';
    WesternAustralian = WesternAustralian +'Australian Capital Territory Data \n';
    WesternAustralian = WesternAustralian +'The Territory Data is the property of the Australian Capital Territory. No part of it may in any form or by any means (electronic, \n';
        WesternAustralian = WesternAustralian +'without prior written permission. Enquiries should be directed to: Director, Customer Services ACT Planning and Land \n';
        
    WesternAustralian = WesternAustralian +'Authority GPO Box 1908 Canberra ACT 2601.';

    mapdata.put('WesternAustralian',WesternAustralian);
    String Tasmanian   = 'Tasmanian Data /n';
    Tasmanian   =Tasmanian  +'This product incorporates data that is copyright owned by the Crown in Right of Tasmania. The data has been used in the \n';
    Tasmanian  = Tasmanian  +'product with the permission of the Crown in Right of Tasmania. The Crown in Right of Tasmania and its employees and agents: \n';
    Tasmanian  = Tasmanian  +'(a) give no warranty regarding the data\'s accuracy, completeness, currency or suitability for any particular purpose and \n';
        Tasmanian  = Tasmanian  +'(b) do not accept liability howsoever arising, including but not limited to negligence for any loss resulting from the use of or reliance upon the data.\n ';
        
    Tasmanian  = Tasmanian  +'Base data from the LIST © State of Tasmania http://www.thelist.tas.gov.au';

    mapdata.put('Tasmanian ',Tasmanian );
    
     String AustralianCapitalTerritory   = 'Australian Capital Territory Data/n';
    AustralianCapitalTerritory   =AustralianCapitalTerritory  +'The Territory Data is the property of the Australian Capital Territory. No part of it may in any form or by any means (electronic,  \n';
    AustralianCapitalTerritory  = AustralianCapitalTerritory  +'mechanical, microcopying, photocopying, recording or otherwise) be reproduced, stored in a retrieval system or transmitted \n';
    AustralianCapitalTerritory  = AustralianCapitalTerritory  +'without prior written permission. Enquiries should be directed to: Director, Customer Services ACT Planning and Land  \n';
        AustralianCapitalTerritory  = AustralianCapitalTerritory  +'Authority GPO Box 1908 Canberra ACT 2601. \n ';
        
   

    mapdata.put('AustralianCapitalTerritory',AustralianCapitalTerritory);
    
    }
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
        if(avmObj[0].Fares_Value_High__c != null && avmObj[0].Fares_Value_Low__c != null )
        Range  = double.valueof(avmObj[0].Fares_Value_High__c) -  double.valueof(avmObj[0].Fares_Value_Low__c);
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
      if(temp.faresValueHigh != null && temp.faresValueLow != null )
        Range  = double.valueof(temp.faresValueHigh ) -  double.valueof(temp.faresValueLow );
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
      if(temp.faresValueHigh != null && temp.faresValueLow != null )
        Range  = double.valueof(temp.faresValueHigh ) -  double.valueof(temp.faresValueLow );
      upsert  aobj;
       
    }

    public String propertyval { get; set; }

    public String tempAddress { get; set; }
     public String Propertid { get; set; }
     public String avmres{ get; set; }
      public String StateMessgae { get; set; }


   public void getPropertyId(){
   
   CoreLogic obj = new CoreLogic();
   Propertid = obj.SearchProperty(tempAddress ) ;
   if(tempAddress.containsIgnoreCase('QLD')  || tempAddress.containsIgnoreCase('Queensland')  )
       StateMessgae =mapdata.get('Queensland');
   if(tempAddress.containsIgnoreCase('SouthAustralian')  || tempAddress.containsIgnoreCase('SA') )
       StateMessgae =mapdata.get('SouthAustralian');
   if(tempAddress.containsIgnoreCase('NewSouthWales')  || tempAddress.containsIgnoreCase('NSW') )
       StateMessgae =mapdata.get('NewSouthWales');
    if(tempAddress.containsIgnoreCase('NewSouthWales')  || tempAddress.containsIgnoreCase('NSW') )
       StateMessgae =mapdata.get('NewSouthWales');
    if(tempAddress.containsIgnoreCase('Victorian')  || tempAddress.containsIgnoreCase('VIC') )
       StateMessgae =mapdata.get('Victorian');
   if(tempAddress.containsIgnoreCase('WesternAustralian')  || tempAddress.containsIgnoreCase('WA') )
       StateMessgae =mapdata.get('WesternAustralian');
   if(tempAddress.containsIgnoreCase('ACT')  )
       StateMessgae =mapdata.get('AustralianCapitalTerritory');
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