public class clsVedaController{

public String clientReference {  get ; set ;}
public String operatorid {  get ; set ;}
public String operatorname {  get ; set ;}
public String permissiontypecode {  get ; set ;}
public String productdatalevelcode {  get ; set ;}
public List<String> scorecardid {  get ; set ;}

public String title {  get ; set ;}
public String familyname {  get ; set ;}
public String firstgivenname {  get ; set ;}
public String othergivenname {  get ; set ;}

public String  unformattedaddres {get ;set;}

public String  gendercode {get ;set;}
public String  name {get ;set;}

public String accounttypecode {get ;set ;}

public String enquiryamount {get ;set ;}
public Integer  relationshipcode {get ;set ;}

public String enquiryclientreference {get ;set ;}
public String UserName {get ;set ;} 
public String PassWord {get ;set ;} 


public String  getXML(){
 if(operatorid == null)
    operatorid ='';
       if(operatorname == null)
             operatorname ='';
         if(   title == null)
            title ='';    
     if(enquiryclientreference == null)
          enquiryclientreference ='';  
       if(othergivenname == null)
          othergivenname ='';

STring XMl =    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-10.xsd" xmlns:ved="http://vedaxml.com/vxml2/vedascore-apply-v2-0.xsd">';
   XMl = XMl + '<soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"> ' ;
      XMl = XMl + '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"> ';
       XMl = XMl +     '<wsse:UsernameToken> ';
          XMl = XMl +     '<wsse:Username>'+Username+'</wsse:Username>';
         XMl = XMl +     '<wsse:Password>'+PassWord+'</wsse:Password>';
           XMl = XMl +  '</wsse:UsernameToken>';
       XMl = XMl +  '</wsse:Security>';
     XMl = XMl +  '<wsa:Action>http://vedaxml.com/vedascore-apply/EnquiryRequest</wsa:Action>';
    XMl = XMl + '</soapenv:Header>';
 XMl = XMl + '<soapenv:Body>';
      XMl = XMl +  '<ved:request>';
         XMl = XMl +  '<ved:enquiry-header>';
          XMl = XMl +    '<ved:client-reference>'+clientReference+'</ved:client-reference>';
         
        
         XMl = XMl +    '<ved:operator-id>'+operatorid+'</ved:operator-id>';
      
             XMl = XMl +       '<ved:operator-name>'+operatorname+'</ved:operator-name>';
           // <!--Next 2 options are set based on your access type-->
            XMl = XMl +    '<ved:permission-type-code>'+permissiontypecode+'</ved:permission-type-code>';
           XMl = XMl +  '<ved:product-data-level-code>'+productdatalevelcode+'</ved:product-data-level-code>';
          //  <!--Requested score cards are optional-->
          //  <!--If this is omitted the default scorecard for your access level will be selected-->
        XMl = XMl +    '<ved:requested-scores>';
           // <!--<ved:scorecard-id>VSA_2.0_X_CR</ved:scorecard-id>-->
           // <!--<ved:scorecard-id>VSA_2.0_X_NR</ved:scorecard-id>-->
           // <!--<ved:scorecard-id>VS_1.1_X_NR</ved:scorecard-id>-->
           if(scorecardid != null) {
            for(String values : scorecardid){
             XMl = XMl + '<ved:scorecard-id>'+values +'</ved:scorecard-id> ';
            }
            }
           
          
            XMl = XMl +  '</ved:requested-scores>';
          XMl = XMl + '</ved:enquiry-header>';
         XMl = XMl + '<ved:enquiry-data>';
          //  <!--A request by made using the bureau ID if knokwn-->
           // <!--<ved:bureau-reference>?</ved:bureau-reference>-->
            XMl = XMl + '<ved:individual>';
             XMl = XMl +   '<ved:current-name>';
      
              XMl = XMl +     '<ved:title>'+ title+'</ved:title>';
                 XMl = XMl +   '<ved:family-name>'+familyname+'</ved:family-name>';
                 XMl = XMl +  '<ved:first-given-name>'+firstgivenname+'</ved:first-given-name>';
                
                
                  XMl = XMl +  '<ved:other-given-name>'+othergivenname+'</ved:other-given-name>';
              XMl = XMl +   '</ved:current-name>';
              // <!--Previous name is optional-->
              // <!--<ved:previous-names>-->
              // <!--<ved:previous-name>-->
              // <!--<ved:title>MRS</ved:title>-->
              // <!--<ved:family-name>REEVS</ved:family-name>-->
              // <!--<ved:first-given-name>JULIE</ved:first-given-name>-->
              // <!--<ved:other-given-name>JAMES</ved:other-given-name>-->
              // <!--</ved:previous-name>-->
             //  <!--</ved:previous-names>-->
              XMl = XMl +  '<ved:addresses>';
                XMl = XMl +   '<ved:address type="C" time-at-address="180">';
                XMl = XMl + '<ved:unformatted-address>'+unformattedaddres+'</ved:unformatted-address>';
                   
                XMl = XMl +   '</ved:address>';
                 
               XMl = XMl + '</ved:addresses>';
              
             XMl = XMl +   '<ved:gender-code>'+gendercode+'</ved:gender-code>';
            
             XMl = XMl +   '<ved:employment>';
             XMl = XMl +      '<ved:employer type="C">';
              XMl = XMl +        '<ved:name>'+name+'</ved:name>';
                   
                 XMl = XMl +   '</ved:employer>';
              XMl = XMl +   '</ved:employment>';
            XMl = XMl +  '</ved:individual>';
           XMl = XMl +   '<ved:enquiry>';
            XMl = XMl +     '<ved:account-type-code>'+accounttypecode+'</ved:account-type-code>';
             XMl = XMl +  '<ved:enquiry-amount currency-code="AUD">'+enquiryamount+'</ved:enquiry-amount>';
            XMl = XMl +   '<ved:relationship-code>'+relationshipcode+'</ved:relationship-code>';
            
             
                  XMl = XMl +  '<ved:enquiry-client-reference>'+enquiryclientreference+'</ved:enquiry-client-reference>';
            XMl = XMl +'</ved:enquiry>';
        XMl = XMl + '</ved:enquiry-data>';
      XMl = XMl + '</ved:request>';
  XMl = XMl + '</soapenv:Body>';
XMl = XMl + '</soapenv:Envelope>'; 

   /* Xmlstreamwriter xmlW = new Xmlstreamwriter();
xmlW.writeStartElement('soapenv', 'Envelope','');
xmlW.writeAttribute('xmlns', '', 'soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
xmlW.writeAttribute('xmlns', '', 'vh', 'http://vedaxml.com/soap/header/v-header-v1-10.xsd');
xmlW.writeAttribute('xmlns', '', 'ved', 'http://vedaxml.com/vxml2/vedascore-apply-v2-0.xsd');
xmlW.writeStartElement('soapenv', 'Header','');
 

xmlW.writeAttribute('xmlns', '', 'wsa', 'http://www.w3.org/2005/08/addressing');
 xmlW.writeStartElement('wsa', 'Action','');
 xmlW.writeCharacters('http://vedaxml.com/vedascore-apply/EnquiryRequest');
 xmlW.writeEndElement();
    xmlW.writeStartElement('wsse', 'Security','');
    xmlW.writeAttribute('xmlns', '', 'wsse', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
        xmlW.writeStartElement('', 'UsernameToken','');
            
            xmlW.writeStartElement('wsse', 'Username','');
            xmlW.writeCharacters('Username');
            xmlW.writeEndElement();
            
            xmlW.writeStartElement('wsse', 'PassWord','');
            xmlW.writeCharacters('PassWord');
            xmlW.writeEndElement();

        xmlW.writeEndElement();
    xmlW.writeEndElement();
xmlW.writeEndElement();


xmlW.writeStartElement('soapenv', 'Body','');
xmlW.writeStartElement('ved', 'request','');
    xmlW.writeStartElement('ved', 'enquiry-header','');
         xmlW.writeStartElement('ved', 'client-reference','');
         xmlW.writeCharacters(clientreference);
         
         xmlW.writeEndElement();
         xmlW.writeStartElement('ved', 'operator-id','');
         xmlW.writeCharacters(operatorid);
         
         xmlW.writeEndElement();
         xmlW.writeStartElement('ved', 'operator-Name','');
         xmlW.writeCharacters(operatorName);
         
         xmlW.writeEndElement();
         xmlW.writeStartElement('ved', 'permission-type-code','');
         xmlW.writeCharacters('YX');
         
         xmlW.writeEndElement();
          xmlW.writeStartElement('ved', 'product-data-level-code','');
         xmlW.writeCharacters('C');
         
         xmlW.writeEndElement();
         
          xmlW.writeStartElement('ved', 'requested-scores','');
               xmlW.writeStartElement('ved', 'scorecard-id','');
                if(scorecardid != null) {
                for(String values : scorecardid){
                 xmlW.writeCharacters(values);
                 }
                }
               xmlW.writeEndElement();  
         xmlW.writeEndElement();
xmlW.writeStartElement('ved', 'enquiry-data','');  
         xmlW.writeStartElement('ved', 'individual','');
                   xmlW.writeStartElement('ved', 'current-name','');
                           xmlW.writeStartElement('ved', 'title','');
                               xmlW.writeCharacters(title);
                            xmlW.writeEndElement();
                             xmlW.writeStartElement('ved', 'family-name','');
                               xmlW.writeCharacters(familyname);
                            xmlW.writeEndElement();
                             xmlW.writeStartElement('ved', 'first-given-name','');
                               xmlW.writeCharacters(firstgivenname);
                            xmlW.writeEndElement();
                             xmlW.writeStartElement('ved', 'other-given-name','');
                               xmlW.writeCharacters(othergivenname);
                            xmlW.writeEndElement();
                    xmlW.writeEndElement();
         xmlW.writeEndElement();
         xmlW.writeStartElement('ved', 'addresses','');
             xmlW.writeStartElement('ved', 'address','');
             xmlW.writeAttribute('', '', 'type', 'C');
             xmlW.writeAttribute('', '', 'time-at-address', '180');
                     xmlW.writeStartElement('ved', 'unformatted-address','');
                         xmlW.writeCharacters(unformattedaddres);
                     xmlW.writeEndElement();    
              xmlW.writeEndElement();
         xmlW.writeEndElement();
         xmlW.writeStartElement('ved', 'gender-code','');
             xmlW.writeCharacters(gendercode);
          xmlW.writeEndElement();
          xmlW.writeStartElement('ved', 'employment','');
                xmlW.writeStartElement('ved', 'employer','');
                xmlW.writeAttribute('', '', 'type', 'C');
                    xmlW.writeStartElement('ved', 'name','');
                      xmlW.writeCharacters(name);
                     xmlW.writeEndElement();
                xmlW.writeEndElement();
          
          xmlW.writeEndElement();
xmlW.writeEndElement();
          xmlW.writeStartElement('ved', 'enquiry',''); 
                  xmlW.writeStartElement('ved', 'account-type-code','');
                      xmlW.writeCharacters(accounttypecode);
                     xmlW.writeEndElement();
                      xmlW.writeStartElement('ved', 'enquiry-amount','');
                      xmlW.writeCharacters(enquiryamount);
                     xmlW.writeEndElement();
                     xmlW.writeStartElement('ved', 'relationship-code','');
                      xmlW.writeCharacters(STring.valueof(relationshipcode));
                     xmlW.writeEndElement();
                      xmlW.writeStartElement('ved', 'enquiry-client-reference','');
                      xmlW.writeCharacters(String.valueof(relationshipcode));
                     xmlW.writeEndElement();
            xmlW.writeEndElement();
xmlW.writeEndElement();
xmlW.writeEndElement();
xmlW.writeEndElement();
xmlW.writeEndElement();
System.debug('The XML :'+xmlW.getXmlString()); */


return xml ;
    
}

}