/**
 * Author: Anthony Xuan
 * Create Date: 19/01/2016
 */

public class CallFileMemberService {

   public static String getSOQLQuery(vhc__Campaign__c callFiles, String postcodeFrom, String postcodeTo, String newPriority) {
      CallFileMemberSelector cfms = new CallFileMemberSelector(new Set < String > {'PostCode__c', 'Update_Priority_By_Postcode__c', 'vhc__Priority__c'}, null);
      return cfms.getQueryPartOne() + getSOQLCondition(callFiles, postcodeFrom, postcodeTo, newPriority);
   }
   
   public static String getSOQLCondition(vhc__Campaign__c callFiles, String postcodeFrom, String postcodeTo, String newPriority) {
      return 'WHERE PostCode__c != null AND vhc__Priority__c != \'' + newPriority + '\' AND Update_Priority_By_Postcode__c != true AND PostCode__c >= ' + postcodeFrom + ' AND PostCode__c <= ' + postcodeTo  + ' AND vhc__Campaign__c = \'' + callFiles.id + '\''; 
   }

   public static Integer getCallFileMemberByCallFileAndPostcodeCount(vhc__Campaign__c callFiles, String postcodeFrom, String postcodeTo, String newPriority) {
      CallFileMemberSelector cfms = new CallFileMemberSelector();
      return cfms.selectCountByOpenCondition(getSOQLCondition(callFiles, postcodeFrom, postcodeTo, newPriority));
   }

   public static void updatePriority(List < vhc__Campaign_Member__c > records, String priority, Boolean isByPostcode) {
      CallFileMemberDomain cfmd = new CallFileMemberDomain(records);
      cfmd.updatePriority(priority, isByPostcode);
      cfmd.commitUpdate();
   }

   public static List < SelectOption > getPrioritySelectOption() {
      List < Schema.PicklistEntry > plel = CallFileMemberDomain.getPickListItem('vhc__Priority__c');
      return CallFileMemberDomain.generateSelectOptionByPickListEntry(plel);
   }

}