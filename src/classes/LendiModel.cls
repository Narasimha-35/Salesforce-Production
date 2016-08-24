public with sharing class LendiModel {

	public class Response extends Model {
		public Integer status_code;
		// public String error;
		// public String message;
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

	public class ServiceCalculatorResult extends Model {
		public List<ServiceCalculator> service_calculators;
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
	}

	public virtual class Income extends Model {
		public String income_sf_id;
		public String user_sf_id;
		public String user_uuid;
		public Double original_amount;
		public String frequency;
		public Integer annually_effective_amount;
		public String income_type;
		public Integer credit_limit_amount;
		public String category;
		public String recognition_field;
		public Integer recognition_rate;
		public Boolean tax_applicable;
		public Integer recognition_amount;
	}

	public virtual class Expense extends Model {
		public String income_sf_id;
		public String user_sf_id;
		public String user_uuid;
		public Integer original_amount;
		public String frequency;
		public Integer annually_effective_amount;
		public String expense_type;
		public Integer credit_limit_amount;
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
		public Integer lvr_from;
		public Integer lvr_to;
		public Integer loan_size_from;
		public Integer loan_size_to;
		public Double interest_rate;
		public Double assessment_rate;
		public Integer rate_buffer;
		public Double final_rate;
		public Integer tenure;
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
		public Integer legal_fees;
		public Integer valuation_fee;
		public Integer application_fee;
		public Integer annual_fee;
		public Integer monthly_fee;
		public Object credit_history;
		public TestObject test;
	}

	public class TestObject {
		public String shortName;
		public String longName;
	}

}
