/*
    This class is used to read CSV file
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Karthik Chekkilla               10/12/2015                               1.0
    =============================================================================
*/
global class acfCSVFileParser
{
 
    public static List<List<String>> parseCSV(string contents,Boolean skipHeaders) 
    {  
        List<List<String>> allFields = new List<List<String>>();    
        List<String> lstLines = new List<String>();
        try {
         // blob blobContent = EncodingUtil.base64Decode(contents);
         // string strContent = blobContent.toString();
            lstLines = contents.split('\r\n');
        } catch (System.ListException e) {
            System.debug('***** Limits exceeded?' + e.getMessage());
        }
        system.debug('Line num is'+lstLines.size());
        Integer num = 0;
        for(String strLine : lstLines) 
        {
            // check for blank CSV lines (only commas)
            if (strLine.replaceAll(',','').trim().length() == 0) break;
            
            List<String> lstFields = strLine.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : lstFields) 
            {
                if (field.startsWith('"') && field.endsWith('"')) 
                {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) 
                    {
                        makeCompositeField = true;
                        compositeField = field;
                    } else if (field.endsWith('"')) 
                        {
                            compositeField += ',' + field;
                            cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                            makeCompositeField = false;
                        } else if (makeCompositeField) 
                            {
                                compositeField +=  ',' + field;
                            } else {
                                    cleanFields.add(field);
                                }
            }
            
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
        return allFields;       
    }    
}