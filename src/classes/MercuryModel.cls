public without sharing class MercuryModel {

	public class Partner {
		public String uniqueId{get; set;}
		public String name{get; set;}
	}

	public class PartnerResponse {
		public Boolean success{get; set;}
		public List<MercuryModel.Partner> partnerList{get; set;}
	}

	public class People {
		public String uniqueId{get; set;}
		public String name{get; set;}
	}

	public class PersonResponse {
		public Boolean success{get; set;}
		public List<MercuryModel.People> People{get; set;}
	}

}
