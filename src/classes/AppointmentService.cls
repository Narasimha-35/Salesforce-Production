public class AppointmentService {

    public static String constructAppointmentDescription(Appointment__c appt) {
        String ret = DocumentService.getTemplate('appointmentConfirmationDescriptionTemplate');
        ret = ret.replace('{!appointmentName}', appt.name == null ? '' : appt.name);
        ret = ret.replace('{!appointmentDatetime}', appt.appointment_Date_and_Time__c == null ? '' : appt.appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a'));
        ret = ret.replace('{!contactMobile}', appt.mobile__c == null ? '' : appt.mobile__c);
        ret = ret.replace('{!contactPhone}', appt.phone__c == null ? '' : appt.phone__c);
        ret = ret.replace('{!contactAddress}', EventService.constructAppointmentEventLocation(appt, ','));
        ret = ret.replace('{!contactEmail}', appt.account_Email__c == null ? '' : appt.account_Email__c);
        ret = ret.replace('{!contactName}', appt.account_Name_Text__c == null ? '' : appt.account_Name_Text__c);
        ret = ret.replace('{!appointmentNotes}', appt.pre_Sales_Notes__c == null ? '' : appt.pre_Sales_Notes__c.stripHtmlTags());
        ret = ret.replace('{!transactionType}', appt.transaction_Type__c == null ? '' : appt.transaction_Type__c);
        ret = ret.replace('{!currentLender}', appt.current_Lender__c == null ? '' : appt.current_Lender__c);
        ret = ret.replace('{!currentLoanType}', appt.current_Loan_Type__c == null ? '' : appt.current_Loan_Type__c);
        ret = ret.replace('{!currentInterestRateType}', appt.current_Interest_Rate_Type__c == null ? '' : appt.current_Interest_Rate_Type__c);
        ret = ret.replace('{!currentFinancials}', appt.current_Financials_Up_to_Date__c == null ? '' : appt.current_Financials_Up_to_Date__c);
        ret = ret.replace('{!lastRefinance}', appt.last_Refinance__c == null ? '' : appt.last_Refinance__c.format());
        ret = ret.replace('{!fixedRateExpiry}', appt.fixed_Rate_Expiry__c == null ? '' : appt.fixed_Rate_Expiry__c.format());
        ret = ret.replace('{!currentLoanAge}', appt.age_of_Current_Loan__c == null ? '' : appt.age_of_Current_Loan__c);
        ret = ret.replace('{!incomeLiabilityDetails}', ' ');
        ret = ret.replace('{!employmentStatus}', appt.employment_Status__c == null ? '' : appt.employment_Status__c);
        ret = ret.replace('{!industry}', appt.industry__c == null ? '' : appt.industry__c);

        ret = ret.replace('{!currentLoanValue}', appt.current_Loan_Value__c == null ? '' : '' + appt.current_Loan_Value__c);
        ret = ret.replace('{!currentInterestRate}', '' + appt.current_Interest_Rate__c);
        ret = ret.replace('{!annualIncome}', appt.annual_Income__c == null ? '' : '' + appt.annual_Income__c);
        ret = ret.replace('{!partnerAnualIncome}', appt.partner_Income__c == null ? '' : '' + appt.partner_Income__c);
        ret = ret.replace('{!creditCardBalance}', appt.credit_Card_Balance__c == null ? '' : '' + appt.credit_Card_Balance__c);
        ret = ret.replace('{!personalLoanBalance}', appt.personal_Loan_Balance__c == null ? '' : '' + appt.personal_Loan_Balance__c);

        return ret;
    }

    public static Event constructEvent(Appointment__c appt, Datetime startTime, Id ownerId) {
        Integer durationOfMeeting = Integer.valueOf(Allocate_Appointment__c.getValues('Phone_Broker').DurationOfMeeting__c);

        Event e = new Event();
        e.ownerid = ownerId == null ? '' : ownerId;
        e.startdatetime = startTime;
        e.enddatetime = startTime.addminutes(durationOfMeeting);
        e.whatid = appt.broker__c;
        e.description = constructAppointmentDescription(appt);
        e.location = EventService.constructAppointmentEventLocation(appt, ',');
        e.subject = EventService.constructAppointmentEventSubject(appt);
        return e;
    }

    public static String constructEmailBodyToNewBroker(Appointment__c appt, EmailTemplate emailTemplate) {
        string ret = '';
        ret = emailTemplate.htmlValue;
        ret = ret.replace('{!Broker.Name}', appt.broker__r.name == null ? '' : appt.broker__r.name);
        ret = ret.replace('[[AppRef]]', appt.name == null ? '' : appt.name);
        ret = ret.replace('[[Presales]]', appt.pre_Sales_User__c == null ? '' : appt.pre_Sales_User__c);
        ret = ret.replace('[[CustName]]', appt.account_Name__c == null ? '' : appt.account_Name__c);
        ret = ret.replace('[[CustEmail]]', appt.account_Email__c == null ? '' : appt.account_Email__c);
        ret = ret.replace('[[Mobile]]', appt.mobile__c == null ? '' : appt.mobile__c);
        ret = ret.replace('[[Phone]]', appt.phone__c == null ? '' : appt.phone__c);
        ret = ret.replace('[[AlternatePhone]]', appt.alternate_Phone__c == null ? '' : appt.alternate_Phone__c);
        ret = ret.replace('[[AppDateTime]]', appt.appointment_Date_and_Time__c == null ? '' : String.valueOf(appt.appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
        ret = ret.replace('[[StreetAddress]]', appt.street_Address__c == null ? '' : appt.street_Address__c);
        ret = ret.replace('[[City]]', appt.city__c == null ? '' : appt.city__c);
        ret = ret.replace('[[PostalCode]]', appt.postal_Code__c == null ? '' : appt.postal_Code__c);
        ret = ret.replace('[[State]]', appt.state__c == null ? '' : appt.state__c);
        ret = ret.replace('[[AppType]]', appt.appointment_Type__c == null ? '' : appt.appointment_Type__c);
        ret = ret.replace('[[preNote]]', appt.pre_Sales_Notes__c == null ? '' : appt.pre_Sales_Notes__c);
        ret = ret.replace('[[TransactionType]]', appt.transaction_Type__c == null ? '' : appt.transaction_Type__c);
        ret = ret.replace('[[CurrentLender]]', appt.current_Lender__c == null ? '' : appt.current_Lender__c);
        ret = ret.replace('[[CurrentLoanValue]]', appt.current_Loan_Value__c == null ? '' : String.valueOf(appt.current_Loan_Value__c));
        ret = ret.replace('[[CurrentLoanType]]', appt.current_Loan_Type__c == null ? '' : appt.current_Loan_Type__c);
        ret = ret.replace('[[CurrentInterestRate]]', appt.current_Interest_Rate__c == null ? '' : String.valueOf(appt.current_Interest_Rate__c));
        ret = ret.replace('[[CurrentInterestRateType]]', appt.current_Interest_Rate_Type__c == null ? '' : appt.current_Interest_Rate_Type__c);
        ret = ret.replace('[[CurrentFinancials]]', appt.current_Financials_Up_to_Date__c == null ? '' : appt.current_Financials_Up_to_Date__c);
        ret = ret.replace('[[FixedRate]]', appt.fixed_Rate_Expiry__c == null ? '' : String.valueOf(appt.fixed_Rate_Expiry__c));
        ret = ret.replace('[[lastRefinance]]', appt.last_Refinance__c == null ? '' : String.valueOf(appt.last_Refinance__c));
        ret = ret.replace('[[AgeCurrent]]', appt.age_of_Current_Loan__c == null ? '' : appt.age_of_Current_Loan__c);
        ret = ret.replace('[[EmploymentStatus]]', appt.employment_Status__c == null ? '' : appt.employment_Status__c);
        ret = ret.replace('[[Industry]]', appt.industry__c == null ? '' : appt.industry__c);
        ret = ret.replace('[[AnnualIncome]]', appt.annual_Income__c == null ? '' : String.valueOf(appt.annual_Income__c));
        ret = ret.replace('[[CreditCardBalance]]', appt.credit_Card_Balance__c == null ? '' : String.valueOf(appt.credit_Card_Balance__c));
        ret = ret.replace('[[PartnerIncome]]', appt.partner_Income__c == null ? '' : String.valueOf(appt.partner_Income__c));
        ret = ret.replace('[[CarLoanBalance]]', appt.car_Loan_Balance__c == null ? '' : String.valueOf(appt.car_Loan_Balance__c));
        ret = ret.replace('[[PersonalLoanBalance]]', appt.personal_Loan_Balance__c == null ? '' : String.valueOf(appt.personal_Loan_Balance__c));
        return ret;
    }

    public static String constructEmailBodyToOldBroker(Appointment__c appt, EmailTemplate emailTemplate) {
        String ret = emailTemplate.htmlValue;
        ret = ret.replace('{!Broker.Name}', appt.Broker__r.name == null ? '' : appt.Broker__r.name);
        ret = ret.replace('[[apptref]]', appt.name == null ? '' : appt.Name);
        ret = ret.replace('[[customer name and address]]', appt.Street_Address__c != null || appt.City__c!= null || appt.Postal_Code__c != null || appt.State__c!= null ? '' : EventService.constructAppointmentEventLocation(appt, ' '));
        ret = ret.replace('[[appointment date and time]]', String.valueOf(appt.Appointment_Date_and_Time__c == null ? '' : appt.Appointment_Date_and_Time__c.format('dd/MM/yyyy hh:mm a')));
        return ret;
    }

}
