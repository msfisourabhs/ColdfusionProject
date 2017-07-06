<!----
	Filename 		: 	home.cfm
 	Functionality	:	HomePage and logout functionality for logged in user
 						Custom Welcom message to logged in user
	Creation Date	:	June ‎22, ‎2017, ‏‎2:42:59 PM

--->
<cfif #StructKeyExists(SESSION,"id")#>
	<cfquery datasource = "Project_DataSource" name = "fetchIsUserActive">
		SELECT isActive
		FROM dbo.Users_Details
		WHERE uid = #SESSION.id#
	</cfquery>
	<cfif fetchIsUserActive.isActive EQ 1>
		<!DOCTYPE html>
		<html>
			<head>
				<title>Welcome Page</title>
				<meta charset="utf-8">
        		<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<link rel = "stylesheet" href = "../stylesheet/home.css">
			</head>
			<body >
				<ul>
				  <li><a class = "active" href = "home.cfm">Home</a></li>
				  <li><a href = "#Profile">Profile</a></li>
				  <li><a href = "#contact">Contact</a></li>
				  <li style = "float:right"><a href = "logout.cfm">Logout</a></li>
				</ul>
				
					
				<!---Welcome Message--->
					<cfquery datasource = "Project_DataSource" name = "fetchUserFullName">
						SELECT FirstName,LastName
						FROM dbo.Users_Details
						WHERE uid = '#SESSION.id#'
					</cfquery>
					<cfoutput query = "fetchUserFullName">
						<h1>Welcome #fetchUserFullName.FirstName# #fetchUserFullName.LastName#</h1>
					</cfoutput>
					
			</body>
		
			</html>
	</cfif>
<cfelse>
		<cfset VARIABLES.errorMessage = "You are not authorised to view this page.<br>"&
							  "If you are a new user <a href = ../Common/register.cfm>Click here to register</a><br>"&
							  "Exsisting Users <a href=login.cfm>Click here to Login</a>">
		<cfinclude template = "../errors/errorPage.cfm">
		
</cfif>



