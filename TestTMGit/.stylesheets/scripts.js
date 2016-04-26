var IE = document.all?true:false
if (!IE) document.captureEvents(Event.MOUSEMOVE)
isIE=document.all;
isNN=!document.all&&document.getElementById;
isN4=document.layers;
var showed = "";
var actualLevel = 0;

function showActiveLink (currentLink) {
  var x= document.getElementById("visited");
  x.style.background="";
  x.id="";

  currentLink.id="visited";
  currentLink.style.background="yellow";
}

function expandSubmenu(subid, level) {
	
	aList = document.getElementsByTagName('a');

	//for (int i=0;i<aList.lenght;i++)
	//{
	
	//}

    if (level!=666)
	{
	    showed = subid;
	    mylayer = document.getElementById(subid);

	    if (mylayer.style.display == "block") 
		{
		
		mylayer.style.visibility="hidden";
      	    	mylayer.style.display = "none";
		}
 
	    else if (mylayer.style.display == "none") 
		{
      	    	mylayer.style.display = 'block';
     	    	if (isIE||isNN) mylayer.style.visibility="visible";
      	    	else if (isN4) mylayer.visibility="show";
		}
	}
}

//function Back() {  /* lpokoradi: Removed, because the link using it was removed. */
//    alert("A Vissza még nincs kész!");
//}

function expandSubmenu2(subid) {
    if ((showed > 0) && (showed != subid)) collapseSubmenu(showed);
    showed = subid;

    mylayer = document.getElementById("submenu_"+subid);
    mylayer.style.display = 'block';
    if (isIE||isNN) mylayer.style.visibility="visible";
    else if (isN4) mylayer.visibility="show";
}


function collapseSubmenu(subid) {
  document.getElementById(subid).style.display = "none";
}

function collapseSubmenu2(subid) {
  return;
  document.getElementById("submenu_"+subid).style.display = "none";
//  alert("miert2?");
}

function expandSubmenu3(subid) {
    if ((showed > 0) && (showed != subid)) collapseSubmenu(showed); 
 
    showed = subid;
    mylayer = document.getElementById("submenu_"+subid);
    positionElement = document.getElementById("subMenuPlace");
//    mylayer.style.top = 138 + sorszam*23 + 'px';

    if (mylayer.style.display == "none") {
	mylayer.style.top = positionElement.style.top; 
	mylayer.style.left = positionElement.style.left;
//      mylayer.style.left = tempX+10 + 'px';
        //mylayer.style.top = tempY-10 + 'px';
//      mylayer.style.left = tempX+10 + 'px';
//      mywidth = getWindowWidth();
//      mylayer.style.left = Math.round((mywidth-980)/2) + 810 - 11 - 170 + 'px';
      mylayer.style.display = 'block';
      if (isIE||isNN) mylayer.style.visibility="visible";
      else if (isN4) mylayer.visibility="show";
    }
}

var currentDefect=1;
var lastMenuID='';
var lastBookmarkID='';

function getElementsByName_iefix(tag, name) {
     
     var elem = document.getElementsByTagName(tag);
     var arr = new Array();
     for(i = 0,iarr = 0; i < elem.length; i++) {
          att = elem[i].getAttribute("name");
          if(att == name) {
               arr[iarr] = elem[i];
               iarr++;
          }
     }
     return arr;
}


function jumpToNextDefect(noDefs) {
  while ((!document.getElementById("def"+(++currentDefect)) || 
    document.getElementById("def"+currentDefect).parentNode.style.visibility=="hidden") &&
    currentDefect<=noDefs) {
  }
  window.location.assign("#def"+currentDefect);
}

function jumpToPreviousDefect() {
  while ((!document.getElementById("def"+(--currentDefect)) || 
    document.getElementById("def"+currentDefect).parentNode.style.visibility=="hidden") &&
    currentDefect>=0) {
  }
  window.location.assign("#def"+currentDefect);
}

function jumpToNextDefectFrom(id,noDefs) {
  while ((!document.getElementById("def"+(++id)) || 
    document.getElementById("def"+id).parentNode.style.visibility=="hidden") &&
    id<=noDefs) {
  }
  currentDefect=id;
  window.location.assign("#def"+id);
}

function jumpToPreviousDefectFrom(id) {
  while ((!document.getElementById("def"+(--id)) || 
    document.getElementById("def"+id).parentNode.style.visibility=="hidden") &&
    id>=0) {
  }
  currentDefect=id;
  window.location.assign("#def"+id);
}
          
function menuInJump(id) {
  if (lastMenuID!='' && document.getElementById("menuTemp")) {
    var oldElement = document.getElementById("menuTemp");
    oldElement.style.backgroundColor="white";
    oldElement.style.fontWeight="normal";
    oldElement.id=lastMenuID;
  }
  if (document.getElementById(id)) { 
  var element=document.getElementById(id);
            
  element.style.backgroundColor="yellow";
  element.style.fontWeight="bold";
  lastMenuID=element.id;
  element.id="menuTemp";
  window.location.assign("#menuTemp");
  } else {
    window.location.assign("#bookMark");
  }
}

function bookmarkSequence(id) {
  if (lastBookmarkID!='') {
    var oldElement = document.getElementById("bookMark");
    oldElement.style.backgroundColor="white";
    oldElement.style.fontWeight="normal";
    oldElement.id=lastBookmarkID;
  }
  var element=document.getElementById("menuTemp")?document.getElementById("menuTemp"):document.getElementById(id);
  element.style.backgroundColor="red";
  element.style.fontWeight="bold";
  lastBookmarkID=id;
  element.id="bookMark";
}

function changeVisibility(elementID) {
  element=document.getElementById(elementID);
  if (element.style.visibility=="hidden")
    element.style.visibility="visible";
  else
    element.style.visibility="hidden";
}

function showDefect(defectName) {
  var defects=getElementsByName_iefix("a",defectName);
  for (var i=0;i < defects.length;i++) {
    var tmpTR=document.getElementById(defects[i].id).parentNode.parentNode;
    document.getElementById(defects[i].id).parentNode.style.visibility="visible";
	if (tmpTR.className.charAt(0)=="_") 
	  tmpTR.className=tmpTR.className.substring(1);
  }
}

function hideDefect(defectName) {
  var defects=getElementsByName_iefix("a",defectName);
  for (var i=0;i < defects.length;i++) {
    var tmpTR=document.getElementById(defects[i].id).parentNode.parentNode;
    document.getElementById(defects[i].id).parentNode.style.visibility="hidden";
	if (tmpTR.className.charAt(0)!="_") 
	  tmpTR.className="_"+tmpTR.className;
  }
}

function processDefectFilter(formID) {
  var form=document.getElementById(formID);
  for (var i=0;i < form.length;i++) {
    var formElement=form.elements[i];
	if (formElement.type.toLowerCase()=='checkbox') {
	  if (formElement.checked==true) {
	    try {
	      showDefect(formElement.value);
		} catch (err) {
		}
	  }
	  else {
	    try {
	      hideDefect(formElement.value);
		} catch (err) {
		}
	  }
	}
  }
  changeVisibility('formDiv001');
}

function hidingDefectFromDefects(id) {
  var defectCheckbox = document.getElementById("checkbox"+id);
  defectCheckbox.checked=false;
  hideDefect(defectCheckbox.value);
}

function showingDefectFromDefects(id) {
  var defectCheckbox = document.getElementById("checkbox"+id);
  defectCheckbox.checked=true;
  showDefect(defectCheckbox.value);
}

function processReportFilter(formID) {
  var form=document.getElementById(formID);
  var cookieValue = new String();
  for (var i=0;i < form.length;i++) {
    var formElement=form.elements[i];
	if (formElement.type.toLowerCase()=='checkbox') {
	  cookieValue = cookieValue.concat(formElement.id);
	  cookieValue = cookieValue.concat('=');
	  cookieValue = cookieValue.concat(formElement.checked);
	  cookieValue = cookieValue.concat(',');
	  if (formElement.checked==true) {
	    try {
	      showBlocks(formElement.value);
		} catch (err) {
		}
	  }
	  else {
	    try {
	      hideBlocks(formElement.value);
		} catch (err) {
		}
	  }
	}
  }
  setCookie('filterForm',cookieValue,30);
  changeVisibility('reportDiv001');
}

function hideBlocks(blockName) {
  var blocks=getElementsByName_iefix("div",blockName);
  
  for (var i=0;i<blocks.length;i++) {
    var block=document.getElementById(blocks[i].id);
    block.style.visibility="hidden";
	block.style.height="0px";
	block.style.display="none";
  }
}

function showBlocks(blockName) {
  var blocks=getElementsByName_iefix("div",blockName);
  for (var i=0;i<blocks.length;i++) {
    var block=document.getElementById(blocks[i].id);
    block.style.visibility="visible";
	block.style.height="auto";
	block.style.display="block";
  }
}

function processDayFilter(formID) {
  var form=document.getElementById(formID);
  for (var i=0;i < form.length;i++) {
    var formElement=form.elements[i];
	if (formElement.type.toLowerCase()=='checkbox') {
	  if (formElement.checked==true) {
	    try {
	      showDays(formElement.value);
		} catch (err) {
		}
	  }
	  else {
	    try {
	      hideDays(formElement.value);
		} catch (err) {
		}
	  }
	}
  }
  changeVisibility('dayFilterDiv001');
}

function hideDays(dayName) {
  var block=document.getElementById(dayName);
  
  block.style.visibility="hidden";
  block.style.height="0px";
  block.style.display="none";
}

function showDays(dayName) {
  var block=document.getElementById(dayName);
  
  block.style.visibility="visible";
  block.style.height="auto";
  block.style.display="block";
}


function changeSubCheckboxes() {
  if (document.getElementById("checkboxSFV").checked==true) {
    document.getElementById("checkboxTI").checked=true;
	  document.getElementById("checkboxFVS").checked=true;
	  document.getElementById("checkboxOR").checked=true;
	  document.getElementById("checkboxEM").checked=true;
	  document.getElementById("checkboxERDC").checked=true;
	  document.getElementById("checkboxCOM").checked=true;
    document.getElementById("checkboxGLOME").checked=true;
    document.getElementById("checkboxTXNCOM").checked=true;
	  return;
	} 
	if (document.getElementById("checkboxSFV").checked==false) {
	  document.getElementById("checkboxTI").checked=false;
	  document.getElementById("checkboxFVS").checked=false;
	  document.getElementById("checkboxOR").checked=false;
	  document.getElementById("checkboxEM").checked=false;
	  document.getElementById("checkboxERDC").checked=false;
	  document.getElementById("checkboxCOM").checked=false;
    document.getElementById("checkboxGLOME").checked=false;
    document.getElementById("checkboxTXNCOM").checked=false;
	  return;
	}
}
function changeUpperCheckBox() {
  if (document.getElementById("checkboxTI").checked==false &&
      document.getElementById("checkboxFVS").checked==false &&
	    document.getElementById("checkboxOR").checked==false &&
	    document.getElementById("checkboxEM").checked==false &&
	    document.getElementById("checkboxERDC").checked==false &&
      document.getElementById("checkboxGLOME").checked==false &&
      document.getElementById("checkboxTXNCOM").checked==false &&
	    document.getElementById("checkboxCOM").checked==false) {
	  document.getElementById("checkboxSFV").checked=false;
    return; 
	}
	if (document.getElementById("checkboxTI").checked==true ||
	  document.getElementById("checkboxFVS").checked==true ||
	  document.getElementById("checkboxOR").checked==true ||
	  document.getElementById("checkboxEM").checked==true ||
	  document.getElementById("checkboxERDC").checked==true ||
	  document.getElementById("checkboxGLOME").checked==true ||
    document.getElementById("checkboxTXNCOM").checked==true ||
    document.getElementById("checkboxCOM").checked==true) {
	  document.getElementById("checkboxSFV").checked=true;
	  return; 
	}
}

function printReport()
{
    var tmpBody = document.getElementById('mainPage').innerHTML.replace(/Top/g," ");
	var a = window.open();
	a.document.open("text/html");
	a.document.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">");
a.document.write("<html xmlns=\"http://www.w3.org/1999/xhtml\"\>");
a.document.write("<head>");
a.document.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />");
a.document.write("<title>Untitled Document</title>");
a.document.write("<style type='text/css'>"+
".changed {"+
"	background: red;"+
"	font-size: 14px;"+
"	font-weight: bold;"+
"}"+
".added {"+
"	background: yellow;"+
"	font-size: 14px;"+
"	font-weight: bold;"+
"}"+
".removed {"+
"	background: red;"+
"	font-size: 14px;"+
"	font-weight: bold;"+
"}"+
"h1 {"+
"	font-size: 14px;"+
"}"+
"h2 {"+
"	font-size: 13px;"+
"}"+
"h3 {"+
"	font-size: 12px;"+
"}"+
"h4 {"+
"	font-size: 11px;"+
"}"+
"p {"+
"	font-size: 11px;"+
"}"+
"ul {"+
"	font-size: 11px;"+
"}"+
"body {"+
"	background-image: url(bpft.jpg);"+
"	background-repeat: no-repeat;"+
"	background-attachment: fixed;"+
"	font-size: 11px;"+
"}"+
"table {"+
"	border-style:double;"+
"	border-color: black;"+
"	table-layout:auto;"+
"	font-size: 11px;"+
"	margin-left:15px;"+
"	empty-cells: hide;"+
"}"+
"a:active {"+
"	background: yellow;"+
"	font-weight:bold;"+
"	color: black;"+
"}"+
".TableFont {"+
"	font-family: 'Times New Roman', Times, serif;"+
"	font-size: 12px;"+
"	font-weight: 500;"+
"}"+
".TableHeader {"+
"	font-size: 14px;"+
"	font-weight: 900;"+
"}"+
"</style>");
a.document.write("</head>");
a.document.write("<body>");
a.document.write(tmpBody);
a.document.write("</body>");
a.document.write("</html>");
a.document.close();
	
}

function getCookie(c_name) {
  if (document.cookie.length>0) {
    c_start=document.cookie.indexOf(c_name + "=");
    if (c_start!=-1) { 
      c_start=c_start + c_name.length+1; 
      c_end=document.cookie.indexOf(";",c_start);
      if (c_end==-1)
	    c_end=document.cookie.length;
    return unescape(document.cookie.substring(c_start,c_end));
    } 
  }
  return "";
}

function setCookie(c_name,value,expiredays) {
  var exdate=new Date();
  exdate.setDate(exdate.getDate()+expiredays);
  document.cookie=c_name+ "=" +escape(value)+
    ((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
}

function checkCookie() {
  cookie=getCookie('filterForm');
  var strArray = new Array();
  strArray=cookie.split(',');
  
  for (i=0;i < strArray.length-1;i++) {
    var tmpStr = new Array();
	tmpStr=strArray[i].split('=');
	var formElement = document.getElementById(tmpStr[0]);
	
	if (formElement.type.toLowerCase()=='checkbox') {
	  if (tmpStr[1]=="true") 
	    formElement.checked=true;
	  else
	    formElement.checked=false;
	}
  }
  
  var form=document.getElementById('reportForm001');
  for (var i=0;i < form.length;i++) {
    var formElement=form.elements[i];
	if (formElement.type.toLowerCase()=='checkbox') {
	  if (formElement.checked==true) {
	    try {
	      showBlocks(formElement.value);
		} catch (err) {
		}
	  }
	  else {
	    try {
	      hideBlocks(formElement.value);
		} catch (err) {
		}
	  }
	}
  }
}