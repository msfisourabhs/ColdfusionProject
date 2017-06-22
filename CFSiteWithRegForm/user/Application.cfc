﻿<cfcomponent output="true">
	
	<cfset this.sessionManagement = "yes"/>
	<cfset this.sessionTimeout = createTimespan(0,0,10,0)/>
	
	
	<cffunction name="onRequestEnd" >
		
		<cfif StructKeyExists(form,"user_email") AND StructKeyExists(form,"user_password")>
			<cfquery datasource="Project_DataSource" name="nmLogin" result="rsLogin">
				SELECT uid 
				FROM dbo.Users_Details
				WHERE EmailAddress = '#form.user_email#' AND Password = '#form.user_password#'
			</cfquery>>	
			
			<cfif rsLogin.recordCount EQ 1>
				<cfquery datasource="Project_DataSource">
					UPDATE dbo.Users_Details 
					SET isActive = 1 
					WHERE uid = #nmLogin.uid#
				</cfquery>
				<cfset session.id = #nmLogin.uid#>
				<cflocation url="home.cfm" addtoken="false" >
			<cfelse>
				<cfoutput>
				<script type="text/javascript">
					document.getElementById("errorHeader").innerHTML = "Invalid Username/Password";
				</script>
				</cfoutput>	
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>