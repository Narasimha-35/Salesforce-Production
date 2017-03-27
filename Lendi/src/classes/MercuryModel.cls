public without sharing class MercuryModel {

    public static String getResourceName(Object mercModel) {
        if(mercModel instanceOf MercuryModel.People) return 'person';
        if(mercModel instanceOf MercuryModel.Loan) return 'loan';
        if(mercModel instanceOf MercuryModel.Income) return 'income';
        if(mercModel instanceOf MercuryModel.Expense) return 'expense';
        if(mercModel instanceOf MercuryModel.LoanPeople) return 'loanPeople';
        if(mercModel instanceOf MercuryModel.Address) return 'address';
        if(mercModel instanceOf MercuryModel.Asset) return 'asset';
        if(mercModel instanceOf MercuryModel.Liability) return 'liability';
        return null;
    }

    public class Partner extends Model {
        public String uniqueId {get; set;}
        public String name {get; set;}
    }

    public class PartnerResponse extends Model {
        public Boolean success {get; set;}
        public List<MercuryModel.Partner> partnerList {get; set;}
    }

    public class People extends Model {
        public String uniqueId {get; set;}
        public String company {get; set;}
        public Boolean isDeleted {get; set;}
        public String deletedBy {get; set;}
        public String deletedOn {get; set;}
        public String createdOn {get; set;}
        public String createdBy {get; set;}
        public String isNew {get; set;}
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String middleName {get; set;}
        public String salutation {get; set;}
        public String title {get; set;}
        public String occupation {get; set;}
        public String employer {get; set;}
        public String jobTitle {get; set;}
        public String maritalStatus {get; set;}
        public String driversLicenceNumber {get; set;}
        public String driversLicenceExpiry {get; set;}
        public String driversLicenceState {get; set;}
        public String gender {get; set;}
        public String dateOfBirth {get; set;}
        public String employmentStatus {get; set;}
        public String employmentCommenced {get; set;}
        public String phoneDisplayType1 {get; set;}
        public String phoneDisplayType2 {get; set;}
        public String phoneDisplayType3 {get; set;}
        public String phoneDisplayType4 {get; set;}
        public String addressDisplay {get; set;}
        public String homePhone {get; set;}
        public String businessPhone {get; set;}
        public String mobile {get; set;}
        public String email {get; set;}
        public String personDataType {get; set;}
        public String notes {get; set;}
        public String relationshipManager {get; set;}
        public Decimal annualSalary {get; set;}
        public String contactType {get; set;}
        public String abn {get; set;}
        public String acn {get; set;}
        public String trustName {get; set;}
        public String homeSuburb {get; set;}
        public Integer numberOfDependents {get; set;}
        public Boolean doNotMail {get; set;}
        public String funambolUsers {get; set;}
        public Boolean markAsPrivate {get; set;}
        public String importDocumentId {get; set;}
        public String partnerName {get; set;}
        public Boolean emailBounced {get; set;}
        public String webPassword {get; set;}
        public Boolean webAccess {get; set;}
        public String relationshipManagerName {get; set;}
        public String fullName {get; set;}
        public String salutationOrFirstName {get; set;}
        public List<ContactMethod> contactMethods;
        public Boolean isPrimaryApplicant;

        public People() {
        }

        public People(Account acc, String branchId) {
            init();
            uniqueId = acc.mercury_People_ID__c != null && acc.mercury_People_ID__c != '' ? acc.mercury_People_ID__c : acc.id;
            //Currently no effect, so comment it out
            //createdOn = acc.createdDate.format('yyyy-MM-dd\'T\'HH:mm:ssXXX');
            createdBy = MercuryStaticValue.API_USER_ID;
            firstName = acc.firstName;
            lastName = acc.lastName;
            dateOfBirth = acc.personBirthdate != null ? ((Datetime) acc.personBirthdate).format('yyyy-MM-dd\'T\'HH:mm:ssXXX') : null;
            numberOfDependents = acc.number_of_Children__pc != null && acc.number_of_Children__pc != '' ? Integer.valueOf(acc.number_of_Children__pc.left(1)) : 0;
            company = branchId;
            annualSalary = acc.acfAnnual_Salary__pc;
            title = acc.personTitle;
            gender = acc.gender__pc;
            maritalStatus = acc.marital_Status__pc;
            employmentStatus = acc.employment_Status__pc;
            employer = acc.employer_Name__pc;
            occupation = acc.current_Role__pc;
            jobTitle = acc.job_Title__pc;
            isPrimaryApplicant = true;

            contactMethods = new List<ContactMethod>();
            contactMethods.add(new ContactMethod(uniqueId, ContactMethodType.HOME, acc.personHomePhone));
            contactMethods.add(new ContactMethod(uniqueId, ContactMethodType.MOBILE, acc.personMobilePhone));
            contactMethods.add(new ContactMethod(uniqueId, ContactMethodType.BUSINESS, acc.phone));
            contactMethods.add(new ContactMethod(uniqueId, ContactMethodType.EMAIL1, acc.personEmail));
            contactMethods.add(new ContactMethod(uniqueId, ContactMethodType.EMAIL2, acc.account_Email__c));

            validateAndClean();
        }

        public People(Click_Applicant__c apct, String branchId) {
            init();
            uniqueId = apct.id;
            if(apct.First_Name__c  != null){
                firstName = apct.First_Name__c ;
               }
               if(apct.Last_Name__c  != null){
                    lastName = apct.Last_Name__c;
               }
               
                if(apct.Middle_Name__c  != null){
                    middleName = apct.Middle_Name__c;
               }
               
               
                if(apct.Title__c  != null){
                    Title  = apct.Title__c;
                  }
                   if(apct.Title__c  != null){
                    Title  = apct.Title__c;
                    salutation =   apct.Title__c;
                  }
              
               
               if( apct.gender__c != null)
               {
                   
                   gender = apct.gender__c;
               }
            
         if(apct.acf_applicant_DOB__c  != null    || apct.acf_applicant_DOB__c  != null )
            dateOfBirth = ApplicantUtilities.getDateFieldInGMT(apct.acf_applicant_DOB__c);
        if(apct.acf_applicant_Marital_Status__c  != ''  || apct.acf_applicant_Marital_Status__c  != null )
            maritalStatus = apct.acf_applicant_Marital_Status__c;
        if(apct.acf_applicant_Dependants__c  != null    || apct.acf_applicant_Dependants__c  != null )
            numberOfDependents = ApplicantUtilities.cleanInteger(apct.acf_applicant_Dependants__c);
        if(apct.acf_applicant_Employer_Name__c  != null    || apct.acf_applicant_Employer_Name__c  != null )
            employer = apct.acf_applicant_Employer_Name__c;
        
        if(apct.current_Role__c  !=  ''  || apct.current_Role__c  != null )
            occupation = apct.current_Role__c;
       
       if(apct.acfEmployment_Type__c  !=  ''  || apct.acfEmployment_Type__c  != null )
            employmentStatus = apct.acfEmployment_Type__c;
       
       if(apct.aCf1_Current_employer_Start_Date__c  != ''  || apct.aCf1_Current_employer_Start_Date__c  != null )
            employmentCommenced = ApplicantUtilities.getDateFieldInGMT(apct.aCf1_Current_employer_Start_Date__c);
            isPrimaryApplicant = false;

            contactMethods = new List<ContactMethod>();
                if(apct.applicant_Phone__c  != ''  || apct.applicant_Phone__c  != null )
            contactMethods.add(new ContactMethod(uniqueId, ContactMethodType.MOBILE, apct.applicant_Phone__c));
          if(apct.applicant_Email__c  != ''  || apct.applicant_Email__c  != null )
            contactMethods.add(new ContactMethod(uniqueId, ContactMethodType.EMAIL1, apct.applicant_Email__c));

            validateAndClean();
        }

        public ContactMethod getContactMethod(ContactMethodType method) {
            return null;
        }

        public Account convertToAccount() {
            return convertToAccount(false);
        }

        public Account convertToAccount(Boolean isFromMercury) {
            Account ret = new Account();
            if(isFromMercury) ret.personLeadSource = MercuryUtility.LEAD_SOURCE;
            ret.mercury_People_ID__c = uniqueId;
            ret.firstName = firstName;
            ret.lastName = lastName;
            ret.gender__pc = gender != null ? MercuryStaticValue.GENDER_MAP.get(gender) : null;
            ret.marital_Status__pc = maritalStatus;
            ret.job_Title__pc = jobTitle;
            ret.employment_Status__pc = employmentStatus;
            if(numberOfDependents != null) {
                ret.number_of_Children__pc = numberOfDependents == 5 ? '5+' : '' + numberOfDependents;
            } else {
                ret.number_of_Children__pc = null;
            }
            ret.personEmail = email;
            ret.personMobilePhone = mobile;
            ret.personHomePhone = homePhone;
            ret.employer_Name__pc = employer;
            ret.annual_Income__pc = annualSalary;
            ret.drivers_Lic_No__pc = driversLicenceNumber;
            ret.drivers_Lic_Exp__pc = driversLicenceExpiry != null && driversLicenceExpiry != '' ? Date.valueOf(driversLicenceExpiry) : null;
            ret.birthday__pc = dateOfBirth != null && dateOfBirth != '' ? Datetime.newInstance(Long.valueOf(dateOfBirth)).date() : null;

            //TODO: Address (home)
            return ret;
        }

        public Account mergeToAccount(Account acc) {
            return mergeToAccount(acc, false);
        }

        public Account mergeToAccount(Account acc, Boolean isFromMercury) {
            Account people = this.convertToAccount(isFromMercury);
            String text = 'Account is Merged With Mercury on ' + Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSXXX');
            acc.mercury_People_ID__c = people.mercury_People_ID__c;
            acc.description = acc.description != null ? acc.description + '\n' + text : text;
            return acc;
        }

        //clean raw data
        @testVisible
        private void validateAndClean() {
            firstName = firstName != null && firstName != '' ? firstName : '';
            annualSalary = annualSalary != null ? annualSalary : 0;
            title = title != null && MercuryStaticValue.AVALIABLE_TITLE.contains(title.toLowerCase().capitalize()) ? title.toLowerCase().capitalize() : null;
            gender = gender != null ? gender.left(1) : null;
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            numberOfDependents = numberOfDependents != null ? numberOfDependents : 0;
        }

        @testVisible
        private void init() {
            isDeleted = false;
            annualSalary = 0;
            numberOfDependents = 0;
            doNotMail = false;
            markAsPrivate = false;
            emailBounced = false;
            webAccess = false;
            personDataType = 'Full';
        }

    }

    public class PersonResponse extends Model {
        public Boolean success {get; set;}
        public MercuryModel.People people {get; set;}
    }

    public class Loan extends Model {
        public String uniqueId {get; set;}
        public String company {get; set;}
        public Boolean isDeleted {get; set;}
        public String deletedBy {get; set;}
        public String deletedOn {get; set;}
        public String createdOn {get; set;}
        public String createdBy {get; set;}
        public String isNew {get; set;}
        public String loanName {get; set;}
        public Double amount {get; set;}
        public String lender {get; set;}
        public String lenderNameShort {get; set;}
        public String status {get; set;}
        public String agent {get; set;}
        public String personActing {get; set;}
        public String personResponsible {get; set;}
        public String lenderReference {get; set;}
        public String financeDate {get; set;}
        public String expectedSettlementDate {get; set;}
        public Long confirmedSettlementDate {get; set;}
        public String leadSourceId {get; set;}
        public String leadSourceDisplay {get; set;}
        public Double discount {get; set;}
        public Double existingAmount {get; set;}
        public Double lmi {get; set;}
        public Boolean settlementDateConfirmed {get; set;}
        public String discountType {get; set;}
        public String loanPersonRelationship {get; set;}
        public String transactionType {get; set;}
        public String notePadText {get; set;}
        public String partnerReference {get; set;}
        public String nextGenId {get; set;}
        public String parentId {get; set;}
        public String workspaceUsers {get; set;}
        public String tranxType {get; set;}
        public Long connectiveLodgeId {get; set;}
        public Double peResidualAmount {get; set;}
        public Double peRepaymentAmount {get; set;}
        public Double peEffectiveRate {get; set;}
        public Double peInterestRate {get; set;}
        public Double peBrokerage {get; set;}
        public String assetDescription {get; set;}
        public String nextAction {get; set;}
        public Long loanTerm {get; set;}
        public String metaData {get; set;}
        public String fixedRateExpiry {get; set;}
        public String depositDueDate {get; set;}
        public Boolean vbo {get; set;}
        public String barCodeId {get; set;}
        public String agentName {get; set;}
        public String personActingName {get; set;}
        public String personResponsibleName {get; set;}
        public String defaultPath {get; set;}
        public String partnerName {get; set;}
        public String partnerSharedWithId {get; set;}
        public String partnerSharedWithName {get; set;}
        public String statusLastUpdated {get; set;}
        public String lenderComments {get; set;}
        public String sitRep {get; set;}
        public String campaignId {get; set;}
        public String campaignName {get; set;}
        public Double securityValue {get; set;}
        public String aliApplicationId {get; set;}
        public String metlifeApplicationId {get; set;}
        public String interestOnlyExpiry {get; set;}

        public Loan() {
        }

        public Loan(Opportunity oppo, String branchId) {
            init();
          
            System.debug(oppo);
            if(oppo.Sync_With_Mercury_Success__c  == true  && oppo.Sync_With_Mercury__c  == true )
            {
            uniqueId = oppo.id; 
            }
            else if(oppo.Mercury_Loan_Id__c   != null  && oppo.merc_uniqueId__c  != null  &&  oppo.merc_uniqueId__c ==  oppo.Mercury_Loan_Id__c  )
            {
            uniqueId = oppo.merc_uniqueId__c; 
            }       
            else if(oppo.merc_uniqueId__c  != null)
            {
            uniqueId = oppo.merc_uniqueId__c; 
            }  
            else
            {
               uniqueId = ''; 
              
            }
            // Need to bulkyfy this code.
            List<OpportunityLineItem> listItems = [Select ACF_Bank_Name__c   from OpportunityLineItem where OpportunityId = :  oppo.Id   limit 1 ] ;
            if(listItems.size() > 0 )
            {
                if(listItems[0].ACF_Bank_Name__c  != null  )
                {
                    lender =  listItems[0].ACF_Bank_Name__c  ;
                }
            }
            //loanName = oppo.ID;
            
            String urldFromCS =  ''; 
            List<acfSalesforceURL__c> sfURL = acfSalesforceURL__c.getall().values();
            if(sfURL <> null && sfURL.size() > 0 && sfURL[0].salesforceURL__c <> null )
            {
               urldFromCS = sfURL[0].salesforceURL__c ;
            }
                    
            sitRep = urldFromCS + '/' +Oppo.Id ;
            status  ='Submit to Production';
            loanName = oppo.Name;
            amount = oppo.Amount;
            company = branchId;
            tranxType = oppo.transaction_Type__c;
            if(oppo.currentAssignedBroker__c != null  &&  MercuryStaticValue.brokerMap.get(oppo.currentAssignedBroker__c) != null
            && MercuryStaticValue.brokerMap.get(oppo.currentAssignedBroker__c).caid__c  != null) 
             agent = MercuryStaticValue.brokerMap.get(oppo.currentAssignedBroker__c).caid__c;
             validateAndClean();
        }

        public Loan(Mercury_Opportunity__c merc_oppo) {
            init();
            uniqueId = merc_oppo.merc_uniqueId__c;
            loanName = merc_oppo.merc_transaction_name__c;
            agentName = merc_oppo.merc_loan_writer__c;
            company = merc_oppo.merc_branch__c;
            personActingName = merc_oppo.merc_admin__c;
            personResponsibleName = merc_oppo.merc_supervisor__c;
            status = merc_oppo.merc_current_status__c;
            leadSourceDisplay = merc_oppo.merc_lead_source__c;
            campaignName = merc_oppo.merc_campagin__c;
            partnerReference = merc_oppo.merc_internal_reference__c;
            tranxType = merc_oppo.merc_opportunity_type__c;
            lender = merc_oppo.merc_lender__c;
            amount = merc_oppo.merc_loan_amount__c;
            existingAmount = merc_oppo.merc_existing_amount__c;
            securityValue = merc_oppo.merc_security_value__c;
            lmi = merc_oppo.merc_lmi__c;
            sitRep = merc_oppo.merc_status_notes__c;
            lenderReference = merc_oppo.merc_lender_reference__c;
            nextGenId = merc_oppo.merc_apply_online_id__c;
            financeDate = ((Datetime)merc_oppo.merc_finance_date__c).format('yyyy-MM-dd');
            depositDueDate = ((Datetime)merc_oppo.merc_deposit_due_date__c).format('yyyy-MM-dd');
            confirmedSettlementDate = ((Datetime)merc_oppo.merc_settlement_date__c).getTime();
            // fixedRateExpiry = ((Datetime)merc_oppo.merc_fixed_rate_expiry__c).format('yyyy-MM-dd');
            // interestOnlyExpiry = ((Datetime)merc_oppo.merc_interest_only_expiry__c).format('yyyy-MM-dd');
            metaData = merc_oppo.merc_categories__c;
          //  leadSourceDisplay = MercuryStaticValue.ACF_LEAD_SOURCE_DISPLAY;
          //leadSourceId = MercuryStaticValue.ACF_LEAD_SOURCE_ID;
            validateAndClean();
        }

        public Opportunity convertToOpportunity() {
            return null;
        }

        @testVisible
        private void init() {
            isDeleted = false;
            amount = 0;
            discount = 0;
            existingAmount = 0;
            lmi = 0;
            settlementDateConfirmed = false;
            connectiveLodgeId = 0;
            peResidualAmount = 0;
            peRepaymentAmount = 0;
            peEffectiveRate = 0;
            peInterestRate = 0;
            peBrokerage = 0;
            loanTerm = 0;
            vbo = false;
            securityValue = 0;
        }

        @testVisible
        private void validateAndClean() {
            amount = amount != null ? amount : 0;
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            transactionType = transactionType != null ? transactionType : MercuryStaticValue.DEFAULT_TRANSACTION_TYPE;
          //  leadSourceDisplay = leadSourceDisplay != null ? leadSourceDisplay : MercuryStaticValue.ACF_LEAD_SOURCE_DISPLAY;
          //  leadSourceId = leadSourceId != null ? leadSourceId : MercuryStaticValue.ACF_LEAD_SOURCE_ID;
            agent = agent != '' ? agent : null;
        }

    }

    public class LoanPeople extends Model {
        public String uniqueId;
        public Boolean isDeleted;
        public String loanID;
        public String personID;
        public String relationship;
        public String email;
        public String createdBy;
        public String company;
        public String fullName;

        public LoanPeople(Account acc, Opportunity oppo) {
            init();
            uniqueId = oppo.id + '-' + acc.id;
            loanID = oppo.id;
            personID = acc.id;
            relationship = 'Primary Applicant';
            fullName = oppo.id + '-' + acc.id;

            validateAndClean();
        }

        public LoanPeople(MercuryModel.People peop, MercuryModel.Loan loan) {
            init();
            uniqueId = loan.uniqueId + '-' + peop.uniqueId;
            loanID = loan.uniqueId;
            personID = peop.uniqueId;
            if(peop.isPrimaryApplicant) {
                relationship = 'Primary Applicant';
            } else {
                relationship = 'Applicant';
            }
            fullName = loan.uniqueId + '-' + peop.uniqueId;
            validateAndClean();
        }

        @testVisible
        private void init() {
            isDeleted = false;
            company = MercuryStaticValue.ACF_BRANCH_ID;
            createdBy = MercuryStaticValue.API_USER_ID;
        }

        @testVisible
        private void validateAndClean() {
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
        }
    }

    public class LoanResponse extends Model {
        public Boolean success {get; set;}
        public Integer total {get; set;}
        public List<MercuryModel.Loan> loans {get; set;}
        public List<String> idList {
            get {
                List<String> ret = new List<String>();
                if(loans != null) {
                    for(MercuryModel.Loan l : loans) {
                        ret.add(l.uniqueId);
                    }
                }
                return ret;
            }
        }
    }

    public class URLParams extends Model {
        public Long dc {get; set;}
        public String currentPartnerId {get; set;}
        public String currentGroupId {get; set;}
        public String searchType {get; set;}
        public MercuryModel.Params params {get; set;}
        public Integer page {get; set;}
        public Integer start {get; set;}
        public Integer lmt {get; set;}
        public String loanId;
        public String method;

        public MercuryModel.URLParams() {
            dc               = DateTime.now().getTime();
            currentPartnerId = '';
            currentGroupId   = '';
            searchType       = '';
            params           = null;
            page             = 1;
            start            = 0;
            lmt              = 25;
        }

        public override String toString() {
            String paramString = JSON.serialize(params);
            paramString = paramString.subString(1, paramString.length() - 1);
            String ret = '';
            ret += '_dc=' + dc;
            ret += '&currentPartnerId=' + currentPartnerId;
            ret += '&currentGroupId=' + currentGroupId;
            ret += '&searchType=' + searchType;
            ret += '&params=' + EncodingUtil.urlEncode('{' + paramString + '}', MercuryStaticValue.ENCODING_SCHEME);
            ret += '&page=' + page;
            ret += '&start=' + start;
            ret += '&limit=' + lmt;
            if (loanId != null) {
                ret += '&loanId=' + loanId;   
            }
            if (method != null) {
                ret += '&method=' + method;   
            }
            return ret;
        }
    }

    public class Params extends Model {
        public String transactionType {get; set;}
        public String transactionTypeRaw {get; set;}
        public String loanWriter {get; set;}
        public String loanWriterId {get; set;}
        public Long dateFrom {get; set;}
        public Long dateTo {get; set;}
        public String groupBy {get; set;}
        public String groupByComment {get; set;}
        public String targetStatus {get; set;}
        public Boolean ignoreDateRange {get; set;}
        public String leadSourceId {get; set;}
        public String leadSourceName {get; set;}
        public String loanCategory {get; set;}
        public String dateSearchType {get; set;}
        public String reportDescription {get; set;}

        public MercuryModel.Params() {
            transactionType    = '';
            transactionTypeRaw = '';
            loanWriter         = '';
            loanWriterId       = '';
            dateFrom           = DateTime.now().getTime();
            dateTo             = DateTime.now().getTime();
            groupBy            = '';
            groupByComment     = '';
            targetStatus       = '';
            ignoreDateRange    = false;
            leadSourceId       = '';
            leadSourceName     = '';
            loanCategory       = '';
            dateSearchType     = '';
            reportDescription  = '';
        }
    }

    public enum ContactMethodType {
        HOME, MOBILE, BUSINESS, BUSINESS_FAX, EMAIL1, EMAIL2, EMAIL3
    }

    public class ContactMethod extends Model {
        public String personID;
        public String contactMethod;
        public String content;

        public ContactMethod(String personId, contactMethodType cmt, String content) {
            this.personID = personId;
            this.content = content;
            if(cmt == ContactMethodType.HOME) {
                contactMethod = 'Home';
            } else if(cmt == ContactMethodType.MOBILE) {
                contactMethod = 'Mobile';
            } else if(cmt == ContactMethodType.BUSINESS) {
                contactMethod = 'Business';
            } else if(cmt == ContactMethodType.BUSINESS_FAX) {
                contactMethod = 'Business Fax';
            } else if(cmt == ContactMethodType.EMAIL1) {
                contactMethod = 'Email 1';
            } else if(cmt == ContactMethodType.EMAIL2) {
                contactMethod = 'Email 2';
            } else if(cmt == ContactMethodType.EMAIL3) {
                contactMethod = 'Email 3';
            }
        }
    }

    public class LoanPeopleResponse {
        public Boolean success;
        public Integer total;
        public List<MercuryModel.LoanPeople> loanPeople;
    }

    public class Income extends Model {
        public String uniqueId;
        public Boolean isDeleted;
        public Decimal amount;
        public String comment;
        public String company;
        public String createdBy;
        public String personId;
        public String type;
        public String frequency;
        public Integer sortKey;

        public Income(Income_And_Expense__c iae, MercuryModel.People people, String branchId) {
            init();

            uniqueId = iae.id;
            amount = iae.amount__c;
            personId = people.uniqueId;
           
          
           
           if(iae.Income_And_Expense_Detail__c  != null)
           {
               if(iae.Income_And_Expense_Detail__c  == 'Liability Credit Card')
               {
                    type = 'Credit Card';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability HECS')
               {
                    type = 'Education';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Hire Purchase')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Lease')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Line of Credit')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Loan as Guarantor')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Maintenance')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Mortgage Loan')
               {
                    type = 'Home Loan';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Other')
               {
                    type = 'Other';
               }
               
               
               if(iae.Income_And_Expense_Detail__c  == 'Liability Other Loan')
               {
                    type = 'Car Loan';
               }

               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Casual/Temporary Employees')
               {
                    type = 'Salary';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Bonus Income')
               {
                    type = 'Bonus';
               }
               
                 if(iae.Income_And_Expense_Detail__c  == 'PAYG - Base Salary')
               {
                    type = 'Salary';
               }
               
                 if(iae.Income_And_Expense_Detail__c  == 'PAYG - Allowances (taxed)')
               {
                    type = 'Salary';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'PAYG - Allowances (not-taxed)')
               {
                    type = 'Salary';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Other Expenses')
               {
                    type = 'Other';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Mobile, Internet and TV')
               {
                    type = 'Living Expenses';
               }
               
                 if(iae.Income_And_Expense_Detail__c  == 'Maintenance / Child Support')
               {
                    type = 'Maintenance';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Living Expenses: Basic Housing and Property Expenses')
               {
                    type = 'Living Expenses';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Liability Term Loan')
               {
                    type = 'Other';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'iability Store Card')
               {
                    type = 'Credit Card';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Insurance Premiums')
               {
                    type = 'Insurance';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Foreign Income')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Family Tax Benefit A and B')
               {
                    type = 'Family Allowance';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Childcare and School Fees')
               {
                    type = 'Education';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Disability Support Pension')
               {
                    type = 'Pension';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Basic Living Expenses')
               {
                    type = 'Living Expenses';
               }
               
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Commission Income')
               {
                    type = 'Salary';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Contractor')
               {
                    type = 'Business Income';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Matenity Leave')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Non-Volntary Deductions (Pre-tax)')
               {
                    type = 'Other';
               }
               
               if(iae.Income_And_Expense_Detail__c  == 'Rental Income')
               {
                    type = 'Rental';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Second Job')
               {
                    type = 'Salary';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Salary Sacrifice')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Overtime Income')
               {
                    type = 'Overtime';
               }
               
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Overtime Income')
               {
                    type = 'Overtime';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Travel and Transport')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Super / Annuity / Pension')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Self Employed - Business Income')
               {
                    type = 'Business Income';

               }
               
           }
           frequency = iae.frequency__c == 'Yearly' ? 'Annual' : iae.frequency__c;
            company = branchId;

            validateAndClean();
        }

        @testVisible
        private void init() {
            isDeleted = false;
            company = MercuryStaticValue.ACF_BRANCH_ID;
            createdBy = MercuryStaticValue.API_USER_ID;
            sortKey = 0;
        }

        @testVisible
        private void validateAndClean() {
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            amount = amount != null ? amount : 0;
        }
    }

    public class Expense extends Model {
        public String uniqueId;
        public Boolean isDeleted;
        public Decimal amount;
        public String comment;
        public String company;
        public String createdBy;
        public String personId;
        public String type;
        public String frequency;
        public Integer sortKey;
        public Decimal balance;
        public Decimal creditLimit;

        public Expense(Income_And_Expense__c iae, MercuryModel.People people, String branchId) {
            init();

            uniqueId = iae.id;
            amount = iae.amount__c;
            personId = people.uniqueId;
           if(iae.Income_And_Expense_Detail__c  != null)
           {
               if(iae.Income_And_Expense_Detail__c  == 'Liability Credit Card')
               {
                    type = 'Credit Card';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability HECS')
               {
                    type = 'Education';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Hire Purchase')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Lease')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Line of Credit')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Loan as Guarantor')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Maintenance')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Mortgage Loan')
               {
                    type = 'Home Loan';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Liability Other')
               {
                    type = 'Other';
               }
               
               
               if(iae.Income_And_Expense_Detail__c  == 'Liability Other Loan')
               {
                    type = 'Car Loan';
               }

               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Casual/Temporary Employees')
               {
                    type = 'Salary';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Bonus Income')
               {
                    type = 'Bonus';
               }
               
                 if(iae.Income_And_Expense_Detail__c  == 'PAYG - Base Salary')
               {
                    type = 'Salary';
               }
               
                 if(iae.Income_And_Expense_Detail__c  == 'PAYG - Allowances (taxed)')
               {
                    type = 'Salary';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'PAYG - Allowances (not-taxed)')
               {
                    type = 'Salary';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Other Expenses')
               {
                    type = 'Other';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Mobile, Internet and TV')
               {
                    type = 'Living Expenses';
               }
               
                 if(iae.Income_And_Expense_Detail__c  == 'Maintenance / Child Support')
               {
                    type = 'Maintenance';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Living Expenses: Basic Housing and Property Expenses')
               {
                    type = 'Living Expenses';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'Liability Term Loan')
               {
                    type = 'Other';
               }
                 if(iae.Income_And_Expense_Detail__c  == 'iability Store Card')
               {
                    type = 'Credit Card';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Insurance Premiums')
               {
                    type = 'Insurance';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Foreign Income')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Family Tax Benefit A and B')
               {
                    type = 'Family Allowance';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Childcare and School Fees')
               {
                    type = 'Education';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Disability Support Pension')
               {
                    type = 'Pension';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Basic Living Expenses')
               {
                    type = 'Living Expenses';
               }
               
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Commission Income')
               {
                    type = 'Salary';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Contractor')
               {
                    type = 'Business Income';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Matenity Leave')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Non-Volntary Deductions (Pre-tax)')
               {
                    type = 'Other';
               }
               
               if(iae.Income_And_Expense_Detail__c  == 'Rental Income')
               {
                    type = 'Rental';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Second Job')
               {
                    type = 'Salary';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Salary Sacrifice')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Overtime Income')
               {
                    type = 'Overtime';
               }
               
               if(iae.Income_And_Expense_Detail__c  == 'PAYG - Overtime Income')
               {
                    type = 'Overtime';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Travel and Transport')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Super / Annuity / Pension')
               {
                    type = 'Other';
               }
               if(iae.Income_And_Expense_Detail__c  == 'Self Employed - Business Income')
               {
                    type = 'Business Income';

               }
               
           }
            frequency = iae.frequency__c == 'Yearly' ? 'Annual' : iae.frequency__c;
            creditLimit = iae.credit_Limit__c;
            balance = iae.balance__c;
            company = branchId;

            validateAndClean();
        }

        @testVisible
        private void init() {
            isDeleted = false;
            company = MercuryStaticValue.ACF_BRANCH_ID;
            createdBy = MercuryStaticValue.API_USER_ID;
            sortKey = 0;
        }

        @testVisible
        private void validateAndClean() {
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            creditLimit = creditLimit != null ? creditLimit : 0;
            balance = balance != null ? balance : 0;
            amount = amount != null ? amount : 0;
        }
    }

    public class Address extends Model {
        public String uniqueId;
        public Boolean isDeleted;
        public String type;
        public String streetName;
        public String streetNumber;
        public String streetType;
        public String city;
        public String state;
        public String postcode;
        public String country;
        public String unitNumber;
        public String buildingName;
        public String floorNumber;
        public Boolean isCorrespondenceAddress;
        //public String fromDate;
        //public String toDate;
        public String addressBlock;
        public String housingSituation;
        public String format;
        public String personName;
        public String company;
        public String createdBy;
        public String parentID;
        public String parentType;
        public String streetSearch;
        public String addrGeoLatitude;
        public String addrGeoLongitude;

        public Address() {
        }

        public Address(Account acc, String branchId) {
            init();

            uniqueId = acc.id;
            parentType = 'person';
            parentID = acc.mercury_People_ID__c != null && acc.mercury_People_ID__c != '' ? acc.mercury_People_ID__c : acc.id;
            //TODO: fix mapping here currently we put everything in stree name because we can't spearate the address
            addressBlock = acc.acfWhat_is_your_postcode__pc;
            streetSearch = acc.acfWhat_is_your_postcode__pc;
            streetName = acc.acfWhat_is_your_postcode__pc;
            company = branchId;

            validateAndClean();
        }
        
        
        public Address(Click_Applicant__c  aplicant , String branchId) {
            init();

            uniqueId = aplicant.id;
           parentType = 'person';
           parentID = aplicant.id;
            //TODO: fix mapping here currently we put everything in stree name because we can't spearate the address
            
            System.debug(aplicant .Address__c );
            if(aplicant .Address__c  != null)
            addressBlock = aplicant .Address__c;
                if(aplicant .Address__c  != null)
            streetSearch = aplicant .Address__c;
               if(aplicant .Address__c  != null)
           streetName = aplicant .Address__c;
           
           company = branchId;

            validateAndClean();
        }

        @testVisible
        private void init() {
            isDeleted = false;
            company = MercuryStaticValue.ACF_BRANCH_ID;
            createdBy = MercuryStaticValue.API_USER_ID;
            isCorrespondenceAddress = false;
        }

        @testVisible
        private void validateAndClean() {
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            addrGeoLatitude = addrGeoLatitude != null ? addrGeoLatitude : '0.0';
            addrGeoLongitude = addrGeoLongitude != null ? addrGeoLongitude : '0.0';
        }
    }

    public class AddressResponse extends Model {
        public Boolean success;
        public List<Address> addressList;
    }

    public class RealEstate extends Model {
        public String uniqueId;
        public Boolean isDeleted;
        public String createdBy;
        public String company;
        public String parentID;
        public String parentType;
        public String type;
        public String streetName;
        public String streetNumber;
        public String streetType;
        public String city;
        public String state;
        public String postcode;
        public String country;
        public String unitNumber;
        public String buildingName;
        public String floorNumber;
        public Boolean isCorrespondenceAddress;
        // public String fromDate;
        // public String toDate;
        public String addressBlock;
        public String format;
        public String housingSituation;
        public Boolean requiresConfirmation;
        // public String poBoxNumber;
        public String poBoxType;
        // public String personName;
        public String addrGeoLatitude;
        public String addrGeoLongitude;

        public RealEstate(Asset_And_Liability__c aal, String branchId) {
            init();

            company = branchId;
            parentID = aal.id;
            streetName = aal.street_Name__c;
            streetNumber = aal.street_Number__c;
            streetType = aal.street_Type__c;
            city = aal.city__c;
            state = aal.state__c;
            postcode = aal.postcode__c != null ? String.valueOf((Integer)aal.postcode__c) : null;
            country = aal.country__c;

            validateAndClean();
        }

        @testVisible
        private void init() {
            isDeleted = false;
            company = MercuryStaticValue.ACF_BRANCH_ID;
            parentType = 'asset';
            isCorrespondenceAddress = false;
            format = 'standard';
            requiresConfirmation = false;
            createdBy = MercuryStaticValue.API_USER_ID;
        }

        @testVisible
        private void validateAndClean() {
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            addrGeoLatitude = addrGeoLatitude != null ? addrGeoLatitude : '0.0';
            addrGeoLongitude = addrGeoLongitude != null ? addrGeoLongitude : '0.0';
        }

    }

    public class Asset extends Model {
        public String uniqueId;
        public Boolean isDeleted;
        public String createdBy;
        public String company;
        public String parentType;
        public String parentId;
        public String name;
        public String type;
        public Decimal value;
        public String valueBasis;
        public String details;
        public String institution;
        public String accountName;
        public String accountNumber;
        public String accountBSB;
        public Boolean realEstateUseAsSecurity;
        public String realEstatePurpose;
        public String realEstateZoning;
        public RealEstate realEstateObject;
        public Boolean realEstateToBePurchased;
        public Decimal realEstateRentalIncome;
        public String realEstateRentalIncomeFrequency;
        public Boolean realEstateRentalEvidenceOfTenancy;
        public String existingMortgageCreditor;
        public Decimal existingMortgageBalance;
        public Integer existingMortgageRepayment;
        public String existingMortgageRepaymentFrequency;
        public Boolean existingMortgageRepaymentClearing;
        public String motorVehicleType;
        public String motorVehiceYear;
        public String motorVehicleMake;

        public Asset(Asset_And_Liability__c aal, MercuryModel.Loan loan, String branchId) {
            init();

            uniqueId = aal.id;
            company = branchId;
            parentId = loan.uniqueId;
            if(AssetAndLiabilityRecordType.getInstance().rtMapById.get(aal.recordTypeId) != null)
            name = AssetAndLiabilityRecordType.getInstance().rtMapById.get(aal.recordTypeId).getName().replaceFirst('Asset ', '');
            if(name  != null )
            type = name.replace(' ', '');
            value = aal.value__c;
            valueBasis = aal.value_Basis__c;
            institution = aal.institution__c;
            accountName = aal.account_Name__c;
            accountNumber = aal.account_Number__c;
            accountBSB = aal.bsb__c;
            realEstateUseAsSecurity = aal.used_as_Security__c;
            realEstatePurpose = aal.primary_Purpose__c;
            realEstateZoning = aal.zoning__c;
            realEstateObject = new RealEstate(aal, branchId);
            realEstateToBePurchased = aal.to_Be_Purchased__c;
            realEstateRentalIncome = aal.gross_Amount__c;
            realEstateRentalIncomeFrequency = MercuryStaticValue.MERC_REPAYMENT_FREQUENCY_MAP.get(aal.repayment_Frequency__c);
            realEstateRentalEvidenceOfTenancy = aal.evidence_of_Tenancy__c;
            existingMortgageCreditor = aal.creditor__c;
            existingMortgageBalance = aal.current_Balance__c;
            existingMortgageRepayment = (Integer) aal.repayments__c;
            existingMortgageRepaymentFrequency = MercuryStaticValue.MERC_REPAYMENT_FREQUENCY_MAP.get(aal.repayment_Frequency__c);
            existingMortgageRepaymentClearing = aal.clearing_From_This_Loan__c;
            motorVehicleType = aal.vehicle_Type__c;
            motorVehiceYear = aal.vehicle_Year__c;
            motorVehicleMake = aal.vehicle_Make__c;
            details = aal.vehicle_Make__c;

            validateAndClean();
        }

        @testVisible
        private void init() {
            isDeleted = false;
            company = MercuryStaticValue.ACF_BRANCH_ID;
            parentType = 'loan';
            createdBy = MercuryStaticValue.API_USER_ID;
        }

        @testVisible
        private void validateAndClean() {
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            value = value != null ? value : 0;
            realEstateRentalIncome = realEstateRentalIncome != null ? realEstateRentalIncome : 0;
            existingMortgageBalance = existingMortgageBalance != null ? existingMortgageBalance : 0;
            existingMortgageRepayment = existingMortgageRepayment != null ? existingMortgageRepayment : 0;
        }
    }

    public class Liability extends Model {
        public String uniqueId;
        public String company;
        public Boolean isDeleted;
        public String createdBy;
        public String parentType;
        public String parentId;
        public String name;
        public String type;
        public Decimal value;
        public String details;
        public Decimal param_rr_limit;
        public String institution;
        public String accountName;
        public String accountBSB;
        public String accountNumber;
        public Decimal accountRepayment;
        public String accountRepaymentFrequency;
        public String creditCardType;
        public Boolean accountClearingFromLoan;

        public Liability(Asset_And_Liability__c aal, MercuryModel.Loan loan, String branchId) {
            init();

            uniqueId = aal.id;
            company = branchId;
            parentId = loan.uniqueId;
             if(AssetAndLiabilityRecordType.getInstance().rtMapById.get(aal.recordTypeId) != null)
            name = AssetAndLiabilityRecordType.getInstance().rtMapById.get(aal.recordTypeId).getName().replaceFirst('Liability ', '');
            if(name  != null )
            type = name.replace(' ', '');
            value = aal.current_Balance__c;
            param_rr_limit = aal.limit__c;
            institution = aal.institution__c;
            accountName = aal.account_Name__c;
            accountNumber = aal.account_Number__c;
            accountBSB = aal.bsb__c;
            accountRepayment = aal.repayments__c;
            accountRepaymentFrequency = MercuryStaticValue.MERC_REPAYMENT_FREQUENCY_MAP.get(aal.repayment_Frequency__c);
            creditCardType = aal.credit_Card_Type__c;
            accountClearingFromLoan = aal.clearing_From_This_Loan__c;

            validateAndClean();
        }

        @testVisible
        private void init() {
            isDeleted = false;
            company = MercuryStaticValue.ACF_BRANCH_ID;
            parentType = 'loan';
            createdBy = MercuryStaticValue.API_USER_ID;
        }

        @testVisible
        private void validateAndClean() {
            company = company != null && company != '' ? company : MercuryStaticValue.ACF_BRANCH_ID;
            value = value != null ? value : 0;
            param_rr_limit = param_rr_limit != null ? param_rr_limit : 0;
            accountRepayment = accountRepayment != null ? accountRepayment : 0;
        }
    }

    public class LodgeLoanResponse extends Model {
        public Boolean success;
        public String result;
    }
    
    

}