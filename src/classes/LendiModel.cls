public with sharing class LendiModel {

	public class Response extends Model {
		public Integer status_code;
		// public String error;
		// public String message;
		public Meta meta;
		public Object data;
	}

	public class Meta extends Model {
		public String community;
		public String api_version;
		public String uid;
	}

	public class User extends Model {
		public String uuid;
		public String firstName;
		public String lastName;
		public String token;

		public User() {
		}

		public User(String uuid) {
			this.uuid = uuid;
		}

		public User(String uuid, String firstName, String lastName) {
			this.uuid = uuid;
			this.firstName = firstName;
			this.lastName = lastName;
		}
	}

}
