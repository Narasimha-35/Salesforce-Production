public class clsCoreLogicServicesHelper {
    public static void CreateRpdata( List<Asset_And_Liability__c> lstobj ) {
        CoreLogicServices obj1 = new CoreLogicServices();
       // List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
        List<Asset_And_Liability__c>  lstAsst = new List<Asset_And_Liability__c> ();
        List<Avm_Property__c>  lstAvm = new List<Avm_Property__c>();
        map<Decimal,List<Avm_Property__c> >  mapAvm = new map<Decimal,List<Avm_Property__c>>();
        List<Avm_Property__c> lstavmObj = [Select  Asset_And_Liability__c,Status__c,id ,Fares_FSD_Score__c, propertyId__c ,Fares_Score__c ,Fares_ValuationDate__c ,Expiry_date__c,Fares_Value_High__c ,Fares_Value_Low__c,Fares_Value_Estimate__c
        from Avm_Property__c where propertyId__c != Null] ;
        for(Avm_Property__c avm : lstavmObj){
            if(avm.propertyId__c != null  &&  !mapAvm.containskey(avm.propertyId__c)){
                List<Avm_Property__c> avmObjTemp = new List<Avm_Property__c> ();
                avmObjTemp.add(avm);
                mapAvm.put(avm.propertyId__c , avmObjTemp);
            }
            else{
                if(avm.propertyId__c != null)
                mapAvm.get(avm.propertyId__c).add(avm);
            }
        }
        map<String,List<Financials_Source__c> >  mapFinancialsSource = new map<String,List<Financials_Source__c>>();
        List<Financials_Source__c> lstFs = [Select id, Asset_And_Liability__c , Amount__c  from Financials_Source__c
        where  Asset_And_Liability__c  != null  and Source__c = 'RPData'];
        for(Financials_Source__c fs : lstFs){
            if(fs.Asset_And_Liability__c != null  &&  !mapFinancialsSource.containskey(fs.Asset_And_Liability__c)){
                List<Financials_Source__c> avmObjTemp = new List<Financials_Source__c> ();
                avmObjTemp.add(fs);
                mapFinancialsSource.put(fs.Asset_And_Liability__c , avmObjTemp);
            }
            else{
                if(fs.Asset_And_Liability__c!= null)
                mapFinancialsSource.get(fs.Asset_And_Liability__c).add(fs);
            }
        }
        List<Financials_Source__c>  lstFinancialsSource = new List<Financials_Source__c> ();
        for(Asset_And_Liability__c  assetObj :  lstobj  )
        {
            try{
            String Propertid ;
            system.debug('###123'+assetObj);
            if(  Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(assetObj.recordtypeid).getname() =='Asset Real Estate' ){
                string address = '';
                system.debug('###Entered RP Data');
                if(string.isNotEmpty(assetObj.Street_Number__c) && string.isNotEmpty(assetObj.Street_Name__c) && string.isNotEmpty(assetObj.Street_Type__c)
                && string.isNotEmpty(assetObj.City__c) && string.isNotEmpty(assetObj.State__c) && assetObj.Postcode__c != null
               )
                {
                    system.debug('###Entered RP Data Inside');
                    Integer assetObjPostcode = Integer.valueof(assetObj.Postcode__c);
                    address = assetObj.Street_Number__c + ' ' + assetObj.Street_Name__c + ' ' + assetObj.Street_Type__c + ' ' ;
                    address += assetObj.City__c + ' ' + assetObj.State__c + ' ' + assetObjPostcode ;
                System.debug('@#$%'+assetObj.Address__c);}
                else{
                    address = assetObj.Address__c ;
                }
                if(address == null)
                {
                    address = '';
                }
                System.debug(address);
                HttpResponse res = obj1.SearchProperty(address );
                if(res.getStatusCode() == 200 ){
                    JSONParser parser = JSON.createParser(res.getBody());
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                        (parser.getText() == 'propertyId')) {
                            parser.nextToken();
                            //if(! Test.isRunningTest())
                            Propertid = parser.gettext();
                        }
                    }
                    System.debug('@@Propertid##'+Propertid);
                    if(Propertid == null){
                        if(address == ''){
                             assetObj.error__C = 'Address is missing';
                           // lstEmails.add(SendRpBatchEmailNotification.sendEmailNotification('Address is missing' , assetObj.id));
                            }else{
                                
                                  assetObj.error__C = 'Unable to get propertyid from CoreLogicServices';
                          //  lstEmails.add(SendRpBatchEmailNotification.sendEmailNotification('Unable to get propertyid from CoreLogicServices' , assetObj.id));
                            }
                        //insert avmObj ;
                    }
                }
                else{
                    if(address == ''){
                          assetObj.error__C = 'Address is missing';
                        //lstEmails.add(SendRpBatchEmailNotification.sendEmailNotification('Address is missing' , assetObj.id));
                        }else{
                            assetObj.error__C = 'Unable to get propertyid from CoreLogicServices';
                        // lstEmails.add(SendRpBatchEmailNotification.sendEmailNotification('Unable to get propertyid from CoreLogicServices' , assetObj.id));
                    }
                    //insert avmObj ;
                }
                if(Propertid != null){
                    String  propertyval = obj1.avmJson(Propertid,'0','0','0','MUCH_BETTER','0','0','BUSINESS','','0','','0');
                    System.debug('@@@@@'+propertyval);
                    if(propertyval != null     )
                    {
                        List<Avm_Property__c> avmObj = new List<Avm_Property__c>();
                        if(mapAvm.get(Decimal.valueof(Propertid)) != null  )
                        avmObj = mapAvm.get(Decimal.valueof(Propertid));
                        System.debug('@@@@@'+avmObj);
                        if(avmObj.size() > 0 ){
                            System.debug('@@@@@'+avmObj.size());
                            DateTime  dt = system.now();
                            if(avmObj[0].Expiry_date__c  < dt){
                                System.debug('@#$ashish'+avmObj[0].Expiry_date__c);
                                HttpResponse avmres = obj1.getPropertyAVM(propertyval ) ;
                                JSONParser parser = JSON.createParser(avmres.getbody());
                                Avm av = (Avm)parser.readValueAs(Avm.class);
                                avmFaresDetail temp = av.avmFaresDetail ;
                                if(temp != null){
                                    Avm_Property__c aobj = new Avm_Property__c();
                                    aobj.propertyId__c= Integer.valueof(Propertid);
                                    aobj.Fares_FSD_Score__c = temp.faresFSDScore ;
                                    aobj.Fares_Value_Estimate__c = temp.faresScore ;
                                    aobj.Fares_ValuationDate__c = temp.faresValuationDate ;
                                    aobj.Fares_Value_Estimate__c = temp.faresValueEstimate ;
                                    aobj.Fares_Value_High__c = temp.faresValueHigh ;
                                    aobj.Fares_Value_Low__c = temp.faresValueLow ;
                                    //aobj.id = avmObj[0].id;
                                    aobj.Asset_And_Liability__c = assetObj.id;
                                    aobj.Property_address__c =address ;
                                    lstAvm.add(aobj);
                                     assetObj.error__C = '';
                                    //upsert  aobj;
                                    List<Financials_Source__c> tempObj1 = mapFinancialsSource.get(assetObj.id);
                                    map<Decimal,Financials_Source__c> setObj = new map<Decimal,Financials_Source__c>();
                                    if(tempObj1 != null  && tempObj1.size() >0){
                                        for(Financials_Source__c fs : tempObj1){
                                            if(fs.Amount__c != null){
                                                setObj.put(Decimal.valueof( temp.faresValueEstimate), fs);
                                            }
                                        }
                                        if( setObj.containskey( Decimal.valueof( temp.faresValueEstimate))){
                                            Financials_Source__c fsObj = setObj.get(Decimal.valueof( temp.faresValueEstimate));
                                            fsObj.Amount__c = Decimal.valueof( temp.faresValueEstimate);
                                            //tempObj1[0].Source__c = 'RPData';
                                            fsObj.Asset_And_Liability__c = assetObj.id;
                                            lstFinancialsSource.add( fsObj );
                                        }
                                        else{
                                            Financials_Source__c tempObj2 = new Financials_Source__c();
                                            if(Decimal.valueof(temp.faresValueEstimate) != null)
                                            tempObj2.Amount__c = Decimal.valueof(temp.faresValueEstimate);
                                            tempObj2.Source__c = 'RPData';
                                            tempObj2.Asset_And_Liability__c = assetObj.id;
                                            lstFinancialsSource.add( tempObj2 );
                                        }
                                    }
                                    else{
                                        Financials_Source__c tempObj2 = new Financials_Source__c();
                                        if(Decimal.valueof(temp.faresValueEstimate) != null)
                                        tempObj2.Amount__c = Decimal.valueof(temp.faresValueEstimate);
                                        tempObj2.Source__c = 'RPData';
                                        tempObj2.Asset_And_Liability__c = assetObj.id;
                                        lstFinancialsSource.add( tempObj2 );
                                    }
                                }
                                else{
                                 //lstEmails.add(SendRpBatchEmailNotification.sendEmailNotification('Unable to get values from Avm Api' , assetObj.id));
                                   assetObj.error__C = 'Unable to get values from Avm Api';
                                }
                            }
                            else{
                                Financials_Source__c tempObj1 = new Financials_Source__c();
                                if(avmObj[0].Fares_Value_Estimate__c != null)
                                tempObj1.Amount__c = Decimal.valueof(avmObj[0].Fares_Value_Estimate__c);
                                tempObj1.Source__c = 'RPData';
                                tempObj1.Asset_And_Liability__c = assetObj.id;
                                lstFinancialsSource.add( tempObj1 );
                                Avm_Property__c aobj = new Avm_Property__c();
                                if(avmObj[0].propertyId__c != null)
                                aobj.propertyId__c= avmObj[0].propertyId__c ;
                                if(avmObj[0].Fares_FSD_Score__c != null)
                                aobj.Fares_FSD_Score__c = avmObj[0].Fares_FSD_Score__c  ;
                                if(avmObj[0].Fares_Value_Estimate__c != null)
                                aobj.Fares_Value_Estimate__c = avmObj[0].Fares_Value_Estimate__c ;
                                if(avmObj[0].Fares_ValuationDate__c != null)
                                aobj.Fares_ValuationDate__c = avmObj[0].Fares_ValuationDate__c ;
                                if(avmObj[0].Fares_Value_Estimate__c != null)
                                aobj.Fares_Value_Estimate__c = avmObj[0].Fares_Value_Estimate__c ;
                                if(avmObj[0].Fares_Value_High__c != null)
                                aobj.Fares_Value_High__c = avmObj[0].Fares_Value_High__c ;
                                if(avmObj[0].Fares_Value_Low__c != null)
                                aobj.Fares_Value_Low__c = avmObj[0].Fares_Value_Low__c ;
                                // aobj.id = avmObj[0].id;
                                aobj.Asset_And_Liability__c = assetObj.id;
                                aobj.Property_address__c =address ;
                                lstAvm.add(aobj);
                                 assetObj.error__C = '';
                            }
                        }
                        else{
                            System.debug('@@@@@'+avmObj.size());
                            HttpResponse avmres = obj1.getPropertyAVM(propertyval ) ;
                            JSONParser parser = JSON.createParser(avmres.getbody() );
                            Avm av = (Avm)parser.readValueAs(Avm.class);
                            avmFaresDetail temp = av.avmFaresDetail ;
                            if(temp != null){
                                Avm_Property__c aobj = new Avm_Property__c();
                                aobj.propertyId__c= Integer.valueof( Propertid);
                                aobj.Fares_FSD_Score__c = temp.faresFSDScore ;
                                aobj.Fares_Value_Estimate__c = temp.faresScore ;
                                aobj.Fares_ValuationDate__c = temp.faresValuationDate ;
                                aobj.Fares_Value_Estimate__c = temp.faresValueEstimate ;
                                aobj.Fares_Value_High__c = temp.faresValueHigh ;
                                aobj.Fares_Value_Low__c = temp.faresValueLow ;
                                aobj.Fares_Value_Low__c = temp.faresValueLow ;
                                aobj.Asset_And_Liability__c = assetObj.id;
                                aobj.Property_address__c =address ;
                                lstAvm.add(aobj);
                                Financials_Source__c tempObj1 = new Financials_Source__c();
                                tempObj1.Amount__c = Decimal.valueof(temp.faresValueEstimate);
                                tempObj1.Source__c = 'RPData';
                                tempObj1.Asset_And_Liability__c = assetObj.id;
                                lstFinancialsSource.add( tempObj1 );
                                 assetObj.error__C = '';
                            }
                            else{
                                 assetObj.error__C = 'Unable to get Avm Details from core logic';
                               // lstEmails.add(SendRpBatchEmailNotification.sendEmailNotification('Unable to get Avm Details from core logic' , assetObj.id));
                                
                            }
                        }
                    }
                }
            }
            }
            catch(Exception E){
                 assetObj.error__C = e.getmessage();
                //lstEmails.add(SendRpBatchEmailNotification.sendEmailNotification(e.getmessage() , assetObj.id));
            }
            assetObj.RpdataApicalled__c = true;
            lstAsst.add(assetObj);
        }
        if(lstFinancialsSource.size()> 0){
            upsert lstFinancialsSource ;
        }
        if(lstAvm.size() > 0){
            
            upsert lstAvm ;
                    
        }
                    if(lstAsst.size() > 0){
                    upsert lstAsst ;
                    }
         
        
    }
    public class Avm{
        public avmFaresDetail avmFaresDetail {get ;set ;}
    }
    //public avmFaresDetail  temp {get ;set;}
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