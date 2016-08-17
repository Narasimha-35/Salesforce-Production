/**
* Service
*/
public virtual class Service {
    public static final String DETAIL_PLACE_HOLDER = '{!DETAIL_PLACE_HOLDER}';

    /**
    * log simple info
    */
    public void logInfo(String msg) {
        System.debug(LoggingLevel.INFO, msg);
    }

    /**
    * log info with map
    */
    public void logInfo(String msgTemplate, Map<String, String> infos) {
        logInfo(putDetail(msgTemplate, infos));
    }

    /**
    * log detailed info
    */
    public void logInfo(String msgTemplate, Map<String, String> infos, String className) {
        msgTemplate = '[' + className + ']' + ' ' + putDetail(msgTemplate, infos);
        logInfo(msgTemplate);
    }

    /**
    *
    */
    // TODO: put into utility
    public String putDetail(String templateString, Map<String, String> replacingMap) {
        String ret = ' ';
        for(String key : replacingMap.keySet()) ret += key + ': ' + replacingMap.get(key) + ' ';
        return templateString.replace(DETAIL_PLACE_HOLDER, ret);
    }

}
