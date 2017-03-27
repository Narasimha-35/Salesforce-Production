@isTest
Public class SortingControllerTest{

    static testMethod void testdoSortByValue() {
        Selectoption[] opts = new Selectoption[] {
                                   new Selectoption('v1', 'l1'),
                                   new Selectoption('v5', 'l1'),
                                   new Selectoption('v2', 'l1'),
                                   new Selectoption('v6', 'l1'),
                                   new Selectoption('v8', 'l1')
                               };
       
       SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Value);
       
       System.assertEquals(opts.size(), 5);
       System.assertEquals('v1', opts[0].getValue());
       System.assertEquals('v2', opts[1].getValue());
       System.assertEquals('v5', opts[2].getValue());
       System.assertEquals('v6', opts[3].getValue());
       System.assertEquals('v8', opts[4].getValue());
    }
    
    static testMethod void testdoSortByLabel() {
        Selectoption[] opts = new Selectoption[] {
                                   new Selectoption('v1', 'l1'),
                                   new Selectoption('v5', 'l5'),
                                   new Selectoption('v2', 'l2'),
                                   new Selectoption('v2.2', 'l2'), // Same label case
                                   new Selectoption('v6', 'l6'),
                                   new Selectoption('v8', 'l8')
                               };
       
       SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Label);
       
       System.assertEquals(opts.size(), 6);
       System.assertEquals('l1', opts[0].getLabel());
       System.assertEquals('l2', opts[1].getLabel());
       System.assertEquals('l2', opts[2].getLabel());
       System.assertEquals('l5', opts[3].getLabel());
       System.assertEquals('l6', opts[4].getLabel());
       System.assertEquals('l8', opts[5].getLabel());
    }

    static testMethod void testLoad() {
        Selectoption[] opts = new Selectoption[] {};
       for (Integer idx = 0; idx < 50000; idx++) 
            opts.add(new Selectoption('v1', 'l1' + idx));
      
       SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Label);
       // 50,000 is max record count to be handled in apex at a time.
       // As of now its taking 150009 script lines to sort this big collection. So leaving nearly 50,000 lines for client code.
       // Here means we are good, the algo is good enough to survive within 200000 script lines governor limits.
    }
    
    
}