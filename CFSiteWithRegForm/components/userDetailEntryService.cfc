<!----
	Filename 		: 	userDetailEntryService.cfc
 	Functionality	:	Inserts user supplied FORM data into database
	Creation Date	:	‎June ‎22, ‎2017, ‏‎2:42:59 PM

--->
<cfcomponent datasource = "Project_DataSource" hint = "Input user data to database " >
	<cfparam name = "FORM.user_interest" default = "NULL">
	<cfparam name = "FORM.subs_value" default = "NULL">
	<cfparam name = "FORM.paddress" default = "NULL">
	<cfset VARIABLES.errorFlag = false>
	<cfset VARIABLES.salt = Hash(GenerateSecretKey("AES"), "SHA-512") /> 
	<cfset VARIABLES.hashedPassword = Hash(FORM.user_password & VARIABLES.salt, "SHA-512") />
	<!---Insert Data into various tables--->
	<cffunction name = "insertFORMDataIntoDB" returntype = "boolean" output = "false" access = "public" hint = "inserts data to various tables">
		<cfargument name = "FORM" type = "struct" required = "true">
		
		<cftry>
			<cfquery>		
			<!---Insert Data in User_Details--->
			
			INSERT INTO dbo.Users_Details
				(FirstName,LastName,EmailAddress,Password,Salt,isActive)
			values
				(<cfqueryparam cfsqltype = "cf_sql_varchar" maxlength = "20" null = "false" value = "#FORM.firstname#">,
				 <cfqueryparam cfsqltype = "cf_sql_varchar" maxlength = "20" null = "false" value = "#FORM.lastname#">,
				 <cfqueryparam cfsqltype = "cf_sql_varchar" maxlength = "60" null = "false" value = "#FORM.user_email#">,
				 '#VARIABLES.hashedPassword#',
				 '#VARIABLES.salt#',
				 0)
				  
			</cfquery>		
			<!---Set the uid for current user--->
			<cfquery name = "nmUserID">
				select uid 
				from dbo.Users_Details 
				where EmailAddress = <cfqueryparam cfsqltype = "cf_sql_varchar" null = "false" maxlength = "60" value = "#FORM.user_email#">
			</cfquery>
			<cfquery>
			
				<!---Insert Data into User_Address--->
				INSERT INTO dbo.User_Address
					(uid,CurrentAddress,PermanentAddress,Country,State,City)
					values
					(#nmUserID.uid#	,
					<cfqueryparam cfsqltype = "cf_sql_varchar" null = "false" maxlength = "60" value = "#FORM.caddress#">,
					<cfqueryparam cfsqltype = "cf_sql_varchar" null = "true" maxlength = "60" value = "#FORM.paddress#">,
					<cfqueryparam cfsqltype = "cf_sql_varchar" null = "false" maxlength = "20" value = "#FORM.country#">,
					<cfqueryparam cfsqltype = "cf_sql_varchar" null = "false" maxlength = "20" value = "#FORM.state#">,
					<cfqueryparam cfsqltype = "cf_sql_varchar" null = "false" maxlength = "30" value = "#FORM.city#">)
			</cfquery>
			
			<cfquery>
				<!---Insert Data into User_Additional_Info--->
				INSERT INTO dbo.Users_Additional_Info
					(uid,Gender,subscription)
					values
					(#nmUserID.uid#,
					<cfqueryparam cfsqltype = "cf_sql_char" maxlength = "1" null = "false" value = "#FORM.gender#">,
					<cfqueryparam cfsqltype = "cf_sql_char" maxlength = "10" null = "true" value = "#FORM.subs_value#">)
			</cfquery>
			
			<cfquery>
				<!---Insert Data into User_Phone_Number--->
				INSERT INTO dbo.Users_Phone_Number
					(uid,PhoneNumber)
					values
					(#nmUserID.uid#,
					<cfqueryparam cfsqltype = "cf_sql_varchar" maxlength = "10" null = "false" value = "#FORM.phoneno#">)
				<cfif #FORM.phonenoalt# NEQ "">
					INSERT INTO dbo.Users_Phone_Number
						(uid,PhoneNumber)
					values
						(#nmUserID.uid#,
						<cfqueryparam cfsqltype = "cf_sql_varchar" maxlength = "10" value = "#FORM.phonenoAlt#">)
				</cfif>
			</cfquery>
			
			<cfloop list = "#FORM.user_interest#" index = "interestValue" delimiters = ",">
				<cfquery datasource = "Project_DataSource" result = "rsUserInterest">
					<!---Insert Data into User_Interest--->
					INSERT INTO dbo.Users_Interest
						(uid,InterestID)
						values
						(#nmUserID.uid#,
						(select InterestID 
						from dbo.Interest_Info 
						where InterestName = <cfqueryparam cfsqltype = "cf_sql_varchar" null = "true" value = "#trim('#interestValue#')#">))
				</cfquery>
			</cfloop>
	
		<cfcatch name = "databaseError" type = "database" >
			<cfset errorMessage = "#databaseError#">
			<cfinclude template = "../errors/errorPage.cfm">
		</cfcatch>
		
		</cftry>
		
		<cfreturn VARIABLES.errorFlag>
	</cffunction>
	
	
</cfcomponent>