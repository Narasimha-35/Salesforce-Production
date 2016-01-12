/*====================================================
				Click Loans
========================================================*/
public  class acResponse {

	public class bankSatementResponseSuccessorFailure{
		public bankStatementResponse response;
		public Boolean success;
		public String message;
		
		public bankSatementResponseSuccessorFailure(bankStatementResponse response,Boolean success,String Message){
			this.response = response;
			this.success = success;
			this.message = message;
		}
	}

	public class bankStatemtnResponseStatemtnsresponse{
		public Map<String,Object> mapResponse;
		public Boolean success;
		public String message;
		
		public bankStatemtnResponseStatemtnsresponse(Map<String,Object> mapResponse,Boolean success,String Message){
			this.mapResponse = mapResponse;
			this.success = success;
			this.message = message;
		}
	}
}