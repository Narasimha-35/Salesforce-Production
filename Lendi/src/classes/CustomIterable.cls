Public  class  CustomIterable implements Iterator<list<GlobalDealIQRulecontrollerExtn.BankWrapper>>
{ 
   list<GlobalDealIQRulecontrollerExtn.BankWrapper> InnerList{get; set;}
   list<GlobalDealIQRulecontrollerExtn.BankWrapper> ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize {get; set;} 

   public CustomIterable(List<GlobalDealIQRulecontrollerExtn.BankWrapper> lstAccWr)
   {
       InnerList = new list<GlobalDealIQRulecontrollerExtn.BankWrapper >(); 
       ListRequested = new list<GlobalDealIQRulecontrollerExtn.BankWrapper >();     
       InnerList = lstAccWr;
       setPageSize = 10;
       i = 0; 
   }   

   Public boolean hasNext(){ 
       if(i >= InnerList.size()) {
           return false; 
       } else {
           return true; 
       }
   } 
   
   Public boolean hasPrevious(){ 
       system.debug('I am in hasPrevious' + i);
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

   Public list<GlobalDealIQRulecontrollerExtn.BankWrapper > next(){       
       system.debug('i value is ' + i);
       ListRequested = new list<GlobalDealIQRulecontrollerExtn.BankWrapper >(); 
       integer startNumber;
       integer size = InnerList.size();
       if(hasNext())
       {  
           if(size <= (i + setPageSize))
           {
               startNumber = i;
               i = size;
           }
           else
           {
               i = (i + setPageSize);
               startNumber = (i - setPageSize);
           }
           
           system.debug('i value is =====' + i);
           system.debug('i value is 2==== ' + (i - setPageSize));
           
           for(integer start = startNumber; start < i; start++)
           {
               ListRequested.add(InnerList[start]);
           }
       } 
       return ListRequested;
   } 
   
   Public list<GlobalDealIQRulecontrollerExtn.BankWrapper > previous(){      
       ListRequested = new list<GlobalDealIQRulecontrollerExtn.BankWrapper >(); 
       system.debug('i value is previous before =====' + i);
       integer size = InnerList.size(); 
       if(i == size)
       {
           if(math.mod(size, setPageSize) > 0)
           {    
               i = size - math.mod(size, setPageSize);
           }
           else
           {
               i = (size - setPageSize);
           } 
       }
       else
       {
           i = (i - setPageSize);
       }
       
       system.debug('i value is previous =====' + i);
       system.debug('i value is 2previous ==== ' + (i - setPageSize));
       
       for(integer start = (i - setPageSize); start < i; ++start)
       {
           ListRequested.add(InnerList[start]);
       } 
       return ListRequested;
   }   
}