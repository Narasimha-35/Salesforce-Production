public  class Applicant
{
    
public string Applicantcdtype {get ;set ;}
    

public String cdtitle {get ;set ;}
public String  nmfirstname {get ;set ;}
public String  nmsurname {get ;set ;}
public String  cdgender {get ;set ;}
public String  cdstsmarital {get ;set ;}
public String  ctdependants {get ;set ;}
public String  cdcitizenship {get ;set ;}
public String  noage {get ;set ;}

public String  cdstatusresidential {get ;set ;}
public String  nmsuburb {get ;set ;}
public String  cdstate {get ;set ;}
public String  cdpostcode {get ;set ;}
public String  cdcountry {get ;set ;}


public String  idcustomerexisting {get ;set ;}

public String  cdstatus {get ;set ;}
public String  noabnmonths {get ;set ;}
public String  fggstregistered {get ;set ;}
public String  nogstmonths  {get ;set ;}

public String  applicantincomeXML  {get ;set ;}
public String  applicantExpancexml  {get ;set ;}
public String  assetApplicantXml  {get ;set ;}
public String  ABN  {get ;set ;}



public String CreateApplicantXml(String VedaMXL){
    
    String xml ='<applicant cd_type="'+Applicantcdtype+'">';
    xml = xml + '<individual><cd_title>'+cdtitle+'</cd_title>';
    xml = xml + '<nm_firstname>'+ nmfirstname+'</nm_firstname>';
    xml = xml + '<nm_surname>'+nmsurname+'</nm_surname>';
    xml = xml + '<cd_gender>'+cdgender+'</cd_gender>';
    xml = xml + '<cd_sts_marital>'+cdstsmarital+'</cd_sts_marital>';
    xml = xml + '<ct_dependants>'+ctdependants+'</ct_dependants>';
    xml = xml + '<cd_citizenship>'+cdcitizenship+'</cd_citizenship>';
    xml = xml + '<no_age>'+noage+'</no_age>';
    xml = xml + '</individual><address><current_address><cd_status_residential>'+cdstatusresidential+'</cd_status_residential>';
    xml = xml + '<nm_suburb>'+nmsuburb+'</nm_suburb>' ;
    xml = xml + '<cd_state>'+cdstate+'</cd_state>' ;
    xml = xml + '<cd_postcode>'+ cdpostcode+'</cd_postcode>';
    xml = xml + '<cd_country>'+cdcountry+'</cd_country>';
    xml = xml + '</current_address></address><existing_customer><id_customer_existing>'+idcustomerexisting+'</id_customer_existing></existing_customer>';
    xml = xml + '<employment><current_employment><cd_status>PAYG</cd_status></current_employment></employment>';
    String abnvalue = '';
        if(ABN  != '')
        abnvalue =  '<tx_abn>'+ABN  +'</tx_abn>';
    xml = xml + '<pepper_applicant><self_employed>'+abnvalue +'</self_employed></pepper_applicant>' ;
    abnvalue ='';
    xml = xml + applicantincomeXML ;
    xml = xml + applicantExpancexml ;
    xml = xml + assetApplicantXml;
    
    xml = xml + '<result><bureau_list><bureau id="VedaScore Apply"><id_bureau>BCA</id_bureau><nm_product>veda_connect_score</nm_product><id_service>VDA001</id_service><dt_enquiry>9/08/2016 2:14:20 PM</dt_enquiry><nm_schema_display>vsa-html.xslt</nm_schema_display><no_seconds>2.80</no_seconds><tx_data_bureau>' +VedaMXL+ '</tx_data_bureau></bureau></bureau_list></result></applicant>';
    
    return xml;
    
}



}