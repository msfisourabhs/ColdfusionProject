<!----
	Filename 		: 	formValidationService.cfc
 	Functionality	:	Server side validation of form data
 						Creation of a validationToken per specific form submit
	Creation Date	:	July ‎2 ,  ‎2017 ,  ‏‎11:52:25 AM

--->

<cfcomponent extends = "fieldValidationService" hint = "validates form data recived via AJAX" output = "false" >
	
	<cffunction name = "validateAllFields" access = "remote" returntype = "struct" returnformat = "JSON" hint = "function validates form fields">
		<cfset LOCAL.strModAndError = {}>	
			<cfset StructAppend(LOCAL.strModAndError , validateName(URL.firstname , "firstname"))>
			<cfset StructAppend(LOCAL.strModAndError , validateName(URL.lastname , "lastname"))>
			
			<cfset StructAppend(LOCAL.strModAndError , validateMail(URL.user_email , "user_email"))>
			<cfset StructAppend(LOCAL.strModAndError , validatePass(URL.user_confirm_password , URL.user_password , "user_confirm_password"))>
			<cfset StructAppend(LOCAL.strModAndError , validateNumber(URL.phoneno , "phoneno"))>
			<cfset StructAppend(LOCAL.strModAndError , validateName(URL.city , "city"))>
			<cfif NOT checkEmptyAndSpaces(URL.country , "country")>
				<cfset StructInsert(LOCAL.strModAndError , "country="&URL.country , "")>
			<cfelse>
				<cfset StructInsert(LOCAL.strModAndError , "country=" , "This field cannot be empty")>
			</cfif>
			
			<cfif NOT checkEmptyAndSpaces(URL.caddress , "caddress")>
				<cfset StructInsert(LOCAL.strModAndError , "caddress="&URL.caddress , "")>
			<cfelse>
				<cfset StructInsert(LOCAL.strModAndError , "caddress=" , "This field cannot be empty")>
			</cfif>
			<cfif NOT checkEmptyAndSpaces(URL.state , "state")>
				<cfset StructInsert(LOCAL.strModAndError , "state="&URL.state , "")>
			<cfelse>
				<cfset StructInsert(LOCAL.strModAndError , "state=" , "This field cannot be empty")>
			</cfif>
			<cfloop collection="#LOCAL.strModAndError#" item="key">
				<cfset LOCAL.counter = 0>
				<cfset LOCAL.structLength = 0>
				<cfset LOCAL.temp = key.Split("=")>
				<cfset LOCAL.field = temp[1]>
				<cfif arrayLen(LOCAL.temp) EQ 2>
					<cfset LOCAL.fieldValue = LOCAL.temp[2]>
				<cfelse>
					<cfset LOCAL.fieldValue = "">
				</cfif>
				<cfset StructUpdate(url , LOCAL.field , LOCAL.fieldValue)>
				<cfif LOCAL.strModAndError[key] EQ "">
					<cfset LOCAL.counter = LOCAL.counter + 1>
				</cfif>	
				<cfset LOCAL.StructLength = LOCAL.StructLength + 1>
			</cfloop>
			<cfif LOCAL.StructLength EQ LOCAL.counter>
				<cfset generateValidationToken()>			
			</cfif>
			
	<cfreturn strModAndError>		
	</cffunction>
	<cffunction name = "generateValidationToken" access = "private" returntype = "String" hint = "generates validation token">
		<cfset LOCAL.formDataToHash = "">
		<cfset LOCAL.arrayFieldValues = StructKeyArray(url)>
		<cfset #ArraySort(LOCAL.arrayFieldValues , "text")#>
		<cfloop array = "#LOCAL.arrayFieldValues#" index = "fieldValue">
			<cfif fieldValue NEQ "method" AND fieldValue NEQ "captchainput">
				<cfset LOCAL.formDataToHash = LOCAL.formDataToHash & url[fieldValue]>	
			</cfif>
			</cfloop>
		<cfset SESSION.validationToken = Hash(LOCAL.formDataToHash , "SHA-512" )>
		
	</cffunction>
	
</cfcomponent>