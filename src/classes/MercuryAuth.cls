public without sharing class MercuryAuth {
    private static MercuryAuth instance = null;
    private String token = null;
    private MercurySettings__c ms = null;

    private MercuryAuth() {
        auth();
    }

    public static MercuryAuth getInstance() {
        if(instance == null) instance = new MercuryAuth();
        return instance;
    }

    public String getToken() {
        return token;
    }

    public void auth() {
        String profileId = UserInfo.getOrganizationId();
        ms = [SELECT id FROM MercurySettings__c WHERE SetupOwnerId = :profileId FOR UPDATE];
        token = MercuryApiUtilities.getAuthToken();
    }

}
