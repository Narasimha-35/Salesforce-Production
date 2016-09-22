global class ParseDIXMLResponse{
    webservice static void parseDIXMLResponseMethod(String reponse, String OpportuntyiD){
        
        String pepperStringFinal = ''; 
        String resultStringFinal = '';
        String  applicantStringFinal = '';
        List<DIWrapperResultAlert> diWrapperResultList = new List<DIWrapperResultAlert>();
        List<DIWrapperLoanCondition> diWrapperLoanList = new List<DIWrapperLoanCondition>();
        List<DIWrapperApplicationAlert> diWrapperApplicantList = new List<DIWrapperApplicationAlert>();
        system.debug('###resp'+reponse);
        reponse = reponse.replaceFirst('<result>', '<bill>');
        reponse = reponse.replaceFirst('</result>', '</bill>');
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
}