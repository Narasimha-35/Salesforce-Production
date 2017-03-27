function moveOptionsUp(selectId) {
 var selectList = document.getElementById(selectId);
 var selectOptions = selectList.getElementsByTagName('option');
 for (var i = 1; i < selectOptions.length; i++) {
  var opt = selectOptions[i];
  if (opt.selected) {
   selectList.removeChild(opt);
   selectList.insertBefore(opt, selectOptions[i - 1]);
     }
    }
}
function moveOptionsDown(selectId) {
 var selectList = document.getElementById(selectId);
 var selectOptions = selectList.getElementsByTagName('option');
 for (var i = selectOptions.length - 2; i >= 0; i--) {
  var opt = selectOptions[i];
  if (opt.selected) {
   var nextOpt = selectOptions[i + 1];
   opt = selectList.removeChild(opt);
   nextOpt = selectList.replaceChild(opt, nextOpt);
   selectList.insertBefore(nextOpt, opt);
     }
    }
}
function moveOptionsAcross(fromSelectId, toSelectId) {
 var fromSelectList = document.getElementById(fromSelectId);
 var toSelectList = document.getElementById(toSelectId);
  var selectOptions = fromSelectList.getElementsByTagName('option');
  for (var i = 0; i < selectOptions.length; i++) {
     var opt = selectOptions[i];
     if (opt.selected) {
      fromSelectList.removeChild(opt);
      toSelectList.appendChild(opt);
      i--;
     }
   }
}
function currentSelectionString(selectId) {
  var selectList = document.getElementById(selectId);
  var selectOptions = selectList.getElementsByTagName('option');
  var res = '[';
  for (var i = 0; i < selectOptions.length; i++) {
    if (i > 0) {
      res += ', ';
    }
    res += selectOptions[i].value;
  }
  return res + ']';
}

function setActiveFields(fieldsId, selectId) {
  var e = document.getElementById(fieldsId);
  e.value = currentSelectionString(selectId);
}

function selectItemByName(selectId, name) {
  var selectList = document.getElementById(selectId);
  var selectOptions = selectList.getElementsByTagName('option');
  for (var i in selectOptions) {
    var so = selectOptions[i];
    if (selectOptions[i].value == name) {
      selectOptions[i].selected = true;
      return;
    }
  }
}

function initActiveValues(fieldsId, fromSelectId, toSelectId) {
  var e = document.getElementById(fieldsId);
  var s = e.value.substring(1, e.value.length - 1);
  var items = s.split(', ');
  for (var i in items) {    
    selectItemByName(fromSelectId, items[i]);
    moveOptionsAcross(fromSelectId, toSelectId);
  }
}
