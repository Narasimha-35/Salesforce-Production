global class autoCompleteController 
{
    public String searchTerm{get;set;}
    public list<acfBank_Detail__c> lstbank{get;set;}
    
    public autoCompleteController()
    {
      lstbank = new list<acfBank_Detail__c>();        
         list<acfBank_Detail__c> lstallBank = new list<acfBank_Detail__c>();
         lstallBank = [select id,Name,acfBank_Name__c from acfBank_Detail__c];
         if(lstallBank!=null && lstallBank.size()>0)
         lstbank = lstallBank ;
      
      
    }
    
}