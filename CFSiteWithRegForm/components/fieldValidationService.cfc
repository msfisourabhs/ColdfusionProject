﻿<cfcomponent output="true" >
	<!---Intialise the Structure(ModifiedValue,ErrorMessage)--->
	<cfset sChangeAndError = {} />
	
	<!---Generates Erros and populates the structure errorMessages--->
	<cffunction name="generateErrors" access="private" output="true" returntype="void" >
		<cfargument type="string" name="fieldValue" required="true" >
		<cfargument type="string" name="errorMessage" required="false" default="This field cannot be empty">
		<cfset #StructUpdate(sChangeAndError,arguments.fieldValue,errorMessage)# />	 
		
	</cffunction>
	<!---Checks for empty fields and removes spaces in inputs--->
	<cffunction name="checkEmptyAndSpaces" access="private" returntype="string" output="true" >
		<cfargument type="string" required="true" name="fieldValue">
		
		<!---Clears the Structure(ModifiedValue,errorMessage)--->
		<cfset StructClear(schangeAndError)>
		<cfset temp = ""/>
		<cfloop from=1 to=#Len(fieldValue)# step=1 index="i">
			<cfset unicode = #Asc(mid(fieldValue,i,1))# />
			<cfset letter = #mid(fieldValue,i,1)# />
				
			<cfif unicode NEQ 32 AND unicode NEQ 9>
				<cfset temp = #temp# & letter />
				
			</cfif>
			
		</cfloop>
		
		
		<cfset StructInsert(sChangeAndError,temp,"") />
		<cfif #Len(temp)# EQ 0>
			<cfset generateErrors(temp) />
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>	
		
	</cffunction>
	<!---Function validates name and city fields--->
	<cffunction name="validateName" access="remote" returntype="Struct" returnformat="JSON" >
	<cfargument type="string" required="true" name="fieldValue" />
		
		<cfif NOT checkEmptyAndSpaces(fieldValue)>
			<cfset counter = 0>
			<cfloop from=1 to=#Len(fieldValue)# step=1 index="i">
				<cfset unicode = #Asc(mid(fieldValue,i,i))# />
					<cfif (unicode GTE 65 AND unicode LTE 90) OR (unicode GTE 97 AND unicode LTE 122) >
						<cfset counter = "#counter#" + 1 >
					</cfif>
			</cfloop>
			<cfif #counter# NEQ #Len(fieldValue)#>
				<cfset #generateErrors(fieldValue,"Name field dosen't contain letters")# />
			</cfif>	
		</cfif>
		<cfreturn sChangeAndError/>
	</cffunction>
	<!---Function validates email fields--->
	<cffunction name="validateMail" access="remote" output="true" returntype="struct" >
	<cfargument type="string" required="true" name="fieldValue" />
	
		<cfif NOT checkEmptyAndSpaces(fieldValue) >
			<cfif NOT isValid("email",fieldValue)>
				<cfset generateErrors(fieldValue ,"Email address is not valid")>
			</cfif>
		</cfif>
		<cfreturn sChangeAndError>
	</cffunction>
	
	<!---Function valdates phone number fields--->
	
	<cffunction name="validateNumber" access="remote" output="false" returntype="struct" returnformat="JSON" >
	<cfargument type="string" required="true" name="fieldValue" />
	
		<cfif NOT checkEmptyAndSpaces(fieldValue) >
			<cfif NOT isValid("telephone",fieldValue)>
				<cfset generateErrors(fieldValue,"Phone number is not valid ")>
			</cfif>
		</cfif>
		<cfreturn sChangeAndError>
	</cffunction>
	
	<!---Function validates passwords--->
	<cffunction name="validatePass" access="remote" output="false" returntype="Struct" returnformat="">
		<cfargument type="string" required="true" name="fieldValue" />
		<cfargument type="string" required="true" name="fieldValueT" />
		<cfif NOT checkEmptyAndSpaces(fieldValue) >
			<cfif fieldValue NEQ fieldValueT>
				<cfset #generateErrors(fieldValue,"Passwords do not match")#>
			</cfif>
		</cfif>
		<cfreturn sChangeAndError>
	</cffunction>

</cfcomponent>