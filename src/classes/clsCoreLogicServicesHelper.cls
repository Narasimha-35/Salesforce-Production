public class clsCoreLogicServicesHelper {
    map<String , String> mapAssetWithPropertyId = new map<String , String>();
    map<id,Asset_And_Liability__c> assetMap = new Map<id,Asset_And_Liability__c>();
    map<String,String> mapPropertyIdToresponse = new Map<String,String>();
    List<Asset_And_Liability__c> assetList = new List<Asset_And_Liability__c>();
    public void CreateRpdata( List<Asset_And_Liability__c> lstobj ) {
       
        CoreLogicServices obj1 = new CoreLogicServices();
        List<Asset_And_Liability__c>  lstAsst = new List<Asset_And_Liability__c> ();
        List<acfPropertydetails__c>  lstacfProperty = new List<acfPropertydetails__c>();
        List<Financials_Source__c>  lstFinancialsSource = new List<Financials_Source__c> ();
        Set<String> lstpropertId = new Set<String>();
        
        
        for(Asset_And_Liability__c  assetObj :  lstobj  )
        {
            system.debug('test Looping***************'+assetObj);
            try{
                String Propertid ;
                if(  Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(assetObj.recordtypeid).getname() =='Asset Real Estate' ){
                    string address = '';
                    system.debug('###Entered RP Data');
                    if(string.isNotEmpty(assetObj.Street_Number__c) && string.isNotEmpty(assetObj.Street_Name__c) && string.isNotEmpty(assetObj.Street_Type__c)
                    && string.isNotEmpty(assetObj.City__c) && string.isNotEmpty(assetObj.State__c) && assetObj.Postcode__c != null
                    )
                    {
                        system.debug('###Entered RP Data Inside');
                        Integer assetObjPostcode = Integer.valueof(assetObj.Postcode__c);
                        String pcode = String.valueof(assetObjPostcode);
                        if(pcode.contains(','))
                        {
                            pcode = pcode.replace(',','');
                        }
                        address = assetObj.Street_Number__c + ' ' + assetObj.Street_Name__c + ' ' + assetObj.Street_Type__c + ' ' ;
                        address += assetObj.City__c + ' ' + assetObj.State__c + ' ' + pcode ;
                    System.debug('@#$%'+assetObj.Address__c);}
                    else{
                        address = assetObj.Address__c ;
                    }
                    if(address == null)
                    {
                        address = '';
                    }
                    System.debug(address);
                    HttpResponse res = obj1.SearchProperty(address);
                    if(res.getStatusCode() == 200 ){
                        JSONParser parser = JSON.createParser(res.getBody());
                        while (parser.nextToken() != null) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                            (parser.getText() == 'propertyId')) {
                                parser.nextToken();
                                Propertid = parser.gettext();
                                lstpropertId.add(Propertid);
                                mapAssetWithPropertyId.put(Propertid ,assetObj.ID);
                            }
                        }
                        System.debug('@@Propertid##'+Propertid);
                        if(Propertid == null){
                            if(address == ''){
                                assetObj.error__C = 'Address is missing';
                                }else{
                                assetObj.error__C = 'Unable to get propertyid from CoreLogicServices';
                            }
                        }
                    }
                    else{
                        if(address == ''){
                            assetObj.error__C = 'Address is missing';
                            }else{
                            assetObj.error__C = 'Unable to get propertyid from CoreLogicServices';
                        }
                    }
                }
            }
            catch(Exception E){
                assetObj.error__C = e.getmessage();
            }
            assetObj.RpdataApicalled__c = true;
            lstAsst.add(assetObj);
            assetMap.put(assetObj.id,assetObj);
            
            
        }
        map<String ,List<acfPropertydetails__c> >  mapProperty = new map<String  ,List<acfPropertydetails__c>>();
        List<acfPropertydetails__c> lstacfPropertyObj = [SELECT Asset_And_Liability__c,Bathrooms__c,Bedrooms__c,buildingComplexName__c,
        CarSpaces__c,councilArea__c,CreatedById,CreatedDate,direction__c,End_Alpha__c,End_Number__c,Expiry_date__c,Extension__c,FeeCode__c,
        floorArea__c,Folio__c,HeritageRegistered__c,Id,Instrument__c,isCalculatedLandArea__c,IsDeleted,isDerivedUnit__c,LandArea__c,landUsePrimary__c,
        landUseSecondary__c,LastModifiedById,LastModifiedDate,latitude__c,LegalDateIssued__c,LegalFrontAge__c,
        locality_ID__c,locality_Name__c,Locality_Single_Line__c,lockUpGarages__c,longitude__c,MapReference__c,MapSheet__c,Map_Scale__c,Name,OccupancyType__c,
        OwnerCode__c,OwnerId,Postcode_ID__c,postcode__c,Post_Code_Name__c,Post_code_Single_Line__c,PropertyID__c,propertySubTypeShort__c,propertySubType__c,
        PropertyType__c,Property_Sub_Type__c,realPropertyDescription__c,Request_Date__c,roofMaterial__c,singleLine__c,startNumber__c,Start_Alpha__c,State__c,
        StreetID__c,Street_Name__c,Street_SingleLine__c,SystemModstamp,TenureNumber__c,TenureReference__c,TitleIndicator__c,TitlePrefix__c,TitleReference__c,
        titleSuffix__c,unitAlpha__c,UnitNumber__c,VGMeasurement__c,VGNumber__c,VgoMap__c,volume__c,Wall_Material__c,yearBuilt__c,ZoneCodeLocal__c,
        ZoneDescriptionLocal__c,Zone_Code_General__c,Zone_Description_General__c FROM acfPropertydetails__c where PropertyID__c  in : lstpropertId  
        ] ;
        system.debug('lstacfPropertyObj---'+lstacfPropertyObj.size());
        
        Set<Id> setIds = new Set<Id>();
        for(acfPropertydetails__c avm : lstacfPropertyObj){
            setIds.add(avm.Id);
            system.debug('avm---'+avm);
            if(avm.propertyId__c != null  &&  !mapProperty.containskey(avm.propertyId__c)){
                List<acfPropertydetails__c> avmObjTemp = new List<acfPropertydetails__c> ();
                avmObjTemp.add(avm);
                mapProperty.put(avm.propertyId__c , avmObjTemp);
            }
            else{
                if(avm.propertyId__c != null)
                mapProperty.get(avm.propertyId__c).add(avm);
            }
        }
                List<Attachment> listAttach = [Select Id , Parentid , Body from Attachment where Parentid  in  :  setIds ] ;
                map<Id, Blob> mapAttachment = new map<Id, Blob>();
                
                for(Attachment  attachObj : listAttach )
                {
                    mapAttachment.put(attachObj.Parentid ,  attachObj.body);
                }

        map<String,List<Financials_Source__c> >  mapFinancialsSource = new map<String,List<Financials_Source__c>>();
        List<Financials_Source__c> lstFs = [Select id, Asset_And_Liability__c , Amount__c  from Financials_Source__c
        where  Asset_And_Liability__c  != null  and Source__c = 'RPData'  and  Asset_And_Liability__c in  : assetMap.keyset()  ];
       
        for(Financials_Source__c fs : lstFs)
        {
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
        List<acfPropertydetails__c>  acfPropList = new List<acfPropertydetails__c>();
        Map<String,acfPropertydetails__c>  mapPropertydetails = new Map<String,acfPropertydetails__c>();
        Map<String,List<Avm_Detail__c> >  mapLstAvmDetails  = new Map<String,List<Avm_Detail__c> >();
        Map<String,List<Contact__c> >  mapContact  = new Map<String,List<Contact__c> >();
        Map<String,List<Current_Ownership__c> >  mapCurrentOwnership  = new Map<String,List<Current_Ownership__c> >();
        List<acfPropertydetails__c> lstacfPropertydetails = new     List<acfPropertydetails__c>();
        Map<String,List<Development_Application_List__c> >  mapDevlist = new Map<String,List<Development_Application_List__c> >();
        Map<String,List<External_Reference__c> >  mapExternalReference = new Map<String,List<External_Reference__c> >();
        Map<String,List<Feature__c> >  mapFeature = new Map<String,List<Feature__c> >();
        Map<String,List<Rent_Property_Campaign_List__c> >  mapRentPropertyCampaign = new Map<String,List<Rent_Property_Campaign_List__c> >();
        Map<String,List<SaleAgencyCampaign__c> >  mapcreateSaleAgencyCampaign = new Map<String,List<SaleAgencyCampaign__c> >();
        Map<String,List<Parcel__c> >  mapcreateParcel = new Map<String,List<Parcel__c> >();
        Map<String,List<Property_Photo_List__c> >  mapcreatepropertyPhoto = new Map<String,List<Property_Photo_List__c> >();
        map<Property_Sale__c, BuyerVenderWrapper>  mapsaleList = new map<Property_Sale__c, BuyerVenderWrapper>();
        
        map<String, List<SalePropertyCampaign__c>>  mapSalePropertyCampaign = new map<String, List<SalePropertyCampaign__c>>();
        
        
       List<CoreLogicEnquiryReport__c> listReports =  new List<CoreLogicEnquiryReport__c> ();
       List<CoreLogicEnquiryReport__c> listReportsOLD = new  List<CoreLogicEnquiryReport__c> ();
        map<Id ,CoreLogicEnquiryReport__c>  mapCoreLogic = new map<ID ,CoreLogicEnquiryReport__c>([Select ID from
         CoreLogicEnquiryReport__c    where Asset_And_Liability__c in : assetMap.keyset()]);
        
        for(String  propertyid : lstpropertId)
        {
            if(!mapProperty.containskey(propertyid))
            {
                clsPropertyJson  obj =  createPropertyRecords(propertyid);
                acfPropertydetails__c objProperty =  createPropertInstance(obj);
                if(objProperty != null)
                {
                    mapPropertydetails.put(propertyid,objProperty);
                }
                List<Avm_Detail__c>    lstavmdetails  = CreateAvmDetailInstance(  obj ) ;
                if( lstavmdetails != null && lstavmdetails.size() > 0)
                {
                    mapLstAvmDetails.put(propertyid, lstavmdetails);
                }
                
                List<SalePropertyCampaign__c>  salePropertyCampaign  = createSalePropertyCampaignList( obj);
                    
                    if(salePropertyCampaign != null &&  salePropertyCampaign.size() > 0)
                    {
                       mapSalePropertyCampaign.put(propertyid, salePropertyCampaign);
                    }
                    
                List<Contact__c>    lstContact =  CreateContactInstance ( obj) ;
                if(lstContact != null &&  lstContact.size() > 0)
                {
                    mapContact.put(propertyid, lstContact);
                }
                List<Current_Ownership__c>   CurrentOwnership =  CreateCurrentOwnershipInstance (obj);
                if(CurrentOwnership != null && CurrentOwnership.size() > 0)
                {
                    mapCurrentOwnership.put(propertyid, CurrentOwnership);
                }
                List<Development_Application_List__c>  DevelopmentApplicationList = CreateDevelopmentApplicationListInstance ( obj);
                if(DevelopmentApplicationList != null &&  DevelopmentApplicationList.size() > 0)
                {
                    mapDevlist.put(propertyid, DevelopmentApplicationList);
                }
                List<External_Reference__c>  ExternalReference = CreateExternalReferenceInstance ( obj);
                if(ExternalReference != null  &&  ExternalReference.size() > 0)
                {
                    mapExternalReference.put(propertyid, ExternalReference);
                }
                List<Feature__c>  Feature = CreateFeatureInstance ( obj);
                if(Feature != null && Feature.size() > 0)
                {
                    mapFeature.put(propertyid, Feature);
                }
                List<Rent_Property_Campaign_List__c>  RentPropertyCampaign = CreateRentPropertyCampaignList ( obj);
                if(RentPropertyCampaign != null &&  RentPropertyCampaign.size() > 0)
                {
                    mapRentPropertyCampaign.put(propertyid, RentPropertyCampaign);
                }
                List<SaleAgencyCampaign__c>  SaleAgencyCampaignList1 = createSaleAgencyCampaignList ( obj);
               
               if(SaleAgencyCampaignList1 != null  &&  SaleAgencyCampaignList1.size() > 0)
                {
                    mapcreateSaleAgencyCampaign.put(propertyid, SaleAgencyCampaignList1);
                }
                
                List<Parcel__c>  ParcelList = createParcelList ( obj);
                if( ParcelList != null  && ParcelList.size() > 0)
                {
                    mapcreateParcel.put(propertyid, ParcelList);
                }
                List<Property_Photo_List__c>  PropertyPhotoList = createpropertyPhotoList ( obj);
                if(PropertyPhotoList != null  &&  PropertyPhotoList.size() > 0)
                {
                    mapcreatepropertyPhoto.put(propertyid, PropertyPhotoList);
                }
                
                List<SaleAgencyCampaign__c>  SaleAgencyCampaignList = createSaleAgencyCampaignList ( obj);
                if(SaleAgencyCampaignList != null  &&  SaleAgencyCampaignList.size() > 0)
                {
                    mapcreateSaleAgencyCampaign.put(propertyid, SaleAgencyCampaignList);
                }
                System.debug('_____'+createsaleList(obj));
                if(createsaleList(obj) != null)
                {
                    System.debug('_____'+createsaleList(obj));
                    mapsaleList = createsaleList ( obj);
                }
                
            }
            else
            {
               DateTime  dt = system.now();
                List<acfPropertydetails__c>   acfPropertydetails =  mapProperty.get(propertyid) ;
                

                if(acfPropertydetails[0].Expiry_date__c  > dt) 
                { 
                    CoreLogicEnquiryReport__c obj = new CoreLogicEnquiryReport__c();
                    obj.Asset_And_Liability__c = mapAssetWithPropertyId.get(propertyid);
                    obj.Property_Detail__c =    acfPropertydetails[0].ID ;
                    if(mapCoreLogic.get(mapAssetWithPropertyId.get(propertyid)) == null){
                            listReportsOLD.add(obj);
                    }
                }                   
                else
                {
                clsPropertyJson  obj =  createPropertyRecords(propertyid);
                acfPropertydetails__c objProperty =  createPropertInstance(obj);
                objProperty.Id = acfPropertydetails[0].ID ;
                if(objProperty != null)
                {
                    mapPropertydetails.put(propertyid,objProperty);
                }
                 
                List<Avm_Detail__c>  objlist =  [Select Id  from Avm_Detail__c  where  Property_Name__c =  : acfPropertydetails[0].ID] ;
                if(objlist.size() > 0){
                    Delete  objlist ;
                }
                List<Avm_Detail__c>    lstavmdetails  = CreateAvmDetailInstance(  obj ) ;
                List<Avm_Detail__c>    lstdetails  = new List<Avm_Detail__c>();
                for(Avm_Detail__c  avm :lstavmdetails)
                {
                    avm.Property_Name__c = acfPropertydetails[0].ID ;
                    lstdetails.add(avm);
                }
                if( lstdetails != null && lstdetails.size() > 0)
                {
                    mapLstAvmDetails.put(propertyid, lstdetails);
                }
                
                List<SalePropertyCampaign__c>  objlist1 =  [Select Id  from SalePropertyCampaign__c  where  Property_Detail__c =  : acfPropertydetails[0].ID] ;
                
                if(objlist1.size() > 0){
                    Delete  objlist1 ;
                }
                
                  List<SalePropertyCampaign__c>  salePropertyCampaign  = createSalePropertyCampaignList( obj);
                  List<SalePropertyCampaign__c> listCamp = new  List<SalePropertyCampaign__c>();
                 
                    for(SalePropertyCampaign__c  saleCamp :salePropertyCampaign )
                    {
                        saleCamp.Property_Detail__c = acfPropertydetails[0].ID ;
                        listCamp.add(saleCamp);
                    }
                    if(listCamp != null &&  listCamp.size() > 0)
                    {
                       mapSalePropertyCampaign.put(propertyid, listCamp);
                    }
                    
               List<Contact__c>  objlist2 =  [Select Id  from Contact__c  where  Property_Name__c =  : acfPropertydetails[0].ID] ;
                
                if(objlist2.size() > 0){
                    Delete  objlist2 ;
                }
                    
                List<Contact__c>    lstContact =  CreateContactInstance ( obj) ;
                 List<Contact__c>    lstCon  = new  List<Contact__c>();
                 for(Contact__c con : lstContact)
                 {
                     con.Property_Name__c = acfPropertydetails[0].ID ;
                     lstCon.add(con);
                 }
                if(lstCon != null &&  lstCon.size() > 0)
                {
                    mapContact.put(propertyid, lstCon);
                }
                
                List<Current_Ownership__c>  objlist3 =  [Select Id  from Current_Ownership__c  where  Property_Name__c =  : acfPropertydetails[0].ID] ;
                
                if(objlist3.size() > 0){
                    Delete  objlist3 ;
                }
                
                List<Current_Ownership__c>   CurrentOwnership =  CreateCurrentOwnershipInstance (obj);
                 List<Current_Ownership__c>   listCurrentOwnership = new List<Current_Ownership__c>();
                 for(Current_Ownership__c  conOwnerShip : CurrentOwnership )                     
                     {
                         conOwnerShip.Property_Name__c =  acfPropertydetails[0].ID ;
                         listCurrentOwnership.add(conOwnerShip);
                     }
                if(listCurrentOwnership != null && listCurrentOwnership.size() > 0)
                {
                    mapCurrentOwnership.put(propertyid, listCurrentOwnership);
                }
                
                List<Development_Application_List__c>  objlist4 =  [Select Id  from Development_Application_List__c  where  Property_Name__c =  : acfPropertydetails[0].ID] ;
                
                if(objlist4.size() > 0){
                    Delete  objlist4 ;
                }
                
                List<Development_Application_List__c>  DevelopmentApplicationList = CreateDevelopmentApplicationListInstance ( obj);
                 List<Development_Application_List__c>  listDevelopmentApplication = new  List<Development_Application_List__c> ();
                 for(Development_Application_List__c  dev : DevelopmentApplicationList){
                     dev.Property_Name__c =  acfPropertydetails[0].ID ; 
                     listDevelopmentApplication.add(dev);
                     
                 }
                if(listDevelopmentApplication != null &&  listDevelopmentApplication.size() > 0)
                {
                    mapDevlist.put(propertyid, listDevelopmentApplication);
                }
                
                List<External_Reference__c>  lstExt = [Select Id from  External_Reference__c  where Property_Name__c =  : acfPropertydetails[0].ID ];
                
                if(lstExt.size() > 0)
                {
                    Delete lstExt ;
                }
                List<External_Reference__c>  ExternalReference = CreateExternalReferenceInstance ( obj);
                if(ExternalReference != null  &&  ExternalReference.size() > 0)
                {
                    mapExternalReference.put(propertyid, ExternalReference);
                }
                
                List<Feature__c>  lstFeature = [Select Id from  Feature__c  where Property_Name__c =  : acfPropertydetails[0].ID ];
                
                if(lstFeature.size() > 0)
                {
                    Delete lstFeature ;
                }
                List<Feature__c>  Feature = CreateFeatureInstance ( obj);
                if(Feature != null && Feature.size() > 0)
                {
                    mapFeature.put(propertyid, Feature);
                }
                
                List<Rent_Property_Campaign_List__c>  lstRent = [Select Id from  Rent_Property_Campaign_List__c  where Property_Name__c =  : acfPropertydetails[0].ID ];
                
                if(lstRent.size() > 0)
                {
                    Delete lstRent ;
                }
                List<Rent_Property_Campaign_List__c>  RentPropertyCampaign = CreateRentPropertyCampaignList ( obj);
                if(RentPropertyCampaign != null &&  RentPropertyCampaign.size() > 0)
                {
                    mapRentPropertyCampaign.put(propertyid, RentPropertyCampaign);
                }
                List<SaleAgencyCampaign__c>  lstSaleAgencyCampaign = [Select Id from  SaleAgencyCampaign__c  where Property_Name__c =  : acfPropertydetails[0].ID ];
                
                if(lstSaleAgencyCampaign.size() > 0)
                {
                    Delete lstSaleAgencyCampaign ;
                }
                
                List<SaleAgencyCampaign__c>  SaleAgencyCampaignList1 = createSaleAgencyCampaignList ( obj);
               
               if(SaleAgencyCampaignList1 != null  &&  SaleAgencyCampaignList1.size() > 0)
                {
                    mapcreateSaleAgencyCampaign.put(propertyid, SaleAgencyCampaignList1);
                }
                
                List<Parcel__c>  lstParcel = [Select Id from  Parcel__c  where Property_Name__c =  : acfPropertydetails[0].ID ];
                
                if(lstParcel.size() > 0)
                {
                    Delete lstParcel ;
                }

                List<Parcel__c>  ParcelList = createParcelList ( obj);
                if( ParcelList != null  && ParcelList.size() > 0)
                {
                    mapcreateParcel.put(propertyid, ParcelList);
                }
                List<Property_Photo_List__c>  lstphotos = [Select Id from  Property_Photo_List__c  where Property_Name__c =  : acfPropertydetails[0].ID ];
                
                if(lstphotos.size() > 0)
                {
                    Delete lstphotos ;
                }
               List<Property_Photo_List__c>  PropertyPhotoList = createpropertyPhotoList ( obj);
                if(PropertyPhotoList != null  &&  PropertyPhotoList.size() > 0)
                {
                    mapcreatepropertyPhoto.put(propertyid, PropertyPhotoList);
                }
                
                List<SaleAgencyCampaign__c>  lstSaleAgencyCampaign1 = [Select Id from  SaleAgencyCampaign__c  where 
                Property_Name__c =  : acfPropertydetails[0].ID ];
                
                if(lstSaleAgencyCampaign1.size() > 0)
                {
                    Delete lstSaleAgencyCampaign1 ;
                }
                List<SaleAgencyCampaign__c>  SaleAgencyCampaignList = createSaleAgencyCampaignList ( obj);
                if(SaleAgencyCampaignList != null  &&  SaleAgencyCampaignList.size() > 0)
                {
                    mapcreateSaleAgencyCampaign.put(propertyid, SaleAgencyCampaignList);
                }
                System.debug('_____'+createsaleList(obj));
                if(createsaleList(obj) != null)
                {
                    System.debug('_____'+createsaleList(obj));
                    mapsaleList = createsaleList ( obj);
                }
                
                }   
            }
        }
        
        
        if(listReportsOLD.size() > 0)
        {
            upsert listReportsOLD ;
        }
       
      
       
       

       if(mapPropertydetails.size() > 0)
        {
            for(String Id : mapPropertydetails.keyset())
            {
                if(mapPropertydetails.get(ID) != null  && mapAssetWithPropertyId.get(id) != null)
                {
                    acfPropertydetails__c obj = mapPropertydetails.get(ID) ;
                    obj.Asset_And_Liability__c = mapAssetWithPropertyId.get(id);
                    acfPropList.add(obj);
                }
            }
        }
        if(acfPropList.size() > 0)
        {
            upsert acfPropList;
            for(acfPropertydetails__c propDetails :acfPropList)
            {
                CoreLogicEnquiryReport__c obj = new CoreLogicEnquiryReport__c();
                if(propDetails.Asset_And_Liability__c != null )
                {
                    obj.Asset_And_Liability__c =    propDetails.Asset_And_Liability__c ;
                     obj.Property_Detail__c =   propDetails.ID ;
                     listReports.add(obj);
                }
            }
            if(listReports.size() > 0)
            {
                upsert listReports ;
            }
            List<Attachment> lstAttachment = new List<Attachment>();
            for(acfPropertydetails__c objPropertydetail : acfPropList)
            {
                if(mapPropertyIdToresponse != null && !mapPropertyIdToresponse.isEmpty() && mapPropertyIdToresponse.get(objPropertydetail.PropertyID__c) != null
                 && mapPropertyIdToresponse.get(objPropertydetail.PropertyID__c) != '')
                 {
                    Attachment objAttach = new Attachment(parentid=objPropertydetail.id,body=Blob.valueof(mapPropertyIdToresponse.get(objPropertydetail.PropertyID__c)),
                                                        Name='CoreLogicResponse '+ System.Today() +'.XML');
                    lstAttachment.add(objAttach);                                   
                 }
            }
            if(lstAttachment != null && !lstAttachment.isEmpty())
                insert lstAttachment;
            
            List<Avm_Detail__c>   lstAVMDetails = new List<Avm_Detail__c>() ;
            List<Contact__c>   lstContact = new List<Contact__c>() ;
            List<Current_Ownership__c> lstOwner = new List<Current_Ownership__c>();
            List<Development_Application_List__c> lstdev = new List<Development_Application_List__c>() ;
            List<External_Reference__c> exList = new List<External_Reference__c>();
            List<Feature__c>  lstFeature = new List<Feature__c>() ;
            list<Rent_Property_Campaign_List__c>  lstRent= new list<Rent_Property_Campaign_List__c>();
            List<Parcel__c>  lstParcel = new List<Parcel__c> ();
            List<SaleAgencyCampaign__c> lstSalecamp = new List<SaleAgencyCampaign__c>();
            List<Property_Photo_List__c> lstphoto = new    List<Property_Photo_List__c>();
            List<Property_Sale__c> lstSale = new List<Property_Sale__c>();
            
            List<SalePropertyCampaign__c> lstSalePropertyCampaign = new List<SalePropertyCampaign__c>();
              
              List<SaleAgencyCampaign__c> lstSaleAgencyCampaign = new List<SaleAgencyCampaign__c>();
            
            for( acfPropertydetails__c objIns :  acfPropList )
            {
                if(objIns.PropertyID__c != null)
                {
                    if(mapLstAvmDetails.get(objIns.PropertyID__c) != null  )
                    {
                        for(Avm_Detail__c obj :   mapLstAvmDetails.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstAVMDetails.add(obj);
                            
                               Financials_Source__c tempObj2 = new Financials_Source__c();
                                tempObj2.Amount__c = Decimal.valueof(obj.Estimate__c);
                                tempObj2.Source__c = 'RPData';
                                tempObj2.Asset_And_Liability__c = mapAssetWithPropertyId.get(objIns.PropertyID__c); 
                                lstFinancialsSource.add( tempObj2 );
                            
                        }
                    }
                    if(mapContact.get(objIns.PropertyID__c )!= null)
                    {
                        for(Contact__c obj :   mapContact.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstContact.add(obj);
                        }
                    }
                    if(mapCurrentOwnership.get(objIns.PropertyID__c )!= null)
                    {
                        for(Current_Ownership__c  obj :   mapCurrentOwnership.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstOwner.add(obj);
                        }
                    }
                    if(mapDevlist.get(objIns.PropertyID__c )!= null)
                    {
                        for(Development_Application_List__c  obj :   mapDevlist.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstdev.add(obj);
                        }
                    }
                    if(mapExternalReference.get(objIns.PropertyID__c )!= null)
                    {
                        for(External_Reference__c  obj :   mapExternalReference.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            exList.add(obj);
                        }
                    }
                    if(mapFeature.get(objIns.PropertyID__c )!= null)
                    {
                        for(Feature__c  obj :   mapFeature.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstFeature.add(obj);
                        }
                    }
                    if(mapRentPropertyCampaign.get(objIns.PropertyID__c )!= null)
                    {
                        for(Rent_Property_Campaign_List__c  obj :   mapRentPropertyCampaign.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstRent.add(obj);
                        }
                    }
                    if(mapcreateParcel.get(objIns.PropertyID__c )!= null)
                    {
                        for(Parcel__c  obj :   mapcreateParcel.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstParcel.add(obj);
                        }
                    }
                    if(mapcreatePropertyPhoto.get(objIns.PropertyID__c )!= null)
                    {
                        for(Property_Photo_List__c  obj :   mapcreatepropertyPhoto.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstphoto.add(obj);
                        }
                    }
                    
                    if(mapcreateSaleAgencyCampaign.get(objIns.PropertyID__c )!= null)
                    {
                        for(SaleAgencyCampaign__c  obj :   mapcreateSaleAgencyCampaign.get(objIns.PropertyID__c))
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstSaleAgencyCampaign.add(obj);
                        }
                    }
                    
                    
                    if(mapSalePropertyCampaign.get(objIns.PropertyID__c )!= null)
                    {
                        for(SalePropertyCampaign__c  obj :   mapSalePropertyCampaign.get(objIns.PropertyID__c))
                        {
                            obj.Property_Detail__c =  objIns.Id ;
                            lstSalePropertyCampaign.add(obj);
                        }
                    }
                    if(mapsaleList != null)
                    {
                        
                        for(Property_Sale__c  obj :   mapsaleList.keyset())
                        {
                            obj.Property_Name__c =  objIns.Id ;
                            lstSale.add(obj);
                        }
                    }
                }
            }
            if(lstAVMDetails.size() > 0)
            {
                upsert lstAVMDetails ;
            }
            if(lstContact.size() > 0)
            {
                upsert lstContact;
            }
            if(lstOwner.size() > 0){
                upsert lstOwner;
            }
            if(lstdev.size() > 0){
                insert lstdev ;
            }
            if(exList.size() > 0)
            {
                upsert exList;
            }
            if(lstFeature.size() > 0)
            {
                upsert lstFeature ;
            }
            if(lstRent.size() > 0)
            {
                upsert lstRent ;
            }
            if(lstParcel.size() > 0)
            {
                upsert lstParcel ;
            }
            if(lstSalecamp.size() > 0)
            {
                upsert lstSalecamp ;
            }
            if(lstSaleAgencyCampaign.size() > 0)
            {
                upsert lstSaleAgencyCampaign ;
            }
            if(lstSalePropertyCampaign.size() > 0)
            {
                upsert lstSalePropertyCampaign ;
            }
            if(lstSale.size() > 0)
            {
                 upsert lstSale ;
                 List<buyerList__c> lstBuyers = new  List<buyerList__c>();
                 List<Vendor__c> lstVenders = new  List<Vendor__c>();
                
                for(integer i = 0 ; i < lstSale.size() ; i++)
                {
                    for(Property_Sale__c  obj :   mapsaleList.keyset())
                        {
                            if(lstSale.get(i).Property_Name__c ==  obj.Property_Name__c )
                            {
                                if(mapsaleList.get(obj) != null){
                                BuyerVenderWrapper  wrap =  mapsaleList.get(obj);
                                    if(wrap != null)
                                    {
                                        //public List<buyerList__c> buyers {get ;set ;}
                                        //  public List<Vendor__c> Venders {get ;set ;}
                                        if(wrap.buyers != null)
                                        {
                                             List<buyerList__c> buyers = wrap.buyers ;
                                             
                                             if(buyers != null  &&  buyers.size() > 0)
                                             {
                                                 for(buyerList__c buyer : buyers )
                                                 {
                                                     buyer.Property_Sale__c = lstSale.get(i).ID ; 
                                                     lstBuyers.add(buyer);
                                                 }
                                             }
                                              List<Vendor__c> venders = wrap.venders ;
                                             
                                             if(venders != null  &&  venders.size() > 0)
                                             {
                                                 for(Vendor__c Vender : venders )
                                                 {
                                                     Vender.Sale__c = lstSale.get(i).ID ; 
                                                     lstVenders.add(Vender);
                                                 }
                                             }
                                        }
                                    }
                                }
                                
                            }
                        }
                }
                if(lstVenders.size() > 0)
                {
                    insert lstVenders ;
                }
                if(lstBuyers.size() > 0)
                {
                    insert lstBuyers ;
                }
                
            }
            if(lstphoto.size() > 0)
            {
                upsert lstphoto ;
            }
        }
        if(lstFinancialsSource.size()> 0){
            upsert lstFinancialsSource ;
        }
        
        if(lstAsst.size() > 0){
            upsert lstAsst;
        }
        if(assetList.size() > 0){
            update assetList;
        }
    }
    public static  map<Property_Sale__c, BuyerVenderWrapper> createsaleList(clsPropertyJson obj1)
    {
        
        map<Property_Sale__c, BuyerVenderWrapper>  propertyMap = new map<Property_Sale__c,BuyerVenderWrapper> ();
        if(obj1.property  != null )
        {
            clsPropertyJson.cls_property  property = obj1.property ;
            if(property.saleList != null )
            {
                List<clsPropertyJson.cls_saleList>  saleListList   =  property.saleList ;
                for(clsPropertyJson.cls_saleList  list1 : saleListList)
                {
                    Property_Sale__c obj = new Property_Sale__c ();
                    if(list1.agency != null)
                    {
                        clsPropertyJson.cls_agency agency  =  list1.agency  ;
                        if(agency.company != null)
                        {
                            clsPropertyJson.cls_company  company = agency.company ;
                            if(company.abn != null)
                            {
                                obj.Agency_ABN__c  = company.abn ;
                            }
                            if(company.acn != null)
                            {
                                obj.Agency_ABN__c  = company.acn ;
                            }
                            if(company.companyname != null)
                            {
                                obj.Agency_CompanyName__c  = company.companyname ;
                            }
                        }
                        if(agency.phone != null)
                        {
                            clsPropertyJson.cls_phone  phone = agency.phone;
                            if(phone.isDoNotCall  != null)
                            {
                                obj.Is_Do_Not_call_Agency__c = phone.isDoNotCall ;
                            }
                            if(phone.phoneNumber != null)
                            {
                                obj.Agency_Phone_Number__c = phone.phoneNumber ;
                            }
                           
                        }
                    }
                    
                    if(list1.agent  != null)
                    {
                        clsPropertyJson.cls_agent  agent = list1.agent ;
                        if(agent.agent != null)
                        {
                            obj.Agent_del__c = agent.agent ;
                        }
                        if(agent.phone != null)
                        {
                            clsPropertyJson.cls_phone  phone = agent.phone;
                            if(phone.isDoNotCall  != null)
                            {
                                obj.isDoNotCall_Agent_del__c = phone.isDoNotCall ;
                            }
                            if(phone.phoneNumber != null)
                            {
                                obj.Agent_Phone_Number__c = phone.phoneNumber ;
                            }
                            
                        }
                    }
                    
                    if(list1.chattelsPrice  != null)
                    {
                        obj.chattels_Price__C = String.valueof(list1.chattelsPrice) ;
                    }
                    if(list1.contractDate  != null)
                    {
                        obj.Contract_Date__c = String.valueof(list1.contractDate );
                    }
                    if(list1.isAgentsAdvice  != null)
                    {
                        obj.IsAgentsAdvice__c = list1.isAgentsAdvice ;
                    }
                    if(list1.isDerivedAgency  != null)
                    {
                        obj.isDerivedAgency__C = list1.isDerivedAgency ;
                    }
                    if(list1.isDerivedAgent  != null)
                    {
                        obj.isDerivedAgent__C = list1.isDerivedAgent ;
                    }
                    if(list1.isDerivedAgent  != null)
                    {
                        obj.isDerivedAgent__C = list1.isDerivedAgent ;
                    }
                    if(list1.isReaRecentSale  != null)
                    {
                        obj.isReaRecentSale__c = list1.isReaRecentSale ;
                    }
                    if(list1.otherPrice  != null)
                    {
                        obj.Other_Price__C = String.valueof(list1.otherPrice) ;
                    }
                    if(list1.price  != null)
                    {
                        obj.Price__C = String.valueof(list1.price) ;
                    }
                    if(list1.settlementDate  != null)
                    {
                        obj.settlementDate__c    = list1.settlementDate ;
                    }
                    if(list1.transferId  != null)
                    {
                        obj.TransferId__c    = String.valueof(list1.transferId) ;
                    }
                    if(list1.type  != null)
                    {
                        obj.Type__c  = list1.type ;
                    }
                    if(list1.vendorRelationship  != null)
                    {
                        obj.Type__c  = list1.vendorRelationship ;
                    }
                    
                    BuyerVenderWrapper  wrap = new BuyerVenderWrapper();
                    
                    if(list1.vendorList != null )
                    {
                       wrap.venders = createvenderListList(list1);
                    }
                    if(list1.buyerList != null )
                    {
                       wrap.buyers = createBuyerList(list1);
                    }
                    propertyMap.put(obj,wrap);
                }
            }
        }
        return propertyMap ;
    }  
        


public class BuyerVenderWrapper
{
    public List<buyerList__c> buyers {get ;set ;}
    public List<Vendor__c> Venders {get ;set ;}
    
}

public static  List<buyerList__c>  createBuyerList(clsPropertyJson.cls_saleList obj1)
{
    List<buyerList__c>  lstObj = new List<buyerList__c>();
    
        if(obj1.buyerList   != null)        
        {
            List<clsPropertyJson.cls_buyerList>  lstBuyer =  obj1.buyerList ;
            
            if(lstBuyer.size() > 0)
            {
                buyerList__c obj = new buyerList__c();
                for(clsPropertyJson.cls_buyerList  buyer :  lstBuyer )
                {
                    if(buyer.id != null)
                    {
                        obj.Id__C = String.valueof(buyer.id);
                    }
                    
                    
               if(buyer.company != null )
                {
                    clsPropertyJson.cls_company company =   buyer.company ;
                    if(company.abn != null)
                    {
                        obj.ABN__C  =company.abn;
                    }
                    if(company.acn != null)
                    {
                        obj.AcN__C =company.acn;
                    }
                    if(company.companyName != null)
                    {
                        obj.CompanyName__c = company.companyName ;
                    }
                }
                if(buyer.mailingAddress != null)
                {
                    clsPropertyJson.cls_mailingAddress   mailingAddress  =  buyer.mailingAddress ;
                    if(mailingAddress.careOf != null)
                    {
                        obj.careOf__C = mailingAddress.careOf  ;
                    }
                    if(mailingAddress.country != null)
                    {
                        obj.Country__C = mailingAddress.country  ;
                    }
                    if(mailingAddress.isDoNotMail != null)
                    {
                        obj.isDoNotMail__c = mailingAddress.isDoNotMail  ;
                    }
                    if(mailingAddress.line1 != null)
                    {
                        obj.line1__c = mailingAddress.line1  ;
                    }
                    if(mailingAddress.line2 != null)
                    {
                        obj.line2__c = mailingAddress.line2  ;
                    }
                    if(mailingAddress.postcode != null)
                    {
                        obj.postcode__c = mailingAddress.postcode  ;
                    }
                    if(mailingAddress.state != null)
                    {
                        obj.State__c = mailingAddress.state  ;
                    }
                    if(mailingAddress.suburb != null)
                    {
                        obj.suburb__C = mailingAddress.suburb  ;
                    }
                }
                if(buyer.person != null)
                {
                    clsPropertyJson.cls_person  person  = buyer.person  ;
                    if(person.firstName != null)
                    {
                        obj.FirstName__c =  person.firstName ;
                    }
                    if(person.initials != null)
                    {
                        obj.Initials__c = person.Initials    ;
                    }
                    if(person.lastName != null)
                    {
                        obj.LastName__c = person.lastName;
                    }
                    if(person.middleNames != null)
                    {
                        obj.MiddleNames__c = person.middleNames;
                    }
                }
                lstObj.add(obj);
            }
            
        }
        }
    return lstObj;
}

public static  List<Vendor__c>  createvenderListList(clsPropertyJson.cls_saleList obj1)
{
    List<Vendor__c>  lstObj = new List<Vendor__c>();
    
        if(obj1.vendorList   != null)       
        {
            List<clsPropertyJson.cls_vendorList>  lstVender =  obj1.vendorList ;
            
            if(lstVender.size() > 0)
            {
                Vendor__c obj = new Vendor__c();
                for(clsPropertyJson.cls_vendorList  vender :  lstVender )
                {
                    if(vender.id != null)
                    {
                        obj.Id__C = String.valueof(vender.id);
                    }
                    
                    
                                if(vender.company != null )
                {
                    clsPropertyJson.cls_company company =   vender.company ;
                    if(company.abn != null)
                    {
                        obj.ABN__C  =company.abn;
                    }
                    if(company.acn != null)
                    {
                        obj.AcN__C =company.acn;
                    }
                    if(company.companyName != null)
                    {
                        obj.CompanyName__c = company.companyName ;
                    }
                }
                if(vender.mailingAddress != null)
                {
                    clsPropertyJson.cls_mailingAddress   mailingAddress  =  vender.mailingAddress ;
                    if(mailingAddress.careOf != null)
                    {
                        obj.careOf__C = mailingAddress.careOf  ;
                    }
                    if(mailingAddress.country != null)
                    {
                        obj.Country__C = mailingAddress.country  ;
                    }
                    if(mailingAddress.isDoNotMail != null)
                    {
                        obj.isDoNotMail__c = mailingAddress.isDoNotMail  ;
                    }
                    if(mailingAddress.line1 != null)
                    {
                        obj.line1__c = mailingAddress.line1  ;
                    }
                    if(mailingAddress.line2 != null)
                    {
                        obj.line2__c = mailingAddress.line2  ;
                    }
                    if(mailingAddress.postcode != null)
                    {
                        obj.postcode__c = mailingAddress.postcode  ;
                    }
                    if(mailingAddress.state != null)
                    {
                        obj.State__c = mailingAddress.state  ;
                    }
                    if(mailingAddress.suburb != null)
                    {
                        obj.suburb__C = mailingAddress.suburb  ;
                    }
                }
                if(vender.person != null)
                {
                    clsPropertyJson.cls_person  person  = vender.person  ;
                    if(person.firstName != null)
                    {
                        obj.FirstName__c =  person.firstName ;
                    }
                    if(person.initials != null)
                    {
                        obj.Initials__c = person.Initials    ;
                    }
                    if(person.lastName != null)
                    {
                        obj.LastName__c = person.lastName;
                    }
                    if(person.middleNames != null)
                    {
                        obj.MiddleNames__c = person.middleNames;
                    }
                }
                lstObj.add(obj);
            }
            
        }
        }
    return lstObj;
}
public static  List<Property_Photo_List__c>  createpropertyPhotoList(clsPropertyJson obj1)
{
    List<Property_Photo_List__c> PropertyPhotoList = new List<Property_Photo_List__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.propertyPhotoList != null )
        {
            List<clsPropertyJson.cls_propertyPhotoList>  parcelListList1   =  property.propertyPhotoList ;
            for(clsPropertyJson.cls_propertyPhotoList  list1 : parcelListList1 )
            {
                Property_Photo_List__c obj = new Property_Photo_List__c();
                if(list1.isDefaultPhoto  != null)
                {
                    obj.isDefaultPhoto__c = list1.isDefaultPhoto ;
                }
                if(list1.largePhotoUrl  != null)
                {
                    obj.Large_Photo_Url__c = list1.largePhotoUrl ;
                }
                if(list1.mediumPhotoUrl  != null)
                {
                    obj.Medium_Photo_Url__c = list1.mediumPhotoUrl ;
                }
                if(list1.scanDate  != null)
                {
                    obj.scanDate__c =list1.scanDate ;
                }
                if(list1.thumbnailPhotoUrl  != null)
                {
                    obj.Thumbnail_Photo_Url__c =list1.thumbnailPhotoUrl ;
                }
                PropertyPhotoList.add(obj) ;
            }
        }
    }
    return PropertyPhotoList ;
}
public static  List<Parcel__c>  createParcelList(clsPropertyJson obj1)
{
    List<Parcel__c> parcelList = new List<Parcel__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.parcelList != null )
        {
            List<clsPropertyJson.cls_parcelList>  parcelListList1   =  property.parcelList ;
            for(clsPropertyJson.cls_parcelList  list1 : parcelListList1 )
            {
                Parcel__c  obj = new Parcel__c();
                if(list1.area  != null)
                {
                    obj.Area__c  = list1.area ;
                }
                if(list1.block  != null)
                {
                    obj.block__c  = list1.block ;
                }
                if(list1.displayName  != null)
                {
                    obj.Display_Name__c  = list1.displayName ;
                }
                if(list1.displayValue  != null)
                {
                    obj.Display_Value__c  = list1.displayValue ;
                }
                if(list1.hundred  != null)
                {
                    obj.Hundred__c  = list1.hundred ;
                }
                if(list1.isPrimaryPlan  != null)
                {
                    obj.IsPrimaryPlan__c  = list1.isPrimaryPlan ;
                }
                if(list1.landAuthority  != null)
                {
                    obj.Land_Authority__c  = list1.landAuthority ;
                }
                if(list1.location  != null)
                {
                    obj.location__C  = list1.location ;
                }
                if(list1.lot  != null)
                {
                    obj.location__C  = list1.lot ;
                }
                if(list1.lot  != null)
                {
                    obj.Lot__c  = list1.lot ;
                }
                if(list1.lotAlpha  != null)
                {
                    obj.lotAlpha__C  = list1.lotAlpha ;
                }
                if(list1.lotPart  != null)
                {
                    obj.lotPart__C  = list1.lotPart ;
                }
                if(list1.plan  != null)
                {
                    obj.plan__c  = list1.plan ;
                }
                if(list1.planType  != null)
                {
                    obj.plan__c  = list1.planType ;
                }
                if(list1.planType  != null)
                {
                    obj.Plan_Type__c  = list1.planType ;
                }
                if(list1.referenceSection  != null)
                {
                    obj.ReferenceSection__c  = list1.referenceSection ;
                }
                if(list1.section  != null)
                {
                    obj.section__C  = list1.section ;
                }
                if(list1.sectionPart  != null)
                {
                    obj.sectionPart__C  = list1.sectionPart ;
                }
                if(list1.surveyPlan  != null)
                {
                    obj.surveyPlan__C  = list1.surveyPlan ;
                }
                parcelList.add(obj);
            }
        }
    }
    return parcelList ;
}





public  static List<SaleAgencyCampaign__c>  createSaleAgencyCampaignList(clsPropertyJson obj1)
{
    List<SaleAgencyCampaign__c> SaleAgencyCampaignList = new List<SaleAgencyCampaign__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.forSaleAgencyCampaignList  != null)
        {
            List<clsPropertyJson.cls_forSaleAgencyCampaignList>  SaleAgencyCampaignList1   =  property.forSaleAgencyCampaignList ;
            for(clsPropertyJson.cls_forSaleAgencyCampaignList  list1 : SaleAgencyCampaignList1 )
            {
                SaleAgencyCampaign__c  obj = new SaleAgencyCampaign__c();
                if(list1.advertisementId != null)
                {
                    obj.AdvertisementId__c = String.valueof(list1.advertisementId);
                }
                if(list1.daysOnMarket != null)
                {
                    obj.DaysOnMarket__c  = String.valueof(list1.daysOnMarket) ;
                }
                if(list1.fromDate  != null)
                {
                    obj.FromDate__c =list1.fromDate;
                }
                if(list1.isActiveCampaign !=  null)
                {
                    obj.isActiveCampaign__c  = list1.isActiveCampaign ;
                }
                if(list1.toDate  != null)
                {
                    obj.ToDate__c = list1.toDate;
                }
                if(list1.dayslisted != null)
                {
                    obj.dayslisted__c  = String.valueof(list1.dayslisted );
                }
                if(list1.saleDate != null)
                {
                    obj.saleDate__c  =list1.saleDate ;
                }
                
                if(list1.agency != null){
                    clsPropertyJson.cls_agency agency  =  list1.agency  ;
                    if(agency.company != null)
                    {
                        clsPropertyJson.cls_company  company = agency.company ;
                        if(company.abn != null)
                        {
                            obj.ABN__c  = company.abn ;
                        }
                        if(company.acn != null)
                        {
                            obj.ACN__c  = company.acn ;
                        }
                        if(company.companyname != null)
                        {
                            obj.CompanyName__c  = company.companyname ;
                        }
                    }
                    if(agency.phone != null)
                    {
                        clsPropertyJson.cls_phone  phone = agency.phone;
                        if(phone.isDoNotCall  != null)
                        {
                            obj.isDoNotCall__c = phone.isDoNotCall ;
                        }
                        if(phone.phoneNumber != null)
                        {
                            obj.phoneNumber__c = phone.phoneNumber ;
                        }
                    }
                }
                SaleAgencyCampaignList.add(obj);
            }
        }
    }
    return SaleAgencyCampaignList ;
}
public  static List<Rent_Property_Campaign_List__c>  CreateRentPropertyCampaignList(clsPropertyJson obj1)
{
    List<Rent_Property_Campaign_List__c>  lstRentPropertyCampaignList = new List<Rent_Property_Campaign_List__c> ();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.forRentPropertyCampaignList  != null)
        {
            List<clsPropertyJson.cls_forRentPropertyCampaignList>  RentPropertyCampaignList   =  property.forRentPropertyCampaignList ;
            for(clsPropertyJson.cls_forRentPropertyCampaignlist  list1 : RentPropertyCampaignlist )
            {
                Rent_Property_Campaign_list__c  obj = new Rent_Property_Campaign_list__c();
                if(list1.advertisementId != null){
                    obj.AdvertisementId__c = String.valueof(list1.advertisementId);
                }
                if(list1.daysOnMarket != null)
                {
                    obj.DaysOnMarket__c  = String.valueof(list1.daysOnMarket) ;
                }
                if(list1.fromDate  != null)
                {
                    obj.FromDate__c = list1.fromDate ;
                }
                if(list1.isActiveCampaign !=  null)
                {
                    obj.isActiveCampaign__c  = list1.isActiveCampaign ;
                }
                if(list1.toDate  != null)
                {
                    obj.To_Date__c = list1.toDate;
                }
                if(list1.agency != null){
                    clsPropertyJson.cls_agency agency  =  list1.agency  ;
                    if(agency.company != null)
                    {
                        clsPropertyJson.cls_company  company = agency.company ;
                        if(company.abn != null)
                        {
                            obj.Agency_ABN__c  = company.abn ;
                        }
                        if(company.acn != null)
                        {
                            obj.Agency_ACN__c  = company.acn ;
                        }
                        if(company.companyname != null)
                        {
                            obj.Agency_CompanyName__c  = company.companyname ;
                        }
                    }
                    if(agency.phone != null)
                    {
                        clsPropertyJson.cls_phone  phone = agency.phone;
                        if(phone.isDoNotCall  != null)
                        {
                            obj.Is_Do_Not_call_Agency__c = phone.isDoNotCall ;
                        }
                        if(phone.phoneNumber != null)
                        {
                            obj.Agency_Phone_Number__c = phone.phoneNumber ;
                        }
                        if(phone.phoneNumber != null)
                        {
                            obj.Agency_Phone_Number__c = phone.phoneNumber ;
                        }
                    }
                }
                if(list1.agent  != null)
                {
                    clsPropertyJson.cls_agent  agent = list1.agent ;
                    if(agent.agent != null)
                    {
                        obj.Agent_del__c = agent.agent ;
                    }
                    if(agent.phone != null)
                    {
                        clsPropertyJson.cls_phone  phone = agent.phone;
                        if(phone.isDoNotCall  != null)
                        {
                            obj.isDoNotCall_Agent_del__c = phone.isDoNotCall ;
                        }
                        if(phone.phoneNumber != null)
                        {
                            obj.Agent_Phone_Number__c = phone.phoneNumber ;
                        }
                        if(phone.phoneNumber != null)
                        {
                            obj.Agency_Phone_Number__c = phone.phoneNumber ;
                        }
                    }
                }
                lstRentPropertyCampaignList.add(obj);
            }
        }
    }
    return lstRentPropertyCampaignList;
}

public  static List<SalePropertyCampaign__c>  createSalePropertyCampaignList(clsPropertyJson obj1)
{
    List<SalePropertyCampaign__c> SaleAgencyCampaignList = new List<SalePropertyCampaign__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.forSaleAgencyCampaignList  != null)
        {
            List<clsPropertyJson.cls_forSaleAgencyCampaignList>  SaleAgencyCampaignList1   =  property.forSaleAgencyCampaignList ;
            for(clsPropertyJson.cls_forSaleAgencyCampaignList  list1 : SaleAgencyCampaignList1 )
            {
                SalePropertyCampaign__c  obj = new SalePropertyCampaign__c();
                if(list1.advertisementId != null)
                {
                    obj.AdvertisementId__c = String.valueof(list1.advertisementId);
                }
                if(list1.daysOnMarket != null)
                {
                    obj.DaysOnMarket__c  = String.valueof(list1.daysOnMarket) ;
                }
                if(list1.fromDate  != null)
                {
                    obj.FromDate__c =list1.fromDate;
                }
                if(list1.isActiveCampaign !=  null)
                {
                    obj.isActiveCampaign__c  = list1.isActiveCampaign ;
                }
                if(list1.toDate  != null)
                {
                    obj.ToDate__c = list1.toDate;
                }
                if(list1.dayslisted != null)
                {
                    obj.dayslisted__c  = String.valueof(list1.dayslisted );
                }
                if(list1.saleDate != null)
                {
                    obj.saleDate__c  =list1.saleDate ;
                }
                if(list1.agency != null){
                    clsPropertyJson.cls_agency agency  =  list1.agency  ;
                    if(agency.company != null)
                    {
                        clsPropertyJson.cls_company  company = agency.company ;
                        if(company.abn != null)
                        {
                            obj.Agency_ABN__c  = company.abn ;
                        }
                        if(company.acn != null)
                        {
                            obj.Agency_ACN__c  = company.acn ;
                        }
                        if(company.companyname != null)
                        {
                            obj.Agency_CompanyName__c  = company.companyname ;
                        }
                    }
                    if(agency.phone != null)
                    {
                        clsPropertyJson.cls_phone  phone = agency.phone;
                        if(phone.isDoNotCall  != null)
                        {
                            obj.Is_Do_Not_call_Agency__c = phone.isDoNotCall ;
                        }
                        if(phone.phoneNumber != null)
                        {
                            obj.Agency_Phone_Number__c = phone.phoneNumber ;
                        }
                    }
                }
                SaleAgencyCampaignList.add(obj);
            }
        }
    }
    return SaleAgencyCampaignList ;
}
public static List<Feature__c>    CreateFeatureInstance (clsPropertyJson obj1)
{
    List<Feature__c>  LstFeatureList  = new List<Feature__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.featureList  != null)
        {
            List<clsPropertyJson.cls_featureList> featureList = property.featureList;
            for(clsPropertyJson.cls_featureList  feature : featureList  )
            {
                Feature__c  obj = new Feature__c();
                if(feature.abbreviation  != null)
                {
                    obj.abbreviation__C = feature.abbreviation ;
                }
                if(feature.id  != null)
                {
                    obj.id__C = String.valueof(feature.id) ;
                }
                if(feature.name  != null)
                {
                    obj.name__C = feature.name ;
                }
                if(feature.type  != null)
                {
                    obj.type__C = feature.type ;
                }
                if(feature.value  != null)
                {
                    obj.value__C = feature.value ;
                }
                LstFeatureList.add(obj);
            }
        }
    }
    return LstFeatureList ;
}
public static List<External_Reference__c>    createExternalReferenceInstance (clsPropertyJson obj1)
{
    List<External_Reference__c>  LstExternalReferenceList  = new List<External_Reference__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.externalReferenceList  != null)
        {
            List<clsPropertyJson.cls_externalReferenceList> currentOwnershipList = property.externalReferenceList;
            for(clsPropertyJson.cls_externalReferenceList externalReference  :  currentOwnershipList)
            {
                External_Reference__c obj = new External_Reference__c();
                if(externalReference.type  != null)
                {
                    obj.type__C = externalReference.type ;
                }
                if(externalReference.value  != null)
                {
                    obj.value__C = externalReference.value ;
                }
                LstExternalReferenceList.add(obj);
            }
        }
    }
    return LstExternalReferenceList;
}
public static List<Development_Application_List__c>    CreateDevelopmentApplicationListInstance (clsPropertyJson obj1)
{
    List<Development_Application_List__c>  LstDevelopmentApplicationList  = new List<Development_Application_List__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.developmentApplicationList  != null)
        {
            List<clsPropertyJson.cls_developmentApplicationList> currentOwnershipList = property.developmentApplicationList;
            for(clsPropertyJson.cls_developmentApplicationList conObj : currentOwnershipList  )
            {
                Development_Application_List__c obj = new Development_Application_List__c();
                if(conObj.approvingAuthority != null)
                {
                    obj.Approving_Authority__c =  conObj.approvingAuthority ;
                }
                if(conObj.buildArea != null)
                {
                    obj.buildArea__c =  String.valueof(conObj.buildArea) ;
                }
                if(conObj.BuildValue != null)
                {
                    obj.BuildValue__c =  String.valueof(conObj.BuildValue) ;
                }
                if(conObj.constructionType != null)
                {
                    obj.constructionType__C =  String.valueof(conObj.constructionType) ;
                }
                if(conObj.developmentApplicationType != null)
                {
                    obj.developmentApplicationType__C =  String.valueof(conObj.developmentApplicationType) ;
                }
                if(conObj.floorMaterial != null)
                {
                    obj.floorMaterial__C =  String.valueof(conObj.floorMaterial) ;
                }
                if(conObj.monthOfSubmission != null)
                {
                    obj.Month_Of_Submission__c =  String.valueof(conObj.monthOfSubmission) ;
                }
                if(conObj.permitIssueDate != null)
                {
                    obj.permitIssueDate__C =  String.valueof(conObj.permitIssueDate) ;
                }
                if(conObj.permitNumber != null)
                {
                    obj.permitNumber__C =  String.valueof(conObj.permitNumber) ;
                }
                if(conObj.propertyId != null)
                {
                    //obj.permitNumber__C =  String.valueof(conObj.propertyId) ;
                }
                if(conObj.roofMaterial != null)
                {
                    obj.roofMaterial__C =  String.valueof(conObj.roofMaterial) ;
                }
                if(conObj.wallMaterial != null)
                {
                    obj.wallMaterial__C =  String.valueof(conObj.wallMaterial) ;
                }
                if(conObj.builderCompany != null )
                {
                    clsPropertyJson.cls_builderCompany company =   conObj.builderCompany ;
                    if(company.abn != null)
                    {
                        obj.ABN__C  =company.abn;
                    }
                    if(company.acn != null)
                    {
                        obj.AcN__C =company.acn;
                    }
                    if(company.companyName != null)
                    {
                        obj.CompanyName__c = company.companyName ;
                    }
                }
                if(conObj.builderAddress != null)
                {
                    clsPropertyJson.cls_builderAddress   mailingAddress  =  conObj.builderAddress ;
                    if(mailingAddress.careOf != null)
                    {
                        obj.CareOf__c = mailingAddress.careOf  ;
                    }
                    if(mailingAddress.country != null)
                    {
                        obj.Country__C = mailingAddress.country  ;
                    }
                    if(mailingAddress.isDoNotMail != null)
                    {
                        obj.isDoNotMail__c = mailingAddress.isDoNotMail  ;
                    }
                    if(mailingAddress.line1 != null)
                    {
                        obj.line1__c = mailingAddress.line1  ;
                    }
                    if(mailingAddress.line2 != null)
                    {
                        obj.line2__c = mailingAddress.line2  ;
                    }
                    if(mailingAddress.postcode != null)
                    {
                        obj.postcode__c = mailingAddress.postcode  ;
                    }
                    if(mailingAddress.state != null)
                    {
                        obj.State__c = mailingAddress.state  ;
                    }
                    if(mailingAddress.suburb != null)
                    {
                        obj.suburb__C = mailingAddress.suburb  ;
                    }
                }
                if(conObj.builderPhone != null)
                {
                    clsPropertyJson.cls_builderPhone  phone  = conObj.builderPhone  ;
                    if(phone.isDoNotCall != null)
                    {
                        obj.isDoNotCall__C = phone.isDoNotCall;
                    }
                    if(phone.phoneNumber != null)
                    {
                        obj.PhoneNumber__c = phone.phoneNumber;
                    }
                }
            }
        }
    }
    return  LstDevelopmentApplicationList ;
}
public static List<Current_Ownership__c>    CreateCurrentOwnershipInstance (clsPropertyJson obj1)
{
    List<Current_Ownership__c>  LstCurrentOwnership  = new List<Current_Ownership__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.currentOwnershipList  != null)
        {
            List<clsPropertyJson.cls_currentOwnershipList> currentOwnershipList = property.currentOwnershipList;
            for(clsPropertyJson.cls_currentOwnershipList conObj : currentOwnershipList  )
            {
                Current_Ownership__c obj = new Current_Ownership__c();
                if(conObj.company != null )
                {
                    clsPropertyJson.cls_company company =   conObj.company ;
                    if(company.abn != null)
                    {
                        obj.ABN__C  =company.abn;
                    }
                    if(company.acn != null)
                    {
                        obj.AcN__C =company.acn;
                    }
                    if(company.companyName != null)
                    {
                        obj.CompanyName__c = company.companyName ;
                    }
                }
                if(conObj.mailingAddress != null)
                {
                    clsPropertyJson.cls_mailingAddress   mailingAddress  =  conObj.mailingAddress ;
                    if(mailingAddress.careOf != null)
                    {
                        obj.careOf__C = mailingAddress.careOf  ;
                    }
                    if(mailingAddress.country != null)
                    {
                        obj.Country__C = mailingAddress.country  ;
                    }
                    if(mailingAddress.isDoNotMail != null)
                    {
                        obj.isDoNotMail__c = mailingAddress.isDoNotMail  ;
                    }
                    if(mailingAddress.line1 != null)
                    {
                        obj.line1__c = mailingAddress.line1  ;
                    }
                    if(mailingAddress.line2 != null)
                    {
                        obj.line2__c = mailingAddress.line2  ;
                    }
                    if(mailingAddress.postcode != null)
                    {
                        obj.postcode__c = mailingAddress.postcode  ;
                    }
                    if(mailingAddress.state != null)
                    {
                        obj.State__c = mailingAddress.state  ;
                    }
                    if(mailingAddress.suburb != null)
                    {
                        obj.suburb__C = mailingAddress.suburb  ;
                    }
                }
                if(conObj.person != null)
                {
                    clsPropertyJson.cls_person  person  = conObj.person  ;
                    if(person.firstName != null)
                    {
                        obj.FirstName__c =  person.firstName ;
                    }
                    if(person.initials != null)
                    {
                        obj.Initials__c = person.Initials    ;
                    }
                    if(person.lastName != null)
                    {
                        obj.LastName__c = person.lastName;
                    }
                    if(person.middleNames != null)
                    {
                        obj.MiddleNames__c = person.middleNames;
                    }
                }
                LstCurrentOwnership.add(obj);
            }
        }
    }
    return LstCurrentOwnership ;
}
public static List<Contact__c>   createContactInstance (clsPropertyJson obj1)
{
    List<Contact__c>  lstContact  = new List<Contact__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.contactList  != null)
        {
            List<clsPropertyJson.cls_contactList>  lst = property.contactList ;
            for(clsPropertyJson.cls_contactList conObj : lst)
            {
                Contact__c obj  =  new  Contact__c();
                if(conObj.contactType != null)
                {
                    obj.contactType__C  = String.valueof(conObj.contactType);
                }
                if(conObj.email != null)
                {
                    obj.email__C  = String.valueof(conObj.email );
                }
                if(conObj.company != null )
                {
                    clsPropertyJson.cls_company company =   conObj.company ;
                    if(company.abn != null)
                    {
                        obj.ABN__C  =company.abn;
                    }
                    if(company.acn != null)
                    {
                        obj.AcN__C =company.acn;
                    }
                    if(company.companyName != null)
                    {
                        obj.Company_Name__c = company.companyName ;
                    }
                }
                if(conObj.mailingAddress != null)
                {
                    clsPropertyJson.cls_mailingAddress   mailingAddress  =  conObj.mailingAddress ;
                    if(mailingAddress.careOf != null)
                    {
                        obj.careOf__C = mailingAddress.careOf  ;
                    }
                    if(mailingAddress.country != null)
                    {
                        obj.Country__C = mailingAddress.country  ;
                    }
                    if(mailingAddress.isDoNotMail != null)
                    {
                        obj.isDoNotMail__c = mailingAddress.isDoNotMail  ;
                    }
                    if(mailingAddress.line1 != null)
                    {
                        obj.line1__c = mailingAddress.line1  ;
                    }
                    if(mailingAddress.line2 != null)
                    {
                        obj.line2__c = mailingAddress.line2  ;
                    }
                    if(mailingAddress.postcode != null)
                    {
                        obj.postcode__c = mailingAddress.postcode  ;
                    }
                    if(mailingAddress.state != null)
                    {
                        obj.State__c = mailingAddress.state  ;
                    }
                    if(mailingAddress.suburb != null)
                    {
                        obj.suburb__C = mailingAddress.suburb  ;
                    }
                }
                if(conObj.person != null)
                {
                    clsPropertyJson.cls_person  person  = conObj.person  ;
                    if(person.firstName != null)
                    {
                        obj.FirstName__c =  person.firstName ;
                    }
                    if(person.initials != null)
                    {
                        obj.Initials__c = person.Initials    ;
                    }
                    if(person.lastName != null)
                    {
                        obj.LastName__c = person.lastName;
                    }
                    if(person.middleNames != null)
                    {
                        obj.MiddleNames__c = person.middleNames;
                    }
                }
                if(conObj.phone != null)
                {
                    clsPropertyJson.cls_phone  phone  = conObj.phone  ;
                    if(phone.isDoNotCall != null)
                    {
                        obj.isDoNotCall__C = phone.isDoNotCall;
                    }
                    if(phone.phoneNumber != null)
                    {
                        obj.PhoneNumber__c = phone.phoneNumber;
                    }
                }
                lstContact.add(obj);
            }
        }
    }
    return lstContact ;
}
public  static List<Avm_Detail__c>   CreateAvmDetailInstance(clsPropertyJson  obj1 )
{
    List<Avm_Detail__c> lstAvmDetails = new  List<Avm_Detail__c>();
    if(obj1.property  != null )
    {
        clsPropertyJson.cls_property  property = obj1.property ;
        if(property.avmDetailList != null)
        {
            List<clsPropertyJson.cls_avmDetailList>  lst = property.avmDetailList ;
            if(lst.size() > 0)
            {
                for(clsPropertyJson.cls_avmDetailList  avm : lst)
                {
                    Avm_Detail__c obj  =  new  Avm_Detail__c();
                    if(avm.estimate != null)
                    {
                        obj.Estimate__c  = String.valueof(avm.estimate );
                    }
                    if(avm.fsd != null)
                    {
                        obj.Fsd__c  = String.valueof(avm.fsd );
                    }
                    if(avm.highEstimate != null)
                    {
                        obj.highEstimate__C  = String.valueof(avm.highEstimate );
                    }
                    if(avm.lowEstimate != null)
                    {
                        obj.lowEstimate__C  = String.valueof(avm.lowEstimate );
                    }
                    if(avm.propertyId != null)
                    {
                        //String.valueof(avm.propertyId );
                    }
                    if(avm.score != null)
                    {
                        obj.score__C  = String.valueof(avm.score );
                    }
                    if(avm.valuationDate != null)
                    {
                        obj.Valuation_Date__c  = String.valueof(avm.valuationDate );
                    }
                    if(avm.source != null)
                    {
                        obj.Source__c  = String.valueof(avm.source );
                    }
                    lstAvmDetails.add(obj);
                }
            }
        }
    }
    return lstAvmDetails;
}
public acfPropertydetails__c createPropertInstance( clsPropertyJson  obj )
{
    acfPropertydetails__c ObjProp = new  acfPropertydetails__c();        
    if(obj.property  != null )
    {
        clsPropertyJson.cls_property  property = obj.property ;
        system.debug('@@@@propertyid'+property.id);
        integer propertyid = Integer.valueOf(property.id);
        system.debug('@@@'+propertyid);
        system.debug('@@@'+mapAssetWithPropertyId);
        system.debug('@@@'+assetMap);
        system.debug('@@@@billid'+assetMap.get(mapAssetWithPropertyId.get(String.valueOf(property.id))));
        if(propertyid !=null && mapAssetWithPropertyId !=null && mapAssetWithPropertyId.containsKey(String.valueOf(propertyid)))
        {
            Asset_And_Liability__c assetObj = new Asset_And_Liability__c();
            assetObj = assetMap.get(mapAssetWithPropertyId.get(String.valueOf(propertyid)));
  
            if(property.legal != null)
            {
                clsPropertyJson.cls_legal legal =  property.legal ;
                if(legal.dateIssued != null)
                {
                    objProp.LegalDateIssued__c =   legal.dateIssued  ;
                }
                if(legal.frontage != null)
                {
                    objProp.LegalFrontAge__c = legal.frontage  ;
                }
                if(legal.heritageRegistered != null)
                {
                    objProp.HeritageRegistered__C = legal.heritageRegistered ;
                }
                if(legal.mapReference != null)
                {
                    objProp.mapReference__C = legal.mapReference ;
                }
                if(legal.mapScale != null)
                {
                    objProp.map_Scale__C = legal.mapScale ;
                }
                if(legal.mapSheet != null)
                {
                    ObjProp.MapSheet__C = legal.mapSheet ;
                }
                if(legal.realPropertyDescription != null)
                {
                    objProp.realPropertyDescription__c  = legal.realPropertyDescription ;
                }
                if(legal.vgMeasurement != null)
                {
                    objProp.vgMeasurement__C  = legal.vgMeasurement ;
                }
                if(legal.vgNumber != null)
                {
                    objProp.vgNumber__C =  legal.vgNumber ;
                }
                if(legal.vgoMap != null)
                {
                    objProp.vgoMap__c  = legal.vgoMap ;
                }
            }
            if(property.coordinate !=null)
            {
                clsPropertyJson.cls_coordinate coordinate   = property.coordinate ;
                if(coordinate.latitude != null)
                {
                    ObjProp.latitude__C = STring.valueof(coordinate.latitude) ;
                }
                if(coordinate.longitude != null)
                {
                    ObjProp.longitude__C =  String.valueof(coordinate.longitude) ;
                }
            }
            if(property.title !=null)
            {
                clsPropertyJson.cls_title title   = property.title ;
                if(title.feeCode != null)
                {
                    ObjProp.FeeCode__C =  title.feeCode  ;
                }
                if(title.folio != null)
                {
                    ObjProp.Folio__C =  title.folio ;
                }
                if(title.instrument != null)
                {
                    ObjProp.Instrument__C = String.valueof(title.instrument) ;
                }
                if(title.ownerCode != null)
                {
                    ObjProp.OwnerCode__c = String.valueof(title.ownerCode) ;
                }
                if(title.tenureNumber != null)
                {
                    ObjProp.TenureNumber__C =  String.valueof(title.tenureNumber) ;
                }
                if(title.tenureReference != null)
                {
                    ObjProp.tenureReference__C = title.tenureReference ;
                }
                if(title.titleIndicator != null)
                {
                    ObjProp.TitleIndicator__c = title.titleIndicator ;
                }
                if(title.titlePrefix != null)
                {
                    ObjProp.TitlePrefix__C = title.titlePrefix ;
                }
                if(title.titleReference != null)
                {
                    objProp.TitleReference__C =title.titleReference ;
                }
                if(title.titleSuffix != null)
                {
                    objProp.titleSuffix__C =  title.titleSuffix ;
                }
                if(title.volume != null)
                {
                    ObjProp.volume__C = title.volume ;
                }
            }
            if(property.site !=null)
            {
                clsPropertyJson.cls_site site =  property.site ;
                if(site.landUsePrimary  != null )
                {
                    ObjProp.landUsePrimary__c =   site.landUsePrimary ;
                }
                if(site.landUseSecondary  != null )
                {
                    ObjProp.landUseSecondary__c =   site.landUseSecondary ;
                }
                if(site.zoneCodeGeneral  != null )
                {
                    ObjProp.Zone_Code_General__C =   site.zoneCodeGeneral ;
                }
                if(site.zoneCodeLocal  != null )
                {
                    ObjProp.ZoneCodeLocal__C =   site.zoneCodeLocal ;
                }
                if(site.zoneDescriptionGeneral  != null )
                {
                    ObjProp.Zone_Description_General__C =   site.zoneDescriptionGeneral ;
                }
                if(site.zoneDescriptionLocal  != null )
                {
                    ObjProp.ZoneDescriptionLocal__c =   site.zoneDescriptionLocal ;
                }
            }
            if(property.id !=null)
            {
                ObjProp.PropertyID__c  = String.valueof( Integer.valueof(property.id));
            }
            if(property.occupancyType !=null)
            {
                ObjProp.OccupancyType__c  = String.valueof(property.occupancyType);
            }
            if(property.propertySubType !=null)
            {
                ObjProp.propertySubType__C  = String.valueof(property.propertySubType);
            }
            if(property.propertySubTypeShort !=null)
            {
                ObjProp.propertySubTypeShort__C  = String.valueof(property.propertySubTypeShort);
            }
            if(property.propertyType !=null)
            {
                ObjProp.propertyType__C  = String.valueof(property.propertyType);
            }
            
            if(property.address  != null)
            {
                clsPropertyJson.cls_address  address = property.address ;
                if(address.buildingComplexName  != null)
                {
                    ObjProp.buildingComplexName__C = address.buildingComplexName ;
                }
                if(address.councilArea  != null)
                {
                    ObjProp.councilArea__c = address.councilArea ;
                }
                if(address.endAlpha  != null)
                {
                    ObjProp.End_Alpha__C = address.endAlpha ;
                }
                if(address.endNumber  != null)
                {
                    ObjProp.End_Number__C = String.valueof(address.endNumber );
                }
                if(address.isDerivedUnit  != null)
                {
                    ObjProp.isDerivedUnit__C = address.isDerivedUnit ;
                }
                if(address.singleLine  != null)
                {
                    ObjProp.singleLine__c = address.singleLine ;
                }
                if(address.startAlpha  != null)
                {
                    ObjProp.Start_Alpha__C = address.startAlpha ;
                }
                if(address.startNumber  != null)
                {
                    ObjProp.startNumber__c = String.valueof(address.startNumber) ;
                    assetObj.Street_Number__c = String.valueof(address.startNumber);
                }
                if(address.startNumber  != null && address.unitNumber  != null)
                {
                    assetObj.Street_Number__c = String.valueof(Integer.valueOf(address.unitNumber)) +'/'+String.valueof(Integer.valueOf(address.startNumber));
                }
                if(address.unitAlpha  != null)
                {
                    ObjProp.unitAlpha__c = address.unitAlpha ;
                }
                if(address.unitNumber  != null)
                {
                    ObjProp.UnitNumber__c = String.valueof(address.unitNumber) ;
                }
                if(address.unitNumber  != null)
                {
                    ObjProp.UnitNumber__c = String.valueof(address.unitNumber) ;
                }
                if( address.street  != null)
                {
                    clsPropertyJson.cls_street street = address.street ;
                    if(street.direction != null)
                    {
                        ObjProp.direction__C =street.direction ;
                    }
                    if(street.extension != null)
                    {
                        ObjProp.Extension__c =street.extension ;
                        assetObj.Street_Type__c = street.extension;
                    }
                    if(street.id != null)
                    {
                        ObjProp.StreetID__c = String.valueof(street.id) ;
                    }
                    if(street.name != null)
                    {
                        ObjProp.Street_Name__C = String.valueof(street.name) ;
                        assetObj.Street_Name__c = String.valueof(street.name); 
                    }
                    if(street.singleLine != null)
                    {
                        ObjProp.Street_SingleLine__C  = String.valueof(street.singleLine) ;
                    }
                    if( street.locality != null)
                    {
                        clsPropertyJson.cls_locality  locality = street.locality ;
                        if(locality.id != null )
                        {
                            ObjProp.locality_ID__c = String.valueof(locality.id) ;
                        }
                        if(locality.name != null )
                        {
                            ObjProp.locality_Name__c = locality.name ;
                            assetObj.City__c = String.valueof(locality.name); 
                        }
                        if(locality.singleLine != null )
                        {
                            ObjProp.Locality_Single_Line__c = locality.singleLine ;
                        }
                        if(locality.postcode != null )
                        {
                            clsPropertyJson.cls_postcode  postcode =    locality.postcode ;
                            if(postcode.ID != null)
                            {
                                ObjProp.Postcode_ID__c = String.valueof(postcode.ID) ;
                            }
                            if(postcode.state != null)
                            {
                                ObjProp.state__C = postcode.state ;
                                assetObj.State__c = postcode.state;
                            }
                            if(postcode.name != null)
                            {
                                ObjProp.Post_Code_Name__C = String.valueof(postcode.name) ;
                                assetObj.Postcode__c = Integer.valueOf(postcode.name);
                                
                            }
                            if(postcode.singleLine != null)
                            {
                                ObjProp.Post_code_Single_Line__C = postcode.singleLine ;
                                
                            }
                        }
                    }
                }
            }
            if(property.attributes != null)
            {
                clsPropertyJson.cls_attributes attributes  = property.attributes ;
                if(attributes.bathrooms != null)
                {
                    ObjProp.Bathrooms__c =   String.valueof(attributes.bathrooms );
                }
                if(attributes.bedrooms != null)
                {
                    ObjProp.Bedrooms__c =   String.valueof(attributes.bedrooms );
                }
                if(attributes.carSpaces != null)
                {
                    ObjProp.CarSpaces__c =   String.valueof(attributes.carSpaces );
                }
                if(attributes.floorArea  != null)
                {
                    ObjProp.floorArea__C =   String.valueof(attributes.floorArea );
                }
                if(attributes.isCalculatedLandArea  != null)
                {
                    ObjProp.isCalculatedLandArea__c =   attributes.isCalculatedLandArea ;
                }
                if(attributes.landArea  != null)
                {
                    ObjProp.LandArea__c =    String.valueof(attributes.landArea) ;
                }
                if(attributes.lockUpGarages  != null)
                {
                    ObjProp.lockUpGarages__c =    String.valueof(attributes.lockUpGarages) ;
                }
                if(attributes.roofMaterial  != null)
                {
                    ObjProp.roofMaterial__C =    String.valueof(attributes.roofMaterial) ;
                }
                if(attributes.wallMaterial  != null)
                {
                    ObjProp.Wall_Material__c =    String.valueof(attributes.wallMaterial) ;
                }
                if(attributes.yearBuilt  != null)
                {
                    ObjProp.yearBuilt__c =    String.valueof(attributes.yearBuilt) ;
                }
            }
            assetList.add(assetObj);
        }
    }    
    System.debug('@@@@asset'+assetList);
    return ObjProp;
}
    public clsPropertyJson  createPropertyRecords(String propertId )
    {
        String singleRes = '';
        CoreLogicServices obj1 = new CoreLogicServices();
        HttpResponse res  = obj1.getSinglePropertyDetail(propertId);
        if(!test.isrunningtest())
        {
            singleRes = res.getBody();
            if(!mapPropertyIdToresponse.containsKey(propertId))
            {
                mapPropertyIdToresponse.put(propertId,singleRes);
            }
        }
        else
        {
            singleRes = '{"property":{"address":{"councilArea":"Woollahra","startAlpha":"Woollahra","unitAlpha":"Woollahra","unitNumber":7,"buildingComplexName":"Woollahra","endAlpha":"Woollahra","endNumber":8,"isDerivedUnit":true,"singleLine":"13 Gipps Street Paddington NSW 2021","startNumber":13,"street":{"extension":"STREET","direction":"Woollahra","id":2656373,"locality":{"id":20440,"name":"PADDINGTON","postcode":{"id":1105315,"name":"2021","singleLine":"2021 NSW","state":"NSW"},"singleLine":"Paddington NSW 2021"},"name":"GIPPS","nameAndNumber":"13 GIPPS STREET ","singleLine":"Gipps Street Paddington NSW 2021"}},"attributes":{"bathrooms":2,"bedrooms":3,"carSpaces":2,"isCalculatedLandArea":false,"landArea":150,"lockUpGarages":1,"floorArea":1.0,"roofMaterial":1.08,"wallMaterial":1.0,"yearBuilt":8.9},"avmDetailList":[{"estimate":2072000,"fsd":16,"highEstimate":2401900,"lowEstimate":1742200,"score":74,"source":"R","valuationDate":"2016-09-18"}],"forRentPropertyCampaignList":[{"advertisementId":8.0,"daysOnMarket":3.0,"fromDate":"2016-09-09T11:27:04.738Z","isActiveCampaign":false,"period":"2","price":3.0,"priceDescription":"test","toDate":"2016-09-09T11:27:04.738Z","agency":{"company":{"companyName":"Hub Realty - Cremorne","abn":"3456","acn":"876"},"phone":{"phoneNumber":"(02) 9964 0255"}},"agent":{"agent":"Merryl Eve Johnson","phone":{"phoneNumber":"0413 733 366"}}}],"contactList":[{"contactType":"Phone","email":"em@gmail.com","mailingAddress":{"careOf":"PETER","country":"AUS","state":"NSW","suburb":"test","isDoNotMail":false,"line1":"13 GIPPS ST","line2":"PADDINGTON NSW","postcode":"2021"},"company":{"abn":"3456","acn":"876","companyName":"true"},"person":{"firstName":"PETER","lastName":"DAVIES"},"phone":{"isDoNotCall":false}}],"developmentApplicationList":[{"approvingAuthority":"Phone","buildArea":"0.8","buildValue":"13.12","constructionType":"PADDINGTON NSW","developmentApplicationType":"test","builderAddress":{"careOf":"PETER","country":"AUS","isDoNotMail":true,"line1":"DAVIES","line2":"PADDINGTON NSW","postcode":"2021","state":"NSW","suburb":"test"},"builderCompany":{"abn":"3456","acn":"876","companyName":"true"},"builderPhone":{"isDoNotCall":true,"phoneNumber":"99907544456"},"floorMaterial":"test","monthOfSubmission":"Nov","permitIssueDate":"2016-09-09T11:27:04.738Z","permitNumber":"8765456","propertyId":"7654456","roofMaterial":"test","wallMaterial":"test"}],"currentOwnershipList":[{"company":{"abn":"3456","acn":"876","companyName":"true"},"mailingAddress":{"careOf":"PETER","country":"AUS","isDoNotMail":true,"line1":"DAVIES","line2":"PADDINGTON NSW","postcode":"2021","state":"NSW","suburb":"test"},"person":{"firstName":"PETER","lastName":"DAVIES","initials":"PETER","middleNames":"DAVIES"}}],"externalReferenceList":[{"type":"Map Reference","value":"UBD NSW: SYDK, M16"},{"type":"REA ID","value":"123424486"}],"featureList":[{"abbreviation":"LUG","id":261521,"name":"Lockup Garages","type":"Integer","value":"1"},{"abbreviation":"B/INS","id":261721,"name":"Built In Wardrobes","type":"Boolean","value":"TRUE"},{"abbreviation":"ENS","id":259992,"name":"Ensuites","type":"Integer","value":"1"}],"forSaleAgencyCampaignList":[{"advertisementId":128174675,"agency":{"company":{"companyName":"Hub Realty - Cremorne","abn":"3456","acn":"876"},"phone":{"phoneNumber":"0299640255","isDoNotCall":true}},"daysListed":24,"daysOnMarket":25,"fromDate":"2016-08-24","isActiveCampaign":false,"saleDate":"2016-09-17","toDate":"2016-09-16"},{"advertisementId":126723066,"daysListed":1,"daysOnMarket":24,"fromDate":"2016-08-25","isActiveCampaign":false,"saleDate":"2016-09-17","toDate":"2016-08-25"}],"forSalePropertyCampaignList":[{"advertisementId":128174675,"agency":{"company":{"companyName":"Hub Realty - Cremorne"},"phone":{"phoneNumber":"(02) 9964 0255"}},"agent":{"agent":"Merryl Eve Johnson","phone":{"phoneNumber":"0413 733 366"}},"daysListed":24,"daysOnMarket":25,"fromDate":"2016-08-24","isActiveCampaign":false,"listingMethod":"Auction","priceDescription":"Not Disclosed","saleDate":"2016-09-17","toDate":"2016-09-16"}],"id":2028759,"legal":{"dateIssued":"1609","heritageRegistered":"Yes","mapReference":"test","mapScale":"tett","mapSheet":"test","vgoMap":"test","frontage":"0","realPropertyDescription":"LOT 5 DP263685 :PH ALEXANDRIA","vgMeasurement":"7","vgNumber":"0000002087935"},"parcelList":[{"area":"","block":"Lot/Plan","hundred":"Lot/Plan","location":"Lot/Plan","lotAlpha":"Lot/Plan","lotPart":"Lot/Plan","referenceSection":"Lot/Plan","section":"Lot/Plan","sectionPart":"Lot/Plan","surveyPlan":"Lot/Plan","displayName":"Lot/Plan","displayValue":"5/DP263685","isPrimaryPlan":true,"landAuthority":"Woollahra","lot":"5","plan":"263685","planType":"DP"}],"propertyPhotoList":[{"isDefaultPhoto":true,"largePhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/768x512/16/08/24/27478172/27478172_1.JPG","mediumPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/470x313/16/08/24/27478172/27478172_1.JPG","scanDate":"2016-08-24","thumbnailPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/120x80/16/08/24/27478172/27478172_1.JPG"},{"isDefaultPhoto":false,"largePhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/768x512/16/08/24/27478172/27478172_2.JPG","mediumPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/470x313/16/08/24/27478172/27478172_2.JPG","scanDate":"2016-08-24","thumbnailPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/120x80/16/08/24/27478172/27478172_2.JPG"},{"isDefaultPhoto":false,"largePhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/768x512/16/08/24/27478172/27478172_3.JPG","mediumPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/470x313/16/08/24/27478172/27478172_3.JPG","scanDate":"2016-08-24","thumbnailPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/120x80/16/08/24/27478172/27478172_3.JPG"},{"isDefaultPhoto":false,"largePhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/768x512/16/08/24/27478172/27478172_4.JPG","mediumPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/470x313/16/08/24/27478172/27478172_4.JPG","scanDate":"2016-08-24","thumbnailPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/120x80/16/08/24/27478172/27478172_4.JPG"},{"isDefaultPhoto":false,"largePhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/768x512/16/08/24/27478172/27478172_5.JPG","mediumPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/470x313/16/08/24/27478172/27478172_5.JPG","scanDate":"2016-08-24","thumbnailPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/120x80/16/08/24/27478172/27478172_5.JPG"},{"isDefaultPhoto":false,"largePhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/768x512/16/08/24/27478172/27478172_6.JPG","mediumPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/470x313/16/08/24/27478172/27478172_6.JPG","scanDate":"2016-08-24","thumbnailPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/120x80/16/08/24/27478172/27478172_6.JPG"},{"isDefaultPhoto":false,"largePhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/768x512/05/02/08/NSW01091F/284.JPG","mediumPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/470x313/05/02/08/NSW01091F/284.JPG","scanDate":"2005-02-08","thumbnailPhotoUrl":"https://static.rpdata.com/rpdaAU/photo/listsale/120x80/05/02/08/NSW01091F/284.JPG"}],"propertySubTypeShort":"House","occupancyType":"House","propertySubType":"House","propertyType":"HOUSE","saleList":[{"agency":{"company":{"companyName":"Hub Realty - Cremorne"}},"contractDate":"2016-09-17","isAgentsAdvice":true,"isReaRecentSale":false,"price":2550000,"settlementDate":"2016-09-17","transferId":88170195,"type":"Unknown"}],"site":{"landUsePrimary":"General Commercial","landUseSecondary":"General Commercial","zoneCodeGeneral":"General Commercial","zoneDescriptionGeneral":"General Commercial","siteValueList":[{"date":"1997-07-01","type":"UCV","valuationNumber":"0000002087935","value":236000}],"zoneCodeLocal":"Z","zoneDescriptionLocal":"Undetermined Or Village"},"title":{"folio":"","ownerCode":"Corporation","feeCode":"Corporation","instrument":9,"tenureNumber":"12","tenureReference":"Corporation","titleIndicator":"No More Titles","titlePrefix":"","titleReference":"5/263685","titleSuffix":"","volume":""},"coordinate":{"latitude":23.54,"longitude":76.9}},"systemInfo":{"instanceName":"71:8080","requestDate":"2016-09-20T17:21:01.022+10:00"}}}';
        }
        System.debug(singleRes);
        return  clsPropertyJson.parse(singleRes );
    }
}