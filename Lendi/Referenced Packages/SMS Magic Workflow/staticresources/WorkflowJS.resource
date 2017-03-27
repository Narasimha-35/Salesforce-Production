
function selectFields(selectedValue,action, objectType, fieldListId, mobileFieldListId, searchFieldId, selectedFieldsElId,campaignRelatedUserListId){
    
        
        var searchFieldValue = null; 
        var selectedValueList = null;
        var selectedMobileFieldValueList = null;
        var campaignRelatedUserFieldValueList = null;
        
        if(objectType == 'sObject'){
           
            searchFieldValue = document.getElementById(searchFieldId).value; 
            selectedValueList = document.getElementById(fieldListId).value;
            selectedMobileFieldValueList = document.getElementById(mobileFieldListId).value; 
        }
        if(objectType == 'Campaign'){
          
            campaignRelatedUserFieldValueList = document.getElementById(campaignRelatedUserListId).value;
        }
        
        if(action == 1){
            var len = selectedValue.length;
            if(objectType == 'sObject' && searchFieldValue == 'relatedUser'){
                var isSelected = false;
                var mainPattern = new RegExp(","+selectedValue+"(,|$)", "i");
                isSelected = mainPattern.test(selectedMobileFieldValueList);
                if(!isSelected)
                    selectedValueList += ',' +  selectedValue;
            }
            else if(objectType == 'sObject' && searchFieldValue == 'mobileField'){
                var isSelected = false;
                var mainPattern = new RegExp(","+selectedValue+"(,|$)", "i");
                isSelected = mainPattern.test(selectedMobileFieldValueList);
                if(!isSelected)
                    selectedMobileFieldValueList += ',' +  selectedValue;
            }
            if(objectType == 'Campaign'){
                var isSelected = false;
                var mainPattern = new RegExp(","+selectedValue+"(,|$)", "i");
                isSelected = mainPattern.test(selectedMobileFieldValueList);
                if(!isSelected)
                    campaignRelatedUserFieldValueList += ',' +  selectedValue;
            }
        } 
        else {
            var len = selectedValue.length;
            if(objectType == 'sObject' && searchFieldValue == 'relatedUser')
                selectedValueList =  selectedValueList.replace(','+selectedValue, '');
            else if(objectType == 'sObject' && searchFieldValue == 'mobileField'){
                selectedMobileFieldValueList =  selectedMobileFieldValueList.replace(','+selectedValue, '');
            }
            
            if(objectType == 'Campaign')
                campaignRelatedUserFieldValueList =  campaignRelatedUserFieldValueList.replace(','+selectedValue, '');
                
            if(len == 0){
                selectedValueList = '';
                selectedMobileFieldValueList = '';
            }
        }
        if(objectType == 'sObject'){
            document.getElementById(fieldListId).value = selectedValueList;
            document.getElementById(mobileFieldListId).value = selectedMobileFieldValueList;
        }
        if(objectType == 'Campaign')
            document.getElementById(campaignRelatedUserListId).value = campaignRelatedUserFieldValueList;
    }

    function addToList(objIdFrom,objIdTo,action,objectType, fieldListId, mobileFieldListId, searchFieldId, selectedFieldsElId, campaignRelatedUserListId){

        var elementRef = document.getElementById(objIdFrom);
        var selectedObjElement = document.getElementById(objIdTo);
        var selectedIndex = elementRef.selectedIndex;
        
        if(selectedIndex == -1){
            var errorMsg = "Please select recipient to add.";
            if(action == 2)
                errorMsg = "Please select recipient to remove.";
            alert(errorMsg);
        }
        
        if(selectedObjElement.options  != undefined && selectedObjElement.options.length == 1 && selectedObjElement.options[0].value.length == 0){
              selectedObjElement.options[0] = null; 
        }
        var selected = elementRef.children[selectedIndex];
        var selectedObject = selected.value;
        var selectedObjectText = selected.text;
        elementRef.options[selectedIndex] = null;
        
        var selectedIndex2 = selectedObjElement.selectedIndex;
        if(selectedIndex2 >= 0 ){
             selectedObjElement.children[selectedIndex2].selected = false;
        }
        
                
        var searchFieldValue = null;
        var selectedValueList = null;
        var selectedMobileFieldValueList = null;
        var campaignRelatedUserFieldValueList = null;
        

      
        if(objectType == 'sObject'){
        	
            searchFieldValue = document.getElementById(searchFieldId).value;
            selectedValueList = document.getElementById(fieldListId).value;
            selectedMobileFieldValueList = document.getElementById(mobileFieldListId).value;
        }
       
        if(objectType == 'Campaign'){
        	
            campaignRelatedUserFieldValueList = document.getElementById(campaignRelatedUserListId).value;
           
        }
        if(objectType == 'Campaign'){
            
            var oOption = document.createElement("OPTION");
            oOption.text = selectedObjectText;
            oOption.value = selectedObject;
            oOption.selected = true;
            
            if(selectedObjElement.length > 0){
                try{
                    for(var i=0; i< selectedObjElement.length; i++){
                        if(selectedObjElement.options[i].value == selectedObject){
                            selectedObjElement[i] = oOption
                        }
                        else
                            selectedObjElement.options.add(oOption);
                    }
                }catch(ex){
                    alert("Exception : "+ex);
                }
            }
            else
                selectedObjElement.options.add(oOption);
            
            if(action == 2){
                selectedObjElement.options.add(oOption);
            }
        }
        
        if(objectType == 'sObject' && searchFieldValue == 'relatedUser'){
            
            var oOption = document.createElement("OPTION");
            oOption.text = selectedObjectText;
            oOption.value = selectedObject;
            oOption.selected = true;
            
            if(selectedObjElement.length > 0){
                try{
                    
                    for(var i=0; i< selectedObjElement.length; i++){
                        if(selectedObjElement.options[i].value == selectedObject)
                            selectedObjElement[i] = oOption;
                        else
                            selectedObjElement.options.add(oOption);
                    }
                }catch(ex){
                    alert("Exception : "+ex);
                }
            }
            else
                selectedObjElement.options.add(oOption);
            
            if(action == 2){
                selectedObjElement.options.add(oOption);
            }
        }
        else if(objectType == 'sObject' && searchFieldValue == 'mobileField'){
        
            var oOption = document.createElement("OPTION");
            oOption.text = selectedObjectText;
            oOption.value = selectedObject;
            oOption.selected = true;
            if(selectedObjElement.length > 0){
                try{
                    for(var i=0; i< selectedObjElement.length; i++){
                        if(selectedObjElement.options[i].value == selectedObject){
                            selectedObjElement[i] = oOption
                        }
                        else
                            selectedObjElement.options.add(oOption);
                    }
                }catch(ex){
                    alert("Exception : "+ex);
                }
            }
            else
                selectedObjElement.options.add(oOption);
            
            if(action == 2){
                selectedObjElement.options.add(oOption);
            }
        }
       
        selectFields(selectedObject,action,objectType,fieldListId, mobileFieldListId, searchFieldId, selectedFieldsElId,campaignRelatedUserListId); 
    }
    
    function clearList(objectId,campaignListId,objectListId){
        
        var objectType = document.getElementById(objectId).value;
        if(objectType == 'Campaign'){
            var selectedObjElement = document.getElementById(campaignListId);
            var listValue = document.getElementById(campaignListId).value;
            for(var i=0; i < selectedObjElement.options.length; i++){
                var selectedValue = selectedObjElement.options[i].value;
                var selectedText = selectedObjElement.options[i].text;
                selectedObjElement.options[i].value = "";
                selectedObjElement.options[i].text = "";
            }
        }
        else{
            var selectedObjElement = document.getElementById(objectListId);
            var listValue = document.getElementById(objectListId).value;
            for(var i=0; i < selectedObjElement.options.length; i++){
                var selectedValue = selectedObjElement.options[i].value;
                var selectedText = selectedObjElement.options[i].text;
                selectedObjElement.options[i].value = "";
                selectedObjElement.options[i].text = "";
            }
        }
    }
    
    function collapseSection(elementId){
        var displayElement = document.getElementById(elementId);
        var divDisplayVal = displayElement.style.display;
        
        if(divDisplayVal == "block"){
            displayElement.style.display = "none";
        }
        if(divDisplayVal == "none"){
            displayElement.style.display = "block";
        }
    }