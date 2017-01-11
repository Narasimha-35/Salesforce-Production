trigger acfUpdateMasterQuestionOnQuestion on Answer__c (after insert,after update) 
{
    map<id,id> map_question_id = new map<id,id>();
    list<id> list_answer_id = new list<id>();
    list<Question__c> list_ques_insert = new list<Question__c>();
    for(Answer__c ans : Trigger.new)
    {
    	if(ans.acf_Question__c <> null && ans.acf_Related_Question__c <> null)
        	map_question_id.put(ans.acf_Question__c, ans.acf_Related_Question__c);  
    }   
    if(map_question_id <> null && map_question_id.size()>0)
    {
    	list<Question__c> ques_obj1 = [select id,acf_Master_Question__c from Question__c where id in : map_question_id.keySet()];
	    for(Question__c ques : ques_obj1)
	    {
	        if(ques.acf_Master_Question__c != null)
	        {
	            Question__c ques_obj_insert = new Question__c(acf_Master_Question__c=ques.acf_Master_Question__c, id=map_question_id.get(ques.id));
	            list_ques_insert.add(ques_obj_insert);
	        }
	        else
	        {
	            Question__c ques_obj_insert = new Question__c(acf_Master_Question__c=ques.id, id=map_question_id.get(ques.id));
	            list_ques_insert.add(ques_obj_insert);
	        }
	    }
    	system.debug('list_ques_insert--------------------- '+list_ques_insert);
    	if(list_ques_insert <> null && list_ques_insert.size()>0)
    		update list_ques_insert;
    }	
}