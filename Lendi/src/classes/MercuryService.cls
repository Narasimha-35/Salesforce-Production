global class MercuryService {
    public static MercuryModel.LoanResponse getLoansFromMercury(String sfObjectName, String branchId, String searchType, MercuryModel.Params params) {
        MercuryModel.URLParams p = new MercuryModel.URLParams();
        p.currentPartnerId = branchId;
        p.searchType = searchType;
        p.params = params;
        HttpResponse res = MercuryApiUtilities.sendGetRequest(sfObjectName, p);
        System.debug(res.getBody());
        MercuryModel.LoanResponse lr = (MercuryModel.LoanResponse) JSON.deserialize(res.getBody(), MercuryModel.LoanResponse.class);
        return lr;
    }
    public static void syncWithMercury(String oppoId, String accountId){
        String tempMessage = '';
        String branchId = MercuryUtility.getBrokerBranch(oppoId);
        Id oId = oppoId;
        Id aId = accountId;
        Opportunity oppo = null;
        Account account = null;
        List<Utilities.CalloutResponseException> exceptions = new List<Utilities.CalloutResponseException>();
        //Create Oppo
        System.debug(oppoId);
        System.debug(LoggingLevel.DEBUG, '[MercuryService] Check DML Limit: ' + Limits.getDMLRows());
        try {
            oppo = MercuryApiUtilities.createOppoInMercury(oppoId, branchId);
            System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Opportunity Success...');
            tempMessage  = tempMessage+ LoggingLevel.INFO +'[MercuryService.syncWithMercury] Sync Opportunity Success...n';
            } catch (Utilities.CalloutResponseException e) {
            System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Opportunity Error: ' + e.getMessage());
            tempMessage  = tempMessage+ LoggingLevel.INFO + '[MercuryService.syncWithMercury] Sync Opportunity Error: ' + e.getMessage();
            exceptions.add(e);
        }
        if(oppo  != null)
        {
            //Create People
            System.debug(accountId);
            System.debug(LoggingLevel.DEBUG, '[MercuryService] Check DML Limit: ' + Limits.getDMLRows());
            try {
                account = MercuryApiUtilities.createPeopleInMercury(accountId, branchId);
                System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Account Success...');
                } catch (Utilities.CalloutResponseException e) {
                System.debug(LoggingLevel.INFO, '[MercuryService.syncWithMercury] Sync Account Error: ' + e.getMessage());
                exceptions.add(e);
            }
            //Create Connection between Oppo and People
            try{
                String oppoAndaccountId = oId + '-' + aId;
                System.debug(LoggingLevel.DEBUG, '[MercuryService] Check DML Limit: ' + Limits.getDMLRows());
                MercuryApiUtilities.createLoanPeopleInMercury(oppoAndaccountId, oId, aId);
            }
            catch (Utilities.CalloutResponseException e) {
            }
            //------------------
            //String branchId = MercuryUtility.getBrokerBranch(oppo.id);
            List<Asset_And_Liability__c> aalList = new List<Asset_And_Liability__c> ();
            ApplicantSelector apts = new ApplicantSelector();
            List<Click_Applicant__c> applicants = apts.getByAccount(account);
            IncomeAndExpenseSelector iaeSelector = new IncomeAndExpenseSelector();
            AssetAndLiabilitySelector aalSelecotr = new AssetAndLiabilitySelector();
            if(oppo  != null)
            aalList = aalSelecotr.getByOpportunit(oppo);
            System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create Address for Account: ' + account.id);
            upsertAddress(account, branchId);
            List<Income_And_Expense__c>   updateIE = new List<Income_And_Expense__c> ();
            MercuryModel.Loan loan = new MercuryModel.Loan(oppo, branchId);
            if(loan.uniqueId == '')
            {
                loan.uniqueId = oppo.ID;
            }
            for(Click_Applicant__c applicant : applicants) {
                MercuryModel.People people   = new MercuryModel.People(applicant, branchId);
                System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create applicant: ' + people.uniqueId);
                createPeople(people);
                System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create loan people: ' + loan.uniqueId + '-' +  people.uniqueId);
                createLoanPeople(people, loan);
                List<Income_And_Expense__c> iaeList = iaeSelector.getByApplicantId(applicant.id);
                System.debug(LoggingLevel.DEBUG, '[MercuryService.updateApplication] Related Income and Expense list: ' + (new Map<Id, Income_And_Expense__c>(iaeList)).keySet());
                for(Income_And_Expense__c iae : iaeList) {
                    System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create Income and Expense id: ' + iae.id);
                    if(iae.Synk_with_Mercury__c   == false){
                        createIncomeAndExpense(iae, people, branchId);
                        iae.Synk_with_Mercury__c   = true ;
                        updateIE.add(iae);
                    }
                }
            }
            List<Asset_And_Liability__c>   assetList  = new List<Asset_And_Liability__c> ();
            for(Asset_And_Liability__c aal : aalList) {
                System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create A&L id: ' + aal.id);
                if(aal.Synk_with_Mercury__c   == false){
                    createAssetAndLiability(aal, loan, branchId);
                    aal.Synk_with_Mercury__c =  true ;
                    assetList.add(aal);
                }
                else{
                    updateAssetAndLiability(aal, loan, branchId);
                }
            }
            //------------------
            oppo.Sync_With_Mercury_Success__c = true;
            oppo.Sync_With_Mercury__c = true;
            oppo.mercury_error__C =  tempMessage ;
            oppo.merc_uniqueId__c  = oppo.Id;
            oppo.Mercury_Loan_Id__c     = oppo.Id;
           
            if(oppo != null) update oppo;
            
            if(account != null) update account;
            if(assetList.size() > 0)
            {
                update assetList;
            }
            if(updateIE.size() > 0)
            update updateIE ;
        }
    }
    
     public static Set<String> getSyncBackLoanId(Date dateFrom, Date dateTo) {
        MercuryModel.LoanResponse res = null;
        Set<String> ids = new Set<String>();
        //if(method == 1) {
        //    for(String s : MercuryStaticValue.MERC_SYNC_TARGET_STATUS) {
            MercuryStaticValue.param1.targetStatus = 'Submit to Production';
            MercuryStaticValue.param1.dateTo = Utilities.getGMTTime((DateTime) dateTo).getTime();
            MercuryStaticValue.param1.dateFrom = Utilities.getGMTTime((DateTime) dateFrom).getTime();
            res = getLoansFromMercury('Opportunity', 'all', 'businessStats', MercuryStaticValue.param1);
            System.debug(LoggingLevel.INFO, '[MercuryService] loans to update: ' + res);
            ids.addAll(res.idList);
        //    }
        /*} else if(method == 2) {
            res = getLoansFromMercury('Opportunity', 'all', 'businessStats', MercuryStaticValue.param2);
            System.debug(LoggingLevel.INFO, '[MercuryService] loans to update: ' + res);
            ids.addAll(res.idList);
        }*/
        return ids;
    }
    
    public static Set<String> getSyncBackLoanId(Integer method) {
        MercuryModel.LoanResponse res = null;
        Set<String> ids = new Set<String>();
        if(method == 1) {
            for(String s : MercuryStaticValue.MERC_SYNC_TARGET_STATUS) {
                MercuryStaticValue.param1.targetStatus = s;
                res = getLoansFromMercury('Opportunity', 'all', 'businessStats', MercuryStaticValue.param1);
                System.debug(LoggingLevel.INFO, '[MercuryService] loans to update: ' + res);
                ids.addAll(res.idList);
            }
        } else if(method == 2) {
            res = getLoansFromMercury('Opportunity', 'all', 'businessStats', MercuryStaticValue.param2);
            System.debug(LoggingLevel.INFO, '[MercuryService] loans to update: ' + res);
            ids.addAll(res.idList);
        }
        return ids;
    }
    public static void syncBackLoan(Integer method) {
        AsyncRequestService.addSyncBackRequest('Opportunity', getSyncBackLoanId(method));
    }
    public static MercuryModel.Loan getLoan(String loanId) {
        HttpResponse res = MercuryApiUtilities.sendGetRequest('Opportunity', loanId);
        MercuryModel.LoanResponse lr = (MercuryModel.LoanResponse) JSON.deserialize(res.getBody(), MercuryModel.LoanResponse.class);
        if(lr.success) return lr.loans[0];
        return null;
    }
    public static List<MercuryModel.LoanPeople> getLoanPeole(String loanId) {
        MercuryModel.URLParams params = new MercuryModel.URLParams();
        params.loanId = loanId;
        params.method = 'getLoanPeople';
        HttpResponse res = MercuryApiUtilities.sendGetRequest('LoanPeople', params);
        MercuryModel.LoanPeopleResponse lr = (MercuryModel.LoanPeopleResponse) JSON.deserialize(res.getBody(), MercuryModel.LoanPeopleResponse.class);
        if(lr.success) return lr.loanPeople;
        return null;
    }
    public static MercuryModel.People getPeople(String peopleId) {
        HttpResponse res = MercuryApiUtilities.sendGetRequest('Account', peopleId);
        MercuryModel.PersonResponse pr = (MercuryModel.PersonResponse) JSON.deserialize(res.getBody(), MercuryModel.PersonResponse.class);
        if(pr.success) return pr.people;
        return null;
    }
    public static void startCleanMercuryOpportunityBatch() {
        MercuryOpportunityCleanUpBatch b = new MercuryOpportunityCleanUpBatch();
        Database.executeBatch(b, MercuryStaticValue.MERC_CLEAN_BATCH_SIZE);
    }
    webservice static void cleanMercuryOpportunity(String input) {
        MercuryService.startCleanMercuryOpportunityBatch();
    }
    webservice static void applyOnline(Id opportunityId) {
        insert AsyncRequestService.createApplyOnlineRequst(opportunityId);
    }
    //Only update the loan in Mercury
    public static void updateApplication(Opportunity oppo) {
        String branchId = MercuryUtility.getBrokerBranch(oppo.id);
        AccountSelector accSelector = new AccountSelector();
        Account acc = accSelector.getById(oppo.accountId);
        ApplicantSelector apts = new ApplicantSelector();
        List<Click_Applicant__c> applicants = apts.getByAccount(acc);
        IncomeAndExpenseSelector iaeSelector = new IncomeAndExpenseSelector();
        AssetAndLiabilitySelector aalSelecotr = new AssetAndLiabilitySelector();
        List<Asset_And_Liability__c> aalList = aalSelecotr.getByOpportunit(oppo);
        System.debug(LoggingLevel.DEBUG, '[MercuryService.updateApplication] Related A&L list: ' + (new Map<Id, Asset_And_Liability__c>(aalList)).keySet());
        //update loan details
        MercuryModel.Loan loan = new MercuryModel.Loan(oppo, branchId);
        System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to update loan id: ' + loan.uniqueId);
        if(Loan.uniqueId  != ''){
            updateLoan(loan  , oppo );
            for(Click_Applicant__c applicant : applicants) {
                MercuryModel.People people;
                if('1' == applicant.click_Applicant_Number__c) {
                    people = new MercuryModel.People(acc, branchId);
                    System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to update primary applicant: ' + people.uniqueId);
                    updatePeople(people );
                    } else {
                    people = new MercuryModel.People(applicant, branchId);
                    System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create applicant: ' + people.uniqueId);
                    createPeople(people);
                    System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create loan people: ' + loan.uniqueId + '-' +  people.uniqueId);
                    createLoanPeople(people, loan);
                }
                List<Income_And_Expense__c> iaeList = iaeSelector.getByApplicantId(applicant.id);
                System.debug(LoggingLevel.DEBUG, '[MercuryService.updateApplication] Related Income and Expense list: ' + (new Map<Id, Income_And_Expense__c>(iaeList)).keySet());
                for(Income_And_Expense__c iae : iaeList) {
                    System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create Income and Expense id: ' + iae.id);
                    if(iae.Synk_with_Mercury__c   == false){
                        createIncomeAndExpense(iae, people, branchId);
                    }
                    else{
                        updateIncomeAndExpense(iae, people, branchId);
                    }
                }
            }
            System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create Address for Account: ' + acc.id);
            upsertAddress(acc, branchId);
            List<Asset_And_Liability__c>   assetList  = new List<Asset_And_Liability__c> ();
            for(Asset_And_Liability__c aal : aalList) {
                System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to create A&L id: ' + aal.id);
                if(aal.Synk_with_Mercury__c   == false){
                    createAssetAndLiability(aal, loan, branchId);
                    aal.Synk_with_Mercury__c =  true ;
                    assetList.add(aal);
                }
                else{
                    updateAssetAndLiability(aal, loan, branchId);
                }
            }
            //upsert applicant details
            oppo.merc_uniqueId__c       = oppo.Id;
            oppo.Mercury_Loan_Id__c     = oppo.Id;
            update oppo ;
            if(assetList.size() > 0){
                update assetList;
            }
        }
        else{
            Loan.uniqueId =  oppo.ID;
            //  OpportunityService.syncOppoToMercury( oppo.ID);
            syncWithMercury(oppo.ID  , oppo.AccountID);
        }
        //TODO: update apply online
        // loan.nextGenId = getApplyOnlineId(loan, branchId);
        // System.debug(LoggingLevel.INFO, '[MercuryService.updateApplication] start to update loan id: ' + loan.uniqueId);
        // updateLoan(loan);
    }
    public static Boolean createLoan(MercuryModel.Loan loan) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(loan), 'createLoan ' + loan.uniqueId);
    }
    public static Boolean updateLoan(MercuryModel.Loan loan) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(loan), 'updateLoan ' + loan.uniqueId);
    }
    public static Boolean updateLoan(MercuryModel.Loan loan , Opportunity opp) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(loan), 'updateLoan ' + loan.uniqueId ,  opp);
    }
    public static Boolean createPeople(MercuryModel.People people) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(people), 'createPeople ' + people.uniqueId);
    }
    public static Boolean updatePeople(MercuryModel.People people) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(people), 'updatePeople ' + people.uniqueId);
    }
    public static Boolean createLoanPeople(MercuryModel.People people, MercuryModel.Loan loan) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.createLoanPeopleInMercury(people, loan), 'createLoanPeople ' + loan.uniqueId + '-' +  people.uniqueId);
    }
    public static Boolean createAsset(MercuryModel.Asset asset) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(asset), 'createAsset ' + asset.uniqueId);
    }
    public static Boolean updateAsset(MercuryModel.Asset asset) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(asset), 'updateAsset ' + asset.uniqueId);
    }
    public static Boolean updateLiability(MercuryModel.Liability liability) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(liability), 'updateLiability ' + liability.uniqueId);
    }
    public static Boolean createLiability(MercuryModel.Liability liability) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(liability), 'createLiability ' + liability.uniqueId);
    }
    public static Boolean createIncome(MercuryModel.Income income) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(income), 'createIncome ' + income.uniqueId);
    }
    public static Boolean updateIncome(MercuryModel.Income income) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(income), 'updateIncome ' + income.uniqueId);
    }
    public static Boolean createExpense(MercuryModel.Expense expense) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(expense), 'createExpense ' + expense.uniqueId);
    }
    public static Boolean updateExpense(MercuryModel.Expense expense) {
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.updateMercuryRecord(expense), 'updateExpense ' + expense.uniqueId);
    }
    public static Boolean upsertAddress(Account acc, String branchId) {
        MercuryModel.Address addr = new MercuryModel.Address(acc, branchId);
        return MercuryApiUtilities.handleResponse(MercuryApiUtilities.insertMercuryRecord(addr), 'upsertAddress ' + acc.id);
    }
    public static String getApplyOnlineId(MercuryModel.Loan loan, String branchId) {
        MercuryModel.LodgeLoanResponse response = (MercuryModel.LodgeLoanResponse) JSON.deserialize(MercuryApiUtilities.lodgeLoan(loan, branchId).res.getBody(), MercuryModel.LodgeLoanResponse.class);
        return response.result;
    }
    public static List<MercuryModel.Address> getAddress(MercuryModel.People people) {
        HttpRequestResponse rr = MercuryApiUtilities.getAddress(people);
        return ((MercuryModel.AddressResponse) JSON.deserialize(rr.res.getBody(), MercuryModel.AddressResponse.class)).addressList;
    }
    public static Boolean createIncomeAndExpense(Income_And_Expense__c iae, MercuryModel.People people, String branchId) {
        Boolean ret = false;
        if(iae.recordTypeId == IncomeRecordType.getInstance().id) {
            ret = createIncome(new MercuryModel.Income(iae, people, branchId));
            } else if(iae.recordTypeId == ExpenseRecordType.getInstance().id) {
            ret = createExpense(new MercuryModel.Expense(iae, people, branchId));
        }
        return ret;
    }
    public static Boolean updateIncomeAndExpense(Income_And_Expense__c iae, MercuryModel.People people, String branchId) {
        Boolean ret = false;
        if(iae.recordTypeId == IncomeRecordType.getInstance().id) {
            ret = updateIncome(new MercuryModel.Income(iae, people, branchId));
            } else if(iae.recordTypeId == ExpenseRecordType.getInstance().id) {
            ret = updateExpense(new MercuryModel.Expense(iae, people, branchId));
        }
        return ret;
    }
    public static Boolean createAssetAndLiability(Asset_And_Liability__c aal, MercuryModel.Loan loan, String branchId) {
        Boolean ret = false;
        if(AssetAndLiabilityRecordType.getInstance().rtMapById.get(aal.recordTypeId).getName().startsWith('Asset')) {
            ret = createAsset(new MercuryModel.Asset(aal, loan, branchId));
            } else {
            ret = createLiability(new MercuryModel.Liability(aal, loan, branchId));
        }
        return ret;
    }
    public static Boolean updateAssetAndLiability(Asset_And_Liability__c aal, MercuryModel.Loan loan, String branchId) {
        Boolean ret = false;
        if(AssetAndLiabilityRecordType.getInstance().rtMapById.get(aal.recordTypeId).getName().startsWith('Asset')) {
            ret = updateAsset(new MercuryModel.Asset(aal, loan, branchId));
            } else {
            ret = updateLiability(new MercuryModel.Liability(aal, loan, branchId));
        }
        return ret;
    }
    public class MercurySyncException extends Exception {
        private List<Exception> exceptionList = null;
        public MercurySyncException(List<Exception> exceptionList) {
            this.exceptionList = exceptionList;
        }
        public List<Exception> getExceptions() {
            return exceptionList;
        }
        public String getErrorMessage() {
            String ret = '';
            for(Exception e : exceptionList) {
                ret += e.getMessage() + ' ';
            }
            return ret;
        }
    }
}