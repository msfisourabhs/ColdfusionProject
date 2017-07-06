<!----
	Filename 		: 	Applicatio.cfc
 	Functionality	:	Intialises application specific data
 						Validates users supplied email address and passowrd to log users in
						Creates session.id variable
	Creation Date	:	June ‎22, ‎2017, ‏‎2:42:59 PM


--->
<cfcomponent hint = "Intailise and validate login credentials">
	<cfset THIS.name = "ProjectColdFusion"/>
	<cfset THIS.sessionManagement = "yes"/>
	<cfset THIS.sessionTimeout = createTimespan(0,0,10,0)/>
	<cfset THIS.datasource = "Project_DataSource">
	<cfset VARIABLES.errorHeader = "">
	<cffunction name = "onRequestEnd" hint = "validate login">
		
		<!---User submits his username and password for validation--->
		<cfif  StructKeyExists(FORM,"user_email") AND StructKeyExists(FORM,"user_password")>
			<!---Fetch the salt for emailID--->
			<cfquery name = "nmFetchSalt" result = "resFetchSalt">
				SELECT Salt
				FROM dbo.Users_Details
				WHERE EmailAddress = <cfqueryparam cfsqltype = "cf_sql_varchar" null = "false" maxlength = "60" value = "#FORM.user_email#"> 
				
			</cfquery>
			<cfif resFetchSalt.recordCount NEQ 0>	
				<cfset LOCAL.hashedPassword = Hash(FORM.user_password & nmFetchSalt.Salt, "SHA-512")>
				<cfquery name = "nmLoginActivity" result = "rsLoginActivity">
					SELECT uid , isActive
					FROM dbo.Users_Details
					WHERE EmailAddress = <cfqueryparam cfsqltype = "cf_sql_varchar" null = "false" maxlength = "60" value = "#FORM.user_email#"> 
						AND 
					Password = '#LOCAL.hashedPassword#'
				</cfquery>	
				<cfif rsLoginActivity.recordCount EQ 1>
					<cfif #nmLoginActivity.isActive# EQ 0>
						<cfquery>
							UPDATE dbo.Users_Details 
							SET isActive = 1 
							WHERE uid = #nmLoginActivity.uid#
						</cfquery>
						<cfset SESSION.id = #nmLoginActivity.uid#>
						<cflocation url = "home.cfm" addtoken = "false" >
					<cfelse>
						<cfset VARIABLES.errorHeader = "Suspicious login detected">			
					</cfif>
				<cfelse>
					<cfset VARIABLES.errorHeader = "Invalid Username/Password">		
				</cfif>
			<cfelse>	
				<cfset VARIABLES.errorHeader = "Invalid Username/Password">		
			</cfif>
			<cflog file = "#THIS.Name#LoginError" type = "error" text = "Email Address: #FORM.user_email#"> 
			<cflog file = "#THIS.Name#LoginError" type = "error" text = "Message: #errorHeader#"> 
			<cflog file = "#THIS.Name#LoginError" type = "error" text = "Login Attempt Time: #now()#"> 
		
		</cfif>
		<cfoutput>
			<script type = "text/javascript">
				document.getElementById("errorHeader").innerHTML = "#errorHeader#";
			</script>
		</cfoutput>
					
	</cffunction>
	
	<cffunction name = "onSessionEnd" output = "false" access = "private" hint = "Destroy the isActive atttribute">
		
		<cfquery datasource = "Project_DataSource">
			UPDATE dbo.Users_Details 
				SET isActive = 0 
			WHERE uid = #SESSION.id#
		</cfquery>
		
	</cffunction>
</cfcomponent>