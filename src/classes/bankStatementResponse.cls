/*====================================================
				Click Loans
========================================================*/
//
//Generated by AdminBooster
//

/*public class bankStatementResponse{
    public cls_accounts accounts;
    public String user_token;   //9f629dc9f59e31fcf3070eddaf41e84a
    
    public class cls_accounts {
        public cls_accounts[] accounts;
        public String accountHolder {get; set;}    //Mary Jone
        public String name {get; set;} //Transaction Account
        public String accountNumber {get; set;}    //456789
        public String id {get; set;}   //456789
        public String bsb {get; set;}  //123-456
        public String balance {get; set;}  //123.45
        public String available {get; set;}    //123.45
    }
    
    public static bankStatementResponse parse(String json){
        return (bankStatementResponse) System.JSON.deserialize(json, bankStatementResponse.class);
    }

    
}*/

public class bankStatementResponse
{
	public cls_accounts[] accounts;
	public String user_token;	//920b0adb1139a95bbf353c0f8a861c65
	public class cls_accounts {
		public String accountHolder;	//Bob Smith
		public String name;	//Transaction Account
		public String accountNumber;	//423897
		public String id;	//423897
		public String bsb;	//123-456
		public String balance;	//3.45
		public String available;	//3.45
	}
	public static bankStatementResponse parse(String json){
		return (bankStatementResponse) System.JSON.deserialize(json, bankStatementResponse.class);
	}

	static testMethod void testParse() {
		String json=		'{"accounts":[{"accountHolder":"Bob Smith","name":"Transaction Account","accountNumber":"423897","id":"423897","bsb":"123-456","balance":"3.45","available":"3.45"},{"accountHolder":"Robert Smith","name":"Savings Account","accountNumber":"7563435","id":"7563435","bsb":"123-456","balance":"23.45","available":"23.45"}],"user_token":"920b0adb1139a95bbf353c0f8a861c65"}';
		bankStatementResponse obj = parse(json);
		System.assert(obj != null);
	}
}