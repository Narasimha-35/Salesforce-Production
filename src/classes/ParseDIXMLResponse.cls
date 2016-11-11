global class ParseDIXMLResponse{
    webservice static void parseDIXMLResponseMethod(String reponse, String OpportuntyiD){
        
        String pepperStringFinal = ''; 
        String resultStringFinal = '';
        String  applicantStringFinal = '';
        List<DIWrapperResultAlert> diWrapperResultList = new List<DIWrapperResultAlert>();
        List<DIWrapperLoanCondition> diWrapperLoanList = new List<DIWrapperLoanCondition>();
        List<DIWrapperApplicationAlert> diWrapperApplicantList = new List<DIWrapperApplicationAlert>();
        system.debug('###resp'+reponse);
        string strrespon= reponse;
        if(strrespon.contains('<result>'))
        {
            integer replaceFirstResult = reponse.indexOf('<result>');
            integer replaceSecondResult = reponse.indexOf('</result>');
            strrespon = strrespon.substring(0,replaceFirstResult) + '<bill>';
            string strMidresponse = reponse.substring(replaceFirstResult+8,replaceSecondResult);
            system.debug('strMidresponse ***************************'+strMidresponse);
            strrespon += strMidresponse + '</bill>';
            system.debug('strrespon__________________________'+strrespon);
            string strEndresponse = reponse.substring(replaceSecondResult+9,reponse.length());
            system.debug('strEndresponse_________________________________'+strEndresponse);
            strrespon += strEndresponse;
        }
        system.debug('__________________________strrespon'+strrespon);
        
        //reponse = reponse.replaceFirst('<result>', '<bill>');
        //reponse = reponse.replaceFirst('</result>', '</bill>');
        reponse =strrespon ;
        if(reponse.contains('<pepper_response')){
            string pepperString = reponse.substringBetween('pepper_response>');
            pepperStringFinal = pepperString.removeEnd('</');
            pepperString = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
            pepperStringFinal = pepperString + pepperStringFinal;
            pepperStringFinal = pepperStringFinal + '</soap:Envelope>';
            
             //Loan Condition Section
            Dom.Document doc = new Dom.Document();
            doc.load(pepperStringFinal);
            Dom.XMLNode rootElement = doc.getRootElement();
            system.debug('###123'+rootElement);
            DOM.XMLNode subRootElement = rootElement.getChildElement('loan_conditions', null);
            system.debug('###name'+subRootElement);
            if(subRootElement != null){
                for(Dom.XMLNode child : subRootElement.getChildElements()) {
                    System.debug(child.getText());
                    system.debug('###'+child.getAttribute('code',''));
                    DIWrapperLoanCondition wrapLoanObj = new DIWrapperLoanCondition();
                    wrapLoanObj.code = child.getAttribute('code','');
                    wrapLoanObj.comment = child.getAttribute('comment','');
                    wrapLoanObj.type = 'Loan Condition';
                    diWrapperLoanList.add(wrapLoanObj);
                }
            }
        }
        
        if(reponse.contains('<bill')){
            String applicantString =reponse.substringBetween('bill>');
            system.debug('###res'+applicantString);
            applicantStringFinal = applicantString.removeEnd('</');
            applicantString = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
            applicantStringFinal = applicantString + applicantStringFinal;
            applicantStringFinal = applicantStringFinal + '</soap:Envelope>';
            
            //ApplicantAlertSection
            Dom.Document doc2 = new Dom.Document();
            doc2.load(applicantStringFinal);
            Dom.XMLNode rootElement2 = doc2.getRootElement();
            system.debug('###123'+rootElement2);
            DOM.XMLNode subRootElement2 = rootElement2.getChildElement('alert_list', null);
            system.debug('###name'+subRootElement2);
            if(subRootElement2 != null){
                for(Dom.XMLNode child : subRootElement2.getChildElements()) {
                    System.debug(child.getText());
                    system.debug('###'+child.getAttribute('id',''));
                    DIWrapperApplicationAlert wrapAppObj = new DIWrapperApplicationAlert();
                    wrapAppObj.id = child.getAttribute('id','');
                    wrapAppObj.description = child.getAttribute('tx_description','');
                    wrapAppObj.txStatus = child.getAttribute('cd_status','');
                    wrapAppObj.txSection = child.getAttribute('tx_section','');
                    wrapAppObj.fgNew = child.getAttribute('fg_new','');
                    wrapAppObj.type = 'Applicant Alert';
                    diWrapperApplicantList.add(wrapAppObj);
                }
            }
           
            
        }
        
        if(reponse.contains('<result')){
            String resultString = reponse.substringBetween('result>');
            resultStringFinal = resultString.removeEnd('</');
            resultString = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
            resultStringFinal = resultString + resultStringFinal;
            resultStringFinal = resultStringFinal + '</soap:Envelope>'; 
            
            //ResultAlertSection
            Dom.Document doc1 = new Dom.Document();
            doc1.load(resultStringFinal);
            Dom.XMLNode rootElement1 = doc1.getRootElement();
            system.debug('###123'+rootElement1);
            DOM.XMLNode subRootElement1 = rootElement1.getChildElement('alert_list', null);
            system.debug('###name'+subRootElement1);
            
            if(subRootElement1 != null){
                for(Dom.XMLNode child : subRootElement1.getChildElements()) {
                    System.debug(child.getText());
                    system.debug('###'+child.getAttribute('id',''));
                    DIWrapperResultAlert wrapResultObj = new DIWrapperResultAlert();
                    wrapResultObj.id = child.getAttribute('id','');
                    wrapResultObj.description = child.getAttribute('tx_description','');
                    wrapResultObj.txStatus = child.getAttribute('cd_status','');
                    wrapResultObj.txSection = child.getAttribute('tx_section','');
                    wrapResultObj.fgNew = child.getAttribute('fg_new','');
                    wrapResultObj.type = 'Result Alert';
                    diWrapperResultList.add(wrapResultObj);
                }
            }
        
        }
        
        system.debug('###'+pepperStringFinal);
        system.debug('###result'+resultStringFinal);
        
       
        
        
        
        if(OpportuntyiD !=null){
            List<DI_Condition_Response__c> diCondList = [Select id from DI_Condition_Response__c where Opportunity__c=:OpportuntyiD];
            if(diCondList !=null && diCondList.size() > 0){
                delete diCondList;
                diCondList.clear();
            }
            
            if(diCondList.size() == 0){
                for(DIWrapperLoanCondition dwrapLoan:diWrapperLoanList){
                    diCondList.add(new DI_Condition_Response__c(Code_Id__c = dwrapLoan.code,Opportunity__c = OpportuntyiD,Description__c=dwrapLoan.comment,Return_Type__c = dWrapLoan.type));
                }
                
                for(DIWrapperResultAlert dWrapResult:diWrapperResultList){
                    diCondList.add(new DI_Condition_Response__c(Code_Id__c = dWrapResult.id,Fg_New__c=dWrapResult.fgNew,Section__c=dWrapResult.txSection,Status__c=dWrapResult.txStatus,Opportunity__c = OpportuntyiD,Description__c=dWrapResult.description,Return_Type__c = dWrapResult.type));
                }
                
                for(DIWrapperApplicationAlert dWrapApplication:diWrapperApplicantList){
                   diCondList.add(new DI_Condition_Response__c(Code_Id__c = dWrapApplication.id,Fg_New__c=dWrapApplication.fgNew,Section__c=dWrapApplication.txSection,Status__c=dWrapApplication.txStatus,Opportunity__c = OpportuntyiD,Description__c=dWrapApplication.description,Return_Type__c = dWrapApplication.type));
                }
            }
            
            if(diCondList.size() > 0){
                insert diCondList;
            }
        }
        
    }
    
   webservice static void parseDIXMLResponseLoanProd(String response, String OpportuntyiD){
        String strLoanProduct = ''; 
        Integer loopIndex = 1;
        List<Pepper_Loan_Product_Fee__c> lstPeeperLoanProductFee = new List<Pepper_Loan_Product_Fee__c>();
        List<Pepper_Loan_Product__c> lstPeeperLoanProduct = new List<Pepper_Loan_Product__c>();
        String name = '';
        if(response.contains('loan_product')){
            String strdiXmlResponse = response.substringBetween('<loan_product>','</loan_product>'); 
            name = response.substringBetween('<tx_product_name>','</tx_product_name>');
            system.debug('strdiXmlResponse######'+strdiXmlResponse); 
            String strXml = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
            strLoanProduct = strXml + strdiXmlResponse + '</soap:Envelope>';
            //Loan Condition Section
            Dom.Document doc = new Dom.Document();
            doc.load(strLoanProduct);
            Dom.XMLNode rootElement = doc.getRootElement();
            system.debug('###123'+rootElement);
            if(rootElement != null){
               List<DIWrapperLoanProduct> diWrapperLoanList = new List<DIWrapperLoanProduct>();
               DIWrapperLoanProduct wrapLoanObj = new DIWrapperLoanProduct();
               for(Dom.XMLNode child : rootElement.getChildElements()) { 
                   List<FeeList> lstDiWrapperLoanProductFee = new List<FeeList>();
                   if(child.getName() == 'cd_group') wrapLoanObj.CDGroup = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'am_loan_amount') wrapLoanObj.AmLoanAmount = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'cd_product') wrapLoanObj.CDProduct = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'no_interest_rate') wrapLoanObj.NoInterestRate = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'fg_hold_fixed') wrapLoanObj.FgHoldFixed = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'no_loan_term') wrapLoanObj.NoLoanTerm = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'cd_loan_term_type') wrapLoanObj.CDLoanTermType = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'cd_interest_only_type') wrapLoanObj.CDInterestOnlyType = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'cd_repayment_frequency') wrapLoanObj.CDRepaymentFrequency = child.getText() != null ? child.getText() : '';
                   if(child.getName() == 'cd_repayment') wrapLoanObj.CDRepayment = child.getText() != null ? child.getText() : '';
                   //if(!name.isEmpty()) wrapLoanoBJ.name = name;
                   
                   if(child.getChildElements() != null && !child.getChildElements().isEmpty()){               
                       //for(Dom.XMLNode subchild : child.getChildElements()){
                           if(child.getName() == 'fee_list'){
                               for(Dom.XMLNode subChild : child.getChildElements()){
                                   FeeList objWrapFee = new FeeList();
                                    for(Dom.XMLNode lowerSubChild:subChild.getChildElements()){
                                        
                                        if(lowerSubChild.getName() == 'id_fee') objWrapFee.idFee = lowerSubChild.getText() != null ? lowerSubChild.getText() : '';
                                        if(lowerSubChild.getName() == 'nm_fee') objWrapFee.nmFee = lowerSubChild.getText() != null ? lowerSubChild.getText() : '';
                                        if(lowerSubChild.getName() == 'am_amount') objWrapFee.amAmount = lowerSubChild.getText() != null ? lowerSubChild.getText() : '';
                                        if(lowerSubChild.getName() == 'cd_occurrance') objWrapFee.cdOccurance = lowerSubChild.getText() != null ? lowerSubChild.getText() : '';
                                        if(lowerSubChild.getName() == 'cd_capitalised') objWrapFee.cdCapitalised = lowerSubChild.getText() != null ? lowerSubChild.getText() : '';
                                        
                                    }
                                    lstDiWrapperLoanProductFee.add(objWrapFee);
                                }
                                if(lstDiWrapperLoanProductFee != null && !lstDiWrapperLoanProductFee.isEmpty())
                                wrapLoanObj.diWrapperLoanProductFee = lstDiWrapperLoanProductFee;
                            }
                        //}
                    }
                    
                    
                    
               }
               diWrapperLoanList.add(wrapLoanObj);
               if(diWrapperLoanList != null && !diWrapperLoanList.isEmpty()){
                    for(DIWrapperLoanProduct objdiwrapLoanList : diWrapperLoanList)
                    {               
                        Pepper_Loan_Product__c objPepperLoanProduct = new Pepper_Loan_Product__c();
                        objPepperLoanProduct.AmLoanAmount__c = objdiwrapLoanList.AmLoanAmount;
                        objPepperLoanProduct.CDGroup__c = objdiwrapLoanList.CDGroup;
                        objPepperLoanProduct.CDInterestOnlyType__c = objdiwrapLoanList.CDInterestOnlyType;
                        objPepperLoanProduct.CDLoanTermType__c = objdiwrapLoanList.CDLoanTermType;
                        objPepperLoanProduct.CDProduct__c = objdiwrapLoanList.CDProduct;
                        objPepperLoanProduct.CDRepayment__c = objdiwrapLoanList.CDRepayment;
                        objPepperLoanProduct.CDRepaymentFrequency__c = objdiwrapLoanList.CDRepaymentFrequency;
                        objPepperLoanProduct.FgHoldFixed__c = objdiwrapLoanList.FgHoldFixed;
                        objPepperLoanProduct.NoInterestRate__c = objdiwrapLoanList.NoInterestRate;
                        objPepperLoanProduct.NoLoanTerm__c = objdiwrapLoanList.NoLoanTerm;
                        objPepperLoanProduct.Opportunity__c = OpportuntyiD;
                        objPepperLoanProduct.name = name;
                        objPepperLoanProduct.Index__c = string.valueof(loopIndex);
                        if(objdiwrapLoanList.diWrapperLoanProductFee != null && !objdiwrapLoanList.diWrapperLoanProductFee.isempty())
                        {
                            for(FeeList objFee : objdiwrapLoanList.diWrapperLoanProductFee)
                            {
                                Pepper_Loan_Product_Fee__c objPepperLoanProductFee = new Pepper_Loan_Product_Fee__c();
                                objPepperLoanProductFee.Amamount__c = objFee.amAmount;
                                objPepperLoanProductFee.CDCapitalised__c = objFee.cdCapitalised;
                                objPepperLoanProductFee.CDOccurrance__c = objFee.cdOccurance;
                                objPepperLoanProductFee.IDFee__c = objFee.idFee;
                                objPepperLoanProductFee.NMFee__c = objFee.nmFee;
                                objPepperLoanProductFee.OpportunityId__c = OpportuntyiD;
                                objPepperLoanProductFee.index__c = string.valueof(loopIndex);
                                lstPeeperLoanProductFee.add(objPepperLoanProductFee);
                            }
                        }   
                        lstPeeperLoanProduct.add(objPepperLoanProduct);
                        loopIndex++;
                    }
                }
        
            }
        }
        system.debug('###opp'+OpportuntyiD);
        system.debug('##123'+lstPeeperLoanProduct);
        List<Pepper_Loan_Product__c> pepperList = [Select id from Pepper_Loan_Product__c where Opportunity__c=:OpportuntyiD];
        Set<id> pepperIdSet = new Set<id>();
        for(Pepper_Loan_Product__c pLoan:pepperList){
            pepperIdSet.add(pLoan.id);
        }
        if(pepperList !=null && pepperList.size()>0){
            delete pepperList;
        }
        List<Pepper_Loan_Product_Fee__c> pepperFeeList =[Select id from Pepper_Loan_Product_Fee__c where Pepper_Loan_Product__c=:pepperIdSet];
        if(pepperFeeList !=null && pepperFeeList.size() > 0){
            delete pepperFeeList;
            //diCondList.clear();
        }
        
        if(lstPeeperLoanProduct != null && !lstPeeperLoanProduct.isEmpty()){
            insert lstPeeperLoanProduct;
        }
        if(lstPeeperLoanProductFee != null && !lstPeeperLoanProductFee.isEmpty()){
            insert lstPeeperLoanProductFee;
        }
    }
    
    
    public class DIWrapperLoanCondition{
        public string code;
        public String comment;
        public String type;
    }
    
    public class DIWrapperResultAlert{
        public string id;
        public string description;
        public string txStatus;
        public string txSection;
        public string fgNew;
        public string type;
    }
    
    public class DIWrapperApplicationAlert{
        public string id;
        public string description;
        public string txStatus;
        public string txSection;
        public string fgNew;
        public string type;
    }
    
    
    public class DIWrapperLoanProduct
    {
        public string CDGroup;
        public String AmLoanAmount;
        public String CDInterestOnlyType;
        public String CDLoanTermType;
        public String CDProduct;
        public String CDRepayment;
        public String CDRepaymentFrequency;
        public String FgHoldFixed;
        public String NoInterestRate;
        public String NoLoanTerm;
        public FeeList[] diWrapperLoanProductFee;       
    }
    
    public class FeeList{
        public string idFee;
        public string nmFee;
        public string amAmount;
        public string cdOccurance;
        public string cdCapitalised;
    }

}