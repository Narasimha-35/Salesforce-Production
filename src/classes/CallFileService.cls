/**
 * Author: Anthony Xuan
 * Create Date: 21/01/2016
 */
public class CallFileService {

   public static List<vhc__Campaign__c> getAllCallFiles() {
      CallFileSelector cfs = new CallFileSelector();
      return cfs.getByOpenCondition('');
   }
   
   public static List<SelectOption> getCallFileSelectionOptions(List<vhc__Campaign__c> callFiles) {
    List<SelectOption> ret = new List<SelectOption>();
    for(vhc__Campaign__c cf : callFiles) {
            ret.add(new SelectOption(cf.id, cf.name));
    }
    return ret;
   }

}