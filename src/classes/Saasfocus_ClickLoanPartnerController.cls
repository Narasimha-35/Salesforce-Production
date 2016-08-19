public without sharing class  Saasfocus_ClickLoanPartnerController {

    public List<PageValues> pvallst{set;get;}
    //public PageValues pvalobj{set;get;}
    //List<Question__c> questnlst{set;get;}
    public string opptype{set;get;}
    public string mobile{set;get;}
    public id cmppaccid{get;set;}
    public String todayDate{set;get;}
    //public id accntid{set;get;}
    public string cmpAccid{set;get;}
    public string cmpLnType{set;get;} 
    public boolean divchk{set;get;}
    public string transtype{set;get;}
    public ID oppoid{get;set;}
    public Account accobj{get;set;}
    public opportunity oppobj{set;get;}
    public string Lastname{set;get;}
    public Map<ID,PageValues> mapremoveduplicateopp;
    public boolean isclickrefilead{get;set;}
    public boolean isclickrefiopp{get;set;}
    public id aid{set;get;}
    public string aid2{set;get;}
    public string ttype{set;get;}
    public integer detail{set;get;}
    public List<Account> accpostloginques{set;get;}
    public List<click_Applicant__c > lstapplicant{set;get;}
    public List<Lead>lstLeadpreques{set;get;}
    public List<SelectOption> getselectlist(){
    List<SelectOption> lstso = new List<SelectOption>();  
    Schema.DescribeFieldResult statusFieldDescription = opportunity.Transaction_Type__c.getDescribe();
    for (Schema.Picklistentry picklistEntry: statusFieldDescription.getPicklistValues()){
    lstso.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
    }
    return lstso;
    }
    
    public Saasfocus_ClickLoanPartnerController()
    {
        accobj= new Account();
        Recordtype rt=[select id from Recordtype where name='Person Account' and SobjectType='Account' limit 1];
        if(rt!=null)
        accobj.recordtypeid=rt.id;
       
        
        oppobj=new Opportunity();
        //accntid=null;
        todayDate=(String.valueOf(System.now().day())+'/' +String.valueOf(System.now().month())+'/' +String.valueOf(System.now().year()));
        cmpAccid=null;
       
        
    }


   
    public void getPageval()
    {
        Set<Id> setaccountid=new Set<ID>();
        List<Account> lstaccount = new List<Account>();
        List<Opportunity> opplst=new List<Opportunity>();
        Set<Id> accid=new Set<id>();
        List<opportunity> opplstnew=new List<opportunity>();
        List<opportunity> opplstlat=new List<opportunity>();
        pvallst=new List<PageValues>();
        mapremoveduplicateopp= new Map<Id,PageValues>();
        
        opplstnew=[select id,Account.name,accountid,Account.BillingAddress,Current_Lender__c,Recordtype.name,Current_Loan_Value__c,Transaction_Type__c,acf_Status__c,(Select id,Appointment_Date_and_Time__c from Appointments__r order by Appointment_Date_and_Time__c desc limit 1) from opportunity where CurrentAssignedBroker__r.email__c =: UserInfo.getUserEmail() ];
        for(Opportunity ob: opplstnew)
        {
            accid.add(ob.accountid);
            
        }
        
        if(opptype=='Settled')
        {
            opplst=[select id,Account.name,accountid,Account.BillingAddress,StageName,Current_Lender__c,Recordtype.name,Current_Loan_Value__c,Transaction_Type__c,acf_Status__c,(Select id,Appointment_Date_and_Time__c from Appointments__r order by Appointment_Date_and_Time__c desc limit 1) from opportunity where accountid in : accid  and  (StageName='Settled' or StageName='Settlement') and (Recordtype.name = 'Click Refi' or Recordtype.name = 'Click New Loans')  ];
        }
        else if(opptype=='In progress')
        {
            opplst=[select id,Account.name,accountid,Account.BillingAddress,StageName,Current_Lender__c,Recordtype.name,Current_Loan_Value__c,Transaction_Type__c,acf_Status__c,(Select id,Appointment_Date_and_Time__c from Appointments__r order by Appointment_Date_and_Time__c desc limit 1) from opportunity where accountid in: accid  ];
        }
        
        else if(opptype=='Dashboard')
        {
            opplst=[select id,Account.name,accountid,Account.BillingAddress,StageName,Current_Lender__c,Recordtype.name,Current_Loan_Value__c,Transaction_Type__c,acf_Status__c,(Select id,Appointment_Date_and_Time__c from Appointments__r order by Appointment_Date_and_Time__c desc limit 1) from opportunity where accountid in: accid  and StageName='Application taken' and acf_Status__c = 'application' and (Recordtype.name = 'Click Refi' or Recordtype.name = 'Click New Loans') ];
        }
        
        else if(opptype=='Approved')
        {
            opplst=[select id,Account.name,accountid,Account.BillingAddress,Current_Lender__c,StageName,Recordtype.name,Current_Loan_Value__c,Transaction_Type__c,acf_Status__c,(Select id,Appointment_Date_and_Time__c from Appointments__r order by Appointment_Date_and_Time__c desc limit 1) from opportunity where accountid in: accid and (StageName='Approval' or StageName='Loan Document') and (Recordtype.name = 'Click Refi' or Recordtype.name = 'Click New Loans') ];
        }
        else if(opptype=='submitted')
        {
            opplst=[select id,Account.name,accountid,Account.BillingAddress,Current_Lender__c,StageName,Recordtype.name,Current_Loan_Value__c,Transaction_Type__c,acf_Status__c,(Select id,Appointment_Date_and_Time__c from Appointments__r order by Appointment_Date_and_Time__c desc limit 1) from opportunity where accountid in: accid and StageName='Application taken'  and acf_Status__c = 'submitted' and (Recordtype.name = 'Click Refi' or Recordtype.name = 'Click New Loans')];
        }
        else
        {
            opplst=[select id,Account.name,accountid,Account.BillingAddress,Current_Lender__c,StageName,Recordtype.name,Current_Loan_Value__c,Transaction_Type__c,acf_Status__c,(Select id,Appointment_Date_and_Time__c from Appointments__r order by Appointment_Date_and_Time__c desc limit 1) from opportunity where accountid in: accid ];
        }
        system.debug('list of opp==>'+opplst);
        if(opplst.size()>0)
        {
        
            
             
            for(Opportunity opp:opplst)
            {
                 
                
                setaccountid.add(opp.accountId);    
                PageValues pvobj=new PageValues();

                pvobj.name=opp.Account.name;
                pvobj.Accid=opp.accountid;
                pvobj.oppstage=opp.StageName;
                pvobj.address=opp.Account.BillingAddress.getCountry();
                pvobj.CurrentLender=opp.Current_Lender__c;
                pvobj.CurrentLoanSize=opp.Current_Loan_Value__c;
                pvobj.TransactionType=opp.Transaction_Type__c;
                if(opp.Appointments__r.size()>0)
                pvobj.lastappointment=opp.Appointments__r[0].Appointment_Date_and_Time__c;
                pvobj.opportunitystatus=opp.acf_Status__c;
                pvobj.opprecordtype=opp.recordtype.name;
                cmpLnType=pvobj.transtypeoptn;
                if(pvobj.transtypeoptn==null || pvobj.transtypeoptn=='') 
                pvobj.transtypeoptn=opp.Transaction_Type__c;
                pvobj.oppid=opp.id;
                
                if(mapremoveduplicateopp.get(pvobj.Accid) != null)
                 {
                     
               
                 
                 if(mapremoveduplicateopp.get(pvobj.Accid).opprecordtype != 'click refi' && mapremoveduplicateopp.get(pvobj.Accid).opprecordtype != 'Click New Loans')
                 {
                      mapremoveduplicateopp.put(pvobj.Accid,pvobj);
                 }
                 
                 
                 }
                else
                {
                     mapremoveduplicateopp.put(pvobj.Accid,pvobj);
                
                }
                    
                
                //mapremoveduplicateopp.get(pvobj.Accid).add(pvobj);
                
                
                
               
                
                
                
                
               
            }
            for(PageValues pvobj: mapremoveduplicateopp.values())
            {
                if(opptype=='In progress')
                {
                 if(pvobj.opprecordtype!='Click Refi' && pvobj.opprecordtype!='Click New Loans')
                 pvallst.add(pvobj);
                }
                else
                pvallst.add(pvobj); 
            }
            
            system.debug('wrapper values==>'+pvallst);
            
            List<Lead> lstlead=[select name,Recordtype.name,acf_partner_account__c from lead where acf_partner_account__c in: setaccountid];
        for(PageValues pvobj:pvallst)
        {
        
        
            if(pvobj.opprecordtype=='Click Refi'|| pvobj.opprecordtype=='Click New Loans')
            {
                 pvobj.type='existing';
                 continue;
            }              
                
            if(lstlead.size()>0 && (pvobj.opprecordtype!='Click Refi' && pvobj.opprecordtype!='Click New Loans'))
            {
                for(Lead objlead:lstlead)
                {
                        //pvobj.type='pending';
                        //system.debug('@@@1'+'name=>'+objlead.name+' Lead record type=>'+objlead.Recordtype.name+' pvojename'+pvobj.name+'=>'+objlead.acf_partner_account__c);
                        
                        system.debug('@@@1'+'name=>'+objlead.name+'rectype=>'+pvobj.opprecordtype+' '+pvobj.accid+' => '+objlead.acf_partner_account__c);
                        
                       if((objlead.Recordtype.name=='Click Refi' || objlead.Recordtype.name=='Click New Loans')  && pvobj.accid==objlead.acf_partner_account__c )
                        {
                             pvobj.type='pending';  
                             system.debug('@@1==>'+pvobj.type); 
                             //break;
                        }
                        if(pvobj.type!='pending')
                        {         
                            pvobj.type='new';
                            system.debug('@@2==>'+pvobj.type); 

                        }
                                            
                    }
                    
            
                }
                
                else 
                {
                    pvobj.type='existing';
                    system.debug('@@3==>'+pvobj.type); 
                } 
                
                if((pvobj.opprecordtype!='Click Refi' && pvobj.opprecordtype!='Click New Loans') && lstlead.size()==0)
                {
                     pvobj.type='new'; 
                     system.debug('@@4==>'+pvobj.type);   
                }
                
                
               
                
                
            }
            
        }    
        
   system.debug('wrapper values==>'+pvallst);
    }
     
    
    public void startclickloan()
    {
      String oid;
      Boolean isSalesforceOppoId ;
      Boolean isSalesforceAccountId ;
      String aid;  
      List<Opportunity> oppo=new List<Opportunity>();
      oppo=[select id,accountid,sync_with_mercury_success__c,mercury_loan_Id__c,account.Mercury_People_ID__c,account.sync_with_mercury_success__pc,account.mercury_loan_Id__c from opportunity  where id =:oppoid ];
        if (oppo[0].sync_with_mercury_success__c) {
            isSalesforceOppoId = true;
            oid = oppo[0].Id;
        } 
        else if (oppo[0].mercury_loan_Id__c != null) {
           isSalesforceOppoId = false;
           oid= oppo[0].mercury_loan_Id__c;
        }
        
        if (oppo[0].account.sync_with_mercury_success__pc) {
            isSalesforceAccountId = true;
            aid= oppo[0].accountid;
        } 
        else if (oppo[0].account.Mercury_People_Id__c != null) {
           isSalesforceAccountId = false;
           aid = oppo[0].account.Mercury_People_Id__c ;
        }
        if (aid!= null && oid!= null) {
            
           MercuryApiUtilities.getDataBack(oid, isSalesforceOppoId, aid, isSalesforceAccountId);
        }
      
    }
    
    public Pagereference createAccount()
    {
       
        
        //Recordtype rt=[select id from Recordtype where name='Person Account' and SobjectType='Account' limit 1];
        //if(rt!=null)
        //{
           // accobj.recordtype.id=rt.id;
            accobj.PersonMobilePhone='+61'+mobile;
            accobj.lastname=Lastname;
            accobj.IsClickLoanPage__c=true;
            MortgageExpert__c   obj2 = MortgageExpert__c.getValues('Click_David Hyman');
            accobj.ownerId=obj2.User_ID__c;
            accobj.Partner_User__c= userInfo.getuserId();
            insert accobj;
            RecordType rt= [select id from RecordType where SobjectType  = 'Opportunity' and name='Home Opportunity' limit 1]; 
            oppobj.recordtypeid=rt.id;
            oppobj.accountId=accobj.id;
            oppobj.name='opp123';
            oppobj.StageName='Appointed';
            List<Broker__c> blst=[select id from broker__c where  Email__c=:UserInfo.getUserEmail()];
            
            if(blst.size()>0)
            oppobj.CurrentAssignedBroker__c=blst[0].id;
            oppobj.IsClickLoanPage__c=true;
            oppobj.Personal_Loan_Balance__c=0;
            oppobj.Credit_Card_Balance__c=0;
            oppobj.Car_Loan_Balance__c=0;
            oppobj.CloseDate=system.today();
            insert oppobj;
            accobj=new Account();
            Lastname=null;
            mobile=null;
            oppobj=new opportunity();   
            PageReference pref = new PageReference('/apex/clickloanpartner');
            pref.setRedirect(true);
            return pref;
        //}
    }
    
   public void showDetails()
    {
        boolean clead=false;
        boolean copp=false;
        
        system.debug('aid==>'+aid2);
        if(aid!=null|| aid2!=null)
        {
            List<Opportunity> lstopp=[select id from Opportunity where accountid =:aid and (recordtype.name= 'Click Refi' OR recordtype.name='Click New Loans') limit 1];
            if(lstopp.size()>0)
                copp=true;
            List<Lead> lstLead=[select Transaction_Type__c from Lead where acf_partner_account__c=:aid and (recordtype.name='Click refi' or recordtype.name='Click New Loans') limit 1];    
            if(lstlead.size()>0)
            {
                clead=true;
                ttype=lstLead[0].Transaction_Type__c;
            }
            
            lstapplicant=new List<click_Applicant__c >();
            lstapplicant=[Select clickOpportunity__r.name,Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, ACF1_Previous_Em_Start_Date0__c, ACF1_Previous_Em_Start_Date12__c, ACF1_Previous_Em_Start_Date24__c, ACF1_Previous_Employer_Name0__c, ACF1_Previous_Employer_Name12__c, ACF1_Previous_Employer_Name24__c, ACf1_Current_employer_Start_Date__c, Current_Role__c, acfAnnual_profit_income__c, acfBusiness_Name_or_ABN_autofill__c, acfDependant1_Age__c, acfDependant2_Age__c, acfDependant3_Age__c, acfDependant4_Age__c, acfDependant5_Age__c, acfEconsent_App2__c, acfEconsent__c, acfEmployment_Type__c, acfLast_2_years_Tax_Return_or_ATO_NOA__c, acf_ACf1_Current_employer_Start_Da__c, acf_Applicant_Name__c, acf_How_Long__c, acf_How_Long_have_you_been_employed__c, acf_appl_ACf2_Current_employer_Start_Da__c, acf_applicant_Annual_profit_income__c, acf_applicant_App_1_Monthly_Expenses__c, acf_applicant_DOB__c, acf_applicant_Dependants__c, acf_applicant_Employer_Name__c, acf_applicant_Marital_Status__c, acf_applicant_Monthlly_Salary__c, acf_applicant_Residency_status__c, clickApp_1_Monthly_Expenses__c, clickMarried_To__r.name,click_Account__r.name, click_Account__c, click_Applicant_Number__c, Applicant_Email__c, Applicant_Phone__c FROM click_Applicant__c  where (click_Account__c =: aid2 OR click_Account__c =: aid)  limit 1000];
            system.debug('accountid==>'+aid2);
            system.debug('applicant==>'+lstapplicant);
            if(copp==true&&clead==true && detail==1)
            {
                    accpostloginques=new List<Account>();
                    accpostloginques=[select PersonEmail,Phone,PersonMobilePhone,acfApplicant2_email__pc,acfApplicant2_phone__pc,acfApplicant2_Monthly_Salary__pc,name,acf_applicant_Employer_Name__pc,acf_applicant_Monthlly_Salary__pc,acf_applicant_Marital_Status__pc,Acf_Are_there_any_more_properties__pc,acfWhat_is_your_postcode__pc,acfNumber_Of_Applicants__pc,Lastname,acf_applicant_DOB__pc, Marital_Status__pc
                    ,acf_Applicant_Dependants__pc,acfDependant1_Age__pc,acfDependant2_Age__pc,acfDependant3_Age__pc,acfDependant4_Age__pc,acfDependant5_Age__pc,
                    acf_applicant_Residency_status__pc,acfAnnual_Salary__pc,Employer_Name__pc,Current_Role__pc,acf_How_Long_have_you_been_employed__pc,
                    acfBusiness_Name_or_ABN_autofill__pc,acf_How_Long__pc,acfAnnual_profit_income__pc,clickApp_1_Monthly_Expenses__pc,acfEconsent__pc,
                    acfApplicant2_Name__pc,acfApplicant2_DOB__pc,acfApplicant2_Marital_Status__pc,acfApplicant2_Dependents__pc,acfApplicant2_dependent1_Age__pc,
                    acfApplicant2_dependent2_Age__pc,acfApplicant2_dependent3_Age__pc,acfApplicant2_dependent4_Age__pc,acfApplicant2_dependent5_Age__pc,
                    acfApplicant2_Residency_status__pc,acfApplicant2_Annual_Salary__pc,acfApplicant2_Employer_Name__pc,clickCurrent_Role_App_2__pc,acfApp2_How_Long_have_you_been_employed__pc,
                    acfApp2_Business_Name_or_ABN_autofill__pc,acfApplicant2_Annual_profit_income__pc,clickApp_2_Monthly_Expenses__pc,acfEconsent_App2__pc,
                    ACF_BankName__pc,acfCurrent_Rate__pc,acfCurrent_Loan_Amount__pc,acfWhat_is_your_current_payment_type__pc,acf_Applicant_Employment_Type__pc,
                    acfPostal_Code__pc,acfApproximately_how_much_is_your_house__pc,acfWhy_are_you_refinancing__pc,click_Is_this_loan_for_an_investment_p__pc,
                    acfWhat_Year_Tax_Return_do_you_Have_App2__pc from account where id =: aid limit 1];
                     
            }
            
            else if(detail==2)
            {
                    accpostloginques=new List<Account>();  
                    lstLeadpreques=[select Transaction_Type__c,Current_Lender__c,acfLoan_Amount__c,acfWhy_are_you_refinancing__c,acfCurrentRate__c,acfApproximately_how_much_is_your_house__c,
                                     click_Is_this_loan_for_an_investment_p__c,acfHow_is_your_current_credit_history__c,acfWhat_is_your_current_payment_type__c,
                                     acfEmployment_Type__c,acfWhat_is_your_postcode__c,acfLast_2_years_Tax_Return_or_ATO_NOA__c
                                     from Lead  where acf_partner_account__c=:aid2 and (recordtype.name='Click refi' or recordtype.name='Click New Loans') limit 1];
                                  
                                                     
                  
                    accpostloginques=[select PersonEmail,Phone,PersonMobilePhone,acfApplicant2_email__pc,acfApplicant2_phone__pc,acfApplicant2_Monthly_Salary__pc,name,acf_applicant_Employer_Name__pc,acf_applicant_Monthlly_Salary__pc,acf_applicant_Marital_Status__pc,Acf_Are_there_any_more_properties__pc,acfWhat_is_your_postcode__pc,acfNumber_Of_Applicants__pc,Lastname,acf_applicant_DOB__pc, Marital_Status__pc
                    ,acf_Applicant_Dependants__pc,acfDependant1_Age__pc,acfDependant2_Age__pc,acfDependant3_Age__pc,acfDependant4_Age__pc,acfDependant5_Age__pc,
                    acf_applicant_Residency_status__pc,acfAnnual_Salary__pc,Employer_Name__pc,Current_Role__pc,acf_How_Long_have_you_been_employed__pc,
                    acfBusiness_Name_or_ABN_autofill__pc,acf_How_Long__pc,acfAnnual_profit_income__pc,clickApp_1_Monthly_Expenses__pc,acfEconsent__pc,
                    acfApplicant2_Name__pc,acfApplicant2_DOB__pc,acfApplicant2_Marital_Status__pc,acfApplicant2_Dependents__pc,acfApplicant2_dependent1_Age__pc,
                    acfApplicant2_dependent2_Age__pc,acfApplicant2_dependent3_Age__pc,acfApplicant2_dependent4_Age__pc,acfApplicant2_dependent5_Age__pc,
                    acfApplicant2_Residency_status__pc,acfApplicant2_Annual_Salary__pc,acfApplicant2_Employer_Name__pc,clickCurrent_Role_App_2__pc,acfApp2_How_Long_have_you_been_employed__pc,
                    acfApp2_Business_Name_or_ABN_autofill__pc,acfApplicant2_Annual_profit_income__pc,clickApp_2_Monthly_Expenses__pc,acfEconsent_App2__pc,
                    ACF_BankName__pc,acfCurrent_Rate__pc,acfCurrent_Loan_Amount__pc,acfWhat_is_your_current_payment_type__pc,acf_Applicant_Employment_Type__pc,
                    acfPostal_Code__pc,acfApproximately_how_much_is_your_house__pc,acfWhy_are_you_refinancing__pc,click_Is_this_loan_for_an_investment_p__pc,
                    acfWhat_Year_Tax_Return_do_you_Have_App2__pc from account where id =: aid2 limit 1];
                     
            }
            
                    
        }
        system.debug('aidnew==>'+aid2);
        system.debug('Questions==>'+accpostloginques);
        system.debug('Lead questions==>'+lstLeadpreques);
        
    }
    public void showDoc()
    {
    }
  
    
    public class PageValues{
        public String name{set;get;}
        public Id AccId{set;get;}
        public string address{set;get;}
        public string CurrentLender{set;get;}
        public String oppstage{set;get;}
        public Decimal CurrentLoanSize{set;get;}
        public string TransactionType{set;get;}
        public DateTime lastappointment{set;get;}
        public string opportunitystatus{set;get;}  
        public string type{set;get;} 
        public string transtypeoptn{set;get;}
        public string opprecordtype;
        public string oppid{set;get;}
    }




}