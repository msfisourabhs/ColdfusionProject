﻿<cfdump var="#Session#">
<cfquery datasource="Project_DataSource" name="nmUserIsActive">
	SELECT isActive
	FROM dbo.Users_Details
	WHERE uid = #Session.id#
</cfquery>
<cfif nmUserIsActive.isActive EQ 1>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="../stylesheet/home.css">
</head>
<body>

<ul>
  <li><a class="active" href="home.cfm?uid=<cfoutput>#Session.id#</cfoutput>">Home</a></li>
  <li><a href="#Profile">Profile</a></li>
  <li><a href="#contact">Contact</a></li>
  <li style="float:right"><a href="logout.cfm?uid=<cfoutput>#Session.id#</cfoutput>">Logout</a></li>
</ul>

	
<!---Welcome Message--->
	<cfquery datasource="Project_DataSource" name="nmName">
		SELECT FirstName,LastName
		FROM dbo.Users_Details
		WHERE uid = '#Session.id#'
	</cfquery>
	<cfoutput query="nmName">
		<h1>Welcome #nmName.FirstName# #nmName.LastName#</h1>
	</cfoutput>
</body>
</html>
<cfelse>
	<cfoutput><p class="errors" style="color:red;text-align:center;font-family:helvetica;font-size:20px">You are not authorised to view this page.<br>If you are a new user 
	<a href="index.cfm">Click here to register</a><br>Exsisting Users
	<a href="login.cfm">Click here to Login</a>
	</p>
	</cfoutput>
</cfif>