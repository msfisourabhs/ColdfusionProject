
<cfquery datasource="Project_DataSource">
	UPDATE dbo.Users_Details 
	SET isActive = 0 
	WHERE uid = #Session.id#	
</cfquery>
<cflogout >

<cflocation url="login.cfm" addtoken="false">