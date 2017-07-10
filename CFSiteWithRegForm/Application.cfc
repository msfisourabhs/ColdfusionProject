<!----	
	Filename 		:	Application.cfc 
 	Functionality	:	Intialises the application data like cookies,datasources etc
 						Generates errors custom pages for all server wide errors
	Creation Date	:	‎June ‎22, ‎2017, ‏‎2:42:59 PM
---->

<cfcomponent output="true">
	
	<cfset this.name = "ProjectColdFusion"/>
	<cfset this.applicationTimeout = createTimespan(0,2,0,0)/>
	<cfset this.datasource = "Project_DataSource"/>
	<cfset this.sessionManagement = "yes"/>
	<cfset this.sessionTimeout = createTimespan(0,0,10,0)/>
	<cfset this.sessioncookie.disableupdate = true>
	<cfset this.sessioncookie.httponly = true>
	<cfset this.sessioncookie.secure = true>
	<cfset this.setclientcookie = true>
	<cfset this.sessioncookie.timeout = createTimespan(0,0,10,0)>
	
	<cffunction name = "onError" returntype = "void" access="public" >
		<cfargument name = "exception" required = "true" type = "any" >
		<cfargument name = "eventname" required = "true" type = "any" >	
		<cfset errorMessage = "500<br> Internal Server Error occured.We are notifying our developers">
		<cfinclude template = "errors/errorPage.cfm">
		<!--- Log all errors. --->
		<cflog file = "#This.Name#InternalServerError" type = "error" text = "Event Name: #Arguments.Eventname#"> 
		<cflog file = "#This.Name#InternalServerError" type = "error" text = "Message: #Arguments.Exception.message#"> 
		<cflog file = "#This.Name#InternalServerError" type = "error" text = "Stack Trace: #Arguments.Exception.StackTrace#"> 
	</cffunction> 
	<cffunction name = "onMissingTemplate" returntype="void" access="public" >
		<cfargument name = "targetPage" type = "string" required = true/>
		<cfset errorMessage = "404<br>Oops! The page "& #targetPage# &" you were looking for was not found"> 
		<cfinclude template = "errors/errorPage.cfm">
		<!--- Log all errors. --->
		<cflog file = "#This.Name#TyposError" type = "error" text = "Event Name: Page Not Found"> 
		<cflog file = "#This.Name#TyposError" type = "error" text = "Message: #errorMessage#"> 

	</cffunction>
	
</cfcomponent>