public without sharing class MercuryAuth {
    private static MercuryAuth instance = null;
    private String token = null;

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
        token = MercuryApiUtilities.getAuthToken();
    }

}
