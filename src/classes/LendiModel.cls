public with sharing class LendiModel {
	public static final String INCOME_TYPE = 'incomes';
	public static final String EXPENSE_TYPE = 'expenses';
	public static final String ASSET_TYPE = 'assets';
	public static final String LIABILITY_TYPE = 'liabilities';

	public class Response extends Model {
		public Integer status_code;
		public Meta meta;
		public Object data;
	}

	public class Meta extends Model {
		public String community;
		public String api_version;
		public String uid;
	}

	public class User extends Model {
		public String uuid;
		public String firstName;
		public String lastName;
		public String token;
		public String user_sf_id;
		public String user_name;
		public String user_uuid;
		public String marital_status;
		public String num_of_dependant;
		public String state;
		public String postcode;
		public Integer total_asset_security_value;
		public Integer funds_requested;
		public Integer funds_required;
		public List<Income> incomes;
		public List<Expense> expenses;
		public List<Liability> liabilities;
		public Integer taxable_incomes;
		public Double tax;
		public Integer user_recognised_income;
		public Integer user_total_raw_income;
		public Integer user_liability_expense;
		public Integer user_living_expense;
		public Integer user_recognised_total_expense;
		public Integer user_total_raw_expense;
		public LivingExpense living_expense_bank_specification;
		public Integer living_expense_bank_specified_monthly;
		public Integer living_expense_bank_specified_annually;
		public Integer living_expense_final_annually;
		public Double disposable_income_annually;
		public Double disposable_income_monthly;

		public User() {
		}

		public User(String uuid) {
			this.uuid = uuid;
		}

		public User(String uuid, String firstName, String lastName) {
			this.uuid = uuid;
			this.firstName = firstName;
			this.lastName = lastName;
		}
	}

	public class ServiceCalculator extends Model {
		public String service_calculator_uuid;
		public UserGroup user_group;
		public Product product;
		public Double maximum_borrowing;
		public Boolean is_services_funds_requested;
		public Boolean is_services_funds_required;
		public Double net_monthly_surplus;
		public Double total_disposable_income_annually;
		public Double total_disposable_income_monthly;
		public Double service_calculator_monthly_repayment;
		public Double actual_monthly_repayment;

		public ServicingCalculator__c convertToServiceCalculator(Id opportunityId) {
			ServicingCalculator__c sc      = new ServicingCalculator__c();
			sc.max_Borrowing_Power__c      = maximum_borrowing;
			sc.net_Monthly_Surplus__c      = net_monthly_surplus;
			sc.services_Funds_Requested__c = is_services_funds_requested;
			sc.services_Funds_Required__c  = is_services_funds_required;
			sc.opportunity__c              = opportunityId;
			sc.opportunityId__c            = opportunityId;

			return sc;
		}

		public List<ServiceCalculatorDetail__c> generateDetails(Id scId, String type) {
			List<ServiceCalculatorDetail__c> ret = new List<ServiceCalculatorDetail__c>();

			for(User u : user_group.users) {
				if(type == INCOME_TYPE) {
					for(Income inc : u.incomes) {
						ServiceCalculatorDetail__c incSCDetail = new ServiceCalculatorDetail__c();
						incSCDetail.amount__c                  = inc.original_amount;
						incSCDetail.applicant__c               = inc.user_sf_id;
						incSCDetail.frequency__c               = inc.frequency;
						incSCDetail.incomeAndExpense__c        = inc.income_and_expense_sf_id;
						incSCDetail.incomeAndExpenseId__c      = inc.income_and_expense_sf_id;
						incSCDetail.recogitionAmount__c        = inc.recognition_rate == null ? 0 : inc.original_amount * inc.recognition_rate;
						incSCDetail.recogitionPercentage__c    = inc.recognition_rate * 100;
						incSCDetail.servicingCalculator__c     = scId;
						ret.add(incSCDetail);
					}
				}
				if(type == EXPENSE_TYPE) {
					for(Expense exp : u.expenses) {
						ServiceCalculatorDetail__c expSCDetail = new ServiceCalculatorDetail__c();
						expSCDetail.amount__c                  = exp.original_amount;
						expSCDetail.applicant__c               = exp.user_sf_id;
						expSCDetail.frequency__c               = exp.frequency;
						expSCDetail.incomeAndExpense__c        = exp.income_and_expense_sf_id;
						expSCDetail.incomeAndExpenseId__c      = exp.income_and_expense_sf_id;
						expSCDetail.recogitionAmount__c        = exp.recognition_rate == null ? 0 : exp.original_amount * exp.recognition_rate;
						expSCDetail.recogitionPercentage__c    = exp.recognition_rate * 100;
						expSCDetail.servicingCalculator__c     = scId;
						ret.add(expSCDetail);
					}
				}
				if(type == LIABILITY_TYPE) {
					for(Liability lia : u.liabilities) {
						if(lia.clearing_from_this_loan == true) continue;
						ServiceCalculatorDetail__c liaSCDetail = new ServiceCalculatorDetail__c();
						liaSCDetail.amount__c                  = lia.repayments;
						liaSCDetail.opportunity__c             = lia.opportunity;
						liaSCDetail.frequency__c               = lia.repayment_frequency;
						liaSCDetail.assetAndLiability__c       = lia.asset_and_liability_sf_id;
						liaSCDetail.assetAndLiabilityId__c     = lia.asset_and_liability_sf_id;
						liaSCDetail.recogitionAmount__c        = lia.repayments;
						liaSCDetail.recogitionPercentage__c    = 100;
						ret.add(liaSCDetail);
					}
				}
			}

			return ret;
		}
	}

	public virtual class Asset extends Model {
		public String asset_and_liability_sf_id;
		public String asset_and_liability_name;
		public String account;
		public String opportunity;
		public String value;
	}

	public virtual class Liability extends Model {
		public String asset_and_liability_sf_id;
		public Boolean clearing_from_this_loan;
		public String opportunity;
		public Double repayments;
		public String repayment_frequency;
	}

	public virtual class Income extends Model {
		public String income_and_expense_sf_id;
		public String user_sf_id;
		public String user_uuid;
		public Double original_amount;
		public String frequency;
		public Integer annually_effective_amount;
		public String income_expense_type;
		public Integer credit_limit_amount;
		public String category;
		public String recognition_field;
		public Integer recognition_rate;
		public Boolean tax_applicable;
		public Integer recognition_amount;
	}

	public virtual class Expense extends Model {
		public String income_and_expense_sf_id;
		public String user_sf_id;
		public String user_uuid;
		public Integer original_amount;
		public String frequency;
		public Integer annually_effective_amount;
		public String income_expense_type;
		public Integer credit_limit_amount;
		public String category;
		public String recognition_field;
		public Integer recognition_rate;
		public Boolean tax_applicable;
		public Integer recognition_amount;
	}

	public class LivingExpense extends Income {
		public String living_expense_sf_id;
		public String living_expense_name;
		public String marital_status;
		public String state;
		public String state_name;
		public String state_short_name;
		public Integer dependants;
		public Integer net_income_from;
		public Long net_income_to;
		public Integer living_expense;
		public String location_guide_sf_id;
		public String location_guide_name;
		public String location_guide_lender;
		public String location_guide_state;
		public Integer location_guide_postcode_from;
		public Integer location_guide_postcode_to;
		public Integer priority;
	}

	public class UserGroup extends Model {
		public List<User> users;
		public Integer funds_requested;
		public Integer funds_required;
		public Integer security_value;
		public Double lvr_rate;
		public List<String> dependants;
		public List<String> postcodes;
		public List<String> states;
		public List<String> income_and_expense_types;
	}

	public class Product extends Model {
		public String product_sf_id;
		public String product_uuid;
		public String product_name;
		public String bank_sf_id;
		public String bank_uuid;
		public String bank_short_name;
		public String bank_full_name;
		public String lvr_rate_sf_id;
		public Double lvr_from;
		public Double lvr_to;
		public Double loan_size_from;
		public Double loan_size_to;
		public Double interest_rate;
		public Double assessment_rate;
		public Double rate_buffer;
		public Double final_rate;
		public Double tenure;
		public Boolean is_redraw;
		public Boolean is_offset_account;
		public Boolean is_interest_only;
		public Boolean is_add_repayment;
		public Boolean is_multiple_splits;
		public Double comparison_rate;
		public String loan_purpose;
		public String loan_type;
		public String product_type;
		public Boolean investment;
		public Boolean owner_occupied;
		public Double legal_fees;
		public Double valuation_fee;
		public Double application_fee;
		public Double annual_fee;
		public Double monthly_fee;
		public String credit_history;

		public Product() {
		}

		public Product(Product2 prod) {
			this.product_sf_id = prod.id;
		}
	}

}
