/*	Filename 		: 	userRegister.js
 	Functionality	:	Adds client side validation of fields
 						Provides dynamic dropdowns and error checking for fields
 						Post form data using Ajax for server side validation  
	Creation Date	:	‎June ‎22, ‎2017, ‏‎2:42:59 PM
*/
window.onload = addHandlers();
$("#form").submit(function(event) {
	var counter = 0;var lenObj = 0; 
	var password,cPassword;
	var form = $("#form");
    
	event.preventDefault();
	
	if (!checkEmptyAndSpaces.call($("#password")[0]) && !checkEmptyAndSpaces.call($("#cpassword")[0])) 
	{
	     password = $("#password").val();
		 cPassword = $("#cpassword").val();

		$("#password").val(CryptoJS.SHA512($("#password").val()));
		$("#cpassword").val(CryptoJS.SHA512($("#cpassword").val()));
	}
	$.getJSON('../components/formValidationService.cfc?method=validateAllFields&' + form.serialize() , function(result)
	{
		console.log(result);
		lenObj = Object.keys(result).length;
		for (var key in result) 
		{
			var temp = key.split("=");
			var field = getErrorMessages(temp[0]);
			if(result[key] !== field.previousElementSibling.innerHTML && result[key] !== "")
				generateErrors(result[key], field);
			if(result[key] === "")
				counter++;
				
		}
		$("#password").val(password);
		$("#cpassword").val(cPassword);
		
		console.log(counter,lenObj);
		if (counter === lenObj && validate()) 
		{	
			$("#form").unbind('submit').submit();
			$("#form").attr("action","registerAction.cfm");
			return true;
		}
		else
		{
			document.getElementById("val").innerHTML = "There were errors in your submission";
			document.getElementById("val").setAttribute("class","valmssg");
			document.body.scrollTop = "0";
	
		}
	});	
	
	return false;	
});
	
function addHandlers()
{
	createCaptcha();
	var firstName = document.getElementsByName("firstname")[0];
	firstName.addEventListener("blur",checkWord);	
	firstName.addEventListener("focus",clearErrors);

	var lastName = document.getElementsByName('lastname')[0];
	lastName.addEventListener("blur",checkWord);
	lastName.addEventListener("focus",clearErrors);

	var pass = document.getElementsByName("user_password")[0];
	var cpass = document.getElementsByName("user_confirm_password")[0];
	pass.addEventListener("focus" , clearErrors);
	pass.addEventListener("blur" , checkEmptyAndSpaces);
	
	cpass.addEventListener("focus" , clearErrors);
	cpass.addEventListener("blur" , checkPass);
	
	var pno = document.getElementsByName("phoneno")[0];
	pno.addEventListener("blur",checkNumber);
	pno.addEventListener("focus",clearErrors);
	
	var pnoalt = document.getElementsByName("phonenoAlt")[0];
	pnoalt.addEventListener("blur",checkNumber);
	pnoalt.addEventListener("focus",clearErrors);
	
	var city = document.getElementsByName("city")[0];
	city.addEventListener("blur",checkWord);
	city.addEventListener("focus",clearErrors);

	var email = document.getElementById("mail");
	email.addEventListener("blur",checkEmail);
	email.addEventListener("focus",clearErrors);

	var caddr = document.getElementsByName("caddress")[0];
	caddr.addEventListener("blur",checkEmptyAndSpaces);
	caddr.addEventListener("focus",clearErrors);

	var paddr = document.getElementsByName("paddress")[0];
	paddr.addEventListener("blur",checkEmptyAndSpaces);
	paddr.addEventListener("focus",clearErrors);

	var country = document.getElementsByName("country")[0];
	country.addEventListener("blur",checkEmptyAndSpaces);
	country.addEventListener("focus",clearErrors);

	var state = document.getElementsByName("state")[0];
	state.addEventListener("blur",checkEmptyAndSpaces);
	state.addEventListener("focus",clearErrors);
	
	return;
}
function checkWord()
{
	if(checkEmptyAndSpaces.call(this))
		return;
	var counter=0;
	var len = this.value.length;
	for(var iterator=0 ; iterator<len; iterator++)
	{
		var unicode = this.value.charCodeAt(iterator);
		if((unicode >= 65 && unicode <=90) || (unicode >= 97 && unicode <= 122))
				counter++;
	}
	
	if(counter !== len)
		generateErrors("Name field dosen't contain letters",this);
	var value = this;
			
	return;
}
function checkPass()
{
	
	var pass = document.getElementsByName("user_password");
	var cpass = document.getElementsByName("user_confirm_password");
	checkEmptyAndSpaces.call(this);
	if(pass[0].value !== cpass[0].value)
		generateErrors("Passwords do not match",pass[0]);		
	var value = this;

	return;
	
}
function checkNumber()
{
	
	var counter = 0;
	var len = this.value.length;
	var pno = document.getElementsByName("phoneno");
	var pnoalt = document.getElementsByName("phonenoAlt");
	
	if(checkEmptyAndSpaces.call(this))
		return;
	if(len < 10 && len > 0)
		generateErrors("Field cannot be less than 10 digits" , this);
	else if(pno[0].value === pnoalt[0].value && len > 0)
		generateErrors("Number should be different form primary number",pnoalt[0]);
	else
	{
		for(var iterator = 0; iterator<len ; iterator++)
		{
			
			var unicode = this.value.charCodeAt(iterator);
			if(unicode >=48 && unicode <= 57)
				counter++;
		}
		if(counter !== len)
			generateErrors("Phone Number does not contain numbers",this);
		
	}
	var value = this;
	
	return;
}
function checkEmail()
{
	
	if(checkEmptyAndSpaces.call(this))
		return;
	var counter_d=0,counter_p=0;
	var val = this.value;
	var atloc = val.indexOf("@");
	var charAllowed = ["!","#","$","%","&","'","*","+","-","/","=","?","^","_","`","{","}","|","~"];
	if(atloc === 0 || atloc === val.length-1 || atloc !== val.lastIndexOf("@") || atloc === -1)
	{
		generateErrors("Invalid Email Address",this);
		return;
	}
	var personalInfo = val.split("@")[0];
	var domainInfo = val.split("@")[1];
	var checkPinfo = function(){
		for(var iterator = 0 ; iterator<personalInfo.length ; iterator++)
		{
			var unicode = personalInfo.charCodeAt(iterator);
		
			if((unicode >= 65 && unicode <=90) || (unicode >= 97 && unicode <= 122) || (charAllowed.indexOf(personalInfo[iterator]) !== -1) || (unicode>=48 && unicode<=57))
			
				counter_p++;
			
			if(unicode === 46)
			{
				
				if(iterator !== 0 && iterator !== personalInfo.length-1 && personalInfo[iterator+1] !== ".")
					counter_p++;	
			}
		}
		if(counter_p !== personalInfo.length)
			return false;
		else
			return true;
	};
	
	
	var checkDinfo = function(){
		for(var iterator = 0 ; iterator<domainInfo.length ; iterator++)
		{
			var unicode = domainInfo.charCodeAt(iterator);
			if((unicode >= 65 && unicode <=90) || (unicode >= 97 && unicode <= 122) || (unicode === 45) || (unicode>=48 && unicode<=57))
				counter_d++;
			
			if(unicode === 46)
			{
				if(iterator !== 0 && iterator !== domainInfo.length-1 && (domainInfo[iterator+1] !== ".") &&iterator !== domainInfo.length-2 && (domainInfo[iterator+2] !== "."))
					counter_d++;
			}
			
		
		}
		if(counter_d !== domainInfo.length)
			return false;
		else
			return true;
	};
	
	if(checkDinfo() === false || checkPinfo() === false)
		generateErrors("Invalid Email Address",this);
	
	
	var value = this;
	
	return;
}
function generateErrors(errormssg,name)
{
	var em = document.createElement("p");
	if(name.classList.contains("required") && errormssg.length === 0)
		em.appendChild(document.createTextNode("This field cannot be empty"));
	else	
		em.appendChild(document.createTextNode(errormssg));
	
	name.insertAdjacentElement('beforebegin',em);
	em.setAttribute("class" , "errors");
		
	return;
}

function clearErrors()
{
	var fs = document.getElementsByTagName('fieldset');
	for(var i =0 ; i<fs.length;i++)
	{
		for(var j =0;j<fs[i].childElementCount;j++)
		{
			if(fs[i].children[j] === this)
			{			
                if(fs[i].children[j].previousElementSibling.classList.contains("errors"))
					fs[i].children[j].previousElementSibling.remove();
			}
		}
	}
	return;
}
function createCaptcha()
{
	var cap = document.getElementById("captcha");
	var opvalue = function(){
		var op = parseInt(Math.random() * (4) + 1);
		if(op === 1)
			return "+";
		else if(op === 2)
			return "-";
		else if(op === 3)
			return "*";
		else
			return "/";
	};
	cap.innerHTML = parseInt(Math.random()*10 + 1) + opvalue() + parseInt(Math.random()*10 + 1);
	document.getElementsByName('capval')[0].value = "";
	
}
function checkCaptcha()
{
	var capmssg = document.getElementById("capmssg");
	capmssg.style.visibility = "initial";
	capmssg.style.display = "block";

	if((document.getElementsByName("capval")[0].value) === parseInt(eval(document.getElementById("captcha").innerHTML)).toString())
	{
		document.getElementById('submitbttn').removeAttribute('disabled');
		capmssg.innerHTML = " &#10004 Captcha Input was Ok.You can Sign Up Now";
		capmssg.style.color = "Green";
	}
	else
	{
		document.getElementById("submitbttn").setAttribute("disabled","true");
		capmssg.innerHTML = " &#10006 Captcha input was incorrect.Please try again.";
		capmssg.style.color = "Red";
		createCaptcha();	
	}
	setTimeout(function(){
		capmssg.style.visibility = "hidden";
		capmssg.style.display = "none";
	},5000);	

}
function validate()
{
	
	var counter = 0;
	var lbl = document.getElementsByTagName('label');
	var inputs = document.getElementsByTagName("input");
	for(var iterator = 0;iterator<inputs.length;iterator++)
	{
		clearErrors.call(inputs[iterator]);
		checkEmptyAndSpaces.call(inputs[iterator]);
	}
	for(var iterator = 0;iterator<lbl.length;iterator++)
	{
		if(lbl[iterator].classList.contains("required"))
		{
			if(lbl[iterator].nextElementSibling.classList.contains("errors"))
				counter++;
		}
	}
	
	if(counter === 0 )
	{
		
		alert("Data was submitted" );
		return true;
		
	}
	else
	{
		document.getElementById("val").innerHTML = "There were errors in your submission";
		document.getElementById("val").setAttribute("class","valmssg");
		document.body.scrollTop = "0";
	
		return false;
	}
	
}

function checkEmptyAndSpaces()
{
	
	var val = this.value;
	var len = this.value.length;
	var temp = "";
	for(iterator = 0 ; iterator < len ; iterator++)
	{
		if(val.charAt(iterator) !== " ")
			temp +=  val.charAt(iterator).toString();
	}
	this.value = temp;
	if(temp.length === 0)
	{	
		generateErrors("",this);
		return true;
	}
	else
		return false;
	
}
    
function getErrorMessages(name)
{
	
	var error = $("input");
	var len = error.length;
	for (iterator = 0; iterator < len; iterator++) 
	{
		if (error[iterator].getAttribute("name") === name) {
			return error[iterator];
			console.log(error[iterator].innerHTML());
		}
	}
}

