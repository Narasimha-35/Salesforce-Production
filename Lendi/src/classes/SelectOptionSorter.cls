global class SelectOptionSorter {
    
    /**
        Sort field to use in SelectOption i.e. Label or Value
    */
    global enum FieldToSort {
        Label, Value
    }
    
    global static void doSort(List<Selectoption> opts, FieldToSort sortField) {
        
        Map<String, Selectoption> mapping = new Map<String, Selectoption>();
        // Suffix to avoid duplicate values like same labels or values are in inbound list 
        Integer suffix = 1;
        for (Selectoption opt : opts) {
            if (sortField == FieldToSort.Label) {
                mapping.put(    // Done this cryptic to save scriptlines, if this loop executes 10000 times
                                // it would every script statement would add 1, so 3 would lead to 30000.
                             (opt.getLabel() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            } else {
                mapping.put(    
                             (opt.getValue() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            }
        }
        
        List<String> sortKeys = new List<String>();
        sortKeys.addAll(mapping.keySet());
        sortKeys.sort();
        // clear the original collection to rebuilt it
        opts.clear();
        
        for (String key : sortKeys) {
            opts.add(mapping.get(key));
        }
    }
}