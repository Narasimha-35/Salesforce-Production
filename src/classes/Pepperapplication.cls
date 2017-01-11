public class Pepperapplication 
{
public String noadults {get ;set ;}
public String nochildren {get ;set ;}
public String txbrand {get ;set ;}
public String nomthscurrent  {get ;set ;}
public String no6mths {get ;set ;}
public String nolvr {get ;set ;}
public String doctype {get ;set ;}


public String createPepperapplicationXml()
{
     String xml = '<pepper_application><loan_details><no_adults>'+noadults+'</no_adults><no_children>'+nochildren+'</no_children>' ;
    xml = xml + '<tx_brand>ClickLoans1</tx_brand><cd_loan_documentation>'+doctype+'</cd_loan_documentation></loan_details><mortgage_arrears>';
    xml =xml + '<no_mths_current>'+nomthscurrent+'</no_mths_current>';
    xml = xml +  '<no_6mths>'+no6mths+'</no_6mths>' ;
    xml = xml +  '</mortgage_arrears><finance_details><no_lvr>'+nolvr+'</no_lvr></finance_details></pepper_application>' ;
    
    return xml;
    
    
}


}