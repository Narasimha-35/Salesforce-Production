public class ClickQuoteDetail_partner 
{
    //------Public Properties--------//
    public string strLoanPurpose {get;set;}
    public decimal decCurrLoanAmt {get;set;}
    public decimal decEstPropVal{get;set;}
    public decimal decBestRate {get;set;}
    public decimal decComparison {get;set;}
    public integer decMonthlyPayment {get;set;}
    public string pge_name {set; get;}
    public static integer intWidth {get;set;}
    public static Id currentLeadId {get;set;}
    
    //------Constructor---------//
    
    public ClickQuoteDetail_partner()
    {    
     boolean isFixed1YrCompleted = false;
     string pge = Apexpages.currentPage().getUrl();
     List<String> parts = pge.split('/'); 
     List<String> parts1 = parts[2].split('\\?');
     pge_name = parts1[0].toLowerCase(); 
     strLoanPurpose = '';
     decMonthlyPayment = 0;
     decComparison = 0;
     decBestRate = 0;
     decEstPropVal = 0;
     decCurrLoanAmt = 0;
     map<string,LVR_Rate__c>mapProductIdToLVR = new map<string,LVR_Rate__c>();
     set<string>setProductIdToExclude = new set<string>();
     //Modified by karthik on 08-05-2015
     
     string AccountIdUser=ApexPages.currentPage().getParameters().get('cid');

     system.debug('Ashu!!!=>'+AccountIdUser);
     account leadDetails=[select acf_Lead__pc from account where id=:AccountIdUser ];
       
     
     system.debug('currentLeadId **********'+currentLeadId);

     if(currentLeadId != null)
     {
        list<lead> lstLead = [select id,acfLoan_Amount__c,RecordType.Name,acfApproximately_how_much_is_your_house__c,acfWhat_is_your_current_payment_type__c from lead where id=:currentLeadId];
       
        if(lstLead != null && lstLead .size()>0)
        { 
            Lead objLead = lstLead[0];
            if(objLead.RecordType.Name != null && objLead.RecordType.Name == 'Click Refi')
            {
                strLoanPurpose = 'Refinance';
            }else if(objLead.RecordType.Name != null && objLead.RecordType.Name == 'Click New Loans')
                  {
                    strLoanPurpose = 'New Loan';
                  }
            if(objLead.acfApproximately_how_much_is_your_house__c != null)
                decEstPropVal = objLead.acfApproximately_how_much_is_your_house__c;
            if(objLead.acfLoan_Amount__c != null)
                decCurrLoanAmt = objLead.acfLoan_Amount__c; 
            
            
            
            string paymentType = objLead.acfWhat_is_your_current_payment_type__c;              
            double usrLVR = 0;

            if(objLead.acfLoan_Amount__c != null && objLead.acfApproximately_how_much_is_your_house__c != null)
                  usrLVR = (objLead.acfLoan_Amount__c/objLead.acfApproximately_how_much_is_your_house__c)*100;
            
            if(!Test.isRunningTest()){     
                for(acfSuggested_Product__c objSuggestedProduct:[select id,acfFilter__c,acfProduct__c,acfProduct_Family__c,acfLead__c from acfSuggested_Product__c where acfLead__c=:currentLeadId])
                {
                    if(objSuggestedProduct.acfFilter__c <> null && objSuggestedProduct.acfProduct__c <> null && objSuggestedProduct.acfFilter__c == 'Exclude')
                    {
                        setProductIdToExclude.add(objSuggestedProduct.acfProduct__c);
                    } 
                    
                }
            }
            
            /////////////////////////////////////////////////////////////////
            set<id> setOfBankDetailId = new set<id>();
        List<Click_Loans_Bank__c> lstbank = new List<Click_Loans_Bank__c>();
        List<Click_Community_Setup__c> cstlst=new List<Click_Community_Setup__c>();
        cstlst=[select id,Click_Network_ID__c from Click_Community_Setup__c where Click_Page_Prefix__c = 'Click' limit 1]; 
        if(cstlst.size()>0)
        {    
        if(ClickCommon.getCommunitySetup(cstlst[0].Click_Network_ID__c).Id <> null)
        {
            lstbank = [select id,Click_Loans_Bank_Detail__c,Community_Setup__c from Click_Loans_Bank__c where Community_Setup__c =:ClickCommon.getCommunitySetup(cstlst[0].Click_Network_ID__c).Id];
        }
        if(lstbank.size() > 0 && lstbank != null)
        {
            for(Click_Loans_Bank__c objbank : lstbank)
            {
                    setOfBankDetailId.add(objbank.Click_Loans_Bank_Detail__c);
            }
        }
        }
        system.debug('Setbank==>'+setOfBankDetailId);
        //product filter logic added by karthik on 08-05-2015
            
            
            
            
            /////////////////////////////////////////////////////////////////
            
     List<LVR_Rate__c>  lstlvrnew=new  List<LVR_Rate__c>();    
     if(setOfBankDetailId <> null)
     {
            for(LVR_Rate__c objLVR:[select id,acfLVR__c,acfRate__c,acfProduct__r.acfType__c,acfProduct__r.Recordtype.Name,acfProduct__c,acfLoan_Size__c,ACF_Comparison_Rate__c,
                                            clickFixed_Interest_Rate__c,clickLoan_Size_From__c,clickLVR_From__c,acfProduct__r.acfTenure_in_Years__c,acfApplication_Fee__c,
                                            acfProduct__r.acfvarTenure_In_Years__c,acfProduct__r.name,acfTerm_in_Years__c,acfProduct__r.acfOffset_Account__c 
                                            from LVR_Rate__c
                                            where 
                                            clickLoan_Size_From__c <: objLead.acfLoan_Amount__c and
                                            acfLoan_Size__c >=:objLead.acfLoan_Amount__c and 
                                            clickLVR_From__c <: usrLVR and 
                                            acfLVR__c>=:usrLVR and 
                                            acfProduct__r.Recordtype.Name = 'Variable' 
                                            and acfProduct__r.acfOffset_Account__c = false                                                                                          
                                            and acfProduct__r.Click_Loans_Bank_Detail__c =: setOfBankDetailId                                             
                                            order by acfTerm_in_Years__c,acfRate__c,clickFixed_Interest_Rate__c asc ])
            
            {
                if(setProductIdToExclude <> null && setProductIdToExclude.size()>0 && setProductIdToExclude.contains(objLVR.acfProduct__c))
                            {
                                continue;
                            } 
                lstlvrnew.add(objLVR);
                }        
               if(lstlvrnew<>null && lstlvrnew.size()>0)   
               {
                   decBestRate = lstlvrnew[0].acfRate__c;
                
                system.debug('@@ashu12344'+lstlvrnew[0].acfRate__c);
                
                decComparison = lstlvrnew[0].ACF_Comparison_Rate__c;
                If(lstlvrnew[0].acfProduct__r.RecordType.Name == 'Variable' && decBestRate != null && lstlvrnew[0].acfProduct__r.acfvarTenure_In_Years__c != null && decCurrLoanAmt!= null && paymentType != null)
                {
                    decMonthlyPayment = integer.valueof(acfCommon.calculateMonthlyPayment(decCurrLoanAmt,double.valueof(decBestRate),paymentType,double.valueof(lstlvrnew[0].acfProduct__r.acfvarTenure_In_Years__c)));
                }else if(lstlvrnew[0].acfProduct__r.RecordType.Name == 'Fixed'  && lstlvrnew[0].acfProduct__r.acfvarTenure_In_Years__c != null && decCurrLoanAmt != null && paymentType!= null)
                {
                  decBestRate = lstlvrnew[0].clickFixed_Interest_Rate__c;
                  if(decBestRate != null)
                    decMonthlyPayment = integer.valueof(acfCommon.calculateMonthlyPayment(decCurrLoanAmt,double.valueof(decBestRate),paymentType,double.valueof(lstlvrnew[0].acfProduct__r.acfvarTenure_In_Years__c)));
                }
                   
               }     
               
               
               
           
                   
            
                }
            }
        }
        
      } 
    
    
    public static void setProgressBarWidth(integer currentQues,integer totQues, string pagename)
    {
        string strNetworkId='';
        list<Click_Community_Setup__c> csObj=new list<Click_Community_Setup__c>();
        csObj=[select Click_Network_ID__c from Click_Community_Setup__c  where Click_Page_Prefix__c='Click' limit 1];
        
        if(csObj.size()>0)
            strNetworkId=csObj[0].Click_Network_ID__c;
        
        system.debug('@@@@QuoteTest'+currentQues+'====='+totQues);
        //intWidth = ((currentQues+1) * 100)/totQues;
        
        List<Click_Community_Setup__c> lstCommunity = new List<Click_Community_Setup__c>();
        lstCommunity = [select id,name,Click_Page_Prefix__c,Click_Network_ID__c,Click_URL__c,Community_User_Name_Prefix__c,
                        Click_IsActive__c,Click_Support_Team_Name__c from Click_Community_Setup__c where Click_Network_ID__c = : strNetworkId AND Click_IsActive__c =: true limit 1];
        
        
        system.debug('clickClass=>'+currentQues+'=>'+totQues);
      
            //intWidth = ((currentQues+1) * 100)/totQues;
         string AccountIdUser=ApexPages.currentPage().getParameters().get('cid');
         string LoggedInLead;
        account accdet=[select acf_Lead__pc from account where id=:AccountIdUser ];
        
        LoggedInLead= accdet.acf_Lead__pc ;
        currentLeadId=accdet.acf_Lead__pc;
        
        List<Lead> lstLSteps = [select id,acfIs_Post_Login_Ques_Attempted__c, acfIs_Bank_Statement_Submitted__c, acfIs_Identity_Document_Submitted__c from lead where id =: LoggedInLead];
        
        set<id> setScript = new set<id>();
        for(Script__c objScript : [select id,acf_Sequence_no__c,acf_Type__c,acf_Stage_Name__c,acf_Question_Type__c  from Script__c where acf_Type__c=:'Post-Login' 
                                   AND Click_Community_Setup__r.Click_Network_ID__c =: strNetworkId order by acf_Sequence_no__c asc]
           )
        {
            setScript.add(objScript.id);
        }
        list<Question__c> lstQuestion = [select id from Question__c where acf_Script__c in: setScript and acf_Active__c = true];
        
        
        system.debug('@@@@QuoteTest'+currentQues+'====='+totQues+'==lststeplist=>'+lstLSteps+'====pagename=>'+pagename+' LeadId=>'+currentLeadId+'account=>'+AccountIdUser+'==pagename=='+pagename);
        
        
        if(lstLSteps != null && lstLSteps.size()>0)
        {
            
            lead objLead = lstLSteps[0];
            
            if(pagename.containsIgnoreCase('BrokerClickPostloginQuestionnaires'))
            {
                system.debug('@@@@bingo'+intWidth);
                integer totalQues = totQues + 5 + 5;                
                if(objLead.acfIs_Bank_Statement_Submitted__c == true)
                    currentQues = currentQues + 5;
                    
                if(objLead.acfIs_Identity_Document_Submitted__c == true)
                    currentQues = currentQues + 5;
                    
                intWidth = ((currentQues+1) * 100)/totalQues;
                system.debug('@@@@ashutest1'+totalQues+'==='+intWidth);
            }
            else If(pagename == 'BrokerClickBankInfoDetails' || pagename == 'Brokerclickjumiointegration')
            {
                integer totalQues = lstQuestion.size();
                
                currentQues = 5;
                
                if(objLead.acfIs_Post_Login_Ques_Attempted__c == true)
                    currentQues = currentQues + totalQues;
                    
                if(objLead.acfIs_Identity_Document_Submitted__c == true)
                    currentQues = currentQues + 5;
                    
                totalQues = lstQuestion.size() + 10;
                
                intWidth = ((currentQues+1) * 100)/totalQues;
                system.debug('@@@@ashutest2'+totalQues+'==='+intWidth);
            }
            else
            {            
                integer totalQues = lstQuestion.size();
                
                currentQues = 5;
                
                if(objLead.acfIs_Post_Login_Ques_Attempted__c == true)
                    currentQues = currentQues + totalQues;
                    
                if(objLead.acfIs_Bank_Statement_Submitted__c == true)
                    currentQues = currentQues + 5;
                    
                intWidth = ((currentQues+1) * 100)/totalQues;
               system.debug('@@@@ashutest3'+totalQues+'==='+intWidth);
            }
       }
    }
}