public class ClsDemo {
    public boolean showAvmpanel1 {
        get;
        set;
    }
    public boolean showAvmpanel2 {
        get;
        set;
    }
    public String Debuglog {
        get;
        set;
    }
    map < String, String > mapdata = new map < String, String > ();
    public String propertId {
        get;
        set;
    }
    public String StateMessgae {
        get;
        set;
    }
    public String pid {
        get;
        set;
    }
    public String Range {
        get;
        set;
    }
    public String bathrooms {
        get;
        set;
    }
    public String bedrooms {
        get;
        set;
    }
    public String carSpaces {
        get;
        set;
    }
    public String craftsmanshipQuality {
        get;
        set;
    }
    public String floorAreaM2 {
        get;
        set;
    }
    public String landAreaM2 {
        get;
        set;
    }
    public String propertyType {
        get;
        set;
    }
    public String saleDate {
        get;
        set;
    }
    public String salePrice {
        get;
        set;
    }
    public String valuationDate {
        get;
        set;
    }
    public String yearBuilt {
        get;
        set;
    }
    public String StreetNumber {
        get;
        set;
    }
    public String StreetName {
        get;
        set;
    }
    public String StreetType {
        get;
        set;
    }
    public String City {
        get;
        set;
    }
    public String State {
        get;
        set;
    }
    public String Postcode {
        get;
        set;
    }


    public ClsDemo() {
        AvmJsonGenerator obj = new AvmJsonGenerator();
        bathrooms = obj.bathrooms;
        bedrooms = obj.bedrooms;
        carSpaces = obj.carSpaces;
        bathrooms = obj.bathrooms;
        craftsmanshipQuality = obj.craftsmanshipQuality;
        floorAreaM2 = obj.floorAreaM2;
        landAreaM2 = obj.landAreaM2;
        saleDate = obj.saleDate;
        salePrice = obj.salePrice;
        valuationDate = obj.valuationDate;
        yearBuilt = obj.yearBuilt;

        String CommonData = '\n\n';
        CommonData = CommonData + 'AVM Disclaimer \n\n';

        CommonData = CommonData + 'This publication contains an automated valuation model estimate (AVM Estimated Value). \n ';
        CommonData = CommonData + 'This AVM Estimated Value is current at the date of the publication only. \n ';
        CommonData = CommonData + 'It is computer generated and is not a professional appraisal of the subject property and should not be relied upon as such. \n';
        CommonData = CommonData + 'The accuracy of the methodology used to develop the AVM Estimated Value, the existence of the subject property, \n';
        CommonData = CommonData + 'and the accuracy of the predicted value and all rule sets provided are estimates based on available data and are not guaranteed or warranted. \n';
        CommonData = CommonData + 'CoreLogic excludes all liability for any loss or damage arising in connection with the AVM Estimated Value.\n';

        String Queensland = 'Queensland Data \n';
        Queensland = Queensland + 'Based on or contains data provided by the State of Queensland (Department of Natural Resources and Mines) 2016. In consideration of the State permitting  \n';
        Queensland = Queensland + 'use of this data you acknowledge and agree that the State gives no warranty in relation to the data (including accuracy, reliability, completeness, \n';
        Queensland = Queensland + 'currency or suitability) and accepts no liability (including without limitation, liability in negligence) for any loss, damage or costs (including  \n';
        Queensland = Queensland + ' consequential damage) relating to any use of the data. Data must not be used for direct marketing or be used in breach of the privacy laws.';
        Queensland = Queensland + CommonData;
        mapdata.put('Queensland', Queensland);

        String SouthAustralian = 'South Australian Data \n';
        SouthAustralian = SouthAustralian + '© 2016 Copyright in this information belongs to the South Australian Government and the South Australian Government does \n ';
        SouthAustralian = SouthAustralian + 'not accept any responsibility for the accuracy or completeness of the information or its suitability for purpose.';
        SouthAustralian = SouthAustralian + CommonData;
        mapdata.put('SouthAustralian', SouthAustralian);

        String NewSouthWales = 'New South Wales Data \n';
        NewSouthWales = NewSouthWales + 'contains property sales information provided under licence from the Land and Property Information (“LPI”). RP Data Pty Ltd  \n';
        NewSouthWales = NewSouthWales + 'trading as CoreLogic is authorised as a Property Sales Information provider by the LPI.';
        NewSouthWales = NewSouthWales + CommonData;
        mapdata.put('NewSouthWales', NewSouthWales);
        String Victorian = 'Victorian Data \n';
        Victorian = Victorian + 'The State of Victoria owns the copyright in the Property Sales Data and reproduction of that data in any way without the \n';
        Victorian = Victorian + 'consent of the State of Victoria will constitute a breach of the Copyright Act 1968 (Cth). The State of Victoria does not warrant \n ';
        Victorian = Victorian + 'the accuracy or completeness of the Property Sales Data and any person using or relying upon such information does so on \n';
        Victorian = Victorian + 'the basis that the State of Victoria accepts no responsibility or liability whatsoever for any errors, faults, defects or omissions in \n';

        Victorian = Victorian + 'the information supplied.';
        Victorian = Victorian + CommonData;
        mapdata.put('Victorian', Victorian);
        String WesternAustralian = 'Western Australian Data \n';
        WesternAustralian = WesternAustralian + 'Based on information provided by and with the permission of the Western Australian Land Information Authority (2016) trading as Landgate. \n';
        WesternAustralian = WesternAustralian + 'Australian Capital Territory Data \n';
        WesternAustralian = WesternAustralian + 'The Territory Data is the property of the Australian Capital Territory. No part of it may in any form or by any means (electronic, \n';
        WesternAustralian = WesternAustralian + 'without prior written permission. Enquiries should be directed to: Director, Customer Services ACT Planning and Land \n';

        WesternAustralian = WesternAustralian + 'Authority GPO Box 1908 Canberra ACT 2601.';
        WesternAustralian = WesternAustralian + CommonData;
        mapdata.put('WesternAustralian', WesternAustralian);
        String Tasmanian = 'Tasmanian Data /n';
        Tasmanian = Tasmanian + 'This product incorporates data that is copyright owned by the Crown in Right of Tasmania. The data has been used in the \n';
        Tasmanian = Tasmanian + 'product with the permission of the Crown in Right of Tasmania. The Crown in Right of Tasmania and its employees and agents: \n';
        Tasmanian = Tasmanian + '(a) give no warranty regarding the data\'s accuracy, completeness, currency or suitability for any particular purpose and \n';
        Tasmanian = Tasmanian + '(b) do not accept liability howsoever arising, including but not limited to negligence for any loss resulting from the use of or reliance upon the data.\n ';

        Tasmanian = Tasmanian + 'Base data from the LIST © State of Tasmania http://www.thelist.tas.gov.au';
        Tasmanian = Tasmanian + CommonData;
        mapdata.put('Tasmanian ', Tasmanian);

        String AustralianCapitalTerritory = 'Australian Capital Territory Data/n';
        AustralianCapitalTerritory = AustralianCapitalTerritory + 'The Territory Data is the property of the Australian Capital Territory. No part of it may in any form or by any means (electronic,  \n';
        AustralianCapitalTerritory = AustralianCapitalTerritory + 'mechanical, microcopying, photocopying, recording or otherwise) be reproduced, stored in a retrieval system or transmitted \n';
        AustralianCapitalTerritory = AustralianCapitalTerritory + 'without prior written permission. Enquiries should be directed to: Director, Customer Services ACT Planning and Land  \n';
        AustralianCapitalTerritory = AustralianCapitalTerritory + 'Authority GPO Box 1908 Canberra ACT 2601. \n ';


        AustralianCapitalTerritory = AustralianCapitalTerritory + CommonData;
        mapdata.put('AustralianCapitalTerritory', AustralianCapitalTerritory);

    }



    public PageReference GetPropertyId() {
        //String Address  = StreetNumner +' ' + StreetName + ' ' + StreetType  + ' ' +City +' '+ State +' '+Postcode ;

        clsPropertyAddress  obj = new clsPropertyAddress ();

        obj.StreetNumber = StreetNumber;
        obj.StreetName = StreetName;

        obj.StreetType = StreetType;
        obj.City = City;
        obj.State = State;
        obj.Postcode = Postcode;
        CoreLogicServices  core = new CoreLogicServices();

        HttpResponse httpres = core.SearchProperty(obj);
        //Debuglog = httpres.getbody();
        JSONParser parser = JSON.createParser(httpres.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'propertyId')) {
                parser.nextToken();
                //if(! Test.isRunningTest())
                propertId = parser.gettext();
            }
        }
        showAvmpanel1 = true;

        return null;
    }

    public PageReference getAvmdetails() {
        AvmJsonGenerator obj = new AvmJsonGenerator();
        obj.bathrooms = bathrooms;
        obj.bedrooms = bedrooms;
        obj.carSpaces = carSpaces;
        obj.bathrooms = bathrooms;
        obj.craftsmanshipQuality = craftsmanshipQuality;
        obj.floorAreaM2 = floorAreaM2;
        obj.landAreaM2 = landAreaM2;
        obj.saleDate = saleDate;
        obj.salePrice = salePrice;
        obj.valuationDate = valuationDate;
        obj.yearBuilt = yearBuilt;
        obj.propertyid= propertId;
       //
 CoreLogicServices obj1 = new CoreLogicServices();
 String  Tempjson = obj1.avmJson(obj ) ;
  debuglog = Tempjson;
        HttpResponse httpres = obj1.getPropertyAVM(Tempjson);
        //  debuglog = httpres.getbody();
        if (State.containsIgnoreCase('QLD') || State.containsIgnoreCase('Queensland'))
            StateMessgae = mapdata.get('Queensland');
        if (State.containsIgnoreCase('SouthAustralian') || State.containsIgnoreCase('SA'))
            StateMessgae = mapdata.get('SouthAustralian');
        if (State.containsIgnoreCase('NewSouthWales') || State.containsIgnoreCase('NSW'))
            StateMessgae = mapdata.get('NewSouthWales');
        if (State.containsIgnoreCase('NewSouthWales') || State.containsIgnoreCase('NSW'))
            StateMessgae = mapdata.get('NewSouthWales');
        if (State.containsIgnoreCase('Victorian') || State.containsIgnoreCase('VIC'))
            StateMessgae = mapdata.get('Victorian');
        if (State.containsIgnoreCase('WesternAustralian') || State.containsIgnoreCase('WA'))
            StateMessgae = mapdata.get('WesternAustralian');
        if (State.containsIgnoreCase('ACT'))
            StateMessgae = mapdata.get('AustralianCapitalTerritory');
        JSONParser parser = JSON.createParser(httpres.getbody());

        Avm av = (Avm) parser.readValueAs(Avm.class);
        avmFaresDetails = av.avmFaresDetail;
        showAvmpanel2 = true;
        return null;
    }
    public avmFaresDetail avmFaresDetails {
        get;
        set;
    }
    public class Avm {
        public avmFaresDetail avmFaresDetail {
            get;
            set;
        }
    }
    public avmFaresDetail temp {
        get;
        set;
    }
    public class avmFaresDetail {

        public string faresFSDScore {
            get;
            set;
        }
        public string faresReferenceID {
            get;
            set;
        }
        public string faresScore {
            get;
            set;
        }
        public string faresValuationDate {
            get;
            set;
        }
        public string faresValueEstimate {
            get;
            set;
        }
        public string faresValueHigh {
            get;
            set;
        }
        public string faresValueLow {
            get;
            set;
        }

    }
}