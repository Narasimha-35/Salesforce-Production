
function selectTemplate(elm, id, sessionId){
	if (elm.value== 'None') {
		var textAreaElm = document.getElementById(id);
		textAreaElm.innerHTML = '';
		return;
	}
	if (elm.value == 'NewTp'){
	 	window.location = '/apex/NewSMSTemplate' + '?retURL=/apex/smagicinteract__SMHome';
		return;
	}
	try{
	 	var callback = {
			onSuccess:  layoutResults,
			onFailure: queryFailed,
			source : {id: id}
			};
	    sforce.connection.sessionId = sessionId;
		sforce.connection.query("Select smagicinteract__Name__c, smagicinteract__Text__c From smagicinteract__SMS_Template__c where id='"+elm.value+"'", callback);
	}catch(err){
		alert(err);
		}
}

function queryFailed(error) {
	alert("An error has occurred: " + error);
}

function layoutResults(queryResult, source) {
	var records = queryResult.getArray('records');
	var textAreaElm = document.getElementById(source.id);
	textAreaElm.innerHTML = records[0].smsmagicvc1__Text__c;
}

function redirectTo(url,retURL){
   if(retURL) url = url + '?retURL='+retURL;
   parent.location = url;
   return false;    
}

function testResource(){
	alert("hello");
}

function changeTemplateText(elm, templateTextId, ObjectTypeId, fieldNameId) {
	
	var text = document.getElementById(templateTextId).value;
	var objectType = document.getElementById(ObjectTypeId).value;
	
	var fieldName= document.getElementById(fieldNameId).value;
	if(fieldName == 'None' || fieldName == '' || fieldName.length == 0) return false;
	
	
	// Updated code to insert field value at the cursor position
	
	var elementRef = document.getElementById(templateTextId);
 	var valueToInsert = "{!"+objectType+"."+fieldName +"}";
 	
 	try{
 	
	if ( document.selection )
	 {
 		 // Internet Explorer...
 	
  	elementRef.focus();
  	var selectionRange = document.selection.createRange();
  	selectionRange.text = valueToInsert;
 	}
 	else if ( (elementRef.selectionStart) || (elementRef.selectionStart == '0') )
 	{
  		// Mozilla/Netscape...

  	var startPos = elementRef.selectionStart;
	var endPos = elementRef.selectionEnd;
	elementRef.value = elementRef.value.substring(0, startPos) +
    valueToInsert + elementRef.value.substring(endPos, elementRef.value.length);
     	elementRef.selectionStart = elementRef.selectionStart + valueToInsert.length;
     
	}
 	else
 	{
 	 elementRef.value += valueToInsert;
 	 elementRef.selectionStart = elementRef.selectionStart + valueToInsert.length;
 	 
 	}
  }catch(e){
 	alert(e);
  }
	
	
    return false;
}
