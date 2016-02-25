public without sharing class MercuryModel {
	public static final Map<String, String> opportunityLoanMap;
	static {
		opportunityLoanMap = new Map<String, String>();
		opportunityLoanMap.put('merc_uniqueId__c', 'uniqueId');
		opportunityLoanMap.put('merc_branch__c', 'company');
		opportunityLoanMap.put('merc_transaction_name__c', 'loanName');
		opportunityLoanMap.put('merc_loan_writer__c', 'agentName');
		opportunityLoanMap.put('merc_admin__c', 'personActingName');
		opportunityLoanMap.put('merc_supervisor__c', 'personResponsibleName');
		opportunityLoanMap.put('merc_current_status__c', 'status');
		opportunityLoanMap.put('merc_lead_source__c', 'leadSourceDisplay');
		opportunityLoanMap.put('merc_campagin__c', 'campaignName');
		opportunityLoanMap.put('merc_internal_reference__c', 'partnerReference');
		opportunityLoanMap.put('merc_opportunity_type__c', 'tranxType');
		opportunityLoanMap.put('merc_lender__c', 'lender');
		opportunityLoanMap.put('merc_loan_amount__c', 'amount');
		opportunityLoanMap.put('merc_existing_amount__c', 'existingAmount');
		opportunityLoanMap.put('merc_security_value__c', 'securityValue');
		opportunityLoanMap.put('merc_lmi__c', 'lmi');
		opportunityLoanMap.put('merc_status_notes__c', 'sitRep');
		opportunityLoanMap.put('merc_transaction_type__c', 'tranxType');
		opportunityLoanMap.put('merc_lender_reference__c', 'lenderReference');
		opportunityLoanMap.put('merc_apply_online_id__c', 'nextGenId');
		opportunityLoanMap.put('merc_finance_date__c', 'financeDate');
		opportunityLoanMap.put('merc_deposit_due_date__c', 'depositDueDate');
		opportunityLoanMap.put('merc_settlement_date__c', 'confirmedSettlementDate');
		opportunityLoanMap.put('merc_fixed_rate_expiry__c', 'fixedRateExpiry');
		opportunityLoanMap.put('merc_interest_only_expiry__c', 'interestOnlyExpiry');
		opportunityLoanMap.put('merc_categories__c', 'metaData');
	}

	public static final Map<String, String> loanOpportunityMap;
	static {
		loanOpportunityMap = new Map<String, String>();
		for(String k : opportunityLoanMap.keySet()) {
			loanOpportunityMap.put(opportunityLoanMap.get(k), k);
		}
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
		public Long annualSalary {get; set;}
		public String contactType {get; set;}
		public String abn {get; set;}
		public String acn {get; set;}
		public String trustName {get; set;}
		public String homeSuburb {get; set;}
		public Long numberOfDependents {get; set;}
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
	}

	public class PersonResponse extends Model {
		public Boolean success {get; set;}
		public List<MercuryModel.People> People {get; set;}
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
		public String confirmedSettlementDate {get; set;}
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
		public Long statusLastUpdated {get; set;}
		public String lenderComments {get; set;}
		public String sitRep {get; set;}
		public String campaignId {get; set;}
		public String campaignName {get; set;}
		public Double securityValue {get; set;}
		public String aliApplicationId {get; set;}
		public String metlifeApplicationId {get; set;}
		public String interestOnlyExpiry {get; set;}
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
			ret += '&params={' + EncodingUtil.urlEncode(paramString, 'UTF-8') + '}';
			ret += '&page=' + page;
			ret += '&start=' + start;
			ret += '&limit=' + lmt;
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

}
