/*====================================================
				Click Loans
========================================================*/
public class Institution 
{
    public string slug;
    public string name;
    public string status;
    public string searchable;
    public string display;
    public string searchVal;
    public string region;
    public string export_with_password;
    public string estatements_supported;
    public string transaction_listings_supported;
    public string requires_preload;
    public string requires_mfa;
    public string updated_at;       
    public string max_days;
    
    public List<Credential> credentials;
    
    public Institution(string slug1, string name1, string status1, string searchable1, string display1, string searchVal1, string region1, string ewp1, string es1, string tls1, string rp1, string rm1, string ua1, string md1, List<Credential> clList1) 
    {
        slug = slug1;
        name = name1;
        status = status1;
        searchable = searchable1;
        display = display1;
        searchVal = searchVal1;
        region = region1;
        export_with_password = ewp1;
        estatements_supported = es1;
        transaction_listings_supported = tls1;
        requires_preload = rp1;
        requires_mfa = rm1;
        updated_at = ua1;       
        max_days = md1;
        credentials = clList1.clone();
    }
    
    public class Credential
    {
        public string name {get;set;}
        public string fieldID;
        public string type {get;set;}
        public string description;
        public Value values {get;set;}
        public string keyboardType;
    }
    
    public class Value
    {
        public integer one {get;set;}
        public integer two {get;set;}
        public integer three {get;set;}
        public integer four {get;set;}
    }
}