<cfcomponent output="false">
	<cfset this.name = "ProjectColdFusion"/>
	<cfset this.applicationTimeout = createTimespan(0,2,0,0)/>
	<cfset this.datasource = "Project_DataSource"/>
	<cfset this.sessionManagement = "yes"/>
	<cfset this.sessionTimeout = createTimespan(0,0,10,0)/>
	
	<cffunction name="validateLogin" returntype="boolean" output="true" access="public" >
		<cfargument name="email" required="true" type="string" >
		<cfargument name="password" required="true" type="string" >	
		<cfquery datasource="Project_DataSource" name="nmLogin" result="rsLogin">
			SELECT uid 
			FROM dbo.Users_Details
			WHERE EmailAddress = '#email#' AND Password = '#password#'
		</cfquery>>	
		
		<cfif rsLogin.recordCount EQ 1>
			<cfquery datasource="Project_DataSource">
				UPDATE dbo.Users_Details 
				SET isActive = 1 
				WHERE uid = #nmLogin.uid#
			</cfquery>
			<cfset session.id = #nmLogin.uid#>
			<cfreturn true>
		<cfelse>
			<cfreturn false>	
		</cfif>
	</cffunction>
</cfcomponent>