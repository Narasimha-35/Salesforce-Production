

/**
 * 	@method 	: sendSMS()
 * 	@description: This function send the SMS based on parameter.
 * 	@param 		: String, Id, Id, String, String, String, String, String, String, boolean, String
 * 	@return		: void
 */
function sendSMS(recordTypeVar, recordIdVar, userId, nameFieldVal, mobileFieldVal, optOutFieldVal, smsType, elementIdVar, packagePrefix, showUserDropDownVal, dialogTitleVal){
	var queryString = parent.window.location.pathname;
 	var isFromPopup = false;
	var isFromVFPage = true;
	var selectedIds = new Array(); 
	var senderId = '';
	var isOptOut = false;
	var showUserDropDown = new Boolean(0);;
	var dialogTitle = 'Send SMS to '+recordTypeVar;
	var senderUserId = null;

	if(dialogTitleVal != null ){
		dialogTitleVal = $.trim(dialogTitleVal);
		if(dialogTitleVal.length > 0)
			dialogTitle = dialogTitleVal;
	}

	if(smsType != null){
		if(smsType == 'popup'){
			isFromPopup = true;
			isFromVFPage = false;
		}
	}
	
	if(showUserDropDownVal != null){
		if(showUserDropDownVal === false){
			showUserDropDown = false;
		}
		if(showUserDropDownVal === true){
			showUserDropDown = true;
		}
	}

	if(isFromPopup){
		var recordIdString = createSMSDialog(elementIdVar, recordTypeVar, recordIdVar, userId, nameFieldVal, mobileFieldVal, showUserDropDown);
		if(recordIdString == null){
			location.reload();
		}
		
		
		/*
		/////Change
		
		$(document).ready(function() {
	    	$("#smsDialog").dialog({ autoOpen: false, modal: true, position: 'center', close:function(event,ui){var jqueryCSSId = document.getElementById('jqueryCss'); if(jqueryCSSId !)} });
	   	});
	   	
	   	$("#smsDialog").dialog("open");
	    $('#smsDialog').dialog("option" , "title" , dialogTitle);
	    $('#smsDialog').dialog('option', 'position', 'center');
		   	
		//////Change
		*/
			
		$('#DialogTitle').html(dialogTitle);
		var mySplitResult = new Array();
		if(recordIdString != null){
			recordIdString = $.trim(recordIdString);
			mySplitResult = recordIdString.split(",");
		}
		else
			mySplitResult = recordIdVar.split(",");
		if(mySplitResult.length == 1){
			var str = mySplitResult[0];
			str = $.trim(str);
			selectedIds.push(str);
			$('#selectAllId').hide();
			$('#checkboxCol').hide();
		}
		if(mySplitResult.length > 1){
			var tempStrVar = '';
			for(i=0; i < mySplitResult.length;i++){
				tempStrVar = mySplitResult[i];
				tempStrVar = $.trim(tempStrVar);
				selectedIds.push(tempStrVar);
			}
		}

		//drag
		$(function() {
			$( "#InlineEditDialog" ).draggable();
		});

		// close of esc key press
		$(document).keydown(function(e) {
		    // ESCAPE key pressed
		    if (e.keyCode == 27) {
			location.reload();
		    }
		});

		// On change of dropdown fetch the template text and put it into the text area. 
		$('#tpl').change(function() {
			var tplId = 'tpl';
			changeTemplateText(tplId);
			charaterCounter();
		});

		// On clicking select all option
		$('#selectall').click(function(event) {
			checkboxes = document.getElementsByName('checkBoxForIndividualRecord');
			if(this.checked) {
				$(".checkBoxClass").prop("checked",true)
				for(i=0; i < checkboxes.length;i++){
					var checkedRecordId = checkboxes[i].value;
					checkedRecordId = $.trim(checkedRecordId);
					if(selectedIds.indexOf(checkedRecordId) == -1)
						selectedIds.push(checkedRecordId);
				}
			}
			else{
				$(".checkBoxClass").prop("checked",false);
				var lengthSize = selectedIds.length;
				selectedIds.splice(0, lengthSize);
			}
			var totalCount = "SMS will be sent to total "+selectedIds.length+' '+recordTypeVar;
			if(selectedIds.length > 1)
	    		totalCount = totalCount+"s";
		    $('#totalMsgCount').html(totalCount);
			
		});

		// on clicking particular checkbox
		$(function() {
			$('input[type="checkbox"]').bind('click',function() {
				if($(this).is(':checked')) {
					var checkedRecordId = $(this).val();
					checkedRecordId = $.trim(checkedRecordId);
					if(checkedRecordId != 'selectall' && selectedIds.indexOf(checkedRecordId) == -1)
						selectedIds.push(checkedRecordId);
				}
				else{
					var unCheckedRecordId = $(this).val();
					unCheckedRecordId = $.trim(unCheckedRecordId);
					if(document.getElementById("selectall").checked)
						document.getElementById("selectall").checked = false;
					//unCheckedRecordId = unCheckedRecordId.substring(0, unCheckedRecordId.length-3);
					var indexOfElement = selectedIds.indexOf(unCheckedRecordId);
					if(indexOfElement != -1)
						selectedIds.splice(indexOfElement, 1);
				}
				var totalCount = "SMS will be sent to total "+selectedIds.length+' '+recordTypeVar;
				if(selectedIds.length > 1)
	    			totalCount = totalCount+"s";
		    	$('#totalMsgCount').html(totalCount);
			});
		});
		
		if($('#defaultRadioButton1').is(':checked'))
			senderId = $('#defaultSenderIdVal').html();

		$('#defaultRadioButton1').click(
			function(){
			senderId = $('#defaultSenderIdVal').html();
			//$('#selectBox :nth-child(4)').attr('selected', 'selected')
			$('#senderIdList').val('0');
		});

		$('#defaultRadioButton2').click(
			function(){
			senderId = '';
		});

		$('#senderIdList').change(function() {
			$('#defaultRadioButton2').attr('checked', true);
			var selectedSenderId = $('#senderIdList').val();
			if(selectedSenderId != null)
				senderId = selectedSenderId;
		});
		

		senderUserId = $('#senderNameList').val();
		$('#senderNameList').change(function() {
			senderUserId = $('#senderNameList').val();
		}); 

		// on clicking send button
		$('#send').click(function(){
			
			try{
				senderId = $.trim(senderId);
				if(senderId == null || senderId.length == 0 || senderId == '0'){
					alert("Please select Sender Id");
					return null;
				}

				var smsTextVal = $('#smsText').val();
				smsTextVal = $.trim(smsTextVal);
				if(smsTextVal.length <= 0){
					alert('Please enter some text or choose template.');
					return null;
				}
				if(selectedIds.length <= 0){
					alert('Please at least one record.');
					return null;
				}
				if($('#optOutDropDown').val() == 'no')
					isOptOut = true;
				var response = pushSMSCallout(selectedIds, recordTypeVar, smsTextVal, senderId, mobileFieldVal, nameFieldVal, optOutFieldVal, isOptOut, showUserDropDown, senderUserId)
				if(response == '0')
					alert("SMS not sent. Please check the available balance & opt out settings.");
				else if(response == '1')
					alert(response+" sms sent successfully.");
				else
					alert(response+" sms's sents successfully.");
				location.reload();
			}catch(e){
				alert('exception : '+e);
			}
		});

		//on clicking close button
		$('#close').click(function(){
			location.reload();
		}); 
	}
	if(isFromVFPage){
		if (parent.window.location.search){ 
			queryString = queryString + parent.window.location.search 
		} 
		var url = "/apex/"+packagePrefix+"BulkSendSMS?retURL="+queryString+"&nameField=" +nameFieldVal +"&phoneField="+ mobileFieldVal+"&optOutField="+optOutFieldVal+"&objectType="+recordTypeVar+"&showUserDropDown="+showUserDropDown+"&recordIds="+recordIdVar;

		parent.window.location = url;
	}
}

/**
 * 	@method 	: pushSMSCallout()
 * 	@description: This function call the webservice method "sendSMS" to the send out SMS.
 * 	@param 		: Id, String, String, String, String, String, String, boolean, boolean, Id
 * 	@return		: String
 */
function pushSMSCallout(recordIdVal, recordTypeVal, smsTextVal, senderIdVal, mobileFieldVal, nameFieldVal, optOutFieldVal, isOptOut, showUserDropDownVal, senderUserIdVal){
	
	// encode the SMS Text
	smsTextVal = encodeURIComponent(smsTextVal);
	
	try{
		// call webservice method to send SMS
		var resp = sforce.apex.execute("smagicinteract.ApexAPI","sendSMS",
			             {recordIdsVar:recordIdVal,
			              objectTypeVar:recordTypeVal,
			              mobilePhoneFieldVar:mobileFieldVal,
			              nameFieldVar:nameFieldVal,
			              senderIdVar:senderIdVal,
			              templateTextVar:smsTextVal,
				      optOutFieldVar:optOutFieldVal,
				      isOptOutVar:isOptOut,
				      showUserDropDownVar:showUserDropDownVal,
				      senderUserIdVar:senderUserIdVal });
	}catch(err){
		alert("Error : "+err);
	}
	return resp;
}


/**
 * 	@method 	: createSMSDialog()
 * 	@description: This function creates the Dialog for sending SMS.
 * 	@param 		: String, String, Id, Id, String, String, boolean
 * 	@return		: void
 */
function createSMSDialog(elementIdVar, recordTypeVar, recordIdVar, userId, nameFieldVal, mobileFieldVal, showUserDropDownVal){
	var elementId = '';
	var recordIdString = '';
	if(elementIdVar.length <= 0 || elementIdVar == null)
		elementId = 'contentWrapper';
	else
		elementId = elementIdVar;
	
	var userList = null;
	if(showUserDropDownVal){
		var userListQuery = "select Id, Name from User where Id != '"+userId+"' and IsActive = true";
		var userListResult = sforce.connection.query(userListQuery);
		userList = userListResult.getArray("records");
	}

	var loggedInUserQueryStr = "Select ProfileId, Profile.Name from User where Id = '"+userId+"'";
	var loggedInUserResult = sforce.connection.query(loggedInUserQueryStr);
	var loggedInUserRecords = loggedInUserResult.getArray("records");
	
	var senderIdQueryStr = "Select  smagicinteract__senderId__c from smagicinteract__SMS_SenderId__c limit 100";
	var senderIdResult = sforce.connection.query(senderIdQueryStr);
	var senderIdRecords = senderIdResult.getArray("records");
	
	var recordType = recordTypeVar;
	var tplQueryStr = "Select Id, smagicinteract__Name__c, smagicinteract__ObjectName__c, smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__ObjectName__c = '"+recordType+"'";

	var tplResult = sforce.connection.query(tplQueryStr);
	var tplRecords = tplResult.getArray("records");
	var tplText = '';

	var recordIds = "";
	var mySplitResult = recordIdVar.split(",");
	var recordIdsLength = mySplitResult.length;

	for(var i = 0; i < recordIdsLength; i++){
		var tempId = '\''+mySplitResult[i]+'\'';
        	recordIds += ', ' + tempId;
        }
        recordIds = recordIds.substring(1);
        recordIds = '(' + recordIds + ')';
	if(nameFieldVal == null){
		nameFieldVal = 'Name';
	}
	if(mobileFieldVal == null){
		mobileFieldVal = 'MobilePhone';
	}
	var recordQueryStr = "Select Id, "+nameFieldVal+", "+mobileFieldVal+" from "+recordType+" where "+mobileFieldVal+" != null and Id in "+recordIds;
	var recordResult = sforce.connection.query(recordQueryStr);
	var records = recordResult.getArray("records");
	if(records.length == 0){
		alert("Mobile number missing! Please check the mobile field used in button code.");
		return null;
	}
	
	var tplText = '';
	
	//document.getElementsByTagName('body')[0].innerHTML
	document.getElementById(elementId).innerHTML += "<div id='InlineEditDialog' role='dialog' aria-live='assetive' aria-describedby='InlineEditDialogTitle' class='overlayDialog inlineEditDialog' style=' width: 450px; height: 450px; max-height: 1366px; max-width: 550px; display: block; left: 506.5px; top: 38.5px; visibility: visible;'><div class='topRight'><a title='Start of Dialog' style='width: 2px; height: 2px; position: absolute; border: 0pt none; margin: 0pt; padding: 0pt; background: none repeat scroll 0% 0% transparent; outline: medium none; z-index: -1; cursor: none;' onclick='return false;' href='javascript:void(0)' id='InlineEditDialogFocusPoint'>Start of Dialog</a><div class='topLeft' id='topLeft'><a class='dialogClose' href='javascript:void(0)' tabindex='0' title='Close' id='InlineEditDialogX' onclick='location.reload();'>Close</a><h2 id='InlineEditDialogTitle'><div id='DialogTitle'>SMS Dialog</div></h2></div></div><div class='middle'><div id='InlineEditDialogContent' class='innerContent'><div class='activeField'><div class='inlineEditCompoundDiv' id='lea16_ileinneredit'><table border='0' width='100%'><tbody><tr><table border='0'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='senderIdLabel'>Sender Id :</label><div id='senderIdLabel'></div></td><td class='labelCol' id='defaultSenderIdCol1' style='display:none;'><input id='defaultRadioButton1' type='radio' name='tplGroup' value='default' checked></td><td id='defaultSenderIdCol2' style='display:none;'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='radioButDiv'><div id='defaultSenderIdVal' style='max-width:122px;width:122px;overflow:hidden;'></div></label><div id='radioButDiv'></div></td><td class='labelCol'id='tdOfRadioButton2' style='display:none;'><input id='defaultRadioButton2' type='radio' name='tplGroup' value='notDefault'></td><td><select name='tpl' id='senderIdList' class='tpl' style='margin-left:5px;max-width:122px;width:122px;'><option value='0'>Select Sender Id</option></select></td></tr></tbody></table></tr><tr><table id='senderNameTable' border='0' style='display:none;'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='senderNameLabel'>Users :</label><div id='senderNameLabel'></div></td><td><select name='senderNameList' id='senderNameList' class='tpl' style='margin-left:5px;max-width:122px;width:122px;'></select></td></tr></tbody></table></tr><tr><table border='0'><tbody><tr><td id='senderIdMessage1' style='font-size: 91%; color:green; display:none;'></td></tr><tr><td id='senderIdMessage2' style='font-size: 91%; color:green; display:none;'></td></tr></tbody></table></tr><tr><td><div style='border-top: 1px solid #DBDBDB;border-top-width: 1px;border-top-style: solid;border-top-color: #DBDBDB; margin-top:5px;margin-bottom:5px;'></div></td></tr><tr><table border='0'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='templateLabel'>Template :</label><div id='templateLabel'></div></td><td><select name='tpl' id='tpl' class='tpl' style='margin-left:5px;max-width:122px;width:122px;'><option>Select</option></select></td></tr></tbody></table></tr><tr><td><div style='border-top: 1px solid #DBDBDB;border-top-width: 1px;border-top-style: solid;border-top-color: #DBDBDB; margin-top:5px;margin-bottom:5px;'></div></td></tr><tr><td><table><tbody><tr><td><div id='totalMsgCount' style='font-size: 91%; color:green; display:block;'></div></td></tr></tbody></table></td></tr><tr><div id='target' style='overflow-y: auto; max-width: 350px; max-height: 80px;'></div></tr><tr><td><div style='border-top: 1px solid #DBDBDB;border-top-width: 1px;border-top-style: solid;border-top-color: #DBDBDB; margin-top:10px;margin-bottom:5px;'></div></td></tr><tr><td><table><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;'>SMS Text :</label></td></tr><tr><td id='charCount' style='font-size: 91%; color:green;'>You can type maximum 700 characters.</td></tr></tbody></table></td></tr><tr><td ><textarea style='position:relative; left:-54px; margin-top:5px; resize: none;' rows='10' cols='40' name='smsText' id='smsText' onkeyup='charaterCounter();'>"+tplText+"</textarea></td></tr><tr><td><div style='border-top: 1px solid #DBDBDB;border-top-width: 1px;border-top-style: solid;border-top-color: #DBDBDB; margin-top:10px;margin-bottom:5px;'></div></td></tr><tr><td><table border='0'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='optOut'>Send to Optout members :</label><div id='optOut'></div></td><td><select name='optOutDropDown' id='optOutDropDown' class='tpl' style='margin-left:5px;'><option value='yes'>Yes</option><option value='no'>No</option></select></td></tr></tbody></table></td></tr></tbody></table></div></div><div></div><div style='display: none;'></div><div class='buttons' id='InlineEditDialog_buttons'><input type='submit' onclick='' value='Send' class='btn' id='send'><input type='submit' id='close' onclick='' value='Cancel' class='btn' id='close'></div></div></div><div class='bottomRight'><input type='text' style='width: 2px; height: 2px; position: absolute; border: 0pt none; margin: 0pt; padding: 0pt; background: none repeat scroll 0% 0% transparent; outline: medium none; z-index: -1; cursor: none;' id='InlineEditDialogBlurCatch'><div class='bottomLeft'></div></div></div><div class='overlayBackground' id='backgroundOfDiag' style='width: 2000px; height: 4000px; display: block;' ></div>";

	//document.getElementById(elementId).innerHTML += "<div id='smsDialog' class='middle'><table border='0'><tbody><tr><table border='0'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='senderIdLabel'>Sender Id :</label><div id='senderIdLabel'></div></td><td class='labelCol' id='defaultSenderIdCol1' style='display:none;'><input id='defaultRadioButton1' type='radio' name='tplGroup' value='default' checked></td><td id='defaultSenderIdCol2' style='display:none;'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='radioButDiv'><div id='defaultSenderIdVal'></div></label><div id='radioButDiv'></div></td><td class='labelCol'id='tdOfRadioButton2' style='display:none;'><input id='defaultRadioButton2' type='radio' name='tplGroup' value='notDefault'></td><td><select name='tpl' id='senderIdList' class='tpl' style='margin-left:5px;'><option value='0'>Select Sender Id</option></select></td></tr></tbody></table></tr><tr><table id='senderNameTable' border='0' style='display:none;'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='senderNameLabel'>Users :</label><div id='senderNameLabel'></div></td><td><select name='senderNameList' id='senderNameList' class='tpl' style='margin-left:5px;'></select></td></tr></tbody></table></tr><tr><table border='0'><tbody><tr><td id='senderIdMessage1' style='font-size: 91%; color:green; display:none;'></td></tr><tr><td id='senderIdMessage2' style='font-size: 91%; color:green; display:none;'></td></tr></tbody></table></tr><tr><table border='0'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='senderIdLabel'>Template :</label><div id='templateLabel'></div></td><td><select name='tpl' id='tpl' class='tpl' style='margin-left:5px; max-length:30px;'><option>Select</option></select></td></tr></tbody></table></tr><tr><td></td></tr><tr><td></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><table><tbody><tr><td><div id='totalMsgCount' style='font-size: 91%; color:green; display:block;'></div></td></tr></tbody></table></td></tr><tr><div id='target' style='overflow-y: auto; max-width: 350px; max-height: 80px;'></div></tr><tr><td><table><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;'>SMS Text :</label></td></tr><tr><td id='charCount' style='font-size: 91%; color:green;'>You can type maximum 700 characters.</td></tr></tbody></table></td></tr><tr><td ><textarea style='position:relative; left:-54px; margin-top:20px; resize: none;' rows='10' cols='40' name='smsText' id='smsText' onkeyup='charaterCounter();'>"+tplText+"</textarea></td></tr><tr><td></td></tr><tr><td><table border='0'><tbody><tr><td class='labelCol'><label style='float:left;font-weight:bold;font-size: 91%;margin-top:6px;margin-bottom:5px;margin-left:-5px;' for='optOut'>Send to Optout members :</label><div id='optOut'></div></td><td><select name='optOutDropDown' id='optOutDropDown' class='tpl' style='margin-left:5px;'><option value='yes'>Yes</option><option value='no'>No</option></select></td></tr></tbody></table></td></tr></tbody></table></div></div><div></div><div style='display: none;'></div><div class='buttons' id='InlineEditDialog_buttons'><input type='submit' onclick='' value='Send' class='btn' id='send'><input type='submit' id='close' onclick='' value='Cancel' class='btn' id='close'></div>";
	if(records.length > 0){

	    var fieldArray = new Array();
	    fieldArray[0] = 'Id';
	    fieldArray[1] = nameFieldVal;
	    fieldArray[2] = mobileFieldVal;
            var content = '';
	    var content = '';	
            content += '<table id="basicTable" style="border: 1px sold black; width:100%;">';
            content += '<tr style="background-color:#D7ECF9;">'
    	    content += '<th id="selectAllId" style="width:5%;text-align:left; display:block;"><input type="checkbox" id="selectall" name="selectall" value="selectall" checked/></th>';
	    content += '<th style="width:60%;text-align:left;">Name</th><th style="width:20%;text-align:left;">Mobile Number</th></tr>';
	    for (var i = 0; i < records.length; i++) {
	        
		var recordArray = new Array();
		recordArray = records[i];
		recordIdString +=', '+recordArray[fieldArray[0]]; 
                content += '<tr>';
		content += '<td id="checkboxCol" name="checkboxCol" style="width:5%;text-align:left;border: 1px sold black; display:block;">';
		content += '<input type="checkbox" class="checkBoxClass" name="checkBoxForIndividualRecord" value="'+recordArray[fieldArray[0]]+'" checked/>';
		content += '</td>';
		content += '<td name="cName" style="width:50%;text-align:left;border: 1px sold black;">';
		content += recordArray[fieldArray[1]];
		content += '</td>';
                content += '<td name="cMobile" style="width:30%;text-align:left;border: 1px sold black;">';
		content += recordArray[fieldArray[2]];
                content += '</td>';
                content += '</tr>';
            }
	    content += '</table>';
	    $('#target').append(content);
	    var totalCount = "SMS will be sent to total "+records.length+' '+recordType;
	    if(records.length > 1)
	    	totalCount = totalCount+"s";
	    $('#totalMsgCount').html(totalCount);
	    
	    if(recordIdString != null){
		    recordIdString = $.trim(recordIdString);
		    if(recordIdString.charAt(0) == ',')
			recordIdString = recordIdString.substring(1, recordIdString.length);

	    }
	}

	if(senderIdRecords.length > 0){
		for (var i=0; i< senderIdRecords.length; i++) {
			var senderIdVal = String(senderIdRecords[i].smagicinteract__senderId__c);
			if(senderIdVal.length > 15)
				senderIdVal = senderIdVal.substring(0,15)+'..';
			$('#senderIdList').append(new Option(senderIdVal,senderIdRecords[i].smagicinteract__senderId__c));
		}
	}
	else{
		var senderIdVal = 'smsMagic';
		$('#senderIdList').append(new Option(senderIdVal,senderIdVal));
	}
	
	if(showUserDropDownVal && userList.length > 0){

		for (var i=0; i< userList.length; i++) {
		   $('#senderNameList').append(new Option(userList[i].Name,userList[i].Id));
		}
		$('#senderNameTable').show();
	}
	
	var combo = document.getElementById("tpl");
	for (var i=0; i< tplRecords.length; i++) {
		var tplName = String(tplRecords[i].smagicinteract__Name__c);
		if(tplName.length > 15)
			tplName = tplName.substring(0,15)+'..';
		$('#tpl').append(new Option(tplName,tplRecords[i].smagicinteract__Name__c));
	}
	//try{
	fetchDefaultSenderId(userId);
	//}catch(e){
	//	alert('Caught this Exception');
	//}
	return recordIdString;
}


/**
 * 	@method 	: fetchDefaultSenderId()
 * 	@description: This function fetch the default sender id, set for the logged in user's profile.
 * 	@param 		: Id
 * 	@return		: void
 */
function fetchDefaultSenderId(userId){

	var loggedInUserQueryStr = "Select ProfileId, Profile.Name from User where Id = '"+userId+"'";
	var loggedInUserResult = sforce.connection.query(loggedInUserQueryStr);
	var loggedInUserRecords = loggedInUserResult.getArray("records");
	if(loggedInUserRecords.length > 0){
		var defaultSenderIdQueryStr = "Select smagicinteract__Profile__c, smagicinteract__Sender_Id__c from smagicinteract__SenderId_Profile_Map__c where smagicinteract__Profile__c = '"+loggedInUserRecords[0].Profile.Name+"'";
		var defaultSenderIdResult = sforce.connection.query(defaultSenderIdQueryStr);
		var defaultSenderIdRecords = defaultSenderIdResult.getArray("records");

		if(defaultSenderIdRecords.length > 0){
			$('#defaultSenderIdVal').html(defaultSenderIdRecords[0].smagicinteract__Sender_Id__c);
			$('#defaultSenderIdCol1').show();
			$('#defaultSenderIdCol2').show();
			$('#tdOfRadioButton2').show();
			var senderIdMsg = '"'+defaultSenderIdRecords[0].smagicinteract__Sender_Id__c+'" is the default Sender Id for this profile ("'+loggedInUserRecords[0].Profile.Name+'")';
			$('#senderIdMessage2').html(senderIdMsg);
			$('#senderIdMessage2').show();
			$('#senderIdMessage1').hide();
		}
		else{
			var senderIdMsg = 'Default Sender Id is not configured for this profile ("'+loggedInUserRecords[0].Profile.Name+'")';
			$('#senderIdMessage1').html(senderIdMsg);
			$('#senderIdMessage1').show();
			$('#senderIdMessage2').hide();
		}
	}
}


/**
 * 	@method 	: changeTemplateText()
 * 	@description: This function change the template text accourding to the selected template.
 * 	@param 		: Id
 * 	@return		: void
 */
function changeTemplateText(templateId){

	var templateIdVar = '#'+templateId;
	var tplName = $(templateIdVar).val();
	var queryStr = "Select Id, smagicinteract__Name__c, smagicinteract__ObjectName__c, smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c= '"+tplName+"'";
	tplResult = sforce.connection.query(queryStr);
	tplRecords = tplResult.getArray("records");

	if(tplRecords.length > 0){
	    $("#smsText").val(tplRecords[0].smagicinteract__Text__c);
	}
	else{
	    $("#smsText").val('');
	}
}

/**
 * 	@method 	: charaterCounter()
 * 	@description: This function counts the total charater remaing.
 * 	@param 		: void
 * 	@return		: void
 */
 
 
function charaterCounter(){
	var maxLimit = 700;
	var txtField = document.getElementById("smsText");
	var currentCount = txtField.value.length;
	var remainingCharMsgDiv = document.getElementById("charCount");
	var noOfCharMsg = remainingCharMsgDiv.innerHTML;
	var remaingChars = 700;
	var msg = "";
	if(currentCount > maxLimit){
		txtField.value = txtField.value.substring(0, maxLimit);
		remaingChars = 0; 
	}
	else{
		remaingChars = maxLimit - currentCount;
	}
	msg = "You can type maximum "+remaingChars+" characters.";
	if(remaingChars == 0)
		msg = "You have reached to the maximum charater limit of 700.";
	remainingCharMsgDiv.innerHTML = msg;
}