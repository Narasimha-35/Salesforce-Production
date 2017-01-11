public class Finance 
{
public String cdtypefinance {get ;set ;}
public String cdloanpurpose {get ;set ;}


public String createFinanceXml()
{
 String XML ='<finance><cd_type_finance>'+cdtypefinance+'</cd_type_finance><cd_loan_purpose>'+cdloanpurpose +'</cd_loan_purpose></finance>';
 
 return XML ;

}

}