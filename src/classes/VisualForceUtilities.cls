public with sharing class VisualForceUtilities {

	public static pagereference cancel(Id currentAppointmentId) {
      PageReference pageRef = new PageReference('/'+currentAppointmentId );
      return pageRef;
   }

}
