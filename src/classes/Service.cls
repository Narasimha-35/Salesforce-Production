/**
* Service
*/
public virtual class Service {
    public static final String DETAIL_PLACE_HOLDER = '{!DETAIL_PLACE_HOLDER}';

    /**
    * log simple info
    */
    public void log(LoggingLevel level, String msg, String className) {
        System.debug(level, '[' + className + ']' + ' ' + msg);
    }

    /**
    * log detailed info
    */
    public void log(LoggingLevel level, String msgTemplate, Map<String, String> infos, String className) {
        log(level, putDetail(msgTemplate, infos), className);
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