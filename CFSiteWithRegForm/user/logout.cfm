<!----
	Filename 		: 	home.cfm
 	Functionality	:	Logs out users
 						Invalidate sessions and Session.id variable
	Creation Date	:	‎June ‎22, ‎2017, ‏‎2:42:59 PM

--->
<cftry>
	<cfquery datasource = "Project_DataSource">
		UPDATE dbo.Users_Details 
		SET isActive = 0 
		WHERE uid = #SESSION.id#	
	</cfquery>
	<cfset #Sessioninvalidate()#>
	<cflocation url = "login.cfm" addtoken = "false">
<cfcatch name = "invalidRequest" type = "any">
	<cfset VARIABLES.errorMessage = "You need to <a href = login.cfm> login </a> before you can logout">
	<cfinclude template="../errors/errorPage.cfm" >
</cfcatch>>
</cftry>