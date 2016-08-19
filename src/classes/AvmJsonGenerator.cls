public class AvmJsonGenerator 
{
public AvmJsonGenerator()
{
    
   // Setting default values for AVM.
   propertyid = '';
   bathrooms = '0';
   bedrooms = '0';
   carSpaces = '0';
   craftsmanshipQuality = 'MUCH_BETTER';
   floorAreaM2 = '0';
   landAreaM2 = '0';
   propertyType = 'BUSINESS';
   saleDate = '';
   salePrice = '0';
   valuationDate = '';
   yearBuilt = '0';
}   
 public String bathrooms {
  get;
  set;
 }
 public String bedrooms {
  get;
  set;
 }
 public String carSpaces {
  get;
  set;
 }
 public String craftsmanshipQuality {
  get;
  set;
 }
 public String floorAreaM2 {
  get;
  set;
 }
 public String landAreaM2 {
  get;
  set;
 }
 public String propertyType {
  get;
  set;
 }
 public String saleDate {
  get;
  set;
 }
 public String salePrice {
  get;
  set;
 }
 public String valuationDate {
  get;
  set;
 }
  public String propertyId{
  get;
  set;
 }
  public String yearBuilt {
  get;
  set;
 }
 
  public String avmJson() {

  String propertyJson = ' {"propertyId": ' + propertyId+ ' ,"targetPropertyAvmInput": { "bathrooms": ' + bathrooms + ', "bedrooms": ' + bedrooms + ',"carSpaces": ' + carSpaces + ', "craftsmanshipQuality": "' + craftsmanshipQuality + '","floorAreaM2": ' + floorAreaM2 + ',"landAreaM2": ' + landAreaM2 + ',' +
   +' "propertyType": "' + propertyType + '",' +
   +'"saleDate": "' + saleDate + '",' +
   +'"salePrice": ' + salePrice + ',' +
   +'  "valuationDate": "' + valuationDate + '",' +
   +' "yearBuilt": ' + yearBuilt + '}' +
   +'}';

  return propertyJson;
 }

}