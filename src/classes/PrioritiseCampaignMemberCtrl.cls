/**
 * Author: Anthony Xuan
 * Create Date: 18/01/2016
 */

public class PrioritiseCampaignMemberCtrl {
   public String postcodeFrom {get; set;}
   public String postcodeTo {get; set;}
   public String priority {get; set;}
   public Integer selectedCallFileMemberSize {get; set;}
   @testvisible
   private String query {get; set;}
   public Id selectedCallFileId {get; set;}
   @testvisible
   private List<vhc__Campaign__c> callFiles = CallFileService.getAllCallFiles();
   public List<SelectOption> callFileOptions {
      get {
         return CallFileService.getCallFileSelectionOptions(callFiles);
      }
   }
   public List<SelectOption> priorityOptions {
      get {
         return CallFileMemberService.getPrioritySelectOption();
      }
   }
   public Boolean showPrioritise {
       get {
           return selectedCallFileMemberSize > 0;
       }
   }

   public PrioritiseCampaignMemberCtrl() {
      postcodeFrom = '';
      postcodeTo = '';
      selectedCallFileMemberSize = 0;
      query = '';
   }

   public void searchCallFileMembers() {
      cleanInputs();
      if(!validatePostcode(postcodeFrom) || !validatePostcode(postcodeTo)) {
          addErrorMessage(ApexPages.severity.ERROR, 'please check postcode input!');
          return;
      }
      vhc__Campaign__c selectedCallFile = (new Map<Id, vhc__Campaign__c>(callFiles)).get(selectedCallFileId);
      selectedCallFileMemberSize = CallFileMemberService.getCallFileMemberByCallFileAndPostcodeCount(selectedCallFile, postcodeFrom, postcodeTo, priority);
      query = CallFileMemberService.getSOQLQuery(selectedCallFile, postcodeFrom, postcodeTo, priority);
   }

   public void updateCallFileMembers() {
      if(selectedCallFileMemberSize != 0) {
        BatchPrioritiseCallFileMember cfBatch = new BatchPrioritiseCallFileMember(query, priority, true);
        Database.executeBatch(cfBatch, 200);
        selectedCallFileMemberSize = 0;
        query = '';
      }
   }

   public void addErrorMessage(ApexPages.severity severity, String msg) {
      ApexPages.addmessage(new ApexPages.message(severity, msg));
   }

   public void cleanInputs() {
      postcodeFrom = String.escapeSingleQuotes(postcodeFrom.trim());
      postcodeTo = String.escapeSingleQuotes(postcodeTo.trim());
   }

   public boolean validatePostcode(String postcode) {
      Pattern postcodePattern = Pattern.compile('^[0-9]{4}');
      Matcher postcodeMatcher = postcodePattern.matcher(postcode);
      return postcodeMatcher.matches();
   }

}
