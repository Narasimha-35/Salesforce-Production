public class SObjectUtility {

   public static List<SObject> getSObjectListFromListById(List<SObject> sol, List<Id> ids) {
      Map<Id, SObject> soMap = new Map<Id, SObject>(sol);
      List<SObject> ret = new List<SObject>();

      for(Id e : ids) {
         ret.add(soMap.get(e));
      }
      return ret;
   }

}
