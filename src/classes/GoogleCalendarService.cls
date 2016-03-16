global with sharing class GoogleCalendarService {
	public static List<SFModel.DebugEmailRequest> DebugEmailRequests = new List<SFModel.DebugEmailRequest>();

	public static void insertGoogleEvent(List<String> ids) {
		try {
			GoogleCalendarUtility.insertGoogleEvent(ids);
		} catch (GoogleCalendarUtility.SyncException se) {
			//Send Email
		} catch (Exception e) {
			GoogleCalendarService.addDebugEmailRequest('insertGoogleEvent', e.getMessage());
		} finally {
			GoogleCalendarService.sendEmail();
		}

	}

	//TODO: need handle rollback, separate google from database
	//TODO: handle ignore error
	public static void upsertGoogleEvents(List<Broker__c> bl) {
		Saasfocus_GoogleSyncEvent gse = new Saasfocus_GoogleSyncEvent();
		try {
			gse.InsertEventslist(bl);
		} catch (Saasfocus_GoogleSyncEvent.InsertEventslist1Exception e1) {
			//Send Email
		} catch (Saasfocus_GoogleSyncEvent.InsertEventslist2Exception e2) {
			//Send Email
		} catch (Exception e) {
			GoogleCalendarService.addDebugEmailRequest('upsertGoogleEvents', e.getMessage());
		} finally {
			GoogleCalendarService.sendEmail();
		}
	}

	//TODO: need handle rollback, separate google from database
	Webservice static void deleteGoogleEvent(String objectName, Id rid) {
		if(objectName == 'Appointment') {
			try{
				Chen_GoogleCalenderHelper.deleteEventByAppointment(rid);
			} catch(Chen_GoogleCalenderHelper.DeleteEventException e1) {
				//Send Email
			} catch(Exception e) {
				GoogleCalendarService.addDebugEmailRequest('deleteGoogleEvent', e.getMessage());
			} finally {
				GoogleCalendarService.sendEmail();
			}
		}
	}

	public static List<Saasfocus_EventClass> getEventslist(DateTime StartDateTime ,DateTime EndDateTime, String BrokerId) {
		Saasfocus_GetGoogleEvent gge = new Saasfocus_GetGoogleEvent();
		try{
			return gge.getEventslist(StartDateTime, EndDateTime, BrokerId);
		} catch (Saasfocus_GetGoogleEvent.getEventslist1Exception e1) {

		} catch (Saasfocus_GetGoogleEvent.getEventslist2Exception e2) {

		} catch (Exception e) {
			GoogleCalendarService.addDebugEmailRequest('insertGoogleEvent', e.getMessage());
		} finally {
			GoogleCalendarService.sendEmail();
		}
		return null;
	}

	public static void sendEmail() {
		if((Boolean) ACFSwitch__c.getOrgDefaults().get('GoogleCalendarEmailSwitch__c')) {
			system.debug(LoggingLevel.INFO, '[GoogleCalendarService] Sending Email to subscribers...');
			for(SFModel.DebugEmailRequest req : DebugEmailRequests) {
				String body = Utilities.generateHTMLEmailBody(req.projectName, req.className, req.methodName, req.detail);
				Utilities.sendEmail(req.recipients, req.subject, body);
			}
		}
	}

	public static void addDebugEmailRequest(String methodName, String detials) {
		GoogleCalendarUtility.addDebugEmailRequest('GoogleCalendarService', methodName, detials, null, null);
	}
}
