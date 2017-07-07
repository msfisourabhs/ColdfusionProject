<!----
	Filename 		: 	fieldValidationService.cfc
 	Functionality	:	Validates different form fields
 						Sanitises user inputs in the form 
	Creation Date	:	June ‎22 ,  ‎2017 ,  ‏‎2:42:59 PM

--->
<cfcomponent hint = "validation for fields" >
	<!---Intialise the Structure(ModifiedValue , ErrorMessage)--->
	<cfset VARIABLES.sChangeAndError = {} />
	
	<!---Generates Erros and populates the structure errorMessages--->
	<cffunction name = "generateErrors" access = "private" output = "true" returntype = "void" hint = "generates errors">
		<cfargument type = "string" name = "field" required = "true" hint = "field value">
		<cfargument type = "string" name = "errorMessage" required = "false" default = "This field cannot be empty" hint = "error message to append">
		<cfset #StructUpdate(VARIABLES.sChangeAndError , ARGUMENTS.field , ARGUMENTS.errorMessage)# />	 
		
	</cffunction>
	<!---Checks for empty fields and removes spaces in inputs--->
	<cffunction name = "checkEmptyAndSpaces" access = "remote" returntype = "boolean" returnformat = "JSON" output = "true" hint = "removes spaces and checks empty inputs">
		<cfargument type = "string" required = "true" name = "fieldValue" hint = "field value to check for ">
		<cfargument type = "string" required = "false" name = "field" hint = "field value">	
	
		<!---Clears the Structure(ModifiedValue , errorMessage)--->
		<cfset StructClear(VARIABLES.schangeAndError)>
		<cfset LOCAL.modifiedValue = ""/>
		<cfloop from = 1 to = #Len(ARGUMENTS.fieldValue)# step = 1 index = "i">
			<cfset LOCAL.unicode = #Asc(mid(ARGUMENTS.fieldValue , i , 1))# />
			<cfset LOCAL.letter = #mid(ARGUMENTS.fieldValue , i , 1)# />
				
			<cfif LOCAL.unicode NEQ 32 AND LOCAL.unicode NEQ 9>
				<cfset LOCAL.modifiedValue = #LOCAL.modifiedValue# & LOCAL.letter />
				
			</cfif>
			
		</cfloop>
		
		
		<cfset StructInsert(VARIABLES.sChangeAndError , ARGUMENTS.field&"="&LOCAL.modifiedValue , "") />
		<cfif #Len(LOCAL.modifiedValue)# EQ 0>
			<cfset generateErrors(ARGUMENTS.field&"="&LOCAL.modifiedValue) />
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>	
		
	</cffunction>
	<!---Function validates name and city fields--->
	<cffunction name = "validateName" access = "remote" returntype = "Struct" returnformat = "JSON" hint = "chacks for errors in name and city fields">
	<cfargument type = "string" required = "true" name = "fieldValue" hint = "field value for name and city"/>
	<cfargument type = "string" required = "false" name = "field" hint = "field value">	
		<cfif NOT checkEmptyAndSpaces(ARGUMENTS.fieldValue , ARGUMENTS.field)>
			<cfset counter = 0>
			<cfloop from = 1 to = #Len(ARGUMENTS.fieldValue)# step = 1 index = "i">
				<cfset unicode = #Asc(mid(ARGUMENTS.fieldValue , i , i))# />
					<cfif (unicode GTE 65 AND unicode LTE 90) OR (unicode GTE 97 AND unicode LTE 122) >
						<cfset counter = "#counter#" + 1 >
					</cfif>
			</cfloop>
			<cfif #counter# NEQ #Len(ARGUMENTS.fieldValue)#>
				<cfset #generateErrors(ARGUMENTS.field&"="&ARGUMENTS.fieldValue , "Name field dosen't contain letters")# />
			</cfif>	
		</cfif>
		<cfreturn VARIABLES.sChangeAndError/>
	</cffunction>
	<!---Function validates email fields--->
	<cffunction name = "validateMail" access = "remote" output = "true" returntype = "struct" returnformat = "JSON" hint = "checks for errors in email address">
	<cfargument type = "string" required = "true" name = "fieldValue" hint = "field value for email"/>
	<cfargument type = "string" required = "false" name = "field" hint = "field value">	
	
		<cfif NOT checkEmptyAndSpaces(ARGUMENTS.fieldValue , ARGUMENTS.field) >
			<cfif NOT isValid("email" , ARGUMENTS.fieldValue)>
				<cfset generateErrors(ARGUMENTS.field&"="&ARGUMENTS.fieldValue  , "Email address is not valid")>
			</cfif>
		</cfif>
		<cfreturn VARIABLES.sChangeAndError>
	</cffunction>
	
	<!---Function valdates phone number fields--->
	
	<cffunction name = "validateNumber" access = "remote" output = "false" returntype = "struct" returnformat = "JSON" hint = "checks for errors in phone numbers">
	<cfargument type = "string" required = "true" name = "fieldValue" hint = "field value for phone number fields"/>
	<cfargument type = "string" required = "false" name = "field" hint = "field value">	
	
		<cfif NOT checkEmptyAndSpaces(ARGUMENTS.fieldValue , ARGUMENTS.field) >
			<cfif NOT isValid("telephone" , ARGUMENTS.fieldValue)>
				<cfset generateErrors(ARGUMENTS.field&"="&ARGUMENTS.fieldValue , "Phone number is not valid ")>
			</cfif>
		</cfif>
		<cfreturn VARIABLES.sChangeAndError>
	</cffunction>
	
	<!---Function validates passwords--->
	<cffunction name = "validatePass" access = "remote" output = "false" returntype = "Struct" returnformat = "JSON" hint = "chcks for equality of passwords">
		<cfargument type = "string" required = "true" name = "fieldValue" hint = "field value for passwords"/>
		<cfargument type = "string" required = "true" name = "fieldValueT" hint = "field value for password"/>
		<cfargument type = "string" required = "false" name = "field" hint = "field value">	
		
		<cfif NOT checkEmptyAndSpaces(ARGUMENTS.fieldValue , ARGUMENTS.field) >
			<cfif ARGUMENTS.fieldValue NEQ ARGUMENTS.fieldValueT>
				<cfset #generateErrors(ARGUMENTS.field&"="&ARGUMENTS.fieldValue , "Passwords do not match")#>
			</cfif>
		</cfif>
		<cfreturn VARIABLES.sChangeAndError>
	</cffunction>
</cfcomponent>