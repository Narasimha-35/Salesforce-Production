//==============================================================================
//     Name             createdDate               Version
//==============================================================================
//    Prateek Gupta       23-05-2016                 1.0
//==============================================================================
//    This class is used to send Email to applicant associated with Opportunity.
//==============================================================================
global class clsSendEmailNotification
{  
    public static List<wrapSelectPdf> lstwrapSelectpdf{get;set;}
    public list<wrapSelectPdf> lstwrapSelectpdfComp{get;set;}
    public String strValidationError {get;set;}
    public Id OppId;
    public boolean mailSent{get;set;}
    public List<Opportunity> lstOpp{get;set;}
    
    public clsSendEmailNotification(ApexPages.StandardController controller) 
    {   
        oppId = ApexPages.CurrentPage().getParameters().get('Id');
        mailSent = false;
        lstwrapSelectpdf = new List<wrapSelectPdf>();  
        lstwrapSelectpdfComp = new List<wrapSelectPdf>();
        set<string> setDocNames = new set<string>();
        setDocNames.add('Credit Guide');
        setDocNames.add('Credit Proposal Disclosure');
        setDocNames.add('Preliminary Assesment');
        for(string strDocName : setDocNames)
        {
            wrapSelectPdf objWrapSelectPdf = new wrapSelectPdf();
            objWrapSelectPdf.strDocName = strDocName;
            lstwrapSelectpdf.add(objWrapSelectPdf);
            lstwrapSelectpdfComp.add(objWrapSelectPdf);
        }          
    }
    
   public PageReference sendDocs()
   {
   try{ 
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        List<Messaging.EmailFileAttachment> emailFileAttachment =  new List<Messaging.EmailFileAttachment>();
        List<String> sendTo = new List<String>();
        List<EmailTemplate> lsttemplateId =new List<EmailTemplate>(); 
        List<S3DocumentModel.UploadRequest> uploadRequests = new List<S3DocumentModel.UploadRequest>(); 
        List<String> ccTo = new List<String>();
        system.debug('###opp'+oppID);
        if(oppID != null)
        {
            lstOpp = new List<Opportunity>();
            List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
            List<Product2> lstProduct = new List<Product2>();
            List<LVR_Rate__c>  lstLVR = new List<LVR_Rate__c>();
            lstOpp = [SELECT StageName,account.personcontactId,accountid,CurrentAssignedBroker__r.Email__c ,acfDate_Docs_Generated__c,CurrentAssignedBroker__r.ACL_Holder__c,CurrentAssignedBroker__r.ACL_Address__c,
                      CurrentAssignedBroker__r.ACL_Phone__c,CurrentAssignedBroker__r.ACL_Licence__c,CurrentAssignedBroker__r.ACL_Email__c,
                      CurrentAssignedBroker__r.ACL_EDR_Scheme__c,CurrentAssignedBroker__r.ACL_EDR_Membership_No__c,CurrentAssignedBroker__r.Name,
                      CurrentAssignedBroker__r.Representative_Business_Address__c,CurrentAssignedBroker__r.MobilePhone__c,CurrentAssignedBroker__r.Representative_Email__c,
                      CurrentAssignedBroker__r.ACR__c,CurrentAssignedBroker__r.ACR_EDR_Scheme_Name__c,CurrentAssignedBroker__r.ACR_EDR_Membership_No__c,
                      CurrentAssignedBroker__r.ACR_EDR_Expiry__c,CurrentAssignedBroker__r.PI_Insurance_Name__c,CurrentAssignedBroker__r.Channel__c , 
                      Account.Recordtypeid  ,(SELECT Applicant_Email__c FROM Applicants__r),(SELECT Opportunity__c,LMI__c from Funding_Positions__r)
                      FROM Opportunity where id = :oppID ];
            
            lstOLI = [select id,Product2.Name,PricebookEntry.Product2.Name,PricebookEntry.Name,Click_Loans_LVR_Rate__r.acfEstablishment_Fee__c,
                      Click_Loans_LVR_Rate__r.acfLegal_Fees__c,Click_Loans_LVR_Rate__r.acfMonthly_Fees__c,Click_Loans_LVR_Rate__r.acfAnnual_Fees__c,click_Loan_Amount__c,click_Type__c,
                      Click_Estimated_Monthly_Payment__c,Click_Tenure__c,acfRate__c,lender__c,OpportunityId 
                      from OpportunityLineItem where OpportunityId=:oppID];
            

            lstProduct = [SELECT Id,Name,acfApplication_Fee__c,acfLegal_Fees__c,Upfront_Commission__c,Trailing_Commission__c,Annual_Fee__c,
                          Monthly_Fee__c FROM Product2 WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem where OpportunityId =:oppID)]; 
                          
            lstLVR = [SELECT id,acfAnnual_Fees__c,acfEstablishment_Fee__c,acfLegal_Fees__c,acfMonthly_Fees__c,
                      (select id,Click_Loans_LVR_Rate__c,PricebookEntry.Product2.Name from Opportunity_Product__r 
                      where OpportunityId =: oppID) from LVR_Rate__c];
                  
            strValidationError = ''; 
            boolean isDocNotselected = true;
            system.debug('lstwrapSelectpdf****'+lstwrapSelectpdfComp +'lstwrapSelectpdf****'+lstwrapSelectpdfComp.size());
            if(lstwrapSelectpdfComp!=null && lstwrapSelectpdfComp.size() > 0)
            {
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp)
                {
                    if(objwrapSelectPdf.IsDocSelected == true)
                    {
                        isDocNotselected = false;
                        break;                    
                    }
                } 
            }
            if(isDocNotselected == true)
            {
                strValidationError = 'Please select the documents to send';
                return null;
            }

            if(lstOpp != null && !lstOpp.isEmpty())
            {
                Opportunity oopObj = lstOpp[0];
                if(oopObj != null)
                {
                    String BrokerChannel =oopObj.CurrentAssignedBroker__r.Channel__c  == null ? '' : oopObj.CurrentAssignedBroker__r.Channel__c ;
                    System.debug('BrokerChannel'+BrokerChannel);
                  
                    if(lstwrapSelectpdfComp != null && !lstwrapSelectpdfComp.isEmpty())
                    {
                        for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp)
                        {
                            if(objwrapSelectPdf.IsDocSelected == true)
                            {
                                if(objwrapSelectPdf.strDocName == 'Preliminary Assesment')
                                {
                                    if(string.isempty(oopObj.CurrentAssignedBroker__c))
                                    {
                                        strValidationError = 'Please fill Broker on  Opportunity.';
                                        break;
                                    }
                                    if(oopObj.Funding_Positions__r !=null && oopObj.Funding_Positions__r.size() >0)
                                    {
                                        if(string.valueof(oopObj.Funding_Positions__r[0].LMI__c) == '' || oopObj.Funding_Positions__r[0].LMI__c == null)
                                          {  
                                            strValidationError = 'Please fill Funding Position LMI.';  
                                            break;
                                          }
                                    }
                                    else  if(string.isempty(String.valueOf(oopObj.acfDate_Docs_Generated__c)))
                                    {
                                        strValidationError = 'Please fill Date Docs Generated field.'; 
                                        break;  
                                    } 
                                   system.debug('lstOLI'+lstOLI.size());
                                    if(lstOLI !=null && !lstOLI.isEmpty())
                                    {
                                        for(OpportunityLineItem objOLI : lstOLI)
                                        {
                                           if(string.isEmpty(objOLI.Product2.Name))
                                           {
                                                strValidationError = 'Please fill Opportunity product name.';
                                                break;
                                           }
                                           else if(string.isEmpty(string.valueOf(objOLI.click_Loan_Amount__c)))
                                           {
                                                strValidationError = 'Please fill loan amount on Opportunity product';
                                                break;
                                           }
                                           else if(string.isEmpty(objOLI.click_Type__c))
                                           {
                                               strValidationError = 'Please fill Payment type on Opportunity product';
                                               break;
                                           }
                                           else if(string.isEmpty(string.valueOf(objOLI.Click_Estimated_Monthly_Payment__c)))
                                           {
                                                strValidationError = 'Please fill Estimated Monthly Payment on Opportunity product';
                                                break;
                                           }
                                           else if(string.isEmpty(objOLI.Click_Tenure__c))
                                           {
                                                strValidationError = 'Please fill Estimated Monthly PaymentTenure on Opportunity product';
                                                break;
                                           }
                                           else if(string.isEmpty(string.valueOf(objOLI.acfRate__c)))
                                           {
                                                strValidationError = 'Please fill Estimated Rate';
                                                break;
                                           }
                                           else if(string.isEmpty(objOLI.lender__c))
                                           {
                                                strValidationError = 'Please fill lender on Opportunity product';
                                                break;
                                           } 
                                        }
                                    }    
                                    if(lstProduct !=null && !lstProduct.isEmpty())    
                                    {
                                        for(Product2 objProduct : lstProduct)
                                        {
                                           system.debug('###'+objProduct);
                                           if(string.isEmpty(objProduct.Name))
                                           {
                                                strValidationError =  'Please fill Product name.';
                                                break;
                                           }
                                          
                                           else if(string.isEmpty(string.valueOf(objProduct.Upfront_Commission__c)))
                                           {
                                               strValidationError = 'Please fill Upfront commission on Product';
                                               break;
                                           }
                                           else if(string.isEmpty(string.valueOf(objProduct.Trailing_Commission__c)))
                                           {
                                               strValidationError = 'Please fill Trailing commission on Product';
                                               break;
                                           }
                                     
                                       }   
                                   }  
                                }
                                if(objwrapSelectPdf.strDocName == 'Credit Guide')
                                { 
                                    if(string.isempty(oopObj.CurrentAssignedBroker__c))
                                    {
                                        strValidationError = 'Please fill Broker on  Opportunity.';
                                        break;
                                    }
                                    System.debug('BrokerChannel12345'+BrokerChannel);
                                    if(objwrapSelectPdf.strDocName == 'Credit Guide' && (BrokerChannel =='Click' || BrokerChannel =='Partner'))
                                    {     
                                        if(string.isempty(oopObj.CurrentAssignedBroker__r.ACL_Holder__c))
                                        {
                                            strValidationError = 'Please fill Broker ACL Holder';
                                            break;
                                        }   
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACL_Address__c))
                                        {
                                           strValidationError = 'Please fill Broker ACL Address.'; 
                                           break;                       
                                        }    
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACR_EDR_Scheme_Name__c))
                                        {
                                            strValidationError =  'Please fill Broker ACR EDR Scheme Name.'; 
                                            break;                       
                                        }
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACR_EDR_Membership_No__c))
                                        {
                                            strValidationError = 'Please fill Broker ACR EDR Membership No.'; 
                                            break;                       
                                        }
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACL_Phone__c))
                                        {
                                            strValidationError = 'Please fill Broker ACL Phone.'; 
                                            break;                       
                                        }                               
                                    }
                                    if(objwrapSelectPdf.strDocName == 'Credit Guide' && BrokerChannel =='Partner')
                                    {                           
                                       if(string.isempty(oopObj.CurrentAssignedBroker__r.Representative_Business_Address__c))
                                        {
                                             strValidationError = 'Please fill Broker Representative Business Address.';   
                                             break;                     
                                        }
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.MobilePhone__c))
                                        {
                                            strValidationError = 'Please fill Broker MobilePhone.'; 
                                            break;                       
                                        }
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.Representative_Email__c))
                                        {
                                             strValidationError = 'Please fill Broker Representative Email.';
                                             break;                        
                                        }
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACR__c))
                                        {
                                             strValidationError = 'Please fill Broker ACR #.';     
                                             break;                   
                                        }
                                        else if(string.isempty(string.valueof(oopObj.CurrentAssignedBroker__r.ACR_EDR_Expiry__c)))
                                        {
                                            strValidationError = 'Please fill Broker ACR EDR Expiry.'; 
                                            break;                       
                                        }
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.PI_Insurance_Name__c))
                                        {
                                             strValidationError = 'Please fill Broker PI Insurance Name.';  
                                             break;                      
                                        }
                                        else if(string.isempty(oopObj.CurrentAssignedBroker__r.Channel__c))
                                        {
                                            strValidationError = 'Please fill Broker Channel.'; 
                                            break;                       
                                        }               
                                    }
                                } 
                                if(objwrapSelectPdf.strDocName == 'Credit Proposal Disclosure')
                                {
                                    if(string.isempty(oopObj.CurrentAssignedBroker__c))
                                    {
                                        strValidationError = 'Please fill Broker on  Opportunity.';
                                        break;
                                    }
                                    else if(string.isempty(oopObj.CurrentAssignedBroker__r.Email__c))
                                    {    
                                        strValidationError = 'Please fill Broker Email.'; 
                                        break;                                    
                                    }
                                    else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACR__c))
                                    {
                                         strValidationError = 'Please fill Broker ACR #.';     
                                         break;                   
                                    }
                                    else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACL_Licence__c))
                                    {
                                        strValidationError = 'Please fill Broker ACL #.'; 
                                        break;                       
                                    }
                                    else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACL_Email__c))
                                    {
                                       strValidationError = 'Please fill Broker ACL Email.';
                                       break;                         
                                    }
                                    else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACL_EDR_Scheme__c))
                                    {
                                        strValidationError = 'Please fill Broker ACL EDR Scheme.';
                                        break;                         
                                    }
                                    else if(string.isempty(oopObj.CurrentAssignedBroker__r.ACL_EDR_Membership_No__c))
                                    {
                                       strValidationError = 'Please fill Broker ACL EDR Membership No.';
                                       break;                         
                                    }
                                    else if(string.isempty(oopObj.CurrentAssignedBroker__r.Name))
                                    {
                                        strValidationError = 'Please fill Broker Name.';
                                        break;                         
                                    }
                                    else if(string.isempty(oopObj.AccountId))
                                    {
                                        strValidationError =  'Please fill Account.'; 
                                        break;                        
                                    }
                                  if(lstOLI !=null && !lstOLI.isEmpty())
                                    {
                                     for(OpportunityLineItem objOLI : lstOLI)
                                      {
                                        if(string.isEmpty(String.valueOf(objOLI.Click_Loans_LVR_Rate__r.acfEstablishment_Fee__c)))
                                        {
                                          strValidationError = 'Please fill Establishment Fee on LVR & Rate.';
                                          break;
                                        }
                                    
                                        else if(string.isEmpty(String.valueOf(objOLI.Click_Loans_LVR_Rate__r.acfLegal_Fees__c)))
                                        {
                                           strValidationError = 'Please fill Legal Fee on LVR & Rate.';
                                           break;
                                        }
                                       } 
                                 /*   system.debug('list---lvr'+lstLVR);
                                    if(lstLVR !=null && !lstLVR.isEmpty())    
                                    {
                                        for(LVR_Rate__c objLVR : lstLVR)
                                        {
                                           system.debug('###'+objLVR);
                                           if(string.isEmpty(string.valueOf(objLVR.acfEstablishment_Fee__c)))
                                           {
                                                strValidationError =  'Please fill Application Fee on LVR & Rate.';
                                                break;
                                           }
                                           else if(string.isEmpty(string.valueOf(objLVR.acfLegal_Fees__c)))
                                           {
                                               strValidationError = 'Please fill Legal Fee on LVR & Rate';
                                               break;
                                           }
                                       }   
                                   }   */ 
                                }
                            }
                        }
                   }
                  }
                   else if(oopObj.Applicants__r != null && !oopObj.Applicants__r.isEmpty() && string.isempty(oopObj.Applicants__r[0].Applicant_Email__c))
                   {
                       strValidationError = 'Please fill Applicant Email.';  
                   }
     
                   String Channel =oopObj.CurrentAssignedBroker__r.Channel__c  == null ? '' : oopObj.CurrentAssignedBroker__r.Channel__c ;
                   string strTemplateName = 'Click_Compliance_Docs';
                   if(Channel == 'Partner' || Channel == 'Employee' || Channel == 'Phone Broker')
                   {
                       strTemplateName = 'ACF_Compliance_Docs';
                   }
                
                    lsttemplateId = [select id,subject,body,name,HtmlValue from EmailTemplate where DeveloperName =:strTemplateName AND isActive=true];    
                    string strAccountId = oopObj.accountid;
                    string strContactId = oopObj.account.personcontactid;
                    if(lsttemplateId != null && lsttemplateId.size()>0)
                    {
                        
                        string strTemplateId = lsttemplateId[0].id;
                        if(lstwrapSelectpdfComp!=null && lstwrapSelectpdfComp.size() > 0)
                        {
                            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(strTemplateId, strContactId, strAccountId);
                            if(oopObj.Applicants__r != null && !oopObj.Applicants__r.isEmpty())
                            {
                                for(click_Applicant__c objApplicant : oopObj.Applicants__r)
                                {
                                    if(objApplicant.Applicant_Email__c != null)
                                    {
                                        sendTo.add(objApplicant.Applicant_Email__c); 
                                    }  
                                }
                            }
                            mail.setToAddresses(sendTo);
                            
                            if(oopObj.CurrentAssignedBroker__c != null && oopObj.CurrentAssignedBroker__r.Email__c != null)
                            {
                                ccTo.add(oopObj.CurrentAssignedBroker__r.Email__c);
                                mail.setCcAddresses(ccTo);
                            }         
                            mail.setSenderDisplayName(Userinfo.getusername());
                            mail.setSubject('Compliance Docs');
                            for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp)
                            {
                                if(objwrapSelectPdf.strDocName == 'Credit Guide' && objwrapSelectPdf.strDocName == 'Credit Proposal Disclosure' && objwrapSelectPdf.strDocName =='Preliminary Assesment' && objwrapSelectPdf.IsDocSelected == false){
                                    strValidationError = 'Please select the documents to send';                           
                                }
                                else if(objwrapSelectPdf.IsDocSelected == true && strValidationError == '')
                                {        
                                    if(oopObj !=null && oopObj.Applicants__r !=null && oopObj.CurrentAssignedBroker__c != null && lstOLI != null && lstProduct != null && oopObj.Funding_Positions__r !=null )
                                    {
                                        emailFileAttachment = getComplianceAttachment(oopObj);
                                        //system.debug('emailFileAttachment---' +emailFileAttachment);
                                        if(emailFileAttachment.size() > 0)
                                        {
                                            mail.setFileAttachments(emailFileAttachment);
                                        }                                        
                                    }               
                                }
                            }  
                            if(strValidationError == '')
                            {
                                mails.add(mail); 
                            }
                            
                        }
                    } 
                    
                if(mails.size() > 0)
                   {
                       Messaging.sendEmail(mails);
                       if(emailFileAttachment.size() > 0)
                       {
                            system.debug('###');
                            for(Messaging.EmailFileAttachment objAttach : emailFileAttachment)
                            {
                                system.debug('###11111');
                                if(objAttach.fileName != null && objAttach.Body != null)
                                    uploadRequests.add(new S3DocumentModel.UploadRequest(objAttach.fileName, objAttach.Body, S3StaticValue.PDF_MINE_TYPE));                                    
                            }
                            system.debug('###uploadRequests***************************'+uploadRequests);
                            system.debug('###sendTo ***************************'+sendTo);
                            // Save history
                            if(sendTo != null && !sendTo.isempty() && uploadRequests != null && !uploadRequests.isempty())
                            {
                                string strHTML = '';
                                string strSubject = '';
                                if(lsttemplateId != null && lsttemplateId.size()>0)
                                {
                                    Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(lsttemplateId[0].id, strContactId, strAccountId);
                                    if(mail != null)
                                    strHTML = mail.HtmlBody;
                                    strSubject = lsttemplateId[0].subject;
                                }
                                system.debug('!@#########'+sendTo+ '^^^'+ccTo+'test****'+strSubject+'!@#$'+strHTML+'%%%%'+uploadRequests+'@@@@@'+oppID);
                                EmailHistoryService.saveEmailHistoryUnderOpportunity(sendTo,ccTo,strSubject, strHTML, uploadRequests,oppID);                                
                            }
                       }
                       
                       mailSent = true;
                       strValidationError = 'Compliance Docs Sent Successfullly.';
                   } 
                }         
            }   
       }
       
       
       return null;
    }
    catch(Exception ex)
    {
           ApexPages.Message nullCheckError = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
           ApexPages.addMessage(nullCheckError);
           strValidationError = string.valueof(ex.getMessage());
           return null;
     
    }   
    
    }  

    @TestVisible private List<Messaging.EmailFileAttachment> getComplianceAttachment(Opportunity oopObj)
     {
        List<Messaging.EmailFileAttachment>  mailsAttachments = new List<Messaging.EmailFileAttachment> ();
       
        String Channel =oopObj.CurrentAssignedBroker__r.Channel__c  == null ? '' : oopObj.CurrentAssignedBroker__r.Channel__c ;
        System.debug('!!@@@'+oopObj.CurrentAssignedBroker__r.Channel__c);
         system.debug('changgghghjgjgjgjgj---'+Channel);
        if(Channel == 'Partner')
        {
            // 1 attachment
            PageReference cPartner = page.CreditGuidePartner;

            cPartner.getParameters().put('id',(String) oopObj.id);
            system.debug('###cPartner'+cPartner);
            cPartner.setRedirect(true);
            Blob CreditGuidePartneObj;
            if(!test.isRunningtest())
            {
             CreditGuidePartneObj= cPartner.getContent();
            }else{
                CreditGuidePartneObj = blob.valueof('test');
            }
            Messaging.EmailFileAttachment CreditGuidePartnerefa = new Messaging.EmailFileAttachment();
            CreditGuidePartnerefa.setFileName('CreditGuidePartner.pdf');
            CreditGuidePartnerefa.setBody(CreditGuidePartneObj);
            system.debug('******600*****'+lstwrapSelectpdfComp);
            if(lstwrapSelectpdfComp!=null && lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Credit Guide' && objwrapSelectPdf.IsDocSelected == true){
                
                    for(Opportunity OppValidate : lstOpp)
                    {
                        if(string.isempty(OppValidate.CurrentAssignedBroker__r.ACL_Licence__c))
                        {    
                            strValidationError = 'Please fill Broker ACL Licence.';                                     
                        }
                        else
                        {
                            mailsAttachments.add(CreditGuidePartnerefa);
                        }
                    }
                    //return mailsAttachments;
                       
                    }
                }
            }           
            // 2nd attachment       
            PageReference PreliminaryAssesmentPartner = page.PreliminaryAssesmentPartner;
            PreliminaryAssesmentPartner.getParameters().put('id',(String) oopObj.id);
            PreliminaryAssesmentPartner.setRedirect(true);
            
            Blob PreliminaryAssesmentPartnerObj;
            if(!test.isRunningtest())
            {
             PreliminaryAssesmentPartnerObj= PreliminaryAssesmentPartner.getContent();
             }else{
                PreliminaryAssesmentPartnerObj = blob.valueof('test');
            }
           
            Messaging.EmailFileAttachment PreliminaryAssesmentPartnerefa = new Messaging.EmailFileAttachment();
            PreliminaryAssesmentPartnerefa.setFileName('PreliminaryAssesmentPartner.pdf');
            PreliminaryAssesmentPartnerefa.setBody(PreliminaryAssesmentPartnerObj);
            
            if(lstwrapSelectpdfComp !=null && lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Preliminary Assesment' && objwrapSelectPdf.IsDocSelected == true){
                    
                        mailsAttachments.add(PreliminaryAssesmentPartnerefa);
                    }
                     
                } 
            }           
           
            // 3rd attachment   
            PageReference creditProposalDisclosurePartner= page.CreditProposalDisclosurePartner;
            CreditProposalDisclosurePartner.getParameters().put('id',(String) oopObj.id);
            CreditProposalDisclosurePartner.setRedirect(true);
            
            Blob CreditProposalDisclosurePartnerObj;
            if(!test.isRunningTest())
            {
              CreditProposalDisclosurePartnerObj= CreditProposalDisclosurePartner.getContent();
            }else{
                CreditProposalDisclosurePartnerObj = blob.valueof('test');
            }
            Messaging.EmailFileAttachment CreditProposalDisclosureDocPartnerObjefa = new Messaging.EmailFileAttachment();
            CreditProposalDisclosureDocPartnerObjefa.setFileName('CreditProposalDisclosurePartner.pdf');
            CreditProposalDisclosureDocPartnerObjefa.setBody(CreditProposalDisclosurePartnerObj);
            if(lstwrapSelectpdfComp !=null && lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Credit Proposal Disclosure' && objwrapSelectPdf.IsDocSelected == true){
                        mailsAttachments.add(CreditProposalDisclosureDocPartnerObjefa);
                    }                 
                }
            }           
           System.debug('Channel12'+Channel);   
        }
         System.debug('Channel'+Channel);
        if  (Channel == 'Employee' || Channel == 'Phone Broker')
        {
            
            // 1 attachment
            PageReference CreditProposalDisclosureEmp = page.CreditProposalDisclosureEmp;
            CreditProposalDisclosureEmp.getParameters().put('id',(String) oopObj.id);
            system.debug('before CreditProposalDisclosureEmp #$%---'+CreditProposalDisclosureEmp);
            CreditProposalDisclosureEmp.setRedirect(true);
        
            system.debug('CreditProposalDisclosureEmp #$%---'+CreditProposalDisclosureEmp);
            Blob CreditGuidePartneObj;
            if(!test.isRunningTest())
            {
             CreditGuidePartneObj= CreditProposalDisclosureEmp.getContent();
            }else{
                CreditGuidePartneObj = blob.valueof('test');
            }
            system.debug('credit*****'+CreditGuidePartneObj);
            Messaging.EmailFileAttachment CreditProposalDisclosureACFefa = new Messaging.EmailFileAttachment();
            CreditProposalDisclosureACFefa.setFileName('CreditProposalDisclosureACF.pdf');
            CreditProposalDisclosureACFefa.setBody(CreditGuidePartneObj);
              if(lstwrapSelectpdfComp !=null && lstwrapSelectpdfComp.size()>0){
                  for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                        if(objwrapSelectPdf.strDocName == 'Credit Proposal Disclosure' && objwrapSelectPdf.IsDocSelected == true){
                           mailsAttachments.add(CreditProposalDisclosureACFefa);
                        }                 
                  }
              }   
            
            // 2nd attachment       
            PageReference PreliminaryAssessmentEmp = page.PreliminaryAssessmentEmp;
            PreliminaryAssessmentEmp.getParameters().put('id',(String) oopObj.id);
            PreliminaryAssessmentEmp.setRedirect(true);
            Blob PreliminaryAssesmentACFObj;
            if(!test.isRunningtest())
            {
             PreliminaryAssesmentACFObj= PreliminaryAssessmentEmp.getContent();
            }else{
                PreliminaryAssesmentACFObj = blob.valueof('test');
            }
            
            Messaging.EmailFileAttachment PreliminaryAssesmentACFefa = new Messaging.EmailFileAttachment();
            PreliminaryAssesmentACFefa.setFileName('PreliminaryAssessmentACF.pdf');
            PreliminaryAssesmentACFefa.setBody(PreliminaryAssesmentACFObj);
            
            
            system.debug('******'+lstwrapSelectpdf);
            if(lstwrapSelectpdfComp !=null && lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Preliminary Assesment' && objwrapSelectPdf.IsDocSelected == true){
                    
                        mailsAttachments.add(PreliminaryAssesmentACFefa);
                    }
                     
                }  
            }
            // 3rd attachment   
            PageReference CreditGuideEmployee= page.CreditGuideEmployee;
            CreditGuideEmployee.getParameters().put('id',(String) oopObj.id);
            CreditGuideEmployee.setRedirect(true);
            Blob CreditGuideEmpObj;
            if(!test.isRunningtest())
            {
              CreditGuideEmpObj= CreditGuideEmployee.getContent();
            }else{
                CreditGuideEmpObj = blob.valueof('test');
            }
            
            Messaging.EmailFileAttachment CreditGuideEmpObjefa = new Messaging.EmailFileAttachment();
            CreditGuideEmpObjefa.setFileName('CreditGuideACF.pdf');
            CreditGuideEmpObjefa.setBody(CreditGuideEmpObj);
            
            if(lstwrapSelectpdfComp !=null &&lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Credit Guide' && objwrapSelectPdf.IsDocSelected == true){
                        mailsAttachments.add(CreditGuideEmpObjefa);
                    }
                }
            }   
           
        }
         system.debug('clickchannel----'+Channel);
        if(Channel == 'Click')
        {
            // 1 attachment
            system.debug('mb####'+mailsAttachments);
            PageReference PreliminaryAssessment = page.PreliminaryAssessment;
            PreliminaryAssessment.getParameters().put('id',(String) oopObj.id);
            PreliminaryAssessment.setRedirect(true);
            Blob PreliminaryAssesmentClickObj;
            if(!test.isRunningTest())
            {
              PreliminaryAssesmentClickObj= PreliminaryAssessment.getContent();
            }else{
                PreliminaryAssesmentClickObj = blob.valueof('test');
            }
            Messaging.EmailFileAttachment PreliminaryAssesmentClickefa = new Messaging.EmailFileAttachment();
            PreliminaryAssesmentClickefa.setFileName('PreliminaryAssesmentClick.pdf');
            PreliminaryAssesmentClickefa.setBody(PreliminaryAssesmentClickObj);
            
            if(lstwrapSelectpdfComp !=null && lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Preliminary Assesment' && objwrapSelectPdf.IsDocSelected == true){
                        mailsAttachments.add(PreliminaryAssesmentClickefa);
                    }
                 }
             }
            
            system.debug('mb####123'+mailsAttachments);
            // 2nd attachment       
            PageReference CreditProposalDisclosure = page.CreditProposalDisclosure;
            CreditProposalDisclosure.getParameters().put('id',(String) oopObj.id);
            CreditProposalDisclosure.setRedirect(true);
            Blob CreditProposalDisclosureDocClickObj;
            if(!test.isRunningtest())
            {
                CreditProposalDisclosureDocClickObj= CreditProposalDisclosure.getContent();
            }else{
                CreditProposalDisclosureDocClickObj = blob.valueof('test');
            }
            Messaging.EmailFileAttachment CreditProposalDisclosureDocClickefa = new Messaging.EmailFileAttachment();
            CreditProposalDisclosureDocClickefa.setFileName('CreditProposalDisclosureClick.pdf');
            CreditProposalDisclosureDocClickefa.setBody(CreditProposalDisclosureDocClickObj);
            
            if(lstwrapSelectpdfComp !=null && lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Credit Proposal Disclosure' && objwrapSelectPdf.IsDocSelected == true){
                        mailsAttachments.add(CreditProposalDisclosureDocClickefa);
                    }     
                 }
             }
            system.debug('mb####456'+mailsAttachments);
            
            // 3rd attachment   
            PageReference CreditGuide = page.CreditGuide;
            CreditGuide.getParameters().put('id',(String) oopObj.id);
            CreditGuide.setRedirect(true);
            
            blob CreditGuideClickObj;
            if(!test.isRunningTest())
            {
             CreditGuideClickObj= CreditGuide.getContent();
            }else{
                CreditGuideClickObj = blob.valueof('test');
            }
            
            Messaging.EmailFileAttachment CreditGuideClickefa = new Messaging.EmailFileAttachment();
            CreditGuideClickefa.setFileName('CreditGuideClick.pdf');
            CreditGuideClickefa.setBody(CreditGuideClickObj);
            
            if(lstwrapSelectpdfComp!=null && lstwrapSelectpdfComp.size() > 0){
                for(wrapSelectPdf objwrapSelectPdf : lstwrapSelectpdfComp){
                    if(objwrapSelectPdf.strDocName == 'Credit Guide' && objwrapSelectPdf.IsDocSelected == true){
                        mailsAttachments.add(CreditGuideClickefa);
                    }
                }
            }   
            system.debug('mb789####'+mailsAttachments);
         }   
         return mailsAttachments;      
     }

    public class wrapSelectPdf
    {  
        public string strDocName{get;set;}
        public boolean IsDocSelected{get;set;}
    }
}