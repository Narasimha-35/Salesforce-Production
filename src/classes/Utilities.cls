global class Utilities {
  public static final String FIELD_NAME = 'fieldName';
  public static final String SOBJECT_NAME= 'sobjectName';
  public static final String SOBJECT_TYPE = 'sobjectType';
  public static final Map<String, String> stateTimeZoneMap;
  static{
    stateTimeZoneMap = new Map<String, String>();
    stateTimeZoneMap.put('WA', '(UTC+08:00) Perth');
    stateTimeZoneMap.put('NSW', '(UTC+10:00) Canberra, Melbourne, Sydney');
    stateTimeZoneMap.put('VIC', '(UTC+10:00) Canberra, Melbourne, Sydney');
    stateTimeZoneMap.put('ACT', '(UTC+10:00) Canberra, Melbourne, Sydney');
    stateTimeZoneMap.put('NT', '(UTC+09:30) Darwin');
    stateTimeZoneMap.put('QLD', '(UTC+10:00) Brisbane');
    stateTimeZoneMap.put('SA', '(UTC+09:30) Adelaide');
    stateTimeZoneMap.put('TAS', '(UTC+10:00) Hobart');
  }

  public static void updateTimezoneOnLead(Lead lead) {
    if (lead.PostalCode == null || lead.PostalCode == '' || !lead.PostalCode.isNumeric()) {
      if(lead.stateCode == null || lead.stateCode == '') {
        lead.vhc__TimeZone__c = '(UTC+08:00) Perth';
      } else {
        lead.vhc__TimeZone__c = stateTimeZoneMap.get(lead.stateCode);
      }
    } else {
      Integer postcodeInt = Integer.valueOf(lead.PostalCode);
      System.debug(postcodeInt);
      if(postcodeInt > 0 && postcodeInt < 800) {
        lead.vhc__TimeZone__c = '(UTC+10:00) Canberra, Melbourne, Sydney';
      } else if (postcodeInt >= 800 && postcodeInt <= 899) {
        //NSW/VIC/ACT
        lead.vhc__TimeZone__c = '(UTC+09:30) Darwin';
      } else if (postcodeInt > 899 && postcodeInt <= 3999) {
        lead.vhc__TimeZone__c = '(UTC+10:00) Canberra, Melbourne, Sydney';
      } else if (postcodeInt >= 4000 && postcodeInt <= 4999) {
        lead.vhc__TimeZone__c = '(UTC+10:00) Brisbane';
      } else if (postcodeInt >= 5000 && postcodeInt <= 5999) {
        lead.vhc__TimeZone__c = '(UTC+09:30) Adelaide';
      } else if (postcodeInt == null) {
        lead.vhc__TimeZone__c = '(UTC+08:00) Perth';
      } else {
        lead.vhc__TimeZone__c = '(UTC+08:00) Perth';
      }
    }
  }

  public static list<SelectOption> getPicklistValues(SObject obj, String fld) {
    list<SelectOption> options = new list<SelectOption>();
    // Get the object type of the SObject.
    Schema.sObjectType objType = obj.getSObjectType();
    // Describe the SObject using its object type.
    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
    // Get a map of fields for the SObject
    map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
    // Get the list of picklist values for this field.
    list<Schema.PicklistEntry> values =
    fieldMap.get(fld).getDescribe().getPickListValues();
    // Add these values to the selectoption list.
    for (Schema.PicklistEntry a : values) {
      options.add(new SelectOption(a.getLabel(), a.getValue()));
    }
    return options;
  }

  public static list<String> getAllFieldsFromSObject(String objectName) {
    SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
    DescribeSObjectResult objDef = objToken.getDescribe();
    Map<String, SObjectField> fields = objDef.fields.getMap();
    List<String> fieldName = new List<String>();
    Set<String> fieldSet = fields.keySet();
    for(String s:fieldSet) {
      SObjectField fieldToken = fields.get(s);
      DescribeFieldResult selectedField = fieldToken.getDescribe();
      //System.debug(selectedField.getName()); // field name
      fieldName.add(objectName + '.' + selectedField.getName() + '#' + selectedField.getType());
      //System.debug(selectedField.getType()); // field type
    }
    return fieldName;
  }

  public static list<SelectOption> getSObjectFieldAsSelectOptions(String sObjectName) {
    List<String> fieldNames = getAllFieldsFromSObject(sObjectName);
    list<SelectOption> options = new list<SelectOption>();
    for (String fieldName : fieldNames) {
      options.add(new SelectOption(fieldName, fieldName));
    }
    return options;
  }

  public static list<SelectOption> getCallFileSelectOptions() {
    list<vhc__Campaign__c> callfiles = CallFileDAO.getAllCallFiles();
    list<SelectOption> options = new list<SelectOption>();
    if (callfiles.size() > 0) {
      for (vhc__Campaign__c callFile : callfiles) {
        options.add(new SelectOption(callFile.Id, callFile.Name));
      }
    }
    return options;
  }

  //Change to get Object info with flag in it
  public static String getObjectInfo(String input, String typeInfo) {
    if (input != null) {
      List<String> parts1 = input.split('\\.');
      String b = parts1.get(1);
      List<String> parts2 = b.split('#');
      String fieldName = parts2.get(0);
      String sobjectName = parts1.get(0);
      String sobjectType = parts2.get(1);
      if (typeInfo == FIELD_NAME) {
        return fieldName;
      } else if (typeInfo == SOBJECT_NAME) {
        return sobjectName;
      } else if (typeInfo == SOBJECT_TYPE) {
        return sobjectType;
      }
      return null;
    }
    return null;
  }

  public static String getPardotUserKey() {
    String userKey = Credential__c.getValues('live').Pardot_User_Key__c;
    return userKey;
  }

  public static String getPardotUserPassword() {
    String userPassword = Credential__c.getValues('live').User_Password__c;
    return userPassword;
  }

  public static String getPardotUserEmail() {
    String userEmail = Credential__c.getValues('live').User_Email__c;
    return userEmail;
  }

  public static String getDNCRTeleMarketerId() {
    String teleMarketId = Credential__c.getValues('live').DNCR_Tele_Marketer_Id__c;
    return teleMarketId;
  }

  public static String getDNCRTeleMarketerPassword() {
    String teleMarketPassword = Credential__c.getValues('live').DNCR_Tele_Marketer_Password__c;
    return teleMarketPassword;
  }

  public static String getDNCRTEndUrlId() {
    String endUrl = Credential__c.getValues('live').DNCR_End_Url__c;
    return endUrl;
  }

  public static String byteAbbreviate(String stringToAbbreviate, Integer byteLength) {
    //First abbrevate using the character length. This will get us close
    stringToAbbreviate = stringToAbbreviate.abbreviate(byteLength);
    Integer abbLength = byteLength;
    while (Blob.valueOf(stringToAbbreviate).size() > byteLength) {
      abbLength = abbLength - 1;
      stringToAbbreviate = stringToAbbreviate.abbreviate(abbLength);
    }
    return stringToAbbreviate;
  }

  public static String accordingToFieldValueToReturnQuery(DNC_Wash_Rule__c rule) {
    String value = '';
    String objectFieldType = Utilities.getObjectInfo(rule.Api_Field_Name__c, Utilities.SOBJECT_TYPE);
    if (objectFieldType == 'STRING' || objectFieldType == 'TEXTAREA' || objectFieldType == 'PICKLIST' || objectFieldType == 'PHONE') {
      if (rule.Operator__c == 'contains with') {
        value = value + '\'%' + rule.Field_Value__c + '%\'';
      } else {
        value = value + '\'' + rule.Field_Value__c + '\'';
      }
    } else if (objectFieldType == 'INTEGER' || objectFieldType == 'DOUBLE' || objectFieldType == 'CURRENCY' || objectFieldType == 'PERCENT') {
      value = value + rule.Field_Value__c;
    } else if (objectFieldType == 'DATE') {
      value = value + rule.Field_Value__c;
    } else if (objectFieldType == 'DATETIME') {
      //String currentDateTime = LeadToCallFileUtilities.convertStringToDateTime(rule.Field_Value__c).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
      value = value + rule.Field_Value__c + 'T00:00:00Z';
    } else if (objectFieldType == 'BOOLEAN') {
      value = value + rule.Field_Value__c;
    }
    return value;
  }

  public static void generateAddressReport() {
    String txtToInsert = 'leadId, Street, City, PostalCode, full address' + ' \n';
    List<Lead> leads = new List<lead>();
    for (Lead lead : [select Id, name, State, City, PostalCode, street from lead where street != '' and PostalCode != '' and City != '' limit 10000]) {
      if (lead.Street != null && lead.Street != ''
      && lead.City != null && lead.City != ''
      && lead.PostalCode != null && lead.PostalCode != '') {
        String address = lead.Street + ' ' + lead.City + ' ' + lead.PostalCode;
        txtToInsert += lead.Id + ',' + lead.Street + ',' + lead.City + ',' + lead.PostalCode + ',' + address + '\n';
        lead.Sent_Address_To_Scrape_Hero__c = true;
        leads.add(lead);
      }
    }
    txtToInsert = txtToInsert.substring(0, txtToInsert.length() - 1);
    txtToInsert = txtToInsert.replaceAll('null', '');
    Document doc = new Document (Name = 'Address Report ' + '-'+ Datetime.now() + '.csv');
    doc.Description = 'Superannuation Report';
    doc.IsPublic = true;
    doc.FolderId = UserInfo.getUserId();
    doc.Body = Blob.valueOf(txtToInsert);
    insert doc;
    update leads;
    // if (report != null && report.reportBeans.size() > 0) {
    //   String txtToInsert = 'EmployeeID, WorkerType, EmployeePayPeriod, TotalGrossPay, SuperannuationCharges, AssignmentNumber' + ' \n';
    //   for (MonthlyPayrollTGenerationSchedule.SuperReportBean row : report.reportBeans) {
    //     txtToInsert += row.employeeId + ',' + row.workerType + ',' + row.employeePayPeriod + ',' + row.totalGrossPay + ',' + row.superannuationCharges + ',' + row.assignmentId + '\n';
    //   }
    // }
  }

  Webservice static void sendAppointmentConfirmEmail(Id apppointmentId) {
    EmailTemplate emailTemplate;
    List<String> emailAddress = new List<String>();
    if (apppointmentId != null) {
      //System.debug('reach here 1');
      Appointment__c appointment = [Select Id, Opp_Owner_Email__c, Appointment_Type__c, Appointment_Status__c, Broker_Email__c, Account_Id__c From Appointment__c Where Id = :apppointmentId];
      if (appointment.Opp_Owner_Email__c != null && appointment.Opp_Owner_Email__c != '') {
        emailAddress.add(appointment.Opp_Owner_Email__c);
      }
      System.debug(appointment.Appointment_Type__c + ' ' + appointment.Appointment_Status__c);
      try {
        if (appointment.Appointment_Type__c == 'Phone Appointment' && appointment.Appointment_Status__c != 'Cancelled' && appointment.Appointment_Status__c != 'Rescheduled') {
          //System.debug('reach here 2');
          emailTemplate = [select id, name, Subject, HtmlValue, Body from EmailTemplate where Name= 'Account Appointment Confirmation - Phone'];
        } else if (appointment.Appointment_Type__c != 'Phone Appointment' && appointment.Appointment_Status__c != 'Cancelled' && appointment.Appointment_Status__c != 'Rescheduled') {
          //System.debug('reach here 3');
          emailTemplate = [select id, name, Subject, HtmlValue, Body from EmailTemplate where Name= 'Account Appointment Confirmation (V1)'];
        }
      } catch (Exception e) {
        System.debug(e);
      }
      if (emailTemplate != null && appointment != null) {
        //check if appointment is null or not
        //System.debug('reach here 4');
        Account personAccount = [Select Id, Name, PersonContactId From Account Where Id = :appointment.Account_Id__c];
        String contactId = personAccount.PersonContactId;
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        //email.setToAddresses(emailList);
        email.saveAsActivity = false;
        email.setTemplateId(emailTemplate.Id);
        email.setWhatId(apppointmentId);
        email.setTargetObjectId(contactId);
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        Database.rollback(sp);
        String mailTextBody = email.getPlainTextBody();
        String mailHtmlBody = email.getHTMLBody();
        String mailSubject = email.getSubject();
        Messaging.Singleemailmessage emailWithActivityTracking = new Messaging.Singleemailmessage();
        emailWithActivityTracking.saveAsActivity = true;
        emailWithActivityTracking.setSubject(mailSubject);
        emailWithActivityTracking.setPlainTextBody(mailTextBody);
        emailWithActivityTracking.setHtmlBody(mailHtmlBody);

        try {
          emailWithActivityTracking.setCcAddresses(emailAddress);
          OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'appointments@creditandfinance.com.au'];
          if ( owea.size() > 0 ) {
            emailWithActivityTracking.setOrgWideEmailAddressId(owea.get(0).Id);
          }
          //emailWithActivityTracking.setReplyTo('appointments@creditandfinance.com.au');
          //emailWithActivityTracking.setSenderDisplayName('Appointment From ACF');
          List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
          for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :emailTemplate.Id])
          {
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
          }
          emailWithActivityTracking.setFileAttachments(fileAttachments);
          //emailWithActivityTracking.setToAddresses(emailList);
          emailWithActivityTracking.setTargetObjectId(contactId);
          //PardotActivitiesUtilities.sendOneToOneEmailFromPardot(emailAddress, mailTextBody, mailHtmlBody, mailSubject);
          Messaging.sendEmail(new Messaging.SingleEmailmessage[] {emailWithActivityTracking});
        } catch (Exception e) {
          sendEmail(new List<String>{'anthony.xuan@creditandfinance.com.au'}, 'Utilities Exception', 'appointment: ' + appointment.id + ' appointment.Opp_Owner_Email__c: ' + appointment.Opp_Owner_Email__c + '<br> Exception: ' + e.getMessage());
        }

      }
    }
  }

  public static void sendEmail(List<String> recipients, String subject, String bodyText) {
    List<Messaging.SingleEmailMessage> mailsS = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage mailsSc = new Messaging.SingleEmailMessage();

    mailsSc.setToAddresses(recipients);
    mailsSc.setSenderDisplayName(subject);
    mailsSc.setSubject(subject);

    mailsSc.setHtmlBody(bodyText);
    mailsS.add(mailsSc);
    Messaging.sendEmail(mailsS);
  }

  //   public static Blob getStaticResource(String resourcePath) {
  //       PageReference somefileRef = new PageReference('/resource/' + resourcePath);
  //       Blob ret = somefileRef.getContent();
  //       System.debug(ret);
  //       return ret;
  //   }

  public static Id castId(String idString) {
    id temp;
    try{
      temp = idString;
      return temp;
    } catch (Exception e) {
      return null;
    }
  }

  public static Datetime getGMTTime(Datetime lt) {
    return Datetime.newInstance(lt.dateGmt(), lt.timeGmt());
  }

  public static Datetime getCurrentMonthStartTime() {
    Datetime dt = Date.today();
    return Datetime.newInstanceGmt(dt.year(), dt.month(), 1);
  }

  public static Object parseValue(Map<String, Schema.DisplayType> fieldTypeMap, String fieldName, Object o) {
    try {
      if(fieldTypeMap.get(fieldName) == Schema.DisplayType.DateTime) {
        if(o instanceof Long) {
          return Datetime.newInstance((Long) o);
        } else if (o instanceof String) {
          return Datetime.valueOf((String) o);
        }
      } else if(fieldTypeMap.get(fieldName) == Schema.DisplayType.Date) {
        if(o instanceof Long) {
          return (Date) Datetime.newInstance((Long) o);
        } else if (o instanceof String) {
          return Date.valueOf((String) o);
        }
      }
    } catch (Exception e) {
      return null;
    }
    return o;
  }

  public class CalloutResponseException extends Exception {
    private HttpRequest req;
    private HttpResponse res;
    private Integer statusCode;

    public CalloutResponseException(HttpRequest req, HttpResponse res) {
      this.req = req;
      this.res = res;
      this.statusCode = res.getStatusCode();
    }

    public HttpRequest getRequest() {
      return this.req;
    }

    public HttpResponse getResponse() {
      return this.res;
    }

    public Integer getStatusCode() {
      return this.statusCode;
    }
  }

  public static Boolean isBussy(Datetime startTime, Datetime endTime, List<Saasfocus_EventClass> events) {
    for(Saasfocus_EventClass e : events) if(isBussy(startTime, endTime, e)) return true;
    return false;
  }

  public static Boolean isBussy(Datetime startTime, Datetime endTime, Saasfocus_EventClass event) {
    Datetime st = Datetime.valueOf(event.startDateTime);
    Datetime ed = Datetime.valueOf(event.endDateTime);

    if(startTime.getTime() < st.getTime() && endTime.getTime() > ed.getTime()) return true;
    if(st.getTime() < startTime.getTime() && startTime.getTime() < ed.getTime()) return true;
    if(st.getTime() < endTime.getTime() && endTime.getTime() < ed.getTime()) return true;
    return false;
  }

  public static PageReference constructPageRef(String pageName, Map<String, String> params) {
		PageReference ret = new PageReference('/apex/' + pageName);
		for(String k : params.keySet()) {
			ret.getParameters().put(k, params.get(k));
		}
		return ret;
	}

	//could Throws VisualforceException
	public static Blob getPageAsPDF(PageReference pr) {
		return pr.getContentAsPDF();
	}

  public static String increaseDuplicateCounter(String name) {
    Pattern namePattern = Pattern.compile('[(][1-9][0-9]?[)]');
    String[] nameParts = name.split('\\.');

    if(namePattern.matcher(nameParts[0]).find()) {
      String[] fileNames = nameParts[0].split('\\(');
      String numPart = fileNames[1].substringBefore(')');
      nameParts[0] = fileNames[0] + '(' + (Integer.valueOf(numPart) + 1) + ')';
    } else {
      nameParts[0] += ' (1)';
    }
    String ret = '';
    for(String s : nameParts) ret += '.' + s;
    return ret.substring(1);
  }

  public static String generateRandomString(Integer len) {
      final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
      String randStr = '';
      while (randStr.length() < len) {
         Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
         randStr += chars.substring(idx, idx + 1);
      }
      return randStr;
  }

}
