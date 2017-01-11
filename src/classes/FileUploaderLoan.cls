public without sharing class FileUploaderLoan {
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List<Account> accstoupload {get; set;}
    List<String> accountMercuryId{get; set;}
    
    public string nameAccsInfoFile {get;set;}
    public blob contentAccsInfoFile {get;set;}
    public void readFile()
    { 
        try {
            nameFile=contentFile.toString();
            filelines = nameFile.split('[\r\n]');
            accountMercuryId = new List<String>();
            accstoupload = new List<Account>();
            Map<String, String> accountEmailId = new Map<String, String>();
            for (Integer i=1;i<filelines.size();i++) {
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                if (inputvalues.size() > 1) {
                    String loadId = inputvalues[0];
                    String peopleId = inputvalues[1];
                    //System.debug(accountEmail);
                    accountMercuryId.add(peopleId);
                    accountEmailId.put(peopleId, loadId);

                }
            }
            List<Account> accounts = [select Id, (select Id, Mercury_Loan_Id__c From Opportunities order by CreatedDate desc), Mercury_People_ID__c, PersonEmail From Account where Mercury_People_ID__c in : accountMercuryId];
            Map<String, List<Opportunity>> accountAndOpposMap = new Map<String, List<Opportunity>>();
            List<Opportunity> opposU = new List<Opportunity>();
            for (Account account : accounts) {
                if (account.Opportunities.size() > 0 && account.Mercury_People_ID__c != null && accountEmailId.get(account.Mercury_People_ID__c) != null) {
                    Opportunity oppo = account.Opportunities.get(0);
                    oppo.Mercury_Loan_Id__c = accountEmailId.get(account.Mercury_People_ID__c);
                    opposU.add(oppo);
                }
            }
            update opposU;
            
        }  catch(Exception e) {
          ApexPages.addMessages(e);
        }
    }
    
    //Method is used to read CSV file and export updated CSV file with account Information
    public void sendUpdatedFile() 
    {
      if(contentAccsInfoFile != null)
      {
           try 
           {
                nameAccsInfoFile = contentAccsInfoFile.toString();
               // nameAccsInfoFile = EncodingUtil.base64Encode(contentAccsInfoFile);
                set<string> strMobileValues = new set<string>();
                set<string> strEmailIds = new set<string>();
                

                String strCSVContent = contentAccsInfoFile.toString();
                //String strCSVContent =  EncodingUtil.base64Encode(contentAccsInfoFile);
                List<List<String>> lstParsedCSVRows = acfCSVFileParser.parseCSV(strCSVContent,true);
                for(list<string> lstfileColValues : lstParsedCSVRows)
                {
                    if(lstfileColValues != null && lstfileColValues.size()>0)
                    {
                        string strMobile = lstfileColValues[0].replace('+','');
                        strMobile = strMobile.trim();
                        strMobileValues.add(strMobile);
                        string strEmailId = lstfileColValues[1].trim();
                        strEmailIds.add(strEmailId);
                    }
                }
                system.debug('@@karthik'+strCSVContent+'===='+strEmailIds+'===='+strMobileValues);
                acfGenerateAccInfoFileBatch objBatchProcess= new acfGenerateAccInfoFileBatch(lstParsedCSVRows,strMobileValues,strEmailIds);
                String strBatchId = Database.executeBatch(objBatchProcess, 200);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'File successfully uploaded for processing.'));
            } catch(Exception e) {
              ApexPages.addMessages(e);
            }
        }else{
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select file'));  
        }
     }  
               
}