public class clsPropertyAddress {


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
    public clsPropertyAddress()
    {// Setting Default Values.A
        StreetNumber = '';
        StreetName = '';
        StreetType = '';
        City = '';
        State = '';
        Postcode = '';
    }
    
    
}