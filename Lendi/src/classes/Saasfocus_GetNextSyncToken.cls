// ----------------------------------------------------------------------------------
// This Class is used for convert the Json Response in the apex Class

// Version#        Date             Author              Description
// ----------------------------------------------------------------------------------
//   1.0       08 April 2015        Ashutosh Kumar         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// 
// ----------------------------------------------------------------------------------
//
//

// This class is used for convert the Json Response in the apex Class

public with sharing class Saasfocus_GetNextSyncToken {

    public class Items {
        public String kind;
        public String etag;
        public String id;
        public String status;
        public String htmlLink;
        public String created;
        public String updated;
        public Creator creator;
        public Creator organizer;
        public Start start;
        public Start end1;
        public String iCalUID;
        public Integer sequence;
        public String hangoutLink;
        public Reminders reminders;
    }

    public class Reminders {
        public Boolean useDefault;
    }

    public class Start {
        public String dateTime1;
        public String timeZone;
    }

    public class Creator {
        public String email;
        public String displayName;
        public Boolean self;
    }

    public String kind;
    public String etag;
    public String summary;
    public String updated;
    public String timeZone;
    public String accessRole;
    public List<DefaultReminders> defaultReminders;
    public String nextSyncToken;
    public List<Items> items;

    public class DefaultReminders {
        public String method;
        public Integer minutes;
    }

    
 }