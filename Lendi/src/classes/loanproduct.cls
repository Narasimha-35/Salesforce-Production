public class loanproduct
{


public Double  amloanamount {get ;set ;}

public Double  cdrepayment {get ;set ;}
public String cdinterestonlytype{get ;set ;}
public String createLoanProductXML()
{
    String XMl ='<loan_product><cd_group>Pepper</cd_group><cd_product>Prime</cd_product><am_loan_amount>'+amloanamount+'</am_loan_amount>';
     XMl =XMl + '<fg_hold_fixed>FALSE</fg_hold_fixed><no_loan_term>30</no_loan_term>';
     XMl =XMl + '<cd_loan_term_type>Years</cd_loan_term_type>';
     XMl =XMl + '<cd_interest_only_type>'+cdinterestonlytype+'</cd_interest_only_type>';
     XMl =XMl + '<cd_repayment_frequency>Monthly</cd_repayment_frequency>' ;
     XMl =XMl + '<cd_repayment>'+cdrepayment+'</cd_repayment>';
     XMl =XMl + '</loan_product>';
     
     RETURN XML;
             
     
    
    
}
}