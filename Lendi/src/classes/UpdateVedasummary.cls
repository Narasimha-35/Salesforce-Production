global class UpdateVedasummary implements Database.Batchable<sObject> , Database.AllowsCallouts
{
    
    global  List<id> lstId ;
   
    global UpdateVedasummary(List<id> lstId1) {
        System.debug('_________'+lstId );
        lstId =lstId1 ;
        System.debug(lstId );
    }
  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug(lstId);
        return DataBase.getQueryLocator([Select  Middle_Name__c, Address__C, First_Name__c, Last_Name__c, Gender__c,id,acf_applicant_DOB__c, acfRelationship_code__c, clickOpportunity__c,acf_Applicant_Name__c, click_Account__r.acfWhat_is_your_postcode__pc  ,
        acf_applicant_Employer_Name__c from  click_Applicant__c  where id  in : lstId ]  );
    }
   
    global void execute(Database.BatchableContext BC,List<click_Applicant__c> appObj) {
        
        map<Veda_Summary__c , Attachment> mapAttachment = new map<Veda_Summary__c , Attachment>();
        map<Id , click_Applicant__c> mapApplicantNAme = new map<Id , click_Applicant__c> ();
        for(click_Applicant__c   insObj : appObj )
        {
            if(insObj.First_name__c != null &&  insObj.Last_name__c != null  &&  insObj.Address__C!= null  && insObj.Gender__c != null &&
            insObj.acf_applicant_Employer_Name__c != null  && insObj.acfRelationship_code__c  != null)
            {
                clsVedaController obj = new clsVedaController();
                Map<string,VedaRequest__c> mapfileds = VedaRequest__c.getAll();
               if(mapfileds != null  && mapfileds.get('Request').account_type_code__c != null )
                obj.accounttypecode = mapfileds.get('Request').account_type_code__c;
               
               if(mapfileds != null  && mapfileds.get('Request').Permissiontypecode__c != null )
                obj.permissiontypecode = mapfileds.get('Request').Permissiontypecode__c;
              
               if(mapfileds != null  && mapfileds.get('Request').enquiry_client_reference__c  != null )
                obj.enquiryclientreference  = mapfileds.get('Request').enquiry_client_reference__c;
              
               if(mapfileds != null  && mapfileds.get('Request').operator_id__c  != null )
                obj.operatorid  = mapfileds.get('Request').operator_id__c;
              
               if(mapfileds != null  && mapfileds.get('Request').operator_name__c  != null )
                obj.operatorname  = mapfileds.get('Request').operator_name__c;
               
               if(mapfileds != null  && mapfileds.get('Request').scorecard_id__c  != null ) {
                    List<String> sid  = mapfileds.get('Request').scorecard_id__c.split(',');
                    obj.scorecardid  = sid;
                }
                if(mapfileds != null  && mapfileds.get('Request').Product_data_level_code__c  != null )
                obj.productdatalevelcode  = mapfileds.get('Request').Product_data_level_code__c;
                obj.clientReference  = insObj.Id ;
                obj.enquiryamount = '0';
                obj.firstgivenname = insObj.First_Name__c;
                obj.familyname= insObj.Last_Name__c ;
                obj.middlename = insobj.Middle_Name__c == null ? '' : insobj.Middle_Name__c;
                obj.relationshipcode  = Integer.valueof(insObj.acfRelationship_code__c);
                obj.unformattedaddres  = insObj.Address__C;
                if(insObj.Gender__c != null)
                obj.gendercode = insObj.Gender__c == 'Male' ? 'M' : 'F'  ;
                obj.name =  insObj.acf_applicant_Employer_Name__c  == null ? '' : insObj.acf_applicant_Employer_Name__c ;
                Map<string,acfveda__c> mapCodes = acfveda__c.getAll();
                if(mapCodes.get('Veda').Username__C != null){
                    obj.UserName = mapCodes.get('Veda').Username__C;
                }
                if(mapCodes.get('Veda').password__C != null){
                    obj.Password = mapCodes.get('Veda').password__C;
                }
                String EndPoint ='';
                if(mapCodes.get('Veda').EndPoint__C != null){
                    EndPoint   = mapCodes.get('Veda').EndPoint__C ;
                }
                String xml = obj.getXML();
                System.debug('____________'+xml);
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(EndPoint);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml');
                req.setTimeout(120000);
                req.setBody(xml);
               
                 HttpResponse res = h.send(req);
                Veda_Summary__c vedaObj = new Veda_Summary__c();
                vedaObj.ApplicantRecId__c  = insObj.ID ;
                
                if(  res.getBodyAsBlob() != null ) {
                    Attachment attachment = new Attachment();
                    attachment.Body = res.getBodyAsBlob();
                    attachment.Name = String.valueOf('Veda-'+System.Now()+'.xml');
                    mapAttachment.put(vedaObj,attachment );
                    System.debug(mapAttachment);
                }
            }
            else{
                String errorMessgae = '';
                if(insObj.first_name__C == null)
                {
                    errorMessgae = errorMessgae  + 'Appicant First Name is missing.\n';
                }
              
                if(insObj.Last_name__C == null)
                {
                    errorMessgae = errorMessgae  + 'Appicant Last Name is missing.\n';
                }
                if(insObj.Address__C == null)
                {
                    errorMessgae =  errorMessgae + 'Applicant\'s Address is missing.\n';
                }
                if(insObj.Gender__c == null){
                    errorMessgae =  errorMessgae + 'Applicant\'s gender is missing. \n';
                }
                if(insObj.acf_applicant_Employer_Name__c == null){
                    errorMessgae =  errorMessgae + 'Applicant\'s Employer name is missing.\n';
                }
                if(insObj.acfRelationship_code__c == null ){
                    errorMessgae =  errorMessgae + 'Applicant\'s Relationship code is missing.\n';
                }
                Veda_Summary__c vedaObj = new Veda_Summary__c();
               
                vedaObj.ApplicantRecId__c  = insObj.Id ;
                vedaObj.Error__C =errorMessgae ;
                //insert vedaObj ;
                mapAttachment.put(vedaObj,null );
            }
            mapApplicantNAme.put(insObj.id,insObj);
        }
        list<String> lstName = new List<String>();
        map<String,click_Applicant__c > mapApplicant = new map<String,click_Applicant__c >();
        for(click_Applicant__c applicant : appObj   ){
            if(applicant.acf_applicant_DOB__c  != null && applicant.First_name__C  != null  && applicant.Last_name__C  != null ){
                lstName.add(applicant.acf_applicant_DOB__c+applicant.First_name__C+' '+applicant.Last_name__C);
                mapApplicant.put(applicant.Id, applicant);
            }
        }
        List<acfVedaApplicantLink__c>  vedaList = [Select Name , Veda_Status__c ,Applicant__c ,Record_Creation_date__c ,Veda_Summary__c  from
        acfVedaApplicantLink__c where Name  in :  lstName  and  Veda_Status__c  = 'Active' ];
        map<String,List<acfVedaApplicantLink__c> > mapVeda = new map<String,List<acfVedaApplicantLink__c >>();
        for(acfVedaApplicantLink__c  vObj : vedaList){
            if(mapVeda.containskey(vObj.name)){
                mapVeda.get(vObj.name).add(vObj);
            }
            else{
                List<acfVedaApplicantLink__c>  tempList = new List<acfVedaApplicantLink__c>();
                tempList.add(vObj);
                mapVeda.put(vObj.name ,tempList ) ;
            }
        }
        List<Veda_Summary__c> lstVeda = new List<Veda_Summary__c>();
        map<id, Attachment> attachObj = new map<id, Attachment>();
        List<acfVedaApplicantLink__c>  lstVedaConn = new List<acfVedaApplicantLink__c> ();
        map<Id,acfVedaApplicantLink__c>  mapConnect= new map<Id,acfVedaApplicantLink__c> ();
        
        System.debug(mapAttachment);
        for(Veda_Summary__c   tempObj : mapAttachment.keyset() )
        {
            acfVedaApplicantLink__c obj = new acfVedaApplicantLink__c();
            obj.Applicant__c  = tempObj.ApplicantRecId__c ;
            click_Applicant__c clickApplicant= mapApplicantNAme.get(tempObj.ApplicantRecId__c);
            if(clickApplicant!= null)  {
                obj.name = clickApplicant.acf_applicant_DOB__c+clickApplicant.first_name__C +' '+clickApplicant.Last_name__C  ;
            }
            obj.Veda_Status__c ='Active';
           
            mapConnect.put(tempObj.ApplicantRecId__c,obj);
          
            if(mapAttachment.get(tempObj) != null)
            {
            attachObj.put(tempObj.ApplicantRecId__c , mapAttachment.get(tempObj) );
            }
            lstVeda.add(tempObj);
        }
        
        insert lstVeda;
        System.debug(lstVeda);
        List<Attachment> lstAttachment = new List<Attachment>();
        for(Veda_Summary__c vedaObj : lstVeda )
        {
            if(attachObj.get(vedaObj.ApplicantRecId__c)  != null ){
                Attachment inst = attachObj.get(vedaObj.ApplicantRecId__c) ;
                inst.ParentId = vedaObj.id;
                lstAttachment.add(inst);
            }
            if(mapConnect.get(vedaObj.ApplicantRecId__c) != null)
            {
                    acfVedaApplicantLink__c obj = mapConnect.get(vedaObj.ApplicantRecId__c);
                    
                    obj.Veda_Summary__c = vedaObj.id ;
                    obj.Record_Creation_date__c= System.now() ;
                    lstVedaConn.add(obj);
                
                    List<acfVedaApplicantLink__c> lstobj = mapVeda.get(obj.Name) ;
                    if(lstobj  != null && lstobj.size() > 0){
                    for(acfVedaApplicantLink__c  temp :  lstobj){
                        if(temp.Applicant__c  == vedaObj.ApplicantRecId__c)
                        {
                            if(temp.id != null  &&  acfCheckVedaExpiry.checkRercord(temp))
                            {
                                
                                temp.Veda_Status__c ='Inactive';
                                lstVedaConn.add(temp);
                            }
                        }
                    }
                }
            }
                
            }
             System.debug(lstAttachment);
        insert lstAttachment;
        upsert lstVedaConn;
        }
       
    
  
    global void finish(Database.BatchableContext BC) {
    }
}