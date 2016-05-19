public without sharing class MercuryAuth {
    private static MercuryAuth instance = null;
    private String token = null;
    private MercurySettings__c ms = null;

    private MercuryAuth() {
        auth(!Test.isRunningTest());
    }

    private MercuryAuth(Boolean needCallOut) {
        auth(needCallOut);
    }

    public static MercuryAuth getInstance() {
        if(instance == null) instance = new MercuryAuth();
        return instance;
    }

    public static MercuryAuth getInstance(Boolean needCallOut) {
        if(instance == null) instance = new MercuryAuth(needCallOut);
        return instance;
    }

    public String getToken() {
        return token;
    }

    public void auth(Boolean needCallOut) {
        String profileId = UserInfo.getOrganizationId();
        ms = [SELECT id FROM MercurySettings__c WHERE SetupOwnerId = :profileId FOR UPDATE];
        if(needCallOut) token = MercuryApiUtilities.getAuthToken();
        else token = 'aaf498ce-fc28-4e0c-a2c3-63cfd7d6ff18';
    }

}