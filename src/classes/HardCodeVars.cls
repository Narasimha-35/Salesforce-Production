public class HardCodeVars {
	public static Map<String, String> typeTable {get; set;}
	static {
		typeTable = new Map<String, String>();
		typeTable.put('1', 'Click');
		typeTable.put('2', 'View');
		typeTable.put('3', 'Error');
		typeTable.put('4', 'Success');
		typeTable.put('5', 'Session');
		typeTable.put('6', 'Sent');
		typeTable.put('7', 'Search');
		typeTable.put('8', 'New Opportunity');
		typeTable.put('9', 'Opportunity Won');
		typeTable.put('10', 'Opportunity Lost');
		typeTable.put('11', 'Open');
		typeTable.put('12', 'Unsubscribe Page');
		typeTable.put('13', 'Bounced');
		typeTable.put('14', 'Spam Complaint');
		typeTable.put('15', 'Email Preference Page');
		typeTable.put('16', 'Resubscribed');
		typeTable.put('17', 'Click (Third Party)');
		typeTable.put('18', 'Opportunity Reopened');
		typeTable.put('19', 'Opportunity Linked');
		typeTable.put('20', 'Visit');
		typeTable.put('21', 'Custom URL click');
		typeTable.put('22', 'Olark Chat');
		typeTable.put('23', 'Invited to Webinar');
		typeTable.put('24', 'Attended Webinar');
		typeTable.put('25', 'Registered for Webinar');
		typeTable.put('26', 'Social Post Click');
		typeTable.put('27', 'Video View');
		typeTable.put('28', 'Event Registered');
		typeTable.put('29', 'Event Checked In');
		typeTable.put('30', 'Video Conversion');
		typeTable.put('31', 'UserVoice Suggestion');
		typeTable.put('32', 'UserVoice Comment');
		typeTable.put('33', 'UserVoice Ticket');
		typeTable.put('34', 'Video Watched (≥ 75% watched)');
		typeTable.put('Other', 'Unknown');
	}
}