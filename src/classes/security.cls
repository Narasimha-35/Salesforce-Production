public class security {
    
    
    public String  IdNumber  {get  ; set ;}
    public Double  amamount {get  ; set ;}
    public Double  amestimatedvalue {get  ; set ;}
    
    public String  status {get  ; set ;}
    
    public String txunformattedaddress {get ;set  ;}
    public String txsuburb{get;set;}
    public String cdstate{get;set;}
    public String nopostcode{get;set;}
    public String cdtypeproperty {get ;set  ;}
    public String cdtypeownership {get ;set  ;}
    public String cdtypetitle{get ;set  ;}
    public String txpurchaseprice{get ;set  ;}
    
    
    public String createSecurityXml ( ){
        
        String xml = '<security id= "'+IdNumber+'">';
        xml =xml +  '<cd_type>Property</cd_type>';
           //xml =xml +           '<cd_type_title>'+cdtypetitle+'</cd_type_title>';
         //xml =xml +     '<tx_purchase_price>'+txpurchaseprice+'</tx_purchase_price>';
        xml =xml +  '<am_amount>'+amamount+'</am_amount>';
        xml =xml +  '<details><property><address><tx_unformatted_address>'+txunformattedaddress+'</tx_unformatted_address><tx_suburb>'+txsuburb+'</tx_suburb><cd_state>'+cdstate+'</cd_state><no_postcode>'+nopostcode+'</no_postcode></address><cd_type_property>';
        xml =xml +  cdtypeproperty+'</cd_type_property><cd_type_ownership>'+cdtypeownership+'</cd_type_ownership><cd_type_title>'+cdtypetitle+'</cd_type_title><tx_purchase_price>'+txpurchaseprice+'</tx_purchase_price>';
        xml =xml +  '</property></details><am_estimated_value>'+amestimatedvalue+'</am_estimated_value>';
        xml =xml +  '<status>'+status+'</status></security>';
        return xml;
    }
}