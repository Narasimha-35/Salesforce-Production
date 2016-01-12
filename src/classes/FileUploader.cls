public without sharing class FileUploader {
	public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List<Account> accstoupload {get; set;}
    List<String> accountEmails {get; set;}
    public void readFile()
    {
        try {
            nameFile=contentFile.toString();
            filelines = nameFile.split('[\r\n]');
            accountEmails = new List<String>();
            accstoupload = new List<Account>();
            Map<String, String> accountEmailId = new Map<String, String>();
            for (Integer i=1;i<filelines.size();i++) {
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                if (inputvalues.size() > 1) {
                    String mercuryId = inputvalues[0];
                    String accountEmail = inputvalues[1];
                    System.debug(accountEmail);
                    accountEmails.add(accountEmail);
                    accountEmailId.put(accountEmail, mercuryId);

                }
            }
            List<Account> accounts = [select Id, Mercury_People_ID__c, PersonEmail From Account where PersonEmail in : accountEmails];
            List<Account> accountsU = new List<Account>();
            if (accounts.size() > 0) {
                for (Account account : accounts) {
                    if (accountEmailId.containsKey(account.PersonEmail)) {
                        account.Mercury_People_ID__c = accountEmailId.get(account.PersonEmail);
                        accountsU.add(account);   
                    }
                }
            }
            update accountsU;
        }  catch(Exception e) {
          ApexPages.addMessages(e);
        }
    }
    
    public List<Account> getuploadedLeads()
    {
        if (accountEmails != NULL) {
            if (accountEmails.size() > 0) {
            	List<Account> accounts = [select Id, Name, PersonEmail From Account where PersonEmail in : accountEmails];
                return accounts;
    		}
		}
		return null;
    }            
}