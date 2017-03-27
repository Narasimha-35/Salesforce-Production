var mtype2ops = new Array();
mtype2ops['AUTONUMBER'] = ['e','n','c','k','s'];
mtype2ops['PERCENT'] = ['e','n','l','g','m','h'];
mtype2ops['BLOB'] = null;
mtype2ops['FAX'] = ['e','n','c','k','s'];
mtype2ops['DOUBLE'] = ['e','n','l','g','m','h'];
mtype2ops['EMAIL'] = ['e','n','c','k','s'];
mtype2ops['PHONE'] = ['e','n','c','k','s'];
mtype2ops['MULTILINETEXT'] = ['e','n','c','k','s'];
mtype2ops['INTEGER'] = ['e','n','l','g','m','h'];
mtype2ops['CURRENCY'] = ['e','n','l','g','m','h'];
mtype2ops['TEXT'] = ['e','n','c','k','s'];
mtype2ops['BOOLEAN'] = ['e','n'];
mtype2ops['DATETIME'] = ['e','n','l','g','m','h'];
mtype2ops['DATE'] = ['e','n','l','g','m','h'];
mtype2ops['ID'] = ['e','n'];
mtype2ops['PICKLIST'] = ['e','n','l','g','m','h','c','k','s'];
mtype2ops['MULTIPICKLIST'] = ['e','n','u','x'];
mtype2ops['REFERENCE'] = ['e','n','l','g','m','h','c','k','s'];
mtype2ops['STRING'] = ['e','n','l','g','m','h','c','k','s'];
mtype2ops['TEXTAREA'] = ['e','n','l','g','m','h','c','k','s'];
  
var optLabels = new Array();
optLabels['e'] = 'equals';optLabels['n'] = 'not equal to';optLabels['s'] = 'starts with';
optLabels['c'] = 'contains';optLabels['k'] = 'does not contain';optLabels['l'] = 'less than';
optLabels['g'] = 'greater than';optLabels['m'] = 'less or equal';
optLabels['h'] = 'greater or equal';optLabels['u'] = 'includes';optLabels['x'] = 'excludes';

var type;
var filterId;

function addItemToSelect(select,value,label){
	var len = select.length;
	select[len]= new  Option(label,value) ;
}

function appendOptions(){
	var f = document.getElementById(filterId);
	f.innerHTML = "";
	for ( T in  mtype2ops){
		if ( T == type){
			typeOpt = mtype2ops[T];
			addItemToSelect(f,"","--"+noneLabel+"--");
			//for (i in typeOpt){
			for (var  i=0 ; i <typeOpt.length ; i++ ){
				var label = optLabels[typeOpt[i]];
				addItemToSelect(f,typeOpt[i],label);
			}
			break;
		}
	}		
}

function setFilter(select,filterNum){
	if (select.value==""){
		appendFilterSelect('filter'+filterNum);
		return;
	}
	var TF = select.value.split(',');
	type = TF[0];
	filterId='filter'+filterNum;
	appendOptions();
	/* new v2 */
	$("#"+filterId).get(0).selectedIndex = 1;
	var API = TF[1];	
	var lookup = $("#fa"+filterNum);

	if(type=='PICKLIST'||type=='MULTIPICKLIST' || type == 'BOOLEAN'){
			lookup.removeClass('hidden');
			lookup.addClass('visible');
			lookup.click(function() {
			  openSelectPickListValue(SFObjectID,API,"value"+filterNum);
			});
		}
		else{
			lookup.addClass('hidden');
			lookup.removeClass('visible');
		}
	var value=$("#value"+filterNum);
	value.removeAttr("onclick");	
	if(type=='DATE'||type=='DATETIME'){
	
		var pathOnClickDP = "DatePicker.pickDate(true, 'value"+filterNum+"', false, this);DatePicker.datePicker.cancelHide(getEvent(event));";
		value.attr("onclick",pathOnClickDP); 
	}
}   



function appendFilterSelect(selectIdToAppend){
	var select = document.getElementById(selectIdToAppend);
	select.innerHTML = "";
	var mainFilter = document.getElementById('filter');
	addItemToSelect(select,"","--"+noneLabel+"--");
	for (var i=0; i<mainFilter.length ;i++) 
		addItemToSelect(select,mainFilter[i].value,mainFilter[i].text);
}

function sortSelect(SFSelect) {
	
	var my_options = $(SFSelect+" option");

	my_options.sort(function(a,b) {
	    if (a.text > b.text) return 1;
	    else if (a.text < b.text) return -1;
	    else return 0
	})
	
	$(SFSelect).empty().append( my_options );
		
	var related = $(SFSelect+' option:contains(":")');
	related.remove();
	$(SFSelect).append (related);
	
	return;
}

function setSelected(select,val){
	for(var i = 0 ; i < select.length ; i++) {
	  if(select[i].value == val)
	    select.selectedIndex = i;
	}
}

function advanced(){
    $("span [id^='and']").html('');
    $('#standardLink').css("display","inline");
    $('#advancedLink').css("display","none");
    $('#advancedBlock').css("display","block");
    //document.getElementById('{!$Component.advanced}').value='true';
    $("#advanced input").val('true')
        
} 
function standard(){
    
    $("span [id^='and']").html(AND_Label);
    $('#standardLink').css("display","none");
    $('#advancedLink').css("display","inline");
    $('#advancedBlock').css("display","none");
    //document.getElementById('{!$Component.advanced}').value='false';
    $("#advanced input").val('false')
}

function showAdvanced(){
    //var adv = document.getElementById('{!$Component.advanced}');
    if ($("#advanced input").val()=='true')  advanced();
}

function appendFieldSelect(selectIdToAppend){
    var select = document.getElementById(selectIdToAppend);
    //var SFselect = document.getElementById('{!$Component.SFObjFields}');
    var SFselect = $("#sfselect select").get(0);
    for ( var i = 0 ; i < SFselect.length ; i++ ){
        addItemToSelect(select,SFselect[i].value,SFselect[i].text);
    }   
}
 
function setSql(){

	//?? remove for production
	//   debugger;

    var type;
    var field;
    var filter;
    var value;
    var fr= $('#fr input');

    for ( var i = 1 ; i < ( NOF + 1) ; i++ ){
        type = document.getElementById('fields'+i).value.split(',')[0];
        field = document.getElementById('fields'+i).value.split(',')[1];
        filter = document.getElementById('filter'+i).value;
        value = document.getElementById('value'+i).value;
    
        if (type==undefined||field==undefined ||filter==''||value=='') {
            fr.get(i-1).value='null';
            continue;
        }
        
        fr.get(i-1).value=type+'~'+field+'~'+filter+'~'+value;
    }   
}



function setFilters(){
    var select ;
    var filter ;
    var value ;
    var fr= $('#fr input');
    for(var i = 1 ; i < ( NOF + 1) ; i++) {
        select = document.getElementById('fields'+i);
        filter = document.getElementById('filter'+i);
        value = document.getElementById('value'+i);
        setFiterRow(fr.get(i-1).value,select,filter,value,i);
    }

}  

function setFiterRow(SFfr,select,filter,valueField,index){
    var tsvl = SFfr.split('~');
    var  sField = tsvl[0]+","+tsvl[1];
    var  sFilter = tsvl[2];
    var  sValue = tsvl[3];
    if (SFfr!='null'){
        setSelected(select,sField);
        setFilter(select,index);
        setSelected(filter,sFilter);        
        valueField.value=sValue;
    }
}

function clearFilter(){

    $("#mainfilters select").each(function (){
        this.selectedIndex=0;
    });
    
    $("#mainfilters input").each(function (){
        this.value="";  
    });
    
    $("#mainfilters div [id^='fa']").each(function (){
        $(this).addClass('hidden');
        $(this).removeClass('visible');
    });
}
function openSelectPickListValue(obj,field,sender){
         var host = window.location.host;
         //host = host.replace('c.','balinkdevutils.'); at pkg
         if(field.indexOf(".")>=0){
         	var newParams=field.split(".");
         	obj=newParams[0];
         	field=newParams[1];
         }
         if(obj.indexOf("__r")>=0)obj=obj.slice(0,-3);
         var url = "/apex/Utils_SelectPickListValue?id="+obj+"&&s="+sender+"&&f="+field; // "https://" + host + "/
         var centerWidth = (window.screen.width - 550) / 2;
         var centerHeight = (window.screen.height - 450) / 3;
         mywindow = window.open (url, "pickuplist","top="+centerHeight+",left="+centerWidth+",location=0,status=0,scrollbars=0,menubar=0,titlebar=no,toolbar=0, width=550,height=450"); 
}

function setSenderValue(sender,value){
	//sender = escapeHtml(sender);
	//value = escapeHtml(value);
    $("#"+sender).val(value);
}

 function escapeHtml(unsafe) 
		{
			if(unsafe == "undefined" || unsafe == null)
				return escape(unsafe);
			if(!isNaN(unsafe))
				return escape(unsafe);
			return escape(unsafe.replace(/&(?!amp;)/g,
				"&amp;").replace(/<(?!lt;)/g, "&lt;").replace(/>(?!gt;)/g,
				"&gt;").replace(/"(?!quot;)/g, "&quot;").replace(/'(?!#039;)/g, "&#039;"));
		}

function createRow(rowNumber){
	var newRow =$('<tr></tr>');
	var td1=$('<td style="display:none">'+rowNumber+'.&nbsp;</td>');
	var td2=$('<td><select id="fields'+rowNumber+'" onchange="setFilter(this,'+rowNumber+')"></select></td>');
	var td3=$('<td><select id="filter'+rowNumber+'" ></select></td>');
	var td4=$('<td></td>');
	var input=$(' <input type="text" id="value'+rowNumber+'"/> ');		
	var span = $('<span  class="lookupSPV">  <a id="fa'+rowNumber+'" class="hidden"  href="javascript:void(0)"></a></span>');
	td4.append(input);
	td4.append(span);
	var td5 = $('<td><span id="and'+rowNumber+'">'+andLabel+'</span><span style="display:none" id="MoreFilters'+rowNumber+'"><a class="MoreFilter" onclick="showHideMoreFilters()" href="javascript:void(0);">'+More_filters+'&gt;&gt;</a></span></td> ');
	newRow.append(td1);
	newRow.append(td2);
	newRow.append(td3);
	newRow.append(td4);
	newRow.append(td5);
	return newRow;
}

