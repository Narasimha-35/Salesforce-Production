global class NobleOakUtilities {
	public static final String LIFE_INSSURANCE = 'LIFE';
	public static final String TPD_INSSURANCE = 'TPD';
	public static final String BEX_INSSURANCE = 'BEX';
	public static final String IP_INSSURANCE = 'IP';
	public static final String TRAUMA_INSSURANCE = 'TRAUMA';
	public static final String GENDER_MALE = 'Male';
	public static final String GENDER_FEMALE = 'Female';
	public static final String DAY_PERIOD_14 = 'Day-14';
	public static final String DAY_PERIOD_30 = 'Day-30';
	
	Webservice static void nobleOakProductDetailCalculation(Id oppoId) {
		List<Opportunity> oppos = [select Id, NO_BEX_Amount__c, State__c, NO_BEX_Annual_Premium__c, NO_BEX_Monthly_Premium__c, NO_BEX_Waiting_Period__c, NO_IP_Waiting_Period__c, NO_IP_Salary_Conti_For__c, NO_IP_Amount__c, NO_IP_Annual_Premium__c, NO_IP_Monthly_Premium__c, NO_Trauma_Amount__c, NO_Trauma_Annual_Premium__c, NO_Trauma_Monthly_Premium__c, NO_TPD_Amount__c, NO_TPD_Annual_Premium__c, NO_TPD_Monthly_Premium__c, NO_Life_Amount__c, NO_Life_Annual_Premium__c, NO_Life_Monthly_Premium__c, Age_Next_Birthday__c, Occupation_category__c, Gender__c, Is_Smoker__c, Name From Opportunity where Id = :oppoId];
		if (oppos.size() == 1) {
			if (oppos.get(0).Age_Next_Birthday__c >= 16 && oppos.get(0).Age_Next_Birthday__c <= 85 && oppos.get(0).NO_Life_Amount__c > 0
				&& oppos.get(0).Gender__c != null && oppos.get(0).Is_Smoker__c != null && oppos.get(0).Occupation_category__c != null) {
				//FullFil the Life Calculation conditions
				ResultForInsuranceCalculation resultForLife = calculateForLife((Integer)oppos.get(0).Age_Next_Birthday__c, oppos.get(0).NO_Life_Amount__c, oppos.get(0).Gender__c, oppos.get(0).Is_Smoker__c, oppos.get(0).Occupation_category__c);
				if (resultForLife != null) {
					oppos.get(0).NO_Life_Annual_Premium__c = resultForLife.annuallyPayment;
					oppos.get(0).NO_Life_Monthly_Premium__c = resultForLife.monthlyPayment;
				}
			}
			
			if (oppos.get(0).Age_Next_Birthday__c >= 16 && oppos.get(0).Age_Next_Birthday__c <= 75 && oppos.get(0).NO_TPD_Amount__c > 0
				&& oppos.get(0).Gender__c != null && oppos.get(0).Is_Smoker__c != null && oppos.get(0).Occupation_category__c != null) {
				//FullFil the TPD Calculation conditions
				ResultForInsuranceCalculation resultForTPD = calculateForTPD((Integer)oppos.get(0).Age_Next_Birthday__c, oppos.get(0).NO_TPD_Amount__c, oppos.get(0).Gender__c, oppos.get(0).Is_Smoker__c, oppos.get(0).Occupation_category__c);
				if (resultForTPD != null) {
					oppos.get(0).NO_TPD_Annual_Premium__c = resultForTPD.annuallyPayment;
					oppos.get(0).NO_TPD_Monthly_Premium__c = resultForTPD.monthlyPayment;
				}
			}
			
			if (oppos.get(0).Age_Next_Birthday__c >= 16 && oppos.get(0).Age_Next_Birthday__c <= 70 && oppos.get(0).NO_Trauma_Amount__c > 0
				&& oppos.get(0).Gender__c != null && oppos.get(0).Is_Smoker__c != null) {
				//FullFil the TRAUMA Calculation conditions
				ResultForInsuranceCalculation resultForTrauma = calculateForTRAUMA((Integer)oppos.get(0).Age_Next_Birthday__c, oppos.get(0).NO_Trauma_Amount__c, oppos.get(0).Gender__c, oppos.get(0).Is_Smoker__c);
				if (resultForTrauma != null) {
					oppos.get(0).NO_Trauma_Annual_Premium__c = resultForTrauma.annuallyPayment;
					oppos.get(0).NO_Trauma_Monthly_Premium__c = resultForTrauma.monthlyPayment;
				}
			}
			
			if (oppos.get(0).Age_Next_Birthday__c >= 16 && oppos.get(0).Age_Next_Birthday__c <= 65 && oppos.get(0).NO_IP_Amount__c > 0
				&& oppos.get(0).Gender__c != null && oppos.get(0).Is_Smoker__c != null && oppos.get(0).NO_IP_Waiting_Period__c != null
				&& oppos.get(0).NO_IP_Salary_Conti_For__c != null && oppos.get(0).Occupation_category__c != null) {
				//FullFil the IP Calculation conditions
				ResultForInsuranceCalculation resultForIP = calculateForIP(oppos.get(0).NO_IP_Amount__c, oppos.get(0).Gender__c, oppos.get(0).Is_Smoker__c, oppos.get(0).NO_IP_Salary_Conti_For__c, oppos.get(0).NO_IP_Waiting_Period__c, (Integer)oppos.get(0).Age_Next_Birthday__c, true, oppos.get(0).Occupation_category__c);
				if (resultForIP != null ) {
					oppos.get(0).NO_IP_Annual_Premium__c = resultForIP.annuallyPayment;
					oppos.get(0).NO_IP_Monthly_Premium__c = resultForIP.monthlyPayment;
				}
			}
			
			if (oppos.get(0).Age_Next_Birthday__c >= 21 && oppos.get(0).Age_Next_Birthday__c <= 65 && oppos.get(0).NO_BEX_Amount__c > 0
				&& oppos.get(0).NO_BEX_Waiting_Period__c != null && oppos.get(0).Gender__c != null && oppos.get(0).Is_Smoker__c != null
				&& oppos.get(0).Occupation_category__c != null && oppos.get(0).State__c != null) {
				//FullFil the BEX Calculation conditions
				String state = oppos.get(0).State__c;
				if (state == 'New South Wales') {
					state = 'NSW';
				} else if (state == 'Australian Capital Territory') {
					state = 'ACT';
				} else if (state == 'Northern Territory') {
					state = 'NT';
				} else if (state == 'Queensland') {
					state = 'QLD';	
				} else if (state == 'South Australia') {
					state = 'SA';
				} else if (state == 'Tasmania') {
					state = 'TAS';
				} else if (state == 'Victoria') {
					state = 'VIC';
				} else if (state == 'Western Australia') {
					state = 'WA';
				}
				ResultForInsuranceCalculation resultForBEX = calculateForBEX(oppos.get(0).NO_BEX_Waiting_Period__c, (Integer)oppos.get(0).Age_Next_Birthday__c, oppos.get(0).Occupation_category__c, oppos.get(0).NO_BEX_Amount__c, state, oppos.get(0).Gender__c, oppos.get(0).Is_Smoker__c);
				if (resultForBEX != null) {
					oppos.get(0).NO_BEX_Annual_Premium__c = resultForBEX.annuallyPayment;
					oppos.get(0).NO_BEX_Monthly_Premium__c = resultForBEX.monthlyPayment;
				}
			}
		}
		update oppos;
	}
	
	public class ResultForInsuranceCalculation {
		public String insurance { get; set; }
		public decimal monthlyPayment { get; set; }
		public decimal annuallyPayment { get; set; }
	}
	
	public static ResultForInsuranceCalculation calculateForTPD(Integer ageNextBday, decimal totalAmountInsurance, String gendar, Boolean isSmoker, String occupation) {
		decimal rate = 0;
		List<NO_Insurance_LTT__c> rates = [Select Id, Females_Non_Smoker__c, Females_Smoker__c, Males_Non_Smoker__c, Males_Smoker__c From NO_Insurance_LTT__c where Age_Next_Bday__c = :ageNextBday and Insurance_Type__c = :TPD_INSSURANCE];
		if (rates.size() == 1 && occupation != null) {
			if (gendar == GENDER_MALE && isSmoker) {
				rate = rates.get(0).Males_Smoker__c;
			} else if (gendar == GENDER_MALE && !isSmoker) {
				rate = rates.get(0).Males_Non_Smoker__c;
			} else if (gendar == GENDER_FEMALE && isSmoker) {
				rate = rates.get(0).Females_Smoker__c;
			} else if (gendar == GENDER_FEMALE && !isSmoker) {
				rate = rates.get(0).Females_Non_Smoker__c;
			}
			
			if (rate > 0) {
				System.debug('rate ' + rate);
				decimal basePremium = calculateBasePremium(totalAmountInsurance, rate);
				System.debug('basePremium ' + basePremium);
				//Get the occupation loading
				NO_Occupation_Loading_Factor__c occupationLoadingRate = [Select Id, Factor__c from NO_Occupation_Loading_Factor__c where Is_TPD_Rider__c = true and Occupation_Class__c = :occupation];
				decimal bpAfterOccupationLoading = calculateOccupationLoading(basePremium, occupationLoadingRate.Factor__c);
				System.debug('bpAfterOccupationLoading ' + bpAfterOccupationLoading);
				decimal discount = calculateLargeSumDiscount(TPD_INSSURANCE, bpAfterOccupationLoading, totalAmountInsurance);
				System.debug('discount ' + discount);
				decimal bpAfterDiscount = bpAfterOccupationLoading - discount;
				decimal adminFee = calculateAdminFee(bpAfterDiscount);
				System.debug('adminFee ' + adminFee);
				NO_Gross_Rate_Loading__c grossRate = [Select Id, Gross_Rate__c From NO_Gross_Rate_Loading__c Where Gender__c = :gendar];
				decimal bpwithgrossRate = calculateGrossRateLoading(bpAfterDiscount, adminFee, grossRate.Gross_Rate__c);
				System.debug('bpwithgrossRate ' + bpwithgrossRate);
				decimal monthlyPayment = calculateMPFL(bpwithgrossRate, 0) / 12;
				decimal annualPayment = bpwithgrossRate;
				ResultForInsuranceCalculation result = new ResultForInsuranceCalculation();
				result.insurance = TPD_INSSURANCE;
				result.monthlyPayment = monthlyPayment.setscale(2);
				result.annuallyPayment = annualPayment.setscale(2);
				return result;
			}
		}
		return null;
	}
	
	public static ResultForInsuranceCalculation calculateForTrauma(Integer ageNextBday, decimal totalAmountInsurance, String gendar, Boolean isSmoker) {
		decimal rate = 0;
		List<NO_Insurance_LTT__c> rates = [Select Id, Females_Non_Smoker__c, Females_Smoker__c, Males_Non_Smoker__c, Males_Smoker__c From NO_Insurance_LTT__c where Age_Next_Bday__c = :ageNextBday and Insurance_Type__c = :TRAUMA_INSSURANCE];
		if (rates.size() == 1) {
			if (gendar == GENDER_MALE && isSmoker) {
				rate = rates.get(0).Males_Smoker__c;
			} else if (gendar == GENDER_MALE && !isSmoker) {
				rate = rates.get(0).Males_Non_Smoker__c;
			} else if (gendar == GENDER_FEMALE && isSmoker) {
				rate = rates.get(0).Females_Smoker__c;
			} else if (gendar == GENDER_FEMALE && !isSmoker) {
				rate = rates.get(0).Females_Non_Smoker__c;
			}
			
			if (rate > 0) {
				System.debug('rate ' + rate);
				decimal basePremium = calculateBasePremium(totalAmountInsurance, rate);
				System.debug('basePremium ' + basePremium);
				decimal adminFee = calculateAdminFee(basePremium);
				System.debug('admin ' + adminFee);
				NO_Gross_Rate_Loading__c grossRate = [Select Id, Gross_Rate__c From NO_Gross_Rate_Loading__c Where Gender__c = :gendar];
				decimal bpwithgrossRate = calculateGrossRateLoading(basePremium, adminFee, grossRate.Gross_Rate__c);
				System.debug('bpwithgrossRate ' + bpwithgrossRate);
				decimal monthlyPayment = calculateMPFL(bpwithgrossRate, 0) / 12;
				decimal annualPayment = bpwithgrossRate;
				ResultForInsuranceCalculation result = new ResultForInsuranceCalculation();
				result.insurance = TRAUMA_INSSURANCE;
				result.monthlyPayment = monthlyPayment.setscale(2);
				result.annuallyPayment = annualPayment.setscale(2);
				return result;
			}
		}
		return null;
	}
	
	public static ResultForInsuranceCalculation calculateForIP(decimal totalAmountInsurance, String gendar, Boolean isSmoker, String coverPeriod, String waitingPeriod, Integer ageNextBday, Boolean isClickLife, String occupation) {
		totalAmountInsurance = totalAmountInsurance * 0.75;
		totalAmountInsurance = totalAmountInsurance.round(System.RoundingMode.DOWN);
		decimal rate = 0;
		List<NO_Insurance_IP__c> rates = [select Id, Females_Non_Smoker__c, Females_Smoker__c, Males_Non_Smoker__c, Males_Smoker__c From NO_Insurance_IP__c where Age_Next_Bday__c = :ageNextBday and IP_Waiting_Period__c = :waitingPeriod and Insurance_IP_Period__c = :coverPeriod];
		if (rates.size() == 1) {
			if (gendar == GENDER_MALE && isSmoker) {
				rate = rates.get(0).Males_Smoker__c;
			} else if (gendar == GENDER_MALE && !isSmoker) {
				rate = rates.get(0).Males_Non_Smoker__c;
			} else if (gendar == GENDER_FEMALE && isSmoker) {
				rate = rates.get(0).Females_Smoker__c;
			} else if (gendar == GENDER_FEMALE && !isSmoker) {
				rate = rates.get(0).Females_Non_Smoker__c;
			}
			
			if (rate > 0) {
				decimal basePremium = calculateBasePremium(totalAmountInsurance, rate);
				List<NO_Occupation_Loading_Factor__c> occupationLoadingRates = [Select Id, Factor__c from NO_Occupation_Loading_Factor__c where Is_TPD_Rider__c = false and Occupation_Class__c = :occupation];
				decimal bpAfterOccupationLoading = calculateOccupationLoading(basePremium, occupationLoadingRates.get(0).Factor__c);
				decimal adminFee = calculateAdminFee(bpAfterOccupationLoading);
				NO_Gross_Rate_Loading__c grossRate = [Select Id, Gross_Rate__c From NO_Gross_Rate_Loading__c Where Gender__c = :gendar];
				decimal withGrossRateLoading = calculateGrossRateLoading(bpAfterOccupationLoading, adminFee, grossRate.Gross_Rate__c);
				if (isClickLife) {
					//has  9.09% discount
					decimal monthlyPayment = (calculateMPFL(withGrossRateLoading, 0) / 12) * (1- 0.0909);
					decimal annualPayment = withGrossRateLoading * (1 - 0.0909);
					ResultForInsuranceCalculation result = new ResultForInsuranceCalculation();
					result.insurance = IP_INSSURANCE;
					result.monthlyPayment = monthlyPayment.setscale(2);
					result.annuallyPayment = annualPayment.setscale(2);
					return result;
				} else {
					decimal monthlyPayment = calculateMPFL(withGrossRateLoading, 0) / 12;
					decimal annualPayment = withGrossRateLoading;
					ResultForInsuranceCalculation result = new ResultForInsuranceCalculation();
					result.insurance = IP_INSSURANCE;
					result.monthlyPayment = monthlyPayment.setscale(2);
					result.annuallyPayment = annualPayment.setscale(2);
					return result;
				}
			}
		}
		return null;
	}
	
	public static ResultForInsuranceCalculation calculateForBEX(String dayPeriod, Integer ageNextBday, String occupation, decimal totalAmountInsurance, String state, String gendar, Boolean isSmoker) {
		decimal rate = 0;
		List<NO_Insurance_BEX__c> rates = [Select Id, Day_14__c, Day_30__c From NO_Insurance_BEX__c where Age_Next_Bday__c = :ageNextBday and Gendar__c = :gendar and Is_Smoker__c = :isSmoker];
		if (rates.size() == 1 && occupation != null && state != null) {
			if (dayPeriod == DAY_PERIOD_14) {
				rate = rates.get(0).Day_14__c;
			} else if (dayPeriod == DAY_PERIOD_30) {
				rate = rates.get(0).Day_30__c;
			}
			
			if (rate > 0) {
				decimal basePremium = calculateBasePremium(totalAmountInsurance, rate);
				System.debug('rate ' + rate);
				System.debug('basePremium ' + basePremium);
				List<NO_Occupation_Loading_Factor__c> occupationLoadingRates = [Select Id, Factor__c from NO_Occupation_Loading_Factor__c where Is_TPD_Rider__c = false and Occupation_Class__c = :occupation];
				if (occupationLoadingRates.size()  == 1) {
					decimal bpAfterOccupationLoading = calculateOccupationLoading(basePremium, occupationLoadingRates.get(0).Factor__c);
					System.debug('bpAfterOccupationLoading ' + bpAfterOccupationLoading);
					decimal adminFee = calculateAdminFee(bpAfterOccupationLoading);
					System.debug('adminFee ' + adminFee);
					NO_Gross_Rate_Loading__c grossRate = [Select Id, Gross_Rate__c From NO_Gross_Rate_Loading__c Where Gender__c = :gendar];
					decimal withGrossRateLoading = calculateGrossRateLoading(bpAfterOccupationLoading, adminFee, grossRate.Gross_Rate__c);
					System.debug('withGrossRateLoading ' + withGrossRateLoading);
					//Get the stamp duty rate
					List<NO_Stamp_Duty_Rate__c> stampDutyRates = [Select Id, Rate__c from NO_Stamp_Duty_Rate__c where State__c = :state];
					if (stampDutyRates.size() == 1) {
						decimal stampDutyFee = calculateStampDuty(BEX_INSSURANCE, bpAfterOccupationLoading, stampDutyRates.get(0).Rate__c);
						System.debug('stampDutyFee ' + stampDutyFee);
						decimal monthlyPayment = calculateMPFLForBEX(withGrossRateLoading, stampDutyFee) / 12;
						decimal annualPayment = withGrossRateLoading + stampDutyFee;
						ResultForInsuranceCalculation result = new ResultForInsuranceCalculation();
						result.insurance = BEX_INSSURANCE;
						result.monthlyPayment = monthlyPayment.setscale(2);
						result.annuallyPayment = annualPayment.setscale(2);
						return result;
					}					
				}
			}
		}
		return null;
	}
	
	public static ResultForInsuranceCalculation calculateForLife(Integer ageNextBday, decimal totalAmountInsurance, String gendar, Boolean isSmoker, String occupation) {
		// Get the life rate
		decimal rate = 0;
		List<NO_Insurance_LTT__c> rates = [Select Id, Females_Non_Smoker__c, Females_Smoker__c, Males_Non_Smoker__c, Males_Smoker__c From NO_Insurance_LTT__c where Age_Next_Bday__c = :ageNextBday and Insurance_Type__c = 'LIFE'];
		if (rates.size() == 1) {
			if (gendar == GENDER_MALE && isSmoker) {
				rate = rates.get(0).Males_Smoker__c;
			} else if (gendar == GENDER_MALE && !isSmoker) {
				rate = rates.get(0).Males_Non_Smoker__c;
			} else if (gendar == GENDER_FEMALE && isSmoker) {
				rate = rates.get(0).Females_Smoker__c;
			} else if (gendar == GENDER_FEMALE && !isSmoker) {
				rate = rates.get(0).Females_Non_Smoker__c;
			}
			
			if (rate > 0) {
				System.debug('rate ' + rate);
				decimal basePremium = calculateBasePremium(totalAmountInsurance, rate);
				System.debug('basePremium ' + basePremium);
				decimal discount = calculateLargeSumDiscount(LIFE_INSSURANCE, basePremium, totalAmountInsurance);
				System.debug('discount ' + discount);
				decimal bPAfterDiscount = basePremium - discount;
				decimal adminFee = calculateAdminFee(bPAfterDiscount);
				System.debug('adminFee ' + adminFee);
				//Get the gross rate
				NO_Gross_Rate_Loading__c grossRate = [Select Id, Gross_Rate__c From NO_Gross_Rate_Loading__c Where Gender__c = :gendar];
				decimal withGrossRateLoading = calculateGrossRateLoading(bPAfterDiscount, adminFee, grossRate.Gross_Rate__c);
				decimal monthlyPayment = calculateMPFL(withGrossRateLoading, 0) / 12;
				decimal annualPayment = withGrossRateLoading;
				ResultForInsuranceCalculation result = new ResultForInsuranceCalculation();
				result.insurance = LIFE_INSSURANCE;
				result.monthlyPayment = monthlyPayment.setscale(2);
				result.annuallyPayment = annualPayment.setscale(2);
				return result;
			}
		}
		return null;
	}
	
	public static decimal calculateBasePremium(decimal totalAmount, decimal rate) {
		decimal basePremium = (totalAmount / 1000) * rate;
		return basePremium;
	}
	
	public static decimal calculateOccupationLoading(decimal basePremium, decimal loadingRate) {
		decimal occupationLoading =  basePremium * loadingRate;
		return occupationLoading;
	}
	
	public static decimal calculateLargeSumDiscount(String insuranceType, decimal bPAfterOccupationLoading, decimal totalAmount) {
		if (insuranceType == LIFE_INSSURANCE) {
			if (totalAmount >= 500000 && totalAmount < 1000000) {
				return bPAfterOccupationLoading * 0.15;
			} else if (totalAmount >= 1000000 && totalAmount < 2000000) {
				return bPAfterOccupationLoading * 0.225;
			} else if (totalAmount >= 2000000 && totalAmount < 3000000) {
				return bPAfterOccupationLoading * 0.25;
			} else if (totalAmount >= 3000000) {
				return bPAfterOccupationLoading * 0.275;
			}
		} else if (insuranceType == TPD_INSSURANCE) {
			if (totalAmount >= 500000 && totalAmount < 1000000) {
				return bPAfterOccupationLoading * 0.1;
			} else if (totalAmount >= 1000000 && totalAmount < 2000000) {
				return bPAfterOccupationLoading * 0.175;
			} else if (totalAmount >= 2000000 && totalAmount < 3000000) {
				return bPAfterOccupationLoading * 0.2;
			} else if (totalAmount >= 3000000) {
				return bPAfterOccupationLoading * 0.225;
			}
		}
		return 0;
	}
	
	public static decimal calculateAdminFee(decimal bPAfterDiscount) {
		decimal adminFee = bPAfterDiscount * 0.1;
		return adminFee;
	}
	
	public static decimal calculateGrossRateLoading(decimal bPAfterDiscount, decimal adminFee, decimal rate) {
		return (bPAfterDiscount + adminFee) / (1 - rate);
	}
	
	public static decimal calculateStampDuty(String insurranceType, decimal bPAfterOccupationLoading, decimal rate) {
		if (insurranceType == BEX_INSSURANCE) {
			return bPAfterOccupationLoading * rate;
		}
		return 0;
	}
	
	public static decimal calculateMPFLForBEX(decimal bPAfterGrossRateLoading, decimal stampDuty) {
		return bPAfterGrossRateLoading * 1.05 + stampDuty;
	}
	
	public static decimal calculateMPFL(decimal bPAfterGrossRateLoading, decimal stampDuty) {
		return (bPAfterGrossRateLoading + stampDuty) * 1.05;
	}
	
	public static decimal discountFromClickLife(String insurranceType, decimal finalAmount) {
		if (IP_INSSURANCE == insurranceType) {
			return finalAmount * 0.0909;
		}
		return 0;
	}
}