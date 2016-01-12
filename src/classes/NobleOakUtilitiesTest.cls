@isTest(SeeAllData = true)
private class NobleOakUtilitiesTest {

    static testMethod void calculateLifeInsuranceTest() {
        // TO DO: implement unit test
        Integer ageNextBdayTest1 = 25;
        decimal totalAmountTest1 = 500000;
        String gendarTest1 = 'Male';
        Boolean isSmokerTest1 = false;
        String occupationTest1 = 'Heavy Blue Collar';
        
        NobleOakUtilities.ResultForInsuranceCalculation result = NobleOakUtilities.calculateForLife(ageNextBdayTest1, totalAmountTest1, gendarTest1, isSmokerTest1, occupationTest1);
    	System.debug(result.insurance + ' M ' + result.monthlyPayment);
    	System.debug(result.insurance + ' A ' + result.annuallyPayment);
    	
		Integer ageNextBdayTest2 = 30;
        decimal totalAmountTest2 = 1000000;
        String gendarTest2 = 'Male';
        Boolean isSmokerTest2 = true;
        String occupationTest2 = 'Medium Blue Collar';
        NobleOakUtilities.ResultForInsuranceCalculation result2 = NobleOakUtilities.calculateForLife(ageNextBdayTest2, totalAmountTest2, gendarTest2, isSmokerTest2, occupationTest2);
        System.debug(result2.insurance + ' M ' + result2.monthlyPayment);
    	System.debug(result2.insurance + ' A ' + result2.annuallyPayment);
    }
    
    static testMethod void calculateTPDInsuranceTest() {
    	Integer ageNextBdayTest1 = 25;
    	decimal totalAmountTest1 = 500000;
    	String gendarTest1 = 'Male';
    	Boolean isSmokerTest1 = false;
    	String occupationTest1 = 'Heavy Blue Collar';
    	
    	NobleOakUtilities.ResultForInsuranceCalculation result = NobleOakUtilities.calculateForTPD(ageNextBdayTest1, totalAmountTest1, gendarTest1, isSmokerTest1, occupationTest1);
    	System.debug(result.insurance + ' M ' + result.monthlyPayment);
    	System.debug(result.insurance + ' A ' + result.annuallyPayment);
    	
    	Integer ageNextBdayTest2 = 30;
    	decimal totalAmountTest2 = 1500000;
    	String gendarTest2 = 'Female';
    	Boolean isSmokerTest2 = false;
    	String occupationTest2 = 'Medium Blue Collar';
    	
    	NobleOakUtilities.ResultForInsuranceCalculation result2 = NobleOakUtilities.calculateForTPD(ageNextBdayTest2, totalAmountTest2, gendarTest2, isSmokerTest2, occupationTest2);
    	System.debug(result2.insurance + ' M ' + result2.monthlyPayment);
    	System.debug(result2.insurance + ' A ' + result2.annuallyPayment);
    }
    
    static testMethod void calculateTRAUMAInsuranceTest() {
    	Integer ageNextBdayTest1 = 25;
    	decimal totalAmountTest1 = 500000;
    	String gendarTest1 = 'Male';
    	Boolean isSmokerTest1 = false;
    	
    	NobleOakUtilities.ResultForInsuranceCalculation result = NobleOakUtilities.calculateForTrauma(ageNextBdayTest1, totalAmountTest1, gendarTest1, isSmokerTest1);
    	System.debug(result.insurance + ' M ' + result.monthlyPayment);
    	System.debug(result.insurance + ' A ' + result.annuallyPayment);
    	
    	Integer ageNextBdayTest2 = 35;
    	decimal totalAmountTest2 = 500000;
    	String gendarTest2 = 'Male';
    	Boolean isSmokerTest2 = true;
    	
    	NobleOakUtilities.ResultForInsuranceCalculation result2 = NobleOakUtilities.calculateForTrauma(ageNextBdayTest2, totalAmountTest2, gendarTest2, isSmokerTest2);
    	System.debug(result2.insurance + ' M ' + result2.monthlyPayment);
    	System.debug(result2.insurance + ' A ' + result2.annuallyPayment);
    }
    
    static testMethod void calculateIPInsuranceTest() {
    	Integer ageNextBdayTest1 = 25;
    	decimal totalAmountTest1 = 500000;
    	String gendarTest1 = 'Male';
    	Boolean isSmokerTest1 = false;
    	String occupationTest1 = 'Heavy Blue Collar';
    	String waitingPeriodTest1 = '30-Day Waiting';
    	String coverPeriodTest1 = 'two years';
    	Boolean isClickLifeTest1 = false;
    	
    	NobleOakUtilities.ResultForInsuranceCalculation result = NobleOakUtilities.calculateForIP(totalAmountTest1, gendarTest1, isSmokerTest1, coverPeriodTest1, waitingPeriodTest1, ageNextBdayTest1, isClickLifeTest1, occupationTest1);
    	System.debug(result.insurance + ' M ' + result.monthlyPayment);
    	System.debug(result.insurance + ' A ' + result.annuallyPayment);
    	
    	Integer ageNextBdayTest2 = 35;
    	decimal totalAmountTest2 = 500000;
    	String gendarTest2 = 'Female';
    	Boolean isSmokerTest2 = true;
    	String occupationTest2 = 'Heavy Blue Collar';
    	String waitingPeriodTest2 = '90-Day Waiting';
    	String coverPeriodTest2 = 'age 65';
    	Boolean isClickLifeTest2 = true;
    	
    	NobleOakUtilities.ResultForInsuranceCalculation result2 = NobleOakUtilities.calculateForIP(totalAmountTest2, gendarTest2, isSmokerTest2, coverPeriodTest2, waitingPeriodTest2, ageNextBdayTest2, isClickLifeTest2, occupationTest2);
    	System.debug(result2.insurance + ' M ' + result2.monthlyPayment);
    	System.debug(result2.insurance + ' A ' + result2.annuallyPayment);
    }
    
    static testMethod void calculateBEXInsuranceTest() {
    	String dayPeriodTest1 = 'Day-30';
    	Integer ageNextBdayTest1 = 25;
    	decimal totalAmountTest1 = 60000;
    	Boolean isSmokerTest1 = false;
    	String occupationTest1 = 'Heavy Blue Collar';
    	String gendarTest1 = 'Male';
    	String stateTest1 = 'NSW';
    	
    	NobleOakUtilities.ResultForInsuranceCalculation result = NobleOakUtilities.calculateForBEX(dayPeriodTest1, ageNextBdayTest1, occupationTest1, totalAmountTest1, stateTest1, gendarTest1, isSmokerTest1);
    	System.debug(result.insurance + ' M ' + result.monthlyPayment);
    	System.debug(result.insurance + ' A ' + result.annuallyPayment);
    }
    
    static testMethod void nobleOakProductDetailCalculationTest() {
    	Opportunity oppo = [select id, Is_Smoker__c, Occupation_category__c, NO_IP_Waiting_Period__c, NO_IP_Salary_Conti_For__c, NO_BEX_Waiting_Period__c from Opportunity where Account_Birthday__c != null and State__c != null and Age_Next_Birthday__c > 22 limit 1];
   		oppo.Is_Smoker__c = true;
   		oppo.Occupation_category__c = 'Medium Blue Collar';
   		oppo.NO_IP_Waiting_Period__c = '30-Day Waiting';
   		oppo.NO_IP_Salary_Conti_For__c = 'two years';
   		oppo.NO_BEX_Waiting_Period__c = 'Day-14';
   		oppo.NO_BEX_Amount__c = 500000;
   		oppo.NO_IP_Amount__c = 500000;
   		oppo.NO_Trauma_Amount__c = 500000;
   		oppo.NO_Life_Amount__c = 500000;
   		oppo.NO_TPD_Amount__c = 500000;
   		update oppo;
   		NobleOakUtilities.nobleOakProductDetailCalculation(oppo.Id);
   		oppo = [select Id, NO_BEX_Amount__c, State__c, NO_BEX_Annual_Premium__c, NO_BEX_Monthly_Premium__c, NO_BEX_Waiting_Period__c, NO_IP_Waiting_Period__c, NO_IP_Salary_Conti_For__c, NO_IP_Amount__c, NO_IP_Annual_Premium__c, NO_IP_Monthly_Premium__c, NO_Trauma_Amount__c, NO_Trauma_Annual_Premium__c, NO_Trauma_Monthly_Premium__c, NO_TPD_Amount__c, NO_TPD_Annual_Premium__c, NO_TPD_Monthly_Premium__c, NO_Life_Amount__c, NO_Life_Annual_Premium__c, NO_Life_Monthly_Premium__c, Age_Next_Birthday__c, Occupation_category__c, Gender__c, Is_Smoker__c, Name From Opportunity where Id = :oppo.Id];
    	System.debug('BEX A ' + oppo.NO_BEX_Annual_Premium__c);
    	System.debug('BEX M ' + oppo.NO_BEX_Monthly_Premium__c);
    	System.debug('IP A ' + oppo.NO_IP_Annual_Premium__c);
    	System.debug('IP M ' + oppo.NO_IP_Monthly_Premium__c);
    	System.debug('TRAUMA A ' + oppo.NO_Trauma_Annual_Premium__c);
    	System.debug('TRAUMA M ' + oppo.NO_Trauma_Monthly_Premium__c);
    	System.debug('TPD A ' + oppo.NO_TPD_Annual_Premium__c);
    	System.debug('TPD M ' + oppo.NO_TPD_Monthly_Premium__c);
    	System.debug('LIFE A ' + oppo.NO_Life_Annual_Premium__c);
    	System.debug('LIFE M ' + oppo.NO_Life_Monthly_Premium__c);
    	
    }
}