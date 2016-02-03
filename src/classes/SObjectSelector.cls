/**
 * Author: Anthony Xuan
 * Create Date: 19/01/2016
 */

public abstract class SObjectSelector {
	private static final Integer RECORD_PER_SOQL = 25000;

    private String sobjectName;
    private Set<String> fields;
    private String fieldsString;

    public SObjectSelector(String sobjectName, Set<String> specFields, Set<String> excludeFields) {
		 SObjectType soType = Schema.getGlobalDescribe().get(sobjectName);
		 this.sobjectName = sobjectName;
		 fields = new Set<String>();
		 //add id in case id have not been selected.
		 fields.add('id');

		 if(specFields == null || specFields.size() == 0) {
			   fields.addAll(soType.getDescribe().fields.getMap().keySet());
		 } else {
			  fields.addAll(specFields);
		 }

		 if(excludeFields != null && excludeFields.size() != 0) fields.retainAll(excludeFields);
		 fieldsString = JSON.serialize(fields).replace('\"', '');
		 fieldsString = fieldsString.substring(1, fieldsString.length() - 1);
	}

	@testvisible
	private Integer getLimitGroupNum(Integer numOfRecords) {
		return (numOfRecords / RECORD_PER_SOQL) + 1;
	}

	public String getQueryPartOne() {
	    return 'SELECT ' + fieldsString + ' FROM ' + sobjectName + ' ';
	}

	//return null if hit the maximum governer Limit
	public List<SObject> selectByIds(List<Id> ids) {
		List<SObject> ret = new List<SObject>();
		String queryString = getQueryPartOne() + 'WHERE id IN :ids LIMIT ' + RECORD_PER_SOQL;
		System.debug(LoggingLevel.INFO, 'Select By Ids: ' + queryString);
	   return Database.query(queryString);
	}

	//NOTE: the condition have to be cleaned before using this function, otherwise Vulnerable to SOQL Injection
	public List<SObject> selectByOpenCondition(String condition) {
		Integer numOfRecords = selectCountByOpenCondition(condition);
		List<SObject> ret = new List<SObject>();
		String queryString = getQueryPartOne() + condition + ' LIMIT ' + RECORD_PER_SOQL;
		System.debug(LoggingLevel.INFO, 'Select By Open Condition: ' + queryString);
		return Database.query(queryString);
	}

	//NOTE: the condition have to be cleaned before using this function, otherwise Vulnerable to SOQL Injection
	public Integer selectCountByOpenCondition(String condition) {
		String queryString = 'SELECT count(id) FROM ' + sobjectName + ' ' + condition;
		AggregateResult[] ar = Database.query(queryString);
		return (Integer)ar[0].get('expr0');
	}
}
