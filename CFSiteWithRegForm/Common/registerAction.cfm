<!---
	Filename 		: 	registerAction.cfm
 	Functionality	:	Verifies Validation Token
 						Adds user details into database upon successful validation  
 						
	Creation Date	:	Thursday, ‎June ‎22, ‎2017, ‏‎2:42:59 PM

--->
<cfset VARIABLES.errorMessage = "">

<cffunction name = "verifyValidationToken" access = "private" returntype = "boolean" hint = "verifies validation token">
	<cfset LOCAL.formDataToHash = "">
	<cfset LOCAL.arrayFieldValues = StructKeyArray(form)>
	<cfset #ArraySort(LOCAL.arrayFieldValues,"text")#>
	<cfloop array = "#arrayFieldValues#" index = "fieldValue">
		<cfif fieldValue NEQ "fieldnames" AND fieldValue NEQ "capval">			
			<cfif fieldValue EQ "user_password" OR fieldValue EQ "user_confirm_password">
				<cfset LOCAL.formDataToHash = LOCAL.formDataToHash & LCase(Hash(form[fieldValue],"SHA-512" ))>
			<cfelse>
				<cfset LOCAL.formDataToHash = LOCAL.formDataToHash & form[fieldValue]>
			</cfif>	
		</cfif>
	</cfloop>
	<cfif Hash(LOCAL.formDataToHash,"SHA-512") EQ SESSION.validationToken>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cfif StructKeyExists(SESSION,"validationToken") && verifyValidationToken()>	
	
	<cfquery datasource = "Project_DataSource" result = "rsUserExsists">
		SELECT uid
		FROM dbo.Users_Details
		WHERE EmailAddress = '#form.user_email#'
	</cfquery>
	
		
	<cfif rsUserExsists.RecordCount EQ 0>
		<!---Input values in the databsse---> 
		<cfset userDetails = CreateObject("component",'Projects.CFSiteWithRegForm.components.userDetailEntryService')>
		<cfif NOT userDetails.insertFormDataIntoDB(form)>	
			<cflocation url = "registerSuccess.cfm" addtoken = "false" >
		<cfelse>
			<cfset VARIABLES.errorMessage = "A Database error has occured">
		</cfif>
	<cfelse>
		<cfset VARIABLES.errorMessage = "User already exsists <a href=register.cfm> Click here to Register</a>">
				
	</cfif>
<cfelse>
	<cfset VARIABLES.errorMessage = "You need to register before you can submit any data">	
</cfif>

<cfif VARIABLES.errorMessage NEQ "">
	<cfinclude template = "../errors/errorPage.cfm">
</cfif>
