global class Generate_Di_XML
{
    webservice static String  Generate_Di_XML(String OpportuntyiD)
    {
        String SecurityTag = '';
        Boolean ToBePurchased ;
        String assetFincetag ='';
        String pepapplication ='';
        String Assetcdtype ='';
        map<String,String>  mapType  = getType();
        List<Asset_And_Liability__c>  lstAsset = new List<Asset_And_Liability__c>();
        lstAsset =[Select Limit__c ,Clearing_From_This_Loan__c, Used_as_Security__c ,Id , Value__c ,State__c  ,Street_Name__c ,RecordtypeiD,Street_Number__c,
                                                Street_Type__c ,Postcode__c ,City__c ,Address__c ,Property_Type__c ,To_Be_Purchased__c ,Primary_Purpose__c ,Property_Status__c
                                                from Asset_And_Liability__c where Opportunity__c   = :  OpportuntyiD];     

        map<Id,Asset_And_Liability__c>    mapAssetData = new        map<Id,Asset_And_Liability__c>();                                       
        if(lstAsset != null && !lstAsset.isEmpty())
        {
            Integer Counter = 1 ;
            For(Asset_And_Liability__c  asset :lstAsset)
            {      if(asset.Clearing_From_This_Loan__c)
                        mapAssetData.put(asset.Id,asset);
                if(asset.recordtypeid != null  && Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(asset.recordtypeid).getname() != null 
                    &&  mapType.get( Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(asset.recordtypeid).getname()) != null)
                {
                    Assetcdtype =  mapType.get( Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(asset.recordtypeid).getname());
                }
                if(asset.Used_as_Security__c == true)
                {
                    security obj = new security();
                    obj.IdNumber = String.valueof(Counter);
                    Counter ++ ;
                    if(asset.Used_as_Security__c == true)
                    {
                        obj.cdtypetitle ='Owns';
                    }   
                    else{
                        obj.cdtypetitle ='Purchasing';
                    }
                   
                   if(asset.Value__C != null )
                        obj.amamount = asset.value__C;
                    else
                        obj.amamount = 0.0;

                    if(asset.To_Be_Purchased__c == true  && asset.Value__c != null )
                    {
                        obj.amestimatedvalue = asset.Value__c;
                        ToBePurchased = true;
                        obj.txpurchaseprice = String.valueof(asset.Value__c);
                       
                    }
                    else
                    {
                        obj.amestimatedvalue = 0.0;
                        obj.txpurchaseprice = String.valueof('0');
                        ToBePurchased = false;
                    }
                    if(asset.Property_Status__c != null)
                        obj.status = asset.Property_Status__c;
                    else
                       obj.status ='Established';
                    if(asset.Street_Name__c  != null &&  asset.Street_Number__c != null &&  asset.Street_Type__c != null &&  asset.Postcode__c != null
                        && asset.City__c != null  &&  asset.State__c != null )
                    {
                        obj.txunformattedaddress =  asset.Street_Number__c +' ' +asset.Street_Name__c + ' '+  asset.Street_Type__c + ' ' +asset.City__c + ' '+  asset.State__c  +' '+ asset.Postcode__c ;
                        obj.txsuburb = asset.City__c;
                        obj.cdstate = asset.State__c ;
                        obj.nopostcode = String.valueOf(asset.Postcode__c);
                    }
                    else if(asset.Address__c  != null)
                    {
                        obj.txunformattedaddress  = asset.Address__c  ;
                        obj.txsuburb = asset.City__c;
                        obj.cdstate = asset.State__c ;
                        obj.nopostcode = String.valueOf(asset.Postcode__c);
                    }
                    else
                    {
                        obj.txunformattedaddress = '';
                        obj.txsuburb = asset.City__c;
                        obj.cdstate = asset.State__c ;
                        obj.nopostcode = String.valueOf(asset.Postcode__c);
                    }
                    if(asset.Property_Type__c  != null  )
                        obj.cdtypeproperty = 'Other'  ;
                      else
                       obj.cdtypeproperty = 'Other';
                    if(asset.Primary_Purpose__c != null  )
                        obj.cdtypeownership = asset.Primary_Purpose__c.replaceAll( '\\s+', ''); 
                    else
                        obj.cdtypeownership =  ''; 
                    SecurityTag = SecurityTag + obj.createSecurityXml();
                }
                Double assetValue = 0.0 ;
                 if(asset.Value__c != null)
                 {
                    assetValue =  asset.Value__c ;
                 }
                 Double limitValue = 0.0 ;
                 if(asset.Limit__c != null)
                 {
                    limitValue =  asset.Limit__c ;
                 }
                 
                if(asset.recordtypeid != null  && Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(asset.recordtypeid).getname() != null &&  Schema.SObjectType.Asset_And_Liability__c.getRecordTypeInfosById().get(asset.recordtypeid).getname().contains('Asset') )
                    assetFincetag = assetFincetag +  '<financial><asset><am_amount>'+ assetValue +'</am_amount><cd_type>'+Assetcdtype+'</cd_type></asset></financial>';
                else
                {
                    STring tempFgPay ='';
                    if(asset.Clearing_From_This_Loan__c){
                         assetFincetag = assetFincetag +  '<financial><liability fg_pay_debt = "1"><am_amount>'+ limitValue +'</am_amount><cd_type>'+Assetcdtype+'</cd_type></liability></financial>';
                    }
                    else{
                         assetFincetag = assetFincetag +  '<financial><liability  fg_pay_debt = "0"><am_amount>'+ limitValue +'</am_amount><cd_type>'+Assetcdtype+'</cd_type></liability></financial>';
                    }
                
                }
            }
        }
        String xmlSecurity ='';
        if(SecurityTag != ''){
          xmlSecurity    = '<securities>' +SecurityTag+'</securities>';
        }
        Decimal lvr =0.0;
        String FinanceXml = '';
        List<Opportunity> lstOLI = new List<Opportunity>();
        lstOLI = [Select    account.acfWhat_is_your_current_payment_type__pc ,Any_Mortgage_Arrears_current__c,Any_Mortgage_Arrears_Last_6mths__c,Id , Amount , Primary_Purpose__c ,   account.acfCurrent_Loan_Amount__pc ,
                  account.acfApproximately_how_much_is_your_house__pc  ,(Select  click_Type__c , Opportunityid , Click_Estimated_Monthly_Payment__c ,Product2Id
                  from Opportunitylineitems) from Opportunity where id=:OpportuntyiD];

        map<Id ,click_Applicant__c>  mapAppIdToApplicantObj =  new   map<Id ,click_Applicant__c>( [Select  Id ,clickMarried_To__c  , clickOpportunity__c from  click_Applicant__c
                                                                where clickOpportunity__c =:OpportuntyiD] );

        if(mapAppIdToApplicantObj  != null  && mapAppIdToApplicantObj.keyset().size() > 0)
        {
            Finance  obj = new Finance ();
            Set<ID>  setObj = mapAppIdToApplicantObj.keyset();
            for(ID id : mapAppIdToApplicantObj.keyset())
            {
                if(setObj.contains(id)  && setObj.size() > 1  )
                {
                  //  obj.cdtypefinance  = 'JointwithSpouse';
                }
            }
            if( setObj.size() == 2  )
            {
                obj.cdtypefinance  = 'Joint';
            }
            if(obj.cdtypefinance  != 'JointwithSpouse'  &&  setObj.size() == 1  )
            {
                obj.cdtypefinance  = 'Sole';
            }
            if(lstOLI != null  &&  lstOLI[0].Primary_Purpose__c != null   )
            {
                String Temp =lstOLI[0].Primary_Purpose__c ;
                if(lstOLI[0].Primary_Purpose__c == 'Pre-approval')
                {
                 obj.cdloanpurpose  =  'purchase '; 
                }
                else
                {
                obj.cdloanpurpose  =  Temp.replaceAll( '\\s+', '');
                }
            }
            else
                obj.cdloanpurpose  =  '';
            FinanceXml = obj.createFinanceXml();
        }
        
        String LoanProduct = '';
        if(lstOLI != null  && !lstOLI.isEmpty()){
            for(Opportunity  opp : lstOLI )
            {
                if(opp.account != null && opp.account.acfCurrent_Loan_Amount__pc != null && opp.account.acfApproximately_how_much_is_your_house__pc != null)
                    lvr = (opp.account.acfCurrent_Loan_Amount__pc /opp.account.acfApproximately_how_much_is_your_house__pc )*100;
                String type =  '' ;
                if(opp.account.acfWhat_is_your_current_payment_type__pc  != null  &&  opp.account.acfWhat_is_your_current_payment_type__pc  =='Principal and Interest' )
                {
                    type = 'PrincipleAndInterest';
                }
                else{
                    if(opp.account.acfWhat_is_your_current_payment_type__pc  != null  &&  opp.account.acfWhat_is_your_current_payment_type__pc  !='Principal and Interest' )
                    {
                        type = 'InterestOnly';  
                    }
                }
                for(OpportunityLineItem item  : opp.Opportunitylineitems )
                {
                    loanproduct obj = new loanproduct();
                    if(opp.Amount != null)
                        obj.amloanamount   =  opp.Amount ;
                    else
                        obj.amloanamount = 0.0;
                  
                    if(item.click_Type__c  != null  &&  item.click_Type__c  == 'Principal and Interest' )
                    {
                        obj.cdinterestonlytype  =  'PrincipleAndInterest';
                    }
                    else
                    {
                        obj.cdinterestonlytype  =  'InterestOnly';
                    }
                  
                   
                    if(item.Click_Estimated_Monthly_Payment__c  != null)
                        obj.cdrepayment  = item.Click_Estimated_Monthly_Payment__c ;
                    else
                        obj.cdrepayment  = 0.0 ;
                    LoanProduct = LoanProduct + obj.createLoanProductXML();
                }
            }
        }
        String Loanproductlist =  '<loan_product_list>'+LoanProduct+' </loan_product_list>';
        String ApplicantXMl ='';
        list<click_Applicant__c>  lstApplicant = new list<click_Applicant__c>();
        lstApplicant = [Select  First_Name__c ,  Last_Name__c, Gst_Registered__C ,Gst_Months__C ,Address__c,  acf_How_Long_have_you_been_employed__c ,status_residential__c ,Id, Title__c , Citizen_ship__c ,
                        click_Applicant_Number__c ,acf_Applicant_Name__c  , Gender__c  ,acfLast_2_years_Tax_Return_or_ATO_NOA__c,ABN__C,acf_applicant_Marital_Status__c ,acf_applicant_Dependants__c,
                        acf_applicant_DOB__c ,acfEmployment_Type__c , (Select  Asset_And_Liability__c ,Category__c ,Id , recordtypeid ,Amount__c ,Frequency__c , Income_And_Expense_Detail__c ,                        
                        Credit_Limit__c  from   Income_And_Expenses__r),acfRelationship_code__c,acf_applicant_Employer_Name__c from click_Applicant__c  where clickOpportunity__c  = : OpportuntyiD];
                        Integer countDependants = 0;
                        
                        Boolean checkAltDoc = false ;
                        
        if(lstApplicant  != null  && !lstApplicant.isEmpty() )
        {
            for(click_Applicant__c  applicantObj  : lstApplicant)
            {
                
                
            if( applicantObj != null  &&  applicantObj.acfEmployment_Type__c   != null  && applicantObj.acfEmployment_Type__c == 'Self Employed'
                && applicantObj.acfLast_2_years_Tax_Return_or_ATO_NOA__c == 'No - Let\'s chat about other options'  && checkAltDoc  != true){
                  checkAltDoc = true; 
                  }
                Applicant  obj = new applicant();
                if(applicantObj.click_Applicant_Number__c  != null  &&  applicantObj.click_Applicant_Number__c == '1' )
                {
                    obj.Applicantcdtype = 'Principal';
                }
                else if(applicantObj.click_Applicant_Number__c  != null  &&  applicantObj.click_Applicant_Number__c != '1'){
                    obj.Applicantcdtype = 'CoBorrower' +  (Integer.valueof( applicantObj.click_Applicant_Number__c  ) - 1);
                }
                
                if(applicantObj.ABN__C != null)
                    obj.abn =   applicantObj.ABN__C ;
                else
                    obj.abn =   '' ;
                
                if(applicantObj.Title__c  != null  )
                    obj.cdtitle =  applicantObj.Title__c ;
                else
                    obj.cdtitle =  '' ;
               
                /*if(applicantObj.acf_Applicant_Name__c  != null)
                {
                    List<String>  lstName = applicantObj.acf_Applicant_Name__c.split(' ');
                    if(lstName.size() >= 1)
                    {
                        obj.nmfirstname = lstName.get(0);
                    }
                    else
                    {
                        obj.nmfirstname = '';
                    }
                    if(lstName.size() >= 2)
                    {
                        obj.nmsurname = lstName.get(1);
                    }
                    else{
                        obj.nmsurname = '';
                    }
                }
                */
                
                 if(applicantObj.First_Name__c  != null)
                 {
                     obj.nmfirstname = applicantObj.First_Name__c  ; 
                 }
                 else{
                     obj.nmfirstname =  ''  ; 
                 }
                 
                  if(applicantObj.Last_Name__c  != null)
                 {
                     obj.nmsurname = applicantObj.Last_Name__c  ; 
                 }
                 else{
                     obj.nmsurname =  ''  ; 
                 }
                if(applicantObj.gender__c != null )
                    obj.cdgender =  applicantObj.gender__c == 'Male' ? 'M': 'F';
                else
                    obj.cdgender = '';
                if(applicantObj.acf_applicant_Marital_Status__c  != null)
                {
                    if (applicantObj.acf_applicant_Marital_Status__c == 'Divorced / It\'s Complicated')
                        obj.cdstsmarital = 'Divorced';
                    if (applicantObj.acf_applicant_Marital_Status__c == 'Married')
                        obj.cdstsmarital = 'Married';
                    if (applicantObj.acf_applicant_Marital_Status__c == 'Defacto')
                        obj.cdstsmarital = 'DeFacto';
                    if (applicantObj.acf_applicant_Marital_Status__c == 'Single')
                        obj.cdstsmarital = 'Single';
                }
                else
                {
                    obj.cdstsmarital = '' ;
                }   
                
                if(applicantObj.acf_applicant_Dependants__c != null ){
                    obj.ctdependants = applicantObj.acf_applicant_Dependants__c ;
                    countDependants = countDependants+  integer.valueof(applicantObj.acf_applicant_Dependants__c);
                }
                else
                {
                    obj.ctdependants = '';
                }
                if(applicantObj.Citizen_ship__c != null )
                    obj.cdcitizenship =applicantObj.Citizen_ship__c ;
                else
                    obj.cdcitizenship = '' ;
                if(applicantObj.acf_applicant_DOB__c != null )
                {
                    String[] strDate = applicantObj.acf_applicant_DOB__c.split('/');
                     Integer myIntDate = 0;
                     Integer myIntMonth = 0;
                     
                     Integer myIntYear =0 ;
                     
                    if(strDate.size() > 1)
                    myIntDate = integer.valueOf(strDate[1]);
                     if(strDate.size() > 0)
                    myIntMonth = integer.valueOf(strDate[0]);
                     if(strDate.size() > 2)
                    myIntYear = integer.valueOf(strDate[2]);
                    Date dtdate = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                    Date todayDate = System.today();
                    if(dtdate != null)
                        obj.noage    =  String.valueof(todayDate.year() - dtdate.year()) ;
                }
                else
                    obj.noage    =  '';
                
                if(applicantObj.status_residential__c  != null)
                    obj.cdstatusresidential      =  applicantObj.status_residential__c ;
                else
                    obj.cdstatusresidential      =  '' ;
                
                if(applicantObj.Address__c != null )
                    obj.nmsuburb =  applicantObj.Address__c ;
                else
                    obj.nmsuburb =  '' ;
               
                obj.cdstate =  'NSW' ;
                obj.cdpostcode =  '2000' ;
                obj.cdcountry ='61';
                obj.idcustomerexisting = applicantObj.Id;
                
                if(applicantObj.acfEmployment_Type__c != null)
                    obj.cdstatus =applicantObj.acfEmployment_Type__c ;
                else
                    obj.cdstatus = '' ;

                if(applicantObj.acf_How_Long_have_you_been_employed__c  != null)
                {
                    List<String>  lststr = applicantObj.acf_How_Long_have_you_been_employed__c.splitByCharacterType();
                    obj.noabnmonths = lststr[0];
                }
                else{
                    obj.noabnmonths = '';
                }
                if(applicantObj.Gst_Registered__C != null )
                    obj.fggstregistered =  applicantObj.Gst_Registered__C ;
                else{
                }
                if(applicantObj.Gst_Months__C  != null)
                    obj.nogstmonths = applicantObj.Gst_Months__C  ;
                else
                    obj.nogstmonths =  ''  ;
                
                String incomexml ='';
                String expxml ='';
                if(applicantObj.Income_And_Expenses__r != null && !applicantObj.Income_And_Expenses__r.isEmpty())
                {
                    for(Income_And_Expense__c  IE : applicantObj.Income_And_Expenses__r)
                    {
                        Decimal incomeamamount = IE.Amount__c == null ? 0.0 : IE.Amount__c  ;
                        String incomecdfrequency = IE.Frequency__c == null ? '' : IE.Frequency__c ;
                        String incomecdtype = IE.Income_And_Expense_Detail__c  == null ?'' : IE.Income_And_Expense_Detail__c ;
                        String cdtype ='';
                        if(incomecdtype != '')
                        {
                            if(mapType.get(incomecdtype) != null)
                            {
                                cdtype = mapType.get(incomecdtype);
                            }
                        }
                        Decimal incomeammonthly =0;
                        if(Schema.SObjectType.Income_And_Expense__c.getRecordTypeInfosById().get(IE.recordtypeid).getname() == 'Income')
                        {
                            if(Ie.Frequency__c == 'Weekly' && IE.Amount__c != null )
                            {
                                incomeamamount = IE.Amount__c * 52 ;
                                incomeammonthly =  IE.Amount__c *4 ;
                            }
                            if(IE.Frequency__c == 'Fortnightly' && IE.Amount__c != null)
                            {
                                incomeamamount =   IE.Amount__c * 26 ;
                                incomeammonthly =  IE.Amount__c *2 ;
                            }
                            if(IE.Frequency__c == 'Monthly' && IE.Amount__c != null)
                            {
                                incomeamamount =   IE.Amount__c * 12 ;
                                incomeammonthly =  IE.Amount__c    ;
                            }
                            if((  IE.Frequency__c == 'Anually' && IE.Amount__c != null)  ||  (  IE.Frequency__c == 'Yearly'   && IE.Amount__c != null)  )
                            {
                                incomeamamount =   IE.Amount__c/1 ;
                                incomeammonthly =  IE.Amount__c  /12  ;
                            }
                            String income ='<financial><income><am_amount>'+incomeamamount+'</am_amount><cd_frequency>'+'Yearly'+'</cd_frequency><cd_type>'+cdtype+'</cd_type><am_monthly>'+incomeammonthly+'</am_monthly>';
                            income = income+     '</income></financial>';
                            incomexml =incomexml +income ;
                        }
                        else{
                            // Decimal incomeammonthly =0;
                            Double limit1 = IE.Credit_Limit__c == null ? 0.0 : Double.valueof(IE.Credit_Limit__c);
                            Decimal incomeamamount1 = IE.Amount__c == null ? 0.0 : IE.Amount__c  ;
                            String incomecdfrequency1 = IE.Frequency__c == null ? '' : IE.Frequency__c ;
                            String incomecdtype1 = IE.Income_And_Expense_Detail__c == null ?'' : IE.Income_And_Expense_Detail__c ;
                            if(Ie.Frequency__c == 'Weekly' &&  IE.Amount__c != null )
                            {
                                incomeammonthly = IE.Amount__c /52 ;
                            }
                            if(IE.Frequency__c == 'Fortnightly' &&  IE.Amount__c != null)
                            {
                                incomeammonthly =   IE.Amount__c/26 ;
                            }
                            if(IE.Frequency__c == 'Monthly' &&  IE.Amount__c != null)
                            {
                                incomeammonthly =   IE.Amount__c/12 ;
                            }
                            if(IE.Frequency__c == 'Anually' &&  IE.Amount__c != null)
                            {
                                incomeammonthly =   IE.Amount__c/1 ;
                            }
                            String tempFgexistsafte ='';
                            if(Ie.Asset_And_Liability__c  != null  &&  mapAssetData.get(Ie.Asset_And_Liability__c)!= null )
                            {
                                tempFgexistsafte ='<fg_exists_after>0</fg_exists_after>' ;
                            }
                            else
                            {
                                tempFgexistsafte ='<fg_exists_after>1</fg_exists_after>' ;
                            }
                            //String temp  ='<fg_exists_after>1</fg_exists_after>';
                            String Exp = '<financial><expense><am_amount>'+incomeamamount1+'</am_amount> <am_limit>'+limit1+'</am_limit><cd_frequency>'+incomecdfrequency1+'</cd_frequency><cd_type>'+cdtype+'</cd_type>';
                            Exp  = Exp + '<am_monthly> '+incomeammonthly+'</am_monthly>'+tempFgexistsafte+'</expense></financial>';
                            expxml =expxml +Exp ;
                        }
                    }
                }
                obj.applicantincomeXML=incomexml ;
                obj.applicantExpancexml=expxml ;
                obj.assetApplicantXml=  assetFincetag ;
                String Vedaxml = '';
                if(string.isNotEmpty(applicantObj.acf_Applicant_Name__c) && applicantObj.acf_applicant_DOB__c != null && string.isNotEmpty(applicantObj.acf_applicant_Employer_Name__c)
                   && string.isNotEmpty(applicantObj.Gender__c) && applicantObj.acfRelationship_code__c != null)
                    Vedaxml = GetVedaXML(applicantObj.ID);
                ApplicantXMl = ApplicantXMl + obj.CreateApplicantXml(Vedaxml);
            }
            // This section for paper application.
            Pepperapplication pepObj = new Pepperapplication();
            pepObj.noadults      =  String.valueof(lstApplicant.size());
            pepObj.nochildren    =  String.valueof(countDependants) ;
            
            if( checkAltDoc )
                pepObj.doctype = 'ALTDOC';
            else
                pepObj.doctype = 'FULLDOC';
               
            if(lstOLI != null  &&  !lstOLI.isEmpty() && string.isNotEmpty(lstOLI[0].Any_Mortgage_Arrears_current__c))
            {
                if(lstOLI[0].Any_Mortgage_Arrears_current__c == 'Partially Missed Payments')
                    pepObj.nomthscurrent = '0.8';
                if(lstOLI[0].Any_Mortgage_Arrears_current__c == '1 Month Arrears')
                    pepObj.nomthscurrent = '1';
                if(lstOLI[0].Any_Mortgage_Arrears_current__c == '2 Month Arrears')
                    pepObj.nomthscurrent = '2';
                if(lstOLI[0].Any_Mortgage_Arrears_current__c == 'More than 2 Months Arrears')
                    pepObj.nomthscurrent = '2.1';
                if(lstOLI[0].Any_Mortgage_Arrears_current__c == 'None')
                    pepObj.nomthscurrent = '0';
            }   
            else{
                pepObj.nomthscurrent  = '0';
            }
            
            if(lstOLI != null  &&  !lstOLI.isEmpty() && string.isNotEmpty(lstOLI[0].Any_Mortgage_Arrears_Last_6mths__c))
            {
                if(lstOLI[0].Any_Mortgage_Arrears_Last_6mths__c == 'Partially Missed Payments')
                    pepObj.no6mths = '0.8';
                if(lstOLI[0].Any_Mortgage_Arrears_Last_6mths__c == '1 Month Arrears')
                    pepObj.no6mths = '1';
                if(lstOLI[0].Any_Mortgage_Arrears_Last_6mths__c == '2 Month Arrears')
                    pepObj.no6mths = '2';
                if(lstOLI[0].Any_Mortgage_Arrears_Last_6mths__c == 'More than 2 Months Arrears')
                    pepObj.no6mths = '2.1';
                if(lstOLI[0].Any_Mortgage_Arrears_Last_6mths__c == 'None')
                    pepObj.no6mths = '0';
            }   
            else{
                pepObj.no6mths ='0';
            }
                
            
            pepObj.nolvr = String.valueof(lvr.setscale(2)) ;
            pepapplication = pepObj.createPepperapplicationXml();
            
        }
        
        String frontxml = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
        frontxml = frontxml +'<soap:Body><ExecuteXMLRequest xmlns="http://decisionintellect.com/inteport/">';
        frontxml = frontxml+   '<_sRequestXML><inteflow xmlns:re="http://rules.nextgen.net/webservices" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        frontxml =frontxml +     '<request cd_type="submit"><user><id_oper>CLK</id_oper><tx_password>password</tx_password></user>';
        frontxml =frontxml +      '<cd_service>SUBMIT</cd_service><id_company>PEPPERRESOLVE</id_company>';
        frontxml = frontxml +      '<id_merchant>CLK</id_merchant><cd_security>IFE</cd_security>';
        frontxml = frontxml +      '<cd_product>IFE</cd_product><cd_country>61</cd_country>';
        frontxml = frontxml +    '<id_channel>Whitelabel</id_channel></request>';
        frontxml = frontxml + '<application_details><id_reference_internal>[APP-ID]</id_reference_internal>';
        frontxml = frontxml + '<id_reference_external>'+OpportuntyiD+'</id_reference_external>';
        frontxml = frontxml + '<id_product_credit>MORTGAGE</id_product_credit><id_flow>MORTGAGE</id_flow>';
        frontxml = frontxml +  '<id_merchant_submit>CLK</id_merchant_submit><id_operator_submit>CLK</id_operator_submit>';
        frontxml = frontxml + '</application_details><service><application>';
             
                  
        Dom.Document doc = new Dom.Document();
        doc.load(frontxml +xmlSecurity+FinanceXml+Loanproductlist+ApplicantXMl+pepapplication+'</application></service></inteflow></_sRequestXML></ExecuteXMLRequest></soap:Body></soap:Envelope>');
        Http h = new Http();
        System.debug(doc.toXmlString());
        HttpRequest req = new HttpRequest();
        String Endpoint ='';
        Map < string, DiRequest__c > mapCodes = DiRequest__c.getAll();
        if (mapCodes != null && mapCodes.get('request').EndPoint__c != null) {
        Endpoint  = mapCodes.get('request').EndPoint__c;
        }
        req.setEndpoint(Endpoint);
        req.setTimeout(60000);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setBody(doc.toXmlString());
        HttpResponse res = h.send(req);
        System.debug(res.getbody());
            
        if(res.getbody() != null)
        {
            Attachment atach = new Attachment();
            atach.name = System.now()+'DI-XML.XML';
            atach.parentId = OpportuntyiD ;
            atach.body = Blob.valueof(res.getbody() );
            Insert atach ;
        }
        return doc.toXmlString()+'-:-'+ res.getbody();
    }
    
    global static String  GetVedaXML(ID ApplicantID)
    {
        String DIXMl ='';
        if(ApplicantID  != null){
            List<acfVedaApplicantLink__c> vedaList = [Select Name,Veda_Status__c ,Applicant__c ,Record_Creation_date__c ,Veda_Summary__c from acfVedaApplicantLink__c
                                                       where Applicant__c  = :ApplicantID and Veda_Status__c = 'Active'  limit 1 ];
            if(vedaList != null &&  vedaList.size() >0   &&  vedaList[0].Veda_Summary__c  != null ){
                List<Attachment>  vedaBody = [Select Body from Attachment  where parentid = : vedaList[0].Veda_Summary__c] ;
                if(vedaBody.size() > 0  &&  vedaBody[0].body != null )
                {
                    Blob vedaResponse = vedaBody[0].body ;
                    String res = vedaResponse.tostring() ;
                    res = res.replaceAll('vs:' , '');
                    if(!res.contains('NO EXISTING FILE FOUND FOR THE SUBJECT OF YOUR ENQUIRY') || !res.contains('BAD REQUEST'))
                    {
                        String VedaXML = res.substringBetween('<soapenv:Body>','</soapenv:Body>');
                        DIXMl = VedaXML ;   
                    }  
                }
            }
        }
        return   DIXMl;
    }
    
    global static map<String,String>  getType()
    {
         map<String,string>  newmap = new map<String,String>();
        newmap.put('Age Pension','Aged');
        newmap.put('Basic Living Costs (Groceries, Utilities etc)','LivingExpenses');
        newmap.put('Basic Living Expenses','LivingExpenses');
        newmap.put('Childcare and School Fees','EducationExpenses');
        newmap.put('Disability Support Pension','Disability');
        newmap.put('Family Tax Benefit A or B','TaxA');
        newmap.put('Foreign Income','Other1');
        
        newmap.put('Insurance Premiums','LivingExpenses');
        newmap.put('Investment Income','Investment');
        newmap.put('Large Family Supplement','OtherWelfare');
        newmap.put('Liability Car Loan','OtherLoan');
        newmap.put('Liability Commercial Bill','CommercialBill');
        newmap.put('Liability Credit Card','CreditCard');
        
        newmap.put('Liability Credit Card','CreditCard');
        newmap.put('Liability HECS','HECS');
        newmap.put('Liability Hire Purchase','HirePurchase');
        newmap.put('Liability Lease','Lease');
        newmap.put('Liability Line Of Credit','LineOfCredit');
        newmap.put('Liability Loan As Guarantor','LoanAsGuarantor');
        newmap.put('Liability Maintenance','ChildMaintenance');
        
        newmap.put('Liability Mortgage Loan','MortgageLoan');
        
        newmap.put('Liability Other','UnsecuredLoan');
        
        newmap.put('Liability Other','UnsecuredLoan');
        newmap.put('Liability Other Loan','OtherLoan');
        newmap.put('Liability Outstanding Taxation','OtherLoan');
        newmap.put('Liability Overdraft','Overdraft');
        newmap.put('Liability Personal Loan','PersonalLoan');
        
        newmap.put('Liability Personal Loan','PersonalLoan');
        newmap.put('Liability Store Card','StoreCard');
        newmap.put('Liability Term Loan','TermLoan');
        newmap.put('Maintenance / Child Support','Child');
        newmap.put('Mobile, Internet and TV','LivingExpenses');
        newmap.put('Other Expenses','Other');
        newmap.put('PAYG - Allowances (not-taxed)','GrossSalary');
        newmap.put('PAYG - Allowances (taxed)','GrossSalary');
        newmap.put('PAYG - Base Salary','GrossSalary');
        newmap.put('PAYG - Bonus Income','GrossSalary');
        newmap.put('PAYG - Casual/Temporary Employees','GrossSalary');
        newmap.put('PAYG - Contractor','GrossSalary');
        newmap.put('PAYG - Matenity Leave','GrossSalary');
        newmap.put('PAYG - Non-Voluntary Deductions (Pre-tax)','GrossSalary');
        
        newmap.put('PAYG - Overtime Income','GrossSalary');
        
        newmap.put('PAYG - Salary Sacrifice','GrossSalary');
        newmap.put('PAYG - Second Job','GrossSalary');
        newmap.put('Rental Income','Rental');
        newmap.put('Super / Annuity / Pension','Super');
        newmap.put('Travel and Transport','LivingExpenses');
        newmap.put('Liability Expenses','OtherLoan');  
        newmap.put('Asset Boat','Other');
        newmap.put('Asset Business Equity','Business Equity');
        newmap.put('Asset Cash Management','CashManagement');
        newmap.put('Asset Charge Over Cash','Other Despoit Account');
        newmap.put('Asset Cheque Account','ChequeAccount');
        newmap.put('Asset Debenture Charge','Other Despoit Account');
        newmap.put('Asset Gifts','Gifts');
        newmap.put('Asset Guarantee','');
        newmap.put('Asset Home Contents','Home Contents');
        newmap.put('Asset Investment Savings','Investment Savings');
        newmap.put('Asset Life Insurance','Life Insurance');
        newmap.put('Asset Managed Funds','Managed Funds');
        newmap.put('Asset Motor Vehicle','Motor Vehicle');
        newmap.put('Asset Other','Other');
        newmap.put('Asset Real Estate','Property');
        newmap.put('Asset Savings Account','Savings Account');
        newmap.put('Asset Shares','Shares');
        newmap.put('Asset Superannuation','Superannuation');
        newmap.put('Asset Term Deposit','Term Deposit');
        newmap.put('Liability Commercial Bill','CommericalBill');
        newmap.put('Liability Credit Card','CreditCard');
        newmap.put('Liability HECS','HECS');
        newmap.put('Liability Hire Purchase','HirePurchase');
        newmap.put('Liability Lease','Lease');
        newmap.put('Liability Line Of Credit','LineOfCredit');
        newmap.put('Liability Loan As Guarantor','LoanAsGuarantor');
        newmap.put('Liability Maintenance','Maintenance');
        newmap.put('Liability Mortgage Loan','MortgageLoan');
        newmap.put('Liability Other','Other');
        newmap.put('Liability Other Loan','OtherLoan');
        newmap.put('Liability Outstanding Taxation','Tax Debt');
        newmap.put('Liability Overdraft','Overdraft');
        newmap.put('Liability Personal Loan','PersonalLoan');
        newmap.put('Liability Store Card','StoreCard');
        newmap.put('Liability Term Loan','TermLoan');
        return newmap ;
    }

   
}